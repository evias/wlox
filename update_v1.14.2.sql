/* MULTI-CURRENCY FEATURE UPDATE */

ALTER TABLE orders ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE transactions ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE order_log ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE bitcoin_addresses ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE currencies ADD `min_price` DOUBLE( 10, 2 ) NOT NULL;
ALTER TABLE currencies ADD `is_main` ENUM('Y','N') NOT NULL DEFAULT 'N';
ALTER TABLE currencies ADD `not_convertible` ENUM('Y','N') NOT NULL DEFAULT 'N';
ALTER TABLE fees ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE site_users ADD `default_c_currency` INT( 10 ) NOT NULL;
ALTER TABLE historical_data ADD `c_currency` INT( 10 ) NOT NULL;
ALTER TABLE  `historical_data` ENGINE = INNODB;

ALTER TABLE  `orders` ADD INDEX ( `c_currency` ) ;
ALTER TABLE  `transactions` ADD INDEX (  `c_currency` ) ;
ALTER TABLE  `order_log` ADD INDEX (  `c_currency` ) ;
ALTER TABLE  `bitcoin_addresses` ADD INDEX (  `c_currency` ) ;
ALTER TABLE  `fees` ADD INDEX (  `c_currency` ) ;
ALTER TABLE  `historical_data` ADD INDEX (  `c_currency` ) ;

CREATE TABLE IF NOT EXISTS `wallets` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `total_btc` double(16,8) unsigned NOT NULL,
  `c_currency` int(10) NOT NULL,
  `hot_wallet_btc` double(16,8) unsigned NOT NULL,
  `warm_wallet_btc` double(16,8) unsigned NOT NULL,
  `pending_withdrawals` double(16,8) unsigned NOT NULL,
  `deficit_btc` double(16,8) unsigned NOT NULL,
  `btc_24h` double(10,2) unsigned NOT NULL,
  `btc_24h_b` double(10,2) unsigned NOT NULL,
  `btc_24h_s` double(10,2) unsigned NOT NULL,
  `btc_1h` double(10,2) unsigned NOT NULL,
  `btc_1h_b` double(10,2) unsigned NOT NULL,
  `btc_1h_s` double(10,2) unsigned NOT NULL,
  `status_id` int(10) NOT NULL,
  `hot_wallet_notified` enum('Y','N') NOT NULL DEFAULT 'N',
  `bitcoin_username` varchar(255) NOT NULL,
  `bitcoin_accountname` varchar(255) NOT NULL,
  `bitcoin_passphrase` varchar(255) NOT NULL,
  `bitcoin_host` varchar(255) NOT NULL,
  `bitcoin_port` varchar(255) NOT NULL,
  `bitcoin_protocol` varchar(255) NOT NULL,
  `bitcoin_warm_wallet_address` varchar(255) NOT NULL,
  `bitcoin_sending_fee` double(16,8) NOT NULL,
  `global_btc` int(10) NOT NULL,
  `market_cap` int(10) NOT NULL,
  `trade_volume` int(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

UPDATE currencies SET is_main = "Y" WHERE currency = "BTC";
UPDATE currencies SET is_main = "Y" WHERE currency = "USD";
INSERT INTO wallets (c_currency) SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y";
UPDATE `wallets` SET `hot_wallet_btc` = (SELECT hot_wallet_btc FROM status WHERE id = 1), `warm_wallet_btc` = (SELECT warm_wallet_btc FROM status WHERE id = 1),`pending_withdrawals` = (SELECT pending_withdrawals FROM status WHERE id = 1),`pending_withdrawals` = (SELECT pending_withdrawals FROM status WHERE id = 1),`btc_24h` = (SELECT btc_24h FROM status WHERE id = 1),status_id = 1, `bitcoin_username` = (SELECT bitcoin_username FROM app_configuration WHERE id = 1), `bitcoin_accountname` = (SELECT bitcoin_accountname FROM app_configuration WHERE id = 1), `bitcoin_passphrase` = (SELECT bitcoin_passphrase FROM app_configuration WHERE id = 1), `bitcoin_host` = (SELECT bitcoin_host FROM app_configuration WHERE id = 1),`bitcoin_port` = (SELECT bitcoin_port FROM app_configuration WHERE id = 1),`bitcoin_protocol` = (SELECT bitcoin_protocol FROM app_configuration WHERE id = 1),`bitcoin_warm_wallet_address` = (SELECT bitcoin_warm_wallet_address FROM app_configuration WHERE id = 1),`bitcoin_sending_fee` = (SELECT bitcoin_sending_fee FROM app_configuration WHERE id = 1);
UPDATE site_users SET default_c_currency = (SELECT id FROM currencies WHERE currency = "BTC");
UPDATE `orders` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
UPDATE `transactions` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
UPDATE `order_log` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
UPDATE `bitcoin_addresses` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
UPDATE `fees` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
UPDATE `historical_data` SET c_currency = (SELECT id FROM currencies WHERE is_main = "Y" AND is_crypto = "Y");
 
ALTER TABLE status DROP last_sweep;
ALTER TABLE status DROP status.deficit_btc;
ALTER TABLE status DROP status.hot_wallet_btc;
ALTER TABLE status DROP status.warm_wallet_btc;
ALTER TABLE status DROP status.total_btc;
ALTER TABLE status DROP status.received_btc_pending;
ALTER TABLE status DROP status.pending_withdrawals;
ALTER TABLE status DROP status.btc_24h;
ALTER TABLE status DROP status.hot_wallet_notified;
ALTER TABLE status DROP status.btc_24h_s;
ALTER TABLE status DROP status.btc_24h_b;
ALTER TABLE status DROP status.btc_1h;
ALTER TABLE status DROP status.btc_1h_s;
ALTER TABLE status DROP status.btc_1h_b;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_username;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_accountname;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_passphrase;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_host;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_port;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_protocol;
ALTER TABLE app_configuration DROP app_configuration.bitcoin_warm_wallet_address;
ALTER TABLE historical_data ADD UNIQUE (`date`,`c_currency`);
ALTER TABLE  `orders` CHANGE  `fiat`  `fiat` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `stop_price`  `stop_price` DOUBLE( 16, 8 ) NOT NULL ;
ALTER TABLE  `orders` CHANGE  `btc_price`  `btc_price` DOUBLE( 16, 8 ) NOT NULL;
ALTER TABLE  `order_log` CHANGE  `btc_price`  `btc_price` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat`  `fiat` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `stop_price`  `stop_price` DOUBLE( 16, 8 ) NOT NULL ;
ALTER TABLE  `transactions` CHANGE  `btc_price`  `btc_price` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat`  `fiat` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat_before1`  `fiat_before1` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat_after1`  `fiat_after1` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat_before`  `fiat_before` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `fiat_after`  `fiat_after` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `conversion_fee`  `conversion_fee` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `convert_amount`  `convert_amount` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `convert_system_rate`  `convert_system_rate` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `bid_at_transaction`  `bid_at_transaction` DOUBLE( 16, 8 ) NOT NULL ,
CHANGE  `ask_at_transaction`  `ask_at_transaction` DOUBLE( 16, 8 ) NOT NULL ;
ALTER TABLE  `transactions` CHANGE  `orig_btc_price`  `orig_btc_price` DOUBLE( 16, 8 ) NOT NULL ;
ALTER TABLE  `transactions` CHANGE  `convert_rate_given`  `convert_rate_given` DOUBLE( 16, 8 ) NOT NULL ;

UPDATE `request_descriptions` SET `id` = 1,`name_en` = 'Withdrawal to bank account',`name_es` = 'Retiro a cuenta bancaria',`name_ru` = 'Вывод средств на банковский счет',`name_zh` = '提现到银行账户' WHERE `request_descriptions`.`id` = 1;
UPDATE `request_descriptions` SET `id` = 2,`name_en` = 'Cryptocurrency withdrawal',`name_es` = 'Retiro de criptodivisas',`name_ru` = 'Kриптовалюта-вывод',`name_zh` = 'Cryptocurrency提款' WHERE `request_descriptions`.`id` = 2;
UPDATE `request_descriptions` SET `id` = 3,`name_en` = 'Deposit from bank account',`name_es` = 'Depósito desde cuenta bancaria',`name_ru` = 'Ввод с аккаунта банковский счет',`name_zh` = '从银行账户存款' WHERE `request_descriptions`.`id` = 3;
UPDATE `request_descriptions` SET `id` = 4,`name_en` = 'Cryptocurrency deposit',`name_es` = 'Depósito de criptodivisas',`name_ru` = 'Kриптовалюта-ввод',`name_zh` = 'Cryptocurrency存款' WHERE `request_descriptions`.`id` = 4;

UPDATE `admin_tabs` SET `name` = 'Users' WHERE `admin_tabs`.`id` = 30;
UPDATE `admin_tabs` SET `id` = 1,`order` = 0 WHERE `admin_tabs`.`id` = 1;
UPDATE `admin_tabs` SET `id` = 4,`order` = 5 WHERE `admin_tabs`.`id` = 4;
UPDATE `admin_tabs` SET `id` = 30,`order` = 3 WHERE `admin_tabs`.`id` = 30;
UPDATE `admin_tabs` SET `id` = 32,`order` = 4 WHERE `admin_tabs`.`id` = 32;
UPDATE `admin_tabs` SET `id` = 62,`order` = 1 WHERE `admin_tabs`.`id` = 62;
UPDATE `admin_tabs` SET `id` = 63,`order` = 2 WHERE `admin_tabs`.`id` = 63;
UPDATE `admin_tabs` SET `id` = 64,`order` = 7 WHERE `admin_tabs`.`id` = 64;
UPDATE `admin_tabs` SET `id` = 65,`order` = 9 WHERE `admin_tabs`.`id` = 65;
UPDATE `admin_tabs` SET `id` = 66,`order` = 6 WHERE `admin_tabs`.`id` = 66;
UPDATE `admin_tabs` SET `id` = 67,`order` = 8 WHERE `admin_tabs`.`id` = 67;
UPDATE `admin_controls` SET `page_id`=0,`tab_id`=67 WHERE page_id=90;
UPDATE `admin_pages` SET `f_id`=67 WHERE id=93;
UPDATE `admin_pages` SET `f_id`=67 WHERE id=96;
DELETE FROM admin_pages WHERE id = 90;

INSERT INTO `admin_tabs` (`id`, `name`, `order`, `icon`, `url`, `hidden`, `is_ctrl_panel`, `for_group`, `one_record`) VALUES
(67, 'Currencies', 8, '', 'currencies', '', '', 0, '');
INSERT INTO `admin_pages` (`id`, `f_id`, `name`, `url`, `icon`, `order`, `page_map_reorders`, `one_record`) VALUES
(100, 67, 'Cryptocurrency Wallets', 'wallets', '', 0, 0, '');

INSERT INTO `admin_controls` (`id`, `page_id`, `tab_id`, `action`, `class`, `arguments`, `order`, `is_static`) VALUES
(286, 100, 0, 'form', 'Form', 'a:10:{s:4:"name";s:7:"wallets";s:6:"method";s:0:"";s:5:"class";s:0:"";s:5:"table";s:7:"wallets";s:14:"return_to_self";s:1:"Y";s:18:"start_on_construct";s:0:"";s:9:"go_to_url";s:0:"";s:12:"go_to_action";s:0:"";s:12:"go_to_is_tab";s:0:"";s:6:"target";s:0:"";}', 0, 'N'),
(287, 100, 0, 'record', 'Record', 'a:1:{s:5:"table";s:7:"wallets";}', 0, 'N'),
(288, 100, 0, '', 'Grid', 'a:24:{s:5:"table";s:7:"wallets";s:4:"mode";s:0:"";s:13:"rows_per_page";s:0:"";s:5:"class";s:0:"";s:12:"show_buttons";s:1:"Y";s:14:"target_elem_id";s:7:"content";s:9:"max_pages";s:0:"";s:16:"pagination_label";s:0:"";s:18:"show_list_captions";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:10:"save_order";s:0:"";s:12:"enable_graph";s:0:"";s:12:"enable_table";s:0:"";s:11:"enable_list";s:0:"";s:17:"enable_graph_line";s:0:"";s:16:"enable_graph_pie";s:0:"";s:15:"button_link_url";s:0:"";s:18:"button_link_is_tab";s:0:"";s:10:"sql_filter";s:0:"";s:16:"alert_condition1";s:0:"";s:16:"alert_condition2";s:0:"";s:8:"group_by";s:0:"";s:11:"no_group_by";s:0:"";}', 0, 'N');

DELETE FROM admin_controls_methods WHERE id IN (1966,1914,1931,2567,2568,2569,2570,2571,2572,2587,1929,2588,1930,1915,1932,1937,1967,2438,2439,2440,2441,2442,2443,2480);
UPDATE `admin_controls_methods` SET `id` = 2405,`method` = 'startArea',`arguments` = 'a:3:{s:6:"legend";s:23:"Cryptocurrency Settings";s:5:"class";s:3:"box";s:6:"height";s:0:"";}',`order` = 41,`control_id` = 269,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2405;
UPDATE `admin_controls_methods` SET `id` = 2415,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:19:"bitcoin_sending_fee";s:7:"caption";s:22:"Default Blockchain Fee";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 11,`control_id` = 269,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2415;
UPDATE `admin_controls_methods` SET `id` = 2478,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:19:"bitcoin_reserve_min";s:7:"caption";s:43:"Reserve Min. Crypto (for Send to Warm Wal.)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 48,`control_id` = 269,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2478;
UPDATE `admin_controls_methods` SET `id` = 1699,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:3:"btc";s:7:"caption";s:13:"Crypto Amount";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 4,`control_id` = 210,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1699;
UPDATE `admin_controls_methods` SET `id` = 1703,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:9:"btc_price";s:7:"caption";s:12:"Crypto Price";s:8:"required";s:1:"1";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 6,`control_id` = 210,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1703;
UPDATE `admin_controls_methods` SET `id` = 1710,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:3:"btc";s:7:"caption";s:13:"Crypto Amount";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 4,`control_id` = 214,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1710;
UPDATE `admin_controls_methods` SET `id` = 1711,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:9:"btc_price";s:7:"caption";s:12:"Crypto Price";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 6,`control_id` = 214,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1711;
UPDATE `admin_controls_methods` SET `id` = 1722,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:3:"btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:6:"Crypto";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 9,`control_id` = 215,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1722;
UPDATE `admin_controls_methods` SET `id` = 1725,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:8:"currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"F. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 13,`control_id` = 215,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1725;
UPDATE `admin_controls_methods` SET `id` = 1730,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:3:"btc";s:7:"caption";s:23:"Crypto Amount (Curr. 1)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 7,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1730;
UPDATE `admin_controls_methods` SET `id` = 1731,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:9:"btc_price";s:7:"caption";s:22:"Crypto Price (Curr. 1)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 8,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1731;
UPDATE `admin_controls_methods` SET `id` = 1742,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:3:"btc";s:7:"caption";s:23:"Crypto Amount (Curr. 1)";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 4,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1742;
UPDATE `admin_controls_methods` SET `id` = 1743,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:9:"btc_price";s:7:"caption";s:22:"Crypto Price (Curr. 1)";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 5,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1743;
UPDATE `admin_controls_methods` SET `id` = 1752,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:3:"btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:6:"Crypto";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 13,`control_id` = 218,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1752;
UPDATE `admin_controls_methods` SET `id` = 1755,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:8:"currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:13:"F. Currency 1";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 9,`control_id` = 218,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1755;
UPDATE `admin_controls_methods` SET `id` = 1864,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:7:"btc_net";s:7:"caption";s:12:"Net Crypto 1";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 24,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1864;
UPDATE `admin_controls_methods` SET `id` = 1865,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:8:"btc_net1";s:7:"caption";s:12:"Net Crypto 2";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 38,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1865;
UPDATE `admin_controls_methods` SET `id` = 1911,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:7:"account";s:7:"caption";s:12:"Bank Account";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 8,`control_id` = 225,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1911;
UPDATE `admin_controls_methods` SET `id` = 1913,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:7:"account";s:7:"caption";s:12:"Bank Account";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 10,`control_id` = 232,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1913;
UPDATE `admin_controls_methods` SET `id` = 1955,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:9:"total_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:15:"T. Crypto (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 1,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1955;
UPDATE `admin_controls_methods` SET `id` = 1956,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:14:"total_fiat_usd";s:8:"subtable";s:0:"";s:14:"header_caption";s:11:"T. Fiat ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 2,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1956;
UPDATE `admin_controls_methods` SET `id` = 1957,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:12:"btc_per_user";s:8:"subtable";s:0:"";s:14:"header_caption";s:17:"Crypto/User (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 3,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1957;
UPDATE `admin_controls_methods` SET `id` = 1958,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:15:"open_orders_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:15:"Open Ord. (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 5,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1958;
UPDATE `admin_controls_methods` SET `id` = 1959,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:16:"transactions_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:12:"Trans. (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 6,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1959;
UPDATE `admin_controls_methods` SET `id` = 1960,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:24:"avg_transaction_size_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:16:"AVG Trans. (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 7,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1960;
UPDATE `admin_controls_methods` SET `id` = 1961,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:27:"transaction_volume_per_user";s:8:"subtable";s:0:"";s:14:"header_caption";s:17:"Trans./User (BTC)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 8,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1961;
UPDATE `admin_controls_methods` SET `id` = 1962,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:14:"total_fees_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:8:"Fees ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 9,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1962;
UPDATE `admin_controls_methods` SET `id` = 1963,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:17:"fees_per_user_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:13:"Fees/User ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 10,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1963;
UPDATE `admin_controls_methods` SET `id` = 1965,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:12:"usd_per_user";s:8:"subtable";s:0:"";s:14:"header_caption";s:13:"Fiat/User ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 4,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1965;
UPDATE `admin_controls_methods` SET `id` = 1999,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:16:"gross_profit_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:16:"Gross Profit ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 11,`control_id` = 249,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1999;
UPDATE `admin_controls_methods` SET `id` = 2010,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:16:"transactions_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:16:"Total Trans. ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 1,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2010;
UPDATE `admin_controls_methods` SET `id` = 2011,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:24:"avg_transaction_size_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:15:"Avg. Trans. ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 2,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2011;
UPDATE `admin_controls_methods` SET `id` = 2012,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:27:"transaction_volume_per_user";s:8:"subtable";s:0:"";s:14:"header_caption";s:14:"Trans/User ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 3,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2012;
UPDATE `admin_controls_methods` SET `id` = 2013,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:14:"total_fees_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:14:"Total Fees ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 4,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2013;
UPDATE `admin_controls_methods` SET `id` = 2014,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:17:"fees_per_user_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:17:"Fees per User ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 5,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2014;
UPDATE `admin_controls_methods` SET `id` = 2015,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:16:"gross_profit_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:16:"Gross Profit ($)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 6,`control_id` = 251,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2015;
UPDATE `admin_controls_methods` SET `id` = 2025,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:10:"btc_before";s:7:"caption";s:15:"Crypto Before 1";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 27,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2025;
UPDATE `admin_controls_methods` SET `id` = 2026,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:11:"btc_before1";s:7:"caption";s:15:"Crypto Before 2";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 40,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2026;
UPDATE `admin_controls_methods` SET `id` = 2027,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:9:"btc_after";s:7:"caption";s:14:"Crypto After 1";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 28,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2027;
UPDATE `admin_controls_methods` SET `id` = 2028,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:10:"btc_after1";s:7:"caption";s:14:"Crypto After 2";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 41,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2028;
UPDATE `admin_controls_methods` SET `id` = 2036,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:3:"btc";s:7:"caption";s:19:"Orig. Crypto Amount";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 6,`control_id` = 252,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2036;
UPDATE `admin_controls_methods` SET `id` = 2038,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:9:"btc_price";s:7:"caption";s:12:"Crypto Price";s:8:"required";s:1:"1";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 9,`control_id` = 252,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2038;
UPDATE `admin_controls_methods` SET `id` = 2050,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:3:"btc";s:7:"caption";s:19:"Orig. Crypto Amount";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 5,`control_id` = 253,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2050;
UPDATE `admin_controls_methods` SET `id` = 2052,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:9:"btc_price";s:7:"caption";s:12:"Crypto Price";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 8,`control_id` = 253,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2052;
UPDATE `admin_controls_methods` SET `id` = 2060,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:3:"btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:12:"Orig. Crypto";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 10,`control_id` = 254,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2060;
UPDATE `admin_controls_methods` SET `id` = 2063,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:8:"currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"F. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 14,`control_id` = 254,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2063;
UPDATE `admin_controls_methods` SET `id` = 2070,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:10:"btc_before";s:7:"caption";s:15:"Crypto Before 1";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 23,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2070;
UPDATE `admin_controls_methods` SET `id` = 2071,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:11:"btc_before1";s:7:"caption";s:15:"Crypto Before 2";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 35,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2071;
UPDATE `admin_controls_methods` SET `id` = 2072,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:9:"btc_after";s:7:"caption";s:14:"Crypto After 1";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 24,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2072;
UPDATE `admin_controls_methods` SET `id` = 2132,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:9:"fa_symbol";s:8:"subtable";s:0:"";s:14:"header_caption";s:6:"Symbol";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 4,`control_id` = 257,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2132;
UPDATE `admin_controls_methods` SET `id` = 2148,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:15:"bitcoin_address";s:7:"caption";s:14:"Crypto Address";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 4,`control_id` = 261,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2148;
UPDATE `admin_controls_methods` SET `id` = 2156,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:15:"bitcoin_address";s:7:"caption";s:14:"Crypto Address";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 4,`control_id` = 262,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2156;
UPDATE `admin_controls_methods` SET `id` = 2183,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:9:"order_btc";s:8:"subtable";s:9:"order_log";s:14:"header_caption";s:11:"Ord. Crypto";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:3:"btc";s:3:"btc";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:29:"history.order_id,order_log.id";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 15,`control_id` = 263,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2183;
UPDATE `admin_controls_methods` SET `id` = 2184,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:14:"order_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:13:"Ord. F. Curr.";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:62:"history.order_id,order_log.id,order_log.currency,currencies.id";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 17,`control_id` = 263,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2184;
UPDATE `admin_controls_methods` SET `id` = 2185,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:11:"order_price";s:8:"subtable";s:9:"order_log";s:14:"header_caption";s:17:"Ord. Crypto Price";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:9:"btc_price";s:9:"btc_price";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:29:"history.order_id,order_log.id";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 16,`control_id` = 263,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2185;
UPDATE `admin_controls_methods` SET `id` = 2189,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:9:"crypto_id";s:7:"caption";s:7:"Bank ID";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 10,`control_id` = 225,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2189;
UPDATE `admin_controls_methods` SET `id` = 2216,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:9:"currency1";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:13:"F. Currency 2";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 12,`control_id` = 218,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2216;
UPDATE `admin_controls_methods` SET `id` = 2222,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:14:"orig_btc_price";s:7:"caption";s:31:"Original Crypto Price (Curr. 2)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 9,`control_id` = 216,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2222;
UPDATE `admin_controls_methods` SET `id` = 2230,`method` = 'field',`arguments` = 'a:14:{s:4:"name";s:14:"orig_btc_price";s:7:"caption";s:31:"Original Crypto Price (Curr. 2)";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}',`order` = 6,`control_id` = 217,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2230;
UPDATE `admin_controls_methods` SET `id` = 2549,`method` = 'filterSelect',`arguments` = 'a:11:{s:10:"field_name";s:44:"transactions.currency,transactions.currency1";s:7:"caption";s:11:"F. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}',`order` = 1,`control_id` = 218,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2549;
UPDATE `admin_controls_methods` SET `id` = 2551,`method` = 'filterSelect',`arguments` = 'a:11:{s:10:"field_name";s:15:"orders.currency";s:7:"caption";s:11:"F. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}',`order` = 1,`control_id` = 215,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2551;
UPDATE `admin_controls_methods` SET `id` = 2556,`method` = 'filterSelect',`arguments` = 'a:11:{s:10:"field_name";s:18:"order_log.currency";s:7:"caption";s:11:"F. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}',`order` = 2,`control_id` = 254,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2556;
UPDATE `admin_controls_methods` SET `id` = 1850,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:8:"from_usd";s:7:"caption";s:27:"From (principal fiat/month)";s:8:"required";s:1:"1";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 2,`control_id` = 237,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1850;
UPDATE `admin_controls_methods` SET `id` = 1851,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:6:"to_usd";s:7:"caption";s:25:"To (principal fiat/month)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 3,`control_id` = 237,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 1851;
UPDATE `admin_controls_methods` SET `id` = 2257,`method` = 'textInput',`arguments` = 'a:13:{s:4:"name";s:10:"global_btc";s:7:"caption";s:30:"Global Reducer (p. crypto/24h)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}',`order` = 4,`control_id` = 237,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2257;
UPDATE `admin_controls_methods` SET `id` = 2260,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:8:"from_usd";s:8:"subtable";s:0:"";s:14:"header_caption";s:16:"From (fiat/mon.)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 2,`control_id` = 268,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2260;
UPDATE `admin_controls_methods` SET `id` = 2261,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:6:"to_usd";s:8:"subtable";s:0:"";s:14:"header_caption";s:14:"To (fiat/mon.)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 3,`control_id` = 268,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2261;
UPDATE `admin_controls_methods` SET `id` = 2262,`method` = 'field',`arguments` = 'a:18:{s:4:"name";s:10:"global_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:27:"Global Reducer (crypto/24h)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}',`order` = 4,`control_id` = 268,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2262;


INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2780, 'textInput', 'a:13:{s:4:"name";s:19:"bitcoin_sending_fee";s:7:"caption";s:14:"Blockchain Fee";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 24, 286, 0),
(2781, 'field', 'a:14:{s:4:"name";s:19:"bitcoin_sending_fee";s:7:"caption";s:14:"Blockchain Fee";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 21, 287, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2696, 'field', 'a:14:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 5, 214, 0),
(2697, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"C. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 10, 215, 0),
(2698, 'selectInput', 'a:20:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 6, 216, 0),
(2699, 'field', 'a:14:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 3, 217, 0),
(2700, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"C. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 6, 218, 0),
(2701, 'filterSelect', 'a:11:{s:10:"field_name";s:23:"transactions.c_currency";s:7:"caption";s:11:"C. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}', 2, 218, 0),
(2702, 'selectInput', 'a:20:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 7, 252, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2703, 'filterSelect', 'a:11:{s:10:"field_name";s:17:"orders.c_currency";s:7:"caption";s:11:"C. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}', 2, 215, 0),
(2704, 'field', 'a:14:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 6, 253, 0),
(2705, 'filterSelect', 'a:11:{s:10:"field_name";s:20:"order_log.c_currency";s:7:"caption";s:11:"C. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}', 3, 254, 0),
(2706, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"C. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 11, 254, 0),
(2707, 'selectInput', 'a:20:{s:4:"name";s:10:"c_currency";s:7:"caption";s:15:"Crypto Currency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 0, 242, 0),
(2708, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"C. Currency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 3, 243, 0),
(2709, 'filterSelect', 'a:11:{s:10:"field_name";s:10:"c_currency";s:7:"caption";s:11:"C. Currency";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:5:"class";s:0:"";s:10:"f_id_field";s:0:"";s:10:"depends_on";s:0:"";s:5:"level";s:0:"";s:4:"f_id";s:0:"";s:15:"use_enum_values";s:0:"";}', 1, 243, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2710, 'field', 'a:18:{s:4:"name";s:14:"order_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:13:"Ord. C. Curr.";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:64:"history.order_id,order_log.id,order_log.c_currency,currencies.id";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 17, 263, 0),
(2711, 'textInput', 'a:13:{s:4:"name";s:9:"total_btc";s:7:"caption";s:13:"Total Balance";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 3, 286, 0),
(2712, 'textInput', 'a:13:{s:4:"name";s:14:"hot_wallet_btc";s:7:"caption";s:18:"Hot Wallet Balance";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 4, 286, 0),
(2713, 'textInput', 'a:13:{s:4:"name";s:15:"warm_wallet_btc";s:7:"caption";s:16:"Off-Site Balance";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 5, 286, 0),
(2714, 'textInput', 'a:13:{s:4:"name";s:19:"pending_withdrawals";s:7:"caption";s:19:"Pending Withdrawals";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 6, 286, 0),
(2715, 'textInput', 'a:13:{s:4:"name";s:11:"deficit_btc";s:7:"caption";s:7:"Deficit";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 7, 286, 0),
(2716, 'selectInput', 'a:20:{s:4:"name";s:10:"c_currency";s:7:"caption";s:14:"Cryptocurrency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 2, 286, 0),
(2717, 'textInput', 'a:13:{s:4:"name";s:7:"btc_24h";s:7:"caption";s:9:"Vol (24h)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 8, 286, 0),
(2718, 'textInput', 'a:13:{s:4:"name";s:9:"btc_24h_b";s:7:"caption";s:13:"Vol (24h) Buy";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 9, 286, 0),
(2719, 'textInput', 'a:13:{s:4:"name";s:9:"btc_24h_s";s:7:"caption";s:14:"Vol (24h) Sell";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 10, 286, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2720, 'textInput', 'a:13:{s:4:"name";s:6:"btc_1h";s:7:"caption";s:8:"Vol (1h)";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 11, 286, 0),
(2721, 'textInput', 'a:13:{s:4:"name";s:8:"btc_1h_b";s:7:"caption";s:12:"Vol (1h) Buy";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 12, 286, 0),
(2722, 'textInput', 'a:13:{s:4:"name";s:8:"btc_1h_s";s:7:"caption";s:13:"Vol (1h) Sell";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 13, 286, 0),
(2723, 'submitButton', 'a:6:{s:4:"name";s:4:"Save";s:5:"value";s:4:"Save";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";}', 14, 286, 0),
(2724, 'cancelButton', 'a:4:{s:5:"value";s:6:"Cancel";s:2:"id";s:0:"";s:5:"class";s:0:"";s:5:"style";s:0:"";}', 15, 286, 0),
(2725, 'field', 'a:14:{s:4:"name";s:10:"c_currency";s:7:"caption";s:14:"Cryptocurrency";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 0, 287, 0),
(2726, 'field', 'a:14:{s:4:"name";s:9:"total_btc";s:7:"caption";s:13:"Total Balance";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 1, 287, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2727, 'field', 'a:14:{s:4:"name";s:14:"hot_wallet_btc";s:7:"caption";s:18:"Hot Wallet Balance";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 2, 287, 0),
(2728, 'field', 'a:14:{s:4:"name";s:15:"warm_wallet_btc";s:7:"caption";s:16:"Off-Site Balance";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 3, 287, 0),
(2729, 'field', 'a:14:{s:4:"name";s:19:"pending_withdrawals";s:7:"caption";s:19:"Pending Withdrawals";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 4, 287, 0),
(2730, 'field', 'a:14:{s:4:"name";s:11:"deficit_btc";s:7:"caption";s:7:"Deficit";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 5, 287, 0),
(2731, 'field', 'a:14:{s:4:"name";s:7:"btc_24h";s:7:"caption";s:9:"Vol (24h)";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 6, 287, 0),
(2732, 'field', 'a:14:{s:4:"name";s:9:"btc_24h_b";s:7:"caption";s:13:"Vol (24h) Buy";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 7, 287, 0),
(2733, 'field', 'a:14:{s:4:"name";s:9:"btc_24h_s";s:7:"caption";s:14:"Vol (24h) Sell";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 8, 287, 0),
(2735, 'field', 'a:14:{s:4:"name";s:6:"btc_1h";s:7:"caption";s:8:"Vol (1h)";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 9, 287, 0),
(2736, 'field', 'a:14:{s:4:"name";s:8:"btc_1h_b";s:7:"caption";s:12:"Vol (1h) Buy";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 10, 287, 0),
(2737, 'field', 'a:14:{s:4:"name";s:8:"btc_1h_s";s:7:"caption";s:13:"Vol (1h) Sell";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 11, 287, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2738, 'cancelButton', 'a:4:{s:5:"value";s:2:"OK";s:2:"id";s:0:"";s:5:"class";s:0:"";s:5:"style";s:0:"";}', 12, 287, 0),
(2740, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:8:"C. Curr.";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 0, 288, 0),
(2741, 'field', 'a:18:{s:4:"name";s:9:"total_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:5:"Total";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 1, 288, 0),
(2742, 'field', 'a:18:{s:4:"name";s:14:"hot_wallet_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:10:"Hot Wallet";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 2, 288, 0),
(2743, 'field', 'a:18:{s:4:"name";s:11:"deficit_btc";s:8:"subtable";s:0:"";s:14:"header_caption";s:7:"Deficit";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 3, 288, 0),
(2744, 'field', 'a:18:{s:4:"name";s:7:"btc_24h";s:8:"subtable";s:0:"";s:14:"header_caption";s:9:"Vol (24h)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 4, 288, 0),
(2745, 'field', 'a:18:{s:4:"name";s:6:"btc_1h";s:8:"subtable";s:0:"";s:14:"header_caption";s:8:"Vol (1h)";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 5, 288, 0),
(2746, 'startArea', 'a:3:{s:6:"legend";s:7:"Wallets";s:5:"class";s:8:"box_left";s:6:"height";s:0:"";}', 2, 244, 0),
(2747, 'startTab', 'a:5:{s:7:"caption";s:7:"Wallets";s:3:"url";s:7:"wallets";s:6:"is_tab";s:0:"";s:14:"inset_id_field";s:9:"status_id";s:6:"area_i";s:0:"";}', 3, 244, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2748, 'endArea', '', 4, 244, 0),
(2749, 'hiddenInput', 'a:8:{s:4:"name";s:9:"status_id";s:8:"required";s:0:"";s:5:"value";s:1:"1";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:7:"jscript";s:0:"";s:20:"is_current_timestamp";s:0:"";s:15:"on_every_update";s:0:"";}', 0, 286, 0),
(2750, 'hiddenInput', 'a:8:{s:4:"name";s:19:"hot_wallet_notified";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:4:"enum";s:7:"jscript";s:0:"";s:20:"is_current_timestamp";s:0:"";s:15:"on_every_update";s:0:"";}', 1, 286, 0),
(2751, 'checkBox', 'a:9:{s:4:"name";s:9:"is_crypto";s:7:"caption";s:18:"Is Cryptocurrency?";s:8:"required";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:11:"label_class";s:0:"";s:7:"checked";s:0:"";}', 11, 256, 0),
(2752, 'field', 'a:18:{s:4:"name";s:9:"is_active";s:8:"subtable";s:0:"";s:14:"header_caption";s:7:"Active?";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 5, 257, 0),
(2753, 'field', 'a:18:{s:4:"name";s:9:"is_crypto";s:8:"subtable";s:0:"";s:14:"header_caption";s:10:"Is Crypto?";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 6, 257, 0),
(2755, 'textInput', 'a:13:{s:4:"name";s:9:"min_price";s:7:"caption";s:13:"Minimum Price";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:7:"decimal";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 3, 256, 0);

INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2756, 'startArea', 'a:3:{s:6:"legend";s:11:"Wallet Info";s:5:"class";s:8:"box_left";s:6:"height";s:0:"";}', 2, 286, 0),
(2757, 'endArea', '', 15, 286, 0),
(2758, 'startArea', 'a:3:{s:6:"legend";s:20:"Connection to Daemon";s:5:"class";s:9:"box_right";s:6:"height";s:0:"";}', 16, 286, 0),
(2759, 'endArea', '', 24, 286, 0),
(2760, 'textInput', 'a:13:{s:4:"name";s:16:"bitcoin_username";s:7:"caption";s:8:"Username";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 17, 286, 0),
(2761, 'textInput', 'a:13:{s:4:"name";s:19:"bitcoin_accountname";s:7:"caption";s:12:"Account Name";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 18, 286, 0),
(2762, 'textInput', 'a:13:{s:4:"name";s:18:"bitcoin_passphrase";s:7:"caption";s:10:"Passphrase";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 19, 286, 0),
(2763, 'textInput', 'a:13:{s:4:"name";s:12:"bitcoin_host";s:7:"caption";s:11:"Hostname/IP";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 20, 286, 0),
(2764, 'textInput', 'a:13:{s:4:"name";s:12:"bitcoin_port";s:7:"caption";s:4:"Port";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 21, 286, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2765, 'textInput', 'a:13:{s:4:"name";s:16:"bitcoin_protocol";s:7:"caption";s:8:"Protocol";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 22, 286, 0),
(2766, 'textInput', 'a:13:{s:4:"name";s:27:"bitcoin_warm_wallet_address";s:7:"caption";s:19:"Warm Wallet Address";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 23, 286, 0),
(2767, 'startArea', 'a:3:{s:6:"legend";s:11:"Wallet Info";s:5:"class";s:9:"box_right";s:6:"height";s:0:"";}', 0, 287, 0),
(2768, 'endArea', '', 13, 287, 0),
(2769, 'startArea', 'a:3:{s:6:"legend";s:20:"Connection to Daemon";s:5:"class";s:9:"box_right";s:6:"height";s:0:"";}', 14, 287, 0),
(2770, 'endArea', '', 22, 287, 0),
(2771, 'field', 'a:14:{s:4:"name";s:16:"bitcoin_username";s:7:"caption";s:8:"Username";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 15, 287, 0),
(2772, 'field', 'a:14:{s:4:"name";s:19:"bitcoin_accountname";s:7:"caption";s:12:"Account Name";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 16, 287, 0),
(2773, 'field', 'a:14:{s:4:"name";s:18:"bitcoin_passphrase";s:7:"caption";s:10:"Passphrase";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 17, 287, 0),
(2774, 'field', 'a:14:{s:4:"name";s:12:"bitcoin_host";s:7:"caption";s:11:"Hostname/IP";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 18, 287, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2775, 'field', 'a:14:{s:4:"name";s:12:"bitcoin_port";s:7:"caption";s:4:"Port";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 19, 287, 0),
(2776, 'field', 'a:14:{s:4:"name";s:16:"bitcoin_protocol";s:7:"caption";s:8:"Protocol";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 20, 287, 0),
(2777, 'field', 'a:14:{s:4:"name";s:27:"bitcoin_warm_wallet_address";s:7:"caption";s:19:"Warm Wallet Address";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 21, 287, 0),
(2778, 'checkBox', 'a:9:{s:4:"name";s:7:"is_main";s:7:"caption";s:13:"Is Principle?";s:8:"required";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:11:"label_class";s:0:"";s:7:"checked";s:0:"";}', 13, 256, 0),
(2779, 'field', 'a:18:{s:4:"name";s:7:"is_main";s:8:"subtable";s:0:"";s:14:"header_caption";s:13:"Is Principle?";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 7, 257, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2782, 'checkBox', 'a:9:{s:4:"name";s:14:"not_convertible";s:7:"caption";s:15:"Not Convertible?";s:8:"required";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:11:"label_class";s:0:"";s:7:"checked";s:0:"";}', 14, 256, 0),
(2783, 'field', 'a:18:{s:4:"name";s:14:"not_convertible";s:8:"subtable";s:0:"";s:14:"header_caption";s:15:"Not Convertible?";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";s:0:"";s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 7, 257, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2784, 'selectInput', 'a:20:{s:4:"name";s:10:"c_currency";s:7:"caption";s:14:"Cryptocurrency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 0, 246, 0),
(2785, 'field', 'a:18:{s:4:"name";s:10:"c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:14:"Cryptocurrency";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 2, 247, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2786, 'textInput', 'a:13:{s:4:"name";s:10:"global_btc";s:7:"caption";s:12:"Global Units";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 15, 286, 0),
(2787, 'textInput', 'a:13:{s:4:"name";s:10:"market_cap";s:7:"caption";s:10:"Market Cap";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 16, 286, 0),
(2788, 'textInput', 'a:13:{s:4:"name";s:12:"trade_volume";s:7:"caption";s:12:"Trade Volume";s:8:"required";s:0:"";s:5:"value";s:0:"";s:2:"id";s:0:"";s:13:"db_field_type";s:3:"int";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:15:"is_manual_array";s:0:"";s:9:"is_unique";s:0:"";s:12:"default_text";s:0:"";s:17:"delete_whitespace";s:0:"";}', 17, 286, 0),
(2789, 'field', 'a:14:{s:4:"name";s:10:"global_btc";s:7:"caption";s:12:"Global Units";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 13, 287, 0),
(2790, 'field', 'a:14:{s:4:"name";s:10:"market_cap";s:7:"caption";s:10:"Market Cap";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 14, 287, 0),
(2791, 'field', 'a:14:{s:4:"name";s:12:"trade_volume";s:7:"caption";s:12:"Trade Volume";s:8:"subtable";s:0:"";s:15:"subtable_fields";s:0:"";s:8:"link_url";s:0:"";s:11:"concat_char";s:0:"";s:7:"in_form";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:14:"override_value";s:0:"";s:13:"link_id_field";s:0:"";}', 14, 287, 0);
INSERT INTO `admin_controls_methods` (`id`, `method`, `arguments`, `order`, `control_id`, `p_id`) VALUES
(2792, 'selectInput', 'a:20:{s:4:"name";s:18:"default_c_currency";s:7:"caption";s:22:"Default Cryptocurrency";s:8:"required";s:0:"";s:5:"value";s:0:"";s:13:"options_array";s:0:"";s:8:"subtable";s:10:"currencies";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:13:"subtable_f_id";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:10:"f_id_field";s:0:"";s:12:"default_text";s:0:"";s:10:"depends_on";s:0:"";s:20:"function_to_elements";s:0:"";s:16:"first_is_default";s:0:"";s:5:"level";s:0:"";s:11:"concat_char";s:0:"";s:9:"is_catsel";s:0:"";}', 13, 130, 0),
(2793, 'field', 'a:18:{s:4:"name";s:18:"default_c_currency";s:8:"subtable";s:10:"currencies";s:14:"header_caption";s:11:"Def. Crypto";s:6:"filter";s:1:"Y";s:8:"link_url";s:0:"";s:15:"subtable_fields";a:1:{s:8:"currency";s:8:"currency";}s:22:"subtable_fields_concat";s:0:"";s:5:"class";s:0:"";s:18:"aggregate_function";s:0:"";s:12:"thumb_amount";s:0:"";s:12:"media_amount";s:0:"";s:10:"media_size";s:0:"";s:10:"f_id_field";s:0:"";s:8:"order_by";s:0:"";s:9:"order_asc";s:0:"";s:11:"link_is_tab";s:0:"";s:16:"limit_is_curdate";s:0:"";s:8:"is_media";s:0:"";}', 6, 132, 0);



UPDATE `admin_controls_methods` SET `id` = 2393,`order` = 7 WHERE `admin_controls_methods`.`id` = 2393;
UPDATE `admin_controls_methods` SET `id` = 2394,`order` = 8 WHERE `admin_controls_methods`.`id` = 2394;
UPDATE `admin_controls_methods` SET `id` = 1933,`order` = 5 WHERE `admin_controls_methods`.`id` = 1933;
UPDATE `admin_controls_methods` SET `id` = 1907,`order` = 6 WHERE `admin_controls_methods`.`id` = 1907;
UPDATE `admin_controls_methods` SET `id` = 1861,`order` = 10 WHERE `admin_controls_methods`.`id` = 1861;
UPDATE `admin_controls_methods` SET `id` = 1862,`order` = 10 WHERE `admin_controls_methods`.`id` = 1862;
UPDATE `admin_controls_methods` SET `id` = 1863,`order` = 15 WHERE `admin_controls_methods`.`id` = 1863;
UPDATE `admin_controls_methods` SET `id` = 1893,`order` = 1 WHERE `admin_controls_methods`.`id` = 1893;
UPDATE `admin_controls_methods` SET `id` = 1894,`order` = 2 WHERE `admin_controls_methods`.`id` = 1894;
UPDATE `admin_controls_methods` SET `id` = 1895,`order` = 3 WHERE `admin_controls_methods`.`id` = 1895;
UPDATE `admin_controls_methods` SET `id` = 1896,`order` = 7 WHERE `admin_controls_methods`.`id` = 1896;
UPDATE `admin_controls_methods` SET `id` = 1897,`order` = 8 WHERE `admin_controls_methods`.`id` = 1897;
UPDATE `admin_controls_methods` SET `id` = 1898,`order` = 2 WHERE `admin_controls_methods`.`id` = 1898;
UPDATE `admin_controls_methods` SET `id` = 1899,`order` = 4 WHERE `admin_controls_methods`.`id` = 1899;
UPDATE `admin_controls_methods` SET `id` = 1936,`order` = 8 WHERE `admin_controls_methods`.`id` = 1936;
UPDATE `admin_controls_methods` SET `id` = 1901,`order` = 5 WHERE `admin_controls_methods`.`id` = 1901;
UPDATE `admin_controls_methods` SET `id` = 1934,`order` = 6 WHERE `admin_controls_methods`.`id` = 1934;
UPDATE `admin_controls_methods` SET `id` = 1935,`order` = 7 WHERE `admin_controls_methods`.`id` = 1935;
UPDATE `admin_controls_methods` SET `id` = 1905,`order` = 4 WHERE `admin_controls_methods`.`id` = 1905;
UPDATE `admin_controls_methods` SET `id` = 2752,`order` = 5 WHERE `admin_controls_methods`.`id` = 2752;
UPDATE `admin_controls_methods` SET `id` = 2753,`order` = 6 WHERE `admin_controls_methods`.`id` = 2753;
UPDATE `admin_controls_methods` SET `id` = 1696,`order` = 1 WHERE `admin_controls_methods`.`id` = 1696;
UPDATE `admin_controls_methods` SET `id` = 1697,`order` = 3 WHERE `admin_controls_methods`.`id` = 1697;
UPDATE `admin_controls_methods` SET `id` = 1698,`order` = 2 WHERE `admin_controls_methods`.`id` = 1698;
UPDATE `admin_controls_methods` SET `id` = 1699,`order` = 4 WHERE `admin_controls_methods`.`id` = 1699;
UPDATE `admin_controls_methods` SET `id` = 1700,`order` = 7 WHERE `admin_controls_methods`.`id` = 1700;
UPDATE `admin_controls_methods` SET `id` = 1703,`order` = 6 WHERE `admin_controls_methods`.`id` = 1703;
UPDATE `admin_controls_methods` SET `id` = 1701,`order` = 8 WHERE `admin_controls_methods`.`id` = 1701;
UPDATE `admin_controls_methods` SET `id` = 1705,`order` = 12 WHERE `admin_controls_methods`.`id` = 1705;
UPDATE `admin_controls_methods` SET `id` = 1706,`order` = 13 WHERE `admin_controls_methods`.`id` = 1706;
UPDATE `admin_controls_methods` SET `id` = 1707,`order` = 2 WHERE `admin_controls_methods`.`id` = 1707;
UPDATE `admin_controls_methods` SET `id` = 1708,`order` = 3 WHERE `admin_controls_methods`.`id` = 1708;
UPDATE `admin_controls_methods` SET `id` = 1709,`order` = 1 WHERE `admin_controls_methods`.`id` = 1709;
UPDATE `admin_controls_methods` SET `id` = 1710,`order` = 4 WHERE `admin_controls_methods`.`id` = 1710;
UPDATE `admin_controls_methods` SET `id` = 1711,`order` = 6 WHERE `admin_controls_methods`.`id` = 1711;
UPDATE `admin_controls_methods` SET `id` = 1712,`order` = 7 WHERE `admin_controls_methods`.`id` = 1712;
UPDATE `admin_controls_methods` SET `id` = 1713,`order` = 8 WHERE `admin_controls_methods`.`id` = 1713;
UPDATE `admin_controls_methods` SET `id` = 1865,`order` = 38 WHERE `admin_controls_methods`.`id` = 1865;
UPDATE `admin_controls_methods` SET `id` = 1715,`order` = 11 WHERE `admin_controls_methods`.`id` = 1715;
UPDATE `admin_controls_methods` SET `id` = 1716,`order` = 5 WHERE `admin_controls_methods`.`id` = 1716;
UPDATE `admin_controls_methods` SET `id` = 1717,`order` = 0 WHERE `admin_controls_methods`.`id` = 1717;
UPDATE `admin_controls_methods` SET `id` = 1718,`order` = 0 WHERE `admin_controls_methods`.`id` = 1718;
UPDATE `admin_controls_methods` SET `id` = 1719,`order` = 7 WHERE `admin_controls_methods`.`id` = 1719;
UPDATE `admin_controls_methods` SET `id` = 1720,`order` = 8 WHERE `admin_controls_methods`.`id` = 1720;
UPDATE `admin_controls_methods` SET `id` = 1721,`order` = 6 WHERE `admin_controls_methods`.`id` = 1721;
UPDATE `admin_controls_methods` SET `id` = 1722,`order` = 9 WHERE `admin_controls_methods`.`id` = 1722;
UPDATE `admin_controls_methods` SET `id` = 1723,`order` = 11 WHERE `admin_controls_methods`.`id` = 1723;
UPDATE `admin_controls_methods` SET `id` = 1724,`order` = 12 WHERE `admin_controls_methods`.`id` = 1724;
UPDATE `admin_controls_methods` SET `id` = 1725,`order` = 13 WHERE `admin_controls_methods`.`id` = 1725;
UPDATE `admin_controls_methods` SET `id` = 1727,`order` = 5 WHERE `admin_controls_methods`.`id` = 1727;
UPDATE `admin_controls_methods` SET `id` = 1728,`order` = 21 WHERE `admin_controls_methods`.`id` = 1728;
UPDATE `admin_controls_methods` SET `id` = 1730,`order` = 7 WHERE `admin_controls_methods`.`id` = 1730;
UPDATE `admin_controls_methods` SET `id` = 1731,`order` = 8 WHERE `admin_controls_methods`.`id` = 1731;
UPDATE `admin_controls_methods` SET `id` = 1732,`order` = 10 WHERE `admin_controls_methods`.`id` = 1732;
UPDATE `admin_controls_methods` SET `id` = 1757,`order` = 23 WHERE `admin_controls_methods`.`id` = 1757;
UPDATE `admin_controls_methods` SET `id` = 1734,`order` = 25 WHERE `admin_controls_methods`.`id` = 1734;
UPDATE `admin_controls_methods` SET `id` = 1735,`order` = 47 WHERE `admin_controls_methods`.`id` = 1735;
UPDATE `admin_controls_methods` SET `id` = 1736,`order` = 48 WHERE `admin_controls_methods`.`id` = 1736;
UPDATE `admin_controls_methods` SET `id` = 1737,`order` = 4 WHERE `admin_controls_methods`.`id` = 1737;
UPDATE `admin_controls_methods` SET `id` = 1738,`order` = 1 WHERE `admin_controls_methods`.`id` = 1738;
UPDATE `admin_controls_methods` SET `id` = 1739,`order` = 2 WHERE `admin_controls_methods`.`id` = 1739;
UPDATE `admin_controls_methods` SET `id` = 1740,`order` = 18 WHERE `admin_controls_methods`.`id` = 1740;
UPDATE `admin_controls_methods` SET `id` = 1741,`order` = 19 WHERE `admin_controls_methods`.`id` = 1741;
UPDATE `admin_controls_methods` SET `id` = 1742,`order` = 4 WHERE `admin_controls_methods`.`id` = 1742;
UPDATE `admin_controls_methods` SET `id` = 1743,`order` = 5 WHERE `admin_controls_methods`.`id` = 1743;
UPDATE `admin_controls_methods` SET `id` = 1744,`order` = 7 WHERE `admin_controls_methods`.`id` = 1744;
UPDATE `admin_controls_methods` SET `id` = 1745,`order` = 20 WHERE `admin_controls_methods`.`id` = 1745;
UPDATE `admin_controls_methods` SET `id` = 1746,`order` = 21 WHERE `admin_controls_methods`.`id` = 1746;
UPDATE `admin_controls_methods` SET `id` = 1747,`order` = 42 WHERE `admin_controls_methods`.`id` = 1747;
UPDATE `admin_controls_methods` SET `id` = 1748,`order` = 4 WHERE `admin_controls_methods`.`id` = 1748;
UPDATE `admin_controls_methods` SET `id` = 1749,`order` = 5 WHERE `admin_controls_methods`.`id` = 1749;
UPDATE `admin_controls_methods` SET `id` = 1750,`order` = 7 WHERE `admin_controls_methods`.`id` = 1750;
UPDATE `admin_controls_methods` SET `id` = 1751,`order` = 8 WHERE `admin_controls_methods`.`id` = 1751;
UPDATE `admin_controls_methods` SET `id` = 1752,`order` = 13 WHERE `admin_controls_methods`.`id` = 1752;
UPDATE `admin_controls_methods` SET `id` = 1753,`order` = 14 WHERE `admin_controls_methods`.`id` = 1753;
UPDATE `admin_controls_methods` SET `id` = 1754,`order` = 15 WHERE `admin_controls_methods`.`id` = 1754;
UPDATE `admin_controls_methods` SET `id` = 1755,`order` = 9 WHERE `admin_controls_methods`.`id` = 1755;
UPDATE `admin_controls_methods` SET `id` = 1756,`order` = 16 WHERE `admin_controls_methods`.`id` = 1756;
UPDATE `admin_controls_methods` SET `id` = 1766,`order` = 36 WHERE `admin_controls_methods`.`id` = 1766;
UPDATE `admin_controls_methods` SET `id` = 1820,`order` = 35 WHERE `admin_controls_methods`.`id` = 1820;
UPDATE `admin_controls_methods` SET `id` = 1821,`order` = 22 WHERE `admin_controls_methods`.`id` = 1821;
UPDATE `admin_controls_methods` SET `id` = 1822,`order` = 31 WHERE `admin_controls_methods`.`id` = 1822;
UPDATE `admin_controls_methods` SET `id` = 1823,`order` = 32 WHERE `admin_controls_methods`.`id` = 1823;
UPDATE `admin_controls_methods` SET `id` = 1824,`order` = 10 WHERE `admin_controls_methods`.`id` = 1824;
UPDATE `admin_controls_methods` SET `id` = 1825,`order` = 11 WHERE `admin_controls_methods`.`id` = 1825;
UPDATE `admin_controls_methods` SET `id` = 1826,`order` = 39 WHERE `admin_controls_methods`.`id` = 1826;
UPDATE `admin_controls_methods` SET `id` = 1827,`order` = 34 WHERE `admin_controls_methods`.`id` = 1827;
UPDATE `admin_controls_methods` SET `id` = 1828,`order` = 17 WHERE `admin_controls_methods`.`id` = 1828;
UPDATE `admin_controls_methods` SET `id` = 1864,`order` = 24 WHERE `admin_controls_methods`.`id` = 1864;
UPDATE `admin_controls_methods` SET `id` = 2755,`order` = 3 WHERE `admin_controls_methods`.`id` = 2755;
UPDATE `admin_controls_methods` SET `id` = 2751,`order` = 11 WHERE `admin_controls_methods`.`id` = 2751;
UPDATE `admin_controls_methods` SET `id` = 2552,`order` = 3 WHERE `admin_controls_methods`.`id` = 2552;
UPDATE `admin_controls_methods` SET `id` = 2551,`order` = 1 WHERE `admin_controls_methods`.`id` = 2551;
UPDATE `admin_controls_methods` SET `id` = 2550,`order` = 3 WHERE `admin_controls_methods`.`id` = 2550;
UPDATE `admin_controls_methods` SET `id` = 2549,`order` = 1 WHERE `admin_controls_methods`.`id` = 2549;
UPDATE `admin_controls_methods` SET `id` = 2025,`order` = 27 WHERE `admin_controls_methods`.`id` = 2025;
UPDATE `admin_controls_methods` SET `id` = 2026,`order` = 40 WHERE `admin_controls_methods`.`id` = 2026;
UPDATE `admin_controls_methods` SET `id` = 2027,`order` = 28 WHERE `admin_controls_methods`.`id` = 2027;
UPDATE `admin_controls_methods` SET `id` = 2028,`order` = 41 WHERE `admin_controls_methods`.`id` = 2028;
UPDATE `admin_controls_methods` SET `id` = 2029,`order` = 29 WHERE `admin_controls_methods`.`id` = 2029;
UPDATE `admin_controls_methods` SET `id` = 2030,`order` = 42 WHERE `admin_controls_methods`.`id` = 2030;
UPDATE `admin_controls_methods` SET `id` = 2031,`order` = 30 WHERE `admin_controls_methods`.`id` = 2031;
UPDATE `admin_controls_methods` SET `id` = 2032,`order` = 43 WHERE `admin_controls_methods`.`id` = 2032;
UPDATE `admin_controls_methods` SET `id` = 2033,`order` = 2 WHERE `admin_controls_methods`.`id` = 2033;
UPDATE `admin_controls_methods` SET `id` = 2034,`order` = 3 WHERE `admin_controls_methods`.`id` = 2034;
UPDATE `admin_controls_methods` SET `id` = 2035,`order` = 4 WHERE `admin_controls_methods`.`id` = 2035;
UPDATE `admin_controls_methods` SET `id` = 2036,`order` = 6 WHERE `admin_controls_methods`.`id` = 2036;
UPDATE `admin_controls_methods` SET `id` = 2037,`order` = 8 WHERE `admin_controls_methods`.`id` = 2037;
UPDATE `admin_controls_methods` SET `id` = 2038,`order` = 9 WHERE `admin_controls_methods`.`id` = 2038;
UPDATE `admin_controls_methods` SET `id` = 2039,`order` = 10 WHERE `admin_controls_methods`.`id` = 2039;
UPDATE `admin_controls_methods` SET `id` = 2040,`order` = 11 WHERE `admin_controls_methods`.`id` = 2040;
UPDATE `admin_controls_methods` SET `id` = 2041,`order` = 13 WHERE `admin_controls_methods`.`id` = 2041;
UPDATE `admin_controls_methods` SET `id` = 2042,`order` = 0 WHERE `admin_controls_methods`.`id` = 2042;
UPDATE `admin_controls_methods` SET `id` = 2043,`order` = 14 WHERE `admin_controls_methods`.`id` = 2043;
UPDATE `admin_controls_methods` SET `id` = 2044,`order` = 15 WHERE `admin_controls_methods`.`id` = 2044;
UPDATE `admin_controls_methods` SET `id` = 2045,`order` = 11 WHERE `admin_controls_methods`.`id` = 2045;
UPDATE `admin_controls_methods` SET `id` = 2046,`order` = 0 WHERE `admin_controls_methods`.`id` = 2046;
UPDATE `admin_controls_methods` SET `id` = 2047,`order` = 1 WHERE `admin_controls_methods`.`id` = 2047;
UPDATE `admin_controls_methods` SET `id` = 2048,`order` = 2 WHERE `admin_controls_methods`.`id` = 2048;
UPDATE `admin_controls_methods` SET `id` = 2049,`order` = 3 WHERE `admin_controls_methods`.`id` = 2049;
UPDATE `admin_controls_methods` SET `id` = 2050,`order` = 5 WHERE `admin_controls_methods`.`id` = 2050;
UPDATE `admin_controls_methods` SET `id` = 2051,`order` = 7 WHERE `admin_controls_methods`.`id` = 2051;
UPDATE `admin_controls_methods` SET `id` = 2052,`order` = 8 WHERE `admin_controls_methods`.`id` = 2052;
UPDATE `admin_controls_methods` SET `id` = 2053,`order` = 9 WHERE `admin_controls_methods`.`id` = 2053;
UPDATE `admin_controls_methods` SET `id` = 2054,`order` = 10 WHERE `admin_controls_methods`.`id` = 2054;
UPDATE `admin_controls_methods` SET `id` = 2055,`order` = 12 WHERE `admin_controls_methods`.`id` = 2055;
UPDATE `admin_controls_methods` SET `id` = 2056,`order` = 13 WHERE `admin_controls_methods`.`id` = 2056;
UPDATE `admin_controls_methods` SET `id` = 2057,`order` = 5 WHERE `admin_controls_methods`.`id` = 2057;
UPDATE `admin_controls_methods` SET `id` = 2058,`order` = 6 WHERE `admin_controls_methods`.`id` = 2058;
UPDATE `admin_controls_methods` SET `id` = 2059,`order` = 8 WHERE `admin_controls_methods`.`id` = 2059;
UPDATE `admin_controls_methods` SET `id` = 2060,`order` = 10 WHERE `admin_controls_methods`.`id` = 2060;
UPDATE `admin_controls_methods` SET `id` = 2061,`order` = 12 WHERE `admin_controls_methods`.`id` = 2061;
UPDATE `admin_controls_methods` SET `id` = 2062,`order` = 13 WHERE `admin_controls_methods`.`id` = 2062;
UPDATE `admin_controls_methods` SET `id` = 2063,`order` = 14 WHERE `admin_controls_methods`.`id` = 2063;
UPDATE `admin_controls_methods` SET `id` = 2064,`order` = 7 WHERE `admin_controls_methods`.`id` = 2064;
UPDATE `admin_controls_methods` SET `id` = 2065,`order` = 15 WHERE `admin_controls_methods`.`id` = 2065;
UPDATE `admin_controls_methods` SET `id` = 2067,`order` = 17 WHERE `admin_controls_methods`.`id` = 2067;
UPDATE `admin_controls_methods` SET `id` = 2068,`order` = 44 WHERE `admin_controls_methods`.`id` = 2068;
UPDATE `admin_controls_methods` SET `id` = 2069,`order` = 31 WHERE `admin_controls_methods`.`id` = 2069;
UPDATE `admin_controls_methods` SET `id` = 2070,`order` = 23 WHERE `admin_controls_methods`.`id` = 2070;
UPDATE `admin_controls_methods` SET `id` = 2071,`order` = 35 WHERE `admin_controls_methods`.`id` = 2071;
UPDATE `admin_controls_methods` SET `id` = 2072,`order` = 24 WHERE `admin_controls_methods`.`id` = 2072;
UPDATE `admin_controls_methods` SET `id` = 2073,`order` = 36 WHERE `admin_controls_methods`.`id` = 2073;
UPDATE `admin_controls_methods` SET `id` = 2074,`order` = 25 WHERE `admin_controls_methods`.`id` = 2074;
UPDATE `admin_controls_methods` SET `id` = 2075,`order` = 37 WHERE `admin_controls_methods`.`id` = 2075;
UPDATE `admin_controls_methods` SET `id` = 2076,`order` = 26 WHERE `admin_controls_methods`.`id` = 2076;
UPDATE `admin_controls_methods` SET `id` = 2077,`order` = 38 WHERE `admin_controls_methods`.`id` = 2077;
UPDATE `admin_controls_methods` SET `id` = 2078,`order` = 27 WHERE `admin_controls_methods`.`id` = 2078;
UPDATE `admin_controls_methods` SET `id` = 2079,`order` = 39 WHERE `admin_controls_methods`.`id` = 2079;
UPDATE `admin_controls_methods` SET `id` = 2080,`order` = 0 WHERE `admin_controls_methods`.`id` = 2080;
UPDATE `admin_controls_methods` SET `id` = 2081,`order` = 11 WHERE `admin_controls_methods`.`id` = 2081;
UPDATE `admin_controls_methods` SET `id` = 2082,`order` = 20 WHERE `admin_controls_methods`.`id` = 2082;
UPDATE `admin_controls_methods` SET `id` = 2083,`order` = 34 WHERE `admin_controls_methods`.`id` = 2083;
UPDATE `admin_controls_methods` SET `id` = 2084,`order` = 33 WHERE `admin_controls_methods`.`id` = 2084;
UPDATE `admin_controls_methods` SET `id` = 2085,`order` = 19 WHERE `admin_controls_methods`.`id` = 2085;
UPDATE `admin_controls_methods` SET `id` = 2086,`order` = 0 WHERE `admin_controls_methods`.`id` = 2086;
UPDATE `admin_controls_methods` SET `id` = 2087,`order` = 8 WHERE `admin_controls_methods`.`id` = 2087;
UPDATE `admin_controls_methods` SET `id` = 2088,`order` = 17 WHERE `admin_controls_methods`.`id` = 2088;
UPDATE `admin_controls_methods` SET `id` = 2089,`order` = 29 WHERE `admin_controls_methods`.`id` = 2089;
UPDATE `admin_controls_methods` SET `id` = 2090,`order` = 30 WHERE `admin_controls_methods`.`id` = 2090;
UPDATE `admin_controls_methods` SET `id` = 2091,`order` = 41 WHERE `admin_controls_methods`.`id` = 2091;
UPDATE `admin_controls_methods` SET `id` = 2097,`order` = 0 WHERE `admin_controls_methods`.`id` = 2097;
UPDATE `admin_controls_methods` SET `id` = 2095,`order` = 0 WHERE `admin_controls_methods`.`id` = 2095;
UPDATE `admin_controls_methods` SET `id` = 2560,`order` = 1 WHERE `admin_controls_methods`.`id` = 2560;
UPDATE `admin_controls_methods` SET `id` = 2558,`order` = 3 WHERE `admin_controls_methods`.`id` = 2558;
UPDATE `admin_controls_methods` SET `id` = 2557,`order` = 1 WHERE `admin_controls_methods`.`id` = 2557;
UPDATE `admin_controls_methods` SET `id` = 2556,`order` = 2 WHERE `admin_controls_methods`.`id` = 2556;
UPDATE `admin_controls_methods` SET `id` = 2110,`order` = 32 WHERE `admin_controls_methods`.`id` = 2110;
UPDATE `admin_controls_methods` SET `id` = 2111,`order` = 45 WHERE `admin_controls_methods`.`id` = 2111;
UPDATE `admin_controls_methods` SET `id` = 2112,`order` = 28 WHERE `admin_controls_methods`.`id` = 2112;
UPDATE `admin_controls_methods` SET `id` = 2113,`order` = 40 WHERE `admin_controls_methods`.`id` = 2113;
UPDATE `admin_controls_methods` SET `id` = 2120,`order` = 0 WHERE `admin_controls_methods`.`id` = 2120;
UPDATE `admin_controls_methods` SET `id` = 2121,`order` = 1 WHERE `admin_controls_methods`.`id` = 2121;
UPDATE `admin_controls_methods` SET `id` = 2122,`order` = 4 WHERE `admin_controls_methods`.`id` = 2122;
UPDATE `admin_controls_methods` SET `id` = 2123,`order` = 5 WHERE `admin_controls_methods`.`id` = 2123;
UPDATE `admin_controls_methods` SET `id` = 2124,`order` = 12 WHERE `admin_controls_methods`.`id` = 2124;
UPDATE `admin_controls_methods` SET `id` = 2125,`order` = 13 WHERE `admin_controls_methods`.`id` = 2125;
UPDATE `admin_controls_methods` SET `id` = 2126,`order` = 14 WHERE `admin_controls_methods`.`id` = 2126;
UPDATE `admin_controls_methods` SET `id` = 2128,`order` = 0 WHERE `admin_controls_methods`.`id` = 2128;
UPDATE `admin_controls_methods` SET `id` = 2129,`order` = 1 WHERE `admin_controls_methods`.`id` = 2129;
UPDATE `admin_controls_methods` SET `id` = 2130,`order` = 2 WHERE `admin_controls_methods`.`id` = 2130;
UPDATE `admin_controls_methods` SET `id` = 2131,`order` = 3 WHERE `admin_controls_methods`.`id` = 2131;
UPDATE `admin_controls_methods` SET `id` = 2132,`order` = 4 WHERE `admin_controls_methods`.`id` = 2132;
UPDATE `admin_controls_methods` SET `id` = 2133,`order` = 6 WHERE `admin_controls_methods`.`id` = 2133;
UPDATE `admin_controls_methods` SET `id` = 2324,`order` = 18 WHERE `admin_controls_methods`.`id` = 2324;
UPDATE `admin_controls_methods` SET `id` = 2325,`order` = 19 WHERE `admin_controls_methods`.`id` = 2325;
UPDATE `admin_controls_methods` SET `id` = 2171,`order` = 5 WHERE `admin_controls_methods`.`id` = 2171;
UPDATE `admin_controls_methods` SET `id` = 2172,`order` = 6 WHERE `admin_controls_methods`.`id` = 2172;
UPDATE `admin_controls_methods` SET `id` = 2175,`order` = 4 WHERE `admin_controls_methods`.`id` = 2175;
UPDATE `admin_controls_methods` SET `id` = 2176,`order` = 7 WHERE `admin_controls_methods`.`id` = 2176;
UPDATE `admin_controls_methods` SET `id` = 2177,`order` = 8 WHERE `admin_controls_methods`.`id` = 2177;
UPDATE `admin_controls_methods` SET `id` = 2178,`order` = 9 WHERE `admin_controls_methods`.`id` = 2178;
UPDATE `admin_controls_methods` SET `id` = 2179,`order` = 14 WHERE `admin_controls_methods`.`id` = 2179;
UPDATE `admin_controls_methods` SET `id` = 2180,`order` = 11 WHERE `admin_controls_methods`.`id` = 2180;
UPDATE `admin_controls_methods` SET `id` = 2181,`order` = 13 WHERE `admin_controls_methods`.`id` = 2181;
UPDATE `admin_controls_methods` SET `id` = 2182,`order` = 10 WHERE `admin_controls_methods`.`id` = 2182;
UPDATE `admin_controls_methods` SET `id` = 2183,`order` = 15 WHERE `admin_controls_methods`.`id` = 2183;
UPDATE `admin_controls_methods` SET `id` = 2184,`order` = 17 WHERE `admin_controls_methods`.`id` = 2184;
UPDATE `admin_controls_methods` SET `id` = 2185,`order` = 16 WHERE `admin_controls_methods`.`id` = 2185;
UPDATE `admin_controls_methods` SET `id` = 2186,`order` = 0 WHERE `admin_controls_methods`.`id` = 2186;
UPDATE `admin_controls_methods` SET `id` = 2190,`order` = 9 WHERE `admin_controls_methods`.`id` = 2190;
UPDATE `admin_controls_methods` SET `id` = 2191,`order` = 9 WHERE `admin_controls_methods`.`id` = 2191;
UPDATE `admin_controls_methods` SET `id` = 2192,`order` = 14 WHERE `admin_controls_methods`.`id` = 2192;
UPDATE `admin_controls_methods` SET `id` = 2193,`order` = 12 WHERE `admin_controls_methods`.`id` = 2193;
UPDATE `admin_controls_methods` SET `id` = 2194,`order` = 11 WHERE `admin_controls_methods`.`id` = 2194;
UPDATE `admin_controls_methods` SET `id` = 2195,`order` = 16 WHERE `admin_controls_methods`.`id` = 2195;
UPDATE `admin_controls_methods` SET `id` = 2198,`order` = 37 WHERE `admin_controls_methods`.`id` = 2198;
UPDATE `admin_controls_methods` SET `id` = 2200,`order` = 33 WHERE `admin_controls_methods`.`id` = 2200;
UPDATE `admin_controls_methods` SET `id` = 2216,`order` = 12 WHERE `admin_controls_methods`.`id` = 2216;
UPDATE `admin_controls_methods` SET `id` = 2219,`order` = 26 WHERE `admin_controls_methods`.`id` = 2219;
UPDATE `admin_controls_methods` SET `id` = 2252,`order` = 13 WHERE `admin_controls_methods`.`id` = 2252;
UPDATE `admin_controls_methods` SET `id` = 2253,`order` = 10 WHERE `admin_controls_methods`.`id` = 2253;
UPDATE `admin_controls_methods` SET `id` = 2222,`order` = 9 WHERE `admin_controls_methods`.`id` = 2222;
UPDATE `admin_controls_methods` SET `id` = 2230,`order` = 6 WHERE `admin_controls_methods`.`id` = 2230;
UPDATE `admin_controls_methods` SET `id` = 2231,`order` = 22 WHERE `admin_controls_methods`.`id` = 2231;
UPDATE `admin_controls_methods` SET `id` = 2232,`order` = 2 WHERE `admin_controls_methods`.`id` = 2232;
UPDATE `admin_controls_methods` SET `id` = 2233,`order` = 12 WHERE `admin_controls_methods`.`id` = 2233;
UPDATE `admin_controls_methods` SET `id` = 2234,`order` = 46 WHERE `admin_controls_methods`.`id` = 2234;
UPDATE `admin_controls_methods` SET `id` = 2235,`order` = 14 WHERE `admin_controls_methods`.`id` = 2235;
UPDATE `admin_controls_methods` SET `id` = 2236,`order` = 15 WHERE `admin_controls_methods`.`id` = 2236;
UPDATE `admin_controls_methods` SET `id` = 2237,`order` = 16 WHERE `admin_controls_methods`.`id` = 2237;
UPDATE `admin_controls_methods` SET `id` = 2239,`order` = 17 WHERE `admin_controls_methods`.`id` = 2239;
UPDATE `admin_controls_methods` SET `id` = 2240,`order` = 18 WHERE `admin_controls_methods`.`id` = 2240;
UPDATE `admin_controls_methods` SET `id` = 2243,`order` = 9 WHERE `admin_controls_methods`.`id` = 2243;
UPDATE `admin_controls_methods` SET `id` = 2244,`order` = 16 WHERE `admin_controls_methods`.`id` = 2244;
UPDATE `admin_controls_methods` SET `id` = 2245,`order` = 11 WHERE `admin_controls_methods`.`id` = 2245;
UPDATE `admin_controls_methods` SET `id` = 2246,`order` = 12 WHERE `admin_controls_methods`.`id` = 2246;
UPDATE `admin_controls_methods` SET `id` = 2247,`order` = 13 WHERE `admin_controls_methods`.`id` = 2247;
UPDATE `admin_controls_methods` SET `id` = 2248,`order` = 14 WHERE `admin_controls_methods`.`id` = 2248;
UPDATE `admin_controls_methods` SET `id` = 2249,`order` = 15 WHERE `admin_controls_methods`.`id` = 2249;
UPDATE `admin_controls_methods` SET `id` = 2266,`order` = 3 WHERE `admin_controls_methods`.`id` = 2266;
UPDATE `admin_controls_methods` SET `id` = 2267,`order` = 1 WHERE `admin_controls_methods`.`id` = 2267;
UPDATE `admin_controls_methods` SET `id` = 2555,`order` = 4 WHERE `admin_controls_methods`.`id` = 2555;
UPDATE `admin_controls_methods` SET `id` = 2553,`order` = 4 WHERE `admin_controls_methods`.`id` = 2553;
UPDATE `admin_controls_methods` SET `id` = 2278,`order` = 2 WHERE `admin_controls_methods`.`id` = 2278;
UPDATE `admin_controls_methods` SET `id` = 2281,`order` = 5 WHERE `admin_controls_methods`.`id` = 2281;
UPDATE `admin_controls_methods` SET `id` = 2282,`order` = 1 WHERE `admin_controls_methods`.`id` = 2282;
UPDATE `admin_controls_methods` SET `id` = 2283,`order` = 4 WHERE `admin_controls_methods`.`id` = 2283;
UPDATE `admin_controls_methods` SET `id` = 2284,`order` = 9 WHERE `admin_controls_methods`.`id` = 2284;
UPDATE `admin_controls_methods` SET `id` = 2328,`order` = 0 WHERE `admin_controls_methods`.`id` = 2328;
UPDATE `admin_controls_methods` SET `id` = 2335,`order` = 0 WHERE `admin_controls_methods`.`id` = 2335;
UPDATE `admin_controls_methods` SET `id` = 2491,`order` = 12 WHERE `admin_controls_methods`.`id` = 2491;
UPDATE `admin_controls_methods` SET `id` = 2395,`order` = 9 WHERE `admin_controls_methods`.`id` = 2395;
UPDATE `admin_controls_methods` SET `id` = 2396,`order` = 10 WHERE `admin_controls_methods`.`id` = 2396;
UPDATE `admin_controls_methods` SET `id` = 2695,`order` = 5 WHERE `admin_controls_methods`.`id` = 2695;
UPDATE `admin_controls_methods` SET `id` = 2696,`order` = 5 WHERE `admin_controls_methods`.`id` = 2696;
UPDATE `admin_controls_methods` SET `id` = 2697,`order` = 10 WHERE `admin_controls_methods`.`id` = 2697;
UPDATE `admin_controls_methods` SET `id` = 2698,`order` = 6 WHERE `admin_controls_methods`.`id` = 2698;
UPDATE `admin_controls_methods` SET `id` = 2699,`order` = 3 WHERE `admin_controls_methods`.`id` = 2699;
UPDATE `admin_controls_methods` SET `id` = 2700,`order` = 6 WHERE `admin_controls_methods`.`id` = 2700;
UPDATE `admin_controls_methods` SET `id` = 2701,`order` = 2 WHERE `admin_controls_methods`.`id` = 2701;
UPDATE `admin_controls_methods` SET `id` = 2702,`order` = 7 WHERE `admin_controls_methods`.`id` = 2702;
UPDATE `admin_controls_methods` SET `id` = 2703,`order` = 2 WHERE `admin_controls_methods`.`id` = 2703;
UPDATE `admin_controls_methods` SET `id` = 2704,`order` = 6 WHERE `admin_controls_methods`.`id` = 2704;
UPDATE `admin_controls_methods` SET `id` = 2705,`order` = 3 WHERE `admin_controls_methods`.`id` = 2705;
UPDATE `admin_controls_methods` SET `id` = 2706,`order` = 11 WHERE `admin_controls_methods`.`id` = 2706;
UPDATE `admin_controls_methods` SET `id` = 2707,`order` = 0 WHERE `admin_controls_methods`.`id` = 2707;
UPDATE `admin_controls_methods` SET `id` = 2708,`order` = 3 WHERE `admin_controls_methods`.`id` = 2708;
UPDATE `admin_controls_methods` SET `id` = 2709,`order` = 1 WHERE `admin_controls_methods`.`id` = 2709;
UPDATE `admin_controls_methods` SET `id` = 2710,`order` = 17 WHERE `admin_controls_methods`.`id` = 2710;
UPDATE `admin_controls_methods` SET `id` = 2766,`order` = 23 WHERE `admin_controls_methods`.`id` = 2766;
UPDATE `admin_controls_methods` SET `id` = 2757,`order` = 15 WHERE `admin_controls_methods`.`id` = 2757;
UPDATE `admin_controls_methods` SET `id` = 2758,`order` = 16 WHERE `admin_controls_methods`.`id` = 2758;
UPDATE `admin_controls_methods` SET `id` = 2759,`order` = 24 WHERE `admin_controls_methods`.`id` = 2759;
UPDATE `admin_controls_methods` SET `id` = 2760,`order` = 17 WHERE `admin_controls_methods`.`id` = 2760;
UPDATE `admin_controls_methods` SET `id` = 2761,`order` = 18 WHERE `admin_controls_methods`.`id` = 2761;
UPDATE `admin_controls_methods` SET `id` = 2762,`order` = 19 WHERE `admin_controls_methods`.`id` = 2762;
UPDATE `admin_controls_methods` SET `id` = 2763,`order` = 20 WHERE `admin_controls_methods`.`id` = 2763;
UPDATE `admin_controls_methods` SET `id` = 2764,`order` = 21 WHERE `admin_controls_methods`.`id` = 2764;
UPDATE `admin_controls_methods` SET `id` = 2750,`order` = 1 WHERE `admin_controls_methods`.`id` = 2750;
UPDATE `admin_controls_methods` SET `id` = 2765,`order` = 22 WHERE `admin_controls_methods`.`id` = 2765;
UPDATE `admin_controls_methods` SET `id` = 2756,`order` = 2 WHERE `admin_controls_methods`.`id` = 2756;
UPDATE `admin_controls_methods` SET `id` = 2711,`order` = 4 WHERE `admin_controls_methods`.`id` = 2711;
UPDATE `admin_controls_methods` SET `id` = 2712,`order` = 5 WHERE `admin_controls_methods`.`id` = 2712;
UPDATE `admin_controls_methods` SET `id` = 2713,`order` = 6 WHERE `admin_controls_methods`.`id` = 2713;
UPDATE `admin_controls_methods` SET `id` = 2714,`order` = 7 WHERE `admin_controls_methods`.`id` = 2714;
UPDATE `admin_controls_methods` SET `id` = 2715,`order` = 8 WHERE `admin_controls_methods`.`id` = 2715;
UPDATE `admin_controls_methods` SET `id` = 2716,`order` = 3 WHERE `admin_controls_methods`.`id` = 2716;
UPDATE `admin_controls_methods` SET `id` = 2717,`order` = 9 WHERE `admin_controls_methods`.`id` = 2717;
UPDATE `admin_controls_methods` SET `id` = 2718,`order` = 10 WHERE `admin_controls_methods`.`id` = 2718;
UPDATE `admin_controls_methods` SET `id` = 2719,`order` = 11 WHERE `admin_controls_methods`.`id` = 2719;
UPDATE `admin_controls_methods` SET `id` = 2720,`order` = 12 WHERE `admin_controls_methods`.`id` = 2720;
UPDATE `admin_controls_methods` SET `id` = 2721,`order` = 13 WHERE `admin_controls_methods`.`id` = 2721;
UPDATE `admin_controls_methods` SET `id` = 2722,`order` = 14 WHERE `admin_controls_methods`.`id` = 2722;
UPDATE `admin_controls_methods` SET `id` = 2723,`order` = 25 WHERE `admin_controls_methods`.`id` = 2723;
UPDATE `admin_controls_methods` SET `id` = 2724,`order` = 26 WHERE `admin_controls_methods`.`id` = 2724;
UPDATE `admin_controls_methods` SET `id` = 2749,`order` = 0 WHERE `admin_controls_methods`.`id` = 2749;
UPDATE `admin_controls_methods` SET `id` = 2767,`order` = 0 WHERE `admin_controls_methods`.`id` = 2767;
UPDATE `admin_controls_methods` SET `id` = 2768,`order` = 13 WHERE `admin_controls_methods`.`id` = 2768;
UPDATE `admin_controls_methods` SET `id` = 2769,`order` = 14 WHERE `admin_controls_methods`.`id` = 2769;
UPDATE `admin_controls_methods` SET `id` = 2770,`order` = 22 WHERE `admin_controls_methods`.`id` = 2770;
UPDATE `admin_controls_methods` SET `id` = 2725,`order` = 1 WHERE `admin_controls_methods`.`id` = 2725;
UPDATE `admin_controls_methods` SET `id` = 2726,`order` = 2 WHERE `admin_controls_methods`.`id` = 2726;
UPDATE `admin_controls_methods` SET `id` = 2727,`order` = 3 WHERE `admin_controls_methods`.`id` = 2727;
UPDATE `admin_controls_methods` SET `id` = 2728,`order` = 4 WHERE `admin_controls_methods`.`id` = 2728;
UPDATE `admin_controls_methods` SET `id` = 2729,`order` = 5 WHERE `admin_controls_methods`.`id` = 2729;
UPDATE `admin_controls_methods` SET `id` = 2730,`order` = 6 WHERE `admin_controls_methods`.`id` = 2730;
UPDATE `admin_controls_methods` SET `id` = 2731,`order` = 7 WHERE `admin_controls_methods`.`id` = 2731;
UPDATE `admin_controls_methods` SET `id` = 2732,`order` = 8 WHERE `admin_controls_methods`.`id` = 2732;
UPDATE `admin_controls_methods` SET `id` = 2733,`order` = 9 WHERE `admin_controls_methods`.`id` = 2733;
UPDATE `admin_controls_methods` SET `id` = 2735,`order` = 10 WHERE `admin_controls_methods`.`id` = 2735;
UPDATE `admin_controls_methods` SET `id` = 2736,`order` = 11 WHERE `admin_controls_methods`.`id` = 2736;
UPDATE `admin_controls_methods` SET `id` = 2737,`order` = 12 WHERE `admin_controls_methods`.`id` = 2737;
UPDATE `admin_controls_methods` SET `id` = 2738,`order` = 23 WHERE `admin_controls_methods`.`id` = 2738;
UPDATE `admin_controls_methods` SET `id` = 2771,`order` = 15 WHERE `admin_controls_methods`.`id` = 2771;
UPDATE `admin_controls_methods` SET `id` = 2772,`order` = 16 WHERE `admin_controls_methods`.`id` = 2772;
UPDATE `admin_controls_methods` SET `id` = 2773,`order` = 17 WHERE `admin_controls_methods`.`id` = 2773;
UPDATE `admin_controls_methods` SET `id` = 2774,`order` = 18 WHERE `admin_controls_methods`.`id` = 2774;
UPDATE `admin_controls_methods` SET `id` = 2775,`order` = 19 WHERE `admin_controls_methods`.`id` = 2775;
UPDATE `admin_controls_methods` SET `id` = 2776,`order` = 20 WHERE `admin_controls_methods`.`id` = 2776;
UPDATE `admin_controls_methods` SET `id` = 2777,`order` = 21 WHERE `admin_controls_methods`.`id` = 2777;
UPDATE `admin_controls_methods` SET `id` = 2563,`order` = 6 WHERE `admin_controls_methods`.`id` = 2563;
UPDATE `admin_controls_methods` SET `id` = 2564,`order` = 7 WHERE `admin_controls_methods`.`id` = 2564;
UPDATE `admin_controls_methods` SET `id` = 2586,`order` = 5 WHERE `admin_controls_methods`.`id` = 2586;
UPDATE `admin_controls_methods` SET `id` = 2538,`order` = 8 WHERE `admin_controls_methods`.`id` = 2538;
UPDATE `admin_controls_methods` SET `id` = 2537,`order` = 2 WHERE `admin_controls_methods`.`id` = 2537;
UPDATE `admin_controls_methods` SET `id` = 2397,`order` = 9 WHERE `admin_controls_methods`.`id` = 2397;
UPDATE `admin_controls_methods` SET `id` = 2505,`order` = 23 WHERE `admin_controls_methods`.`id` = 2505;
UPDATE `admin_controls_methods` SET `id` = 2303,`order` = 3 WHERE `admin_controls_methods`.`id` = 2303;
UPDATE `admin_controls_methods` SET `id` = 2304,`order` = 4 WHERE `admin_controls_methods`.`id` = 2304;
UPDATE `admin_controls_methods` SET `id` = 2398,`order` = 24 WHERE `admin_controls_methods`.`id` = 2398;
UPDATE `admin_controls_methods` SET `id` = 2399,`order` = 67 WHERE `admin_controls_methods`.`id` = 2399;
UPDATE `admin_controls_methods` SET `id` = 2400,`order` = 70 WHERE `admin_controls_methods`.`id` = 2400;
UPDATE `admin_controls_methods` SET `id` = 2401,`order` = 71 WHERE `admin_controls_methods`.`id` = 2401;
UPDATE `admin_controls_methods` SET `id` = 2402,`order` = 73 WHERE `admin_controls_methods`.`id` = 2402;
UPDATE `admin_controls_methods` SET `id` = 2403,`order` = 74 WHERE `admin_controls_methods`.`id` = 2403;
UPDATE `admin_controls_methods` SET `id` = 2404,`order` = 77 WHERE `admin_controls_methods`.`id` = 2404;
UPDATE `admin_controls_methods` SET `id` = 2405,`order` = 41 WHERE `admin_controls_methods`.`id` = 2405;
UPDATE `admin_controls_methods` SET `id` = 2406,`order` = 66 WHERE `admin_controls_methods`.`id` = 2406;
UPDATE `admin_controls_methods` SET `id` = 2407,`order` = 82 WHERE `admin_controls_methods`.`id` = 2407;
UPDATE `admin_controls_methods` SET `id` = 2408,`order` = 107 WHERE `admin_controls_methods`.`id` = 2408;
UPDATE `admin_controls_methods` SET `id` = 2409,`order` = 63 WHERE `admin_controls_methods`.`id` = 2409;
UPDATE `admin_controls_methods` SET `id` = 2410,`order` = 65 WHERE `admin_controls_methods`.`id` = 2410;
UPDATE `admin_controls_methods` SET `id` = 2412,`order` = 10 WHERE `admin_controls_methods`.`id` = 2412;
UPDATE `admin_controls_methods` SET `id` = 2413,`order` = 16 WHERE `admin_controls_methods`.`id` = 2413;
UPDATE `admin_controls_methods` SET `id` = 2414,`order` = 15 WHERE `admin_controls_methods`.`id` = 2414;
UPDATE `admin_controls_methods` SET `id` = 2415,`order` = 11 WHERE `admin_controls_methods`.`id` = 2415;
UPDATE `admin_controls_methods` SET `id` = 2416,`order` = 14 WHERE `admin_controls_methods`.`id` = 2416;
UPDATE `admin_controls_methods` SET `id` = 2417,`order` = 108 WHERE `admin_controls_methods`.`id` = 2417;
UPDATE `admin_controls_methods` SET `id` = 2418,`order` = 1 WHERE `admin_controls_methods`.`id` = 2418;
UPDATE `admin_controls_methods` SET `id` = 2422,`order` = 109 WHERE `admin_controls_methods`.`id` = 2422;
UPDATE `admin_controls_methods` SET `id` = 2421,`order` = 0 WHERE `admin_controls_methods`.`id` = 2421;
UPDATE `admin_controls_methods` SET `id` = 2423,`order` = 68 WHERE `admin_controls_methods`.`id` = 2423;
UPDATE `admin_controls_methods` SET `id` = 2425,`order` = 69 WHERE `admin_controls_methods`.`id` = 2425;
UPDATE `admin_controls_methods` SET `id` = 2450,`order` = 83 WHERE `admin_controls_methods`.`id` = 2450;
UPDATE `admin_controls_methods` SET `id` = 2427,`order` = 30 WHERE `admin_controls_methods`.`id` = 2427;
UPDATE `admin_controls_methods` SET `id` = 2428,`order` = 40 WHERE `admin_controls_methods`.`id` = 2428;
UPDATE `admin_controls_methods` SET `id` = 2429,`order` = 31 WHERE `admin_controls_methods`.`id` = 2429;
UPDATE `admin_controls_methods` SET `id` = 2430,`order` = 34 WHERE `admin_controls_methods`.`id` = 2430;
UPDATE `admin_controls_methods` SET `id` = 2431,`order` = 35 WHERE `admin_controls_methods`.`id` = 2431;
UPDATE `admin_controls_methods` SET `id` = 2432,`order` = 36 WHERE `admin_controls_methods`.`id` = 2432;
UPDATE `admin_controls_methods` SET `id` = 2433,`order` = 37 WHERE `admin_controls_methods`.`id` = 2433;
UPDATE `admin_controls_methods` SET `id` = 2434,`order` = 38 WHERE `admin_controls_methods`.`id` = 2434;
UPDATE `admin_controls_methods` SET `id` = 2435,`order` = 39 WHERE `admin_controls_methods`.`id` = 2435;
UPDATE `admin_controls_methods` SET `id` = 2436,`order` = 52 WHERE `admin_controls_methods`.`id` = 2436;
UPDATE `admin_controls_methods` SET `id` = 2437,`order` = 51 WHERE `admin_controls_methods`.`id` = 2437;
UPDATE `admin_controls_methods` SET `id` = 2444,`order` = 62 WHERE `admin_controls_methods`.`id` = 2444;
UPDATE `admin_controls_methods` SET `id` = 2445,`order` = 61 WHERE `admin_controls_methods`.`id` = 2445;
UPDATE `admin_controls_methods` SET `id` = 2446,`order` = 54 WHERE `admin_controls_methods`.`id` = 2446;
UPDATE `admin_controls_methods` SET `id` = 2447,`order` = 56 WHERE `admin_controls_methods`.`id` = 2447;
UPDATE `admin_controls_methods` SET `id` = 2448,`order` = 13 WHERE `admin_controls_methods`.`id` = 2448;
UPDATE `admin_controls_methods` SET `id` = 2449,`order` = 17 WHERE `admin_controls_methods`.`id` = 2449;
UPDATE `admin_controls_methods` SET `id` = 2452,`order` = 20 WHERE `admin_controls_methods`.`id` = 2452;
UPDATE `admin_controls_methods` SET `id` = 2453,`order` = 12 WHERE `admin_controls_methods`.`id` = 2453;
UPDATE `admin_controls_methods` SET `id` = 2454,`order` = 84 WHERE `admin_controls_methods`.`id` = 2454;
UPDATE `admin_controls_methods` SET `id` = 2455,`order` = 86 WHERE `admin_controls_methods`.`id` = 2455;
UPDATE `admin_controls_methods` SET `id` = 2456,`order` = 87 WHERE `admin_controls_methods`.`id` = 2456;
UPDATE `admin_controls_methods` SET `id` = 2457,`order` = 88 WHERE `admin_controls_methods`.`id` = 2457;
UPDATE `admin_controls_methods` SET `id` = 2458,`order` = 89 WHERE `admin_controls_methods`.`id` = 2458;
UPDATE `admin_controls_methods` SET `id` = 2459,`order` = 90 WHERE `admin_controls_methods`.`id` = 2459;
UPDATE `admin_controls_methods` SET `id` = 2460,`order` = 91 WHERE `admin_controls_methods`.`id` = 2460;
UPDATE `admin_controls_methods` SET `id` = 2461,`order` = 92 WHERE `admin_controls_methods`.`id` = 2461;
UPDATE `admin_controls_methods` SET `id` = 2462,`order` = 94 WHERE `admin_controls_methods`.`id` = 2462;
UPDATE `admin_controls_methods` SET `id` = 2463,`order` = 95 WHERE `admin_controls_methods`.`id` = 2463;
UPDATE `admin_controls_methods` SET `id` = 2464,`order` = 96 WHERE `admin_controls_methods`.`id` = 2464;
UPDATE `admin_controls_methods` SET `id` = 2465,`order` = 93 WHERE `admin_controls_methods`.`id` = 2465;
UPDATE `admin_controls_methods` SET `id` = 2466,`order` = 97 WHERE `admin_controls_methods`.`id` = 2466;
UPDATE `admin_controls_methods` SET `id` = 2467,`order` = 98 WHERE `admin_controls_methods`.`id` = 2467;
UPDATE `admin_controls_methods` SET `id` = 2468,`order` = 99 WHERE `admin_controls_methods`.`id` = 2468;
UPDATE `admin_controls_methods` SET `id` = 2469,`order` = 100 WHERE `admin_controls_methods`.`id` = 2469;
UPDATE `admin_controls_methods` SET `id` = 2470,`order` = 101 WHERE `admin_controls_methods`.`id` = 2470;
UPDATE `admin_controls_methods` SET `id` = 2471,`order` = 102 WHERE `admin_controls_methods`.`id` = 2471;
UPDATE `admin_controls_methods` SET `id` = 2472,`order` = 103 WHERE `admin_controls_methods`.`id` = 2472;
UPDATE `admin_controls_methods` SET `id` = 2473,`order` = 33 WHERE `admin_controls_methods`.`id` = 2473;
UPDATE `admin_controls_methods` SET `id` = 2474,`order` = 21 WHERE `admin_controls_methods`.`id` = 2474;
UPDATE `admin_controls_methods` SET `id` = 2475,`order` = 18 WHERE `admin_controls_methods`.`id` = 2475;
UPDATE `admin_controls_methods` SET `id` = 2476,`order` = 19 WHERE `admin_controls_methods`.`id` = 2476;
UPDATE `admin_controls_methods` SET `id` = 2477,`order` = 72 WHERE `admin_controls_methods`.`id` = 2477;
UPDATE `admin_controls_methods` SET `id` = 2478,`order` = 48 WHERE `admin_controls_methods`.`id` = 2478;
UPDATE `admin_controls_methods` SET `id` = 2479,`order` = 49 WHERE `admin_controls_methods`.`id` = 2479;
UPDATE `admin_controls_methods` SET `id` = 2481,`order` = 75 WHERE `admin_controls_methods`.`id` = 2481;
UPDATE `admin_controls_methods` SET `id` = 2482,`order` = 55 WHERE `admin_controls_methods`.`id` = 2482;
UPDATE `admin_controls_methods` SET `id` = 2483,`order` = 76 WHERE `admin_controls_methods`.`id` = 2483;
UPDATE `admin_controls_methods` SET `id` = 2484,`order` = 78 WHERE `admin_controls_methods`.`id` = 2484;
UPDATE `admin_controls_methods` SET `id` = 2485,`order` = 79 WHERE `admin_controls_methods`.`id` = 2485;
UPDATE `admin_controls_methods` SET `id` = 2486,`order` = 80 WHERE `admin_controls_methods`.`id` = 2486;
UPDATE `admin_controls_methods` SET `id` = 2487,`order` = 81 WHERE `admin_controls_methods`.`id` = 2487;
UPDATE `admin_controls_methods` SET `id` = 2488,`order` = 22 WHERE `admin_controls_methods`.`id` = 2488;
UPDATE `admin_controls_methods` SET `id` = 2489,`order` = 32 WHERE `admin_controls_methods`.`id` = 2489;
UPDATE `admin_controls_methods` SET `id` = 2492,`order` = 57 WHERE `admin_controls_methods`.`id` = 2492;
UPDATE `admin_controls_methods` SET `id` = 2493,`order` = 59 WHERE `admin_controls_methods`.`id` = 2493;
UPDATE `admin_controls_methods` SET `id` = 2494,`order` = 26 WHERE `admin_controls_methods`.`id` = 2494;
UPDATE `admin_controls_methods` SET `id` = 2495,`order` = 58 WHERE `admin_controls_methods`.`id` = 2495;
UPDATE `admin_controls_methods` SET `id` = 2496,`order` = 60 WHERE `admin_controls_methods`.`id` = 2496;
UPDATE `admin_controls_methods` SET `id` = 2497,`order` = 25 WHERE `admin_controls_methods`.`id` = 2497;
UPDATE `admin_controls_methods` SET `id` = 2498,`order` = 29 WHERE `admin_controls_methods`.`id` = 2498;
UPDATE `admin_controls_methods` SET `id` = 2499,`order` = 27 WHERE `admin_controls_methods`.`id` = 2499;
UPDATE `admin_controls_methods` SET `id` = 2500,`order` = 28 WHERE `admin_controls_methods`.`id` = 2500;
UPDATE `admin_controls_methods` SET `id` = 2504,`order` = 53 WHERE `admin_controls_methods`.`id` = 2504;
UPDATE `admin_controls_methods` SET `id` = 2503,`order` = 85 WHERE `admin_controls_methods`.`id` = 2503;
UPDATE `admin_controls_methods` SET `id` = 2628,`order` = 104 WHERE `admin_controls_methods`.`id` = 2628;
UPDATE `admin_controls_methods` SET `id` = 2629,`order` = 106 WHERE `admin_controls_methods`.`id` = 2629;
UPDATE `admin_controls_methods` SET `id` = 2630,`order` = 105 WHERE `admin_controls_methods`.`id` = 2630;
UPDATE `admin_controls_methods` SET `id` = 2694,`order` = 64 WHERE `admin_controls_methods`.`id` = 2694;
UPDATE `admin_controls_methods` SET `id` = 2723,`order` = 26 WHERE `admin_controls_methods`.`id` = 2723;
UPDATE `admin_controls_methods` SET `id` = 2724,`order` = 27 WHERE `admin_controls_methods`.`id` = 2724;
UPDATE `admin_controls_methods` SET `id` = 2738,`order` = 24 WHERE `admin_controls_methods`.`id` = 2738;
UPDATE `admin_controls_methods` SET `id` = 2759,`order` = 25 WHERE `admin_controls_methods`.`id` = 2759;
UPDATE `admin_controls_methods` SET `id` = 2770,`order` = 23 WHERE `admin_controls_methods`.`id` = 2770;
UPDATE `admin_controls_methods` SET `id` = 1921,`order` = 1 WHERE `admin_controls_methods`.`id` = 1921;
UPDATE `admin_controls_methods` SET `id` = 1922,`order` = 3 WHERE `admin_controls_methods`.`id` = 1922;
UPDATE `admin_controls_methods` SET `id` = 1923,`order` = 4 WHERE `admin_controls_methods`.`id` = 1923;
UPDATE `admin_controls_methods` SET `id` = 1925,`order` = 2 WHERE `admin_controls_methods`.`id` = 1925;
UPDATE `admin_controls_methods` SET `id` = 2784,`order` = 0 WHERE `admin_controls_methods`.`id` = 2784;
UPDATE `admin_controls_methods` SET `id` = 1924,`order` = 0 WHERE `admin_controls_methods`.`id` = 1924;
UPDATE `admin_controls_methods` SET `id` = 1926,`order` = 1 WHERE `admin_controls_methods`.`id` = 1926;
UPDATE `admin_controls_methods` SET `id` = 1927,`order` = 2 WHERE `admin_controls_methods`.`id` = 1927;
UPDATE `admin_controls_methods` SET `id` = 2785,`order` = 2 WHERE `admin_controls_methods`.`id` = 2785;
UPDATE `admin_controls_methods` SET `id` = 2393,`order` = 7 WHERE `admin_controls_methods`.`id` = 2393;
UPDATE `admin_controls_methods` SET `id` = 2394,`order` = 8 WHERE `admin_controls_methods`.`id` = 2394;
UPDATE `admin_controls_methods` SET `id` = 2755,`order` = 3 WHERE `admin_controls_methods`.`id` = 2755;
UPDATE `admin_controls_methods` SET `id` = 2751,`order` = 11 WHERE `admin_controls_methods`.`id` = 2751;
UPDATE `admin_controls_methods` SET `id` = 2120,`order` = 0 WHERE `admin_controls_methods`.`id` = 2120;
UPDATE `admin_controls_methods` SET `id` = 2121,`order` = 1 WHERE `admin_controls_methods`.`id` = 2121;
UPDATE `admin_controls_methods` SET `id` = 2122,`order` = 4 WHERE `admin_controls_methods`.`id` = 2122;
UPDATE `admin_controls_methods` SET `id` = 2123,`order` = 5 WHERE `admin_controls_methods`.`id` = 2123;
UPDATE `admin_controls_methods` SET `id` = 2124,`order` = 12 WHERE `admin_controls_methods`.`id` = 2124;
UPDATE `admin_controls_methods` SET `id` = 2125,`order` = 15 WHERE `admin_controls_methods`.`id` = 2125;
UPDATE `admin_controls_methods` SET `id` = 2126,`order` = 16 WHERE `admin_controls_methods`.`id` = 2126;
UPDATE `admin_controls_methods` SET `id` = 2133,`order` = 6 WHERE `admin_controls_methods`.`id` = 2133;
UPDATE `admin_controls_methods` SET `id` = 2232,`order` = 2 WHERE `admin_controls_methods`.`id` = 2232;
UPDATE `admin_controls_methods` SET `id` = 2782,`order` = 14 WHERE `admin_controls_methods`.`id` = 2782;
UPDATE `admin_controls_methods` SET `id` = 2778,`order` = 13 WHERE `admin_controls_methods`.`id` = 2778;
UPDATE `admin_controls_methods` SET `id` = 2395,`order` = 9 WHERE `admin_controls_methods`.`id` = 2395;
UPDATE `admin_controls_methods` SET `id` = 2396,`order` = 10 WHERE `admin_controls_methods`.`id` = 2396;
UPDATE `admin_controls_methods` SET `id` = 2752,`order` = 5 WHERE `admin_controls_methods`.`id` = 2752;
UPDATE `admin_controls_methods` SET `id` = 2753,`order` = 6 WHERE `admin_controls_methods`.`id` = 2753;
UPDATE `admin_controls_methods` SET `id` = 2128,`order` = 0 WHERE `admin_controls_methods`.`id` = 2128;
UPDATE `admin_controls_methods` SET `id` = 2129,`order` = 1 WHERE `admin_controls_methods`.`id` = 2129;
UPDATE `admin_controls_methods` SET `id` = 2130,`order` = 2 WHERE `admin_controls_methods`.`id` = 2130;
UPDATE `admin_controls_methods` SET `id` = 2131,`order` = 3 WHERE `admin_controls_methods`.`id` = 2131;
UPDATE `admin_controls_methods` SET `id` = 2132,`order` = 4 WHERE `admin_controls_methods`.`id` = 2132;
UPDATE `admin_controls_methods` SET `id` = 2783,`order` = 7 WHERE `admin_controls_methods`.`id` = 2783;
UPDATE `admin_controls_methods` SET `id` = 2779,`order` = 7 WHERE `admin_controls_methods`.`id` = 2779;
UPDATE `admin_controls_methods` SET `id` = 2766,`order` = 26 WHERE `admin_controls_methods`.`id` = 2766;
UPDATE `admin_controls_methods` SET `id` = 2757,`order` = 18 WHERE `admin_controls_methods`.`id` = 2757;
UPDATE `admin_controls_methods` SET `id` = 2758,`order` = 19 WHERE `admin_controls_methods`.`id` = 2758;
UPDATE `admin_controls_methods` SET `id` = 2759,`order` = 28 WHERE `admin_controls_methods`.`id` = 2759;
UPDATE `admin_controls_methods` SET `id` = 2760,`order` = 20 WHERE `admin_controls_methods`.`id` = 2760;
UPDATE `admin_controls_methods` SET `id` = 2761,`order` = 21 WHERE `admin_controls_methods`.`id` = 2761;
UPDATE `admin_controls_methods` SET `id` = 2762,`order` = 22 WHERE `admin_controls_methods`.`id` = 2762;
UPDATE `admin_controls_methods` SET `id` = 2763,`order` = 23 WHERE `admin_controls_methods`.`id` = 2763;
UPDATE `admin_controls_methods` SET `id` = 2764,`order` = 24 WHERE `admin_controls_methods`.`id` = 2764;
UPDATE `admin_controls_methods` SET `id` = 2750,`order` = 1 WHERE `admin_controls_methods`.`id` = 2750;
UPDATE `admin_controls_methods` SET `id` = 2765,`order` = 25 WHERE `admin_controls_methods`.`id` = 2765;
UPDATE `admin_controls_methods` SET `id` = 2756,`order` = 2 WHERE `admin_controls_methods`.`id` = 2756;
UPDATE `admin_controls_methods` SET `id` = 2780,`order` = 27 WHERE `admin_controls_methods`.`id` = 2780;
UPDATE `admin_controls_methods` SET `id` = 2711,`order` = 4 WHERE `admin_controls_methods`.`id` = 2711;
UPDATE `admin_controls_methods` SET `id` = 2712,`order` = 5 WHERE `admin_controls_methods`.`id` = 2712;
UPDATE `admin_controls_methods` SET `id` = 2713,`order` = 6 WHERE `admin_controls_methods`.`id` = 2713;
UPDATE `admin_controls_methods` SET `id` = 2714,`order` = 7 WHERE `admin_controls_methods`.`id` = 2714;
UPDATE `admin_controls_methods` SET `id` = 2715,`order` = 8 WHERE `admin_controls_methods`.`id` = 2715;
UPDATE `admin_controls_methods` SET `id` = 2716,`order` = 3 WHERE `admin_controls_methods`.`id` = 2716;
UPDATE `admin_controls_methods` SET `id` = 2717,`order` = 9 WHERE `admin_controls_methods`.`id` = 2717;
UPDATE `admin_controls_methods` SET `id` = 2718,`order` = 10 WHERE `admin_controls_methods`.`id` = 2718;
UPDATE `admin_controls_methods` SET `id` = 2719,`order` = 11 WHERE `admin_controls_methods`.`id` = 2719;
UPDATE `admin_controls_methods` SET `id` = 2720,`order` = 12 WHERE `admin_controls_methods`.`id` = 2720;
UPDATE `admin_controls_methods` SET `id` = 2721,`order` = 13 WHERE `admin_controls_methods`.`id` = 2721;
UPDATE `admin_controls_methods` SET `id` = 2722,`order` = 14 WHERE `admin_controls_methods`.`id` = 2722;
UPDATE `admin_controls_methods` SET `id` = 2723,`order` = 29 WHERE `admin_controls_methods`.`id` = 2723;
UPDATE `admin_controls_methods` SET `id` = 2724,`order` = 30 WHERE `admin_controls_methods`.`id` = 2724;
UPDATE `admin_controls_methods` SET `id` = 2749,`order` = 0 WHERE `admin_controls_methods`.`id` = 2749;
UPDATE `admin_controls_methods` SET `id` = 2786,`order` = 15 WHERE `admin_controls_methods`.`id` = 2786;
UPDATE `admin_controls_methods` SET `id` = 2787,`order` = 16 WHERE `admin_controls_methods`.`id` = 2787;
UPDATE `admin_controls_methods` SET `id` = 2788,`order` = 17 WHERE `admin_controls_methods`.`id` = 2788;
UPDATE `admin_controls_methods` SET `id` = 2767,`order` = 0 WHERE `admin_controls_methods`.`id` = 2767;
UPDATE `admin_controls_methods` SET `id` = 2768,`order` = 15 WHERE `admin_controls_methods`.`id` = 2768;
UPDATE `admin_controls_methods` SET `id` = 2769,`order` = 16 WHERE `admin_controls_methods`.`id` = 2769;
UPDATE `admin_controls_methods` SET `id` = 2770,`order` = 25 WHERE `admin_controls_methods`.`id` = 2770;
UPDATE `admin_controls_methods` SET `id` = 2781,`order` = 24 WHERE `admin_controls_methods`.`id` = 2781;
UPDATE `admin_controls_methods` SET `id` = 2725,`order` = 1 WHERE `admin_controls_methods`.`id` = 2725;
UPDATE `admin_controls_methods` SET `id` = 2726,`order` = 2 WHERE `admin_controls_methods`.`id` = 2726;
UPDATE `admin_controls_methods` SET `id` = 2727,`order` = 3 WHERE `admin_controls_methods`.`id` = 2727;
UPDATE `admin_controls_methods` SET `id` = 2728,`order` = 4 WHERE `admin_controls_methods`.`id` = 2728;
UPDATE `admin_controls_methods` SET `id` = 2729,`order` = 5 WHERE `admin_controls_methods`.`id` = 2729;
UPDATE `admin_controls_methods` SET `id` = 2730,`order` = 6 WHERE `admin_controls_methods`.`id` = 2730;
UPDATE `admin_controls_methods` SET `id` = 2731,`order` = 7 WHERE `admin_controls_methods`.`id` = 2731;
UPDATE `admin_controls_methods` SET `id` = 2732,`order` = 8 WHERE `admin_controls_methods`.`id` = 2732;
UPDATE `admin_controls_methods` SET `id` = 2733,`order` = 9 WHERE `admin_controls_methods`.`id` = 2733;
UPDATE `admin_controls_methods` SET `id` = 2735,`order` = 10 WHERE `admin_controls_methods`.`id` = 2735;
UPDATE `admin_controls_methods` SET `id` = 2736,`order` = 11 WHERE `admin_controls_methods`.`id` = 2736;
UPDATE `admin_controls_methods` SET `id` = 2737,`order` = 12 WHERE `admin_controls_methods`.`id` = 2737;
UPDATE `admin_controls_methods` SET `id` = 2738,`order` = 26 WHERE `admin_controls_methods`.`id` = 2738;
UPDATE `admin_controls_methods` SET `id` = 2771,`order` = 17 WHERE `admin_controls_methods`.`id` = 2771;
UPDATE `admin_controls_methods` SET `id` = 2772,`order` = 18 WHERE `admin_controls_methods`.`id` = 2772;
UPDATE `admin_controls_methods` SET `id` = 2773,`order` = 19 WHERE `admin_controls_methods`.`id` = 2773;
UPDATE `admin_controls_methods` SET `id` = 2774,`order` = 20 WHERE `admin_controls_methods`.`id` = 2774;
UPDATE `admin_controls_methods` SET `id` = 2775,`order` = 21 WHERE `admin_controls_methods`.`id` = 2775;
UPDATE `admin_controls_methods` SET `id` = 2776,`order` = 22 WHERE `admin_controls_methods`.`id` = 2776;
UPDATE `admin_controls_methods` SET `id` = 2777,`order` = 23 WHERE `admin_controls_methods`.`id` = 2777;
UPDATE `admin_controls_methods` SET `id` = 2789,`order` = 13 WHERE `admin_controls_methods`.`id` = 2789;
UPDATE `admin_controls_methods` SET `id` = 2790,`order` = 14 WHERE `admin_controls_methods`.`id` = 2790;
UPDATE `admin_controls_methods` SET `id` = 2791,`order` = 14 WHERE `admin_controls_methods`.`id` = 2791;

UPDATE `lang` SET `id` = 32,`key` = 'home-bitcoin-market-explain',`esp` = 'Estadí­sticas clave sobre el mercado de compraventa de [c_currency]',`eng` = 'Key statistics about the [c_currency] trading market',`order` = '',`p_id` = 9,`ru` = 'Основные статистические данные о рынке [c_currency]',`zh` = '关于[c_currency]交易市场的关键统计数据' WHERE `lang`.`id` = 32;
UPDATE `lang` SET `id` = 39,`key` = 'home-stats-total-btc',`esp` = '[c_currency] totales',`eng` = 'Total [c_currency]',`order` = '',`p_id` = 9,`ru` = ' Всего [c_currency]',`zh` = '总[c_currency]' WHERE `lang`.`id` = 39;
UPDATE `lang` SET `id` = 120,`key` = 'orders-order-by-btc-price',`esp` = 'Precio [c_currency]',`eng` = '[c_currency] Price',`order` = '',`p_id` = 17,`ru` = 'Цена [c_currency]',`zh` = '[c_currency] 价格' WHERE `lang`.`id` = 120;
UPDATE `lang` SET `id` = 125,`key` = 'transactions-btc',`esp` = 'Monto [c_currency]',`eng` = '[c_currency] Amount',`order` = '',`p_id` = 17,`ru` = 'Количество [c_currency]',`zh` = '[c_currency]金额' WHERE `lang`.`id` = 125;
UPDATE `lang` SET `id` = 127,`key` = 'transactions-price',`esp` = 'Precio [c_currency]',`eng` = '[c_currency] Price',`order` = '',`p_id` = 17,`ru` = 'Цена [c_currency]',`zh` = '[c_currency] 价格' WHERE `lang`.`id` = 127;
UPDATE `lang` SET `id` = 133,`key` = 'buy-bitcoins',`esp` = 'Comprar [c_currency]',`eng` = 'Buy [c_currency]',`order` = '',`p_id` = 17,`ru` = 'Покупка [c_currency]',`zh` = '买[c_currency]' WHERE `lang`.`id` = 133;
UPDATE `lang` SET `id` = 134,`key` = 'sell-bitcoins',`esp` = 'Vender [c_currency]',`eng` = 'Sell [c_currency]',`order` = '',`p_id` = 17,`ru` = 'Продажа [c_currency]',`zh` = '卖[c_currency]' WHERE `lang`.`id` = 134;
UPDATE `lang` SET `id` = 142,`key` = 'buy-total',`esp` = '[c_currency] a recibir',`eng` = '[c_currency] to Receive',`order` = '',`p_id` = 17,`ru` = '',`zh` = '' WHERE `lang`.`id` = 142;
UPDATE `lang` SET `id` = 154,`key` = 'sell-errors-balance-too-low',`esp` = 'No tiene suficientes [c_currency].',`eng` = 'You do not have enough [c_currency].',`order` = '',`p_id` = 17,`ru` = 'У вас нет достаточного количества [c_currency].',`zh` = '您没有足够的金额[c_currency]。' WHERE `lang`.`id` = 154;
UPDATE `lang` SET `id` = 158,`key` = 'sell-btc-available',`esp` = 'BTC disponibles',`eng` = 'Available [c_currency]',`order` = '',`p_id` = 17,`ru` = 'Доступные [c_currency]',`zh` = '可用的[c_currency]' WHERE `lang`.`id` = 158;
UPDATE `lang` SET `id` = 196,`key` = 'settings-withdrawal-2fa-btc',`esp` = 'Confirmar retiros de criptodivisas con autenticación de dos factores.',`eng` = 'Confirm crypto withdrawals with two-factor authentication.',`order` = '',`p_id` = 104,`ru` = 'Подтверждать вывод крипто с помощью двухфакторной аутентификации.',`zh` = '确认取款Crypto使用双因素认证。' WHERE `lang`.`id` = 196;
UPDATE `lang` SET `id` = 197,`key` = 'settings-withdrawal-email-btc',`esp` = 'Confirmar retiros de criptodivisas por email.',`eng` = 'Confirm crypto withdrawals by email.',`order` = '',`p_id` = 104,`ru` = 'Подтверждать выводы крипто по электронной почте.',`zh` = '确认取款Crypto使用电子邮件。' WHERE `lang`.`id` = 197;
UPDATE `lang` SET `id` = 200,`key` = 'settings-notify-deposit-btc',`esp` = 'Notificar por email cuando se depositan criptodivisas.',`eng` = 'Notify by email when crypto deposits are made.',`order` = '',`p_id` = 104,`ru` = 'Уведомлять по электронной почте, когда депозиты крипто сделаны.',`zh` = 'Crypto存款时, 通过电子邮件通知。' WHERE `lang`.`id` = 200;
UPDATE `lang` SET `id` = 221,`key` = 'bank-accounts-add-label',`esp` = 'Agregar cuenta Crypto Capital',`eng` = 'Add Crypto Capital Account',`order` = '',`p_id` = 215,`ru` = 'Добавить Crypto Capital Аккаунт',`zh` = '添加Crypto Capital帐户' WHERE `lang`.`id` = 221;
UPDATE `lang` SET `id` = 222,`key` = 'bank-accounts-account-cc',`esp` = 'Número de cuenta Crypto Capital',`eng` = 'Crypto Capital Account Number',`order` = '',`p_id` = 215,`ru` = 'Номер Аккаунта Crypto Capital ',`zh` = 'Crypto Capital 帐户号码' WHERE `lang`.`id` = 222;
UPDATE `lang` SET `id` = 226,`key` = 'bank-accounts-crypto-label',`esp` = 'Cuenta Crypto Capital',`eng` = 'Crypto Capital Account',`order` = '',`p_id` = 215,`ru` = 'Crypto Capital Аккаунт',`zh` = 'Crypto Capital帐户' WHERE `lang`.`id` = 226;
UPDATE `lang` SET `id` = 241,`key` = 'deposit-bitcoins',`esp` = 'Depositar criptodivisas',`eng` = 'Deposit Cryptos',`order` = '',`p_id` = 22,`ru` = 'Ввод крипто',`zh` = 'Crypto充值' WHERE `lang`.`id` = 241;
UPDATE `lang` SET `id` = 242,`key` = 'deposit-send-to-address',`esp` = 'Enví­e [c_currency] a esta dirección',`eng` = 'Send [c_currency] to This Address',`order` = '',`p_id` = 22,`ru` = 'Отправить [c_currency] по этому адресу',`zh` = '发送[c_currency]到这个地址' WHERE `lang`.`id` = 242;
UPDATE `lang` SET `id` = 352,`key` = 'account-global-btc',`esp` = 'Vol. [c_currency] 24h en casa de cambio',`eng` = 'Exchange-wide 24h [c_currency] volume',`order` = '',`p_id` = 17,`ru` = 'Объем всего суточного обмена [c_currency]',`zh` = '所24小时的交流[c_currency]的体积' WHERE `lang`.`id` = 352;
UPDATE `lang` SET `id` = 398,`key` = 'home-landing-currency',`esp` = 'Cambiar [currency] por <strong>[c_currency]</strong>',`eng` = 'Exchange [currency] to <strong>[c_currency]</strong>',`order` = '',`p_id` = 9,`ru` = 'Обменять [currency] на <strong>[c_currency]</strong>',`zh` = '转换[currency]到 <strong>[c_currency]</strong>' WHERE `lang`.`id` = 398;
UPDATE `lang` SET `id` = 399,`key` = 'home-landing-currency-explain',`esp` = '[currency] a <strong>[c_currency]</strong> precio histórico y libreta de órdenes.',`eng` = '[currency] to <strong>[c_currency]</strong> historical prices and order book.',`order` = '',`p_id` = 9,`ru` = '[currency] на <strong>[c_currency]</strong> исторические цены и кнага заявок. ',`zh` = '[currency]到<strong>[c_currency]</strong>的历史价格和定貨簿。' WHERE `lang`.`id` = 399;
UPDATE `lang` SET `id` = 400,`key` = 'home-landing-sign-up',`esp` = 'Regístrese para cambiar [currency] a [c_currency]',`eng` = 'Sign Up to Exchange [currency] to [c_currency]',`order` = '',`p_id` = 9,`ru` = 'Зарегистрируйтесь, чтобы обменять [currency] to [c_currency]',`zh` = '注册对转换[currency]到比特币' WHERE `lang`.`id` = 400;
UPDATE `lang` SET `id` = 436,`key` = 'settings-notify-withdraw-btc',`esp` = 'Notificar por email cuando se retiran criptodivisas.',`eng` = 'Notify by email when crypto withdrawals are made.',`order` = '',`p_id` = 104,`ru` = 'Уведомлять по электронной почте, когда выводы BTC сделаны.',`zh` = '提现比特币时, 通过电子邮件通知。' WHERE `lang`.`id` = 436;
UPDATE `lang` SET `id` = 440,`key` = 'withdraw-btc-total',`esp` = '[c_currency] a recibir',`eng` = '[c_currency] to Receive',`order` = '',`p_id` = 23,`ru` = '[c_currency] к получению',`zh` = '以接收[c_currency]' WHERE `lang`.`id` = 440;
UPDATE `lang` SET `id` = 115,`key` = 'account-30-day-vol',`esp` = 'Volumen en [currency] a 30 dias',`eng` = '30 day volume in [currency]',`order` = '',`p_id` = 17,`ru` = '30 дневный объем в [currency]',`zh` = '30天内[currency]量' WHERE `lang`.`id` = 115;
UPDATE `lang` SET `id` = 231,`key` = 'bitcoin-addresses',`esp` = 'Direcciones de criptodiv.',`eng` = 'Crypto Addresses',`order` = '',`p_id` = 0,`ru` = 'крипто-Адреса',`zh` = '比特币地址' WHERE `lang`.`id` = 231;
UPDATE `lang` SET `id` = 243,`key` = 'deposit-manage-addresses',`esp` = 'Administrar direcciones de cryptodivisas',`eng` = 'Manage crypto addresses',`order` = '',`p_id` = 22,`ru` = 'Управление Биткоин-адресами',`zh` = '管理比特币地址' WHERE `lang`.`id` = 243;
UPDATE `lang` SET `id` = 252,`key` = 'withdraw-bitcoins',`esp` = 'Retirar criptodivisas',`eng` = 'Withdraw Cryptos',`order` = '',`p_id` = 23,`ru` = 'Вывод Биткоинов',`zh` = '比特币提现' WHERE `lang`.`id` = 252;
UPDATE `lang` SET `id` = 255,`key` = 'withdraw-send-bitcoins',`esp` = 'Enviar criptodivisa',`eng` = 'Send Crypto',`order` = '',`p_id` = 23,`ru` = 'Отправка биткоинов',`zh` = '发送比特币' WHERE `lang`.`id` = 255;
UPDATE `lang` SET `id` = 272,`key` = 'withdraw-address-invalid',`esp` = 'La dirección [c_currency] especificada es inválida.',`eng` = 'You have specified an invalid [c_currency] address.',`order` = '',`p_id` = 23,`ru` = 'Вы указали неверный [c_currency]-адрес.',`zh` = '您指定了一个无效的[c_currency]地址。' WHERE `lang`.`id` = 272;
UPDATE `lang` SET `id` = 273,`key` = 'withdraw-btc-request',`esp` = 'Su solicitud de retiro se ha creado. Sus criptodivisas serán enviados próximamente.',`eng` = 'Your withdrawal request has been created successfully. Your crypto will be sent shortly.',`order` = '',`p_id` = 23,`ru` = 'Ваш запрос на вывод был успешно создан. Ваши биткоины будут отправлены в ближайшее время.',`zh` = '您的取款请求已成功创建。您的比特币将很快送到。' WHERE `lang`.`id` = 273;
UPDATE `lang` SET `id` = 120,`key` = 'orders-order-by-btc-price',`esp` = 'Precio de la órden',`eng` = 'Order Price',`order` = '',`p_id` = 17,`ru` = 'Цена Заявки',`zh` = '订单价格' WHERE `lang`.`id` = 120;
UPDATE `lang` SET `id` = 242,`key` = 'deposit-send-to-address',`esp` = 'Enviar a esta dirección',`eng` = 'Send to This Address',`order` = '',`p_id` = 22,`ru` = 'Отправить по этому адресу',`zh` = '发送到这个地址' WHERE `lang`.`id` = 242;

INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(516, 'deposit-c-currency', 'Moneda a depositar', 'Currency to Deposit', '', 22, 'Currency to Deposit', 'Currency to Deposit');
INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(512, 'default-c-currency', 'Mercado por defecto', 'Default Market', '', 27, 'Pынок по умолчанию', '默认市场');
INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(513, 'market', 'Mercado', 'Market', '', 11, 'Рынка', '币市场');
INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(514, 'same-currency-error', 'La moneda predefinida no puede ser igual al mercado predefinido.', 'The default currency cannot be the same as the default market.', '', 104, 'The default currency cannot be the same as the default market.', 'The default currency cannot be the same as the default market.');
INSERT INTO `lang` (`id`, `key`, `esp`, `eng`, `order`, `p_id`, `ru`, `zh`) VALUES
(515, 'buy-errors-under-min-price', 'El menor precio permitido para este mercado es [min].', 'The minimum price for this market is [min].', '', 17, 'The minimum price for this market is [min].', 'The minimum price for this market is [min].');
UPDATE `lang` SET `id` = 515,`key` = 'buy-errors-under-min-price',`esp` = 'El menor precio permitido [crypto] es [min].',`eng` = 'The minimum price for [crypto] is [min].',`order` = '',`p_id` = 17,`ru` = 'The minimum price for [crypto] is [min].',`zh` = 'The minimum price for [crypto] is [min].' WHERE `lang`.`id` = 515;


UPDATE `emails` SET `id` = 19,`key` = 'order-cancelled',`title_en` = 'Order Partially Executed',`title_es` = 'Órden parcialmente ejecutada',`content_en` = 0x3c703e4465617220757365722c3c2f703e0d0a0d0a3c703e596f752061726520726563656976696e672074686973206d6573736167652062656361757365205b616d6f756e745d205b635f63757272656e63795d206f66206f6e65206f6620796f7572206f726465727320636f756c64206e6f742062652066756c6c792065786563757465642062656361757365206f66206c61636b206f662066756e64732e205468697320736974756174696f6e2063616e206f63637572207768656e2061207269736520696e20746865206d61726b6574207072696365206361757365732074686520746f74616c20616d6f756e74206f662061206d61726b6574206f7264657220746f2065786365656420796f757220617661696c61626c652066756e64732e205468657265666f72652c206f6e6c792074686520617661696c61626c6520616d6f756e742077696c6c20626520657865637574656420746f2061766f69642061206e656761746976652062616c616e6365206f6e20796f7572206163636f756e742e3c2f703e0d0a0d0a3c703e4265737420726567617264732c3c2f703e0d0a0d0a3c703e5b65786368616e67655f6e616d655d20537570706f7274205465616d3c2f703e0d0a,`content_es` = 0x3c703e457374696d61646f207573756172696f2c3c2f703e0d0a0d0a3c703e557374656420686120726563696269646f2065737465206d656e73616a6520706f72717565205b616d6f756e745d205b635f63757272656e63795d20646520756e612064652073757320266f61637574653b7264656e6573206e6f207075646f2073657220656a6563757461646120706f722066616c746120646520666f6e646f732e20457374612073697475616369266f61637574653b6e2073652070756564652070726573656e746172206375616e646f20756e20616c7a6120656e20656c2070726563696f2064656c206d65726361646f20686163652071756520656c2076616c6f7220746f74616c20646520737520266f61637574653b7264656e206465206d65726361646f207375627265706173652073757320666f6e646f7320646973706f6e69626c65732e20506f72206c6f2074616e746f2c2073266f61637574653b6c6f20736520706f6472266161637574653b20656a656375746172206c612063616e746964616420646973706f6e69626c6520706172612065766974617220756e2062616c616e6365206e6567617469766f20656e207375206375656e74612e3c2f703e0d0a0d0a3c703e53616c75646f732c3c2f703e0d0a0d0a3c703e536f706f727465206465205b65786368616e67655f6e616d655d3c2f703e0d0a,`title_ru` = 'Частично Выполненная Заявка',`title_zh` = '执行部分订单',`content_ru` = 0x3c703ed0a3d0b2d0b0d0b6d0b0d0b5d0bcd18bd0b920d0bfd0bed0bbd18cd0b7d0bed0b2d0b0d182d0b5d0bbd18c2c3c2f703e0d0a0d0a3c703ed092d18b20d0bfd0bed0bbd183d187d0b8d0bbd0b820d18dd182d0be20d181d0bed0bed0b1d189d0b5d0bdd0b8d0b52c20d0bfd0bed182d0bed0bcd18320d187d182d0be205b616d6f756e745d205b635f63757272656e63795d20d0bed0b4d0bdd0bed0b920d0b8d0b720d0b2d0b0d188d0b8d18520d0b7d0b0d18fd0b2d0bed0ba20d0bdd0b520d0bcd0bed0b6d0b5d18220d0b1d18bd182d18c20d0b8d181d0bfd0bed0bbd0bdd0b5d0bdd0be20d0b220d0bfd0bed0bbd0bdd0bed0bc20d0bed0b1d18ad0b5d0bcd0b520d0b8d0b72dd0b7d0b020d0bed182d181d183d182d181d182d0b2d0b8d18f20d181d180d0b5d0b4d181d182d0b22e20d0a2d0b0d0bad0b0d18f20d181d0b8d182d183d0b0d186d0b8d18f20d0bcd0bed0b6d0b5d18220d0b2d0bed0b7d0bdd0b8d0bad0bdd183d182d18c2c20d0bad0bed0b3d0b4d0b020d0b8d0b72dd0b7d0b020d180d0bed181d182d0b020d180d18bd0bdd0bed187d0bdd0bed0b920d186d0b5d0bdd18b20d0bed0b1d189d0b0d18f20d181d183d0bcd0bcd0b020d180d18bd0bdd0bed187d0bdd0bed0b3d0be20d0bed180d0b4d0b5d180d0b020d0bfd180d0b5d0b2d0bed181d185d0bed0b4d0b8d18220d0b2d0b0d188d0b820d181d0b2d0bed0b1d0bed0b4d0bdd18bd0b520d181d180d0b5d0b4d181d182d0b2d0b0202e20d0a2d0b0d0bad0b8d0bc20d0bed0b1d180d0b0d0b7d0bed0bc2c20d182d0bed0bbd18cd0bad0be20d0b4d0bed181d182d183d0bfd0bdd0b0d18f20d181d183d0bcd0bcd0b020d0b1d183d0b4d0b5d18220d0b2d18bd0bfd0bed0bbd0bdd0b5d0bdd0b02c20d187d182d0bed0b1d18b20d0b8d0b7d0b1d0b5d0b6d0b0d182d18c20d0bed182d180d0b8d186d0b0d182d0b5d0bbd18cd0bdd0bed0b3d0be20d0b1d0b0d0bbd0b0d0bdd181d0b020d0bdd0b020d0b2d0b0d188d0b5d0bc20d181d187d0b5d182d0b52e3c2f703e0d0a0d0a3c703e3c7370616e207374796c653d226c696e652d6865696768743a20312e36656d3b223ed0a120d183d0b2d0b0d0b6d0b5d0bdd0b8d0b5d0bc2c3c2f7370616e3e3c2f703e0d0a0d0a3c703ed09ad0bed0bcd0b0d0bdd0b4d0b020d0bfd0bed0b4d0b4d0b5d180d0b6d0bad0b8205b65786368616e67655f6e616d655d3c2f703e0d0a,`content_zh` = 0x3c703ee5b08ae695ace79a84e794a8e688b7efbc8c3c2f703e0d0a0d0a3c703ee682a8e694b6e588b0e6ada4e6b688e681afefbc8ce59ba0e4b8bae682a8e79a84205b616d6f756e745d205b635f63757272656e63795de79a84e8aea2e58d95e4b88de883bde5ae8ce585a8e698afe794b1e4ba8ee7bcbae4b98fe8b584e98791e689a7e8a18ce38082e59ba0e6ada4efbc8ce58faae58fafe794a8e98791e9a29de8a2abe689a7e8a18cefbc8ce4bba5e981bfe5858de59ca8e682a8e79a84e5b890e688b7e4bd99e9a29de4b8bae8b49fe580bce380823c2f703e0d0a0d0a3c703e3c7370616e207374796c653d226c696e652d6865696768743a20312e36656d3b223ee8b0a8e887b4e997aee58099efbc8c3c2f7370616e3e3c2f703e0d0a0d0a3c703e5b65786368616e67655f6e616d655de694afe68c81e59ba2e9989f3c2f703e0d0a WHERE `emails`.`id` = 19;

INSERT INTO `admin_pages` (`id`, `f_id`, `name`, `url`, `icon`, `order`, `page_map_reorders`, `one_record`) VALUES
(101, 1, 'Emails', 'emails', '', 0, 0, ''),
(102, 1, 'Language Table', 'lang', '', 0, 0, '');
DELETE FROM `admin_tabs` WHERE `admin_tabs`.`id` = 4;
DELETE FROM `admin_tabs` WHERE `admin_tabs`.`id` = 32;
UPDATE `admin_controls` SET page_id = 101, tab_id = 0 WHERE id IN (22,23,24);
UPDATE `admin_controls` SET page_id = 102, tab_id = 0 WHERE id IN (178,139,141)
UPDATE `admin_controls_methods` SET `id` = 2782,`method` = 'checkBox',`arguments` = 'a:9:{s:4:"name";s:15:"not_convertible";s:7:"caption";s:16:"Not Convertible?";s:8:"required";s:0:"";s:2:"id";s:0:"";s:5:"class";s:0:"";s:7:"jscript";s:0:"";s:5:"style";s:0:"";s:11:"label_class";s:0:"";s:7:"checked";s:0:"";}',`order` = 14,`control_id` = 256,`p_id` = 0 WHERE `admin_controls_methods`.`id` = 2782;
