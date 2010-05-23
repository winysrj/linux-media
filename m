Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:51786 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939Ab0EWSbO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 May 2010 14:31:14 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, d.belimov@gmail.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/5] tm6000: add power led off
Date: Sun, 23 May 2010 20:29:25 +0200
Message-Id: <1274639366-2613-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1274639366-2613-1-git-send-email-stefan.ringel@arcor.de>
References: <1274639366-2613-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

- add power led off, if device is disconnected



Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-cards.c |   19 +++++++++++++++++++
 drivers/staging/tm6000/tm6000-core.c  |   13 +++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 33b134b..553ebe4 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -925,6 +925,25 @@ static void tm6000_usb_disconnect(struct usb_interface *interface)
 	}
 #endif
 
+	if (dev->gpio.power_led) {
+		switch (dev->model) {
+		case TM6010_BOARD_HAUPPAUGE_900H:
+		case TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE:
+		case TM6010_BOARD_TWINHAN_TU501:
+			/* Power led off */
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x01);
+			msleep(15);
+			break;
+		case TM6010_BOARD_BEHOLD_WANDER:
+		case TM6010_BOARD_BEHOLD_VOYAGER:
+			/* Power led off */
+			tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+				dev->gpio.power_led, 0x00);
+			msleep(15);
+			break;
+		}
+	}
 	tm6000_v4l2_unregister(dev);
 
 	tm6000_i2c_unregister(dev);
diff --git a/drivers/staging/tm6000/tm6000-core.c b/drivers/staging/tm6000/tm6000-core.c
index 1259ae5..624c276 100644
--- a/drivers/staging/tm6000/tm6000-core.c
+++ b/drivers/staging/tm6000/tm6000-core.c
@@ -323,6 +323,12 @@ int tm6000_init_analog_mode (struct tm6000_core *dev)
 	tm6000_set_standard (dev, &dev->norm);
 	tm6000_set_audio_bitrate (dev,48000);
 
+	/* switch dvb led off */
+	if (dev->gpio.dvb_led) {
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+			dev->gpio.dvb_led, 0x01);
+	}
+
 	return 0;
 }
 
@@ -375,6 +381,13 @@ int tm6000_init_digital_mode (struct tm6000_core *dev)
 		tm6000_set_reg (dev, REQ_04_EN_DISABLE_MCU_INT, 0x0020, 0x00);
 		msleep(100);
 	}
+
+	/* switch dvb led on */
+	if (dev->gpio.dvb_led) {
+		tm6000_set_reg(dev, REQ_03_SET_GET_MCU_PIN,
+			dev->gpio.dvb_led, 0x00);
+	}
+
 	return 0;
 }
 
-- 
1.7.0.3

