Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48587 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbaCXTdP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 15:33:15 -0400
Received: by mail-ee0-f53.google.com with SMTP id b57so4798060eek.26
        for <linux-media@vger.kernel.org>; Mon, 24 Mar 2014 12:33:14 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 18/19] em28xx: remove field tuner_addr from struct em28xx
Date: Mon, 24 Mar 2014 20:33:24 +0100
Message-Id: <1395689605-2705-19-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1395689605-2705-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The tuner address is only used by the v4l submodule and at tuner setup and
can be obtained from the board data directly (if specified).

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |  2 --
 drivers/media/usb/em28xx/em28xx-video.c | 17 ++++++++---------
 drivers/media/usb/em28xx/em28xx.h       |  1 -
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index b81946f..e552375 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2716,8 +2716,6 @@ static void em28xx_card_setup(struct em28xx *dev)
 		    dev->board.name, dev->model);
 
 	dev->tuner_type = em28xx_boards[dev->model].tuner_type;
-	if (em28xx_boards[dev->model].tuner_addr)
-		dev->tuner_addr = em28xx_boards[dev->model].tuner_addr;
 
 	/* request some modules */
 	switch (dev->model) {
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 8c0082c..254a7ff 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2223,16 +2223,13 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	return vfd;
 }
 
-static void em28xx_tuner_setup(struct em28xx *dev)
+static void em28xx_tuner_setup(struct em28xx *dev, unsigned short tuner_addr)
 {
 	struct em28xx_v4l2      *v4l2 = dev->v4l2;
 	struct v4l2_device      *v4l2_dev = &v4l2->v4l2_dev;
 	struct tuner_setup      tun_setup;
 	struct v4l2_frequency   f;
 
-	if (dev->tuner_type == TUNER_ABSENT)
-		return;
-
 	memset(&tun_setup, 0, sizeof(tun_setup));
 
 	tun_setup.mode_mask = T_ANALOG_TV | T_RADIO;
@@ -2248,7 +2245,7 @@ static void em28xx_tuner_setup(struct em28xx *dev)
 
 	if ((dev->tuner_type != TUNER_ABSENT) && (dev->tuner_type)) {
 		tun_setup.type   = dev->tuner_type;
-		tun_setup.addr   = dev->tuner_addr;
+		tun_setup.addr   = tuner_addr;
 
 		v4l2_device_call_all(v4l2_dev,
 				     0, tuner, s_type_addr, &tun_setup);
@@ -2364,6 +2361,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 	/* Initialize tuner and camera */
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
+		unsigned short tuner_addr = dev->board.tuner_addr;
 		int has_demod = (dev->board.tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
@@ -2375,7 +2373,7 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
 				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
-		if (dev->tuner_addr == 0) {
+		if (tuner_addr == 0) {
 			enum v4l2_i2c_tuner_type type =
 				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 			struct v4l2_subdev *sd;
@@ -2385,15 +2383,16 @@ static int em28xx_v4l2_init(struct em28xx *dev)
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
-				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
+				tuner_addr = v4l2_i2c_subdev_addr(sd);
 		} else {
 			v4l2_i2c_new_subdev(&v4l2->v4l2_dev,
 					    &dev->i2c_adap[dev->def_i2c_bus],
-					    "tuner", dev->tuner_addr, NULL);
+					    "tuner", tuner_addr, NULL);
 		}
+
+		em28xx_tuner_setup(dev, tuner_addr);
 	}
 
-	em28xx_tuner_setup(dev);
 	if (dev->em28xx_sensor != EM28XX_NOSENSOR)
 		em28xx_init_camera(dev);
 
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 917cb25..3a3fe16 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -632,7 +632,6 @@ struct em28xx {
 	struct em28xx_audio_mode audio_mode;
 
 	int tuner_type;		/* type of the tuner */
-	int tuner_addr;		/* tuner address */
 
 	/* i2c i/o */
 	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
-- 
1.8.4.5

