Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:40936 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755736Ab1EATGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 15:06:05 -0400
Received: from tobias-t61p.localnet (unknown [10.2.3.10])
	by mail.lorenz.priv (Postfix) with ESMTPS id 9B0FB14485
	for <linux-media@vger.kernel.org>; Sun,  1 May 2011 21:06:01 +0200 (CEST)
From: Tobias Lorenz <tobias.lorenz@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/6] remove version check in usb_driver_probe.
Date: Sun, 1 May 2011 21:02:22 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105012102.22789.tobias.lorenz@gmx.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This patch removes the version check in usb_driver_probe.
All device seem to work.
If there are some troubles, the version is in the logs anyway.

Signed-off-by: Tobias Lorenz <tobias.lorenz@gmx.net>
---
 drivers/media/radio/si470x/radio-si470x-usb.c |   46 
----------------------------------------------
 1 file changed, 46 deletions(-)

diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c 
b/drivers/media/radio/si470x/radio-si470x-usb.c
index 392e84f..a6721c1 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -139,15 +139,6 @@ MODULE_PARM_DESC(max_rds_errors, "RDS maximum block 
errors: *1*");
 
 
 /**************************************************************************
- * Software/Hardware Versions from Scratch Page
- **************************************************************************/
-#define RADIO_SW_VERSION_NOT_BOOTLOADABLE	6
-#define RADIO_SW_VERSION			7
-#define RADIO_HW_VERSION			1
-
-
-
-/**************************************************************************
  * LED State Definitions
  **************************************************************************/
 #define LED_COMMAND		0x35
@@ -649,7 +649,6 @@ static int si470x_usb_driver_probe(struct usb_interface 
*intf,
 	struct usb_host_interface *iface_desc;
 	struct usb_endpoint_descriptor *endpoint;
 	int i, int_end_size, retval = 0;
-	unsigned char version_warning = 0;
 
 	/* private data allocation and initialization */
 	radio = kzalloc(sizeof(struct si470x_device), GFP_KERNEL);
@@ -712,15 +711,6 @@ static int si470x_usb_driver_probe(struct usb_interface 
*intf,
 	}
 	dev_info(&intf->dev, "DeviceID=0x%4.4hx ChipID=0x%4.4hx\n",
 			radio->registers[DEVICEID], radio->registers[CHIPID]);
-	if ((radio->registers[CHIPID] & CHIPID_FIRMWARE) < RADIO_FW_VERSION) {
-		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"firmware version %hu,\n", RADIO_FW_VERSION);
-		dev_warn(&intf->dev,
-			"but the device has firmware version %hu.\n",
-			radio->registers[CHIPID] & CHIPID_FIRMWARE);
-		version_warning = 1;
-	}
 
 	/* get software and hardware versions */
 	if (si470x_get_scratch_page_versions(radio) < 0) {
@@ -729,33 +719,6 @@ static int si470x_usb_driver_probe(struct usb_interface 
*intf,
 	}
 	dev_info(&intf->dev, "software version %d, hardware version %d\n",
 			radio->software_version, radio->hardware_version);
-	if (radio->software_version < RADIO_SW_VERSION) {
-		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"software version %hu,\n", RADIO_SW_VERSION);
-		dev_warn(&intf->dev,
-			"but the device has software version %hu.\n",
-			radio->software_version);
-		version_warning = 1;
-	}
-	if (radio->hardware_version < RADIO_HW_VERSION) {
-		dev_warn(&intf->dev,
-			"This driver is known to work with "
-			"hardware version %hu,\n", RADIO_HW_VERSION);
-		dev_warn(&intf->dev,
-			"but the device has hardware version %hu.\n",
-			radio->hardware_version);
-		version_warning = 1;
-	}
-
-	/* give out version warning */
-	if (version_warning == 1) {
-		dev_warn(&intf->dev,
-			"If you have some trouble using this driver,\n");
-		dev_warn(&intf->dev,
-			"please report to V4L ML at "
-			"linux-media@vger.kernel.org\n");
-	}
 
 	/* set initial frequency */
 	si470x_set_freq(radio, 87.5 * FREQ_MUL); /* available in all regions */
-- 
1.7.4.1

