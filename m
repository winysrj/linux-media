Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:45263 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751143AbeCIPxo (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 10:53:44 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mike Isely <isely@pobox.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Brad Love <brad@nextdimension.cc>,
        Daniel Scheller <d.scheller@gmx.net>
Subject: [PATCH 05/11] media: lgdt330x: convert it to the new I2C binding way
Date: Fri,  9 Mar 2018 12:53:30 -0300
Message-Id: <1b74a9590df8cb5988f469afcf35c8d350bac51f.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
In-Reply-To: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
References: <c673e447c4776af9137fa9edd334ebf5298f1f08.1520610788.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Convert the driver to allow its usage with the new I2C
binding way.

Please notice that this patch doesn't convert the
callers to bind to it using the new way.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/common/b2c2/flexcop-fe-tuner.c |   4 +-
 drivers/media/dvb-frontends/lgdt330x.c       | 219 +++++++++++++++++----------
 drivers/media/dvb-frontends/lgdt330x.h       |  18 ++-
 drivers/media/pci/bt8xx/dvb-bt8xx.c          |   4 +-
 drivers/media/pci/cx23885/cx23885-dvb.c      |   6 +-
 drivers/media/pci/cx88/cx88-dvb.c            |   7 +-
 drivers/media/pci/ngene/ngene-cards.c        |   4 +-
 drivers/media/usb/dvb-usb/cxusb.c            |   9 +-
 drivers/media/usb/em28xx/em28xx-dvb.c        |   3 +-
 drivers/media/usb/pvrusb2/pvrusb2-devattr.c  |   4 +-
 10 files changed, 177 insertions(+), 101 deletions(-)

diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c b/drivers/media/common/b2c2/flexcop-fe-tuner.c
index a1ce3e8eb1d3..aac1aadb0cb1 100644
--- a/drivers/media/common/b2c2/flexcop-fe-tuner.c
+++ b/drivers/media/common/b2c2/flexcop-fe-tuner.c
@@ -495,7 +495,6 @@ static int airstar_atsc2_attach(struct flexcop_device *fc,
 /* AirStar ATSC 3rd generation */
 #if FE_SUPPORTED(LGDT330X)
 static struct lgdt330x_config air2pc_atsc_hd5000_config = {
-	.demod_address       = 0x59,
 	.demod_chip          = LGDT3303,
 	.serial_mpeg         = 0x04,
 	.clock_polarity_flip = 1,
@@ -504,7 +503,8 @@ static struct lgdt330x_config air2pc_atsc_hd5000_config = {
 static int airstar_atsc3_attach(struct flexcop_device *fc,
 	struct i2c_adapter *i2c)
 {
-	fc->fe = dvb_attach(lgdt330x_attach, &air2pc_atsc_hd5000_config, i2c);
+	fc->fe = dvb_attach(lgdt330x_attach, &air2pc_atsc_hd5000_config,
+			    0x59, i2c);
 	if (!fc->fe)
 		return 0;
 
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 1e52831cb603..a6fd5a239026 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -29,8 +29,6 @@
  *
  */
 
-#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -51,17 +49,16 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off lgdt330x frontend debugging (default:off).");
 
-#define dprintk(fmt, arg...) do {					\
+#define dprintk(state, fmt, arg...) do {				\
 	if (debug)							\
-		printk(KERN_DEBUG pr_fmt("%s: " fmt),			\
-		       __func__, ##arg);				\
+		dev_printk(KERN_DEBUG, &state->client->dev, fmt, ##arg);\
 } while (0)
 
 struct lgdt330x_state {
-	struct i2c_adapter *i2c;
+	struct i2c_client *client;
 
 	/* Configuration settings */
-	const struct lgdt330x_config *config;
+	struct lgdt330x_config config;
 
 	struct dvb_frontend frontend;
 
@@ -74,29 +71,24 @@ struct lgdt330x_state {
 };
 
 static int i2c_write_demod_bytes(struct lgdt330x_state *state,
-				 u8 *buf, /* data bytes to send */
+				 const u8 *buf, /* data bytes to send */
 				 int len  /* number of bytes to send */)
 {
-	struct i2c_msg msg = {
-		.addr = state->config->demod_address,
-		.flags = 0,
-		.buf = buf,
-		.len = 2
-	};
 	int i;
 	int err;
 
 	for (i = 0; i < len - 1; i += 2) {
-		err = i2c_transfer(state->i2c, &msg, 1);
-		if (err != 1) {
-			pr_warn("%s: error (addr %02x <- %02x, err = %i)\n",
-				__func__, msg.buf[0], msg.buf[1], err);
+		err = i2c_master_send(state->client, buf, 2);
+		if (err != 2) {
+			dev_warn(&state->client->dev,
+				 "%s: error (addr %02x <- %02x, err = %i)\n",
+				__func__, buf[0], buf[1], err);
 			if (err < 0)
 				return err;
 			else
 				return -EREMOTEIO;
 		}
-		msg.buf += 2;
+		buf += 2;
 	}
 	return 0;
 }
@@ -111,12 +103,12 @@ static int i2c_read_demod_bytes(struct lgdt330x_state *state,
 	u8 wr[] = { reg };
 	struct i2c_msg msg[] = {
 		{
-			.addr = state->config->demod_address,
+			.addr = state->client->addr,
 			.flags = 0,
 			.buf = wr,
 			.len = 1
 		}, {
-			.addr = state->config->demod_address,
+			.addr = state->client->addr,
 			.flags = I2C_M_RD,
 			.buf = buf,
 			.len = len
@@ -124,10 +116,11 @@ static int i2c_read_demod_bytes(struct lgdt330x_state *state,
 	};
 	int ret;
 
-	ret = i2c_transfer(state->i2c, msg, 2);
+	ret = i2c_transfer(state->client->adapter, msg, 2);
 	if (ret != 2) {
-		pr_warn("%s: addr 0x%02x select 0x%02x error (ret == %i)\n",
-			__func__, state->config->demod_address, reg, ret);
+		dev_warn(&state->client->dev,
+			 "%s: addr 0x%02x select 0x%02x error (ret == %i)\n",
+			 __func__, state->client->addr, reg, ret);
 		if (ret >= 0)
 			ret = -EIO;
 	} else {
@@ -181,7 +174,7 @@ static int lgdt3303_sw_reset(struct lgdt330x_state *state)
 
 static int lgdt330x_sw_reset(struct lgdt330x_state *state)
 {
-	switch (state->config->demod_chip) {
+	switch (state->config.demod_chip) {
 	case LGDT3302:
 		return lgdt3302_sw_reset(state);
 	case LGDT3303:
@@ -269,7 +262,7 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 	char  *chip_name;
 	int    err;
 
-	switch (state->config->demod_chip) {
+	switch (state->config.demod_chip) {
 	case LGDT3302:
 		chip_name = "LGDT3302";
 		err = i2c_write_demod_bytes(state, lgdt3302_init_data,
@@ -277,7 +270,7 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 		break;
 	case LGDT3303:
 		chip_name = "LGDT3303";
-		switch (state->config->clock_polarity_flip) {
+		switch (state->config.clock_polarity_flip) {
 		case 2:
 			err = i2c_write_demod_bytes(state,
 						    flip_2_lgdt3303_init_data,
@@ -296,10 +289,11 @@ static int lgdt330x_init(struct dvb_frontend *fe)
 		break;
 	default:
 		chip_name = "undefined";
-		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
+		dev_warn(&state->client->dev,
+			 "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
-	dprintk("Initialized the %s chip\n", chip_name);
+	dprintk(state, "Initialized the %s chip\n", chip_name);
 	if (err < 0)
 		return err;
 	return lgdt330x_sw_reset(state);
@@ -319,7 +313,7 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 
 	*ucblocks = 0;
 
-	switch (state->config->demod_chip) {
+	switch (state->config.demod_chip) {
 	case LGDT3302:
 		err = i2c_read_demod_bytes(state, LGDT3302_PACKET_ERR_COUNTER1,
 					   buf, sizeof(buf));
@@ -329,7 +323,8 @@ static int lgdt330x_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
 					   buf, sizeof(buf));
 		break;
 	default:
-		printk(KERN_WARNING "Only LGDT3302 and LGDT3303 are supported chips.\n");
+		dev_warn(&state->client->dev,
+			 "Only LGDT3302 and LGDT3303 are supported chips.\n");
 		err = -ENODEV;
 	}
 	if (err < 0)
@@ -382,16 +377,16 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 	if (state->current_modulation != p->modulation) {
 		switch (p->modulation) {
 		case VSB_8:
-			dprintk("VSB_8 MODE\n");
+			dprintk(state, "VSB_8 MODE\n");
 
 			/* Select VSB mode */
 			top_ctrl_cfg[1] = 0x03;
 
 			/* Select ANT connector if supported by card */
-			if (state->config->pll_rf_set)
-				state->config->pll_rf_set(fe, 1);
+			if (state->config.pll_rf_set)
+				state->config.pll_rf_set(fe, 1);
 
-			if (state->config->demod_chip == LGDT3303) {
+			if (state->config.demod_chip == LGDT3303) {
 				err = i2c_write_demod_bytes(state,
 							    lgdt3303_8vsb_44_data,
 							    sizeof(lgdt3303_8vsb_44_data));
@@ -399,16 +394,16 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			break;
 
 		case QAM_64:
-			dprintk("QAM_64 MODE\n");
+			dprintk(state, "QAM_64 MODE\n");
 
 			/* Select QAM_64 mode */
 			top_ctrl_cfg[1] = 0x00;
 
 			/* Select CABLE connector if supported by card */
-			if (state->config->pll_rf_set)
-				state->config->pll_rf_set(fe, 0);
+			if (state->config.pll_rf_set)
+				state->config.pll_rf_set(fe, 0);
 
-			if (state->config->demod_chip == LGDT3303) {
+			if (state->config.demod_chip == LGDT3303) {
 				err = i2c_write_demod_bytes(state,
 							    lgdt3303_qam_data,
 							    sizeof(lgdt3303_qam_data));
@@ -416,42 +411,44 @@ static int lgdt330x_set_parameters(struct dvb_frontend *fe)
 			break;
 
 		case QAM_256:
-			dprintk("QAM_256 MODE\n");
+			dprintk(state, "QAM_256 MODE\n");
 
 			/* Select QAM_256 mode */
 			top_ctrl_cfg[1] = 0x01;
 
 			/* Select CABLE connector if supported by card */
-			if (state->config->pll_rf_set)
-				state->config->pll_rf_set(fe, 0);
+			if (state->config.pll_rf_set)
+				state->config.pll_rf_set(fe, 0);
 
-			if (state->config->demod_chip == LGDT3303) {
+			if (state->config.demod_chip == LGDT3303) {
 				err = i2c_write_demod_bytes(state,
 							    lgdt3303_qam_data,
 							    sizeof(lgdt3303_qam_data));
 			}
 			break;
 		default:
-			pr_warn("%s: Modulation type(%d) UNSUPPORTED\n",
-				__func__, p->modulation);
+			dev_warn(&state->client->dev,
+				 "%s: Modulation type(%d) UNSUPPORTED\n",
+				 __func__, p->modulation);
 			return -1;
 		}
 		if (err < 0)
-			pr_warn("%s: error blasting bytes to lgdt3303 for modulation type(%d)\n",
-				__func__, p->modulation);
+			dev_warn(&state->client->dev,
+				 "%s: error blasting bytes to lgdt3303 for modulation type(%d)\n",
+				 __func__, p->modulation);
 
 		/*
 		 * select serial or parallel MPEG hardware interface
 		 * Serial:   0x04 for LGDT3302 or 0x40 for LGDT3303
 		 * Parallel: 0x00
 		 */
-		top_ctrl_cfg[1] |= state->config->serial_mpeg;
+		top_ctrl_cfg[1] |= state->config.serial_mpeg;
 
 		/* Select the requested mode */
 		i2c_write_demod_bytes(state, top_ctrl_cfg,
 				      sizeof(top_ctrl_cfg));
-		if (state->config->set_ts_params)
-			state->config->set_ts_params(fe, 0);
+		if (state->config.set_ts_params)
+			state->config.set_ts_params(fe, 0);
 		state->current_modulation = p->modulation;
 	}
 
@@ -492,7 +489,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* AGC status register */
 	i2c_read_demod_bytes(state, AGC_STATUS, buf, 1);
-	dprintk("AGC_STATUS = 0x%02x\n", buf[0]);
+	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
 	if ((buf[0] & 0x0c) == 0x8) {
 		/*
 		 * Test signal does not exist flag
@@ -509,7 +506,8 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* signal status */
 	i2c_read_demod_bytes(state, TOP_CONTROL, buf, sizeof(buf));
-	dprintk("TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
+	dprintk(state,
+		"TOP_CONTROL = 0x%02x, IRO_MASK = 0x%02x, IRQ_STATUS = 0x%02x\n",
 		buf[0], buf[1], buf[2]);
 
 	/* sync status */
@@ -524,7 +522,7 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("CARRIER_LOCK = 0x%02x\n", buf[0]);
+	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -537,8 +535,9 @@ static int lgdt3302_read_status(struct dvb_frontend *fe,
 			*status |= FE_HAS_CARRIER;
 		break;
 	default:
-		pr_warn("%s: Modulation set to unsupported value\n",
-			__func__);
+		dev_warn(&state->client->dev,
+			 "%s: Modulation set to unsupported value\n",
+			 __func__);
 	}
 
 	return 0;
@@ -558,7 +557,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 	if (err < 0)
 		return err;
 
-	dprintk("AGC_STATUS = 0x%02x\n", buf[0]);
+	dprintk(state, "AGC_STATUS = 0x%02x\n", buf[0]);
 	if ((buf[0] & 0x21) == 0x01) {
 		/*
 		 * Test input signal does not exist flag
@@ -569,7 +568,7 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 
 	/* Carrier Recovery Lock Status Register */
 	i2c_read_demod_bytes(state, CARRIER_LOCK, buf, 1);
-	dprintk("CARRIER_LOCK = 0x%02x\n", buf[0]);
+	dprintk(state, "CARRIER_LOCK = 0x%02x\n", buf[0]);
 	switch (state->current_modulation) {
 	case QAM_256:
 	case QAM_64:
@@ -600,8 +599,9 @@ static int lgdt3303_read_status(struct dvb_frontend *fe,
 		}
 		break;
 	default:
-		pr_warn("%s: Modulation set to unsupported value\n",
-			__func__);
+		dev_warn(&state->client->dev,
+			 "%s: Modulation set to unsupported value\n",
+			 __func__);
 	}
 	return 0;
 }
@@ -677,15 +677,16 @@ static int lgdt3302_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* log10(688128)*2^24 and log10(696320)*2^24 */
 		break;
 	default:
-		pr_err("%s: Modulation set to unsupported value\n",
-		       __func__);
+		dev_err(&state->client->dev,
+			"%s: Modulation set to unsupported value\n",
+			__func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("noise = 0x%08x, snr = %d.%02d dB\n", noise,
+	dprintk(state, "noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -721,15 +722,16 @@ static int lgdt3303_read_snr(struct dvb_frontend *fe, u16 *snr)
 		/* log10(688128)*2^24 and log10(696320)*2^24 */
 		break;
 	default:
-		pr_err("%s: Modulation set to unsupported value\n",
-		       __func__);
+		dev_err(&state->client->dev,
+			"%s: Modulation set to unsupported value\n",
+			__func__);
 		return -EREMOTEIO; /* return -EDRIVER_IS_GIBBERED; */
 	}
 
 	state->snr = calculate_snr(noise, c);
 	*snr = (state->snr) >> 16; /* Convert from 8.24 fixed-point to 8.8 */
 
-	dprintk("noise = 0x%08x, snr = %d.%02d dB\n", noise,
+	dprintk(state, "noise = 0x%08x, snr = %d.%02d dB\n", noise,
 		state->snr >> 24, (((state->snr >> 8) & 0xffff) * 100) >> 16);
 
 	return 0;
@@ -773,15 +775,27 @@ lgdt330x_get_tune_settings(struct dvb_frontend *fe,
 static void lgdt330x_release(struct dvb_frontend *fe)
 {
 	struct lgdt330x_state *state = fe->demodulator_priv;
+	struct i2c_client *client = state->client;
 
-	kfree(state);
+	dev_dbg(&client->dev, "\n");
+
+	i2c_unregister_device(client);
+}
+
+static struct dvb_frontend *lgdt330x_get_dvb_frontend(struct i2c_client *client)
+{
+	struct lgdt330x_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	return &state->frontend;
 }
 
 static const struct dvb_frontend_ops lgdt3302_ops;
 static const struct dvb_frontend_ops lgdt3303_ops;
 
-struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
-				     struct i2c_adapter *i2c)
+static int lgdt330x_probe(struct i2c_client *client,
+			  const struct i2c_device_id *id)
 {
 	struct lgdt330x_state *state = NULL;
 	u8 buf[1];
@@ -792,11 +806,13 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 		goto error;
 
 	/* Setup the state */
-	state->config = config;
-	state->i2c = i2c;
+	memcpy(&state->config, client->dev.platform_data,
+	       sizeof(state->config));
+	i2c_set_clientdata(client, state);
+	state->client = client;
 
 	/* Create dvb_frontend */
-	switch (config->demod_chip) {
+	switch (state->config.demod_chip) {
 	case LGDT3302:
 		memcpy(&state->frontend.ops, &lgdt3302_ops,
 		       sizeof(struct dvb_frontend_ops));
@@ -810,6 +826,9 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 	}
 	state->frontend.demodulator_priv = state;
 
+	/* Setup get frontend callback */
+	state->config.get_dvb_frontend = lgdt330x_get_dvb_frontend;
+
 	/* Verify communication with demod chip */
 	if (i2c_read_demod_bytes(state, 2, buf, 1))
 		goto error;
@@ -817,15 +836,33 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
 	state->current_frequency = -1;
 	state->current_modulation = -1;
 
-	pr_info("Demod loaded for LGDT330%s chip\n",
-		config->demod_chip == LGDT3302 ? "2" : "3");
+	dev_info(&state->client->dev,
+		"Demod loaded for LGDT330%s chip\n",
+		state->config.demod_chip == LGDT3302 ? "2" : "3");
 
-	return &state->frontend;
+	return 0;
 
 error:
 	kfree(state);
-	dprintk("ERROR\n");
-	return NULL;
+	dprintk(state, "ERROR\n");
+	return -ENODEV;
+}
+struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *_config,
+				     u8 demod_address,
+				     struct i2c_adapter *i2c)
+{
+	struct i2c_client *client;
+	struct i2c_board_info board_info = {};
+	struct lgdt330x_config config = *_config;
+
+	strlcpy(board_info.type, "lgdt330x", sizeof(board_info.type));
+	board_info.addr = demod_address;
+	board_info.platform_data = &config;
+	client = i2c_new_device(i2c, &board_info);
+	if (!client || !client->dev.driver)
+		return NULL;
+
+	return lgdt330x_get_dvb_frontend(client);
 }
 EXPORT_SYMBOL(lgdt330x_attach);
 
@@ -875,6 +912,36 @@ static const struct dvb_frontend_ops lgdt3303_ops = {
 	.release              = lgdt330x_release,
 };
 
+static int lgdt330x_remove(struct i2c_client *client)
+{
+	struct lgdt330x_state *state = i2c_get_clientdata(client);
+
+	dev_dbg(&client->dev, "\n");
+
+	kfree(state);
+
+	return 0;
+}
+
+static const struct i2c_device_id lgdt330x_id_table[] = {
+	{"lgdt330x", 0},
+	{}
+};
+MODULE_DEVICE_TABLE(i2c, lgdt330x_id_table);
+
+static struct i2c_driver lgdt330x_driver = {
+	.driver = {
+		.name	= "lgdt330x",
+		.suppress_bind_attrs = true,
+	},
+	.probe		= lgdt330x_probe,
+	.remove		= lgdt330x_remove,
+	.id_table	= lgdt330x_id_table,
+};
+
+module_i2c_driver(lgdt330x_driver);
+
+
 MODULE_DESCRIPTION("LGDT330X (ATSC 8VSB & ITU-T J.83 AnnexB 64/256 QAM) Demodulator Driver");
 MODULE_AUTHOR("Wilson Michaels");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/lgdt330x.h b/drivers/media/dvb-frontends/lgdt330x.h
index 18bd54eabca4..94cc09d15ece 100644
--- a/drivers/media/dvb-frontends/lgdt330x.h
+++ b/drivers/media/dvb-frontends/lgdt330x.h
@@ -29,7 +29,6 @@ typedef enum lg_chip_t {
 /**
  * struct lgdt330x_config - contains lgdt330x configuration
  *
- * @demod_address:	The demodulator's i2c address
  * @demod_chip:		LG demodulator chip LGDT3302 or LGDT3303
  * @serial_mpeg:	MPEG hardware interface - 0:parallel 1:serial
  * @pll_rf_set:		Callback function to set PLL interface
@@ -38,23 +37,30 @@ typedef enum lg_chip_t {
  *	Flip the polarity of the mpeg data transfer clock using alternate
  *	init data.
  *	This option applies ONLY to LGDT3303 - 0:disabled (default) 1:enabled
+ * @get_dvb_frontend:
+ *	returns the frontend associated with this I2C client.
+ *	Filled by the driver.
  */
 struct lgdt330x_config
 {
-	u8 demod_address;
 	lg_chip_type demod_chip;
 	int serial_mpeg;
 	int (*pll_rf_set) (struct dvb_frontend* fe, int index);
 	int (*set_ts_params)(struct dvb_frontend* fe, int is_punctured);
 	int clock_polarity_flip;
+
+	struct dvb_frontend* (*get_dvb_frontend)(struct i2c_client *);
 };
 
 #if IS_REACHABLE(CONFIG_DVB_LGDT330X)
-extern struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
-					    struct i2c_adapter* i2c);
+struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
+				     u8 demod_address,
+				     struct i2c_adapter *i2c);
 #else
-static inline struct dvb_frontend* lgdt330x_attach(const struct lgdt330x_config* config,
-					    struct i2c_adapter* i2c)
+static
+struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *config,
+				     u8 demod_address,
+				     struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index f60d69ac515b..5ef6e2051d45 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -575,7 +575,6 @@ static struct mt352_config digitv_alps_tded4_config = {
 };
 
 static struct lgdt330x_config tdvs_tua6034_config = {
-	.demod_address    = 0x0e,
 	.demod_chip       = LGDT3303,
 	.serial_mpeg      = 0x40, /* TPSERIAL for 3303 in TOP_CONTROL */
 };
@@ -614,7 +613,8 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 
 	case BTTV_BOARD_DVICO_FUSIONHDTV_5_LITE:
 		lgdt330x_reset(card);
-		card->fe = dvb_attach(lgdt330x_attach, &tdvs_tua6034_config, card->i2c_adapter);
+		card->fe = dvb_attach(lgdt330x_attach, &tdvs_tua6034_config,
+				      0x0e, card->i2c_adapter);
 		if (card->fe != NULL) {
 			dvb_attach(simple_tuner_attach, card->fe,
 				   card->i2c_adapter, 0x61,
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 7bb1febb1cb2..31dfe603fd9a 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -252,7 +252,6 @@ static struct mt2131_config hauppauge_generic_tunerconfig = {
 };
 
 static struct lgdt330x_config fusionhdtv_5_express = {
-	.demod_address = 0x0e,
 	.demod_chip = LGDT3303,
 	.serial_mpeg = 0x40,
 };
@@ -1321,8 +1320,9 @@ static int dvb_register(struct cx23885_tsport *port)
 	case CX23885_BOARD_DVICO_FUSIONHDTV_5_EXP:
 		i2c_bus = &dev->i2c_bus[0];
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
-						&fusionhdtv_5_express,
-						&i2c_bus->i2c_adap);
+					       &fusionhdtv_5_express,
+					       0x0e,
+					       &i2c_bus->i2c_adap);
 		if (fe0->dvb.frontend == NULL)
 			break;
 		dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index ec65eca713f9..99f1a069212a 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -411,21 +411,18 @@ static int lgdt330x_set_ts_param(struct dvb_frontend *fe, int is_punctured)
 }
 
 static struct lgdt330x_config fusionhdtv_3_gold = {
-	.demod_address = 0x0e,
 	.demod_chip    = LGDT3302,
 	.serial_mpeg   = 0x04, /* TPSERIAL for 3302 in TOP_CONTROL */
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
 static const struct lgdt330x_config fusionhdtv_5_gold = {
-	.demod_address = 0x0e,
 	.demod_chip    = LGDT3303,
 	.serial_mpeg   = 0x40, /* TPSERIAL for 3303 in TOP_CONTROL */
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
 static const struct lgdt330x_config pchdtv_hd5500 = {
-	.demod_address = 0x59,
 	.demod_chip    = LGDT3303,
 	.serial_mpeg   = 0x40, /* TPSERIAL for 3303 in TOP_CONTROL */
 	.set_ts_params = lgdt330x_set_ts_param,
@@ -1237,6 +1234,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		fusionhdtv_3_gold.pll_rf_set = lgdt330x_pll_rf_set;
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
+					       0x0e,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
@@ -1255,6 +1253,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		mdelay(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_3_gold,
+					       0x0e,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
@@ -1273,6 +1272,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		mdelay(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &fusionhdtv_5_gold,
+					       0x0e,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
@@ -1294,6 +1294,7 @@ static int dvb_register(struct cx8802_dev *dev)
 		mdelay(200);
 		fe0->dvb.frontend = dvb_attach(lgdt330x_attach,
 					       &pchdtv_hd5500,
+					       0x59,
 					       &core->i2c_adap);
 		if (fe0->dvb.frontend) {
 			if (!dvb_attach(simple_tuner_attach, fe0->dvb.frontend,
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 65fc8f23ad86..594990c0d2b8 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -721,7 +721,6 @@ static int cineS2_probe(struct ngene_channel *chan)
 
 
 static struct lgdt330x_config aver_m780 = {
-	.demod_address = 0xb2 >> 1,
 	.demod_chip    = LGDT3303,
 	.serial_mpeg   = 0x00, /* PARALLEL */
 	.clock_polarity_flip = 1,
@@ -738,7 +737,8 @@ static int demod_attach_lg330x(struct ngene_channel *chan)
 {
 	struct device *pdev = &chan->dev->pci_dev->dev;
 
-	chan->fe = dvb_attach(lgdt330x_attach, &aver_m780, &chan->i2c_adapter);
+	chan->fe = dvb_attach(lgdt330x_attach, &aver_m780,
+			      0xb2 >> 1, &chan->i2c_adapter);
 	if (chan->fe == NULL) {
 		dev_err(pdev, "No LGDT330x found!\n");
 		return -ENODEV;
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 387a074ea6ec..ae5f11a2b5b2 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -540,12 +540,10 @@ static struct cx22702_config cxusb_cx22702_config = {
 };
 
 static struct lgdt330x_config cxusb_lgdt3303_config = {
-	.demod_address = 0x0e,
 	.demod_chip    = LGDT3303,
 };
 
 static struct lgdt330x_config cxusb_aver_lgdt3303_config = {
-	.demod_address       = 0x0e,
 	.demod_chip          = LGDT3303,
 	.clock_polarity_flip = 2,
 };
@@ -763,6 +761,7 @@ static int cxusb_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 
 	adap->fe_adap[0].fe = dvb_attach(lgdt330x_attach,
 					 &cxusb_lgdt3303_config,
+					 0x0e,
 					 &adap->dev->i2c_adap);
 	if ((adap->fe_adap[0].fe) != NULL)
 		return 0;
@@ -772,8 +771,10 @@ static int cxusb_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 
 static int cxusb_aver_lgdt3303_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	adap->fe_adap[0].fe = dvb_attach(lgdt330x_attach, &cxusb_aver_lgdt3303_config,
-			      &adap->dev->i2c_adap);
+	adap->fe_adap[0].fe = dvb_attach(lgdt330x_attach,
+					 &cxusb_aver_lgdt3303_config,
+					 0x0e,
+				         &adap->dev->i2c_adap);
 	if (adap->fe_adap[0].fe != NULL)
 		return 0;
 
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 2ce7de1c7cce..8fe71ae9baf7 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -300,7 +300,6 @@ static int em28xx_dvb_bus_ctrl(struct dvb_frontend *fe, int acquire)
 /* ------------------------------------------------------------------ */
 
 static struct lgdt330x_config em2880_lgdt3303_dev = {
-	.demod_address = 0x0e,
 	.demod_chip = LGDT3303,
 };
 
@@ -1472,6 +1471,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
 					&em2880_lgdt3303_dev,
+					0x0e,
 					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (em28xx_attach_xc3028(0x61, dev) < 0) {
 			result = -EINVAL;
@@ -1552,6 +1552,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	case EM2882_BOARD_KWORLD_ATSC_315U:
 		dvb->fe[0] = dvb_attach(lgdt330x_attach,
 					&em2880_lgdt3303_dev,
+					0x0e,
 					&dev->i2c_adap[dev->def_i2c_bus]);
 		if (dvb->fe[0]) {
 			if (!dvb_attach(simple_tuner_attach, dvb->fe[0],
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
index 71537097c13f..06de1c83f444 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-devattr.c
@@ -182,7 +182,6 @@ static const struct pvr2_device_desc pvr2_device_av400 = {
 
 #ifdef CONFIG_VIDEO_PVRUSB2_DVB
 static struct lgdt330x_config pvr2_lgdt3303_config = {
-	.demod_address       = 0x0e,
 	.demod_chip          = LGDT3303,
 	.clock_polarity_flip = 1,
 };
@@ -190,6 +189,7 @@ static struct lgdt330x_config pvr2_lgdt3303_config = {
 static int pvr2_lgdt3303_attach(struct pvr2_dvb_adapter *adap)
 {
 	adap->fe = dvb_attach(lgdt330x_attach, &pvr2_lgdt3303_config,
+			      0x0e,
 			      &adap->channel.hdw->i2c_adap);
 	if (adap->fe)
 		return 0;
@@ -243,13 +243,13 @@ static const struct pvr2_device_desc pvr2_device_onair_creator = {
 
 #ifdef CONFIG_VIDEO_PVRUSB2_DVB
 static struct lgdt330x_config pvr2_lgdt3302_config = {
-	.demod_address       = 0x0e,
 	.demod_chip          = LGDT3302,
 };
 
 static int pvr2_lgdt3302_attach(struct pvr2_dvb_adapter *adap)
 {
 	adap->fe = dvb_attach(lgdt330x_attach, &pvr2_lgdt3302_config,
+			      0x0e,
 			      &adap->channel.hdw->i2c_adap);
 	if (adap->fe)
 		return 0;
-- 
2.14.3
