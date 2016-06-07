Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45535 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbcFGFzb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2016 01:55:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH] af9035: fix logging
Date: Tue,  7 Jun 2016 08:55:11 +0300
Message-Id: <1465278911-27964-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove __func__ and KBUILD_MODNAME from logging formatters and pass
USB interface device instead, so logging can be done correctly.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 193 +++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 96 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index a8ab592..eabede4 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -49,6 +49,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 #define CHECKSUM_LEN 2
 #define USB_TIMEOUT 2000
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret, wlen, rlen;
 	u16 checksum, tmp_checksum;
 
@@ -57,8 +58,8 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	/* buffer overflow check */
 	if (req->wlen > (BUF_LEN - REQ_HDR_LEN - CHECKSUM_LEN) ||
 			req->rlen > (BUF_LEN - ACK_HDR_LEN - CHECKSUM_LEN)) {
-		dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
-				KBUILD_MODNAME, req->wlen, req->rlen);
+		dev_err(&intf->dev, "too much data wlen=%d rlen=%d\n",
+			req->wlen, req->rlen);
 		ret = -EINVAL;
 		goto exit;
 	}
@@ -94,10 +95,8 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 	checksum = af9035_checksum(state->buf, rlen - 2);
 	tmp_checksum = (state->buf[rlen - 2] << 8) | state->buf[rlen - 1];
 	if (tmp_checksum != checksum) {
-		dev_err(&d->udev->dev,
-				"%s: command=%02x checksum mismatch (%04x != %04x)\n",
-				KBUILD_MODNAME, req->cmd, tmp_checksum,
-				checksum);
+		dev_err(&intf->dev, "command=%02x checksum mismatch (%04x != %04x)\n",
+			req->cmd, tmp_checksum, checksum);
 		ret = -EIO;
 		goto exit;
 	}
@@ -110,8 +109,8 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 			goto exit;
 		}
 
-		dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
-				__func__, req->cmd, state->buf[2]);
+		dev_dbg(&intf->dev, "command=%02x failed fw error=%d\n",
+			req->cmd, state->buf[2]);
 		ret = -EIO;
 		goto exit;
 	}
@@ -122,20 +121,20 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d, struct usb_req *req)
 exit:
 	mutex_unlock(&d->usb_mutex);
 	if (ret < 0)
-		dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+		dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
 /* write multiple registers */
 static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
 {
+	struct usb_interface *intf = d->intf;
 	u8 wbuf[MAX_XFER_SIZE];
 	u8 mbox = (reg >> 16) & 0xff;
 	struct usb_req req = { CMD_MEM_WR, mbox, 6 + len, wbuf, 0, NULL };
 
 	if (6 + len > sizeof(wbuf)) {
-		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
-			 KBUILD_MODNAME, len);
+		dev_warn(&intf->dev, "i2c wr: len=%d is too big!\n", len);
 		return -EOPNOTSUPP;
 	}
 
@@ -198,6 +197,7 @@ static int af9035_add_i2c_dev(struct dvb_usb_device *d, const char *type,
 {
 	int ret, num;
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	struct i2c_client *client;
 	struct i2c_board_info board_info = {
 		.addr = addr,
@@ -212,11 +212,10 @@ static int af9035_add_i2c_dev(struct dvb_usb_device *d, const char *type,
 			break;
 	}
 
-	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+	dev_dbg(&intf->dev, "num=%d\n", num);
 
 	if (num == AF9035_I2C_CLIENT_MAX) {
-		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
-				KBUILD_MODNAME);
+		dev_err(&intf->dev, "I2C client out of index\n");
 		ret = -ENODEV;
 		goto err;
 	}
@@ -240,7 +239,7 @@ static int af9035_add_i2c_dev(struct dvb_usb_device *d, const char *type,
 	state->i2c_client[num] = client;
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 	return ret;
 }
 
@@ -248,6 +247,7 @@ static void af9035_del_i2c_dev(struct dvb_usb_device *d)
 {
 	int num;
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	struct i2c_client *client;
 
 	/* find last used client */
@@ -257,11 +257,10 @@ static void af9035_del_i2c_dev(struct dvb_usb_device *d)
 			break;
 	}
 
-	dev_dbg(&d->udev->dev, "%s: num=%d\n", __func__, num);
+	dev_dbg(&intf->dev, "num=%d\n", num);
 
 	if (num == -1) {
-		dev_err(&d->udev->dev, "%s: I2C client out of index\n",
-				KBUILD_MODNAME);
+		dev_err(&intf->dev, "I2C client out of index\n");
 		goto err;
 	}
 
@@ -276,7 +275,7 @@ static void af9035_del_i2c_dev(struct dvb_usb_device *d)
 	state->i2c_client[num] = NULL;
 	return;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed\n", __func__);
+	dev_dbg(&intf->dev, "failed\n");
 }
 
 static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
@@ -496,6 +495,7 @@ static struct i2c_algorithm af9035_i2c_algo = {
 static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 wbuf[1] = { 1 };
 	u8 rbuf[4];
@@ -513,10 +513,8 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret < 0)
 		goto err;
 
-	dev_info(&d->udev->dev,
-			"%s: prechip_version=%02x chip_version=%02x chip_type=%04x\n",
-			KBUILD_MODNAME, state->prechip_version,
-			state->chip_version, state->chip_type);
+	dev_info(&intf->dev, "prechip_version=%02x chip_version=%02x chip_type=%04x\n",
+		 state->prechip_version, state->chip_version, state->chip_type);
 
 	if (state->chip_type == 0x9135) {
 		if (state->chip_version == 0x02)
@@ -536,7 +534,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	if (ret < 0)
 		goto err;
 
-	dev_dbg(&d->udev->dev, "%s: reply=%*ph\n", __func__, 4, rbuf);
+	dev_dbg(&intf->dev, "reply=%*ph\n", 4, rbuf);
 	if (rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])
 		ret = WARM;
 	else
@@ -545,7 +543,7 @@ static int af9035_identify_state(struct dvb_usb_device *d, const char **name)
 	return ret;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -553,6 +551,7 @@ err:
 static int af9035_download_firmware_old(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
+	struct usb_interface *intf = d->intf;
 	int ret, i, j, len;
 	u8 wbuf[1];
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
@@ -583,14 +582,12 @@ static int af9035_download_firmware_old(struct dvb_usb_device *d,
 		hdr_checksum = fw->data[fw->size - i + 5] << 8;
 		hdr_checksum |= fw->data[fw->size - i + 6] << 0;
 
-		dev_dbg(&d->udev->dev,
-				"%s: core=%d addr=%04x data_len=%d checksum=%04x\n",
-				__func__, hdr_core, hdr_addr, hdr_data_len,
-				hdr_checksum);
+		dev_dbg(&intf->dev, "core=%d addr=%04x data_len=%d checksum=%04x\n",
+			hdr_core, hdr_addr, hdr_data_len, hdr_checksum);
 
 		if (((hdr_core != 1) && (hdr_core != 2)) ||
 				(hdr_data_len > i)) {
-			dev_dbg(&d->udev->dev, "%s: bad firmware\n", __func__);
+			dev_dbg(&intf->dev, "bad firmware\n");
 			break;
 		}
 
@@ -621,18 +618,17 @@ static int af9035_download_firmware_old(struct dvb_usb_device *d,
 
 		i -= hdr_data_len + HDR_SIZE;
 
-		dev_dbg(&d->udev->dev, "%s: data uploaded=%zu\n",
-				__func__, fw->size - i);
+		dev_dbg(&intf->dev, "data uploaded=%zu\n", fw->size - i);
 	}
 
 	/* print warn if firmware is bad, continue and see what happens */
 	if (i)
-		dev_warn(&d->udev->dev, "%s: bad firmware\n", KBUILD_MODNAME);
+		dev_warn(&intf->dev, "bad firmware\n");
 
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -640,6 +636,7 @@ err:
 static int af9035_download_firmware_new(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
+	struct usb_interface *intf = d->intf;
 	int ret, i, i_prev;
 	struct usb_req req_fw_dl = { CMD_FW_SCATTER_WR, 0, 0, NULL, 0, NULL };
 	#define HDR_SIZE 7
@@ -669,15 +666,14 @@ static int af9035_download_firmware_new(struct dvb_usb_device *d,
 			if (ret < 0)
 				goto err;
 
-			dev_dbg(&d->udev->dev, "%s: data uploaded=%d\n",
-					__func__, i);
+			dev_dbg(&intf->dev, "data uploaded=%d\n", i);
 		}
 	}
 
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -685,6 +681,7 @@ err:
 static int af9035_download_firmware(struct dvb_usb_device *d,
 		const struct firmware *fw)
 {
+	struct usb_interface *intf = d->intf;
 	struct state *state = d_to_priv(d);
 	int ret;
 	u8 wbuf[1];
@@ -693,7 +690,7 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 	struct usb_req req = { 0, 0, 0, NULL, 0, NULL };
 	struct usb_req req_fw_ver = { CMD_FW_QUERYINFO, 0, 1, wbuf, 4, rbuf };
 
-	dev_dbg(&d->udev->dev, "%s:\n", __func__);
+	dev_dbg(&intf->dev, "\n");
 
 	/*
 	 * In case of dual tuner configuration we need to do some extra
@@ -773,25 +770,25 @@ static int af9035_download_firmware(struct dvb_usb_device *d,
 		goto err;
 
 	if (!(rbuf[0] || rbuf[1] || rbuf[2] || rbuf[3])) {
-		dev_err(&d->udev->dev, "%s: firmware did not run\n",
-				KBUILD_MODNAME);
+		dev_err(&intf->dev, "firmware did not run\n");
 		ret = -ENODEV;
 		goto err;
 	}
 
-	dev_info(&d->udev->dev, "%s: firmware version=%d.%d.%d.%d",
-			KBUILD_MODNAME, rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
+	dev_info(&intf->dev, "firmware version=%d.%d.%d.%d",
+		 rbuf[0], rbuf[1], rbuf[2], rbuf[3]);
 
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
 
 static int af9035_read_config(struct dvb_usb_device *d)
 {
+	struct usb_interface *intf = d->intf;
 	struct state *state = d_to_priv(d);
 	int ret, i;
 	u8 tmp;
@@ -826,7 +823,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 			goto err;
 
 		if (tmp == 0x00) {
-			dev_dbg(&d->udev->dev, "%s: no eeprom\n", __func__);
+			dev_dbg(&intf->dev, "no eeprom\n");
 			goto skip_eeprom;
 		}
 	} else if (state->chip_type == 0x9306) {
@@ -847,8 +844,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 	if (tmp == 1 || tmp == 3 || tmp == 5)
 		state->dual_mode = true;
 
-	dev_dbg(&d->udev->dev, "%s: ts mode=%d dual mode=%d\n", __func__,
-			tmp, state->dual_mode);
+	dev_dbg(&intf->dev, "ts mode=%d dual mode=%d\n", tmp, state->dual_mode);
 
 	if (state->dual_mode) {
 		/* read 2nd demodulator I2C address */
@@ -861,8 +857,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (tmp)
 			state->af9033_i2c_addr[1] = tmp;
 
-		dev_dbg(&d->udev->dev, "%s: 2nd demod I2C addr=%02x\n",
-				__func__, tmp);
+		dev_dbg(&intf->dev, "2nd demod I2C addr=%02x\n", tmp);
 	}
 
 	addr = state->eeprom_addr;
@@ -873,8 +868,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		if (ret < 0)
 			goto err;
 
-		dev_dbg(&d->udev->dev, "%s: [%d]tuner=%02x\n",
-				__func__, i, tmp);
+		dev_dbg(&intf->dev, "[%d]tuner=%02x\n", i, tmp);
 
 		/* tuner sanity check */
 		if (state->chip_type == 0x9135) {
@@ -903,10 +897,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		}
 
 		if (state->af9033_config[i].tuner != tmp) {
-			dev_info(&d->udev->dev,
-					"%s: [%d] overriding tuner from %02x to %02x\n",
-					KBUILD_MODNAME, i, tmp,
-					state->af9033_config[i].tuner);
+			dev_info(&intf->dev, "[%d] overriding tuner from %02x to %02x\n",
+				 i, tmp, state->af9033_config[i].tuner);
 		}
 
 		switch (state->af9033_config[i].tuner) {
@@ -926,9 +918,8 @@ static int af9035_read_config(struct dvb_usb_device *d)
 		case AF9033_TUNER_IT9135_62:
 			break;
 		default:
-			dev_warn(&d->udev->dev,
-					"%s: tuner id=%02x not supported, please report!",
-					KBUILD_MODNAME, tmp);
+			dev_warn(&intf->dev, "tuner id=%02x not supported, please report!",
+				 tmp);
 		}
 
 		/* disable dual mode if driver does not support it */
@@ -945,9 +936,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 				break;
 			default:
 				state->dual_mode = false;
-				dev_info(&d->udev->dev,
-						"%s: driver does not support 2nd tuner and will disable it",
-						KBUILD_MODNAME);
+				dev_info(&intf->dev, "driver does not support 2nd tuner and will disable it");
 		}
 
 		/* tuner IF frequency */
@@ -963,7 +952,7 @@ static int af9035_read_config(struct dvb_usb_device *d)
 
 		tmp16 |= tmp << 8;
 
-		dev_dbg(&d->udev->dev, "%s: [%d]IF=%d\n", __func__, i, tmp16);
+		dev_dbg(&intf->dev, "[%d]IF=%d\n", i, tmp16);
 
 		addr += 0x10; /* shift for the 2nd tuner params */
 	}
@@ -991,9 +980,8 @@ skip_eeprom:
 		switch (le16_to_cpu(d->udev->descriptor.idProduct)) {
 		case USB_PID_AVERMEDIA_A867:
 		case USB_PID_AVERMEDIA_TWINSTAR:
-			dev_info(&d->udev->dev,
-				"%s: Device may have issues with I2C read operations. Enabling fix.\n",
-				KBUILD_MODNAME);
+			dev_info(&intf->dev,
+				 "Device may have issues with I2C read operations. Enabling fix.\n");
 			state->no_read = true;
 			break;
 		}
@@ -1001,7 +989,7 @@ skip_eeprom:
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1009,10 +997,11 @@ err:
 static int af9035_tua9001_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 val;
 
-	dev_dbg(&d->udev->dev, "%s: cmd=%d arg=%d\n", __func__, cmd, arg);
+	dev_dbg(&intf->dev, "cmd=%d arg=%d\n", cmd, arg);
 
 	/*
 	 * CEN     always enabled by hardware wiring
@@ -1046,7 +1035,7 @@ static int af9035_tua9001_tuner_callback(struct dvb_usb_device *d,
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1055,6 +1044,7 @@ err:
 static int af9035_fc0011_tuner_callback(struct dvb_usb_device *d,
 		int cmd, int arg)
 {
+	struct usb_interface *intf = d->intf;
 	int ret;
 
 	switch (cmd) {
@@ -1112,7 +1102,7 @@ static int af9035_fc0011_tuner_callback(struct dvb_usb_device *d,
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1138,9 +1128,10 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 {
 	struct i2c_adapter *adap = adapter_priv;
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
+	struct usb_interface *intf = d->intf;
 
-	dev_dbg(&d->udev->dev, "%s: component=%d cmd=%d arg=%d\n",
-			__func__, component, cmd, arg);
+	dev_dbg(&intf->dev, "component=%d cmd=%d arg=%d\n",
+		component, cmd, arg);
 
 	switch (component) {
 	case DVB_FRONTEND_COMPONENT_TUNER:
@@ -1163,9 +1154,10 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
 
-	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	if (!state->af9033_config[adap->id].tuner) {
 		/* unsupported tuner */
@@ -1192,7 +1184,7 @@ static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1201,11 +1193,12 @@ static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	struct si2168_config si2168_config;
 	struct i2c_adapter *adapter;
 
-	dev_dbg(&d->udev->dev, "adap->id=%d\n", adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	memset(&si2168_config, 0, sizeof(si2168_config));
 	si2168_config.i2c_adapter = &adapter;
@@ -1228,7 +1221,7 @@ static int it930x_frontend_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1237,9 +1230,10 @@ static int af9035_frontend_detach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int demod2;
 
-	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	/*
 	 * For dual tuner devices we have to resolve 2nd demod client, as there
@@ -1315,12 +1309,13 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	struct dvb_frontend *fe;
 	struct i2c_msg msg[1];
 	u8 tuner_addr;
 
-	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	/*
 	 * XXX: Hack used in that function: we abuse unused I2C address bit [7]
@@ -1558,7 +1553,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1567,10 +1562,11 @@ static int it930x_tuner_attach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	struct si2157_config si2157_config;
 
-	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	/* I2C master bus 2 clock speed 300k */
 	ret = af9035_wr_reg(d, 0x00f6a7, 0x07);
@@ -1626,7 +1622,7 @@ static int it930x_tuner_attach(struct dvb_usb_adapter *adap)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1636,8 +1632,9 @@ static int it930x_tuner_detach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 
-	dev_dbg(&d->udev->dev, "adap->id=%d\n", adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	if (adap->id == 1) {
 		if (state->i2c_client[3])
@@ -1655,8 +1652,9 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 {
 	struct state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
+	struct usb_interface *intf = d->intf;
 
-	dev_dbg(&d->udev->dev, "%s: adap->id=%d\n", __func__, adap->id);
+	dev_dbg(&intf->dev, "adap->id=%d\n", adap->id);
 
 	switch (state->af9033_config[adap->id].tuner) {
 	case AF9033_TUNER_TUA9001:
@@ -1682,6 +1680,7 @@ static int af9035_tuner_detach(struct dvb_usb_adapter *adap)
 static int af9035_init(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret, i;
 	u16 frame_size = (d->udev->speed == USB_SPEED_FULL ? 5 : 87) * 188 / 4;
 	u8 packet_size = (d->udev->speed == USB_SPEED_FULL ? 64 : 512) / 4;
@@ -1706,9 +1705,8 @@ static int af9035_init(struct dvb_usb_device *d)
 		{ 0x80f9a4, 0x00, 0x01 },
 	};
 
-	dev_dbg(&d->udev->dev,
-			"%s: USB speed=%d frame_size=%04x packet_size=%02x\n",
-			__func__, d->udev->speed, frame_size, packet_size);
+	dev_dbg(&intf->dev, "USB speed=%d frame_size=%04x packet_size=%02x\n",
+		d->udev->speed, frame_size, packet_size);
 
 	/* init endpoints */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
@@ -1721,7 +1719,7 @@ static int af9035_init(struct dvb_usb_device *d)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1729,6 +1727,7 @@ err:
 static int it930x_init(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret, i;
 	u16 frame_size = (d->udev->speed == USB_SPEED_FULL ? 5 : 816) * 188 / 4;
 	u8 packet_size = (d->udev->speed == USB_SPEED_FULL ? 64 : 512) / 4;
@@ -1788,9 +1787,8 @@ static int it930x_init(struct dvb_usb_device *d)
 		{ 0x00da5a, 0x1f, 0xff }, /* ts_fail_ignore */
 	};
 
-	dev_dbg(&d->udev->dev,
-			"%s: USB speed=%d frame_size=%04x packet_size=%02x\n",
-			__func__, d->udev->speed, frame_size, packet_size);
+	dev_dbg(&intf->dev, "USB speed=%d frame_size=%04x packet_size=%02x\n",
+		d->udev->speed, frame_size, packet_size);
 
 	/* init endpoints */
 	for (i = 0; i < ARRAY_SIZE(tab); i++) {
@@ -1803,7 +1801,7 @@ static int it930x_init(struct dvb_usb_device *d)
 
 	return 0;
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1812,6 +1810,7 @@ err:
 #if IS_ENABLED(CONFIG_RC_CORE)
 static int af9035_rc_query(struct dvb_usb_device *d)
 {
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u32 key;
 	u8 buf[4];
@@ -1837,14 +1836,14 @@ static int af9035_rc_query(struct dvb_usb_device *d)
 					buf[2] << 8  | buf[3]);
 	}
 
-	dev_dbg(&d->udev->dev, "%s: %*ph\n", __func__, 4, buf);
+	dev_dbg(&intf->dev, "%*ph\n", 4, buf);
 
 	rc_keydown(d->rc_dev, RC_TYPE_NEC, key, 0);
 
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1852,6 +1851,7 @@ err:
 static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 {
 	struct state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
 	int ret;
 	u8 tmp;
 
@@ -1859,7 +1859,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	if (ret < 0)
 		goto err;
 
-	dev_dbg(&d->udev->dev, "%s: ir_mode=%02x\n", __func__, tmp);
+	dev_dbg(&intf->dev, "ir_mode=%02x\n", tmp);
 
 	/* don't activate rc if in HID mode or if not available */
 	if (tmp == 5) {
@@ -1868,7 +1868,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 		if (ret < 0)
 			goto err;
 
-		dev_dbg(&d->udev->dev, "%s: ir_type=%02x\n", __func__, tmp);
+		dev_dbg(&intf->dev, "ir_type=%02x\n", tmp);
 
 		switch (tmp) {
 		case 0: /* NEC */
@@ -1891,7 +1891,7 @@ static int af9035_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	return 0;
 
 err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+	dev_dbg(&intf->dev, "failed=%d\n", ret);
 
 	return ret;
 }
@@ -1903,8 +1903,9 @@ static int af9035_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 		struct usb_data_stream_properties *stream)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
+	struct usb_interface *intf = d->intf;
 
-	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
+	dev_dbg(&intf->dev, "adap=%d\n", fe_to_adap(fe)->id);
 
 	if (d->udev->speed == USB_SPEED_FULL)
 		stream->u.bulk.buffersize = 5 * 188;
@@ -1956,7 +1957,7 @@ static int af9035_probe(struct usb_interface *intf,
 	if ((le16_to_cpu(udev->descriptor.idVendor) == USB_VID_TERRATEC) &&
 			(le16_to_cpu(udev->descriptor.idProduct) == 0x0099)) {
 		if (!strcmp("Afatech", manufacturer)) {
-			dev_dbg(&udev->dev, "%s: rejecting device\n", __func__);
+			dev_dbg(&udev->dev, "rejecting device\n");
 			return -ENODEV;
 		}
 	}
-- 
http://palosaari.fi/

