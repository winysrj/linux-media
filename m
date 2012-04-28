Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39154 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab2D1N5R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 09:57:17 -0400
Received: by yenl12 with SMTP id l12so920633yen.19
        for <linux-media@vger.kernel.org>; Sat, 28 Apr 2012 06:57:16 -0700 (PDT)
From: elezegarcia@gmail.com
To: mchehab@infradead.org
Cc: crope@iki.fi, gennarone@gmail.com, linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Subject: [PATCH] em28xx: Make card_setup() and pre_card_setup() static
Date: Sat, 28 Apr 2012 10:57:01 -0300
Message-Id: <4f9bf73c.a54dec0a.47ed.ffff85c4@mx.google.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ezequiel Garcia <elezegarcia@gmail.com>

This cleans namespace a bit by making em28xx_card_setup()
em28xx_pre_card_setup() static functions.

Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
---
 drivers/media/video/em28xx/em28xx-cards.c |    6 ++++--
 drivers/media/video/em28xx/em28xx.h       |    2 --
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9fd8cc7..5c0fd9f 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -69,6 +69,8 @@ struct em28xx_hash_table {
 	unsigned int  tuner;
 };
 
+static void em28xx_pre_card_setup(struct em28xx *dev);
+
 /*
  *  Reset sequences for analog/digital modes
  */
@@ -2361,7 +2363,7 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 /* Since em28xx_pre_card_setup() requires a proper dev->model,
  * this won't work for boards with generic PCI IDs
  */
-void em28xx_pre_card_setup(struct em28xx *dev)
+static void em28xx_pre_card_setup(struct em28xx *dev)
 {
 	/* Set the initial XCLK and I2C clock values based on the board
 	   definition */
@@ -2709,7 +2711,7 @@ void em28xx_register_i2c_ir(struct em28xx *dev)
 	i2c_new_probed_device(&dev->i2c_adap, &info, addr_list, NULL);
 }
 
-void em28xx_card_setup(struct em28xx *dev)
+static void em28xx_card_setup(struct em28xx *dev)
 {
 	/*
 	 * If the device can be a webcam, seek for a sensor.
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 2868b19..100d1e8 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -710,8 +710,6 @@ void em28xx_release_analog_resources(struct em28xx *dev);
 
 /* Provided by em28xx-cards.c */
 extern int em2800_variant_detect(struct usb_device *udev, int model);
-extern void em28xx_pre_card_setup(struct em28xx *dev);
-extern void em28xx_card_setup(struct em28xx *dev);
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 extern const unsigned int em28xx_bcount;
-- 
1.7.3.4

