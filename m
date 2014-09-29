Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48688 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaI2CXu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Sep 2014 22:23:50 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Johannes Stezenbach <js@linuxtv.org>
Subject: [PATCH 5/6] [media] em28xx: move board-specific init code
Date: Sun, 28 Sep 2014 23:23:22 -0300
Message-Id: <84057c3007157e6353817d166935ca600b6510a8.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1411956856.git.mchehab@osg.samsung.com>
References: <cover.1411956856.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some drivers are doing some board-specific init.

The same init is also needed during restore, so, let's
move this code to a separate function.

No functional changes should be noticed so far

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 3d19607bd8f0..ff46ba46a34d 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1045,6 +1045,29 @@ static void em28xx_unregister_dvb(struct em28xx_dvb *dvb)
 	dvb_unregister_adapter(&dvb->adapter);
 }
 
+static void em28xx_dvb_board_init(struct em28xx *dev, struct em28xx_dvb *dvb)
+{
+	/* init frontend */
+	switch (dev->model) {
+	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
+		hauppauge_hvr930c_init(dev);
+		break;
+	case EM2884_BOARD_TERRATEC_H5:
+		terratec_h5_init(dev);
+		break;
+	case EM2884_BOARD_PCTV_510E:
+	case EM2884_BOARD_PCTV_520E:
+		pctv_520e_init(dev);
+		break;
+	case EM2884_BOARD_CINERGY_HTC_STICK:
+		terratec_htc_stick_init(dev);
+		break;
+	case EM2884_BOARD_TERRATEC_HTC_USB_XS:
+		terratec_htc_usb_xs_init(dev);
+		break;
+	}
+}
+
 static int em28xx_dvb_init(struct em28xx *dev)
 {
 	int result = 0;
@@ -1093,6 +1116,8 @@ static int em28xx_dvb_init(struct em28xx *dev)
 
 	mutex_lock(&dev->lock);
 	em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
+	em28xx_dvb_board_init(dev, dvb);
+
 	/* init frontend */
 	switch (dev->model) {
 	case EM2874_BOARD_LEADERSHIP_ISDBT:
@@ -1266,7 +1291,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2884_BOARD_HAUPPAUGE_WINTV_HVR_930C:
 	{
 		struct xc5000_config cfg;
-		hauppauge_hvr930c_init(dev);
 
 		dvb->fe[0] = dvb_attach(drxk_attach,
 					&hauppauge_930c_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
@@ -1298,8 +1322,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	}
 	case EM2884_BOARD_TERRATEC_H5:
-		terratec_h5_init(dev);
-
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_h5_drxk, &dev->i2c_adap[dev->def_i2c_bus]);
 		if (!dvb->fe[0]) {
 			result = -EINVAL;
@@ -1363,8 +1385,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		break;
 	case EM2884_BOARD_PCTV_510E:
 	case EM2884_BOARD_PCTV_520E:
-		pctv_520e_init(dev);
-
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &pctv_520e_drxk,
 				&dev->i2c_adap[dev->def_i2c_bus]);
@@ -1381,8 +1401,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	case EM2884_BOARD_CINERGY_HTC_STICK:
-		terratec_htc_stick_init(dev);
-
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_htc_stick_drxk,
 					&dev->i2c_adap[dev->def_i2c_bus]);
@@ -1400,8 +1418,6 @@ static int em28xx_dvb_init(struct em28xx *dev)
 		}
 		break;
 	case EM2884_BOARD_TERRATEC_HTC_USB_XS:
-		terratec_htc_usb_xs_init(dev);
-
 		/* attach demodulator */
 		dvb->fe[0] = dvb_attach(drxk_attach, &terratec_htc_stick_drxk,
 					&dev->i2c_adap[dev->def_i2c_bus]);
-- 
1.9.3

