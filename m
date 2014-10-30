Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:35015 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161094AbaJ3UNL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 16:13:11 -0400
From: Matthias Schwarzott <zzam@gentoo.org>
To: mchehab@osg.samsung.com, crope@iki.fi, linux-media@vger.kernel.org
Cc: Matthias Schwarzott <zzam@gentoo.org>
Subject: [PATCH v4 07/14] cx231xx: add wrapper to get the i2c_adapter pointer
Date: Thu, 30 Oct 2014 21:12:28 +0100
Message-Id: <1414699955-5760-8-git-send-email-zzam@gentoo.org>
In-Reply-To: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
References: <1414699955-5760-1-git-send-email-zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a preparation for mapping I2C_1_MUX_1 and I2C_1_MUX_3 later to the seperate
muxed i2c adapters.

Map mux adapters to I2C_1 for now.

Add local variables for i2c_adapters in dvb_init to get line lengths
shorter.

Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
Reviewed-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/cx231xx/cx231xx-cards.c |  8 +++---
 drivers/media/usb/cx231xx/cx231xx-dvb.c   | 42 +++++++++++++++++--------------
 drivers/media/usb/cx231xx/cx231xx-i2c.c   | 20 ++++++++++++++-
 drivers/media/usb/cx231xx/cx231xx-input.c |  3 ++-
 drivers/media/usb/cx231xx/cx231xx.h       |  1 +
 5 files changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
index 2f027c7..f5fb93a 100644
--- a/drivers/media/usb/cx231xx/cx231xx-cards.c
+++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
@@ -1033,7 +1033,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 	/* request some modules */
 	if (dev->board.decoder == CX231XX_AVDECODER) {
 		dev->sd_cx25840 = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-					&dev->i2c_bus[I2C_0].i2c_adap,
+					cx231xx_get_i2c_adap(dev, I2C_0),
 					"cx25840", 0x88 >> 1, NULL);
 		if (dev->sd_cx25840 == NULL)
 			cx231xx_info("cx25840 subdev registration failure\n");
@@ -1043,8 +1043,10 @@ void cx231xx_card_setup(struct cx231xx *dev)
 
 	/* Initialize the tuner */
 	if (dev->board.tuner_type != TUNER_ABSENT) {
+		struct i2c_adapter *tuner_i2c = cx231xx_get_i2c_adap(dev,
+						dev->board.tuner_i2c_master);
 		dev->sd_tuner = v4l2_i2c_new_subdev(&dev->v4l2_dev,
-						    &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+						    tuner_i2c,
 						    "tuner",
 						    dev->tuner_addr, NULL);
 		if (dev->sd_tuner == NULL)
@@ -1062,7 +1064,7 @@ void cx231xx_card_setup(struct cx231xx *dev)
 			struct i2c_client client;
 
 			memset(&client, 0, sizeof(client));
-			client.adapter = &dev->i2c_bus[I2C_1].i2c_adap;
+			client.adapter = cx231xx_get_i2c_adap(dev, I2C_1);
 			client.addr = 0xa0 >> 1;
 
 			read_eeprom(dev, &client, eeprom, sizeof(eeprom));
diff --git a/drivers/media/usb/cx231xx/cx231xx-dvb.c b/drivers/media/usb/cx231xx/cx231xx-dvb.c
index 6c7b5e2..869c433 100644
--- a/drivers/media/usb/cx231xx/cx231xx-dvb.c
+++ b/drivers/media/usb/cx231xx/cx231xx-dvb.c
@@ -378,7 +378,7 @@ static int attach_xc5000(u8 addr, struct cx231xx *dev)
 	struct xc5000_config cfg;
 
 	memset(&cfg, 0, sizeof(cfg));
-	cfg.i2c_adap = &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap;
+	cfg.i2c_adap = cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master);
 	cfg.i2c_addr = addr;
 
 	if (!dev->dvb->frontend) {
@@ -583,6 +583,8 @@ static int dvb_init(struct cx231xx *dev)
 {
 	int result = 0;
 	struct cx231xx_dvb *dvb;
+	struct i2c_adapter *tuner_i2c;
+	struct i2c_adapter *demod_i2c;
 
 	if (!dev->board.has_dvb) {
 		/* This device does not support the extension */
@@ -599,6 +601,8 @@ static int dvb_init(struct cx231xx *dev)
 	dev->cx231xx_set_analog_freq = cx231xx_set_analog_freq;
 	dev->cx231xx_reset_analog_tuner = cx231xx_reset_analog_tuner;
 
+	tuner_i2c = cx231xx_get_i2c_adap(dev, dev->board.tuner_i2c_master);
+	demod_i2c = cx231xx_get_i2c_adap(dev, dev->board.demod_i2c_master);
 	mutex_lock(&dev->lock);
 	cx231xx_set_mode(dev, CX231XX_DIGITAL_MODE);
 	cx231xx_demod_reset(dev);
@@ -609,7 +613,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -622,7 +626,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       tuner_i2c,
 			       &cnxt_rde250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -634,7 +638,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &xc5000_s5h1411_config,
-					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -647,7 +651,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(xc5000_attach, dev->dvb->frontend,
-			       &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       tuner_i2c,
 			       &cnxt_rdu250_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -657,7 +661,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1432_attach,
 					&dvico_s5h1432_config,
-					&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -670,7 +674,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       0x60, tuner_i2c,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -681,7 +685,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(s5h1411_attach,
 					       &tda18271_s5h1411_config,
-					       &dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+					       demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -694,7 +698,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		if (!dvb_attach(tda18271_attach, dev->dvb->frontend,
-			       0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			       0x60, tuner_i2c,
 			       &cnxt_rde253s_tunerconfig)) {
 			result = -EINVAL;
 			goto out_free;
@@ -703,11 +707,11 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_HAUPPAUGE_EXETER:
 
 		printk(KERN_INFO "%s: looking for tuner / demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+		       __func__, i2c_adapter_id(tuner_i2c));
 
 		dev->dvb->frontend = dvb_attach(lgdt3305_attach,
 						&hcw_lgdt3305_config,
-						&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap);
+						tuner_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -720,7 +724,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
-			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   0x60, tuner_i2c,
 			   &hcw_tda18271_config);
 		break;
 
@@ -728,7 +732,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&hauppauge_930C_HD_1113xx_si2165_config,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			tuner_i2c
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -745,7 +749,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
 			0x60,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			tuner_i2c,
 			&hcw_tda18271_config);
 
 		dev->cx231xx_reset_analog_tuner = NULL;
@@ -761,7 +765,7 @@ static int dvb_init(struct cx231xx *dev)
 
 		dev->dvb->frontend = dvb_attach(si2165_attach,
 			&pctv_quatro_stick_1114xx_si2165_config,
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap
+			tuner_i2c
 			);
 
 		if (dev->dvb->frontend == NULL) {
@@ -786,7 +790,7 @@ static int dvb_init(struct cx231xx *dev)
 		request_module("si2157");
 
 		client = i2c_new_device(
-			&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			tuner_i2c,
 			&info);
 		if (client == NULL || client->dev.driver == NULL) {
 			dvb_frontend_detach(dev->dvb->frontend);
@@ -811,11 +815,11 @@ static int dvb_init(struct cx231xx *dev)
 	case CX231XX_BOARD_KWORLD_UB430_USB_HYBRID:
 
 		printk(KERN_INFO "%s: looking for demod on i2c bus: %d\n",
-		       __func__, i2c_adapter_id(&dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap));
+		       __func__, i2c_adapter_id(tuner_i2c));
 
 		dev->dvb->frontend = dvb_attach(mb86a20s_attach,
 						&pv_mb86a20s_config,
-						&dev->i2c_bus[dev->board.demod_i2c_master].i2c_adap);
+						demod_i2c);
 
 		if (dev->dvb->frontend == NULL) {
 			printk(DRIVER_NAME
@@ -828,7 +832,7 @@ static int dvb_init(struct cx231xx *dev)
 		dvb->frontend->callback = cx231xx_tuner_callback;
 
 		dvb_attach(tda18271_attach, dev->dvb->frontend,
-			   0x60, &dev->i2c_bus[dev->board.tuner_i2c_master].i2c_adap,
+			   0x60, tuner_i2c,
 			   &pv_tda18271_config);
 		break;
 
diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
index 4505716..af9180f 100644
--- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
+++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
@@ -483,7 +483,7 @@ void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port)
 	struct i2c_client client;
 
 	memset(&client, 0, sizeof(client));
-	client.adapter = &dev->i2c_bus[i2c_port].i2c_adap;
+	client.adapter = cx231xx_get_i2c_adap(dev, i2c_port);
 
 	cx231xx_info(": Checking for I2C devices on port=%d ..\n", i2c_port);
 	for (i = 0; i < 128; i++) {
@@ -537,3 +537,21 @@ int cx231xx_i2c_unregister(struct cx231xx_i2c *bus)
 	i2c_del_adapter(&bus->i2c_adap);
 	return 0;
 }
+
+struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
+{
+	switch (i2c_port) {
+	case I2C_0:
+		return &dev->i2c_bus[0].i2c_adap;
+	case I2C_1:
+		return &dev->i2c_bus[1].i2c_adap;
+	case I2C_2:
+		return &dev->i2c_bus[2].i2c_adap;
+	case I2C_1_MUX_1:
+	case I2C_1_MUX_3:
+		return &dev->i2c_bus[1].i2c_adap;
+	default:
+		return NULL;
+	}
+}
+EXPORT_SYMBOL_GPL(cx231xx_get_i2c_adap);
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 05f0434..5ae2ce3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -100,7 +100,8 @@ int cx231xx_ir_init(struct cx231xx *dev)
 	ir_i2c_bus = cx231xx_boards[dev->model].ir_i2c_master;
 	dev_dbg(&dev->udev->dev, "Trying to bind ir at bus %d, addr 0x%02x\n",
 		ir_i2c_bus, info.addr);
-	dev->ir_i2c_client = i2c_new_device(&dev->i2c_bus[ir_i2c_bus].i2c_adap, &info);
+	dev->ir_i2c_client = i2c_new_device(
+		cx231xx_get_i2c_adap(dev, ir_i2c_bus), &info);
 
 	return 0;
 }
diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
index 377216b..f03338b 100644
--- a/drivers/media/usb/cx231xx/cx231xx.h
+++ b/drivers/media/usb/cx231xx/cx231xx.h
@@ -754,6 +754,7 @@ int cx231xx_reset_analog_tuner(struct cx231xx *dev);
 void cx231xx_do_i2c_scan(struct cx231xx *dev, int i2c_port);
 int cx231xx_i2c_register(struct cx231xx_i2c *bus);
 int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
+struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
 
 /* Internal block control functions */
 int cx231xx_read_i2c_master(struct cx231xx *dev, u8 dev_addr, u16 saddr,
-- 
2.1.2

