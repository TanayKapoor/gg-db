CREATE TABLE `users` (
  `id` integer PRIMARY KEY AUTO_INCREMENT,
  `avatar` varchar(255),
  `first_name` varchar(255),
  `last_name` varchar(255),
  `username` varchar(255) UNIQUE NOT NULL,
  `email` varchar(255) UNIQUE NOT NULL,
  `password_hash` varchar(255),
  `birth_date` date,
  `phone_number` varchar(255),
  `is_active` boolean DEFAULT true,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `social_accounts` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `provider` varchar(255) NOT NULL,
  `provider_user_id` varchar(255) UNIQUE NOT NULL,
  `email` varchar(255) NOT NULL,
  `avatar` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `login_sessions` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `token` varchar(255) UNIQUE NOT NULL,
  `ip_address` varchar(255),
  `user_agent` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp,
  `expires_at` timestamp NOT NULL
);

CREATE TABLE `refresh_tokens` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `token` varchar(255) UNIQUE NOT NULL,
  `expires_at` timestamp NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `addresses` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `title` varchar(255),
  `address_line_1` varchar(255) NOT NULL,
  `address_line_2` varchar(255),
  `country` varchar(255) NOT NULL,
  `state` varchar(255) NOT NULL,
  `city` varchar(255) NOT NULL,
  `postal_code` varchar(255) NOT NULL,
  `landmark` varchar(255),
  `phone_number` varchar(255),
  `is_default` boolean DEFAULT false,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `categories` (
  `id` integer PRIMARY KEY,
  `name` varchar(255) UNIQUE NOT NULL,
  `description` varchar(255),
  `parent_id` integer,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `products` (
  `id` integer PRIMARY KEY,
  `name` varchar(255) NOT NULL,
  `description` text,
  `summary` varchar(255),
  `cover` varchar(255),
  `category_id` integer NOT NULL,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `user_activity_logs` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `action` varchar(255) NOT NULL,
  `details` json,
  `ip_address` varchar(255),
  `user_agent` varchar(255),
  `created_at` timestamp
);

CREATE TABLE `coupons` (
  `id` integer PRIMARY KEY,
  `code` varchar(255) UNIQUE NOT NULL,
  `discount_type` varchar(255) NOT NULL,
  `discount_value` decimal NOT NULL,
  `max_discount` decimal,
  `min_order_value` decimal,
  `start_date` timestamp NOT NULL,
  `end_date` timestamp NOT NULL,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `order_coupons` (
  `id` integer PRIMARY KEY,
  `order_id` integer NOT NULL,
  `coupon_id` integer NOT NULL,
  `discount_applied` decimal NOT NULL
);

CREATE TABLE `product_attributes` (
  `id` integer PRIMARY KEY,
  `product_id` integer NOT NULL,
  `type` ENUM ('color', 'size', 'material', 'style') NOT NULL,
  `value` varchar(255) NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `product_skus` (
  `id` integer PRIMARY KEY,
  `product_id` integer NOT NULL,
  `attributes` json NOT NULL,
  `sku` varchar(255) UNIQUE NOT NULL,
  `price` decimal NOT NULL,
  `quantity` integer DEFAULT 0,
  `is_active` boolean DEFAULT true,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `product_sku_attributes` (
  `id` integer PRIMARY KEY,
  `sku_id` integer NOT NULL,
  `attribute_type` ENUM ('color', 'size', 'material', 'style') NOT NULL,
  `attribute_value` varchar(255) NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `wishlist` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `product_id` integer NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `carts` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `total_price` decimal DEFAULT 0,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `cart_items` (
  `id` integer PRIMARY KEY,
  `cart_id` integer NOT NULL,
  `sku_id` integer NOT NULL,
  `quantity` integer DEFAULT 1,
  `price` decimal,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `orders` (
  `id` integer PRIMARY KEY,
  `user_id` integer NOT NULL,
  `total_price` decimal,
  `status` ENUM ('pending', 'processing', 'shipped', 'delivered', 'cancelled', 'returned'),
  `shipping_address_id` integer,
  `created_at` timestamp,
  `updated_at` timestamp
);

CREATE TABLE `order_items` (
  `id` integer,
  `order_id` integer NOT NULL,
  `sku_id` integer NOT NULL,
  `quantity` integer NOT NULL,
  `price` decimal NOT NULL,
  `created_at` timestamp
);

CREATE TABLE `payments` (
  `id` integer PRIMARY KEY,
  `order_id` integer NOT NULL,
  `amount` decimal NOT NULL,
  `provider` varchar(255),
  `status` ENUM ('pending', 'completed', 'failed', 'refunded'),
  `created_at` timestamp,
  `updated_at` timestamp
);

ALTER TABLE `social_accounts` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `login_sessions` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `refresh_tokens` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `addresses` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `categories` ADD FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

ALTER TABLE `products` ADD FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

ALTER TABLE `user_activity_logs` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `order_coupons` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `order_coupons` ADD FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`);

ALTER TABLE `product_attributes` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `product_skus` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `product_sku_attributes` ADD FOREIGN KEY (`sku_id`) REFERENCES `product_skus` (`id`);

ALTER TABLE `wishlist` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `wishlist` ADD FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

ALTER TABLE `carts` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `cart_items` ADD FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`);

ALTER TABLE `cart_items` ADD FOREIGN KEY (`sku_id`) REFERENCES `product_skus` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

ALTER TABLE `orders` ADD FOREIGN KEY (`shipping_address_id`) REFERENCES `addresses` (`id`);

ALTER TABLE `order_items` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);

ALTER TABLE `order_items` ADD FOREIGN KEY (`sku_id`) REFERENCES `product_skus` (`id`);

ALTER TABLE `payments` ADD FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`);
