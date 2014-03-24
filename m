Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:39038 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaCXTdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:14 -0400
Received: by mail-ee0-f48.google.com with SMTP id b57so4800195eek.7
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:13 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 17/19] em28xx: remove field tda9887_conf from struct em28xx
Date: Mon, 24 Mar 2014 20:33:23 +0100
Message-Id: <1395689605-2705-18-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tda9887 configuration is already stored in the board data, and it is used
only one time by the v4l2 sub-module at tuner setup.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 3 ---
 drivers/media/usb/em28xx/em28xx-video.c | 6 +++---
 drivers/media/usb/em28xx/em28xx.h       | 1 -
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 64ea25a..b81946f 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2719,9 +2719,6 @@ static void em28xx_card_setup(struct em28xx *dev)
 	if (em28xx_boards[dev->model].tuner_addr)
 		dev->tuner_addr = em28xx_boards[dev->model].tuner_addr;
 
-	if (em28xx_boards[dev->model].tda9887_conf)
-		dev->tda9887_conf = em28xx_boards[dev->model].tda9887_conf;
-
 	/* request some modules */
 	switch (dev->model) {
 	case EM2820_BOARD_HAUPPAUGE_WINTV_USB_2:
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 35bf2b9..8c0082c 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2254,11 +2254,11 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 				     0, tuner, s_type_addr, &tun_setup);
 	}
 
-	if (dev->tda9887_conf) {
+	if (dev->board.tda9887_conf) {
 		struct v4l2_priv_tun_config tda9887_cfg;
 
 		tda9887_cfg.tuner = TUNER_TDA9887;
-		tda9887_cfg.priv = &dev->tda9887_conf;
+		tda9887_cfg.priv = &dev->board.tda9887_conf;
 
 		v4l2_device_call_all(v4l2_dev,
 				     0, tuner, s_config, &tda9887_cfg);
@@ -2364,7 +2364,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Initialize tuner and camera */
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
-		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
+		int has_demod = (dev->board.tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
 			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 8a0ed93..917cb25 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -633,7 +633,6 @@ struct em28xx {
 
 	int tuner_type;		/* type of the tuner */
 	int tuner_addr;		/* tuner address */
-	int tda9887_conf;
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
-- 
1.8.4.5

