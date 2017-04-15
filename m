Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33546 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbdDOKFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Apr 2017 06:05:42 -0400
Received: by mail-wr0-f196.google.com with SMTP id l28so14869846wre.0
        for <linux-media@vger.kernel.org>; Sat, 15 Apr 2017 03:05:42 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@kernel.org,
        =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 3/5] em28xx: don't treat device as webcam if an unknown sensor is detected
Date: Sat, 15 Apr 2017 12:05:02 +0200
Message-Id: <20170415100504.3076-3-fschaefer.oss@googlemail.com>
In-Reply-To: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
References: <20170415100504.3076-1-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

With an unknown sensor, norm_maxw() and norm_maxh() return 0 as max.
height and width values, which causes a devide by zero in size_to_scale().
Of course we could use speculative default values for unknown sensors,
but the chance that the device works at this resolution without any
driver/setup is very low and therefore not worth the efforts.
Instead, just don't treat the device as camera.
A message will then be printed to the log that the device isn't supported.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 5f80a1b2fb8c..48c7fec47509 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2917,7 +2917,9 @@ static void em28xx_card_setup(struct em28xx *dev)
 	 * If sensor is not found, then it isn't a webcam.
 	 */
 	if (dev->board.is_webcam) {
-		if (em28xx_detect_sensor(dev) < 0)
+		em28xx_detect_sensor(dev);
+		if (dev->em28xx_sensor == EM28XX_NOSENSOR)
+			/* NOTE: error/unknown sensor/no sensor */
 			dev->board.is_webcam = 0;
 	}
 
@@ -3665,9 +3667,11 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 		try_bulk = usb_xfer_mode > 0;
 	}
 
-	/* Disable V4L2 if the device doesn't have a decoder */
+	/* Disable V4L2 if the device doesn't have a decoder or image sensor */
 	if (has_video &&
-	    dev->board.decoder == EM28XX_NODECODER && !dev->board.is_webcam) {
+	    dev->board.decoder == EM28XX_NODECODER &&
+	    dev->em28xx_sensor == EM28XX_NOSENSOR) {
+
 		dev_err(&interface->dev,
 			"Currently, V4L2 is not supported on this model\n");
 		has_video = false;
-- 
2.12.2
