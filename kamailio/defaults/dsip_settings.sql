-- DB representation of settings.py with following exceptions:
-- LOAD_SETTINGS_FROM: not included in db
DROP TABLE IF EXISTS dsip_settings;
/*!40101 SET @saved_cs_client = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE dsip_settings (
  DSIP_ID int UNSIGNED NOT NULL AUTO_INCREMENT,
  DSIP_CLUSTER_ID int UNSIGNED NOT NULL DEFAULT 1,
  DSIP_CLUSTER_SYNC tinyint(1) NOT NULL DEFAULT 1,
  DSIP_PROTO varchar(16) NOT NULL DEFAULT 'http',
  DSIP_PORT int NOT NULL DEFAULT 5000,
  DSIP_USERNAME varchar(255) NOT NULL DEFAULT 'admin',
  DSIP_PASSWORD varbinary($HASHED_CREDS_ENCODED_MAX_LEN) COLLATE 'binary' NOT NULL,
  DSIP_IPC_PASS varbinary($AESCTR_CREDS_ENCODED_MAX_LEN) COLLATE 'binary' NOT NULL,
  DSIP_API_PROTO varchar(16) NOT NULL DEFAULT 'http',
  DSIP_API_PORT int NOT NULL DEFAULT 5000,
  DSIP_PRIV_KEY varchar(255) NOT NULL DEFAULT '/etc/dsiprouter/privkey',
  DSIP_PID_FILE varchar(255) NOT NULL DEFAULT '/var/run/dsiprouter/dsiprouter.pid',
  DSIP_UNIX_SOCK varchar(255) NOT NULL DEFAULT '/var/run/dsiprouter/dsiprouter.sock',
  DSIP_IPC_SOCK varchar(255) NOT NULL DEFAULT '/var/run/dsiprouter/ipc.sock',
  DSIP_API_TOKEN varbinary($AESCTR_CREDS_ENCODED_MAX_LEN) COLLATE 'binary' NOT NULL,
  DSIP_LOG_LEVEL int NOT NULL DEFAULT 3,
  DSIP_LOG_FACILITY int NOT NULL DEFAULT 18,
  DSIP_SSL_KEY varchar(255) NOT NULL DEFAULT '',
  DSIP_SSL_CERT varchar(255) NOT NULL DEFAULT '',
  DSIP_SSL_EMAIL varchar(255) NOT NULL DEFAULT '',
  DSIP_CERTS_DIR varchar(255) NOT NULL DEFAULT '/etc/dsiprouter/certs',
  VERSION varchar(32) NOT NULL DEFAULT '0.61',
  DEBUG tinyint(1) NOT NULL DEFAULT 0,
  ROLE varchar(32) NOT NULL DEFAULT '',
  GUI_INACTIVE_TIMEOUT int UNSIGNED NOT NULL DEFAULT 20,
  KAM_DB_HOST varchar(255) NOT NULL DEFAULT 'localhost',
  KAM_DB_DRIVER varchar(255) NOT NULL DEFAULT '',
  KAM_DB_TYPE varchar(255) NOT NULL DEFAULT 'mysql',
  KAM_DB_PORT varchar(255) NOT NULL DEFAULT '3306',
  KAM_DB_NAME varchar(255) NOT NULL DEFAULT 'kamailio',
  KAM_DB_USER varchar(255) NOT NULL DEFAULT 'kamailio',
  KAM_DB_PASS varbinary($AESCTR_CREDS_ENCODED_MAX_LEN) COLLATE 'binary' NOT NULL,
  KAM_KAMCMD_PATH varchar(255) NOT NULL DEFAULT '/usr/sbin/kamcmd',
  KAM_CFG_PATH varchar(255) NOT NULL DEFAULT '/etc/kamailio/kamailio.cfg',
  KAM_TLSCFG_PATH varchar(255) NOT NULL DEFAULT '/etc/kamailio/tls.cfg',
  RTP_CFG_PATH varchar(255) NOT NULL DEFAULT '/etc/kamailio/kamailio.cfg',
  SQLALCHEMY_TRACK_MODIFICATIONS tinyint(1) NOT NULL DEFAULT 0,
  SQLALCHEMY_SQL_DEBUG tinyint(1) NOT NULL DEFAULT 0,
  FLT_CARRIER int NOT NULL DEFAULT 8,
  FLT_PBX int NOT NULL DEFAULT 9,
  FLT_MSTEAMS int NOT NULL DEFAULT 17,
  FLT_OUTBOUND int NOT NULL DEFAULT 8000,
  FLT_INBOUND int NOT NULL DEFAULT 9000,
  FLT_LCR_MIN int NOT NULL DEFAULT 10000,
  FLT_FWD_MIN int NOT NULL DEFAULT 20000,
  DOMAIN varchar(255) NOT NULL DEFAULT 'sip.dsiprouter.org',
  TELEBLOCK_GW_ENABLED tinyint(1) NOT NULL DEFAULT 0,
  TELEBLOCK_GW_IP varchar(255) NOT NULL DEFAULT '62.34.24.22',
  TELEBLOCK_GW_PORT varchar(255) NOT NULL DEFAULT '5066',
  TELEBLOCK_MEDIA_IP varchar(255) NOT NULL DEFAULT '',
  TELEBLOCK_MEDIA_PORT varchar(255) NOT NULL DEFAULT '',
  FLOWROUTE_ACCESS_KEY varchar(255) NOT NULL DEFAULT '',
  FLOWROUTE_SECRET_KEY varchar(255) NOT NULL DEFAULT '',
  FLOWROUTE_API_ROOT_URL varchar(255) NOT NULL DEFAULT 'https://api.flowroute.com/v2',
  INTERNAL_IP_ADDR varchar(255) NOT NULL DEFAULT '192.168.0.1',
  INTERNAL_IP_NET varchar(255) NOT NULL DEFAULT '192.168.0.*',
  EXTERNAL_IP_ADDR varchar(255) NOT NULL DEFAULT '1.1.1.1',
  EXTERNAL_FQDN varchar(255) NOT NULL DEFAULT 'sip.dsiprouter.org',
  UPLOAD_FOLDER varchar(255) NOT NULL DEFAULT '/tmp',
  CLOUD_PLATFORM varchar(16) NOT NULL DEFAULT '',
  MAIL_SERVER varchar(255) NOT NULL DEFAULT 'smtp.gmail.com',
  MAIL_PORT int NOT NULL DEFAULT 587,
  MAIL_USE_TLS tinyint(1) NOT NULL DEFAULT 1,
  MAIL_USERNAME varchar(255) NOT NULL DEFAULT '',
  MAIL_PASSWORD varbinary($AESCTR_CREDS_ENCODED_MAX_LEN) COLLATE 'binary' NOT NULL,
  MAIL_ASCII_ATTACHMENTS tinyint(1) NOT NULL DEFAULT 0,
  MAIL_DEFAULT_SENDER varchar(255) NOT NULL DEFAULT 'DoNotReply@smtp.gmail.com',
  MAIL_DEFAULT_SUBJECT varchar(255) NOT NULL DEFAULT 'dSIPRouter System Notification',
  CHECK (ROLE IN ('', 'outbound', 'inout')),
  CHECK (CLOUD_PLATFORM IN ('', 'AWS', 'GCP', 'AZURE', 'DO')),
  PRIMARY KEY (DSIP_ID)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  MAX_ROWS = 1
  MIN_ROWS = 1;
/*!40101 SET character_set_client = @saved_cs_client */;

-- Update dsip_settings table then for current dsiprouter instance, then
-- Sync changes to dsip_settings across same cluster with the following exceptions:
-- DSIP_ID is unchanged
-- DSIP_CLUSTER_ID is unchanged
-- DSIP_CLUSTER_SYNC is unchanged
-- INTERNAL_IP_ADDR is unchanged
-- INTERNAL_IP_NET is unchanged
-- EXTERNAL_IP_ADDR is unchanged
-- EXTERNAL_FQDN is unchanged
DROP PROCEDURE IF EXISTS update_dsip_settings;
DELIMITER //
CREATE PROCEDURE update_dsip_settings(
  IN NEW_DSIP_ID int UNSIGNED, IN NEW_DSIP_CLUSTER_ID int UNSIGNED, IN NEW_DSIP_CLUSTER_SYNC tinyint(1), IN NEW_DSIP_PROTO varchar(16),
  IN NEW_DSIP_PORT int, IN NEW_DSIP_USERNAME varchar(255), IN NEW_DSIP_PASSWORD varbinary($HASHED_CREDS_ENCODED_MAX_LEN),
  IN NEW_DSIP_IPC_PASS varbinary($AESCTR_CREDS_ENCODED_MAX_LEN), IN NEW_DSIP_API_PROTO varchar(16),
  IN NEW_DSIP_API_PORT int, IN NEW_DSIP_PRIV_KEY varchar(255), IN NEW_DSIP_PID_FILE varchar(255),
  IN NEW_DSIP_UNIX_SOCK varchar(255), IN NEW_DSIP_IPC_SOCK varchar(255), IN NEW_DSIP_API_TOKEN varbinary($AESCTR_CREDS_ENCODED_MAX_LEN), IN NEW_DSIP_LOG_LEVEL int, IN NEW_DSIP_LOG_FACILITY int,
  IN NEW_DSIP_SSL_KEY varchar(255), IN NEW_DSIP_SSL_CERT varchar(255), IN NEW_DSIP_SSL_EMAIL varchar(255), IN NEW_DSIP_CERTS_DIR varchar(255),
  IN NEW_VERSION varchar(32),
  IN NEW_DEBUG tinyint(1), IN NEW_ROLE varchar(32), IN NEW_GUI_INACTIVE_TIMEOUT int UNSIGNED, IN NEW_KAM_DB_HOST varchar(255),
  IN NEW_KAM_DB_DRIVER varchar(255), IN NEW_KAM_DB_TYPE varchar(255), IN NEW_KAM_DB_PORT varchar(255), IN NEW_KAM_DB_NAME varchar(255),
  IN NEW_KAM_DB_USER varchar(255), IN NEW_KAM_DB_PASS varbinary($AESCTR_CREDS_ENCODED_MAX_LEN), IN NEW_KAM_KAMCMD_PATH varchar(255),
  IN NEW_KAM_CFG_PATH varchar(255), IN NEW_KAM_TLSCFG_PATH varchar(255), IN NEW_RTP_CFG_PATH varchar(255), IN NEW_SQLALCHEMY_TRACK_MODIFICATIONS tinyint(1),
  IN NEW_SQLALCHEMY_SQL_DEBUG tinyint(1), IN NEW_FLT_CARRIER int, IN NEW_FLT_PBX int, IN NEW_FLT_MSTEAMS int, IN NEW_FLT_OUTBOUND int, IN NEW_FLT_INBOUND int,
  IN NEW_FLT_LCR_MIN int, IN NEW_FLT_FWD_MIN int, IN NEW_DOMAIN varchar(255), IN NEW_TELEBLOCK_GW_ENABLED tinyint(1),
  IN NEW_TELEBLOCK_GW_IP varchar(255), IN NEW_TELEBLOCK_GW_PORT varchar(255), IN NEW_TELEBLOCK_MEDIA_IP varchar(255),
  IN NEW_TELEBLOCK_MEDIA_PORT varchar(255), IN NEW_FLOWROUTE_ACCESS_KEY varchar(255), IN NEW_FLOWROUTE_SECRET_KEY varchar(255),
  IN NEW_FLOWROUTE_API_ROOT_URL varchar(255), IN NEW_INTERNAL_IP_ADDR varchar(255), IN NEW_INTERNAL_IP_NET varchar(255),
  IN NEW_EXTERNAL_IP_ADDR varchar(255), IN NEW_EXTERNAL_FQDN varchar(255), IN NEW_UPLOAD_FOLDER varchar(255), IN NEW_CLOUD_PLATFORM varchar(16),
  IN NEW_MAIL_SERVER varchar(255), IN NEW_MAIL_PORT int, IN NEW_MAIL_USE_TLS tinyint(1), IN NEW_MAIL_USERNAME varchar(255),
  IN NEW_MAIL_PASSWORD varbinary($AESCTR_CREDS_ENCODED_MAX_LEN), IN NEW_MAIL_ASCII_ATTACHMENTS tinyint(1), IN NEW_MAIL_DEFAULT_SENDER varchar(255),
  IN NEW_MAIL_DEFAULT_SUBJECT varchar(255)
)
BEGIN
  START TRANSACTION;

  REPLACE INTO dsip_settings
  VALUES (NEW_DSIP_ID, NEW_DSIP_CLUSTER_ID, NEW_DSIP_CLUSTER_SYNC, NEW_DSIP_PROTO, NEW_DSIP_PORT,
          NEW_DSIP_USERNAME, NEW_DSIP_PASSWORD, NEW_DSIP_IPC_PASS, NEW_DSIP_API_PROTO,
          NEW_DSIP_API_PORT, NEW_DSIP_PRIV_KEY, NEW_DSIP_PID_FILE, NEW_DSIP_UNIX_SOCK, NEW_DSIP_IPC_SOCK, NEW_DSIP_API_TOKEN,
          NEW_DSIP_LOG_LEVEL, NEW_DSIP_LOG_FACILITY, NEW_DSIP_SSL_KEY, NEW_DSIP_SSL_CERT, NEW_DSIP_SSL_EMAIL, NEW_DSIP_CERTS_DIR,
          NEW_VERSION, NEW_DEBUG, NEW_ROLE, NEW_GUI_INACTIVE_TIMEOUT, NEW_KAM_DB_HOST, NEW_KAM_DB_DRIVER,
          NEW_KAM_DB_TYPE, NEW_KAM_DB_PORT, NEW_KAM_DB_NAME, NEW_KAM_DB_USER, NEW_KAM_DB_PASS, NEW_KAM_KAMCMD_PATH,
          NEW_KAM_CFG_PATH, NEW_KAM_TLSCFG_PATH, NEW_RTP_CFG_PATH, NEW_SQLALCHEMY_TRACK_MODIFICATIONS, NEW_SQLALCHEMY_SQL_DEBUG,
          NEW_FLT_CARRIER, NEW_FLT_PBX, NEW_FLT_MSTEAMS, NEW_FLT_OUTBOUND, NEW_FLT_INBOUND, NEW_FLT_LCR_MIN, NEW_FLT_FWD_MIN, NEW_DOMAIN,
          NEW_TELEBLOCK_GW_ENABLED, NEW_TELEBLOCK_GW_IP, NEW_TELEBLOCK_GW_PORT, NEW_TELEBLOCK_MEDIA_IP,
          NEW_TELEBLOCK_MEDIA_PORT, NEW_FLOWROUTE_ACCESS_KEY, NEW_FLOWROUTE_SECRET_KEY, NEW_FLOWROUTE_API_ROOT_URL,
          NEW_INTERNAL_IP_ADDR, NEW_INTERNAL_IP_NET, NEW_EXTERNAL_IP_ADDR, NEW_EXTERNAL_FQDN, NEW_UPLOAD_FOLDER, NEW_CLOUD_PLATFORM,
          NEW_MAIL_SERVER, NEW_MAIL_PORT, NEW_MAIL_USE_TLS, NEW_MAIL_USERNAME, NEW_MAIL_PASSWORD,
          NEW_MAIL_ASCII_ATTACHMENTS, NEW_MAIL_DEFAULT_SENDER, NEW_MAIL_DEFAULT_SUBJECT);

  IF NEW_DSIP_CLUSTER_SYNC = 1 THEN
    UPDATE dsip_settings
    SET DSIP_PROTO = NEW_DSIP_PROTO,
        DSIP_PORT = NEW_DSIP_PORT,
        DSIP_USERNAME = NEW_DSIP_USERNAME,
        DSIP_PASSWORD = NEW_DSIP_PASSWORD,
        DSIP_IPC_PASS = NEW_DSIP_IPC_PASS,
        DSIP_API_PROTO = NEW_DSIP_API_PROTO,
        DSIP_API_PORT = NEW_DSIP_API_PORT,
        DSIP_PRIV_KEY = NEW_DSIP_PRIV_KEY,
        DSIP_PID_FILE = NEW_DSIP_PID_FILE,
        DSIP_UNIX_SOCK = NEW_DSIP_UNIX_SOCK,
        DSIP_IPC_SOCK = NEW_DSIP_IPC_SOCK,
        DSIP_API_TOKEN = NEW_DSIP_API_TOKEN,
        DSIP_LOG_LEVEL = NEW_DSIP_LOG_LEVEL,
        DSIP_LOG_FACILITY = NEW_DSIP_LOG_FACILITY,
        DSIP_SSL_KEY = NEW_DSIP_SSL_KEY,
        DSIP_SSL_CERT = NEW_DSIP_SSL_CERT,
        DSIP_SSL_EMAIL = NEW_DSIP_SSL_EMAIL,
        DSIP_CERTS_DIR = NEW_DSIP_CERTS_DIR,
        VERSION = NEW_VERSION,
        DEBUG = NEW_DEBUG,
        ROLE = NEW_ROLE,
        GUI_INACTIVE_TIMEOUT = NEW_GUI_INACTIVE_TIMEOUT,
        KAM_DB_HOST = NEW_KAM_DB_HOST,
        KAM_DB_DRIVER = NEW_KAM_DB_DRIVER,
        KAM_DB_TYPE = NEW_KAM_DB_TYPE,
        KAM_DB_PORT = NEW_KAM_DB_PORT,
        KAM_DB_NAME = NEW_KAM_DB_NAME,
        KAM_DB_USER = NEW_KAM_DB_USER,
        KAM_DB_PASS = NEW_KAM_DB_PASS,
        KAM_KAMCMD_PATH = NEW_KAM_KAMCMD_PATH,
        KAM_CFG_PATH = NEW_KAM_CFG_PATH,
        KAM_TLSCFG_PATH = NEW_KAM_TLSCFG_PATH,
        RTP_CFG_PATH = NEW_RTP_CFG_PATH,
        SQLALCHEMY_TRACK_MODIFICATIONS = NEW_SQLALCHEMY_TRACK_MODIFICATIONS,
        SQLALCHEMY_SQL_DEBUG = NEW_SQLALCHEMY_SQL_DEBUG,
        FLT_CARRIER = NEW_FLT_CARRIER,
        FLT_PBX = NEW_FLT_PBX,
        FLT_MSTEAMS = NEW_FLT_MSTEAMS,
        FLT_OUTBOUND = NEW_FLT_OUTBOUND,
        FLT_INBOUND = NEW_FLT_INBOUND,
        FLT_LCR_MIN = NEW_FLT_LCR_MIN,
        FLT_FWD_MIN = NEW_FLT_FWD_MIN,
        DOMAIN = NEW_DOMAIN,
        TELEBLOCK_GW_ENABLED = NEW_TELEBLOCK_GW_ENABLED,
        TELEBLOCK_GW_IP = NEW_TELEBLOCK_GW_IP,
        TELEBLOCK_GW_PORT = NEW_TELEBLOCK_GW_PORT,
        TELEBLOCK_MEDIA_IP = NEW_TELEBLOCK_MEDIA_IP,
        TELEBLOCK_MEDIA_PORT = NEW_TELEBLOCK_MEDIA_PORT,
        FLOWROUTE_ACCESS_KEY = NEW_FLOWROUTE_ACCESS_KEY,
        FLOWROUTE_SECRET_KEY = NEW_FLOWROUTE_SECRET_KEY,
        FLOWROUTE_API_ROOT_URL = NEW_FLOWROUTE_API_ROOT_URL,
        UPLOAD_FOLDER = NEW_UPLOAD_FOLDER,
        MAIL_SERVER = NEW_MAIL_SERVER,
        MAIL_PORT = NEW_MAIL_PORT,
        MAIL_USE_TLS = NEW_MAIL_USE_TLS,
        MAIL_USERNAME = NEW_MAIL_USERNAME,
        MAIL_PASSWORD = NEW_MAIL_PASSWORD,
        MAIL_ASCII_ATTACHMENTS = NEW_MAIL_ASCII_ATTACHMENTS,
        MAIL_DEFAULT_SENDER = NEW_MAIL_DEFAULT_SENDER,
        MAIL_DEFAULT_SUBJECT = NEW_MAIL_DEFAULT_SUBJECT
    WHERE DSIP_CLUSTER_ID = NEW_DSIP_CLUSTER_ID
      AND DSIP_CLUSTER_SYNC = 1
      AND DSIP_ID != NEW_DSIP_ID;
  END IF;

  COMMIT;
END //
DELIMITER ;
