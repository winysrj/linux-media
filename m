Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758854Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC 03/17] af9035: dual mode support
Date: Sun,  9 Dec 2012 21:56:14 +0200
Message-Id: <1355082988-6211-3-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jose Alberto Reguero <jareguero@telefonica.net>

Adds initial support for af9035 dual mode designs.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>
[crope@iki.fi: fix merge conflict]
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c  |  12 +++
 drivers/media/usb/dvb-usb-v2/af9035.c | 155 +++++++++++++++++++++++-----------
 drivers/media/usb/dvb-usb-v2/af9035.h |   3 +
 3 files changed, 123 insertions(+), 47 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 27638a9..745d2fa 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -335,6 +335,18 @@ static int af9033_init(struct dvb_frontend *fe)
 			goto err;
 	}
 
+	if (state->cfg.ts_mode == AF9033_TS_MODE_SERIAL) {
+		ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+		ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
+		if (ret < 0)
+			goto err;
+		ret = af9033_wr_reg_mask(state, 0x00d916, 0x00, 0x01);
+		if (ret < 0)
+			goto err;
+	}
+
 	state->bandwidth_hz = 0; /* force to program all parameters */
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index c1ec18c..15625eb 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -209,10 +209,14 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40 || msg[1].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
-		} else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
+		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
+			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
 			/* integrated demod */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
+			if (state->af9033_config[1].i2c_addr &&
+			   (msg[0].addr == state->af9033_config[1].i2c_addr))
+				reg |= 0x100000;
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
 					msg[1].len);
 		} else {
@@ -220,8 +224,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			u8 buf[5 + msg[0].len];
 			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
 					buf, msg[1].len, msg[1].buf };
+			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
-			buf[1] = msg[0].addr << 1;
+			buf[1] = (u8)(msg[0].addr << 1);
 			buf[2] = 0x00; /* reg addr len */
 			buf[3] = 0x00; /* reg addr MSB */
 			buf[4] = 0x00; /* reg addr LSB */
@@ -232,10 +237,14 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 		if (msg[0].len > 40) {
 			/* TODO: correct limits > 40 */
 			ret = -EOPNOTSUPP;
-		} else if (msg[0].addr == state->af9033_config[0].i2c_addr) {
+		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
+			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
 			/* integrated demod */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
+			if (state->af9033_config[1].i2c_addr &&
+			   (msg[0].addr == state->af9033_config[1].i2c_addr))
+				reg |= 0x100000;
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
 					msg[0].len - 3);
 		} else {
@@ -243,8 +252,9 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			u8 buf[5 + msg[0].len];
 			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
 					0, NULL };
+			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
-			buf[1] = msg[0].addr << 1;
+			buf[1] = (u8)(msg[0].addr << 1);
 			buf[2] = 0x00; /* reg addr len */
 			buf[3] = 0x00; /* reg addr MSB */
 			buf[4] = 0x00; /* reg addr LSB */
@@ -283,9 +293,30 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	int ret;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
+	u8 tmp;
 	struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
 			sizeof(rbuf), rbuf };
 
+	/* check if there is dual tuners */
+	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
+	if (ret < 0)
+		goto err;
+
+	if (tmp) {
+		/* read 2nd demodulator I2C address */
+		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg(d, 0x00417f, tmp);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg(d, 0x00d81a, 1);
+		if (ret < 0)
+			goto err;
+	}
+
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret < 0)
 		goto err;
@@ -498,6 +529,15 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	dev_dbg(&d->udev->dev, "%s: dual mode=%d\n",
 			__func__, state->dual_mode);
 
+	if (state->dual_mode) {
+		/* read 2nd demodulator I2C address */
+		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
+		if (ret < 0)
+			goto err;
+		state->af9033_config[1].i2c_addr = tmp;
+		pr_debug("%s: 2nd demod I2C addr:%02x\n", __func__, tmp);
+	}
+
 	for (i = 0; i < state->dual_mode + 1; i++) {
 		/* tuner */
 		ret = af9035_rd_reg(d, EEPROM_1_TUNER_ID + eeprom_shift, &tmp);
@@ -731,6 +771,12 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 	return 0;
 }
 
+static int af9035_get_adapter_count(struct dvb_usb_device *d)
+{
+	struct state *state = d_to_priv(d);
+	return state->dual_mode + 1;
+}
+
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
@@ -786,13 +832,22 @@ static const struct fc0011_config af9035_fc0011_config = {
 	.i2c_address = 0x60,
 };
 
-static struct mxl5007t_config af9035_mxl5007t_config = {
-	.xtal_freq_hz = MxL_XTAL_24_MHZ,
-	.if_freq_hz = MxL_IF_4_57_MHZ,
-	.invert_if = 0,
-	.loop_thru_enable = 0,
-	.clk_out_enable = 0,
-	.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+static struct mxl5007t_config af9035_mxl5007t_config[] = {
+	{
+		.xtal_freq_hz = MxL_XTAL_24_MHZ,
+		.if_freq_hz = MxL_IF_4_57_MHZ,
+		.invert_if = 0,
+		.loop_thru_enable = 0,
+		.clk_out_enable = 0,
+		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+	}, {
+		.xtal_freq_hz = MxL_XTAL_24_MHZ,
+		.if_freq_hz = MxL_IF_4_57_MHZ,
+		.invert_if = 0,
+		.loop_thru_enable = 1,
+		.clk_out_enable = 1,
+		.clk_out_amp = MxL_CLKOUT_AMP_0_94V,
+	}
 };
 
 static struct tda18218_config af9035_tda18218_config = {
@@ -843,46 +898,52 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 				&d->i2c_adap, &af9035_fc0011_config);
 		break;
 	case AF9033_TUNER_MXL5007T:
-		ret = af9035_wr_reg(d, 0x00d8e0, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8e1, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8df, 0);
-		if (ret < 0)
-			goto err;
+		state->tuner_address[adap->id] = 0x60;
+		/* hack, use b[7] to carry used I2C-bus */
+		state->tuner_address[adap->id] |= (adap->id << 7);
+		if (adap->id == 0) {
+			ret = af9035_wr_reg(d, 0x00d8e0, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8e1, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8df, 0);
+			if (ret < 0)
+				goto err;
 
-		msleep(30);
+			msleep(30);
 
-		ret = af9035_wr_reg(d, 0x00d8df, 1);
-		if (ret < 0)
-			goto err;
+			ret = af9035_wr_reg(d, 0x00d8df, 1);
+			if (ret < 0)
+				goto err;
 
-		msleep(300);
+			msleep(300);
 
-		ret = af9035_wr_reg(d, 0x00d8c0, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8c1, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8bf, 0);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8b4, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8b5, 1);
-		if (ret < 0)
-			goto err;
-		ret = af9035_wr_reg(d, 0x00d8b3, 1);
-		if (ret < 0)
-			goto err;
+			ret = af9035_wr_reg(d, 0x00d8c0, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8c1, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8bf, 0);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8b4, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8b5, 1);
+			if (ret < 0)
+				goto err;
+			ret = af9035_wr_reg(d, 0x00d8b3, 1);
+			if (ret < 0)
+				goto err;
+		}
 
 		/* attach tuner */
 		fe = dvb_attach(mxl5007t_attach, adap->fe[0],
-				&d->i2c_adap, 0x60, &af9035_mxl5007t_config);
+				&d->i2c_adap, state->tuner_address[adap->id],
+				&af9035_mxl5007t_config[adap->id]);
 		break;
 	case AF9033_TUNER_TDA18218:
 		/* attach tuner */
@@ -971,8 +1032,8 @@ static int af9035_init(struct dvb_usb_device *d)
 		{ 0x00dd8a, (frame_size >> 0) & 0xff, 0xff},
 		{ 0x00dd8b, (frame_size >> 8) & 0xff, 0xff},
 		{ 0x00dd0d, packet_size, 0xff },
-		{ 0x80f9a3, 0x00, 0x01 },
-		{ 0x80f9cd, 0x00, 0x01 },
+		{ 0x80f9a3, state->dual_mode, 0x01 },
+		{ 0x80f9cd, state->dual_mode, 0x01 },
 		{ 0x80f99d, 0x00, 0x01 },
 		{ 0x80f9a4, 0x00, 0x01 },
 	};
@@ -1094,7 +1155,7 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.init = af9035_init,
 	.get_rc_config = af9035_get_rc_config,
 
-	.num_adapters = 1,
+	.get_adapter_count = af9035_get_adapter_count,
 	.adapter = {
 		{
 			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index f509d35..e26e04d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -56,6 +56,8 @@ struct state {
 	bool dual_mode;
 
 	struct af9033_config af9033_config[2];
+
+	u8 tuner_address[2];
 };
 
 u32 clock_lut[] = {
@@ -92,6 +94,7 @@ u32 clock_lut_it9135[] = {
 /* EEPROM locations */
 #define EEPROM_IR_MODE            0x430d
 #define EEPROM_DUAL_MODE          0x4326
+#define EEPROM_2WIREADDR          0x4327
 #define EEPROM_IR_TYPE            0x4329
 #define EEPROM_1_IFFREQ_L         0x432d
 #define EEPROM_1_IFFREQ_H         0x432e
-- 
1.7.11.7

