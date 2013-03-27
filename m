Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:57689 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab3C0VGa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Mar 2013 17:06:30 -0400
Received: by mail-ee0-f49.google.com with SMTP id d41so4439400eek.36
        for <linux-media@vger.kernel.org>; Wed, 27 Mar 2013 14:06:29 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/9] em28xx: rename em28xx_hint_sensor() to em28xx_detect_sensor()
Date: Wed, 27 Mar 2013 22:06:30 +0100
Message-Id: <1364418396-8191-4-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1364418396-8191-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that the board hints and the sensor initialization/configuration have been
separated, em28xx_detect_sensor() is the better name for this function.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    7 +++----
 1 Datei geändert, 3 Zeilen hinzugefügt(+), 4 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index c8ad7e5..7bb760e 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2309,11 +2309,10 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
 	return 0;
 }
 
-/* HINT method: webcam I2C chips
- *
+/*
  * This method works for webcams with Micron sensors
  */
-static int em28xx_hint_sensor(struct em28xx *dev)
+static int em28xx_detect_sensor(struct em28xx *dev)
 {
 	int rc;
 	char *sensor_name;
@@ -2746,7 +2745,7 @@ static void em28xx_card_setup(struct em28xx *dev)
 	 * If sensor is not found, then it isn't a webcam.
 	 */
 	if (dev->board.is_webcam) {
-		if (em28xx_hint_sensor(dev) < 0)
+		if (em28xx_detect_sensor(dev) < 0)
 			dev->board.is_webcam = 0;
 		else
 			dev->progressive = 1;
-- 
1.7.10.4

