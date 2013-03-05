Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3CEKzh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Mar 2013 05:55:37 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 1/3] em28xx: Prepare to support 2 different I2C buses
Date: Tue,  5 Mar 2013 07:55:26 -0300
Message-Id: <1362480928-20382-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
References: <1362480928-20382-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Newer em28xx devices have 2 buses. Change the logic to allow
using both buses.

This patch was generated by this small script:

for i in drivers/media/usb/em28xx/*.c; do
	sed 's,->i2c_adap,->i2c_adap[dev->def_i2c_bus],g;s,->i2c_client,->i2c_client[dev->def_i2c_bus],'
done

Of course, em28xx.h needed manual edit.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 32 ++++++------
 drivers/media/usb/em28xx/em28xx-dvb.c   | 86 ++++++++++++++++-----------------
 drivers/media/usb/em28xx/em28xx-i2c.c   | 30 ++++++------
 drivers/media/usb/em28xx/em28xx-input.c |  5 +-
 drivers/media/usb/em28xx/em28xx.h       | 10 +++-
 5 files changed, 85 insertions(+), 78 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 4dcef9d..d81f7ee 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2249,7 +2249,7 @@ static int em28xx_initialize_mt9m111(struct em28xx *dev)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, &regs[i][0], 3);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &regs[i][0], 3);
 
 	return 0;
 }
@@ -2276,7 +2276,7 @@ static int em28xx_initialize_mt9m001(struct em28xx *dev)
 	};
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, &regs[i][0], 3);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &regs[i][0], 3);
 
 	return 0;
 }
@@ -2294,10 +2294,10 @@ static int em28xx_hint_sensor(struct em28xx *dev)
 	u16 version;
 
 	/* Micron sensor detection */
-	dev->i2c_client.addr = 0xba >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0xba >> 1;
 	cmd = 0;
-	i2c_master_send(&dev->i2c_client, &cmd, 1);
-	rc = i2c_master_recv(&dev->i2c_client, (char *)&version_be, 2);
+	i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], &cmd, 1);
+	rc = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], (char *)&version_be, 2);
 	if (rc != 2)
 		return -EINVAL;
 
@@ -2748,8 +2748,8 @@ static void em28xx_card_setup(struct em28xx *dev)
 #endif
 		/* Call first TVeeprom */
 
-		dev->i2c_client.addr = 0xa0 >> 1;
-		tveeprom_hauppauge_analog(&dev->i2c_client, &tv, dev->eedata);
+		dev->i2c_client[dev->def_i2c_bus].addr = 0xa0 >> 1;
+		tveeprom_hauppauge_analog(&dev->i2c_client[dev->def_i2c_bus], &tv, dev->eedata);
 
 		dev->tuner_type = tv.tuner_type;
 
@@ -2841,15 +2841,15 @@ static void em28xx_card_setup(struct em28xx *dev)
 
 	/* request some modules */
 	if (dev->board.has_msp34xx)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"msp3400", 0, msp3400_addrs);
 
 	if (dev->board.decoder == EM28XX_SAA711X)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"saa7115_auto", 0, saa711x_addrs);
 
 	if (dev->board.decoder == EM28XX_TVP5150)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"tvp5150", 0, tvp5150_addrs);
 
 	if (dev->em28xx_sensor == EM28XX_MT9V011) {
@@ -2861,25 +2861,25 @@ static void em28xx_card_setup(struct em28xx *dev)
 		};
 
 		pdata.xtal = dev->sensor_xtal;
-		v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev_board(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 				&mt9v011_info, NULL);
 	}
 
 
 	if (dev->board.adecoder == EM28XX_TVAUDIO)
-		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+		v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 			"tvaudio", dev->board.tvaudio_addr, NULL);
 
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		if (dev->board.radio.type)
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 				"tuner", dev->board.radio_addr, NULL);
 
 		if (has_demod)
 			v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner",
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(ADDRS_DEMOD));
 		if (dev->tuner_addr == 0) {
 			enum v4l2_i2c_tuner_type type =
@@ -2887,13 +2887,13 @@ static void em28xx_card_setup(struct em28xx *dev)
 			struct v4l2_subdev *sd;
 
 			sd = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-				&dev->i2c_adap, "tuner",
+				&dev->i2c_adap[dev->def_i2c_bus], "tuner",
 				0, v4l2_i2c_tuner_addrs(type));
 
 			if (sd)
 				dev->tuner_addr = v4l2_i2c_subdev_addr(sd);
 		} else {
-			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
+			v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap[dev->def_i2c_bus],
 				"tuner", dev->tuner_addr, NULL);
 		}
 	}
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 7200dfe..98b95be 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -463,10 +463,10 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
 	msleep(10);
 
-	dev->i2c_client.addr = 0x82 >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
 	em28xx_gpio_set(dev, hauppauge_hvr930c_end);
 
 	msleep(100);
@@ -520,10 +520,10 @@ static void terratec_h5_init(struct em28xx *dev)
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
 	msleep(10);
 
-	dev->i2c_client.addr = 0x82 >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
 	em28xx_gpio_set(dev, terratec_h5_end);
 };
 
@@ -573,10 +573,10 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
 	msleep(10);
 
-	dev->i2c_client.addr = 0x82 >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
 
 	em28xx_gpio_set(dev, terratec_htc_stick_end);
 };
@@ -631,10 +631,10 @@ static void terratec_htc_usb_xs_init(struct em28xx *dev)
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
 	msleep(10);
 
-	dev->i2c_client.addr = 0x82 >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
 
 	em28xx_gpio_set(dev, terratec_htc_usb_xs_end);
 };
@@ -660,10 +660,10 @@ static void pctv_520e_init(struct em28xx *dev)
 		{{ 0x01, 0x00, 0x73, 0xaf }, 4},
 	};
 
-	dev->i2c_client.addr = 0x82 >> 1; /* 0x41 */
+	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1; /* 0x41 */
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client, regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
 };
 
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
@@ -777,7 +777,7 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 	struct xc2028_config cfg;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.i2c_adap  = &dev->i2c_adap;
+	cfg.i2c_adap  = &dev->i2c_adap[dev->def_i2c_bus];
 	cfg.i2c_addr  = addr;
 
 	if (!dev->dvb->fe[0]) {
@@ -960,7 +960,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	switch (dev->model) {
 	case EM2874_BOARD_LEADERSHIP_ISDBT:
 		dvb->fe[0] = dvb_attach(s921_attach,
-				&sharp_isdbt, &dev->i2c_adap);
+				&sharp_isdbt, &dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
@@ -974,7 +974,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
 					   &em2880_lgdt3303_dev,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -983,7 +983,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_KWORLD_DVB_310U:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_with_xc3028,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -994,7 +994,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1007,13 +1007,13 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_KWORLD_VS_DVBT:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_xc3028_no_i2c_gate,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] == NULL) {
 			/* This board could have either a zl10353 or a mt352.
 			   If the chip id isn't for zl10353, try mt352 */
 			dvb->fe[0] = dvb_attach(mt352_attach,
 						   &terratec_xs_mt352_cfg,
-						   &dev->i2c_adap);
+						   &dev->i2c_adap[dev->def_i2c_bus]);
 		}
 
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
@@ -1024,16 +1024,16 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2870_BOARD_KWORLD_355U:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
 					   &em28xx_zl10353_no_i2c_gate_dev,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL)
 			dvb_attach(qt1010_attach, dvb->fe[0],
-				   &dev->i2c_adap, &em28xx_qt1010_config);
+				   &dev->i2c_adap[dev->def_i2c_bus], &em28xx_qt1010_config);
 		break;
 	case EM2883_BOARD_KWORLD_HYBRID_330U:
 	case EM2882_BOARD_EVGA_INDTUBE:
 		dvb->fe[0] = dvb_attach(s5h1409_attach,
 					   &em28xx_s5h1409_with_xc3028,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1042,10 +1042,10 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
 					   &em2880_lgdt3303_dev,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
-				&dev->i2c_adap, 0x61, TUNER_THOMSON_DTT761X)) {
+				&dev->i2c_adap[dev->def_i2c_bus], 0x61, TUNER_THOMSON_DTT761X)) {
 				result = -EINVAL;
 				goto out_free;
 			}
@@ -1054,7 +1054,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
 	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
 		dvb->fe[0] = dvb_attach(drxd_attach, &em28xx_drxd, NULL,
-					   &dev->i2c_adap, &dev->udev->dev);
+					   &dev->i2c_adap[dev->def_i2c_bus], &dev->udev->dev);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1064,10 +1064,10 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		/* Philips CU1216L NIM (Philips TDA10023 + Infineon TUA6034) */
 		dvb->fe[0] = dvb_attach(tda10023_attach,
 			&em28xx_tda10023_config,
-			&dev->i2c_adap, 0x48);
+			&dev->i2c_adap[dev->def_i2c_bus], 0x48);
 		if (dvb->fe[0]) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
-				&dev->i2c_adap, 0x60, TUNER_PHILIPS_CU1216L)) {
+				&dev->i2c_adap[dev->def_i2c_bus], 0x60, TUNER_PHILIPS_CU1216L)) {
 				result = -EINVAL;
 				goto out_free;
 			}
@@ -1076,10 +1076,10 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2870_BOARD_KWORLD_A340:
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
 					   &em2870_lgdt3304_dev,
-					   &dev->i2c_adap);
+					   &dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0] != NULL)
 			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-				   &dev->i2c_adap, &kworld_a340_config);
+				   &dev->i2c_adap[dev->def_i2c_bus], &kworld_a340_config);
 		break;
 	case EM28174_BOARD_PCTV_290E:
 		/* set default GPIO0 for LNA, used if GPIOLIB is undefined */
@@ -1087,14 +1087,14 @@ static int em28xx_dvb_init(struct em28xx *dev)
 				CXD2820R_GPIO_L;
 		dvb->fe[0] = dvb_attach(cxd2820r_attach,
 					&em28xx_cxd2820r_config,
-					&dev->i2c_adap,
+					&dev->i2c_adap[dev->def_i2c_bus],
 					&dvb->lna_gpio);
 		if (dvb->fe[0]) {
 			/* FE 0 attach tuner */
 			if (!dvb_attach(tda18271_attach,
 					dvb->fe[0],
 					0x60,
-					&dev->i2c_adap,
+					&dev->i2c_adap[dev->def_i2c_bus],
 					&em28xx_cxd2820r_tda18271_config)) {
 
 				dvb_frontend_detach(dvb->fe[0]);
@@ -1124,7 +1124,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		hauppauge_hvr930c_init(dev);
 
 		dvb->fe[0] = dvb_attach(drxk_attach,
-					&hauppauge_930c_drxk, &dev->i2c_adap);
+					&hauppauge_930c_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1142,7 +1142,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
-		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap,
+		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
 				&cfg)) {
 			result = -EINVAL;
 			goto out_free;
@@ -1155,7 +1155,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2884_BOARD_TERRATEC_H5:
 		terratec_h5_init(dev);
 
-		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap);
+		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1169,7 +1169,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		/* Attach tda18271 to DVB-C frontend */
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
-		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0], &dev->i2c_adap, 0x60)) {
+		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus], 0x60)) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -1180,17 +1180,17 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM28174_BOARD_PCTV_460E:
 		/* attach demod */
 		dvb->fe[0] = dvb_attach(tda10071_attach,
-			&em28xx_tda10071_config, &dev->i2c_adap);
+			&em28xx_tda10071_config, &dev->i2c_adap[dev->def_i2c_bus]);
 
 		/* attach SEC */
 		if (dvb->fe[0])
-			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap,
+			dvb_attach(a8293_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
 				&em28xx_a8293_config);
 		break;
 	case EM2874_BOARD_MAXMEDIA_UB425_TC:
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &maxmedia_ub425_tc_drxk,
-				&dev->i2c_adap);
+				&dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (dvb->fe[0]) {
 			/* disable I2C-gate */
@@ -1198,7 +1198,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 			/* attach tuner */
 			if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
-					&dev->i2c_adap, 0x60)) {
+					&dev->i2c_adap[dev->def_i2c_bus], 0x60)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
 				goto out_free;
@@ -1216,12 +1216,12 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
-				&dev->i2c_adap);
+				&dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (dvb->fe[0]) {
 			/* attach tuner */
 			if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-					&dev->i2c_adap,
+					&dev->i2c_adap[dev->def_i2c_bus],
 					&em28xx_cxd2820r_tda18271_config)) {
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
@@ -1234,7 +1234,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_htc_stick_drxk,
-					&dev->i2c_adap);
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1242,7 +1242,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* Attach the demodulator. */
 		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-				&dev->i2c_adap,
+				&dev->i2c_adap[dev->def_i2c_bus],
 				&em28xx_cxd2820r_tda18271_config)) {
 			result = -EINVAL;
 			goto out_free;
@@ -1253,7 +1253,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_htc_stick_drxk,
-					&dev->i2c_adap);
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1261,7 +1261,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* Attach the demodulator. */
 		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
-				&dev->i2c_adap,
+				&dev->i2c_adap[dev->def_i2c_bus],
 				&em28xx_cxd2820r_tda18271_config)) {
 			result = -EINVAL;
 			goto out_free;
diff --git a/drivers/media/usb/em28xx/em28xx-i2c.c b/drivers/media/usb/em28xx/em28xx-i2c.c
index 6152423..9086e57 100644
--- a/drivers/media/usb/em28xx/em28xx-i2c.c
+++ b/drivers/media/usb/em28xx/em28xx-i2c.c
@@ -384,7 +384,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 	/* Select address */
 	buf[0] = addr >> 8;
 	buf[1] = addr & 0xff;
-	ret = i2c_master_send(&dev->i2c_client, buf + !addr_w16, 1 + addr_w16);
+	ret = i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], buf + !addr_w16, 1 + addr_w16);
 	if (ret < 0)
 		return ret;
 	/* Read data */
@@ -398,7 +398,7 @@ static int em28xx_i2c_read_block(struct em28xx *dev, u16 addr, bool addr_w16,
 		else
 			rsize = remain;
 
-		ret = i2c_master_recv(&dev->i2c_client, data, rsize);
+		ret = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], data, rsize);
 		if (ret < 0)
 			return ret;
 
@@ -422,10 +422,10 @@ static int em28xx_i2c_eeprom(struct em28xx *dev, u8 **eedata, u16 *eedata_len)
 	*eedata = NULL;
 	*eedata_len = 0;
 
-	dev->i2c_client.addr = 0xa0 >> 1;
+	dev->i2c_client[dev->def_i2c_bus].addr = 0xa0 >> 1;
 
 	/* Check if board has eeprom */
-	err = i2c_master_recv(&dev->i2c_client, &buf, 0);
+	err = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], &buf, 0);
 	if (err < 0) {
 		em28xx_info("board has no eeprom\n");
 		return -ENODEV;
@@ -652,8 +652,8 @@ void em28xx_do_i2c_scan(struct em28xx *dev)
 	memset(i2c_devicelist, 0, ARRAY_SIZE(i2c_devicelist));
 
 	for (i = 0; i < ARRAY_SIZE(i2c_devs); i++) {
-		dev->i2c_client.addr = i;
-		rc = i2c_master_recv(&dev->i2c_client, &buf, 0);
+		dev->i2c_client[dev->def_i2c_bus].addr = i;
+		rc = i2c_master_recv(&dev->i2c_client[dev->def_i2c_bus], &buf, 0);
 		if (rc < 0)
 			continue;
 		i2c_devicelist[i] = i;
@@ -675,21 +675,21 @@ int em28xx_i2c_register(struct em28xx *dev)
 
 	BUG_ON(!dev->em28xx_write_regs || !dev->em28xx_read_reg);
 	BUG_ON(!dev->em28xx_write_regs_req || !dev->em28xx_read_reg_req);
-	dev->i2c_adap = em28xx_adap_template;
-	dev->i2c_adap.dev.parent = &dev->udev->dev;
-	strcpy(dev->i2c_adap.name, dev->name);
-	dev->i2c_adap.algo_data = dev;
-	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
+	dev->i2c_adap[dev->def_i2c_bus] = em28xx_adap_template;
+	dev->i2c_adap[dev->def_i2c_bus].dev.parent = &dev->udev->dev;
+	strcpy(dev->i2c_adap[dev->def_i2c_bus].name, dev->name);
+	dev->i2c_adap[dev->def_i2c_bus].algo_data = dev;
+	i2c_set_adapdata(&dev->i2c_adap[dev->def_i2c_bus], &dev->v4l2_dev);
 
-	retval = i2c_add_adapter(&dev->i2c_adap);
+	retval = i2c_add_adapter(&dev->i2c_adap[dev->def_i2c_bus]);
 	if (retval < 0) {
 		em28xx_errdev("%s: i2c_add_adapter failed! retval [%d]\n",
 			__func__, retval);
 		return retval;
 	}
 
-	dev->i2c_client = em28xx_client_template;
-	dev->i2c_client.adapter = &dev->i2c_adap;
+	dev->i2c_client[dev->def_i2c_bus] = em28xx_client_template;
+	dev->i2c_client[dev->def_i2c_bus].adapter = &dev->i2c_adap[dev->def_i2c_bus];
 
 	retval = em28xx_i2c_eeprom(dev, &dev->eedata, &dev->eedata_len);
 	if ((retval < 0) && (retval != -ENODEV)) {
@@ -711,6 +711,6 @@ int em28xx_i2c_register(struct em28xx *dev)
  */
 int em28xx_i2c_unregister(struct em28xx *dev)
 {
-	i2c_del_adapter(&dev->i2c_adap);
+	i2c_del_adapter(&dev->i2c_adap[dev->def_i2c_bus]);
 	return 0;
 }
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 1bef990..466b19d 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -280,11 +280,12 @@ static int em2874_polling_getkey(struct em28xx_IR *ir,
 
 static int em28xx_i2c_ir_handle_key(struct em28xx_IR *ir)
 {
+	struct em28xx *dev = ir->dev;
 	static u32 ir_key;
 	int rc;
 	struct i2c_client client;
 
-	client.adapter = &ir->dev->i2c_adap;
+	client.adapter = &ir->dev->i2c_adap[dev->def_i2c_bus];
 	client.addr = ir->i2c_dev_addr;
 
 	rc = ir->get_key_i2c(&client, &ir_key);
@@ -461,7 +462,7 @@ static int em28xx_probe_i2c_ir(struct em28xx *dev)
 	};
 
 	while (addr_list[i] != I2C_CLIENT_END) {
-		if (i2c_probe_func_quick_read(&dev->i2c_adap, addr_list[i]) == 1)
+		if (i2c_probe_func_quick_read(&dev->i2c_adap[dev->def_i2c_bus], addr_list[i]) == 1)
 			return addr_list[i];
 		i++;
 	}
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index 2d6d31a..5de7b6c 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -157,6 +157,9 @@
 #define EM28XX_NUM_BUFS 5
 #define EM28XX_DVB_NUM_BUFS 5
 
+/* max number of I2C buses on em28xx devices */
+#define NUM_I2C_BUSES	2
+
 /* isoc transfers: number of packets for each buffer
    windows requests only 64 packets .. so we better do the same
    this is what I found out for all alternate numbers there!
@@ -507,10 +510,13 @@ struct em28xx {
 	int tuner_type;		/* type of the tuner */
 	int tuner_addr;		/* tuner address */
 	int tda9887_conf;
+
 	/* i2c i/o */
-	struct i2c_adapter i2c_adap;
-	struct i2c_client i2c_client;
+	struct i2c_adapter i2c_adap[NUM_I2C_BUSES];
+	struct i2c_client i2c_client[NUM_I2C_BUSES];
 	unsigned char eeprom_addrwidth_16bit:1;
+	int def_i2c_bus;	/* Default I2C bus */
+
 	/* video for linux */
 	int users;		/* user count for exclusive use */
 	int streaming_users;    /* Number of actively streaming users */
-- 
1.8.1.4

