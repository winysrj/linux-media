Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932300Ab0IXOOi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jean Delvare <khali@linux-fr.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Pete Eberlein <pete@sensoray.com>,
	Mike Isely <isely@pobox.com>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <mkaricheri@gmail.com>
Subject: [PATCH 02/16] v4l: Remove hardcoded module names passed to v4l2_i2c_new_subdev*
Date: Fri, 24 Sep 2010 16:14:00 +0200
Message-Id: <1285337654-5044-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

With the v4l2_i2c_new_subdev* functions now supporting loading modules
based on modaliases, replace the hardcoded module name passed to those
functions by NULL.

All corresponding I2C modules have been checked, and all of them include
a module aliases table with names corresponding to what the drivers
modified here use.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/video/au0828/au0828-cards.c     |    4 ++--
 drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++++++++-----------
 drivers/media/video/cafe_ccic.c               |    2 +-
 drivers/media/video/cx231xx/cx231xx-cards.c   |    4 ++--
 drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    6 +++---
 drivers/media/video/cx88/cx88-cards.c         |    8 ++++----
 drivers/media/video/cx88/cx88-video.c         |    4 ++--
 drivers/media/video/em28xx/em28xx-cards.c     |   18 +++++++++---------
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/mxb.c                     |   12 ++++++------
 drivers/media/video/saa7134/saa7134-cards.c   |    8 ++++----
 drivers/media/video/saa7134/saa7134-core.c    |    4 ++--
 drivers/media/video/usbvision/usbvision-i2c.c |    6 +++---
 drivers/media/video/vino.c                    |    4 ++--
 drivers/staging/tm6000/tm6000-cards.c         |    4 ++--
 16 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 57dd919..0453816 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -212,7 +212,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 		   be abstracted out if we ever need to support a different
 		   demod) */
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				"au8522", "au8522", 0x8e >> 1, NULL);
+				NULL, "au8522", 0x8e >> 1, NULL);
 		if (sd == NULL)
 			printk(KERN_ERR "analog subdev registration failed\n");
 	}
@@ -221,7 +221,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		/* Load the tuner module, which does the attach */
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				"tuner", "tuner", dev->board.tuner_addr, NULL);
+				NULL, "tuner", dev->board.tuner_addr, NULL);
 		if (sd == NULL)
 			printk(KERN_ERR "tuner subdev registration fail\n");
 
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 7af56cd..87d8b00 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3529,7 +3529,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "saa6588", "saa6588", 0, addrs);
+			&btv->c.i2c_adap, NULL, "saa6588", 0, addrs);
 		btv->has_saa6588 = (sd != NULL);
 	}
 
@@ -3554,7 +3554,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "msp3400", "msp3400", 0, addrs);
+			&btv->c.i2c_adap, NULL, "msp3400", 0, addrs);
 		if (btv->sd_msp34xx)
 			return;
 		goto no_audio;
@@ -3568,7 +3568,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tda7432", "tda7432", 0, addrs))
+				&btv->c.i2c_adap, NULL, "tda7432", 0, addrs))
 			return;
 		goto no_audio;
 	}
@@ -3576,7 +3576,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	case 3: {
 		/* The user specified that we should probe for tvaudio */
 		btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "tvaudio", "tvaudio", 0, tvaudio_addrs());
+			&btv->c.i2c_adap, NULL, "tvaudio", 0, tvaudio_addrs());
 		if (btv->sd_tvaudio)
 			return;
 		goto no_audio;
@@ -3596,11 +3596,11 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	   found is really something else (e.g. a tea6300). */
 	if (!bttv_tvcards[btv->c.type].no_msp34xx) {
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "msp3400", "msp3400",
+			&btv->c.i2c_adap, NULL, "msp3400",
 			0, I2C_ADDRS(I2C_ADDR_MSP3400 >> 1));
 	} else if (bttv_tvcards[btv->c.type].msp34xx_alt) {
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, "msp3400", "msp3400",
+			&btv->c.i2c_adap, NULL, "msp3400",
 			0, I2C_ADDRS(I2C_ADDR_MSP3400_ALT >> 1));
 	}
 
@@ -3616,13 +3616,13 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tda7432", "tda7432", 0, addrs))
+				&btv->c.i2c_adap, NULL, "tda7432", 0, addrs))
 			return;
 	}
 
 	/* Now see if we can find one of the tvaudio devices. */
 	btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-		&btv->c.i2c_adap, "tvaudio", "tvaudio", 0, tvaudio_addrs());
+		&btv->c.i2c_adap, NULL, "tvaudio", 0, tvaudio_addrs());
 	if (btv->sd_tvaudio)
 		return;
 
@@ -3646,13 +3646,13 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 		/* Load tuner module before issuing tuner config call! */
 		if (bttv_tvcards[btv->c.type].has_radio)
 			v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tuner", "tuner",
+				&btv->c.i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
 		v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tuner", "tuner",
+				&btv->c.i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, "tuner", "tuner",
+				&btv->c.i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
 
 		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 2ffb6df..780f3ff 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2014,7 +2014,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 
 	cam->sensor_addr = 0x42;
 	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, &cam->i2c_adapter,
-			"ov7670", "ov7670", cam->sensor_addr, NULL);
+			NULL, "ov7670", cam->sensor_addr, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index f2a4900..daaa3b4 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -319,7 +319,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	if (dev->board.decoder == CX231XX_AVDECODER) {
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 					&dev->i2c_bus[0].i2c_adap,
-					"cx25840", "cx25840", 0x88 >> 1, NULL);
+					NULL, "cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
@@ -329,7 +329,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		dev->sd_tuner =	v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				"tuner", "tuner", 0xc2 >> 1, NULL);
+				NULL, "tuner", 0xc2 >> 1, NULL);
 		if (dev->sd_tuner == NULL)
 			cx231xx_info("tuner subdev registration failure\n");
 
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index e76ce87..db05400 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -1247,7 +1247,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
-				"cx25840", "cx25840", 0x88 >> 1, NULL);
+				NULL, "cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840) {
 			dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
 			v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 5aadc1d..4920ddd 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1512,11 +1512,11 @@ int cx23885_video_register(struct cx23885_dev *dev)
 		if (dev->tuner_addr)
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				"tuner", "tuner", dev->tuner_addr, NULL);
+				NULL, "tuner", dev->tuner_addr, NULL);
 		else
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[1].i2c_adap,
-				"tuner", "tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
+				&dev->i2c_bus[1].i2c_adap, NULL,
+				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
 		if (sd) {
 			struct tuner_setup tun_setup;
 
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 97672cb..b0613f7 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3485,19 +3485,19 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		   later code configures a tea5767.
 		 */
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"tuner", "tuner",
+				NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
 		if (has_demod)
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, "tuner", "tuner",
+				&core->i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (core->board.tuner_addr == ADDR_UNSET) {
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, "tuner", "tuner",
+				&core->i2c_adap, NULL, "tuner",
 				0, has_demod ? tv_addrs + 4 : tv_addrs);
 		} else {
 			v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"tuner", "tuner", core->board.tuner_addr, NULL);
+				NULL, "tuner", core->board.tuner_addr, NULL);
 		}
 	}
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index b755bf1..f9d1877 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1873,14 +1873,14 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 	if (core->board.audio_chip == V4L2_IDENT_WM8775)
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				"wm8775", "wm8775", 0x36 >> 1, NULL);
+				NULL, "wm8775", 0x36 >> 1, NULL);
 
 	if (core->board.audio_chip == V4L2_IDENT_TVAUDIO) {
 		/* This probes for a tda9874 as is used on some
 		   Pixelview Ultra boards. */
 		v4l2_i2c_new_subdev(&core->v4l2_dev,
 				&core->i2c_adap,
-				"tvaudio", "tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
+				NULL, "tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
 	}
 
 	switch (core->boardnr) {
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index ffbe544..7af7860 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2523,39 +2523,39 @@ void em28xx_card_setup(struct em28xx *dev)
 	/* request some modules */
 	if (dev->board.has_msp34xx)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			"msp3400", "msp3400", 0, msp3400_addrs);
+			NULL, "msp3400", 0, msp3400_addrs);
 
 	if (dev->board.decoder == EM28XX_SAA711X)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			"saa7115", "saa7115_auto", 0, saa711x_addrs);
+			NULL, "saa7115_auto", 0, saa711x_addrs);
 
 	if (dev->board.decoder == EM28XX_TVP5150)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			"tvp5150", "tvp5150", 0, tvp5150_addrs);
+			NULL, "tvp5150", 0, tvp5150_addrs);
 
 	if (dev->em28xx_sensor == EM28XX_MT9V011) {
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-			 &dev->i2c_adap, "mt9v011", "mt9v011", 0, mt9v011_addrs);
+			 &dev->i2c_adap, NULL, "mt9v011", 0, mt9v011_addrs);
 		v4l2_subdev_call(sd, core, s_config, 0, &dev->sensor_xtal);
 	}
 
 
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			"tvaudio", "tvaudio", dev->board.tvaudio_addr, NULL);
+			NULL, "tvaudio", dev->board.tvaudio_addr, NULL);
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				"tuner", "tuner", dev->board.radio_addr, NULL);
+				NULL, "tuner", dev->board.radio_addr, NULL);
 
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == 0) {
 			enum v4l2_i2c_tuner_type type =
@@ -2563,14 +2563,14 @@ void em28xx_card_setup(struct em28xx *dev)
 			struct v4l2_subdev *sd;
 
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
 				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
 		} else {
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				"tuner", "tuner", dev->tuner_addr, NULL);
+				NULL, "tuner", dev->tuner_addr, NULL);
 		}
 	}
 
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index 8f1c94f..e7f63c1 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1485,7 +1485,7 @@ static int __devinit viu_of_probe(struct of_device *op,
 
 	ad = i2c_get_adapter(0);
 	viu_dev->decoder = v4l2_i2c_new_subdev(&viu_dev->v4l2_dev, ad,
-			"saa7115", "saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
+			NULL, "saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
 
 	viu_dev->vidq.timeout.function = viu_vid_timeout;
 	viu_dev->vidq.timeout.data     = (unsigned long)viu_dev;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index da07d14..4c9c1bb 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -185,17 +185,17 @@ static int mxb_probe(struct saa7146_dev *dev)
 	}
 
 	mxb->saa7111a = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"saa7115", "saa7111", I2C_SAA7111A, NULL);
+			NULL, "saa7111", I2C_SAA7111A, NULL);
 	mxb->tea6420_1 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6420", "tea6420", I2C_TEA6420_1, NULL);
+			NULL, "tea6420", I2C_TEA6420_1, NULL);
 	mxb->tea6420_2 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6420", "tea6420", I2C_TEA6420_2, NULL);
+			NULL, "tea6420", I2C_TEA6420_2, NULL);
 	mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tea6415c", "tea6415c", I2C_TEA6415C, NULL);
+			NULL, "tea6415c", I2C_TEA6415C, NULL);
 	mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tda9840", "tda9840", I2C_TDA9840, NULL);
+			NULL, "tda9840", I2C_TDA9840, NULL);
 	mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			"tuner", "tuner", I2C_TUNER, NULL);
+			NULL, "tuner", I2C_TUNER, NULL);
 
 	/* check if all devices are present */
 	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index bb8d83d..10a6cbf 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -7551,22 +7551,22 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		   so we do not need to probe for a radio tuner device. */
 		if (dev->radio_type != UNSET)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				dev->radio_addr, NULL);
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == ADDR_UNSET) {
 			enum v4l2_i2c_tuner_type type =
 				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 		} else {
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner", "tuner",
+				&dev->i2c_adap, NULL, "tuner",
 				dev->tuner_addr, NULL);
 		}
 	}
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 40bc635..2de110f 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -991,7 +991,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (card_is_empress(dev)) {
 		struct v4l2_subdev *sd =
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				"saa6752hs", "saa6752hs",
+				NULL, "saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
 
 		if (sd)
@@ -1002,7 +1002,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap,	"saa6588", "saa6588",
+				&dev->i2c_adap, NULL, "saa6588",
 				0, I2C_ADDRS(saa7134_boards[dev->board].rds_addr));
 		if (sd) {
 			printk(KERN_INFO "%s: found RDS decoder\n", dev->name);
diff --git a/drivers/media/video/usbvision/usbvision-i2c.c b/drivers/media/video/usbvision/usbvision-i2c.c
index a5fd2aa..e3bbae2 100644
--- a/drivers/media/video/usbvision/usbvision-i2c.c
+++ b/drivers/media/video/usbvision/usbvision-i2c.c
@@ -251,7 +251,7 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
 		   hit-and-miss. */
 		mdelay(10);
 		v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, "saa7115",
+				&usbvision->i2c_adap, NULL,
 				"saa7115_auto", 0, saa711x_addrs);
 		break;
 	}
@@ -261,14 +261,14 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
 		struct tuner_setup tun_setup;
 
 		sd = v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, "tuner",
+				&usbvision->i2c_adap, NULL,
 				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		/* depending on whether we found a demod or not, select
 		   the tuner type. */
 		type = sd ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 
 		sd = v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, "tuner",
+				&usbvision->i2c_adap, NULL,
 				"tuner", 0, v4l2_i2c_tuner_addrs(type));
 
 		if (sd == NULL)
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index 3eb15f7..e5e005d 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -4334,10 +4334,10 @@ static int __init vino_module_init(void)
 
 	vino_drvdata->decoder =
 		v4l2_i2c_new_subdev(&vino_drvdata->v4l2_dev, &vino_i2c_adapter,
-			       "saa7191", "saa7191", 0, I2C_ADDRS(0x45));
+			       NULL, "saa7191", 0, I2C_ADDRS(0x45));
 	vino_drvdata->camera =
 		v4l2_i2c_new_subdev(&vino_drvdata->v4l2_dev, &vino_i2c_adapter,
-			       "indycam", "indycam", 0, I2C_ADDRS(0x2b));
+			       NULL, "indycam", 0, I2C_ADDRS(0x2b));
 
 	dprintk("init complete!\n");
 
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 9d091c3..1c3b1b6 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -545,7 +545,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 
 	/* Load tuner module */
 	v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-		"tuner", "tuner", dev->tuner_addr, NULL);
+		NULL, "tuner", dev->tuner_addr, NULL);
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 	tun_setup.type = dev->tuner_type;
@@ -683,7 +683,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	if (dev->caps.has_tda9874)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			"tvaudio", "tvaudio", I2C_ADDR_TDA9874, NULL);
+			NULL, "tvaudio", I2C_ADDR_TDA9874, NULL);
 
 	/* register and initialize V4L2 */
 	rc = tm6000_v4l2_register(dev);
-- 
1.7.2.2

