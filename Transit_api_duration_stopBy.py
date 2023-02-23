import csv
import datetime
import json
import os
import pyproj
import requests
import pandas as pd


# Parameters for coordinate reference system (CRS)
crs = "+proj=lcc +lat_1=49 +lat_2=44 +lat_0=46.5 +lon_0=3 +x_0=700000 +y_0=6600000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs"



def add_new_row(file_name, row):
    with open(file_name, 'a', newline='') as write_obj:
        csv_writer = csv.writer(write_obj)
        csv_writer.writerow(row)


def lat_long_from_csv(file_name):

    # if our output not exist, we create it
    if not os.path.exists("data_final_car_20_02_2023.csv"):
        df = pd.DataFrame(columns=['lat_x', 'long_x', 'lat_y', 'long_y', 'duration', 'congestion'])
        df.to_csv('data_final_car_20_02_2023.csv', index=False)

    # we open our csv file
    with open(file_name, 'r') as fcsv:
        reader = csv.reader(fcsv)

        # we skip the header
        header = next(reader)
        for row in reader:
            # we get the lat and long from the csv file
            lat_x = float(row[0])
            long_x = float(row[1])
            lat_y = float(row[2])
            long_y = float(row[3])

            # we get the duration and the number of stop by from the api
            response = requests.get("http://localhost:8080/otp/routers/default/plan",
                                    params={"fromPlace": f"{lat_x}, {long_x}",
                                            "toPlace": f"{lat_y}, {long_y}",
                                            "time": "9pm",
                                            "date": "02-20-2023",
                                            "mode": "TRANSIT,WALK",
                                            "numItineraries": "1",
                                            "arriveBy": "false",
                                            "wheelchair": "false"})
            data = json.loads(response.text)
            total_wait = 0

            # if the api return a code 200 and if there is at least one itinerary
            if response.status_code == 200 and len(data["plan"]["itineraries"]) != 0:
                #print(data)
                print("code 200")

                # get itineraries and for each itinerary we get the duration and the number of stop by
                itineraries = data["plan"]["itineraries"]
                for itinerary in itineraries:
                    print("--------------------------")

                    # we get the duration
                    duration = itinerary['duration']
                    print(duration)

                    # we get the number of stop by
                    number_stop_by = len(itinerary["legs"])
                    total_wait += itinerary["waitingTime"]
                    print(number_stop_by)
            else:
                print("code 400")
                duration = 0
                number_stop_by = 0

            # we create a row with the lat and long and the duration and the number of stop by
            row = [lat_x, long_x, lat_y, long_y, duration, number_stop_by, total_wait]

            # we add the row to the csv file
            add_new_row("data_final_transit_20_02_2023.csv", row)
            print(row)


# test function
lat_long_from_api(48.88143, 2.38575, 48.84734, 2.30713)


# conversion function from xy to lat and long JOB of previous group
def xy_to_lat_lon(x, y, crs):
    # Define the source and destination CRS
    src_crs = pyproj.CRS.from_proj4(crs)
    dst_crs = pyproj.CRS.from_epsg(4326)  # WGS 84

    # Create a Transformer object to convert between the two CRS
    transformer = pyproj.Transformer.from_crs(src_crs, dst_crs)

    # Transform the x and y coordinates
    lon, lat = transformer.transform(x, y)
    print(crs, x, y, lat, lon)
    return lat, lon


# create a csv file with lat and long with conversion Polygone x and y to lat and long
def fill_csv_with_lat_lon(csv_file, crs):
    # if our output not exist, we create it
    if not os.path.exists("output_final_20_02_2023.csv"):
        df = pd.DataFrame(columns=['lat_x', 'long_x', 'lat_y', 'long_y'])
        df.to_csv('output_final_20_02_2023.csv', index=False)

    # we open our csv file
    df = pd.read_csv('output_final_20_02_2023.csv')
    with open(csv_file, 'r') as fcsv:

        # we skip the header
        reader = csv.reader(fcsv)
        header = next(reader)

        # we get the lat and long from the csv file
        for row in reader:
            x1 = float(row[0])
            y1 = float(row[1])
            x2 = float(row[2])
            y2 = float(row[3])

            # we convert the x and y to lat and long
            lat1, lon1 = xy_to_lat_lon(x1, y1, crs)
            lat2, lon2 = xy_to_lat_lon(x2, y2, crs)

            # we create a row with the lat and long
            new_row = {'lat_x': lon1, 'long_x': lat1, 'lat_y': lon2, 'long_y': lat2}

            # we add the row to the csv file
            df = df.append(new_row, ignore_index=True)

            # we save the csv file
            df.to_csv('output_final_20_02_2023.csv', index=False)


# test function
#fill_csv_with_lat_lon("demand_output.csv", crs)

#lat_long_from_csv("output_final_20_02_2023.csv")
