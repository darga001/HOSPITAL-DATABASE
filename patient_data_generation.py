from __future__ import annotations

from datetime import date
import random

from faker import Faker
import pandas as pd

fake = Faker()

NUMBER_OF_PATIENTS = 5500
OUTPUT_CSV_PATH = "patients.csv"

NATIONALITY_OTHER_POOL = [
    "Canadian",
    "Mexican",
    "Brazilian",
    "Argentine",
    "British",
    "German",
    "French",
    "Japanese",
]

BLOOD_TYPES = ["O+", "A+", "B+", "O-", "A-", "AB+", "B-", "AB-"]
BLOOD_TYPE_WEIGHTS = [0.37, 0.36, 0.08, 0.07, 0.06, 0.03, 0.02, 0.01]


def calculate_age(on_date: date, dob: date) -> int:
    years = on_date.year - dob.year
    had_birthday = (on_date.month, on_date.day) >= (dob.month, dob.day)
    return years if had_birthday else years - 1


def unique_email(used: set[str]) -> str:
    while True:
        value = fake.email()
        if value not in used:
            used.add(value)
            return value


def unique_phone_number(used: set[str]) -> str:
    while True:
        value = fake.phone_number()
        if value not in used:
            used.add(value)
            return value


def choose_nationality() -> str:
    if random.random() < 0.90:
        return "American"
    return random.choice(NATIONALITY_OTHER_POOL)


def choose_blood_type() -> str:
    return random.choices(BLOOD_TYPES, weights=BLOOD_TYPE_WEIGHTS, k=1)[0]


def choose_marital_status(age: int) -> bool:
    if age < 18:
        return False
    return random.random() < 0.5


def choose_born_in_hospital(age: int) -> bool:
    if age <= 5:
        return random.random() < 0.30
    return False


def main() -> None:
    today = date.today()
    used_emails: set[str] = set()
    used_phones: set[str] = set()

    patients: list[dict[str, object]] = []

    for patient_id in range(1, NUMBER_OF_PATIENTS + 1):
        gender = random.choice(["Male", "Female"])
        if gender == "Male":
            first_name = fake.first_name_male()
        else:
            first_name = fake.first_name_female()

        dob = fake.date_of_birth(minimum_age=0, maximum_age=90)
        age = calculate_age(today, dob)

        patients.append(
            {
                "patient_id": patient_id,
                "patient_name": first_name,
                "patient_last_name": fake.last_name(),
                "date_of_birth": dob,
                "gender": gender,
                "marital_status": choose_marital_status(age),
                "nationality": choose_nationality(),
                "blood_type": choose_blood_type(),
                "email": unique_email(used_emails),
                "phone_number": unique_phone_number(used_phones),
                "city": fake.city(),
                "zip": fake.zipcode(),
                "registration_date": fake.date_between(start_date="-5y", end_date="today"),
                "born_in_hospital": choose_born_in_hospital(age),
            }
        )

    df = pd.DataFrame(
        patients,
        columns=[
            "patient_id",
            "patient_name",
            "patient_last_name",
            "date_of_birth",
            "gender",
            "marital_status",
            "nationality",
            "blood_type",
            "email",
            "phone_number",
            "city",
            "zip_code",
            "registration_date",
            "born_in_hospital",
        ],
    )

    df.to_csv(OUTPUT_CSV_PATH, index=False)

    print(df.head())
    print(f"Wrote {len(df)} patients to {OUTPUT_CSV_PATH}")


if __name__ == "__main__":
    main()

