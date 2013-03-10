Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52842 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774Ab3CJCEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:39 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 10/41] af9035: merge af9035 and it9135 eeprom read routines
Date: Sun, 10 Mar 2013 04:03:02 +0200
Message-Id: <1362881013-5271-10-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 139 ++++++++++++++--------------------
 drivers/media/usb/dvb-usb-v2/af9035.h |  27 ++++---
 2 files changed, 73 insertions(+), 93 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 42ed0f7..a1e953a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -362,7 +362,7 @@ static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
 	 * which is done by master demod.
 	 * Master feeds also clock and controls power via GPIO.
 	 */
-	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
+	ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_DUAL_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -387,7 +387,9 @@ static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
 			goto err;
 
 		/* tell the slave I2C address */
-		ret = af9035_rd_reg(d, EEPROM_2ND_DEMOD_ADDR, &tmp);
+		ret = af9035_rd_reg(d,
+				EEPROM_BASE_AF9035 + EEPROM_2ND_DEMOD_ADDR,
+				&tmp);
 		if (ret < 0)
 			goto err;
 
@@ -580,19 +582,39 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		return af9035_download_firmware_af9035(d, fw);
 }
 
-static int af9035_read_config_af9035(struct dvb_usb_device *d)
+static int af9035_read_config(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
-	int ret, i, eeprom_shift = 0;
+	int ret, i;
 	u8 tmp;
-	u16 tmp16;
+	u16 tmp16, addr;
 
 	/* demod I2C "address" */
 	state->af9033_config[0].i2c_addr = 0x38;
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 
+	/* eeprom memory mapped location */
+	if (state->chip_type == 0x9135) {
+		/* check if eeprom exists */
+		if (state->chip_version == 2)
+			ret = af9035_rd_reg(d, 0x00461d, &tmp);
+		else
+			ret = af9035_rd_reg(d, 0x00461b, &tmp);
+		if (ret < 0)
+			goto err;
+
+		if (tmp) {
+			addr = EEPROM_BASE_IT9135;
+		} else {
+			state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
+			goto skip_eeprom;
+		}
+	} else {
+		addr = EEPROM_BASE_AF9035;
+	}
+
 	/* check if there is dual tuners */
-	ret = af9035_rd_reg(d, EEPROM_DUAL_MODE, &tmp);
+	ret = af9035_rd_reg(d, addr + EEPROM_DUAL_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -602,7 +624,7 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
-		ret = af9035_rd_reg(d, EEPROM_2ND_DEMOD_ADDR, &tmp);
+		ret = af9035_rd_reg(d, addr + EEPROM_2ND_DEMOD_ADDR, &tmp);
 		if (ret < 0)
 			goto err;
 
@@ -613,7 +635,7 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 
 	for (i = 0; i < state->dual_mode + 1; i++) {
 		/* tuner */
-		ret = af9035_rd_reg(d, EEPROM_1_TUNER_ID + eeprom_shift, &tmp);
+		ret = af9035_rd_reg(d, addr + EEPROM_1_TUNER_ID, &tmp);
 		if (ret < 0)
 			goto err;
 
@@ -621,7 +643,10 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
 				__func__, i, tmp);
 
-		switch (tmp) {
+		if (state->chip_type == 0x9135 && tmp == 0x00)
+			state->af9033_config[i].tuner = AF9033_TUNER_IT9135_38;
+
+		switch (state->af9033_config[i].tuner) {
 		case AF9033_TUNER_TUA9001:
 		case AF9033_TUNER_FC0011:
 		case AF9033_TUNER_MXL5007T:
@@ -630,9 +655,16 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 		case AF9033_TUNER_FC0012:
 			state->af9033_config[i].spec_inv = 1;
 			break;
+		case AF9033_TUNER_IT9135_38:
+		case AF9033_TUNER_IT9135_51:
+		case AF9033_TUNER_IT9135_52:
+		case AF9033_TUNER_IT9135_60:
+		case AF9033_TUNER_IT9135_61:
+		case AF9033_TUNER_IT9135_62:
+			break;
 		default:
-			dev_warn(&d->udev->dev, "%s: tuner id=%02x not " \
-					"supported, please report!",
+			dev_warn(&d->udev->dev,
+					"%s: tuner id=%02x not supported, please report!",
 					KBUILD_MODNAME, tmp);
 		}
 
@@ -643,19 +675,19 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 				break;
 			default:
 				state->dual_mode = false;
-				dev_info(&d->udev->dev, "%s: driver does not " \
-						"support 2nd tuner and will " \
-						"disable it", KBUILD_MODNAME);
+				dev_info(&d->udev->dev,
+						"%s: driver does not support 2nd tuner and will disable it",
+						KBUILD_MODNAME);
 		}
 
 		/* tuner IF frequency */
-		ret = af9035_rd_reg(d, EEPROM_1_IFFREQ_L + eeprom_shift, &tmp);
+		ret = af9035_rd_reg(d, addr + EEPROM_1_IF_L, &tmp);
 		if (ret < 0)
 			goto err;
 
 		tmp16 = tmp;
 
-		ret = af9035_rd_reg(d, EEPROM_1_IFFREQ_H + eeprom_shift, &tmp);
+		ret = af9035_rd_reg(d, addr + EEPROM_1_IF_H, &tmp);
 		if (ret < 0)
 			goto err;
 
@@ -663,9 +695,10 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 
 		dev_dbg(&d->udev->dev, "%s: [%d]IF=%d\n", __func__, i, tmp16);
 
-		eeprom_shift = 0x10; /* shift for the 2nd tuner params */
+		addr += 0x10; /* shift for the 2nd tuner params */
 	}
 
+skip_eeprom:
 	/* get demod clock */
 	ret = af9035_rd_reg(d, 0x00d800, &tmp);
 	if (ret < 0)
@@ -673,60 +706,13 @@ static int af9035_read_config_af9035(struct dvb_usb_device *d)
 
 	tmp = (tmp >> 0) & 0x0f;
 
-	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
-		state->af9033_config[i].clock = clock_lut[tmp];
-
-	return 0;
-
-err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-
-	return ret;
-}
-
-static int af9035_read_config_it9135(struct dvb_usb_device *d)
-{
-	struct state *state = d_to_priv(d);
-	int ret, i;
-	u8 tmp;
-
-	/* demod I2C "address" */
-	state->af9033_config[0].i2c_addr = 0x38;
-	state->af9033_config[0].tuner = AF9033_TUNER_IT9135_38;
-	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
-	state->dual_mode = false;
-
-	/* check if eeprom exists */
-	if (state->chip_version == 2)
-		ret = af9035_rd_reg(d, 0x00461d, &tmp);
-	else
-		ret = af9035_rd_reg(d, 0x00461b, &tmp);
-	if (ret < 0)
-		goto err;
-
-	if (tmp) {
-		/* tuner */
-		ret = af9035_rd_reg(d, 0x0049d0, &tmp);
-		if (ret < 0)
-			goto err;
-
-		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
-				__func__, 0, tmp);
-
-		if (tmp)
-			state->af9033_config[0].tuner = tmp;
+	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++) {
+		if (state->chip_type == 0x9135)
+			state->af9033_config[i].clock = clock_lut_it9135[tmp];
+		else
+			state->af9033_config[i].clock = clock_lut_af9035[tmp];
 	}
 
-	/* get demod clock */
-	ret = af9035_rd_reg(d, 0x00d800, &tmp);
-	if (ret < 0)
-		goto err;
-
-	tmp = (tmp >> 0) & 0x0f;
-
-	for (i = 0; i < ARRAY_SIZE(state->af9033_config); i++)
-		state->af9033_config[i].clock = clock_lut_it9135[tmp];
-
 	return 0;
 
 err:
@@ -735,16 +721,6 @@ err:
 	return ret;
 }
 
-static int af9035_read_config(struct dvb_usb_device *d)
-{
-	struct state *state = d_to_priv(d);
-
-	if (state->chip_type == 0x9135)
-		return af9035_read_config_it9135(d);
-	else
-		return af9035_read_config_af9035(d);
-}
-
 static int af9035_tua9001_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -1290,7 +1266,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (state->chip_type == 0x9135)
 		return 0;
 
-	ret = af9035_rd_reg(d, EEPROM_IR_MODE, &tmp);
+	ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_IR_MODE, &tmp);
 	if (ret < 0)
 		goto err;
 
@@ -1298,7 +1274,8 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 
 	/* don't activate rc if in HID mode or if not available */
 	if (tmp == 5) {
-		ret = af9035_rd_reg(d, EEPROM_IR_TYPE, &tmp);
+		ret = af9035_rd_reg(d, EEPROM_BASE_AF9035 + EEPROM_IR_TYPE,
+				&tmp);
 		if (ret < 0)
 			goto err;
 
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 7086ff2..4d918ee 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -61,7 +61,7 @@ struct state {
 	struct af9033_config af9033_config[2];
 };
 
-static const u32 clock_lut[] = {
+static const u32 clock_lut_af9035[] = {
 	20480000, /*      FPGA */
 	16384000, /* 16.38 MHz */
 	20480000, /* 20.48 MHz */
@@ -93,17 +93,20 @@ static const u32 clock_lut_it9135[] = {
 #define AF9035_FIRMWARE_IT9135_V1 "dvb-usb-it9135-01.fw"
 #define AF9035_FIRMWARE_IT9135_V2 "dvb-usb-it9135-02.fw"
 
-/* EEPROM locations */
-#define EEPROM_IR_MODE            0x430d
-#define EEPROM_DUAL_MODE          0x4326
-#define EEPROM_2ND_DEMOD_ADDR     0x4327
-#define EEPROM_IR_TYPE            0x4329
-#define EEPROM_1_IFFREQ_L         0x432d
-#define EEPROM_1_IFFREQ_H         0x432e
-#define EEPROM_1_TUNER_ID         0x4331
-#define EEPROM_2_IFFREQ_L         0x433d
-#define EEPROM_2_IFFREQ_H         0x433e
-#define EEPROM_2_TUNER_ID         0x4341
+#define EEPROM_BASE_AF9035        0x42fd
+#define EEPROM_BASE_IT9135        0x499c
+#define EEPROM_SHIFT                0x10
+
+#define EEPROM_IR_MODE              0x10
+#define EEPROM_DUAL_MODE            0x29
+#define EEPROM_2ND_DEMOD_ADDR       0x2a
+#define EEPROM_IR_TYPE              0x2c
+#define EEPROM_1_IF_L               0x30
+#define EEPROM_1_IF_H               0x31
+#define EEPROM_1_TUNER_ID           0x34
+#define EEPROM_2_IF_L               0x40
+#define EEPROM_2_IF_H               0x41
+#define EEPROM_2_TUNER_ID           0x44
 
 /* USB commands */
 #define CMD_MEM_RD                  0x00
-- 
1.7.11.7

