ALTER TABLE currencies ADD `is_crypto` ENUM('Y','N') NOT NULL DEFAULT 'N';
ALTER TABLE `site_users` ADD `chat_handle` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;
ALTER TABLE `conversions` CHANGE `amount` `amount` DOUBLE( 10, 8 ) NOT NULL;
ALTER TABLE `app_configuration` ADD `chat_baseurl` VARCHAR( 255 ) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL;

CREATE TABLE IF NOT EXISTS `chat` (
  `id` int(20) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `message` blob NOT NULL,
  `site_user` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(477, 'orders-click-price-sell', 'Pulse para agregar precio a formulario de venta.', 'Click to add price to sell order ticket.', '', 11, 'Click to add to sell order ticket.', 'Click to add to sell order ticket.'),
(478, 'orders-click-amount-sell', 'Pulse para agregar cantidad a formulario de venta.', 'Click to add amount to sell order ticket.', '', 11, '', ''),
(479, 'orders-click-price-buy', 'Pulse para agregar precio a formulario de compra.', 'Click to add price to buy order ticket.', '', 11, 'Click to add price to buy order ticket.', 'Click to add price to buy order ticket.'),
(480, 'orders-click-amount-buy', 'Pulse para agregar cantidad a formulario de compra.', 'Click to add amount to buy order ticket.', '', 11, 'Click to add amount to buy order ticket.', 'Click to add amount to buy order ticket.');
INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(481, 'chat', 'Chat', 'Chat', '', 0, 'Chat', 'Chat'),
(482, 'chat-login', 'Inicie sesión para chatear.', 'Please log in to chat.', '', 481, 'Please log in to chat.', 'Please log in to chat.'),
(483, 'chat-handle', 'Nombre en chat', 'Chat Handle', '', 481, 'Chat Handle', 'Chat Handle');

INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2589, 'textInput', 'a:13:{s:4:"name";s:11:"chat_handle";s:7:"caption";s:11:"Chat Handle";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 11, 130, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2694, 'textInput', 'a:13:{s:4:"name";s:12:"chat_baseurl";s:7:"caption";s:13:"Chat Base URL";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 63, 269, 0);
