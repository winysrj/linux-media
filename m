Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:49815 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbeCIPxm (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:42 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/11] media: lgdt330x: use pr_foo() macros
Date: Fri,  9 Mar 2018 12:53:28 -0300
Message-Id: <64875f3014f9da0ed6282b45b96d3329d774874e.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cleanup the usecases of dprintk() by using pr_fmt() and replace
printk by pr_foo().

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/lgdt330x.c | 64 ++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index ad0842fcdba5..a3139eb69c93 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -29,6 +29,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -48,9 +50,11 @@
 static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off lgdt330x frontend debugging (default:off).");
-#define dprintk(args...) do {				\
-	if (debug)					\
-		printk(KERN_DEBUG "lgdt330x: " args);	\
+
+#define dprintk(fmt, arg...) do {					\
+	if (debug)							\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
+		       __func__, ##arg);				\
 } while (0)
 
 struct lgdt330x_state {
@@ -85,8 +89,8 @@ static int i2c_write_demod_bytes(struct lgdt330x_state *state,
 	for (i = 0; i < len - 1; i += 2) {
 		err = i2c_transfer(state->i2c, &msg, 1);
 		if (err != 1) {
-			printk(KERN_WARNING "lgdt330x: %s error (addr %02x <- %02x, err = %i)\n",
-			       __func__, msg.buf[0], msg.buf[1], err);
+			pr_warn("%s: error (addr %02x <- %02x, err = %i)\n",
+				__func__, msg.buf[0], msg.buf[1], err);
 			if (err < 0)
 				return err;
 			else
@@ -122,8 +126,8 @@ static int i2c_read_demod_bytes(struct lgdt330x_state *state,
 
 	ret = i2c_transfer(state->i2c, msg, 2);
 	if (ret != 2) {
-		printk(KERN_WARNING "lgdt330x: %s: addr 0x%02x select 0x%02x error (ret == %i)\n",
-		       __func__, state->config->demod_address, reg, ret);
+		pr_warn("%s: addr 0x%02x select 0x%02x error (ret == %i)\n",
+			__func__, state->config->demod_address, reg, ret);
 		if (ret >= 0)
 			ret = -EIO;
 	} else {
@@ -295,7 +299,7 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
-	dprintk("%s entered as %s\n", __func__, chip_name);
+	dprintk("entered as %s\n", chip_name);
 	if (err < 0)
 		return err;
 	return lgdt330x_sw_reset(state);
@@ -378,7 +382,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 	if (state->current_modulation != p->modulation) {
 		switch (p->modulation) {
 		case VSB_8:
-			dprintk("%s: VSB_8 MODE\n", __func__);
+			dprintk("VSB_8 MODE\n");
 
 			/* Select VSB mode */
 			top_ctrl_cfg[1] = 0x03;
@@ -395,7 +399,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			break;
 
 		case QAM_64:
-			dprintk("%s: QAM_64 MODE\n", __func__);
+			dprintk("QAM_64 MODE\n");
 
 			/* Select QAM_64 mode */
 			top_ctrl_cfg[1] = 0x00;
@@ -412,7 +416,7 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			break;
 
 		case QAM_256:
-			dprintk("%s: QAM_256 MODE\n", __func__);
+			dprintk("QAM_256 MODE\n");
 
 			/* Select QAM_256 mode */
 			top_ctrl_cfg[1] = 0x01;
@@ -428,13 +432,13 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			}
 			break;
 		default:
-			printk(KERN_WARNING "lgdt330x: %s: Modulation type(%d) UNSUPPORTED\n",
-			       __func__, p->modulation);
+			pr_warn("%s: Modulation type(%d) UNSUPPORTED\n",
+				__func__, p->modulation);
 			return -1;
 		}
 		if (err < 0)
-			printk(KERN_WARNING "lgdt330x: %s: error blasting bytes to lgdt3303 for modulation type(%d)\n",
-			       __func__, p->modulation);
+			pr_warn("%s: error blasting bytes to lgdt3303 for modulation type(%d)\n",
+				__func__, p->modulation);
 
 		/*
 		 * select serial or parallel MPEG hardware interface
@@ -488,7 +492,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* AGC status register */
 	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
+	dprintk("AGC_STATUS = 0x%02x\n", buf[0]);
 	if ((buf[0] & 0x0c) == 0x8) {
 		/*
 		 * Test signal does not exist flag
@@ -505,8 +509,8 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* signal status */
 	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk("%s: TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
-		__func__, buf[0], buf[1], buf[2]);
+	dprintk("TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
+		buf[0], buf[1], buf[2]);
 
 	/* sync status */
 	if ((buf[2] & 0x03) == 0x01)
@@ -520,7 +524,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
+	dprintk("CARRIER_LOCK = 0x%02x\n", buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -533,8 +537,8 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 			*status |= FE_HAS_CARRIER;
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __func__);
+		pr_warn("%s: Modulation set to unsupported value\n",
+			__func__);
 	}
 
 	return 0;
@@ -554,7 +558,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 	if (err < 0)
 		return err;
 
-	dprintk("%s: AGC_STATUS = 0x%02x\n", __func__, buf[0]);
+	dprintk("AGC_STATUS = 0x%02x\n", buf[0]);
 	if ((buf[0] & 0x21) == 0x01) {
 		/*
 		 * Test input signal does not exist flag
@@ -565,7 +569,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("%s: CARRIER_LOCK = 0x%02x\n", __func__, buf[0]);
+	dprintk("CARRIER_LOCK = 0x%02x\n", buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -596,8 +600,8 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		}
 		break;
 	default:
-		printk(KERN_WARNING "lgdt330x: %s: Modulation set to unsupported value\n",
-		       __func__);
+		pr_warn("%s: Modulation set to unsupported value\n",
+			__func__);
 	}
 	return 0;
 }
@@ -673,7 +677,7 @@ static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* log10(688128)*2^24 and log10(696320)*2^24 */
 		break;
 	default:
-		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
+		pr_err("%s: Modulation set to unsupported value\n",
 		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
@@ -681,7 +685,7 @@ static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
+	dprintk("noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -717,7 +721,7 @@ static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* log10(688128)*2^24 and log10(696320)*2^24 */
 		break;
 	default:
-		printk(KERN_ERR "lgdt330x: %s: Modulation set to unsupported value\n",
+		pr_err("%s: Modulation set to unsupported value\n",
 		       __func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
@@ -725,7 +729,7 @@ static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("%s: noise = 0x%08x, snr = %d.%02d dB\n", __func__, noise,
+	dprintk("noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -817,7 +821,7 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 
 error:
 	kfree(state);
-	dprintk("%s: ERROR\n", __func__);
+	dprintk("ERROR\n");
 	return NULL;
 }
 EXPORT_SYMBOL(lgdt330x_attach);
-- 
2.14.3
