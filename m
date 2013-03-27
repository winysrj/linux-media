Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:62924 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3C0VG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:28 -0400
Received: by mail-ee0-f53.google.com with SMTP id c13so1742293eek.26
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:27 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/9] em28xx: fix and separate the board hints for sensor devices
Date: Wed, 27 Mar 2013 22:06:28 +0100
Message-Id: <1364418396-8191-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The current board hint code is mixed together with the sensor detection and
initialization code. It actually selects a board depending on the detected
sensor type only, with the result that 3 of the 6 webcam boards are currently
dead.

Separate it and move it to em28xx_hint_board() which already contains the board
hints for analog capturing+TV and DVB devices.
This way, we have all board hints at a common place which makes it easier
to extend the code and reduces the risk of regressions.
It also makes it possible again to use the boards EM2750_BOARD_DLCW_130,
EM2820_BOARD_VIDEOLOGY_20K14XUSB and EM2860_BOARD_NETGMBH_CAM (using the module
parameter "card").

NOTE: the current board hint logic for webcams is preserved. Not more not less.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |   40 +++++++++++++++----------------
 1 Datei geändert, 19 Zeilen hinzugefügt(+), 21 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 54e0362..e41ecb5 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2333,9 +2333,6 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 	switch (version) {
 	case 0x8232:		/* mt9v011 640x480 1.3 Mpix sensor */
 	case 0x8243:		/* mt9v011 rev B 640x480 1.3 Mpix sensor */
-		dev->model = EM2820_BOARD_SILVERCREST_WEBCAM;
-		em28xx_set_model(dev);
-
 		sensor_name = "mt9v011";
 		dev->em28xx_sensor = EM28XX_MT9V011;
 		dev->sensor_xres = 640;
@@ -2359,9 +2356,6 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 		break;
 
 	case 0x143a:    /* MT9M111 as found in the ECS G200 */
-		dev->model = EM2750_BOARD_UNKNOWN;
-		em28xx_set_model(dev);
-
 		sensor_name = "mt9m111";
 		dev->board.xclk = EM28XX_XCLK_FREQUENCY_48MHZ;
 		dev->em28xx_sensor = EM28XX_MT9M111;
@@ -2375,9 +2369,6 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 		break;
 
 	case 0x8431:
-		dev->model = EM2750_BOARD_UNKNOWN;
-		em28xx_set_model(dev);
-
 		sensor_name = "mt9m001";
 		dev->em28xx_sensor = EM28XX_MT9M001;
 		em28xx_initialize_mt9m001(dev);
@@ -2394,11 +2385,7 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 		return -EINVAL;
 	}
 
-	/* Setup webcam defaults */
-	em28xx_pre_card_setup(dev);
-
-	em28xx_errdev("Sensor is %s, using model %s entry.\n",
-		      sensor_name, em28xx_boards[dev->model].name);
+	em28xx_info("sensor %s detected\n", sensor_name);
 
 	return 0;
 }
@@ -2628,6 +2615,18 @@ static int em28xx_hint_board(struct em28xx *dev)
 {
 	int i;
 
+	if (dev->board.is_webcam) {
+		if (dev->em28xx_sensor == EM28XX_MT9V011) {
+			dev->model = EM2820_BOARD_SILVERCREST_WEBCAM;
+		} else if (dev->em28xx_sensor == EM28XX_MT9M001 ||
+			   dev->em28xx_sensor == EM28XX_MT9M111) {
+			dev->model = EM2750_BOARD_UNKNOWN;
+		}
+		/* FIXME: IMPROVE ! */
+
+		return 0;
+	}
+
 	/* HINT method: EEPROM
 	 *
 	 * This method works only for boards with eeprom.
@@ -2719,10 +2718,10 @@ static void em28xx_card_setup(struct em28xx *dev)
 			dev->progressive = 1;
 	}
 
-	if (!dev->board.is_webcam) {
-		switch (dev->model) {
-		case EM2820_BOARD_UNKNOWN:
-		case EM2800_BOARD_UNKNOWN:
+	switch (dev->model) {
+	case EM2750_BOARD_UNKNOWN:
+	case EM2820_BOARD_UNKNOWN:
+	case EM2800_BOARD_UNKNOWN:
 		/*
 		 * The K-WORLD DVB-T 310U is detected as an MSI Digivox AD.
 		 *
@@ -2743,9 +2742,8 @@ static void em28xx_card_setup(struct em28xx *dev)
 			em28xx_pre_card_setup(dev);
 		}
 		break;
-		default:
-			em28xx_set_model(dev);
-		}
+	default:
+		em28xx_set_model(dev);
 	}
 
 	em28xx_info("Identified as %s (card=%d)\n",
-- 
1.7.10.4

