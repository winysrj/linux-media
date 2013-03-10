Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60403 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab3CJCEi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 04/41] af9035: add auto configuration heuristic for it9135
Date: Sun, 10 Mar 2013 04:02:56 +0200
Message-Id: <1362881013-5271-4-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Detect automatically multiple chip versions and select configuration
according to that.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 116 ++++++++++++++++++++++++----------
 drivers/media/usb/dvb-usb-v2/af9035.h |   6 +-
 2 files changed, 88 insertions(+), 34 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index d57fbb1..7fdc9ed 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -292,12 +292,38 @@ static struct i2c_algorithm af9035_i2c_algo = {
 
 static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 {
+	struct state *state = d_to_priv(d);
 	int ret;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
 	struct usb_req req = { CMD_FW_QUERYINFO, 0, sizeof(wbuf), wbuf,
 			sizeof(rbuf), rbuf };
 
+	ret = af9035_rd_regs(d, 0x1222, rbuf, 3);
+	if (ret < 0)
+		goto err;
+
+	state->chip_version = rbuf[0];
+	state->chip_type = rbuf[2] << 8 | rbuf[1] << 0;
+
+	ret = af9035_rd_reg(d, 0x384f, &state->prechip_version);
+	if (ret < 0)
+		goto err;
+
+	dev_info(&d->udev->dev,
+			"%s: prechip_version=%02x chip_version=%02x chip_type=%04x\n",
+			__func__, state->prechip_version, state->chip_version,
+			state->chip_type);
+
+	if (state->chip_type == 0x9135) {
+		if (state->chip_version == 2)
+			*name = AF9035_FIRMWARE_IT9135_V2;
+		else
+			*name = AF9035_FIRMWARE_IT9135_V1;
+	} else {
+		*name = AF9035_FIRMWARE_AF9035;
+	}
+
 	ret = af9035_ctrl_msg(d, &req);
 	if (ret < 0)
 		goto err;
@@ -316,7 +342,7 @@ err:
 	return ret;
 }
 
-static int af9035_download_firmware(struct dvb_usb_device *d,
+static int af9035_download_firmware_af9035(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
 	int ret, i, j, len;
@@ -543,7 +569,18 @@ err:
 	return ret;
 }
 
-static int af9035_read_config(struct dvb_usb_device *d)
+static int af9035_download_firmware(struct dvb_usb_device *d,
+		const struct firmware *fw)
+{
+	struct state *state = d_to_priv(d);
+
+	if (state->chip_type == 0x9135)
+		return af9035_download_firmware_it9135(d, fw);
+	else
+		return af9035_download_firmware_af9035(d, fw);
+}
+
+static int af9035_read_config_af9035(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
 	int ret, i, eeprom_shift = 0;
@@ -658,6 +695,27 @@ static int af9035_read_config_it9135(struct dvb_usb_device *d)
 	state->af9033_config[0].adc_multiplier = AF9033_ADC_MULTIPLIER_2X;
 	state->dual_mode = false;
 
+	/* check if eeprom exists */
+	if (state->chip_version == 2)
+		ret = af9035_rd_reg(d, 0x00461d, &tmp);
+	else
+		ret = af9035_rd_reg(d, 0x00461b, &tmp);
+	if (ret < 0)
+		goto err;
+
+	if (tmp) {
+		/* tuner */
+		ret = af9035_rd_reg(d, 0x0049d0, &tmp);
+		if (ret < 0)
+			goto err;
+
+		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
+				__func__, 0, tmp);
+
+		if (tmp)
+			state->af9033_config[0].tuner = tmp;
+	}
+
 	/* get demod clock */
 	ret = af9035_rd_reg(d, 0x00d800, &tmp);
 	if (ret < 0)
@@ -676,6 +734,16 @@ err:
 	return ret;
 }
 
+static int af9035_read_config(struct dvb_usb_device *d)
+{
+	struct state *state = d_to_priv(d);
+
+	if (state->chip_type == 0x9135)
+		return af9035_read_config_it9135(d);
+	else
+		return af9035_read_config_af9035(d);
+}
+
 static int af9035_tua9001_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
@@ -1101,7 +1169,13 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 				&af9035_fc0012_config[adap->id]);
 		break;
 	case AF9033_TUNER_IT9135_38:
+	case AF9033_TUNER_IT9135_51:
+	case AF9033_TUNER_IT9135_52:
+	case AF9033_TUNER_IT9135_60:
+	case AF9033_TUNER_IT9135_61:
+	case AF9033_TUNER_IT9135_62:
 		/* attach tuner */
+		af9035_it913x_config.tuner_id_0 = state->af9033_config[0].tuner;
 		fe = dvb_attach(it913x_attach, adap->fe[0],
 				&d->i2c_adap, 0x38, &af9035_it913x_config);
 		break;
@@ -1202,9 +1276,14 @@ err:
 
 static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
+	struct state *state = d_to_priv(d);
 	int ret;
 	u8 tmp;
 
+	/* TODO: IT9135 remote control support */
+	if (state->chip_type == 0x9135)
+		return 0;
+
 	ret = af9035_rd_reg(d, EEPROM_IR_MODE, &tmp);
 	if (ret < 0)
 		goto err;
@@ -1260,7 +1339,6 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.generic_bulk_ctrl_endpoint_response = 0x81,
 
 	.identify_state = af9035_identify_state,
-	.firmware = AF9035_FIRMWARE_AF9035,
 	.download_firmware = af9035_download_firmware,
 
 	.i2c_algo = &af9035_i2c_algo,
@@ -1280,35 +1358,6 @@ static const struct dvb_usb_device_properties af9035_props = {
 	},
 };
 
-static const struct dvb_usb_device_properties it9135_props = {
-	.driver_name = KBUILD_MODNAME,
-	.owner = THIS_MODULE,
-	.adapter_nr = adapter_nr,
-	.size_of_priv = sizeof(struct state),
-
-	.generic_bulk_ctrl_endpoint = 0x02,
-	.generic_bulk_ctrl_endpoint_response = 0x81,
-
-	.identify_state = af9035_identify_state,
-	.firmware = AF9035_FIRMWARE_IT9135,
-	.download_firmware = af9035_download_firmware_it9135,
-
-	.i2c_algo = &af9035_i2c_algo,
-	.read_config = af9035_read_config_it9135,
-	.frontend_attach = af9035_frontend_attach,
-	.tuner_attach = af9035_tuner_attach,
-	.init = af9035_init,
-
-	.num_adapters = 1,
-	.adapter = {
-		{
-			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
-		}, {
-			.stream = DVB_USB_STREAM_BULK(0x85, 6, 87 * 188),
-		},
-	},
-};
-
 static const struct usb_device_id af9035_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9035_9035,
 		&af9035_props, "Afatech AF9035 reference design", NULL) },
@@ -1356,4 +1405,5 @@ MODULE_AUTHOR("Antti Palosaari <crope@iki.fi>");
 MODULE_DESCRIPTION("Afatech AF9035 driver");
 MODULE_LICENSE("GPL");
 MODULE_FIRMWARE(AF9035_FIRMWARE_AF9035);
-MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135);
+MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135_V1);
+MODULE_FIRMWARE(AF9035_FIRMWARE_IT9135_V2);
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.h b/drivers/media/usb/dvb-usb-v2/af9035.h
index 9556bab..f995339 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.h
+++ b/drivers/media/usb/dvb-usb-v2/af9035.h
@@ -55,6 +55,9 @@ struct usb_req {
 struct state {
 	u8 seq; /* packet sequence number */
 	bool dual_mode;
+	u8 prechip_version;
+	u8 chip_version;
+	u16 chip_type;
 	struct af9033_config af9033_config[2];
 };
 
@@ -87,7 +90,8 @@ u32 clock_lut_it9135[] = {
 };
 
 #define AF9035_FIRMWARE_AF9035 "dvb-usb-af9035-02.fw"
-#define AF9035_FIRMWARE_IT9135 "dvb-usb-it9135-01.fw"
+#define AF9035_FIRMWARE_IT9135_V1 "dvb-usb-it9135-01.fw"
+#define AF9035_FIRMWARE_IT9135_V2 "dvb-usb-it9135-02.fw"
 
 /* EEPROM locations */
 #define EEPROM_IR_MODE            0x430d
-- 
1.7.11.7

