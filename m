Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab0I1Sv3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 14:51:29 -0400
Date: Tue, 28 Sep 2010 15:46:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Srinivasa.Deevi@conexant.com, Palash.Bandyopadhyay@conexant.com,
	dheitmueller@kernellabs.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 05/10] V4L/DVB: cx231xx: properly use the right tuner i2c
 address
Message-ID: <20100928154657.33ef83ab@pedra>
In-Reply-To: <cover.1285699057.git.mchehab@redhat.com>
References: <cover.1285699057.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The driver has a field to indicate what bus is used by tuner and
by demod. However, this field were never used. On Pixelview,
it uses I2C 2 for tuner, instead of I2C 1.

	drivers/media/video/cx231xx/cx231xx-cards.c

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-cards.c b/drivers/media/video/cx231xx/cx231xx-cards.c
index b516068..8e088db 100644
--- a/drivers/media/video/cx231xx/cx231xx-cards.c
+++ b/drivers/media/video/cx231xx/cx231xx-cards.c
@@ -569,7 +569,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	/* Initialize the tuner */
 	if (dev->board.tuner_type != TUNER_ABSENT) {
 		dev->sd_tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-						    &dev->i2c_bus[1].i2c_adap,
+						    &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 						    "tuner", "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
diff --git a/drivers/media/video/cx231xx/cx231xx-dvb.c b/drivers/media/video/cx231xx/cx231xx-dvb.c
index 879eacb..4efd3d3 100644
--- a/drivers/media/video/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/video/cx231xx/cx231xx-dvb.c
@@ -347,7 +347,7 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	struct xc5000_config cfg;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.i2c_adap = &dev->i2c_bus[1].i2c_adap;
+	cfg.i2c_adap = &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap;
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
@@ -573,7 +573,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[2].i2c_adap);
+					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -586,7 +586,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[1].i2c_adap,
+			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 			       &cnxt_rde250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -598,7 +598,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &xc5000_s5h1411_config,
-					       &dev->i2c_bus[2].i2c_adap);
+					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -611,7 +611,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[1].i2c_adap,
+			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 			       &cnxt_rdu250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -621,7 +621,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[2].i2c_adap);
+					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -634,7 +634,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[1].i2c_adap,
+			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -644,7 +644,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &tda18271_s5h1411_config,
-					       &dev->i2c_bus[2].i2c_adap);
+					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -657,7 +657,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[1].i2c_adap,
+			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -666,11 +666,11 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
 		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(&dev->i2c_bus[1].i2c_adap));
+		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
 
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
 						&hcw_lgdt3305_config,
-						&dev->i2c_bus[1].i2c_adap);
+						&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -683,7 +683,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
-			   0x60, &dev->i2c_bus[1].i2c_adap,
+			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
 			   &hcw_tda18271_config);
 		break;
 
-- 
1.7.1


