import csv
import datetime as datetime
import json
import os

import googlemaps
import pandas as pd
import requests
from googlemaps.directions import directions

# Google map api keys
gmaps = googlemaps.Client(key='AIzaSyBv9OtDRp8LtBvNQUkuNyrhXjJf0IP-PvU')


def add_new_row(file_name, row):
    with open(file_name, 'a+', newline='') as write_obj:
        csv_writer = csv.writer(write_obj)
        csv_writer.writerow(row)


def lat_long_from_csv(file_name):
    # if our output not exist, we create it
    if not os.path.exists("data_final_car_20_02_2023.csv"):
        df = pd.DataFrame(columns=['lat_x', 'long_x', 'lat_y', 'long_y', 'duration', 'conjestion'])
        df.to_csv('data_final_car_20_02_2023.csv', index=False)

    # we open our csv file
    with open(file_name, 'r') as fcsv:
        reader = csv.reader(fcsv)

        # we skip the header
        header = next(reader)
        for row in reader:
            lat_x = float(row[0])
            long_x = float(row[1])
            lat_y = float(row[2])
            long_y = float(row[3])

            # we get the duration and the number of stop by from the api
            response = requests.get("http://localhost:8080/otp/routers/default/plan",
                                    params={"fromPlace": f"{lat_x}, {long_x}",
                                            "toPlace": f"{lat_y}, {long_y}",
                                            "time": "8.30pm",
                                            "date": "02-20-2023",
                                            "mode": "CAR"})
            # save the response in a json format
            data = json.loads(response.text)

            # select date and time for the request to the Google api
            datet_time = datetime.datetime(2023, 3, 17, 8, 30, 0)

            # get the duration with traffic from the Google api with congestion
            directions_result = directions(gmaps,
                                           origin=f"{lat_x}, {long_x}",
                                           destination=f"{lat_y}, {long_y}",
                                           mode="driving",
                                           departure_time=datet_time,
                                           traffic_model="pessimistic"  # "best_guess", "optimistic", "pessimistic"
                                           )
            # get the duration in congestion traffic.
            congestion = directions_result[0]['legs'][0]['duration_in_traffic']['value']

            # if the response is 200 and the itinerary is not empty
            if response.status_code == 200 and len(data["plan"]["itineraries"]) != 0:
                # print(data)
                print("code 200")

                # get the duration of the itinerary
                itinerary = data["plan"]["itineraries"][0]
                print("--------------------------")
                duration = itinerary['duration']

                # we create a new row with the duration and the number of stop by
                row = [lat_x, long_x, lat_y, long_y, duration, congestion]

                # we add the new row to the csv file
                add_new_row("data_final_car_20_02_2023.csv", row)
                print(row)
            else:
                print("code 400")


# we call the function
lat_long_from_csv("output_final_20_02_2023.csv")
