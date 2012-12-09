Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:38993 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758870Ab2LIT5M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Dec 2012 14:57:12 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: =?y?q?=5BPATCH=20RFC=2004/17=5D=20af9035=3A=20dual=20mode=20related=20changes?=
Date: Sun,  9 Dec 2012 21:56:15 +0200
Message-Id: <1355082988-6211-4-git-send-email-crope@iki.fi>
In-Reply-To: <1355082988-6211-1-git-send-email-crope@iki.fi>
References: <1355082988-6211-1-git-send-email-crope@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Various small changes and fixes releated to dual mode.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-frontends/af9033.c  |   2 +
 drivers/media/usb/dvb-usb-v2/af9035.c | 140 +++++++++++++++++++++++-----------
 drivers/media/usb/dvb-usb-v2/af9035.h |   5 +-
 3 files changed, 99 insertions(+), 48 deletions(-)

diff --git a/drivers/media/dvb-frontends/af9033.c b/drivers/media/dvb-frontends/af9033.c
index 745d2fa..c9cad98 100644
--- a/drivers/media/dvb-frontends/af9033.c
+++ b/drivers/media/dvb-frontends/af9033.c
@@ -339,9 +339,11 @@ static int af9033_init(struct dvb_frontend *fe)
 		ret = af9033_wr_reg_mask(state, 0x00d91c, 0x01, 0x01);
 		if (ret < 0)
 			goto err;
+
 		ret = af9033_wr_reg_mask(state, 0x00d917, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
+
 		ret = af9033_wr_reg_mask(state, 0x00d916, 0x00, 0x01);
 		if (ret < 0)
 			goto err;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 15625eb..d1beb7f 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -211,12 +211,13 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
 			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
-			/* integrated demod */
+			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
-			if (state->af9033_config[1].i2c_addr &&
-			   (msg[0].addr == state->af9033_config[1].i2c_addr))
+
+			if (msg[0].addr == state->af9033_config[1].i2c_addr)
 				reg |= 0x100000;
+
 			ret = af9035_rd_regs(d, reg, &msg[1].buf[0],
 					msg[1].len);
 		} else {
@@ -226,7 +227,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 					buf, msg[1].len, msg[1].buf };
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[1].len;
-			buf[1] = (u8)(msg[0].addr << 1);
+			buf[1] = msg[0].addr << 1;
 			buf[2] = 0x00; /* reg addr len */
 			buf[3] = 0x00; /* reg addr MSB */
 			buf[4] = 0x00; /* reg addr LSB */
@@ -239,12 +240,13 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 			ret = -EOPNOTSUPP;
 		} else if ((msg[0].addr == state->af9033_config[0].i2c_addr) ||
 			   (msg[0].addr == state->af9033_config[1].i2c_addr)) {
-			/* integrated demod */
+			/* demod access via firmware interface */
 			u32 reg = msg[0].buf[0] << 16 | msg[0].buf[1] << 8 |
 					msg[0].buf[2];
-			if (state->af9033_config[1].i2c_addr &&
-			   (msg[0].addr == state->af9033_config[1].i2c_addr))
+
+			if (msg[0].addr == state->af9033_config[1].i2c_addr)
 				reg |= 0x100000;
+
 			ret = af9035_wr_regs(d, reg, &msg[0].buf[3],
 					msg[0].len - 3);
 		} else {
@@ -254,7 +256,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
 					0, NULL };
 			req.mbox |= ((msg[0].addr & 0x80)  >>  3);
 			buf[0] = msg[0].len;
-			buf[1] = (u8)(msg[0].addr << 1);
+			buf[1] = msg[0].addr << 1;
 			buf[2] = 0x00; /* reg addr len */
 			buf[3] = 0x00; /* reg addr MSB */
 			buf[4] = 0x00; /* reg addr LSB */
@@ -293,30 +295,9 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	int ret;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
-	u8 tmp;
 	struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
 			sizeof(rbuf), rbuf };
 
-	/* check if there is dual tuners */
-	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
-	if (ret < 0)
-		goto err;
-
-	if (tmp) {
-		/* read 2nd demodulator I2C address */
-		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg(d, 0x00417f, tmp);
-		if (ret < 0)
-			goto err;
-
-		ret = af9035_wr_reg(d, 0x00d81a, 1);
-		if (ret < 0)
-			goto err;
-	}
-
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret < 0)
 		goto err;
@@ -344,12 +325,57 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
 	struct usb_req req_fw_dl = { CMD_FW_DL, 0, 0, wbuf, 0, NULL };
 	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf } ;
-	u8 hdr_core;
+	u8 hdr_core, tmp;
 	u16 hdr_addr, hdr_data_len, hdr_checksum;
 	#define MAX_DATA 58
 	#define HDR_SIZE 7
 
 	/*
+	 * In case of dual tuner configuration we need to do some extra
+	 * initialization in order to download firmware to slave demod too,
+	 * which is done by master demod.
+	 * Master feeds also clock and controls power via GPIO.
+	 */
+	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
+	if (ret < 0)
+		goto err;
+
+	if (tmp) {
+		/* configure gpioh1, reset & power slave demod */
+		ret = af9035_wr_reg_mask(d, 0x00d8b0, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8b1, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x00, 0x01);
+		if (ret < 0)
+			goto err;
+
+		usleep_range(10000, 50000);
+
+		ret = af9035_wr_reg_mask(d, 0x00d8af, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+
+		/* tell the slave I2C address */
+		ret = af9035_rd_reg(d, EEPROM_2ND_DEMOD_ADDR, &tmp);
+		if (ret < 0)
+			goto err;
+
+		ret = af9035_wr_reg(d, 0x00417f, tmp);
+		if (ret < 0)
+			goto err;
+
+		/* enable clock out */
+		ret = af9035_wr_reg_mask(d, 0x00d81a, 0x01, 0x01);
+		if (ret < 0)
+			goto err;
+	}
+
+	/*
 	 * Thanks to Daniel Glöckner <daniel-gl@gmx.net> about that info!
 	 *
 	 * byte 0: MCS 51 core
@@ -520,22 +546,27 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	u8 tmp;
 	u16 tmp16;
 
+	/* demod I2C "address" */
+	state->af9033_config[0].i2c_addr = 0x38;
+
 	/* check if there is dual tuners */
 	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
 	state->dual_mode = tmp;
-	dev_dbg(&d->udev->dev, "%s: dual mode=%d\n",
-			__func__, state->dual_mode);
+	dev_dbg(&d->udev->dev, "%s: dual mode=%d\n", __func__,
+			state->dual_mode);
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
-		ret = af9035_rd_reg(d, EEPROM_2WIREADDR, &tmp);
+		ret = af9035_rd_reg(d, EEPROM_2ND_DEMOD_ADDR, &tmp);
 		if (ret < 0)
 			goto err;
+
 		state->af9033_config[1].i2c_addr = tmp;
-		pr_debug("%s: 2nd demod I2C addr:%02x\n", __func__, tmp);
+		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
+				__func__, tmp);
 	}
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
@@ -563,6 +594,16 @@ static int af9035_read_config(struct dvb_usb_device *d)
 					KBUILD_MODNAME, tmp);
 		}
 
+		/* disable dual mode if driver does not support it */
+		if (i == 1)
+			switch (tmp) {
+			default:
+				state->dual_mode = false;
+				dev_info(&d->udev->dev, "%s: driver does not " \
+						"support 2nd tuner and will " \
+						"disable it", KBUILD_MODNAME);
+		}
+
 		/* tuner IF frequency */
 		ret = af9035_rd_reg(d, EEPROM_1_IFFREQ_L + eeprom_shift, &tmp);
 		if (ret < 0)
@@ -798,15 +839,14 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 		if (ret < 0)
 			goto err;
 
-		ret = af9035_wr_reg(d, 0x00d81a,
-				state->dual_mode);
+		ret = af9035_wr_reg(d, 0x00d81a, state->dual_mode);
 		if (ret < 0)
 			goto err;
 	}
 
 	/* attach demodulator */
-	adap->fe[0] = dvb_attach(af9033_attach,
-			&state->af9033_config[adap->id], &d->i2c_adap);
+	adap->fe[0] = dvb_attach(af9033_attach, &state->af9033_config[adap->id],
+			&d->i2c_adap);
 	if (adap->fe[0] == NULL) {
 		ret = -ENODEV;
 		goto err;
@@ -866,6 +906,11 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
 	struct dvb_frontend *fe;
+	u8 tuner_addr;
+	/*
+	 * XXX: Hack used in that function: we abuse unused I2C address bit [7]
+	 * to carry info about used I2C bus for dual tuner configuration.
+	 */
 
 	switch (state->af9033_config[adap->id].tuner) {
 	case AF9033_TUNER_TUA9001:
@@ -898,16 +943,15 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 				&d->i2c_adap, &af9035_fc0011_config);
 		break;
 	case AF9033_TUNER_MXL5007T:
-		state->tuner_address[adap->id] = 0x60;
-		/* hack, use b[7] to carry used I2C-bus */
-		state->tuner_address[adap->id] |= (adap->id << 7);
 		if (adap->id == 0) {
 			ret = af9035_wr_reg(d, 0x00d8e0, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8e1, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8df, 0);
 			if (ret < 0)
 				goto err;
@@ -923,27 +967,35 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 			ret = af9035_wr_reg(d, 0x00d8c0, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8c1, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8bf, 0);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8b4, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8b5, 1);
 			if (ret < 0)
 				goto err;
+
 			ret = af9035_wr_reg(d, 0x00d8b3, 1);
 			if (ret < 0)
 				goto err;
+
+			tuner_addr = 0x60;
+		} else {
+			tuner_addr = 0x60 | 0x80; /* I2C bus hack */
 		}
 
 		/* attach tuner */
-		fe = dvb_attach(mxl5007t_attach, adap->fe[0],
-				&d->i2c_adap, state->tuner_address[adap->id],
-				&af9035_mxl5007t_config[adap->id]);
+		fe = dvb_attach(mxl5007t_attach, adap->fe[0], &d->i2c_adap,
+				tuner_addr, &af9035_mxl5007t_config[adap->id]);
 		break;
 	case AF9033_TUNER_TDA18218:
 		/* attach tuner */
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index e26e04d..29f3eec 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -54,10 +54,7 @@ struct usb_req {
 struct state {
 	u8 seq; /* packet sequence number */
 	bool dual_mode;
-
 	struct af9033_config af9033_config[2];
-
-	u8 tuner_address[2];
 };
 
 u32 clock_lut[] = {
@@ -94,7 +91,7 @@ u32 clock_lut_it9135[] = {
 /* EEPROM locations */
 #define EEPROM_IR_MODE            0x430d
 #define EEPROM_DUAL_MODE          0x4326
-#define EEPROM_2WIREADDR          0x4327
+#define EEPROM_2ND_DEMOD_ADDR     0x4327
 #define EEPROM_IR_TYPE            0x4329
 #define EEPROM_1_IFFREQ_L         0x432d
 #define EEPROM_1_IFFREQ_H         0x432e
-- 
1.7.11.7

