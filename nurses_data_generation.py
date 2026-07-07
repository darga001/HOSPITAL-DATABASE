from faker import Faker
import pandas as pd
import random
import math

fake = Faker()

departments = [
    {"name": "Emergency Room", "occupied": 120},
    {"name": "Gastroenterology", "occupied": 28},
    {"name": "Rheumatology", "occupied": 28},
    {"name": "Cardiology", "occupied": 25},
    {"name": "Obstetrics & Maternity", "occupied": 25},
    {"name": "Pediatrics", "occupied": 25},
    {"name": "Reproductive Medicine", "occupied": 25},
    {"name": "Intensive Care Unit", "occupied": 21},
    {"name": "Neurology", "occupied": 21},
    {"name": "Oncology", "occupied": 21},
    {"name": "Psychiatry", "occupied": 21},
    {"name": "Endocrinology", "occupied": 14},
    {"name": "Pulmonology", "occupied": 14},
    {"name": "Urology", "occupied": 14},
    {"name": "Neuroskeletal", "occupied": 13},
    {"name": "Orthopedics", "occupied": 13},
    {"name": "Dermatology", "occupied": 11},
    {"name": "Immunology", "occupied": 11},
    {"name": "Hematology", "occupied": 7},
    {"name": "Medical Genetics", "occupied": 7},
    {"name": "Ophthalmology", "occupied": 7},
    {"name": "Imaging", "occupied": 5},
    {"name": "Laboratory Services", "occupied": 2},
]

department_meta_by_name = {
    "Cardiology": {"department_id": 1, "wing_id": 3},
    "Dermatology": {"department_id": 2, "wing_id": 3},
    "Endocrinology": {"department_id": 3, "wing_id": 2},
    "Urology": {"department_id": 4, "wing_id": 2},
    "Reproductive Medicine": {"department_id": 5, "wing_id": 5},
    "Hematology": {"department_id": 6, "wing_id": 2},
    "Immunology": {"department_id": 7, "wing_id": 2},
    "Psychiatry": {"department_id": 8, "wing_id": 7},
    "Medical Genetics": {"department_id": 9, "wing_id": 2},
    "Neuroskeletal": {"department_id": 10, "wing_id": 6},
    "Orthopedics": {"department_id": 11, "wing_id": 6},
    "Rheumatology": {"department_id": 12, "wing_id": 3},
    "Neurology": {"department_id": 13, "wing_id": 3},
    "Oncology": {"department_id": 14, "wing_id": 2},
    "Ophthalmology": {"department_id": 15, "wing_id": 3},
    "Pulmonology": {"department_id": 16, "wing_id": 3},
    "Gastroenterology": {"department_id": 17, "wing_id": 2},
    "Emergency Room": {"department_id": 18, "wing_id": 1},
    "Intensive Care Unit": {"department_id": 19, "wing_id": 1},
    "Pediatrics": {"department_id": 20, "wing_id": 5},
    "Obstetrics & Maternity": {"department_id": 21, "wing_id": 5},
    "Billing": {"department_id": 22, "wing_id": 4},
    "Pharmacy": {"department_id": 23, "wing_id": 6},
    "Operations": {"department_id": 24, "wing_id": 4},
    "Imaging": {"department_id": 25, "wing_id": 6},
    "Laboratory Services": {"department_id": 26, "wing_id": 6},
}

def get_ratio(dept_name):
    if "Emergency" in dept_name:
        return 4
    elif "Intensive" in dept_name:
        return 2
    elif any(x in dept_name for x in ["Pediatric", "Maternity", "Reproductive", "Cardiology"]):
        return 4
    elif any(x in dept_name for x in ["Dermatology", "Immunology"]):
        return 6
    elif "Imaging" in dept_name:
        return 8
    elif "Laboratory" in dept_name:
        return 2
    else:
        return 5

def calculate_nurses(occupied, ratio):
    nurses_per_shift = math.ceil(occupied / ratio)
    total_nurses = math.ceil(nurses_per_shift * 3 * 1.3)
    return total_nurses

nurses = []
nurse_id = 1

for dept in departments:
    dept_name = dept["name"]
    occupied = dept["occupied"]
    ratio = get_ratio(dept_name)
    total_nurses = calculate_nurses(occupied, ratio)

    dept_meta = department_meta_by_name.get(dept_name)
    if not dept_meta:
        raise ValueError(f"Missing department_id/wing_id mapping for department: {dept_name}")

    day_count = round(total_nurses * 0.40)
    night_count = round(total_nurses * 0.40)
    rotating_count = total_nurses - day_count - night_count

    shift_pool = (
        ["Day"] * day_count +
        ["Night"] * night_count +
        ["Rotating"] * rotating_count
    )

    random.shuffle(shift_pool)

    for shift in shift_pool:
        gender = random.choice(["Male", "Female"])

        if gender == "Male":
            first_name = fake.first_name_male()
        else:
            first_name = fake.first_name_female()

        nurse = {
            "nurse_id": nurse_id,
            "nurse_name": first_name,
            "nurse_last_name": fake.last_name(),
            "date_of_birth": fake.date_of_birth(minimum_age=21, maximum_age=65),
            "gender": gender,
            "email": fake.email(),
            "phone_number": fake.phone_number(),
            "nurse_type": random.choice(["RN"] * 7 + ["LPN"] * 2 + ["CNA"]),
            "specialty": dept_name,
            "department_id": dept_meta["department_id"],
            "wing_id": dept_meta["wing_id"],
            "shift_type": shift,
            "employment_status_active": True,
            "vacation_status": random.choice([False] * 95 + [True] * 5),
            "salary": random.randint(55_000, 75_000),
        }

        nurses.append(nurse)
        nurse_id += 1

df = pd.DataFrame(nurses)
df.to_csv("nurses.csv", index=False)

print(df.head())
print(f"Total nurses generated: {len(df)}")
