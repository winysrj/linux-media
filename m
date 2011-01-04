Return-path: <mchehab@gaivota>
Received: from mail.hnelson.de ([87.230.84.188]:53466 "EHLO mail.hnelson.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab1ADTVO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 14:21:14 -0500
Received: from nova.crius.de (77-23-222-80-dynip.superkabel.de [77.23.222.80])
	by mail.hnelson.de (Postfix) with ESMTPSA id F2E263340002
	for <linux-media@vger.kernel.org>; Tue,  4 Jan 2011 20:12:25 +0100 (CET)
Date: Tue, 4 Jan 2011 20:12:20 +0100 (CET)
From: Holger Nelson <hnelson@hnelson.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Add Terratec Grabster support to tm6000
Message-ID: <alpine.DEB.2.00.1101041917040.6749@nova.crius.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

the following patch adds support for a Terratec Grabster AV MX150 (and 
maybe other devices in the Grabster series). This device is an analog 
frame grabber device using a tm5600. This device doesn't have a tuner, so 
I changed the code to skip the tuner reset if neither has_tuner nor 
has_dvb is set.

Holger

diff -urpN --exclude='*~' linux-2.6.37-rc8/drivers/staging/tm6000/tm6000-cards.c linux-lts-backport-natty-2.6.37/drivers/staging/tm6000/tm6000-cards.c
--- linux-2.6.37-rc8/drivers/staging/tm6000/tm6000-cards.c	2010-12-29 02:05:48.000000000 +0100
+++ linux-lts-backport-natty-2.6.37/drivers/staging/tm6000/tm6000-cards.c	2011-01-04 10:46:40.582497722 +0100
@@ -50,6 +50,7 @@
  #define TM6010_BOARD_BEHOLD_VOYAGER		11
  #define TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE	12
  #define TM6010_BOARD_TWINHAN_TU501		13
+#define TM5600_BOARD_TERRATEC_GRABSTER		14

  #define TM6000_MAXBOARDS        16
  static unsigned int card[]     = {[0 ... (TM6000_MAXBOARDS - 1)] = UNSET };
@@ -303,6 +304,19 @@ struct tm6000_board tm6000_boards[] = {
  			.dvb_led	= TM6010_GPIO_5,
  			.ir		= TM6010_GPIO_0,
  		},
+	},
+	[TM5600_BOARD_TERRATEC_GRABSTER] = {
+		.name         = "Terratec Grabster Series",
+		.type         = TM5600,
+		.caps = {
+			.has_tuner	= 0,
+			.has_dvb	= 0,
+			.has_zl10353	= 0,
+			.has_eeprom	= 0,
+			.has_remote	= 0,
+		},
+		.gpio = {
+		},
  	}
  };

@@ -325,6 +339,7 @@ struct usb_device_id tm6000_id_table[] =
  	{ USB_DEVICE(0x13d3, 0x3241), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
  	{ USB_DEVICE(0x13d3, 0x3243), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
  	{ USB_DEVICE(0x13d3, 0x3264), .driver_info = TM6010_BOARD_TWINHAN_TU501 },
+	{ USB_DEVICE(0x0ccd, 0x0079), .driver_info = TM5600_BOARD_TERRATEC_GRABSTER },
  	{ },
  };

@@ -505,33 +520,35 @@ int tm6000_cards_setup(struct tm6000_cor
  	 * reset, just add the code at the board-specific part
  	 */

-	if (dev->gpio.tuner_reset) {
-		for (i = 0; i < 2; i++) {
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						dev->gpio.tuner_reset, 0x00);
-			if (rc < 0) {
-				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
-				return rc;
-			}
+	if (dev->caps.has_tuner||dev->caps.has_dvb) {
+		if (dev->gpio.tuner_reset) {
+			for (i = 0; i < 2; i++) {
+				rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+							dev->gpio.tuner_reset, 0x00);
+				if (rc < 0) {
+					printk(KERN_ERR "Error %i doing tuner reset\n", rc);
+					return rc;
+				}

-			msleep(10); /* Just to be conservative */
-			rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
-						dev->gpio.tuner_reset, 0x01);
-			if (rc < 0) {
-				printk(KERN_ERR "Error %i doing tuner reset\n", rc);
-				return rc;
-			}
-			msleep(10);
+				msleep(10); /* Just to be conservative */
+				rc = tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+							dev->gpio.tuner_reset, 0x01);
+				if (rc < 0) {
+					printk(KERN_ERR "Error %i doing tuner reset\n", rc);
+					return rc;
+				}
+				msleep(10);

-			if (!i) {
-				rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
-				if (rc >= 0)
-					printk(KERN_DEBUG "board=0x%08x\n", rc);
+				if (!i) {
+					rc = tm6000_get_reg32(dev, REQ_40_GET_VERSION, 0, 0);
+					if (rc >= 0)
+						printk(KERN_DEBUG "board=0x%08x\n", rc);
+				}
  			}
+		} else {
+			printk(KERN_ERR "Tuner reset is not configured\n");
+			return -1;
  		}
-	} else {
-		printk(KERN_ERR "Tuner reset is not configured\n");
-		return -1;
  	}

  	msleep(50);
