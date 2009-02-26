Return-path: <linux-media-owner@vger.kernel.org>
Received: from ryu.zarb.org ([212.85.158.22]:52550 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZBZNmk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2009 08:42:40 -0500
Received: from localhost (localhost [127.0.0.1])
	by ryu.zarb.org (Postfix) with ESMTP id 888483F567
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 14:31:43 +0100 (CET)
Received: from ryu.zarb.org ([127.0.0.1])
	by localhost (ryu.zarb.org [127.0.0.1]) (amavisd-new, port 10025)
	with ESMTP id XPxHBqTjfpKr for <linux-media@vger.kernel.org>;
	Thu, 26 Feb 2009 14:31:42 +0100 (CET)
Received: from [192.168.100.212] (office-abk.mandriva.com [84.55.162.90])
	by ryu.zarb.org (Postfix) with ESMTPSA id 81B803F46A
	for <linux-media@vger.kernel.org>; Thu, 26 Feb 2009 14:31:42 +0100 (CET)
Subject: [PATCH] Add ids for Yuan PD378S DVB adapter
From: Pascal Terjan <pterjan@mandriva.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Thu, 26 Feb 2009 14:31:41 +0100
Message-Id: <1235655101.25173.6.camel@plop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Signed-off-by: Arnaud Patard <apatard@mandriva.com>
Signed-off-by: Pascal Terjan <pterjan@mandriva.com>

---
 drivers/media/dvb/dvb-usb/dib0700_devices.c |    7 ++++++-
 drivers/media/dvb/dvb-usb/dvb-usb-ids.h     |    1 +
 drivers/media/dvb/dvb-usb/dvb-usb.h         |    2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/dvb-usb/dib0700_devices.c b/drivers/media/dvb/dvb-usb/dib0700_devices.c
index 635d30a..fbd8a0c 100644
--- a/drivers/media/dvb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/dvb/dvb-usb/dib0700_devices.c
@@ -1396,6 +1396,7 @@ struct usb_device_id dib0700_usb_id_table[] = {
 	{ USB_DEVICE(USB_VID_TERRATEC,	USB_PID_TERRATEC_CINERGY_T_EXPRESS) },
 	{ USB_DEVICE(USB_VID_TERRATEC,
 			USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY_2) },
+	{ USB_DEVICE(USB_VID_YUAN,	USB_PID_YUAN_PD378S) },
 	{ 0 }		/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, dib0700_usb_id_table);
@@ -1595,7 +1596,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 			},
 		},
 
-		.num_device_descs = 9,
+		.num_device_descs = 10,
 		.devices = {
 			{   "DiBcom STK7070P reference design",
 				{ &dib0700_usb_id_table[15], NULL },
@@ -1633,6 +1634,10 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 				{ &dib0700_usb_id_table[33], NULL },
 				{ NULL },
 			},
+			{   "Yuan PD378S",
+				{ &dib0700_usb_id_table[44], NULL },
+				{ NULL },
+			},
 		},
 
 		.rc_interval      = DEFAULT_RC_INTERVAL,
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
index 0db0c06..a34a035 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
@@ -232,6 +232,7 @@
 #define USB_PID_ASUS_U3100				0x173f
 #define USB_PID_YUAN_EC372S				0x1edc
 #define USB_PID_YUAN_STK7700PH				0x1f08
+#define USB_PID_YUAN_PD378S				0x2edc
 #define USB_PID_DW2102					0x2102
 #define USB_PID_XTENSIONS_XD_380			0x0381
 #define USB_PID_TELESTAR_STARSTICK_2			0x8000
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index b1de0f7..6aaf576 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -223,7 +223,7 @@ struct dvb_usb_device_properties {
 	int generic_bulk_ctrl_endpoint;
 
 	int num_device_descs;
-	struct dvb_usb_device_description devices[9];
+	struct dvb_usb_device_description devices[10];
 };
 
 /**
-- 
1.6.1.3

