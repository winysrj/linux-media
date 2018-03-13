Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:46221 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932791AbeCMXkM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:12 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 06/18] af9015: fix logging
Date: Wed, 14 Mar 2018 01:39:32 +0200
Message-Id: <20180313233944.7234-6-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pass correct device to dev_* logging functions, which allows us to
remove redundant KBUILD_MODNAME and __func__ parameters from log format.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 160 +++++++++++++++++-----------------
 1 file changed, 81 insertions(+), 79 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 8013659c41b1..7e4cce05b911 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -29,6 +29,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 #define REQ_HDR_LEN 8 /* send header size */
 #define ACK_HDR_LEN 2 /* rece header size */
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret, wlen, rlen;
 	u8 write = 1;
 
@@ -66,8 +67,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	case BOOT:
 		break;
 	default:
-		dev_err(&d->udev->dev, "%s: unknown command=%d\n",
-				KBUILD_MODNAME, req->cmd);
+		dev_err(&intf->dev, "unknown cmd %d\n", req->cmd);
 		ret = -EIO;
 		goto error;
 	}
@@ -75,8 +75,8 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	/* buffer overflow check */
 	if ((write && (req->data_len > BUF_LEN - REQ_HDR_LEN)) ||
 			(!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
-		dev_err(&d->udev->dev, "%s: too much data; cmd=%d len=%d\n",
-				KBUILD_MODNAME, req->cmd, req->data_len);
+		dev_err(&intf->dev, "too much data, cmd %u, len %u\n",
+			req->cmd, req->data_len);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -103,8 +103,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 
 	/* check status */
 	if (rlen && state->buf[1]) {
-		dev_err(&d->udev->dev, "%s: command failed=%d\n",
-				KBUILD_MODNAME, state->buf[1]);
+		dev_err(&intf->dev, "cmd failed %u\n", state->buf[1]);
 		ret = -EIO;
 		goto error;
 	}
@@ -206,6 +205,7 @@ static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u16 addr;
 	u8 mbox, addr_len;
@@ -307,15 +307,14 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 		ret = af9015_ctrl_msg(d, &req);
 	} else {
 		ret = -EOPNOTSUPP;
-		dev_dbg(&d->udev->dev, "%s: unknown msg, num %u\n",
-			__func__, num);
+		dev_dbg(&intf->dev, "unknown msg, num %u\n", num);
 	}
 	if (ret)
 		goto err;
 
 	return num;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed %d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed %d\n", ret);
 	return ret;
 }
 
@@ -331,6 +330,7 @@ static struct i2c_algorithm af9015_i2c_algo = {
 
 static int af9015_identify_state(struct dvb_usb_device *d, const char **name)
 {
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 reply;
 	struct req_t req = {GET_CONFIG, 0, 0, 0, 0, 1, &reply};
@@ -339,7 +339,7 @@ static int af9015_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret)
 		return ret;
 
-	dev_dbg(&d->udev->dev, "%s: reply=%02x\n", __func__, reply);
+	dev_dbg(&intf->dev, "reply %02x\n", reply);
 
 	if (reply == 0x02)
 		ret = WARM;
@@ -353,10 +353,12 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 	const struct firmware *fw)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int i, len, remaining, ret;
 	struct req_t req = {DOWNLOAD_FIRMWARE, 0, 0, 0, 0, 0, NULL};
 	u16 checksum = 0;
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	dev_dbg(&intf->dev, "\n");
 
 	/* calc checksum */
 	for (i = 0; i < fw->size; i++)
@@ -378,9 +380,8 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 
 		ret = af9015_ctrl_msg(d, &req);
 		if (ret) {
-			dev_err(&d->udev->dev,
-					"%s: firmware download failed=%d\n",
-					KBUILD_MODNAME, ret);
+			dev_err(&intf->dev, "firmware download failed %d\n",
+				ret);
 			goto error;
 		}
 	}
@@ -390,8 +391,7 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 	req.data_len = 0;
 	ret = af9015_ctrl_msg(d, &req);
 	if (ret) {
-		dev_err(&d->udev->dev, "%s: firmware boot failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_err(&intf->dev, "firmware boot failed %d\n", ret);
 		goto error;
 	}
 
@@ -407,6 +407,7 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 static int af9015_eeprom_hash(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret, i;
 	u8 buf[AF9015_EEPROM_SIZE];
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, NULL};
@@ -427,24 +428,24 @@ static int af9015_eeprom_hash(struct dvb_usb_device *d)
 	}
 
 	for (i = 0; i < AF9015_EEPROM_SIZE; i += 16)
-		dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 16, buf + i);
+		dev_dbg(&intf->dev, "%*ph\n", 16, buf + i);
 
-	dev_dbg(&d->udev->dev, "%s: eeprom sum=%.8x\n",
-			__func__, state->eeprom_sum);
+	dev_dbg(&intf->dev, "eeprom sum %.8x\n", state->eeprom_sum);
 	return 0;
 err:
-	dev_err(&d->udev->dev, "%s: eeprom failed=%d\n", KBUILD_MODNAME, ret);
+	dev_dbg(&intf->dev, "failed %d\n", ret);
 	return ret;
 }
 
 static int af9015_read_config(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 val, i, offset = 0;
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, &val};
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&intf->dev, "\n");
 
 	/* IR remote controller */
 	req.addr = AF9015_EEPROM_IR_MODE;
@@ -462,7 +463,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		goto error;
 
 	state->ir_mode = val;
-	dev_dbg(&d->udev->dev, "%s: IR mode=%d\n", __func__, val);
+	dev_dbg(&intf->dev, "ir mode %02x\n", val);
 
 	/* TS mode - one or two receivers */
 	req.addr = AF9015_EEPROM_TS_MODE;
@@ -471,7 +472,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		goto error;
 
 	state->dual_mode = val;
-	dev_dbg(&d->udev->dev, "%s: TS mode=%d\n", __func__, state->dual_mode);
+	dev_dbg(&intf->dev, "ts mode %02x\n", state->dual_mode);
 
 	/* disable 2nd adapter because we don't have PID-filters */
 	if (d->udev->speed == USB_SPEED_FULL)
@@ -511,9 +512,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			state->af9013_config[i].clock = 25000000;
 			break;
 		}
-		dev_dbg(&d->udev->dev, "%s: [%d] xtal=%d set clock=%d\n",
-				__func__, i, val,
-				state->af9013_config[i].clock);
+		dev_dbg(&intf->dev, "[%d] xtal %02x, clock %u\n",
+			i, val, state->af9013_config[i].clock);
 
 		/* IF frequency */
 		req.addr = AF9015_EEPROM_IF1H + offset;
@@ -530,8 +530,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 
 		state->af9013_config[i].if_frequency += val;
 		state->af9013_config[i].if_frequency *= 1000;
-		dev_dbg(&d->udev->dev, "%s: [%d] IF frequency=%d\n", __func__,
-				i, state->af9013_config[i].if_frequency);
+		dev_dbg(&intf->dev, "[%d] if frequency %u\n",
+			i, state->af9013_config[i].if_frequency);
 
 		/* MT2060 IF1 */
 		req.addr = AF9015_EEPROM_MT2060_IF1H  + offset;
@@ -544,8 +544,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto error;
 		state->mt2060_if1[i] += val;
-		dev_dbg(&d->udev->dev, "%s: [%d] MT2060 IF1=%d\n", __func__, i,
-				state->mt2060_if1[i]);
+		dev_dbg(&intf->dev, "[%d] MT2060 IF1 %u\n",
+			i, state->mt2060_if1[i]);
 
 		/* tuner */
 		req.addr =  AF9015_EEPROM_TUNER_ID1 + offset;
@@ -574,21 +574,19 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			state->af9013_config[i].spec_inv = 1;
 			break;
 		default:
-			dev_err(&d->udev->dev, "%s: tuner id=%d not " \
-					"supported, please report!\n",
-					KBUILD_MODNAME, val);
+			dev_err(&intf->dev,
+				"tuner id %02x not supported, please report!\n",
+				val);
 			return -ENODEV;
 		}
 
 		state->af9013_config[i].tuner = val;
-		dev_dbg(&d->udev->dev, "%s: [%d] tuner id=%d\n",
-				__func__, i, val);
+		dev_dbg(&intf->dev, "[%d] tuner id %02x\n", i, val);
 	}
 
 error:
 	if (ret)
-		dev_err(&d->udev->dev, "%s: eeprom read failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_err(&intf->dev, "eeprom read failed %d\n", ret);
 
 	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
 	   content :-( Override some wrong values here. Ditto for the
@@ -598,9 +596,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			USB_PID_AVERMEDIA_A850) ||
 		(le16_to_cpu(d->udev->descriptor.idProduct) ==
 			USB_PID_AVERMEDIA_A850T))) {
-		dev_dbg(&d->udev->dev,
-				"%s: AverMedia A850: overriding config\n",
-				__func__);
+		dev_dbg(&intf->dev, "AverMedia A850: overriding config\n");
 		/* disable dual mode */
 		state->dual_mode = 0;
 
@@ -615,7 +611,9 @@ static int af9015_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 		struct usb_data_stream_properties *stream)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
-	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
+	struct usb_interface *intf = d->intf;
+
+	dev_dbg(&intf->dev, "adap %u\n", fe_to_adap(fe)->id);
 
 	if (d->udev->speed == USB_SPEED_FULL)
 		stream->u.bulk.buffersize = TS_USB11_FRAME_SIZE;
@@ -729,12 +727,14 @@ static int af9015_tuner_sleep(struct dvb_frontend *fe)
 static int af9015_copy_firmware(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 fw_params[4];
 	u8 val, i;
 	struct req_t req = {COPY_FIRMWARE, 0, 0x5100, 0, 0, sizeof(fw_params),
 		fw_params };
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	dev_dbg(&intf->dev, "\n");
 
 	fw_params[0] = state->firmware_size >> 8;
 	fw_params[1] = state->firmware_size & 0xff;
@@ -746,8 +746,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	if (ret)
 		goto error;
 	else
-		dev_dbg(&d->udev->dev, "%s: firmware status=%02x\n",
-				__func__, val);
+		dev_dbg(&intf->dev, "firmware status %02x\n", val);
 
 	if (val == 0x0c) /* fw is running, no need for download */
 		goto exit;
@@ -762,10 +761,9 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	/* copy firmware */
 	ret = af9015_ctrl_msg(d, &req);
 	if (ret)
-		dev_err(&d->udev->dev, "%s: firmware copy cmd failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_err(&intf->dev, "firmware copy cmd failed %d\n", ret);
 
-	dev_dbg(&d->udev->dev, "%s: firmware copy done\n", __func__);
+	dev_dbg(&intf->dev, "firmware copy done\n");
 
 	/* set I2C master clock back to normal */
 	ret = af9015_write_reg(d, 0xd416, 0x14); /* 0x14 * 400ns */
@@ -775,8 +773,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	/* request boot firmware */
 	ret = af9015_write_reg_i2c(d, state->af9013_config[1].i2c_addr,
 			0xe205, 1);
-	dev_dbg(&d->udev->dev, "%s: firmware boot cmd status=%d\n",
-			__func__, ret);
+	dev_dbg(&intf->dev, "firmware boot cmd status %d\n", ret);
 	if (ret)
 		goto error;
 
@@ -786,8 +783,8 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 		/* check firmware status */
 		ret = af9015_read_reg_i2c(d, state->af9013_config[1].i2c_addr,
 				0x98be, &val);
-		dev_dbg(&d->udev->dev, "%s: firmware status cmd status=%d " \
-				"firmware status=%02x\n", __func__, ret, val);
+		dev_dbg(&intf->dev, "firmware status cmd status %d, firmware status %02x\n",
+			ret, val);
 		if (ret)
 			goto error;
 
@@ -796,13 +793,11 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	}
 
 	if (val == 0x04) {
-		dev_err(&d->udev->dev, "%s: firmware did not run\n",
-				KBUILD_MODNAME);
 		ret = -ETIMEDOUT;
+		dev_err(&intf->dev, "firmware did not run\n");
 	} else if (val != 0x0c) {
-		dev_err(&d->udev->dev, "%s: firmware boot timeout\n",
-				KBUILD_MODNAME);
 		ret = -ETIMEDOUT;
+		dev_err(&intf->dev, "firmware boot timeout\n");
 	}
 
 error:
@@ -812,8 +807,10 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 
 static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 {
-	int ret;
 	struct af9015_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
+	int ret;
 
 	if (adap->id == 0) {
 		state->af9013_config[0].ts_mode = AF9013_TS_USB;
@@ -833,10 +830,8 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 
 			ret = af9015_copy_firmware(adap_to_d(adap));
 			if (ret) {
-				dev_err(&adap_to_d(adap)->udev->dev,
-						"%s: firmware copy to 2nd " \
-						"frontend failed, will " \
-						"disable it\n", KBUILD_MODNAME);
+				dev_err(&intf->dev,
+					"firmware copy to 2nd frontend failed, will disable it\n");
 				state->dual_mode = 0;
 				return -ENODEV;
 			}
@@ -944,8 +939,10 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	dev_dbg(&intf->dev, "\n");
 
 	switch (state->af9013_config[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
@@ -999,9 +996,8 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
-		dev_err(&d->udev->dev, "%s: unknown tuner id=%d\n",
-				KBUILD_MODNAME,
-				state->af9013_config[adap->id].tuner);
+		dev_err(&intf->dev, "unknown tuner, tuner id %02x\n",
+			state->af9013_config[adap->id].tuner);
 		ret = -ENODEV;
 	}
 
@@ -1023,8 +1019,10 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
+
+	dev_dbg(&intf->dev, "onoff %d\n", onoff);
 
 	if (onoff)
 		ret = af9015_set_reg_bit(d, 0xd503, 0);
@@ -1038,10 +1036,12 @@ static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	int onoff)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 idx;
-	dev_dbg(&d->udev->dev, "%s: index=%d pid=%04x onoff=%d\n",
-			__func__, index, pid, onoff);
+
+	dev_dbg(&intf->dev, "index %d, pid %04x, onoff %d\n",
+		index, pid, onoff);
 
 	ret = af9015_write_reg(d, 0xd505, (pid & 0xff));
 	if (ret)
@@ -1061,10 +1061,12 @@ static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 static int af9015_init_endpoint(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u16 frame_size;
 	u8  packet_size;
-	dev_dbg(&d->udev->dev, "%s: USB speed=%d\n", __func__, d->udev->speed);
+
+	dev_dbg(&intf->dev, "usb speed %u\n", d->udev->speed);
 
 	if (d->udev->speed == USB_SPEED_FULL) {
 		frame_size = TS_USB11_FRAME_SIZE/4;
@@ -1150,8 +1152,7 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 
 error:
 	if (ret)
-		dev_err(&d->udev->dev, "%s: endpoint init failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_err(&intf->dev, "endpoint init failed %d\n", ret);
 
 	return ret;
 }
@@ -1159,8 +1160,10 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 static int af9015_init(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+
+	dev_dbg(&intf->dev, "\n");
 
 	mutex_init(&state->fe_mutex);
 
@@ -1212,6 +1215,7 @@ static const struct af9015_rc_setup af9015_rc_setup_hashes[] = {
 static int af9015_rc_query(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 buf[17];
 
@@ -1222,14 +1226,14 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* If any of these are non-zero, assume invalid data */
 	if (buf[1] || buf[2] || buf[3]) {
-		dev_dbg(&d->udev->dev, "%s: invalid data\n", __func__);
+		dev_dbg(&intf->dev, "invalid data\n");
 		return ret;
 	}
 
 	/* Check for repeat of previous code */
 	if ((state->rc_repeat != buf[6] || buf[0]) &&
 			!memcmp(&buf[12], state->rc_last, 4)) {
-		dev_dbg(&d->udev->dev, "%s: key repeated\n", __func__);
+		dev_dbg(&intf->dev, "key repeated\n");
 		rc_repeat(d->rc_dev);
 		state->rc_repeat = buf[6];
 		return ret;
@@ -1238,8 +1242,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
 		enum rc_proto proto;
-		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
-				__func__, 4, buf + 12);
+		dev_dbg(&intf->dev, "key pressed %*ph\n", 4, buf + 12);
 
 		/* Reset the canary */
 		ret = af9015_write_reg(d, 0x98e9, 0xff);
@@ -1271,7 +1274,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 		}
 		rc_keydown(d->rc_dev, proto, state->rc_keycode, 0);
 	} else {
-		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
+		dev_dbg(&intf->dev, "no key press\n");
 		/* Invalidate last keypress */
 		/* Not really needed, but helps with debug */
 		state->rc_last[2] = state->rc_last[3];
@@ -1282,8 +1285,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 error:
 	if (ret) {
-		dev_warn(&d->udev->dev, "%s: rc query failed=%d\n",
-				KBUILD_MODNAME, ret);
+		dev_warn(&intf->dev, "rc query failed %d\n", ret);
 
 		/* allow random errors as dvb-usb will stop polling on error */
 		if (!state->rc_failed)
@@ -1376,7 +1378,7 @@ static int af9015_probe(struct usb_interface *intf,
 	if ((le16_to_cpu(udev->descriptor.idVendor) == USB_VID_TERRATEC) &&
 			(le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
 		if (!strcmp("ITE Technologies, Inc.", manufacturer)) {
-			dev_dbg(&udev->dev, "%s: rejecting device\n", __func__);
+			dev_dbg(&intf->dev, "rejecting device\n");
 			return -ENODEV;
 		}
 	}
-- 
2.14.3
