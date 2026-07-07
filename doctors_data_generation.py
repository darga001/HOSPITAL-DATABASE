from faker import Faker
import pandas as pd
import random
import math

fake = Faker()

departments = [
    {"department_id": 1, "name": "Cardiology", "wing_id": 3, "offices": 12},
    {"department_id": 2, "name": "Dermatology", "wing_id": 3, "offices": 6},
    {"department_id": 3, "name": "Endocrinology", "wing_id": 2, "offices": 8},
    {"department_id": 4, "name": "Urology", "wing_id": 2, "offices": 8},
    {"department_id": 5, "name": "Reproductive Medicine", "wing_id": 5, "offices": 8},
    {"department_id": 6, "name": "Hematology", "wing_id": 2, "offices": 6},
    {"department_id": 7, "name": "Immunology", "wing_id": 2, "offices": 7},
    {"department_id": 8, "name": "Psychiatry", "wing_id": 7, "offices": 8},
    {"department_id": 9, "name": "Medical Genetics", "wing_id": 2, "offices": 6},
    {"department_id": 10, "name": "Neuroskeletal", "wing_id": 6, "offices": 6},
    {"department_id": 11, "name": "Orthopedics", "wing_id": 6, "offices": 8},
    {"department_id": 12, "name": "Rheumatology", "wing_id": 3, "offices": 7},
    {"department_id": 13, "name": "Neurology", "wing_id": 3, "offices": 10},
    {"department_id": 14, "name": "Oncology", "wing_id": 2, "offices": 12},
    {"department_id": 15, "name": "Ophthalmology", "wing_id": 3, "offices": 6},
    {"department_id": 16, "name": "Pulmonology", "wing_id": 3, "offices": 8},
    {"department_id": 17, "name": "Gastroenterology", "wing_id": 2, "offices": 10},
    {"department_id": 18, "name": "Emergency Room", "wing_id": 1, "offices": 12},
    {"department_id": 19, "name": "Intensive Care Unit", "wing_id": 1, "offices": 12},
    {"department_id": 20, "name": "Pediatrics", "wing_id": 5, "offices": 10},
    {"department_id": 21, "name": "Obstetrics & Maternity", "wing_id": 5, "offices": 10},
    {"department_id": 22, "name": "Billing", "wing_id": 4, "offices": 8},
    {"department_id": 23, "name": "Pharmacy", "wing_id": 6, "offices": 5},
    {"department_id": 24, "name": "Operations", "wing_id": 4, "offices": 10},
    {"department_id": 25, "name": "Imaging", "wing_id": 6, "offices": 8},
    {"department_id": 26, "name": "Laboratory Services", "wing_id": 6, "offices": 6},
]

specialties_by_department = {
    "Emergency Room": ["Emergency Medicine"],
    "Intensive Care Unit": ["Critical Care Medicine", "Intensivist"],
    "Cardiology": ["Cardiology", "Interventional Cardiology"],
    "Dermatology": ["Dermatology"],
    "Gastroenterology": ["Gastroenterology"],
    "Endocrinology": ["Endocrinology"],
    "Urology": ["Urology"],
    "Reproductive Medicine": ["Urology"],
    "Oncology": ["Oncology", "Medical Oncology"],
    "Hematology": ["Hematology", "Hematology-Oncology"],
    "Medical Genetics": ["Medical Genetics"],
    "Immunology": ["Immunology"],
    "Neurology": ["Neurology"],
    "Pulmonology": ["Pulmonology"],
    "Rheumatology": ["Rheumatology"],
    "Ophthalmology": ["Ophthalmology"],
    "Pediatrics": ["Pediatrics"],
    "Obstetrics & Maternity": ["Obstetrics & Gynecology"],
}

default_salary_range = (80_000, 150_000)

def get_ratio(dept_name):
    if dept_name == "Emergency Room":
        return 2.5
    return 0.75
    
def doctor_calculation (offices, ratio):
    doctors_per_dept = math.ceil (offices * ratio)
    total_doctors = doctors_per_dept
    return total_doctors

doctors = []
doctor_id = 1
license_numbers = set()

for dept in departments:
    dept_name = dept["name"]
    department_id = dept["department_id"]
    wing_id = dept["wing_id"]
    offices = dept["offices"]
    ratio = get_ratio(dept_name)
    total_doctors = doctor_calculation (offices, ratio)

    day_count = round(total_doctors * 0.40)
    night_count = round(total_doctors * 0.40)
    rotating_count = total_doctors - day_count - night_count

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

        specialty_choice_pool = specialties_by_department.get(dept_name, [dept_name])
        chosen_specialty = random.choice(specialty_choice_pool)

        specialty = chosen_specialty
        subspecialty = None
        if dept_name == "Cardiology" and chosen_specialty == "Interventional Cardiology":
            specialty = "Cardiology"
            subspecialty = "Interventional Cardiology"
        elif dept_name == "Oncology" and chosen_specialty == "Medical Oncology":
            specialty = "Oncology"
            subspecialty = "Medical Oncology"
        elif dept_name == "Hematology" and chosen_specialty == "Hematology-Oncology":
            specialty = "Hematology"
            subspecialty = "Hematology-Oncology"

        license_number = None
        while not license_number or license_number in license_numbers:
            license_number = f"MD-{random.randint(10000000, 99999999)}"
        license_numbers.add(license_number)

        min_salary, max_salary = default_salary_range
        salary = random.randint(min_salary, max_salary)

        doctor = {
            "doctor_id": doctor_id,
            "doctor_name": first_name,
            "doctor_last_name": fake.last_name(),
            "date_of_birth": fake.date_of_birth(minimum_age=27, maximum_age=70),
            "gender": gender,
            "email": fake.email(),
            "phone_number": fake.phone_number(),
            "license_number": license_number,
            "specialty": specialty,
            "sub_specialty": subspecialty,
            "department_id": department_id,
            "wing_id": wing_id,
            "shift_type": shift,
            "employment_status_active": random.choice([True] * 9 + [False]),
            "vacation_status": False,
            "salary": salary,
        }

        doctors.append(doctor)
        doctor_id += 1

df = pd.DataFrame(doctors)
df.to_csv("doctors.csv", index=False)

print(df.head())
print(f"Total doctors generated: {len(df)}")
