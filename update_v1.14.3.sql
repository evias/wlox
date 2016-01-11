INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2615, 'textInput', 'a:13:{s:4:"name";s:19:"thousands_separator";s:7:"caption";s:19:"Thousands Separator";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 20, 269, 0),
(2616, 'textInput', 'a:13:{s:4:"name";s:17:"decimal_separator";s:7:"caption";s:17:"Decimal Separator";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 21, 269, 0),
(2618, 'checkBox', 'a:9:{s:4:"name";s:8:"time_24h";s:7:"caption";s:15:"24h Time Format";s:8:"required";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:11:"label_class";s:0:"";s:7:"checked";s:0:"";}', 22, 269, 0);

ALTER TABLE `app_configuration` ADD `thousands_separator` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE `app_configuration` ADD `decimal_separator` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE `app_configuration` ADD `time_24h` ENUM('Y','N') NOT NULL DEFAULT 'N';
