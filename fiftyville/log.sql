-- Keep a log of any SQL queries you execute as you solve the mystery.
-- july 28 2021 on took place on Humphrey Street.
SELECT description
FROM crime_scene_reports
Where day=28 AND month=7 AND year=2021 AND street = "Humphrey Street";

--from description we can follow new path
SELECT transcript
FROM interviews
WHERE day=28 AND month=7 AND year=2021 AND transcript LIKE "%bakery%";

--Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away.
--If you have security footage from the bakery parking lot,
--you might want to look for cars that left the parking lot in that time frame.
SELECT name
FROM people
JOIN bakery_security_logs ON people.license_plate = bakery_security_logs.license_plate
WHERE year=2021 AND month=7 AND day=28 AND hour=10 AND minute >= 15 AND minute <= 25 AND activity = "exit";

--possible thief names: (Vanessa, BRUCE, Barry, Luca, Sofia, Iman, Diana, Kelsey)




--I don't know the thief's name, but it was someone I recognized. Earlier this morning,
--before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.
--new suspect are (Luca,Kenny,Taylor,Bruce,Brooke,Iman,Benista,Diana)

--We have more recurrin suspect. (Luca, Bruce,iman,Diana)

SELECT DISTINCT name
FROM people
JOIN bank_accounts ON people.id = bank_accounts.person_id
JOIN atm_transactions ON bank_accounts.account_number = atm_transactions.account_number
WHERE day=28 AND year=2021 AND month=7 AND transaction_type="withdraw" AND atm_location = "Leggett Street";


--As the thief was leaving the bakery, they called someone who talked to them for less than a minute.
--In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
--The thief then asked the person on the other end of the phone to purchase the flight ticket.
--check to see who was had the flight
SELECT name
FROM people
JOIN passengers ON people.passport_number=passengers.passport_number
WHERE flight_id = (
    SELECT id
    FROM flights
    WHERE day=29 AND month=7 AND year=2021
    ORDER BY hour,minute
    LIMIT 1);

 --New possible thief
 --Doris,Sofia,Bruce,Edward,Kelsey,Taylor,Kenny,Luca
 --found in both (Bruce,Luca)(so these dude might be the one)
 SELECT DISTINCT name
FROM people
JOIN phone_calls ON people.phone_number = phone_calls.caller
WHERE day=28 AND month=7 AND year=2021 AND duration < 60;

   --new suspect are sofia,Kelsey,Bruce,Taylor,Diana,Carina,Kenny,Benista
   --Bruce
SELECT city
FROM airports
WHERE id = (
    SELECT destination_airport_id
    FROM flights
    WHERE year=2021 AND month=7 AND day=29
    ORDER BY hour,minute
    LIMIT 1);
   --Escaped to NYC

   SELECT name
FROM people
JOIN phone_calls ON people.phone_number = phone_calls.receiver
WHERE day=28 AND month=7 AND year=2021 AND duration<60 AND caller = (
    SELECT phone_number
    FROM people
    WHERE name="Bruce");

   --Accomplice is ROBIN