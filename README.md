# HOSPITAL-DATABASE
# Hospital Management Database
 
A normalized relational database modeling core hospital operations — patient admissions, clinical activity, staffing, and facility structure — built in PostgreSQL with synthetic data generation in Python.
 
**Status: In Progress.** Schema design and table creation are complete. Data population is ongoing (see [Current Status](#current-status) below).
 
## Overview
 
This project models a realistic hospital system as a portfolio-grade (not production-grade) database, designed to demonstrate relational schema design, normalization, and query writing against a non-trivial number of interrelated tables — rather than to serve as a deployable hospital system.
 
- **18 tables** across three schema domains (facility/staffing, patient/admissions, clinical activity)
- **37 foreign-key relationships** enforcing referential integrity across domains
- Deliberate scope decisions were made to keep the project focused: for example, billing is modeled only as a cost-signaling field, not a full billing/insurance subsystem, since claims adjudication is outside the scope of what this project demonstrates.
## Schema Domains
 
| Domain | Purpose |
|---|---|
| Facility & Staffing | Departments, staff roles, shifts, physical hospital structure |
| Patient & Admissions | Patient records, admissions, discharges, bed/room assignment |
| Clinical Activity | Diagnoses, procedures, treatments, clinical events tied to admissions |
 
## Tech Stack
 
- **Database:** PostgreSQL
- **Data generation:** Python (Faker)
- **Planned frontend:** Streamlit (hosted on Railway) — not yet built
## Data Population Approach
 
Table population is being handled through three parallel methods, reflecting the different data realism needs across the schema:
 
1. **Synthetic generation (Python/Faker):** used for high-volume, low-complexity tables (e.g., patients, staff) where realistic-looking but fabricated records are sufficient.
2. **Manual SQL inserts:** used for reference/lookup tables and smaller tables where exact, controlled values matter more than volume (e.g., departments, roles, procedure codes).
3. **Public dataset sourcing (Kaggle, other open datasets):** used for the highly relational, clinically-dependent tables where realistic *distributions* (e.g., diagnosis frequency, procedure-to-diagnosis relationships) matter more than fully synthetic data can provide.
