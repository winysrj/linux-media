Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:58464 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab2IMAY0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 20:24:26 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 09/16] af9015: use Kernel dev_foo() logging
Date: Thu, 13 Sep 2012 03:23:50 +0300
Message-Id: <1347495837-3244-9-git-send-email-crope@iki.fi>
In-Reply-To: <1347495837-3244-1-git-send-email-crope@iki.fi>
References: <1347495837-3244-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

... and some minor logging changes.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 155 ++++++++++++++++++++--------------
 drivers/media/usb/dvb-usb-v2/af9015.h |  21 -----
 2 files changed, 91 insertions(+), 85 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index d9d3030..c429da7 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -23,9 +23,6 @@
 
 #include "af9015.h"
 
-static int dvb_usb_af9015_debug;
-module_param_named(debug, dvb_usb_af9015_debug, int, 0644);
-MODULE_PARM_DESC(debug, "set debugging level" DVB_USB_DEBUG_STATUS);
 static int dvb_usb_af9015_remote;
 module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
 MODULE_PARM_DESC(remote, "select remote");
@@ -72,15 +69,17 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	case BOOT:
 		break;
 	default:
-		err("unknown command:%d", req->cmd);
+		dev_err(&d->udev->dev, "%s: unknown command=%d\n",
+				KBUILD_MODNAME, req->cmd);
 		ret = -1;
 		goto error;
 	}
 
 	/* buffer overflow check */
 	if ((write && (req->data_len > BUF_LEN - REQ_HDR_LEN)) ||
-		(!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
-		err("too much data; cmd:%d len:%d", req->cmd, req->data_len);
+			(!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
+		dev_err(&d->udev->dev, "%s: too much data; cmd=%d len=%d\n",
+				KBUILD_MODNAME, req->cmd, req->data_len);
 		ret = -EINVAL;
 		goto error;
 	}
@@ -106,7 +105,8 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 
 	/* check status */
 	if (rlen && buf[1]) {
-		err("command failed:%d", buf[1]);
+		dev_err(&d->udev->dev, "%s: command failed=%d\n",
+				KBUILD_MODNAME, buf[1]);
 		ret = -1;
 		goto error;
 	}
@@ -334,7 +334,8 @@ static int af9015_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret)
 		return ret;
 
-	deb_info("%s: reply:%02x\n", __func__, reply);
+	dev_dbg(&d->udev->dev, "%s: reply=%02x\n", __func__, reply);
+
 	if (reply == 0x02)
 		ret = WARM;
 	else
@@ -350,8 +351,7 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 	int i, len, remaining, ret;
 	struct req_t req = {DOWNLOAD_FIRMWARE, 0, 0, 0, 0, 0, NULL};
 	u16 checksum = 0;
-
-	deb_info("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* calc checksum */
 	for (i = 0; i < fw->size; i++)
@@ -373,7 +373,9 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 
 		ret = af9015_ctrl_msg(d, &req);
 		if (ret) {
-			err("firmware download failed:%d", ret);
+			dev_err(&d->udev->dev,
+					"%s: firmware download failed=%d\n",
+					KBUILD_MODNAME, ret);
 			goto error;
 		}
 	}
@@ -383,7 +385,8 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 	req.data_len = 0;
 	ret = af9015_ctrl_msg(d, &req);
 	if (ret) {
-		err("firmware boot failed:%d", ret);
+		dev_err(&d->udev->dev, "%s: firmware boot failed=%d\n",
+				KBUILD_MODNAME, ret);
 		goto error;
 	}
 
@@ -414,9 +417,9 @@ static int af9015_eeprom_hash(struct dvb_usb_device *d)
 		eeprom[reg] = val;
 	}
 
-	if (dvb_usb_af9015_debug & 0x01)
-		print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, eeprom,
-				eeprom_size);
+	for (reg = 0; reg < eeprom_size; reg += 16)
+		dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 16,
+				eeprom + reg);
 
 	BUG_ON(eeprom_size % 4);
 
@@ -426,7 +429,8 @@ static int af9015_eeprom_hash(struct dvb_usb_device *d)
 		state->eeprom_sum += le32_to_cpu(((u32 *)eeprom)[reg]);
 	}
 
-	deb_info("%s: eeprom sum=%.8x\n", __func__, state->eeprom_sum);
+	dev_dbg(&d->udev->dev, "%s: eeprom sum=%.8x\n",
+			__func__, state->eeprom_sum);
 
 	ret = 0;
 free:
@@ -441,7 +445,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	u8 val, i, offset = 0;
 	struct req_t req = {READ_I2C, AF9015_I2C_EEPROM, 0, 0, 1, 1, &val};
 
-	deb_info("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	/* IR remote controller */
 	req.addr = AF9015_EEPROM_IR_MODE;
@@ -458,8 +462,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	if (ret)
 		goto error;
 
-	deb_info("%s: IR mode=%d\n", __func__, val);
 	state->ir_mode = val;
+	dev_dbg(&d->udev->dev, "%s: IR mode=%d\n", __func__, val);
 
 	/* TS mode - one or two receivers */
 	req.addr = AF9015_EEPROM_TS_MODE;
@@ -468,7 +472,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		goto error;
 
 	state->dual_mode = val;
-	deb_info("%s: TS mode=%d\n", __func__, state->dual_mode);
+	dev_dbg(&d->udev->dev, "%s: TS mode=%d\n", __func__, state->dual_mode);
 
 	/* disable 2nd adapter because we don't have PID-filters */
 	if (d->udev->speed == USB_SPEED_FULL)
@@ -506,8 +510,9 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			state->af9013_config[i].clock = 25000000;
 			break;
 		};
-		deb_info("%s: [%d] xtal=%d set clock=%d\n", __func__, i,
-				val, state->af9013_config[i].clock);
+		dev_dbg(&d->udev->dev, "%s: [%d] xtal=%d set clock=%d\n",
+				__func__, i, val,
+				state->af9013_config[i].clock);
 
 		/* IF frequency */
 		req.addr = AF9015_EEPROM_IF1H + offset;
@@ -524,8 +529,8 @@ static int af9015_read_config(struct dvb_usb_device *d)
 
 		state->af9013_config[i].if_frequency += val;
 		state->af9013_config[i].if_frequency *= 1000;
-		deb_info("%s: [%d] IF frequency=%d\n", __func__, i,
-				state->af9013_config[i].if_frequency);
+		dev_dbg(&d->udev->dev, "%s: [%d] IF frequency=%d\n", __func__,
+				i, state->af9013_config[i].if_frequency);
 
 		/* MT2060 IF1 */
 		req.addr = AF9015_EEPROM_MT2060_IF1H  + offset;
@@ -538,7 +543,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 		if (ret)
 			goto error;
 		state->mt2060_if1[i] += val;
-		deb_info("%s: [%d] MT2060 IF1=%d\n", __func__, i,
+		dev_dbg(&d->udev->dev, "%s: [%d] MT2060 IF1=%d\n", __func__, i,
 				state->mt2060_if1[i]);
 
 		/* tuner */
@@ -568,17 +573,21 @@ static int af9015_read_config(struct dvb_usb_device *d)
 			state->af9013_config[i].spec_inv = 1;
 			break;
 		default:
-			warn("tuner id=%d not supported, please report!", val);
+			dev_err(&d->udev->dev, "%s: tuner id=%d not " \
+					"supported, please report!\n",
+					KBUILD_MODNAME, val);
 			return -ENODEV;
 		};
 
 		state->af9013_config[i].tuner = val;
-		deb_info("%s: [%d] tuner id=%d\n", __func__, i, val);
+		dev_dbg(&d->udev->dev, "%s: [%d] tuner id=%d\n",
+				__func__, i, val);
 	}
 
 error:
 	if (ret)
-		err("eeprom read failed=%d", ret);
+		dev_err(&d->udev->dev, "%s: eeprom read failed=%d\n",
+				KBUILD_MODNAME, ret);
 
 	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
 	   content :-( Override some wrong values here. Ditto for the
@@ -588,7 +597,9 @@ error:
 			USB_PID_AVERMEDIA_A850) ||
 		(le16_to_cpu(d->udev->descriptor.idProduct) ==
 			USB_PID_AVERMEDIA_A850T))) {
-		deb_info("%s: AverMedia A850: overriding config\n", __func__);
+		dev_dbg(&d->udev->dev,
+				"%s: AverMedia A850: overriding config\n",
+				__func__);
 		/* disable dual mode */
 		state->dual_mode = 0;
 
@@ -602,9 +613,10 @@ error:
 static int af9015_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 		struct usb_data_stream_properties *stream)
 {
-	deb_info("%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
+	struct dvb_usb_device *d = fe_to_d(fe);
+	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
 
-	if (fe_to_d(fe)->udev->speed == USB_SPEED_FULL)
+	if (d->udev->speed == USB_SPEED_FULL)
 		stream->u.bulk.buffersize = TS_USB11_FRAME_SIZE;
 
 	return 0;
@@ -721,7 +733,7 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	u8 val, i;
 	struct req_t req = {COPY_FIRMWARE, 0, 0x5100, 0, 0, sizeof(fw_params),
 		fw_params };
-	deb_info("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	fw_params[0] = state->firmware_size >> 8;
 	fw_params[1] = state->firmware_size & 0xff;
@@ -736,7 +748,8 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	if (ret)
 		goto error;
 	else
-		deb_info("%s: firmware status:%02x\n", __func__, val);
+		dev_dbg(&d->udev->dev, "%s: firmware status=%02x\n",
+				__func__, val);
 
 	if (val == 0x0c) /* fw is running, no need for download */
 		goto exit;
@@ -751,8 +764,10 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	/* copy firmware */
 	ret = af9015_ctrl_msg(d, &req);
 	if (ret)
-		err("firmware copy cmd failed:%d", ret);
-	deb_info("%s: firmware copy done\n", __func__);
+		dev_err(&d->udev->dev, "%s: firmware copy cmd failed=%d\n",
+				KBUILD_MODNAME, ret);
+
+	dev_dbg(&d->udev->dev, "%s: firmware copy done\n", __func__);
 
 	/* set I2C master clock back to normal */
 	ret = af9015_write_reg(d, 0xd416, 0x14); /* 0x14 * 400ns */
@@ -762,7 +777,8 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	/* request boot firmware */
 	ret = af9015_write_reg_i2c(d, state->af9013_config[1].i2c_addr,
 			0xe205, 1);
-	deb_info("%s: firmware boot cmd status:%d\n", __func__, ret);
+	dev_dbg(&d->udev->dev, "%s: firmware boot cmd status=%d\n",
+			__func__, ret);
 	if (ret)
 		goto error;
 
@@ -772,8 +788,8 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 		/* check firmware status */
 		ret = af9015_read_reg_i2c(d, state->af9013_config[1].i2c_addr,
 				0x98be, &val);
-		deb_info("%s: firmware status cmd status:%d fw status:%02x\n",
-			__func__, ret, val);
+		dev_dbg(&d->udev->dev, "%s: firmware status cmd status=%d " \
+				"firmware status=%02x\n", __func__, ret, val);
 		if (ret)
 			goto error;
 
@@ -782,10 +798,12 @@ static int af9015_copy_firmware(struct dvb_usb_device *d)
 	}
 
 	if (val == 0x04) {
-		err("firmware did not run");
+		dev_err(&d->udev->dev, "%s: firmware did not run\n",
+				KBUILD_MODNAME);
 		ret = -1;
 	} else if (val != 0x0c) {
-		err("firmware boot timeout");
+		dev_err(&d->udev->dev, "%s: firmware boot timeout\n",
+				KBUILD_MODNAME);
 		ret = -1;
 	}
 
@@ -814,8 +832,10 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 		if (state->dual_mode) {
 			ret = af9015_copy_firmware(adap_to_d(adap));
 			if (ret) {
-				err("firmware copy to 2nd frontend " \
-					"failed, will disable it");
+				dev_err(&adap_to_d(adap)->udev->dev,
+						"%s: firmware copy to 2nd " \
+						"frontend failed, will " \
+						"disable it\n", KBUILD_MODNAME);
 				state->dual_mode = 0;
 				return -ENODEV;
 			}
@@ -921,9 +941,10 @@ static struct mxl5007t_config af9015_mxl5007t_config = {
 
 static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 {
-	struct af9015_state *state = adap_to_priv(adap);
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct af9015_state *state = d_to_priv(d);
 	int ret;
-	deb_info("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	switch (state->af9013_config[adap->id].tuner) {
 	case AF9013_TUNER_MT2060:
@@ -977,9 +998,10 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
+		dev_err(&d->udev->dev, "%s: unknown tuner id=%d\n",
+				KBUILD_MODNAME,
+				state->af9013_config[adap->id].tuner);
 		ret = -ENODEV;
-		err("Unknown tuner id:%d",
-			state->af9013_config[adap->id].tuner);
 	}
 
 	if (adap->fe[0]->ops.tuner_ops.init) {
@@ -999,13 +1021,14 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
-	deb_info("%s: onoff:%d\n", __func__, onoff);
+	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
 
 	if (onoff)
-		ret = af9015_set_reg_bit(adap_to_d(adap), 0xd503, 0);
+		ret = af9015_set_reg_bit(d, 0xd503, 0);
 	else
-		ret = af9015_clear_reg_bit(adap_to_d(adap), 0xd503, 0);
+		ret = af9015_clear_reg_bit(d, 0xd503, 0);
 
 	return ret;
 }
@@ -1013,22 +1036,22 @@ static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 	int onoff)
 {
+	struct dvb_usb_device *d = adap_to_d(adap);
 	int ret;
 	u8 idx;
+	dev_dbg(&d->udev->dev, "%s: index=%d pid=%04x onoff=%d\n",
+			__func__, index, pid, onoff);
 
-	deb_info("%s: set pid filter, index %d, pid %x, onoff %d\n",
-		__func__, index, pid, onoff);
-
-	ret = af9015_write_reg(adap_to_d(adap), 0xd505, (pid & 0xff));
+	ret = af9015_write_reg(d, 0xd505, (pid & 0xff));
 	if (ret)
 		goto error;
 
-	ret = af9015_write_reg(adap_to_d(adap), 0xd506, (pid >> 8));
+	ret = af9015_write_reg(d, 0xd506, (pid >> 8));
 	if (ret)
 		goto error;
 
 	idx = ((index & 0x1f) | (1 << 5));
-	ret = af9015_write_reg(adap_to_d(adap), 0xd504, idx);
+	ret = af9015_write_reg(d, 0xd504, idx);
 
 error:
 	return ret;
@@ -1040,7 +1063,7 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 	int ret;
 	u16 frame_size;
 	u8  packet_size;
-	deb_info("%s: USB speed:%d\n", __func__, d->udev->speed);
+	dev_dbg(&d->udev->dev, "%s: USB speed=%d\n", __func__, d->udev->speed);
 
 	if (d->udev->speed == USB_SPEED_FULL) {
 		frame_size = TS_USB11_FRAME_SIZE/4;
@@ -1115,7 +1138,9 @@ static int af9015_init_endpoint(struct dvb_usb_device *d)
 
 error:
 	if (ret)
-		err("endpoint init failed:%d", ret);
+		dev_err(&d->udev->dev, "%s: endpoint init failed=%d\n",
+				KBUILD_MODNAME, ret);
+
 	return ret;
 }
 
@@ -1123,7 +1148,7 @@ static int af9015_init(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
 	int ret;
-	deb_info("%s:\n", __func__);
+	dev_dbg(&d->udev->dev, "%s:\n", __func__);
 
 	mutex_init(&state->fe_mutex);
 
@@ -1177,21 +1202,21 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	int ret;
 	u8 buf[17];
 
-	deb_info("%s:\n", __func__);
-
 	/* read registers needed to detect remote controller code */
 	ret = af9015_read_regs(d, 0x98d9, buf, sizeof(buf));
 	if (ret)
 		goto error;
 
 	/* If any of these are non-zero, assume invalid data */
-	if (buf[1] || buf[2] || buf[3])
+	if (buf[1] || buf[2] || buf[3]) {
+		dev_dbg(&d->udev->dev, "%s: invalid data\n", __func__);
 		return ret;
+	}
 
 	/* Check for repeat of previous code */
 	if ((state->rc_repeat != buf[6] || buf[0]) &&
 			!memcmp(&buf[12], state->rc_last, 4)) {
-		deb_rc("%s: key repeated\n", __func__);
+		dev_dbg(&d->udev->dev, "%s: key repeated\n", __func__);
 		rc_keydown(d->rc_dev, state->rc_keycode, 0);
 		state->rc_repeat = buf[6];
 		return ret;
@@ -1199,7 +1224,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
-		deb_rc("%s: key pressed %*ph\n", __func__, 4, buf + 12);
+		dev_dbg(&d->udev->dev, "%s: key pressed %*ph\n",
+				__func__, 4, buf + 12);
 
 		/* Reset the canary */
 		ret = af9015_write_reg(d, 0x98e9, 0xff);
@@ -1224,7 +1250,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 		}
 		rc_keydown(d->rc_dev, state->rc_keycode, 0);
 	} else {
-		deb_rc("%s: no key press\n", __func__);
+		dev_dbg(&d->udev->dev, "%s: no key press\n", __func__);
 		/* Invalidate last keypress */
 		/* Not really needed, but helps with debug */
 		state->rc_last[2] = state->rc_last[3];
@@ -1235,7 +1261,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 error:
 	if (ret) {
-		err("%s: failed:%d", __func__, ret);
+		dev_warn(&d->udev->dev, "%s: rc query failed=%d\n",
+				KBUILD_MODNAME, ret);
 
 		/* allow random errors as dvb-usb will stop polling on error */
 		if (!state->rc_failed)
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index 35f946c..533637d 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -36,27 +36,6 @@
 #include "tda18218.h"
 #include "mxl5007t.h"
 
-#define DVB_USB_LOG_PREFIX "af9015"
-
-#ifdef CONFIG_DVB_USB_DEBUG
-#define dprintk(var, level, args...) \
-	do { if ((var & level)) printk(args); } while (0)
-#define DVB_USB_DEBUG_STATUS
-#else
-#define dprintk(args...)
-#define DVB_USB_DEBUG_STATUS " (debugging is not enabled)"
-#endif
-
-#define deb_info(args...) dprintk(dvb_usb_af9015_debug, 0x01, args)
-#define deb_rc(args...)   dprintk(dvb_usb_af9015_debug, 0x02, args)
-
-#undef err
-#define err(format, arg...) \
-	printk(KERN_ERR     DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
-#undef warn
-#define warn(format, arg...) \
-	printk(KERN_WARNING DVB_USB_LOG_PREFIX ": " format "\n" , ## arg)
-
 #define AF9015_FIRMWARE "dvb-usb-af9015.fw"
 
 /* Windows driver uses packet count 21 for USB1.1 and 348 for USB2.0.
-- 
1.7.11.4

