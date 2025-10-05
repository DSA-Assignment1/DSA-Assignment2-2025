
# Smart Public Transport Ticketing System  
### Distributed Systems and Applications (DSA612S) — Group Project  

---

## Overview
The **Smart Public Transport Ticketing System** is a distributed, event-driven platform that modernises how passengers buy, manage, and validate tickets for buses and trains.  
It replaces traditional paper-based systems with a **microservices-based architecture** built in **Ballerina**, using **Kafka** for event communication and **MySQL** for persistent storage.

This project simulates a real-world public transport ticketing platform designed for scalability, reliability, and asynchronous communication.

---

## Objectives

By completing this project, we demonstrate our ability to:
- Design and implement **microservices** with clear boundaries and APIs.  
- Use **Kafka** for event-driven communication between services.  
- Persist data in **MySQL** and reason about consistency.  
- Containerise and orchestrate all components using **Docker Compose**.  
- Apply testing, monitoring, and fault-tolerance strategies to distributed systems.

---

## System Architecture

The system is composed of six microservices communicating asynchronously through **Kafka topics** and persisting data in a **shared MySQL database**.

```

+----------------+        +----------------+        +----------------+
| Passenger      |        | Ticketing      |        | Payment        |
| Service        | -----> | Service        | -----> | Service        |
| (HTTP + Kafka) |        | (Kafka + DB)   |        | (HTTP + Kafka) |
+----------------+        +----------------+        +----------------+
|                           |                       |
v                           v                       v
+----------------+        +----------------+        +----------------+
| Notification   | <----- | Transport      | <----- | Admin          |
| Service        |        | Service        |        | Service        |
| (Kafka + DB)   |        | (HTTP + Kafka) |        | (HTTP + Kafka) |
+----------------+        +----------------+        +----------------+
|
v
+----------------+
|  MySQL (DB)    |
|  Kafka Broker  |
+----------------+

```

---

## Technologies Used

| Component | Technology |
|------------|------------|
| Language / Framework | [Ballerina](https://ballerina.io/) |
| Event Communication | [Apache Kafka](https://kafka.apache.org/) |
| Database | MySQL 8.0 |
| Containerisation | Docker |
| Orchestration | Docker Compose |
| Version Control | Git / GitHub |

---

## Project Structure

```

SmartTicketingSystem/
│
├── docker-compose.yml
├── init.sql
├── README.md
│
├── passenger_service/
│   ├── main.bal
│   ├── Ballerina.toml
│   ├── Config.toml
│   ├── Dockerfile
│
├── ticketing_service/
│   ├── main.bal
│   ├── Dockerfile
│
├── payment_service/
│   ├── main.bal
│   ├── Dockerfile
│
├── transport_service/
│   ├── main.bal
│   ├── Dockerfile
│
├── notification_service/
│   ├── main.bal
│   ├── Dockerfile
│
└── admin_service/
├── main.bal
├── Dockerfile

````

---

## Database Schema (MySQL)

The `init.sql` file creates and initializes the database schema:

- **users** – stores passenger and admin accounts  
- **routes / trips** – managed by Transport/Admin services  
- **tickets** – created and updated by Ticketing service  
- **payments** – handled by Payment service  
- **notifications** – stored by Notification service  

---

## Kafka Topics

| Topic | Produced By | Consumed By | Description |
|-------|--------------|-------------|--------------|
| `ticket.requests` | Passenger Service | Ticketing Service | Passenger requests a ticket |
| `payments.processed` | Payment Service | Ticketing Service | Payment confirmed or failed |
| `ticket.status` | Ticketing Service | Notification Service | Status updates (CREATED, PAID, VALIDATED, EXPIRED) |
| `schedule.updates` | Transport/Admin Service | Notification Service | Delays or cancellations |
| `passenger.registered` | Passenger Service | Notification/Ticketing | New user registration event |

---

## Service Responsibilities

| Service | Description | Port |
|----------|--------------|------|
| **Passenger Service** | Handles passenger registration, login, and ticket requests. Publishes events to Kafka. | 8081 |
| **Ticketing Service** | Manages ticket creation, payment confirmation, and lifecycle transitions. | 8082 |
| **Payment Service** | Simulates payments, updates payment records, and publishes confirmation events. | 8083 |
| **Transport Service** | Manages routes and trip scheduling. Publishes updates to Kafka. | 8084 |
| **Notification Service** | Consumes ticket and schedule updates to alert passengers. | 8085 |
| **Admin Service** | Allows administrators to create routes, monitor usage, and publish disruptions. | 8086 |

---

## Running the System

### Prerequisites
- [Docker Desktop](https://www.docker.com/)
- [Ballerina 2201.9.0](https://ballerina.io/downloads/)
- Optional: [MySQL Workbench](https://dev.mysql.com/downloads/workbench/)

---

### 1. Build Containers

```bash
docker compose build --no-cache
````

---

### 2. Start the System

```bash
docker compose up
```

All services (MySQL, Kafka, and six microservices) will start automatically.

---

### 3. Test the API Endpoints

#### Register a Passenger

```bash
curl -X POST http://localhost:8081/passengers/register \
-H "Content-Type: application/json" \
-d '{"username":"kiki","email":"kiki@example.com","password":"secret","userRole":"passenger"}'
```

#### Request a Ticket

```bash
curl -X POST http://localhost:8081/passengers/tickets \
-H "Content-Type: application/json" \
-d '{"user_id":1,"trip_id":2,"price":25.00,"type":"single"}'
```

#### Make a Payment

```bash
curl -X POST http://localhost:8083/payments \
-H "Content-Type: application/json" \
-d '{"ticketCode":"T20251004","amount":25.00}'
```

#### View Notifications

```bash
curl http://localhost:8085/notifications/1
```

---

## Development Workflow

1. Edit service logic in each `<service>/main.bal` file.
2. Use `bal build` to compile and test locally.
3. Commit changes:

   ```bash
   git add .
   git commit -m "Updated ticketing service logic"
   git push origin main
   ```
4. Use `docker compose up --build` to rebuild all services.



---

## Contributors/Team Members

|      Names       | Student Number|
| ----------------:|--------------:|
| Hermaine Kharugas| 224001833     |
| Rafael Timotheus | 222059710     |
| Nestor Shikulo   | 222059702     |
| El-Salvador Pashita| 223057606   |
| Uushona Selma    | 222081368     |
| Absalom Elindi   | 223077518     |


