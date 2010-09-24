Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:60404 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932308Ab0IXOOp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:45 -0400
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
Subject: [PATCH 16/16] v4l: Remove module_name argument to the v4l2_i2c_new_subdev* functions
Date: Fri, 24 Sep 2010 16:14:14 +0200
Message-Id: <1285337654-5044-17-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1285337654-5044-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The argument isn't used anymore by the functions, remote it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/radio/radio-si4713.c            |    2 +-
 drivers/media/video/au0828/au0828-cards.c     |    4 ++--
 drivers/media/video/bt8xx/bttv-cards.c        |   22 +++++++++++-----------
 drivers/media/video/cafe_ccic.c               |    2 +-
 drivers/media/video/cx18/cx18-i2c.c           |    8 ++++----
 drivers/media/video/cx231xx/cx231xx-cards.c   |    4 ++--
 drivers/media/video/cx23885/cx23885-cards.c   |    2 +-
 drivers/media/video/cx23885/cx23885-video.c   |    4 ++--
 drivers/media/video/cx88/cx88-cards.c         |    9 ++++-----
 drivers/media/video/cx88/cx88-video.c         |    7 +++----
 drivers/media/video/davinci/vpfe_capture.c    |    1 -
 drivers/media/video/davinci/vpif_capture.c    |    1 -
 drivers/media/video/davinci/vpif_display.c    |    2 +-
 drivers/media/video/em28xx/em28xx-cards.c     |   18 +++++++++---------
 drivers/media/video/fsl-viu.c                 |    2 +-
 drivers/media/video/ivtv/ivtv-i2c.c           |   22 +++++++++-------------
 drivers/media/video/mxb.c                     |   12 ++++++------
 drivers/media/video/pvrusb2/pvrusb2-hdw.c     |    6 ++----
 drivers/media/video/saa7134/saa7134-cards.c   |    8 ++++----
 drivers/media/video/saa7134/saa7134-core.c    |    4 ++--
 drivers/media/video/sh_vou.c                  |    2 +-
 drivers/media/video/soc_camera.c              |    2 +-
 drivers/media/video/usbvision/usbvision-i2c.c |    6 +++---
 drivers/media/video/v4l2-common.c             |   15 +++++----------
 drivers/media/video/vino.c                    |    4 ++--
 drivers/media/video/zoran/zoran_card.c        |    5 ++---
 drivers/staging/go7007/go7007-driver.c        |    2 +-
 drivers/staging/tm6000/tm6000-cards.c         |    4 ++--
 include/media/v4l2-common.h                   |   16 ++++++----------
 29 files changed, 88 insertions(+), 108 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 045b10f..d49c215 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -291,7 +291,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
 		goto unregister_v4l2_dev;
 	}
 
-	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter, NULL,
+	sd = v4l2_i2c_new_subdev_board(&rsdev->v4l2_dev, adapter,
 					pdata->subdev_board_info, NULL);
 	if (!sd) {
 		dev_err(&pdev->dev, "Cannot get v4l2 subdevice\n");
diff --git a/drivers/media/video/au0828/au0828-cards.c b/drivers/media/video/au0828/au0828-cards.c
index 0453816..01be89f 100644
--- a/drivers/media/video/au0828/au0828-cards.c
+++ b/drivers/media/video/au0828/au0828-cards.c
@@ -212,7 +212,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 		   be abstracted out if we ever need to support a different
 		   demod) */
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				NULL, "au8522", 0x8e >> 1, NULL);
+				"au8522", 0x8e >> 1, NULL);
 		if (sd == NULL)
 			printk(KERN_ERR "analog subdev registration failed\n");
 	}
@@ -221,7 +221,7 @@ void au0828_card_setup(struct au0828_dev *dev)
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		/* Load the tuner module, which does the attach */
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				NULL, "tuner", dev->board.tuner_addr, NULL);
+				"tuner", dev->board.tuner_addr, NULL);
 		if (sd == NULL)
 			printk(KERN_ERR "tuner subdev registration fail\n");
 
diff --git a/drivers/media/video/bt8xx/bttv-cards.c b/drivers/media/video/bt8xx/bttv-cards.c
index 87d8b00..49efcf6 100644
--- a/drivers/media/video/bt8xx/bttv-cards.c
+++ b/drivers/media/video/bt8xx/bttv-cards.c
@@ -3529,7 +3529,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, NULL, "saa6588", 0, addrs);
+			&btv->c.i2c_adap, "saa6588", 0, addrs);
 		btv->has_saa6588 = (sd != NULL);
 	}
 
@@ -3554,7 +3554,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, NULL, "msp3400", 0, addrs);
+			&btv->c.i2c_adap, "msp3400", 0, addrs);
 		if (btv->sd_msp34xx)
 			return;
 		goto no_audio;
@@ -3568,7 +3568,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, NULL, "tda7432", 0, addrs))
+				&btv->c.i2c_adap, "tda7432", 0, addrs))
 			return;
 		goto no_audio;
 	}
@@ -3576,7 +3576,7 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	case 3: {
 		/* The user specified that we should probe for tvaudio */
 		btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, NULL, "tvaudio", 0, tvaudio_addrs());
+			&btv->c.i2c_adap, "tvaudio", 0, tvaudio_addrs());
 		if (btv->sd_tvaudio)
 			return;
 		goto no_audio;
@@ -3596,11 +3596,11 @@ void __devinit bttv_init_card2(struct bttv *btv)
 	   found is really something else (e.g. a tea6300). */
 	if (!bttv_tvcards[btv->c.type].no_msp34xx) {
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, NULL, "msp3400",
+			&btv->c.i2c_adap, "msp3400",
 			0, I2C_ADDRS(I2C_ADDR_MSP3400 >> 1));
 	} else if (bttv_tvcards[btv->c.type].msp34xx_alt) {
 		btv->sd_msp34xx = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-			&btv->c.i2c_adap, NULL, "msp3400",
+			&btv->c.i2c_adap, "msp3400",
 			0, I2C_ADDRS(I2C_ADDR_MSP3400_ALT >> 1));
 	}
 
@@ -3616,13 +3616,13 @@ void __devinit bttv_init_card2(struct bttv *btv)
 		};
 
 		if (v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, NULL, "tda7432", 0, addrs))
+				&btv->c.i2c_adap, "tda7432", 0, addrs))
 			return;
 	}
 
 	/* Now see if we can find one of the tvaudio devices. */
 	btv->sd_tvaudio = v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-		&btv->c.i2c_adap, NULL, "tvaudio", 0, tvaudio_addrs());
+		&btv->c.i2c_adap, "tvaudio", 0, tvaudio_addrs());
 	if (btv->sd_tvaudio)
 		return;
 
@@ -3646,13 +3646,13 @@ void __devinit bttv_init_tuner(struct bttv *btv)
 		/* Load tuner module before issuing tuner config call! */
 		if (bttv_tvcards[btv->c.type].has_radio)
 			v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, NULL, "tuner",
+				&btv->c.i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
 		v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, NULL, "tuner",
+				&btv->c.i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		v4l2_i2c_new_subdev(&btv->c.v4l2_dev,
-				&btv->c.i2c_adap, NULL, "tuner",
+				&btv->c.i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_TV_WITH_DEMOD));
 
 		tun_setup.mode_mask = T_ANALOG_TV | T_DIGITAL_TV;
diff --git a/drivers/media/video/cafe_ccic.c b/drivers/media/video/cafe_ccic.c
index 780f3ff..f121610 100644
--- a/drivers/media/video/cafe_ccic.c
+++ b/drivers/media/video/cafe_ccic.c
@@ -2014,7 +2014,7 @@ static int cafe_pci_probe(struct pci_dev *pdev,
 
 	cam->sensor_addr = 0x42;
 	cam->sensor = v4l2_i2c_new_subdev(&cam->v4l2_dev, &cam->i2c_adapter,
-			NULL, "ov7670", cam->sensor_addr, NULL);
+			"ov7670", cam->sensor_addr, NULL);
 	if (cam->sensor == NULL) {
 		ret = -ENODEV;
 		goto out_smbus;
diff --git a/drivers/media/video/cx18/cx18-i2c.c b/drivers/media/video/cx18/cx18-i2c.c
index 3b67984..9ae6915 100644
--- a/drivers/media/video/cx18/cx18-i2c.c
+++ b/drivers/media/video/cx18/cx18-i2c.c
@@ -121,15 +121,15 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 	if (hw == CX18_HW_TUNER) {
 		/* special tuner group handling */
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, NULL, type, 0, cx->card_i2c->radio);
+				adap, type, 0, cx->card_i2c->radio);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, NULL, type, 0, cx->card_i2c->demod);
+				adap, type, 0, cx->card_i2c->demod);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		sd = v4l2_i2c_new_subdev(&cx->v4l2_dev,
-				adap, NULL, type, 0, cx->card_i2c->tv);
+				adap, type, 0, cx->card_i2c->tv);
 		if (sd != NULL)
 			sd->grp_id = hw;
 		return sd != NULL ? 0 : -1;
@@ -143,7 +143,7 @@ int cx18_i2c_register(struct cx18 *cx, unsigned idx)
 		return -1;
 
 	/* It's an I2C device other than an analog tuner or IR chip */
-	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, NULL, type, hw_addrs[idx],
+	sd = v4l2_i2c_new_subdev(&cx->v4l2_dev, adap, type, hw_addrs[idx],
 				 NULL);
 	if (sd != NULL)
 		sd->grp_id = hw;
diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index daaa3b4..129290e 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -319,7 +319,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	if (dev->board.decoder == CX231XX_AVDECODER) {
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 					&dev->i2c_bus[0].i2c_adap,
-					NULL, "cx25840", 0x88 >> 1, NULL);
+					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
 		cx25840_call(dev, core, load_fw);
@@ -329,7 +329,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		dev->sd_tuner =	v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				NULL, "tuner", 0xc2 >> 1, NULL);
+				"tuner", 0xc2 >> 1, NULL);
 		if (dev->sd_tuner == NULL)
 			cx231xx_info("tuner subdev registration failure\n");
 
diff --git a/drivers/media/video/cx23885/cx23885-cards.c b/drivers/media/video/cx23885/cx23885-cards.c
index db05400..8861309 100644
--- a/drivers/media/video/cx23885/cx23885-cards.c
+++ b/drivers/media/video/cx23885/cx23885-cards.c
@@ -1247,7 +1247,7 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	case CX23885_BOARD_LEADTEK_WINFAST_PXTV1200:
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[2].i2c_adap,
-				NULL, "cx25840", 0x88 >> 1, NULL);
+				"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840) {
 			dev->sd_cx25840->grp_id = CX23885_HW_AV_CORE;
 			v4l2_subdev_call(dev->sd_cx25840, core, load_fw);
diff --git a/drivers/media/video/cx23885/cx23885-video.c b/drivers/media/video/cx23885/cx23885-video.c
index 4920ddd..d6a87c6 100644
--- a/drivers/media/video/cx23885/cx23885-video.c
+++ b/drivers/media/video/cx23885/cx23885-video.c
@@ -1512,10 +1512,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
 		if (dev->tuner_addr)
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
 				&dev->i2c_bus[1].i2c_adap,
-				NULL, "tuner", dev->tuner_addr, NULL);
+				"tuner", dev->tuner_addr, NULL);
 		else
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_bus[1].i2c_adap, NULL,
+				&dev->i2c_bus[1].i2c_adap,
 				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_TV));
 		if (sd) {
 			struct tuner_setup tun_setup;
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index b0613f7..265f869 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -3485,19 +3485,18 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 		   later code configures a tea5767.
 		 */
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				NULL, "tuner",
-				0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
+				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_RADIO));
 		if (has_demod)
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, NULL, "tuner",
+				&core->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (core->board.tuner_addr == ADDR_UNSET) {
 			v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap, NULL, "tuner",
+				&core->i2c_adap, "tuner",
 				0, has_demod ? tv_addrs + 4 : tv_addrs);
 		} else {
 			v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				NULL, "tuner", core->board.tuner_addr, NULL);
+				"tuner", core->board.tuner_addr, NULL);
 		}
 	}
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index f9d1877..154051a 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1873,14 +1873,13 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 
 	if (core->board.audio_chip == V4L2_IDENT_WM8775)
 		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
-				NULL, "wm8775", 0x36 >> 1, NULL);
+				"wm8775", 0x36 >> 1, NULL);
 
 	if (core->board.audio_chip == V4L2_IDENT_TVAUDIO) {
 		/* This probes for a tda9874 as is used on some
 		   Pixelview Ultra boards. */
-		v4l2_i2c_new_subdev(&core->v4l2_dev,
-				&core->i2c_adap,
-				NULL, "tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
+		v4l2_i2c_new_subdev(&core->v4l2_dev, &core->i2c_adap,
+				"tvaudio", 0, I2C_ADDRS(0xb0 >> 1));
 	}
 
 	switch (core->boardnr) {
diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c
index 5d90fb0..0314bf4 100644
--- a/drivers/media/video/davinci/vpfe_capture.c
+++ b/drivers/media/video/davinci/vpfe_capture.c
@@ -1986,7 +1986,6 @@ static __init int vpfe_probe(struct platform_device *pdev)
 		vpfe_dev->sd[i] =
 			v4l2_i2c_new_subdev_board(&vpfe_dev->v4l2_dev,
 						  i2c_adap,
-						  NULL,
 						  &sdinfo->board_info,
 						  NULL);
 		if (vpfe_dev->sd[i]) {
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 4b8e70c..0193ffd 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -2012,7 +2012,6 @@ static __init int vpif_probe(struct platform_device *pdev)
 		vpif_obj.sd[i] =
 			v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
 						  i2c_adap,
-						  NULL,
 						  &subdevdata->board_info,
 						  NULL);
 
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index 2523a7f..8d156d9 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -1552,7 +1552,7 @@ static __init int vpif_probe(struct platform_device *pdev)
 
 	for (i = 0; i < subdev_count; i++) {
 		vpif_obj.sd[i] = v4l2_i2c_new_subdev_board(&vpif_obj.v4l2_dev,
-						i2c_adap, NULL,
+						i2c_adap,
 						&subdevdata[i].board_info,
 						NULL);
 		if (!vpif_obj.sd[i]) {
diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 7af7860..49feed2 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -2523,39 +2523,39 @@ void em28xx_card_setup(struct em28xx *dev)
 	/* request some modules */
 	if (dev->board.has_msp34xx)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			NULL, "msp3400", 0, msp3400_addrs);
+			"msp3400", 0, msp3400_addrs);
 
 	if (dev->board.decoder == EM28XX_SAA711X)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			NULL, "saa7115_auto", 0, saa711x_addrs);
+			"saa7115_auto", 0, saa711x_addrs);
 
 	if (dev->board.decoder == EM28XX_TVP5150)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			NULL, "tvp5150", 0, tvp5150_addrs);
+			"tvp5150", 0, tvp5150_addrs);
 
 	if (dev->em28xx_sensor == EM28XX_MT9V011) {
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-			 &dev->i2c_adap, NULL, "mt9v011", 0, mt9v011_addrs);
+			 &dev->i2c_adap, "mt9v011", 0, mt9v011_addrs);
 		v4l2_subdev_call(sd, core, s_config, 0, &dev->sensor_xtal);
 	}
 
 
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			NULL, "tvaudio", dev->board.tvaudio_addr, NULL);
+			"tvaudio", dev->board.tvaudio_addr, NULL);
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				NULL, "tuner", dev->board.radio_addr, NULL);
+				"tuner", dev->board.radio_addr, NULL);
 
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == 0) {
 			enum v4l2_i2c_tuner_type type =
@@ -2563,14 +2563,14 @@ void em28xx_card_setup(struct em28xx *dev)
 			struct v4l2_subdev *sd;
 
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
 				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
 		} else {
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				NULL, "tuner", dev->tuner_addr, NULL);
+				"tuner", dev->tuner_addr, NULL);
 		}
 	}
 
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index e7f63c1..b0f3f10 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1485,7 +1485,7 @@ static int __devinit viu_of_probe(struct of_device *op,
 
 	ad = i2c_get_adapter(0);
 	viu_dev->decoder = v4l2_i2c_new_subdev(&viu_dev->v4l2_dev, ad,
-			NULL, "saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
+			"saa7113", VIU_VIDEO_DECODER_ADDR, NULL);
 
 	viu_dev->vidq.timeout.function = viu_vid_timeout;
 	viu_dev->vidq.timeout.data     = (unsigned long)viu_dev;
diff --git a/drivers/media/video/ivtv/ivtv-i2c.c b/drivers/media/video/ivtv/ivtv-i2c.c
index d104c98..b56d8c0 100644
--- a/drivers/media/video/ivtv/ivtv-i2c.c
+++ b/drivers/media/video/ivtv/ivtv-i2c.c
@@ -238,19 +238,16 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 		return -1;
 	if (hw == IVTV_HW_TUNER) {
 		/* special tuner handling */
-		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, NULL, type,
-				0, itv->card_i2c->radio);
+		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
+				itv->card_i2c->radio);
 		if (sd)
 			sd->grp_id = 1 << idx;
-		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, NULL, type,
-				0, itv->card_i2c->demod);
+		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
+				itv->card_i2c->demod);
 		if (sd)
 			sd->grp_id = 1 << idx;
-		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, NULL, type,
-				0, itv->card_i2c->tv);
+		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev, adap, type, 0,
+				itv->card_i2c->tv);
 		if (sd)
 			sd->grp_id = 1 << idx;
 		return sd ? 0 : -1;
@@ -266,17 +263,16 @@ int ivtv_i2c_register(struct ivtv *itv, unsigned idx)
 	/* It's an I2C device other than an analog tuner or IR chip */
 	if (hw == IVTV_HW_UPD64031A || hw == IVTV_HW_UPD6408X) {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, NULL, type, 0, I2C_ADDRS(hw_addrs[idx]));
+				adap, type, 0, I2C_ADDRS(hw_addrs[idx]));
 	} else if (hw == IVTV_HW_CX25840) {
 		struct cx25840_platform_data pdata;
 
 		pdata.pvr150_workaround = itv->pvr150_workaround;
 		sd = v4l2_i2c_new_subdev_cfg(&itv->v4l2_dev,
-				adap, NULL, type, 0, &pdata, hw_addrs[idx],
-				NULL);
+				adap, type, 0, &pdata, hw_addrs[idx], NULL);
 	} else {
 		sd = v4l2_i2c_new_subdev(&itv->v4l2_dev,
-				adap, NULL, type, hw_addrs[idx], NULL);
+				adap, type, hw_addrs[idx], NULL);
 	}
 	if (sd)
 		sd->grp_id = 1 << idx;
diff --git a/drivers/media/video/mxb.c b/drivers/media/video/mxb.c
index 4c9c1bb..8104129 100644
--- a/drivers/media/video/mxb.c
+++ b/drivers/media/video/mxb.c
@@ -185,17 +185,17 @@ static int mxb_probe(struct saa7146_dev *dev)
 	}
 
 	mxb->saa7111a = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "saa7111", I2C_SAA7111A, NULL);
+			"saa7111", I2C_SAA7111A, NULL);
 	mxb->tea6420_1 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "tea6420", I2C_TEA6420_1, NULL);
+			"tea6420", I2C_TEA6420_1, NULL);
 	mxb->tea6420_2 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "tea6420", I2C_TEA6420_2, NULL);
+			"tea6420", I2C_TEA6420_2, NULL);
 	mxb->tea6415c = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "tea6415c", I2C_TEA6415C, NULL);
+			"tea6415c", I2C_TEA6415C, NULL);
 	mxb->tda9840 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "tda9840", I2C_TDA9840, NULL);
+			"tda9840", I2C_TDA9840, NULL);
 	mxb->tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev, &mxb->i2c_adapter,
-			NULL, "tuner", I2C_TUNER, NULL);
+			"tuner", I2C_TUNER, NULL);
 
 	/* check if all devices are present */
 	if (!mxb->tea6420_1 || !mxb->tea6420_2 || !mxb->tea6415c ||
diff --git a/drivers/media/video/pvrusb2/pvrusb2-hdw.c b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
index bef2027..66ad516 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-hdw.c
@@ -2088,16 +2088,14 @@ static int pvr2_hdw_load_subdev(struct pvr2_hdw *hdw,
 			   " Setting up with specified i2c address 0x%x",
 			   mid, i2caddr[0]);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
-					 NULL, fname,
-					 i2caddr[0], NULL);
+					 fname, i2caddr[0], NULL);
 	} else {
 		pvr2_trace(PVR2_TRACE_INIT,
 			   "Module ID %u:"
 			   " Setting up with address probe list",
 			   mid);
 		sd = v4l2_i2c_new_subdev(&hdw->v4l2_dev, &hdw->i2c_adap,
-						NULL, fname,
-						0, i2caddr);
+					 fname, 0, i2caddr);
 	}
 
 	if (!sd) {
diff --git a/drivers/media/video/saa7134/saa7134-cards.c b/drivers/media/video/saa7134/saa7134-cards.c
index 10a6cbf..4c69f48 100644
--- a/drivers/media/video/saa7134/saa7134-cards.c
+++ b/drivers/media/video/saa7134/saa7134-cards.c
@@ -7551,22 +7551,22 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		   so we do not need to probe for a radio tuner device. */
 		if (dev->radio_type != UNSET)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				dev->radio_addr, NULL);
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == ADDR_UNSET) {
 			enum v4l2_i2c_tuner_type type =
 				has_demod ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 		} else {
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "tuner",
+				&dev->i2c_adap, "tuner",
 				dev->tuner_addr, NULL);
 		}
 	}
diff --git a/drivers/media/video/saa7134/saa7134-core.c b/drivers/media/video/saa7134/saa7134-core.c
index 2de110f..70469d9 100644
--- a/drivers/media/video/saa7134/saa7134-core.c
+++ b/drivers/media/video/saa7134/saa7134-core.c
@@ -991,7 +991,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 	if (card_is_empress(dev)) {
 		struct v4l2_subdev *sd =
 			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-				NULL, "saa6752hs",
+				"saa6752hs",
 				saa7134_boards[dev->board].empress_addr, NULL);
 
 		if (sd)
@@ -1002,7 +1002,7 @@ static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
 		struct v4l2_subdev *sd;
 
 		sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, NULL, "saa6588",
+				&dev->i2c_adap, "saa6588",
 				0, I2C_ADDRS(saa7134_boards[dev->board].rds_addr));
 		if (sd) {
 			printk(KERN_INFO "%s: found RDS decoder\n", dev->name);
diff --git a/drivers/media/video/sh_vou.c b/drivers/media/video/sh_vou.c
index 6e35eaa..a3ce9bf 100644
--- a/drivers/media/video/sh_vou.c
+++ b/drivers/media/video/sh_vou.c
@@ -1405,7 +1405,7 @@ static int __devinit sh_vou_probe(struct platform_device *pdev)
 		goto ereset;
 
 	subdev = v4l2_i2c_new_subdev_board(&vou_dev->v4l2_dev, i2c_adap,
-			NULL, vou_pdata->board_info, NULL);
+			vou_pdata->board_info, NULL);
 	if (!subdev) {
 		ret = -ENOMEM;
 		goto ei2cnd;
diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
index 328cf97..9aa2870 100644
--- a/drivers/media/video/soc_camera.c
+++ b/drivers/media/video/soc_camera.c
@@ -898,7 +898,7 @@ static int soc_camera_init_i2c(struct soc_camera_device *icd,
 	icl->board_info->platform_data = icd;
 
 	subdev = v4l2_i2c_new_subdev_board(&ici->v4l2_dev, adap,
-				NULL, icl->board_info, NULL);
+				icl->board_info, NULL);
 	if (!subdev)
 		goto ei2cnd;
 
diff --git a/drivers/media/video/usbvision/usbvision-i2c.c b/drivers/media/video/usbvision/usbvision-i2c.c
index e3bbae2..81dd53b 100644
--- a/drivers/media/video/usbvision/usbvision-i2c.c
+++ b/drivers/media/video/usbvision/usbvision-i2c.c
@@ -251,7 +251,7 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
 		   hit-and-miss. */
 		mdelay(10);
 		v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, NULL,
+				&usbvision->i2c_adap,
 				"saa7115_auto", 0, saa711x_addrs);
 		break;
 	}
@@ -261,14 +261,14 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
 		struct tuner_setup tun_setup;
 
 		sd = v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, NULL,
+				&usbvision->i2c_adap,
 				"tuner", 0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		/* depending on whether we found a demod or not, select
 		   the tuner type. */
 		type = sd ? ADDRS_TV_WITH_DEMOD : ADDRS_TV;
 
 		sd = v4l2_i2c_new_subdev(&usbvision->v4l2_dev,
-				&usbvision->i2c_adap, NULL,
+				&usbvision->i2c_adap,
 				"tuner", 0, v4l2_i2c_tuner_addrs(type));
 
 		if (sd == NULL)
diff --git a/drivers/media/video/v4l2-common.c b/drivers/media/video/v4l2-common.c
index 120b4ac..7a23399 100644
--- a/drivers/media/video/v4l2-common.c
+++ b/drivers/media/video/v4l2-common.c
@@ -368,18 +368,15 @@ EXPORT_SYMBOL_GPL(v4l2_i2c_subdev_init);
 
 /* Load an i2c sub-device. */
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter, const char *module_name,
-		struct i2c_board_info *info, const unsigned short *probe_addrs)
+		struct i2c_adapter *adapter, struct i2c_board_info *info,
+		const unsigned short *probe_addrs)
 {
 	struct v4l2_subdev *sd = NULL;
 	struct i2c_client *client;
 
 	BUG_ON(!v4l2_dev);
 
-	if (module_name)
-		request_module(module_name);
-	else
-		request_module(I2C_MODULE_PREFIX "%s", info->type);
+	request_module(I2C_MODULE_PREFIX "%s", info->type);
 
 	/* Create the i2c client */
 	if (info->addr == 0 && probe_addrs)
@@ -431,8 +428,7 @@ error:
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_board);
 
 struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type,
+		struct i2c_adapter *adapter, const char *client_type,
 		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs)
 {
@@ -446,8 +442,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
 	info.irq = irq;
 	info.platform_data = platform_data;
 
-	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, module_name,
-			&info, probe_addrs);
+	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, probe_addrs);
 }
 EXPORT_SYMBOL_GPL(v4l2_i2c_new_subdev_cfg);
 
diff --git a/drivers/media/video/vino.c b/drivers/media/video/vino.c
index e5e005d..7e7eec4 100644
--- a/drivers/media/video/vino.c
+++ b/drivers/media/video/vino.c
@@ -4334,10 +4334,10 @@ static int __init vino_module_init(void)
 
 	vino_drvdata->decoder =
 		v4l2_i2c_new_subdev(&vino_drvdata->v4l2_dev, &vino_i2c_adapter,
-			       NULL, "saa7191", 0, I2C_ADDRS(0x45));
+			       "saa7191", 0, I2C_ADDRS(0x45));
 	vino_drvdata->camera =
 		v4l2_i2c_new_subdev(&vino_drvdata->v4l2_dev, &vino_i2c_adapter,
-			       NULL, "indycam", 0, I2C_ADDRS(0x2b));
+			       "indycam", 0, I2C_ADDRS(0x2b));
 
 	dprintk("init complete!\n");
 
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index 0aac376..76179f7 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -1342,13 +1342,12 @@ static int __devinit zoran_probe(struct pci_dev *pdev,
 	}
 
 	zr->decoder = v4l2_i2c_new_subdev(&zr->v4l2_dev,
-		&zr->i2c_adapter, NULL, zr->card.i2c_decoder,
+		&zr->i2c_adapter, zr->card.i2c_decoder,
 		0, zr->card.addrs_decoder);
 
 	if (zr->card.i2c_encoder)
 		zr->encoder = v4l2_i2c_new_subdev(&zr->v4l2_dev,
-			&zr->i2c_adapter,
-			NULL, zr->card.i2c_encoder,
+			&zr->i2c_adapter, zr->card.i2c_encoder,
 			0, zr->card.addrs_encoder);
 
 	dprintk(2,
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 0a1d925..4e20387 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -199,7 +199,7 @@ static int init_i2c_module(struct i2c_adapter *adapter, const char *type,
 	struct go7007 *go = i2c_get_adapdata(adapter);
 	struct v4l2_device *v4l2_dev = &go->v4l2_dev;
 
-	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, NULL, type, addr, NULL))
+	if (v4l2_i2c_new_subdev(v4l2_dev, adapter, type, addr, NULL))
 		return 0;
 
 	printk(KERN_INFO "go7007: probing for module i2c:%s failed\n", type);
diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
index 1c3b1b6..500a78c 100644
--- a/drivers/staging/tm6000/tm6000-cards.c
+++ b/drivers/staging/tm6000/tm6000-cards.c
@@ -545,7 +545,7 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
 
 	/* Load tuner module */
 	v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-		NULL, "tuner", dev->tuner_addr, NULL);
+		"tuner", dev->tuner_addr, NULL);
 
 	memset(&tun_setup, 0, sizeof(tun_setup));
 	tun_setup.type = dev->tuner_type;
@@ -683,7 +683,7 @@ static int tm6000_init_dev(struct tm6000_core *dev)
 
 	if (dev->caps.has_tda9874)
 		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
-			NULL, "tvaudio", I2C_ADDR_TDA9874, NULL);
+			"tvaudio", I2C_ADDR_TDA9874, NULL);
 
 	/* register and initialize V4L2 */
 	rc = tm6000_v4l2_register(dev);
diff --git a/include/media/v4l2-common.h b/include/media/v4l2-common.h
index 98b3264..4bcda5a 100644
--- a/include/media/v4l2-common.h
+++ b/include/media/v4l2-common.h
@@ -137,31 +137,27 @@ struct v4l2_subdev_ops;
 
 
 /* Load an i2c module and return an initialized v4l2_subdev struct.
-   Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
 struct v4l2_subdev *v4l2_i2c_new_subdev_cfg(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type,
+		struct i2c_adapter *adapter, const char *client_type,
 		int irq, void *platform_data,
 		u8 addr, const unsigned short *probe_addrs);
 
 /* Load an i2c module and return an initialized v4l2_subdev struct.
-   Only call request_module if module_name != NULL.
    The client_type argument is the name of the chip that's on the adapter. */
 static inline struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter,
-		const char *module_name, const char *client_type,
+		struct i2c_adapter *adapter, const char *client_type,
 		u8 addr, const unsigned short *probe_addrs)
 {
-	return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, module_name,
-				client_type, 0, NULL, addr, probe_addrs);
+	return v4l2_i2c_new_subdev_cfg(v4l2_dev, adapter, client_type, 0, NULL,
+				       addr, probe_addrs);
 }
 
 struct i2c_board_info;
 
 struct v4l2_subdev *v4l2_i2c_new_subdev_board(struct v4l2_device *v4l2_dev,
-		struct i2c_adapter *adapter, const char *module_name,
-		struct i2c_board_info *info, const unsigned short *probe_addrs);
+		struct i2c_adapter *adapter, struct i2c_board_info *info,
+		const unsigned short *probe_addrs);
 
 /* Initialize an v4l2_subdev with data from an i2c_client struct */
 void v4l2_i2c_subdev_init(struct v4l2_subdev *sd, struct i2c_client *client,
-- 
1.7.2.2

