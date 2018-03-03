Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45670 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751923AbeCCPQT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 3 Mar 2018 10:16:19 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 2/2] media: em28xx-dvb: do some coding style improvements
Date: Sat,  3 Mar 2018 12:16:12 -0300
Message-Id: <63392fab77026ce3f75785b603c25929048e29f3.1520090161.git.mchehab@s-opensource.com>
In-Reply-To: <0728180f1e956d290122b3c430632fc352293adb.1520090161.git.mchehab@s-opensource.com>
References: <0728180f1e956d290122b3c430632fc352293adb.1520090161.git.mchehab@s-opensource.com>
In-Reply-To: <0728180f1e956d290122b3c430632fc352293adb.1520090161.git.mchehab@s-opensource.com>
References: <0728180f1e956d290122b3c430632fc352293adb.1520090161.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As we're touching a lot on this file, let's solve several
Coding Style issues there using checkpatch --fix-inline --strict,
and manually adjusting the results.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 194 ++++++++++++++++++----------------
 1 file changed, 104 insertions(+), 90 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index f188b5ff31b7..7f21f3e6ca71 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -96,7 +96,7 @@ struct em28xx_dvb {
 	struct dvb_net             net;
 
 	/* Due to DRX-K - probably need changes */
-	int (*gate_ctrl)(struct dvb_frontend *, int);
+	int (*gate_ctrl)(struct dvb_frontend *fe, int gate);
 	struct semaphore      pll_mutex;
 	bool			dont_attach_fe1;
 	int			lna_gpio;
@@ -278,14 +278,13 @@ static int em28xx_stop_feed(struct dvb_demux_feed *feed)
 	mutex_lock(&dvb->lock);
 	dvb->nfeeds--;
 
-	if (0 == dvb->nfeeds)
+	if (!dvb->nfeeds)
 		err = em28xx_stop_streaming(dvb);
 
 	mutex_unlock(&dvb->lock);
 	return err;
 }
 
-
 /* ------------------------------------------------------------------ */
 static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 {
@@ -514,14 +513,15 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 
 	em28xx_gpio_set(dev, hauppauge_hvr930c_init);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
-	msleep(10);
+	usleep_range(10000, 11000);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				regs[i].r, regs[i].len);
 	em28xx_gpio_set(dev, hauppauge_hvr930c_end);
 
 	msleep(100);
@@ -530,8 +530,7 @@ static void hauppauge_hvr930c_init(struct em28xx *dev)
 	msleep(30);
 
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
-	msleep(10);
-
+	usleep_range(10000, 11000);
 }
 
 static void terratec_h5_init(struct em28xx *dev)
@@ -571,14 +570,15 @@ static void terratec_h5_init(struct em28xx *dev)
 
 	em28xx_gpio_set(dev, terratec_h5_init);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
-	msleep(10);
+	usleep_range(10000, 11000);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x45);
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				regs[i].r, regs[i].len);
 	em28xx_gpio_set(dev, terratec_h5_end);
 };
 
@@ -624,14 +624,15 @@ static void terratec_htc_stick_init(struct em28xx *dev)
 	em28xx_gpio_set(dev, terratec_htc_stick_init);
 
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
-	msleep(10);
+	usleep_range(10000, 11000);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				regs[i].r, regs[i].len);
 
 	em28xx_gpio_set(dev, terratec_htc_stick_end);
 };
@@ -682,14 +683,15 @@ static void terratec_htc_usb_xs_init(struct em28xx *dev)
 	em28xx_gpio_set(dev, terratec_htc_usb_xs_init);
 
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x40);
-	msleep(10);
+	usleep_range(10000, 11000);
 	em28xx_write_reg(dev, EM28XX_R06_I2C_CLK, 0x44);
-	msleep(10);
+	usleep_range(10000, 11000);
 
 	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1;
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				regs[i].r, regs[i].len);
 
 	em28xx_gpio_set(dev, terratec_htc_usb_xs_end);
 };
@@ -718,7 +720,8 @@ static void pctv_520e_init(struct em28xx *dev)
 	dev->i2c_client[dev->def_i2c_bus].addr = 0x82 >> 1; /* 0x41 */
 
 	for (i = 0; i < ARRAY_SIZE(regs); i++)
-		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus], regs[i].r, regs[i].len);
+		i2c_master_send(&dev->i2c_client[dev->def_i2c_bus],
+				regs[i].r, regs[i].len);
 };
 
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
@@ -780,7 +783,7 @@ static int em28xx_mt352_terratec_xs_init(struct dvb_frontend *fe)
 	static u8 tuner_go[]       = { TUNER_GO, 0x01};
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
-	udelay(200);
+	usleep_range(200, 250);
 	mt352_write(fe, reset,          sizeof(reset));
 	mt352_write(fe, adc_ctl_1_cfg,  sizeof(adc_ctl_1_cfg));
 	mt352_write(fe, agc_cfg,        sizeof(agc_cfg));
@@ -840,8 +843,8 @@ static void px_bcud_init(struct em28xx *dev)
 	/* sleeping ISDB-T */
 	dev->dvb->i2c_client_demod->addr = 0x14;
 	for (i = 0; i < ARRAY_SIZE(regs1); i++)
-		i2c_master_send(dev->dvb->i2c_client_demod, regs1[i].r,
-				regs1[i].len);
+		i2c_master_send(dev->dvb->i2c_client_demod,
+				regs1[i].r, regs1[i].len);
 	/* sleeping ISDB-S */
 	dev->dvb->i2c_client_demod->addr = 0x15;
 	for (i = 0; i < ARRAY_SIZE(regs2); i++)
@@ -1190,8 +1193,8 @@ static int em28178_dvb_init_pctv_461e(struct em28xx *dev)
 	ts2020_config.fe = dvb->fe[0];
 
 	dvb->i2c_client_tuner = dvb_module_probe("ts2020", "ts2022",
-					         i2c_adapter,
-					         0x60, &ts2020_config);
+						 i2c_adapter,
+						 0x60, &ts2020_config);
 	if (!dvb->i2c_client_tuner) {
 		dvb_module_release(dvb->i2c_client_demod);
 		return -ENODEV;
@@ -1204,8 +1207,8 @@ static int em28178_dvb_init_pctv_461e(struct em28xx *dev)
 	/* attach SEC */
 	a8293_pdata.dvb_frontend = dvb->fe[0];
 	dvb->i2c_client_sec = dvb_module_probe("a8293", NULL,
-				  &dev->i2c_adap[dev->def_i2c_bus],
-				  0x08, &a8293_pdata);
+					       &dev->i2c_adap[dev->def_i2c_bus],
+					       0x08, &a8293_pdata);
 	if (!dvb->i2c_client_sec) {
 		dvb_module_release(dvb->i2c_client_tuner);
 		dvb_module_release(dvb->i2c_client_demod);
@@ -1407,12 +1410,13 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 	dev_info(&dev->intf->dev, "Binding DVB extension\n");
 
-	dvb = kzalloc(sizeof(struct em28xx_dvb), GFP_KERNEL);
+	dvb = kzalloc(sizeof(*dvb), GFP_KERNEL);
 	if (!dvb)
 		return -ENOMEM;
 
 	dev->dvb = dvb;
-	dvb->fe[0] = dvb->fe[1] = NULL;
+	dvb->fe[0] = NULL;
+	dvb->fe[1] = NULL;
 
 	/* pre-allocate DVB usb transfer buffers */
 	if (dev->dvb_xfer_bulk) {
@@ -1442,7 +1446,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	switch (dev->model) {
 	case EM2874_BOARD_LEADERSHIP_ISDBT:
 		dvb->fe[0] = dvb_attach(s921_attach,
-				&sharp_isdbt, &dev->i2c_adap[dev->def_i2c_bus]);
+					&sharp_isdbt,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
@@ -1455,8 +1460,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
 	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
-					   &em2880_lgdt3303_dev,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+					&em2880_lgdt3303_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1464,8 +1469,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2880_BOARD_KWORLD_DVB_310U:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
-					   &em28xx_zl10353_with_xc3028,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+					&em28xx_zl10353_with_xc3028,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1475,8 +1480,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_TERRATEC_HYBRID_XS:
 	case EM2880_BOARD_EMPIRE_DUAL_TV:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
-					   &em28xx_zl10353_xc3028_no_i2c_gate,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+					&em28xx_zl10353_xc3028_no_i2c_gate,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1488,44 +1493,47 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_DIKOM_DK300:
 	case EM2882_BOARD_KWORLD_VS_DVBT:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
-					   &em28xx_zl10353_xc3028_no_i2c_gate,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] == NULL) {
-			/* This board could have either a zl10353 or a mt352.
-			   If the chip id isn't for zl10353, try mt352 */
+					&em28xx_zl10353_xc3028_no_i2c_gate,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (!dvb->fe[0]) {
+			/*
+			 * This board could have either a zl10353 or a mt352.
+			 * If the chip id isn't for zl10353, try mt352
+			 */
 			dvb->fe[0] = dvb_attach(mt352_attach,
-						   &terratec_xs_mt352_cfg,
-						   &dev->i2c_adap[dev->def_i2c_bus]);
-		}
-
-		if (em28xx_attach_xc3028(0x61, dev) < 0) {
-			result = -EINVAL;
-			goto out_free;
-		}
-		break;
-	case EM2870_BOARD_TERRATEC_XS_MT2060:
-		dvb->fe[0] = dvb_attach(zl10353_attach,
-						&em28xx_zl10353_no_i2c_gate_dev,
+						&terratec_xs_mt352_cfg,
 						&dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL) {
+		}
+
+		if (em28xx_attach_xc3028(0x61, dev) < 0) {
+			result = -EINVAL;
+			goto out_free;
+		}
+		break;
+	case EM2870_BOARD_TERRATEC_XS_MT2060:
+		dvb->fe[0] = dvb_attach(zl10353_attach,
+					&em28xx_zl10353_no_i2c_gate_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0]) {
 			dvb_attach(mt2060_attach, dvb->fe[0],
-					&dev->i2c_adap[dev->def_i2c_bus],
-					&em28xx_mt2060_config, 1220);
+				   &dev->i2c_adap[dev->def_i2c_bus],
+				   &em28xx_mt2060_config, 1220);
 		}
 		break;
 	case EM2870_BOARD_KWORLD_355U:
 		dvb->fe[0] = dvb_attach(zl10353_attach,
-					   &em28xx_zl10353_no_i2c_gate_dev,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL)
+					&em28xx_zl10353_no_i2c_gate_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0])
 			dvb_attach(qt1010_attach, dvb->fe[0],
-				   &dev->i2c_adap[dev->def_i2c_bus], &em28xx_qt1010_config);
+				   &dev->i2c_adap[dev->def_i2c_bus],
+				   &em28xx_qt1010_config);
 		break;
 	case EM2883_BOARD_KWORLD_HYBRID_330U:
 	case EM2882_BOARD_EVGA_INDTUBE:
 		dvb->fe[0] = dvb_attach(s5h1409_attach,
-					   &em28xx_s5h1409_with_xc3028,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+					&em28xx_s5h1409_with_xc3028,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
 			goto out_free;
@@ -1533,9 +1541,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
-					   &em2880_lgdt3303_dev,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL) {
+					&em2880_lgdt3303_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0]) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
 					&dev->i2c_adap[dev->def_i2c_bus],
 					0x61, TUNER_THOMSON_DTT761X)) {
@@ -1557,8 +1565,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2870_BOARD_REDDO_DVB_C_USB_BOX:
 		/* Philips CU1216L NIM (Philips TDA10023 + Infineon TUA6034) */
 		dvb->fe[0] = dvb_attach(tda10023_attach,
-			&em28xx_tda10023_config,
-			&dev->i2c_adap[dev->def_i2c_bus], 0x48);
+					&em28xx_tda10023_config,
+					&dev->i2c_adap[dev->def_i2c_bus],
+					0x48);
 		if (dvb->fe[0]) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
 					&dev->i2c_adap[dev->def_i2c_bus],
@@ -1570,18 +1579,18 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2870_BOARD_KWORLD_A340:
 		dvb->fe[0] = dvb_attach(lgdt3305_attach,
-					   &em2870_lgdt3304_dev,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
+					&em2870_lgdt3304_dev,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
 		}
 		if (!dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				&dev->i2c_adap[dev->def_i2c_bus],
-			&kworld_a340_config)) {
-				dvb_frontend_detach(dvb->fe[0]);
-				result = -EINVAL;
-				goto out_free;
+				&kworld_a340_config)) {
+			dvb_frontend_detach(dvb->fe[0]);
+			result = -EINVAL;
+			goto out_free;
 		}
 		break;
 	case EM28174_BOARD_PCTV_290E:
@@ -1599,7 +1608,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 					0x60,
 					&dev->i2c_adap[dev->def_i2c_bus],
 					&em28xx_cxd2820r_tda18271_config)) {
-
 				dvb_frontend_detach(dvb->fe[0]);
 				result = -EINVAL;
 				goto out_free;
@@ -1629,7 +1637,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		hauppauge_hvr930c_init(dev);
 
 		dvb->fe[0] = dvb_attach(drxk_attach,
-					&hauppauge_930c_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
+					&hauppauge_930c_drxk,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1646,8 +1655,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
-		if (!dvb_attach(xc5000_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus],
-				&cfg)) {
+		if (!dvb_attach(xc5000_attach, dvb->fe[0],
+				&dev->i2c_adap[dev->def_i2c_bus], &cfg)) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -1659,7 +1668,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2884_BOARD_TERRATEC_H5:
 		terratec_h5_init(dev);
 
-		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
+		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk,
+					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
 			goto out_free;
@@ -1673,7 +1683,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		/* Attach tda18271 to DVB-C frontend */
 		if (dvb->fe[0]->ops.i2c_gate_ctrl)
 			dvb->fe[0]->ops.i2c_gate_ctrl(dvb->fe[0], 1);
-		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0], &dev->i2c_adap[dev->def_i2c_bus], 0x60)) {
+		if (!dvb_attach(tda18271c2dd_attach, dvb->fe[0],
+				&dev->i2c_adap[dev->def_i2c_bus], 0x60)) {
 			result = -EINVAL;
 			goto out_free;
 		}
@@ -1683,9 +1694,9 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2884_BOARD_C3TECH_DIGITAL_DUO:
 		dvb->fe[0] = dvb_attach(mb86a20s_attach,
-					   &c3tech_duo_mb86a20s_config,
-					   &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL)
+					&c3tech_duo_mb86a20s_config,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0])
 			dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
 				   &dev->i2c_adap[dev->def_i2c_bus],
 				   &c3tech_duo_tda18271_config);
@@ -1699,7 +1710,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2874_BOARD_MAXMEDIA_UB425_TC:
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &maxmedia_ub425_tc_drxk,
-				&dev->i2c_adap[dev->def_i2c_bus]);
+					&dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (dvb->fe[0]) {
 			/* disable I2C-gate */
@@ -1721,7 +1732,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
-				&dev->i2c_adap[dev->def_i2c_bus]);
+					&dev->i2c_adap[dev->def_i2c_bus]);
 
 		if (dvb->fe[0]) {
 			/* attach tuner */
@@ -1807,8 +1818,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		kworld_ub435q_v3_config.fe = dvb->fe[0];
 
 		dvb->i2c_client_tuner = dvb_module_probe("tda18212", NULL,
-							 adapter,
-							 0x60,
+							 adapter, 0x60,
 							 &kworld_ub435q_v3_config);
 		if (!dvb->i2c_client_tuner) {
 			dvb_frontend_detach(dvb->fe[0]);
@@ -1818,9 +1828,11 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	}
 	case EM2874_BOARD_PCTV_HD_MINI_80E:
-		dvb->fe[0] = dvb_attach(drx39xxj_attach, &dev->i2c_adap[dev->def_i2c_bus]);
-		if (dvb->fe[0] != NULL) {
-			dvb->fe[0] = dvb_attach(tda18271_attach, dvb->fe[0], 0x60,
+		dvb->fe[0] = dvb_attach(drx39xxj_attach,
+					&dev->i2c_adap[dev->def_i2c_bus]);
+		if (dvb->fe[0]) {
+			dvb->fe[0] = dvb_attach(tda18271_attach, dvb->fe[0],
+						0x60,
 						&dev->i2c_adap[dev->def_i2c_bus],
 						&pinnacle_80e_dvb_config);
 			if (!dvb->fe[0]) {
@@ -1864,7 +1876,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 			"The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
-	if (NULL == dvb->fe[0]) {
+	if (!dvb->fe[0]) {
 		dev_err(&dev->intf->dev, "frontend initialization failed\n");
 		result = -EINVAL;
 		goto out_free;
@@ -1926,8 +1938,10 @@ static int em28xx_dvb_fini(struct em28xx *dev)
 	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 
 	if (dev->disconnected) {
-		/* We cannot tell the device to sleep
-		 * once it has been unplugged. */
+		/*
+		 * We cannot tell the device to sleep
+		 * once it has been unplugged.
+		 */
 		if (dvb->fe[0]) {
 			prevent_sleep(&dvb->fe[0]->ops);
 			dvb->fe[0]->exit = DVB_FE_DEVICE_REMOVED;
-- 
2.14.3
