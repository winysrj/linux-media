Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933233Ab3CSQvL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Mar 2013 12:51:11 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doron Cohen <doronc@siano-ms.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 21/46] [media] siano: add new devices to the Siano Driver
Date: Tue, 19 Mar 2013 13:49:10 -0300
Message-Id: <1363711775-2120-22-git-send-email-mchehab@redhat.com>
In-Reply-To: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
References: <1363711775-2120-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is based on Doron Cohen's patches:
	http://patchwork.linuxtv.org/patch/7881/
	http://patchwork.linuxtv.org/patch/7888/
	http://patchwork.linuxtv.org/patch/7883/

It basically merges the above patches, rebasing them to
the macro definitions used upstream, with are different
 than the ones used by them internally.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/common/siano/sms-cards.c | 65 ++++++++++++++++++++++++++++++++--
 drivers/media/common/siano/sms-cards.h |  8 +++++
 drivers/media/mmc/siano/smssdio.c      | 10 ++++++
 drivers/media/usb/siano/smsusb.c       | 31 ++++++++++++++++
 4 files changed, 111 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/siano/sms-cards.c b/drivers/media/common/siano/sms-cards.c
index 04bb04c..bb6e558 100644
--- a/drivers/media/common/siano/sms-cards.c
+++ b/drivers/media/common/siano/sms-cards.c
@@ -28,43 +28,53 @@ MODULE_PARM_DESC(cards_dbg, "set debug level (info=1, adv=2 (or-able))");
 static struct sms_board sms_boards[] = {
 	[SMS_BOARD_UNKNOWN] = {
 		.name	= "Unknown board",
+		.type = SMS_UNKNOWN_TYPE,
+		.default_mode = DEVICE_MODE_NONE,
 	},
 	[SMS1XXX_BOARD_SIANO_STELLAR] = {
 		.name	= "Siano Stellar Digital Receiver",
 		.type	= SMS_STELLAR,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_A] = {
 		.name	= "Siano Nova A Digital Receiver",
 		.type	= SMS_NOVA_A0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_SIANO_NOVA_B] = {
 		.name	= "Siano Nova B Digital Receiver",
 		.type	= SMS_NOVA_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_SIANO_VEGA] = {
 		.name	= "Siano Vega Digital Receiver",
 		.type	= SMS_VEGA,
+		.default_mode = DEVICE_MODE_CMMB,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT] = {
 		.name	= "Hauppauge Catamount",
 		.type	= SMS_STELLAR,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-stellar-dvbt-01.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A] = {
 		.name	= "Hauppauge Okemo-A",
 		.type	= SMS_NOVA_A0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-a-dvbt-01.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B] = {
 		.name	= "Hauppauge Okemo-B",
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-nova-b-dvbt-01.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
 		.name	= "Hauppauge WinTV MiniStick",
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.rc_codes = RC_MAP_HAUPPAUGE,
 		.board_cfg.leds_power = 26,
 		.board_cfg.led0 = 27,
@@ -78,6 +88,7 @@ static struct sms_board sms_boards[] = {
 		.name	= "Hauppauge WinTV MiniCard",
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.lna_ctrl  = 29,
 		.board_cfg.foreign_lna0_ctrl = 29,
 		.rf_switch = 17,
@@ -87,17 +98,64 @@ static struct sms_board sms_boards[] = {
 		.name	= "Hauppauge WinTV MiniCard",
 		.type	= SMS_NOVA_B0,
 		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 		.lna_ctrl  = -1,
 	},
 	[SMS1XXX_BOARD_SIANO_NICE] = {
-	/* 11 */
 		.name = "Siano Nice Digital Receiver",
 		.type = SMS_NOVA_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
 	},
 	[SMS1XXX_BOARD_SIANO_VENICE] = {
-	/* 12 */
 		.name = "Siano Venice Digital Receiver",
 		.type = SMS_VEGA,
+		.default_mode = DEVICE_MODE_CMMB,
+	},
+	[SMS1XXX_BOARD_SIANO_STELLAR_ROM] = {
+		.name = "Siano Stellar Digital Receiver ROM",
+		.type = SMS_STELLAR,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
+		.intf_num = 1,
+	},
+	[SMS1XXX_BOARD_ZTE_DVB_DATA_CARD] = {
+		.name = "ZTE Data Card Digital Receiver",
+		.type = SMS_NOVA_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
+		.intf_num = 5,
+		.mtu = 15792,
+	},
+	[SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD] = {
+		.name = "ONDA Data Card Digital Receiver",
+		.type = SMS_NOVA_B0,
+		.default_mode = DEVICE_MODE_DVBT_BDA,
+		.intf_num = 6,
+		.mtu = 15792,
+	},
+	[SMS1XXX_BOARD_SIANO_MING] = {
+		.name = "Siano Ming Digital Receiver",
+		.type = SMS_MING,
+		.default_mode = DEVICE_MODE_CMMB,
+	},
+	[SMS1XXX_BOARD_SIANO_PELE] = {
+		.name = "Siano Pele Digital Receiver",
+		.type = SMS_PELE,
+		.default_mode = DEVICE_MODE_ISDBT_BDA,
+	},
+	[SMS1XXX_BOARD_SIANO_RIO] = {
+		.name = "Siano Rio Digital Receiver",
+		.type = SMS_RIO,
+		.default_mode = DEVICE_MODE_ISDBT_BDA,
+	},
+	[SMS1XXX_BOARD_SIANO_DENVER_1530] = {
+		.name = "Siano Denver (ATSC-M/H) Digital Receiver",
+		.type = SMS_DENVER_1530,
+		.default_mode = DEVICE_MODE_ATSC,
+		.crystal = 2400,
+	},
+	[SMS1XXX_BOARD_SIANO_DENVER_2160] = {
+		.name = "Siano Denver (TDMB) Digital Receiver",
+		.type = SMS_DENVER_2160,
+		.default_mode = DEVICE_MODE_DAB_TDMB,
 	},
 };
 
@@ -119,7 +177,8 @@ static inline void sms_gpio_assign_11xx_default_led_config(
 }
 
 int sms_board_event(struct smscore_device_t *coredev,
-		enum SMS_BOARD_EVENTS gevent) {
+		    enum SMS_BOARD_EVENTS gevent)
+{
 	struct smscore_config_gpio MyGpioConfig;
 
 	sms_gpio_assign_11xx_default_led_config(&MyGpioConfig);
diff --git a/drivers/media/common/siano/sms-cards.h b/drivers/media/common/siano/sms-cards.h
index 60d26be..777a4a0 100644
--- a/drivers/media/common/siano/sms-cards.h
+++ b/drivers/media/common/siano/sms-cards.h
@@ -37,6 +37,14 @@
 #define SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 10
 #define SMS1XXX_BOARD_SIANO_NICE	11
 #define SMS1XXX_BOARD_SIANO_VENICE	12
+#define SMS1XXX_BOARD_SIANO_STELLAR_ROM 13
+#define SMS1XXX_BOARD_ZTE_DVB_DATA_CARD	14
+#define SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD 15
+#define SMS1XXX_BOARD_SIANO_MING	16
+#define SMS1XXX_BOARD_SIANO_PELE	17
+#define SMS1XXX_BOARD_SIANO_RIO		18
+#define SMS1XXX_BOARD_SIANO_DENVER_1530	19
+#define SMS1XXX_BOARD_SIANO_DENVER_2160 20
 
 struct sms_board_gpio_cfg {
 	int lna_vhf_exist;
diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index 15d3493..c96da47 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -61,6 +61,16 @@ static const struct sdio_device_id smssdio_ids[] = {
 	 .driver_data = SMS1XXX_BOARD_SIANO_VEGA},
 	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, SDIO_DEVICE_ID_SIANO_VENICE),
 	 .driver_data = SMS1XXX_BOARD_SIANO_VEGA},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x302),
+	.driver_data = SMS1XXX_BOARD_SIANO_MING},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x500),
+	.driver_data = SMS1XXX_BOARD_SIANO_PELE},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x600),
+	.driver_data = SMS1XXX_BOARD_SIANO_RIO},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x700),
+	.driver_data = SMS1XXX_BOARD_SIANO_DENVER_2160},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_SIANO, 0x800),
+	.driver_data = SMS1XXX_BOARD_SIANO_DENVER_1530},
 	{ /* end: all zeroes */ },
 };
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index a31bf74..751c0d6 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -441,6 +441,7 @@ static int smsusb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
+	char devpath[32];
 	int i, rc;
 
 	sms_info("interface number %d",
@@ -485,6 +486,16 @@ static int smsusb_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
+	if (id->driver_info == SMS1XXX_BOARD_SIANO_STELLAR_ROM) {
+		sms_info("stellar device was found.");
+		snprintf(devpath, sizeof(devpath), "usb\\%d-%s",
+			 udev->bus->busnum, udev->devpath);
+		sms_info("stellar device was found.");
+		return smsusb1_load_firmware(
+				udev, smscore_registry_getmode(devpath),
+				id->driver_info);
+	}
+
 	rc = smsusb_init_device(intf, id->driver_info);
 	sms_info("rc %d", rc);
 	sms_board_load_modules(id->driver_info);
@@ -602,6 +613,26 @@ static const struct usb_device_id smsusb_id_table[] = {
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
 	{ USB_DEVICE(0x2040, 0xf5a0),
 		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
+	{ USB_DEVICE(0x187f, 0x0202),
+		.driver_info = SMS1XXX_BOARD_SIANO_NICE },
+	{ USB_DEVICE(0x187f, 0x0301),
+		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
+	{ USB_DEVICE(0x187f, 0x0302),
+		.driver_info = SMS1XXX_BOARD_SIANO_VENICE },
+	{ USB_DEVICE(0x187f, 0x0310),
+		.driver_info = SMS1XXX_BOARD_SIANO_MING },
+	{ USB_DEVICE(0x187f, 0x0500),
+		.driver_info = SMS1XXX_BOARD_SIANO_PELE },
+	{ USB_DEVICE(0x187f, 0x0600),
+		.driver_info = SMS1XXX_BOARD_SIANO_RIO },
+	{ USB_DEVICE(0x187f, 0x0700),
+		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_2160 },
+	{ USB_DEVICE(0x187f, 0x0800),
+		.driver_info = SMS1XXX_BOARD_SIANO_DENVER_1530 },
+	{ USB_DEVICE(0x19D2, 0x0086),
+		.driver_info = SMS1XXX_BOARD_ZTE_DVB_DATA_CARD },
+	{ USB_DEVICE(0x19D2, 0x0078),
+		.driver_info = SMS1XXX_BOARD_ONDA_MDTV_DATA_CARD },
 	{ } /* Terminating entry */
 	};
 
-- 
1.8.1.4

