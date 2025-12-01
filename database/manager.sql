CREATE DATABASE  IF NOT EXISTS `manager` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `manager`;
-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: manager
-- ------------------------------------------------------
-- Server version	8.0.43

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `buildings`
--

DROP TABLE IF EXISTS `buildings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buildings` (
  `building_id` int NOT NULL AUTO_INCREMENT,
  `building_name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `total_floors` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`building_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buildings`
--

LOCK TABLES `buildings` WRITE;
/*!40000 ALTER TABLE `buildings` DISABLE KEYS */;
INSERT INTO `buildings` VALUES (1,'Dormitory A','UC Main Campus - Building A',5,1,'2025-11-28 18:33:44','2025-11-28 18:33:44'),(2,'Dormitory B','UC Main Campus - Building B',4,1,'2025-11-28 18:33:44','2025-11-28 18:33:44');
/*!40000 ALTER TABLE `buildings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `assignment_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `payment_method` varchar(30) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `payment_period_start` date DEFAULT NULL,
  `payment_period_end` date DEFAULT NULL,
  `receipt_number` varchar(100) DEFAULT NULL,
  `recorded_by` int DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `receipt_number` (`receipt_number`),
  KEY `fk_payment_user` (`user_id`),
  KEY `fk_payment_assignment` (`assignment_id`),
  KEY `fk_payment_recorder` (`recorded_by`),
  CONSTRAINT `fk_payment_assignment` FOREIGN KEY (`assignment_id`) REFERENCES `room_assignments` (`assignment_id`),
  CONSTRAINT `fk_payment_recorder` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_payment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (4,3,1,5000.00,'cash','2025-01-05','2025-01-01','2025-01-31','RCPT-1001',1,'January payment','2025-11-28 18:54:20','2025-11-28 18:54:20'),(5,4,2,3500.00,'bank_transfer','2025-02-03','2025-02-01','2025-02-28','RCPT-1002',2,'February payment','2025-11-28 18:54:20','2025-11-28 18:54:20'),(6,5,3,3500.00,'cash','2025-01-20','2025-01-15','2025-02-15','RCPT-1003',1,'Initial payment','2025-11-28 18:54:20','2025-11-28 18:54:20');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `generated_by` int DEFAULT NULL,
  `report_type` varchar(50) DEFAULT NULL,
  `report_title` varchar(200) DEFAULT NULL,
  `file_path` varchar(500) DEFAULT NULL,
  `generated_on` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`report_id`),
  KEY `fk_report_user` (`generated_by`),
  CONSTRAINT `fk_report_user` FOREIGN KEY (`generated_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,1,'occupancy','January Occupancy Report','/reports/occupancy_jan2025.pdf','2025-11-28 19:33:54'),(2,2,'payments','February Payment Summary','/reports/payment_feb2025.pdf','2025-11-28 19:33:54'),(3,1,'user_summary','Active User List 2025','/reports/users_2025.pdf','2025-11-28 19:33:54');
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_assignments`
--

DROP TABLE IF EXISTS `room_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_assignments` (
  `assignment_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `room_id` int DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `monthly_rate` decimal(10,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `assigned_by` int DEFAULT NULL,
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`assignment_id`),
  KEY `fk_assignment_user` (`user_id`),
  KEY `fk_assignment_room` (`room_id`),
  KEY `fk_assignment_admin` (`assigned_by`),
  CONSTRAINT `fk_assignment_admin` FOREIGN KEY (`assigned_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `fk_assignment_room` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`room_id`),
  CONSTRAINT `fk_assignment_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_assignments`
--

LOCK TABLES `room_assignments` WRITE;
/*!40000 ALTER TABLE `room_assignments` DISABLE KEYS */;
INSERT INTO `room_assignments` VALUES (1,3,1,'2025-01-01','2025-12-31',5000.00,'active',1,'Assigned upon enrollment','2025-11-28 18:54:20','2025-11-28 18:54:20'),(2,4,2,'2025-02-01','2025-12-31',3500.00,'active',2,'Requested by student','2025-11-28 18:54:20','2025-11-28 18:54:20'),(3,5,4,'2025-01-15','2025-12-31',3500.00,'active',1,'Transferred from previous room','2025-11-28 18:54:20','2025-11-28 18:54:20');
/*!40000 ALTER TABLE `room_assignments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `type_id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `base_rate` decimal(10,2) NOT NULL,
  `capacity` int NOT NULL,
  `description` text,
  `features` text,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,'Single',5000.00,1,'Single occupancy room','Bed, Desk, Cabinet',1,'2025-11-28 18:33:59','2025-11-28 18:33:59'),(2,'Double',3500.00,2,'Two-bed room shared by two students','2 Beds, Cabinets, Study Table',1,'2025-11-28 18:33:59','2025-11-28 18:33:59'),(3,'Suite',8000.00,2,'Premium room with comfort room','CR, Aircon, 2 Beds, Table',1,'2025-11-28 18:33:59','2025-11-28 18:33:59');
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `room_id` int NOT NULL AUTO_INCREMENT,
  `building_id` int DEFAULT NULL,
  `type_id` int DEFAULT NULL,
  `room_number` varchar(50) NOT NULL,
  `floor_number` int DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT '1',
  `notes` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`room_id`),
  KEY `fk_rooms_building` (`building_id`),
  KEY `fk_rooms_type` (`type_id`),
  CONSTRAINT `fk_rooms_building` FOREIGN KEY (`building_id`) REFERENCES `buildings` (`building_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_rooms_type` FOREIGN KEY (`type_id`) REFERENCES `room_types` (`type_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,1,1,'A101',1,1,'Newly renovated','2025-11-28 18:48:18','2025-11-28 18:48:18'),(2,1,2,'A102',1,1,'Good ventilation','2025-11-28 18:48:18','2025-11-28 18:48:18'),(3,1,3,'A201',2,1,'Premium suite room','2025-11-28 18:48:18','2025-11-28 18:48:18'),(4,2,2,'B101',1,1,'Shared room','2025-11-28 18:48:18','2025-11-28 18:48:18'),(5,2,1,'B201',2,1,'Single room available','2025-11-28 18:48:18','2025-11-28 18:48:18');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(10) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin1','hashedpassword1','admin','Aaron Paul','Vallega','admin1@uc.edu.ph','09123456789','1990-05-20',1,'2025-11-28 18:52:04','2025-11-28 18:52:04'),(2,'admin2','hashedpassword2','admin','Maria','Lopez','admin2@uc.edu.ph','09129876543','1987-09-15',1,'2025-11-28 18:52:04','2025-11-28 18:52:04'),(3,'stud001','hashedpass3','student','John','Santos','john.santos@uc.edu.ph','09123400001','2003-01-12',1,'2025-11-28 18:52:04','2025-11-28 18:52:04'),(4,'stud002','hashedpass4','student','Angel','Cruz','angel.cruz@uc.edu.ph','09123400002','2004-04-20',1,'2025-11-28 18:52:04','2025-11-28 18:52:04'),(5,'stud003','hashedpass5','student','Marco','Reyes','marco.reyes@uc.edu.ph','09123400003','2002-11-05',1,'2025-11-28 18:52:04','2025-11-28 18:52:04');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-11-28 20:25:37
