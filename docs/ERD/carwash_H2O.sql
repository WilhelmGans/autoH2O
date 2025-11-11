CREATE TABLE `users` (
  `id` uuid PRIMARY KEY,
  `phone_number` varchar(20) UNIQUE NOT NULL,
  `role` varchar(20) NOT NULL,
  `first_name` varchar(100),
  `last_name` varchar(100),
  `email` varchar(255),
  `rating` decimal(3,2) DEFAULT 5,
  `cancelation_count` integer DEFAULT 0,
  `is_blocked` boolean DEFAULT false,
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp DEFAULT (now())
);

CREATE TABLE `users_cars` (
  `user_id` uuid,
  `car_id` uuid
);

CREATE TABLE `cities` (
  `id` int PRIMARY KEY,
  `name` varchar(255) NOT NULL
);

CREATE TABLE `addresses` (
  `id` int PRIMARY KEY,
  `city_id` int,
  `street` varchar(255),
  `house_number` varchar(255),
  `building` varchar(255)
);

CREATE TABLE `car_washes` (
  `id` uuid PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `address_id` int,
  `open_time` time NOT NULL,
  `close_time` time NOT NULL,
  `city` varchar(100) NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `boxes` (
  `id` uuid PRIMARY KEY,
  `car_wash_id` uuid NOT NULL,
  `number` integer NOT NULL,
  `type` varchar(20) NOT NULL,
  `is_active` boolean DEFAULT true
);

CREATE TABLE `services` (
  `id` uuid PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `description` text,
  `base_price` decimal(10,2) NOT NULL,
  `category` varchar(20) NOT NULL,
  `duration_minutes` integer NOT NULL,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `cars` (
  `id` uuid PRIMARY KEY,
  `vin` varchar(17) UNIQUE,
  `make` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  `multiplier` decimal DEFAULT 1,
  `year` integer NOT NULL,
  `gos_number` varchar(20) NOT NULL,
  `body_type` varchar(50) NOT NULL,
  `color` varchar(50),
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp DEFAULT (now())
);

CREATE TABLE `orders` (
  `id` uuid PRIMARY KEY,
  `user_id` uuid NOT NULL,
  `car_id` uuid NOT NULL,
  `car_wash_id` uuid NOT NULL,
  `box_id` uuid NOT NULL,
  `status` varchar(20) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `payment_status` varchar(20) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `final_amount` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT 0,
  `bonus_points_used` integer DEFAULT 0,
  `scheduled_time` timestamp NOT NULL,
  `start_time` timestamp,
  `end_time` timestamp,
  `washer_id` uuid,
  `created_at` timestamp DEFAULT (now()),
  `updated_at` timestamp DEFAULT (now())
);

CREATE TABLE `order_services` (
  `id` uuid PRIMARY KEY,
  `order_id` uuid NOT NULL,
  `service_id` uuid NOT NULL,
  `vehicle_type` varchar(20) NOT NULL,
  `quantity` integer DEFAULT 1,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `promotions` (
  `id` uuid PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `description` text,
  `code` varchar(50) UNIQUE,
  `discount_type` varchar(20) NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT 0,
  `max_discount` decimal(10,2),
  `valid_from` timestamp NOT NULL,
  `valid_until` timestamp NOT NULL,
  `usage_limit` integer,
  `used_count` integer DEFAULT 0,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `order_promotions` (
  `id` uuid PRIMARY KEY,
  `order_id` uuid NOT NULL,
  `promotion_id` uuid NOT NULL,
  `discount_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `bonuses` (
  `id` uuid PRIMARY KEY,
  `user_id` uuid NOT NULL,
  `order_id` uuid,
  `type` varchar(20) NOT NULL,
  `points` integer NOT NULL,
  `balance_after` integer NOT NULL,
  `description` text,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `reviews` (
  `id` uuid PRIMARY KEY,
  `order_id` uuid UNIQUE NOT NULL,
  `user_id` uuid NOT NULL,
  `rating` integer NOT NULL,
  `comment` text,
  `washer_rating` integer,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `review_photos` (
  `id` uuid PRIMARY KEY,
  `review_id` uuid NOT NULL,
  `photo_url` text NOT NULL,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `special_tariffs` (
  `id` uuid PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `description` text,
  `user_category` varchar(50) NOT NULL,
  `discount_percentage` decimal(5,2) NOT NULL,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `user_special_tariffs` (
  `id` uuid PRIMARY KEY,
  `user_id` uuid NOT NULL,
  `tariff_id` uuid NOT NULL,
  `assigned_at` timestamp DEFAULT (now()),
  `assigned_by` uuid
);

CREATE TABLE `time_slots` (
  `id` uuid PRIMARY KEY,
  `box_id` uuid NOT NULL,
  `slot_time` timestamp NOT NULL,
  `is_available` boolean DEFAULT true,
  `order_id` uuid
);

CREATE TABLE `notifications` (
  `id` uuid PRIMARY KEY,
  `user_id` uuid NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` varchar(50) NOT NULL,
  `is_read` boolean DEFAULT false,
  `related_entity_type` varchar(50),
  `related_entity_id` uuid,
  `created_at` timestamp DEFAULT (now())
);

CREATE TABLE `integration_logs` (
  `id` uuid PRIMARY KEY,
  `entity_type` varchar(50) NOT NULL,
  `entity_id` uuid NOT NULL,
  `operation` varchar(50) NOT NULL,
  `status` varchar(20) NOT NULL,
  `request_data` jsonb,
  `response_data` jsonb,
  `error_message` text,
  `created_at` timestamp DEFAULT (now())
);

CREATE INDEX `users_index_0` ON `users` (`phone_number`);

CREATE INDEX `users_index_1` ON `users` (`role`);

CREATE INDEX `users_index_2` ON `users` (`is_blocked`);

CREATE INDEX `users_cars_index_3` ON `users_cars` (`user_id`);

CREATE INDEX `users_cars_index_4` ON `users_cars` (`car_id`);

CREATE INDEX `boxes_index_5` ON `boxes` (`car_wash_id`);

CREATE UNIQUE INDEX `boxes_index_6` ON `boxes` (`car_wash_id`, `number`);

CREATE INDEX `cars_index_7` ON `cars` (`gos_number`);

CREATE INDEX `orders_index_8` ON `orders` (`user_id`);

CREATE INDEX `orders_index_9` ON `orders` (`status`);

CREATE INDEX `orders_index_10` ON `orders` (`scheduled_time`);

CREATE INDEX `orders_index_11` ON `orders` (`car_wash_id`);

CREATE INDEX `orders_index_12` ON `orders` (`washer_id`);

CREATE INDEX `order_services_index_13` ON `order_services` (`order_id`);

CREATE INDEX `order_services_index_14` ON `order_services` (`service_id`);

CREATE INDEX `promotions_index_15` ON `promotions` (`code`);

CREATE INDEX `promotions_index_16` ON `promotions` (`is_active`);

CREATE INDEX `promotions_index_17` ON `promotions` (`valid_until`);

CREATE INDEX `order_promotions_index_18` ON `order_promotions` (`order_id`);

CREATE INDEX `order_promotions_index_19` ON `order_promotions` (`promotion_id`);

CREATE INDEX `bonuses_index_20` ON `bonuses` (`user_id`);

CREATE INDEX `bonuses_index_21` ON `bonuses` (`order_id`);

CREATE INDEX `bonuses_index_22` ON `bonuses` (`created_at`);

CREATE INDEX `reviews_index_23` ON `reviews` (`order_id`);

CREATE INDEX `reviews_index_24` ON `reviews` (`user_id`);

CREATE INDEX `reviews_index_25` ON `reviews` (`rating`);

CREATE INDEX `review_photos_index_26` ON `review_photos` (`review_id`);

CREATE INDEX `user_special_tariffs_index_27` ON `user_special_tariffs` (`user_id`);

CREATE INDEX `user_special_tariffs_index_28` ON `user_special_tariffs` (`tariff_id`);

CREATE UNIQUE INDEX `time_slots_index_29` ON `time_slots` (`box_id`, `slot_time`);

CREATE INDEX `time_slots_index_30` ON `time_slots` (`box_id`);

CREATE INDEX `time_slots_index_31` ON `time_slots` (`slot_time`);

CREATE INDEX `time_slots_index_32` ON `time_slots` (`is_available`);

CREATE INDEX `notifications_index_33` ON `notifications` (`user_id`);

CREATE INDEX `notifications_index_34` ON `notifications` (`is_read`);

CREATE INDEX `notifications_index_35` ON `notifications` (`created_at`);

CREATE INDEX `integration_logs_index_36` ON `integration_logs` (`entity_type`, `entity_id`);

CREATE INDEX `integration_logs_index_37` ON `integration_logs` (`status`);

CREATE INDEX `integration_logs_index_38` ON `integration_logs` (`created_at`);

ALTER TABLE `users_cars` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `users_cars` ADD FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);

ALTER TABLE `addresses` ADD FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`);

ALTER TABLE `car_washes` ADD FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`);

ALTER TABLE `boxes` ADD FOREIGN KEY (`car_wash_id`) REFERENCES `car_washes` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`car_id`) REFERENCES `cars` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`car_wash_id`) REFERENCES `car_washes` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`box_id`) REFERENCES `boxes` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`washer_id`) REFERENCES `users` (`id`);

ALTER TABLE `order_services` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `order_services` ADD FOREIGN KEY (`service_id`) REFERENCES `services` (`id`);

ALTER TABLE `order_promotions` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `order_promotions` ADD FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`);

ALTER TABLE `bonuses` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `bonuses` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `reviews` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `review_photos` ADD FOREIGN KEY (`review_id`) REFERENCES `reviews` (`id`);

ALTER TABLE `user_special_tariffs` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `user_special_tariffs` ADD FOREIGN KEY (`tariff_id`) REFERENCES `special_tariffs` (`id`);

ALTER TABLE `user_special_tariffs` ADD FOREIGN KEY (`assigned_by`) REFERENCES `users` (`id`);

ALTER TABLE `time_slots` ADD FOREIGN KEY (`box_id`) REFERENCES `boxes` (`id`);

ALTER TABLE `time_slots` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `notifications` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);
