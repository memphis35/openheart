# OpenHeart

## A goal to achieve

Let's suppose we have a medical station, and we need to manage its several
busyness processes. This application particularly simplifies registration process, including picking
medical brigades, orderings and prioritizing requests, monitoring request statuses,
used resources and keeping the statistics. This DB schema is used for an application to automatize medical station work.

## Schema

![Database initial schema](./img/schema.png "Database schema")

## Documentation

| Table name        | Description                                                                                                                                                                                                              |
|-------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| brigade           | Daily working unit that contains two paramedics, driver and describes car info and unit specialization                                                                                                                   |
| brigade_people    | A set of employees of particular brigade                                                                                                                                                                                 |
| brigade_set       | A set of brigades that belongs to particular working unit.                                                                                                                                                               |
| car               | A list of available cars                                                                                                                                                                                                 |
| cause             | A list of symptoms and possible diagnosis with severities                                                                                                                                                                |
| consumed_material | History of consumed materials by brigades.                                                                                                                                                                               |
| department        | A list of available medical stations                                                                                                                                                                                     |
| employee          | A comprehensive list of employees who has a particular job (drivers, paramedics, doctors, operators, etc)                                                                                                                |
| material          | A list of drugs and other materials that can be used during assistance. It contains information about its name and type.                                                                                                 |
| position          | A list of existing employee positions.                                                                                                                                                                                   |
| patient_card      | Normally, it is just an electronic version of real card created by paramedic as a result of request handling. It contains information about patient, real severity of request, any information about provided assistance |
| request           | Kind of end-user's order to request a medical brigade to get some help (injury, decease, etc)                                                                                                                            |
| specialization    | A list of existing brigade specializations.                                                                                                                                                                              |
| status            | A list of request statuses                                                                                                                                                                                               |
| working_unit      | A unit that contain information about daily activity of medical station. It contains a set of brigades, working date and a senior doctor                                                                                 |

<br>

---

Pet project for RDBMS lessons at OTUS company
