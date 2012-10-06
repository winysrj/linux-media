Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab2JFOtw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Oct 2012 10:49:52 -0400
Date: Sat, 6 Oct 2012 11:49:41 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Fw: [PATCH] v4 Add support to Avermedia Twinstar double tuner in
 af9035
Message-ID: <20121006114941.7ec4c6ad@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antti,

Please review.

Thanks!
Mauro

Forwarded message:

Date: Sun, 23 Sep 2012 21:48:47 +0200
From: Jose Alberto Reguero <jareguero@telefonica.net>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] v4 Add support to Avermedia Twinstar double tuner in af9035


This patch add support to the Avermedia Twinstar double tuner in the af9035
driver. Version 4 of the patch. I split the patch as suggested by Antti. I send
the changes to mxl5007 driver in another patch.

Signed-off-by: Jose Alberto Reguero <jareguero@telefonica.net>

Jose Alberto

diff -upr linux/drivers/media/dvb-frontends/af9033.c linux.new/drivers/media/dvb-frontends/af9033.c
--- linux/drivers/media/dvb-frontends/af9033.c	2012-08-14 05:45:22.000000000 +0200
+++ linux.new/drivers/media/dvb-frontends/af9033.c	2012-09-13 22:22:29.012301231 +0200
@@ -326,6 +326,18 @@ static int af9033_init(struct dvb_fronte
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
diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.c linux.new/drivers/media/usb/dvb-usb-v2/af9035.c
--- linux/drivers/media/usb/dvb-usb-v2/af9035.c	2012-08-16 05:45:24.000000000 +0200
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.c	2012-09-23 21:32:10.313657063 +0200
@@ -209,10 +209,14 @@ static int af9035_i2c_master_xfer(struct
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
@@ -220,8 +224,9 @@ static int af9035_i2c_master_xfer(struct
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
@@ -232,10 +237,14 @@ static int af9035_i2c_master_xfer(struct
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
@@ -243,8 +252,9 @@ static int af9035_i2c_master_xfer(struct
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
@@ -283,9 +293,30 @@ static int af9035_identify_state(struct 
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
@@ -492,7 +523,14 @@ static int af9035_read_config(struct dvb
 
 	state->dual_mode = tmp;
 	pr_debug("%s: dual mode=%d\n", __func__, state->dual_mode);
-
+	if (state->dual_mode) {
+		/* read 2nd demodulator I2C address */
+		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
+		if (ret < 0)
+			goto err;
+		state->af9033_config[1].i2c_addr = tmp;
+		pr_debug("%s: 2nd demod I2C addr:%02x\n", __func__, tmp);
+	}
 	for (i = 0; i < state->dual_mode + 1; i++) {
 		/* tuner */
 		ret = af9035_rd_reg(d, EEPROM_1_TUNER_ID + eeprom_shift, &tmp);
@@ -671,6 +709,12 @@ static int af9035_frontend_callback(void
 	return -EINVAL;
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
@@ -726,13 +770,22 @@ static const struct fc0011_config af9035
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
@@ -795,46 +848,52 @@ static int af9035_tuner_attach(struct dv
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
@@ -879,8 +938,8 @@ static int af9035_init(struct dvb_usb_de
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
@@ -1001,7 +1060,7 @@ static const struct dvb_usb_device_prope
 	.init = af9035_init,
 	.get_rc_config = af9035_get_rc_config,
 
-	.num_adapters = 1,
+	.get_adapter_count = af9035_get_adapter_count,
 	.adapter = {
 		{
 			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
diff -upr linux/drivers/media/usb/dvb-usb-v2/af9035.h linux.new/drivers/media/usb/dvb-usb-v2/af9035.h
--- linux/drivers/media/usb/dvb-usb-v2/af9035.h	2012-08-14 05:45:22.000000000 +0200
+++ linux.new/drivers/media/usb/dvb-usb-v2/af9035.h	2012-09-23 21:29:45.608466128 +0200
@@ -54,6 +54,8 @@ struct state {
 	bool dual_mode;
 
 	struct af9033_config af9033_config[2];
+
+	u8 tuner_address[2];
 };
 
 u32 clock_lut[] = {
@@ -87,6 +89,7 @@ u32 clock_lut_it9135[] = {
 /* EEPROM locations */
 #define EEPROM_IR_MODE            0x430d
 #define EEPROM_DUAL_MODE          0x4326
+#define EEPROM_2WIREADDR          0x4327
 #define EEPROM_IR_TYPE            0x4329
 #define EEPROM_1_IFFREQ_L         0x432d
 #define EEPROM_1_IFFREQ_H         0x432e

--
To unsubscribe from this list: send the line "unsubscribe linux-media" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
