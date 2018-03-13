Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:32859 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932843AbeCMXkR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:17 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 18/18] af9015: correct some coding style issues
Date: Wed, 14 Mar 2018 01:39:44 +0200
Message-Id: <20180313233944.7234-18-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Correct coding style issues reported mostly by checkpatch.pl.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 172 +++++++++++++++++-----------------
 1 file changed, 88 insertions(+), 84 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 8379ef164fad..39f9ffce3caa 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -72,17 +72,19 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 		goto error;
 	}
 
-	/* buffer overflow check */
+	/* Buffer overflow check */
 	if ((write && (req->data_len > BUF_LEN - REQ_HDR_LEN)) ||
-			(!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
+	    (!write && (req->data_len > BUF_LEN - ACK_HDR_LEN))) {
 		dev_err(&intf->dev, "too much data, cmd %u, len %u\n",
 			req->cmd, req->data_len);
 		ret = -EINVAL;
 		goto error;
 	}
 
-	/* write receives seq + status = 2 bytes
-	   read receives seq + status + data = 2 + N bytes */
+	/*
+	 * Write receives seq + status = 2 bytes
+	 * Read receives seq + status + data = 2 + N bytes
+	 */
 	wlen = REQ_HDR_LEN;
 	rlen = ACK_HDR_LEN;
 	if (write) {
@@ -96,8 +98,8 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 	if (req->cmd == DOWNLOAD_FIRMWARE || req->cmd == RECONNECT_USB)
 		rlen = 0;
 
-	ret = dvb_usbv2_generic_rw_locked(d,
-			state->buf, wlen, state->buf, rlen);
+	ret = dvb_usbv2_generic_rw_locked(d, state->buf, wlen,
+					  state->buf, rlen);
 	if (ret)
 		goto error;
 
@@ -118,7 +120,7 @@ static int af9015_ctrl_msg(struct dvb_usb_device *d, struct req_t *req)
 }
 
 static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
-	u8 val)
+				u8 val)
 {
 	struct af9015_state *state = d_to_priv(d);
 	struct req_t req = {WRITE_I2C, addr, reg, 1, 1, 1, &val};
@@ -131,7 +133,7 @@ static int af9015_write_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 }
 
 static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
-	u8 *val)
+			       u8 *val)
 {
 	struct af9015_state *state = d_to_priv(d);
 	struct req_t req = {READ_I2C, addr, reg, 0, 1, 1, val};
@@ -144,7 +146,7 @@ static int af9015_read_reg_i2c(struct dvb_usb_device *d, u8 addr, u16 reg,
 }
 
 static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
-	int num)
+			   int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct af9015_state *state = d_to_priv(d);
@@ -154,28 +156,29 @@ static int af9015_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	u8 mbox, addr_len;
 	struct req_t req;
 
-/*
-The bus lock is needed because there is two tuners both using same I2C-address.
-Due to that the only way to select correct tuner is use demodulator I2C-gate.
-
-................................................
-. AF9015 includes integrated AF9013 demodulator.
-. ____________                   ____________  .                ____________
-.|     uC     |                 |   demod    | .               |    tuner   |
-.|------------|                 |------------| .               |------------|
-.|   AF9015   |                 |  AF9013/5  | .               |   MXL5003  |
-.|            |--+----I2C-------|-----/ -----|-.-----I2C-------|            |
-.|            |  |              | addr 0x38  | .               |  addr 0xc6 |
-.|____________|  |              |____________| .               |____________|
-.................|..............................
-		 |               ____________                   ____________
-		 |              |   demod    |                 |    tuner   |
-		 |              |------------|                 |------------|
-		 |              |   AF9013   |                 |   MXL5003  |
-		 +----I2C-------|-----/ -----|-------I2C-------|            |
-				| addr 0x3a  |                 |  addr 0xc6 |
-				|____________|                 |____________|
-*/
+	/*
+	 * I2C multiplexing:
+	 * There could be two tuners, both using same I2C address. Demodulator
+	 * I2C-gate is only possibility to select correct tuner.
+	 *
+	 * ...........................................
+	 * . AF9015 integrates AF9013 demodulator    .
+	 * . ____________               ____________ .             ____________
+	 * .|   USB IF   |             |   demod    |.            |   tuner    |
+	 * .|------------|             |------------|.            |------------|
+	 * .|   AF9015   |             |   AF9013   |.            |   MXL5003  |
+	 * .|            |--+--I2C-----|-----/ -----|.----I2C-----|            |
+	 * .|            |  |          | addr 0x1c  |.            |  addr 0x63 |
+	 * .|____________|  |          |____________|.            |____________|
+	 * .................|.........................
+	 *                  |           ____________               ____________
+	 *                  |          |   demod    |             |   tuner    |
+	 *                  |          |------------|             |------------|
+	 *                  |          |   AF9013   |             |   MXL5003  |
+	 *                  +--I2C-----|-----/ -----|-----I2C-----|            |
+	 *                             | addr 0x1d  |             |  addr 0x63 |
+	 *                             |____________|             |____________|
+	 */
 
 	if (msg[0].len == 0 || msg[0].flags & I2C_M_RD) {
 		addr = 0x0000;
@@ -186,11 +189,11 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 		mbox = 0;
 		addr_len = 1;
 	} else if (msg[0].len == 2) {
-		addr = msg[0].buf[0] << 8|msg[0].buf[1] << 0;
+		addr = msg[0].buf[0] << 8 | msg[0].buf[1] << 0;
 		mbox = 0;
 		addr_len = 2;
 	} else {
-		addr = msg[0].buf[0] << 8|msg[0].buf[1] << 0;
+		addr = msg[0].buf[0] << 8 | msg[0].buf[1] << 0;
 		mbox = msg[0].buf[2];
 		addr_len = 3;
 	}
@@ -209,7 +212,7 @@ Due to that the only way to select correct tuner is use demodulator I2C-gate.
 		req.addr = addr;
 		req.mbox = mbox;
 		req.addr_len = addr_len;
-		req.data_len = msg[0].len-addr_len;
+		req.data_len = msg[0].len - addr_len;
 		req.data = &msg[0].buf[addr_len];
 		ret = af9015_ctrl_msg(d, &req);
 	} else if (num == 2 && !(msg[0].flags & I2C_M_RD) &&
@@ -313,7 +316,7 @@ static int af9015_download_firmware(struct dvb_usb_device *d,
 	#define LEN_MAX (BUF_LEN - REQ_HDR_LEN) /* Max payload size */
 	for (rem = firmware->size; rem > 0; rem -= LEN_MAX) {
 		req.data_len = min(LEN_MAX, rem);
-		req.data = (u8 *) &firmware->data[firmware->size - rem];
+		req.data = (u8 *)&firmware->data[firmware->size - rem];
 		req.addr = 0x5100 + firmware->size - rem;
 		ret = af9015_ctrl_msg(d, &req);
 		if (ret) {
@@ -522,14 +525,14 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	if (ret)
 		dev_err(&intf->dev, "eeprom read failed %d\n", ret);
 
-	/* AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
-	   content :-( Override some wrong values here. Ditto for the
-	   AVerTV Red HD+ (A850T) device. */
+	/*
+	 * AverMedia AVerTV Volar Black HD (A850) device have bad EEPROM
+	 * content :-( Override some wrong values here. Ditto for the
+	 * AVerTV Red HD+ (A850T) device.
+	 */
 	if (le16_to_cpu(d->udev->descriptor.idVendor) == USB_VID_AVERMEDIA &&
-		((le16_to_cpu(d->udev->descriptor.idProduct) ==
-			USB_PID_AVERMEDIA_A850) ||
-		(le16_to_cpu(d->udev->descriptor.idProduct) ==
-			USB_PID_AVERMEDIA_A850T))) {
+	    ((le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850) ||
+	    (le16_to_cpu(d->udev->descriptor.idProduct) == USB_PID_AVERMEDIA_A850T))) {
 		dev_dbg(&intf->dev, "AverMedia A850: overriding config\n");
 		/* disable dual mode */
 		state->dual_mode = 0;
@@ -542,7 +545,7 @@ static int af9015_read_config(struct dvb_usb_device *d)
 }
 
 static int af9015_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
-		struct usb_data_stream_properties *stream)
+				    struct usb_data_stream_properties *stream)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
 	struct usb_interface *intf = d->intf;
@@ -567,7 +570,7 @@ static int af9015_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 
 	dev_dbg(&intf->dev, "adap id %d, onoff %d\n", adap_id, onoff);
 
-	if (state->usb_ts_if_configured[adap_id] == false) {
+	if (!state->usb_ts_if_configured[adap_id]) {
 		dev_dbg(&intf->dev, "set usb and ts interface\n");
 
 		/* USB IF stream settings */
@@ -665,6 +668,7 @@ static int af9015_streaming_ctrl(struct dvb_frontend *fe, int onoff)
 static int af9015_get_adapter_count(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
+
 	return state->dual_mode + 1;
 }
 
@@ -686,7 +690,7 @@ static int af9015_af9013_set_frontend(struct dvb_frontend *fe)
 
 /* override demod callbacks for resource locking */
 static int af9015_af9013_read_status(struct dvb_frontend *fe,
-	enum fe_status *status)
+				     enum fe_status *status)
 {
 	int ret;
 	struct af9015_state *state = fe_to_priv(fe);
@@ -905,19 +909,12 @@ static int af9015_af9013_frontend_attach(struct dvb_usb_adapter *adap)
 	 * those "critical" paths to keep AF9015 happy.
 	 */
 	if (adap->fe[0]) {
-		state->set_frontend[adap->id] =
-			adap->fe[0]->ops.set_frontend;
-		adap->fe[0]->ops.set_frontend =
-			af9015_af9013_set_frontend;
-
-		state->read_status[adap->id] =
-			adap->fe[0]->ops.read_status;
-		adap->fe[0]->ops.read_status =
-			af9015_af9013_read_status;
-
+		state->set_frontend[adap->id] = adap->fe[0]->ops.set_frontend;
+		adap->fe[0]->ops.set_frontend = af9015_af9013_set_frontend;
+		state->read_status[adap->id] = adap->fe[0]->ops.read_status;
+		adap->fe[0]->ops.read_status = af9015_af9013_read_status;
 		state->init[adap->id] = adap->fe[0]->ops.init;
 		adap->fe[0]->ops.init = af9015_af9013_init;
-
 		state->sleep[adap->id] = adap->fe[0]->ops.sleep;
 		adap->fe[0]->ops.sleep = af9015_af9013_sleep;
 	}
@@ -1025,42 +1022,42 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 	case AF9013_TUNER_MT2060:
 	case AF9013_TUNER_MT2060_2:
 		ret = dvb_attach(mt2060_attach, adap->fe[0], adapter,
-			&af9015_mt2060_config,
-			state->mt2060_if1[adap->id]) == NULL ? -ENODEV : 0;
+				 &af9015_mt2060_config,
+				 state->mt2060_if1[adap->id]) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_QT1010:
 	case AF9013_TUNER_QT1010A:
 		ret = dvb_attach(qt1010_attach, adap->fe[0], adapter,
-			&af9015_qt1010_config) == NULL ? -ENODEV : 0;
+				 &af9015_qt1010_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18271:
 		ret = dvb_attach(tda18271_attach, adap->fe[0], 0x60, adapter,
-			&af9015_tda18271_config) == NULL ? -ENODEV : 0;
+				 &af9015_tda18271_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_TDA18218:
 		ret = dvb_attach(tda18218_attach, adap->fe[0], adapter,
-			&af9015_tda18218_config) == NULL ? -ENODEV : 0;
+				 &af9015_tda18218_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5003D:
 		ret = dvb_attach(mxl5005s_attach, adap->fe[0], adapter,
-			&af9015_mxl5003_config) == NULL ? -ENODEV : 0;
+				 &af9015_mxl5003_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5005D:
 	case AF9013_TUNER_MXL5005R:
 		ret = dvb_attach(mxl5005s_attach, adap->fe[0], adapter,
-			&af9015_mxl5005_config) == NULL ? -ENODEV : 0;
+				 &af9015_mxl5005_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_ENV77H11D5:
 		ret = dvb_attach(dvb_pll_attach, adap->fe[0], 0x60, adapter,
-			DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
+				 DVB_PLL_TDA665X) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MC44S803:
 		ret = dvb_attach(mc44s803_attach, adap->fe[0], adapter,
-			&af9015_mc44s803_config) == NULL ? -ENODEV : 0;
+				 &af9015_mc44s803_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_MXL5007T:
 		ret = dvb_attach(mxl5007t_attach, adap->fe[0], adapter,
-			0x60, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
+				 0x60, &af9015_mxl5007t_config) == NULL ? -ENODEV : 0;
 		break;
 	case AF9013_TUNER_UNKNOWN:
 	default:
@@ -1137,7 +1134,7 @@ struct af9015_rc_setup {
 };
 
 static char *af9015_rc_setup_match(unsigned int id,
-	const struct af9015_rc_setup *table)
+				   const struct af9015_rc_setup *table)
 {
 	for (; table->rc_codes; table++)
 		if (table->id == id)
@@ -1182,7 +1179,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 	/* Check for repeat of previous code */
 	if ((state->rc_repeat != buf[6] || buf[0]) &&
-			!memcmp(&buf[12], state->rc_last, 4)) {
+	    !memcmp(&buf[12], state->rc_last, 4)) {
 		dev_dbg(&intf->dev, "key repeated\n");
 		rc_repeat(d->rc_dev);
 		state->rc_repeat = buf[6];
@@ -1192,6 +1189,7 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 	/* Only process key if canary killed */
 	if (buf[16] != 0xff && buf[0] != 0x01) {
 		enum rc_proto proto;
+
 		dev_dbg(&intf->dev, "key pressed %*ph\n", 4, buf + 12);
 
 		/* Reset the canary */
@@ -1201,8 +1199,8 @@ static int af9015_rc_query(struct dvb_usb_device *d)
 
 		/* Remember this key */
 		memcpy(state->rc_last, &buf[12], 4);
-		if (buf[14] == (u8) ~buf[15]) {
-			if (buf[12] == (u8) ~buf[13]) {
+		if (buf[14] == (u8)~buf[15]) {
+			if (buf[12] == (u8)~buf[13]) {
 				/* NEC */
 				state->rc_keycode = RC_SCANCODE_NEC(buf[12],
 								    buf[14]);
@@ -1258,29 +1256,33 @@ static int af9015_get_rc_config(struct dvb_usb_device *d, struct dvb_usb_rc *rc)
 	/* try to load remote based module param */
 	if (!rc->map_name)
 		rc->map_name = af9015_rc_setup_match(dvb_usb_af9015_remote,
-				af9015_rc_setup_modparam);
+						     af9015_rc_setup_modparam);
 
 	/* try to load remote based eeprom hash */
 	if (!rc->map_name)
 		rc->map_name = af9015_rc_setup_match(state->eeprom_sum,
-				af9015_rc_setup_hashes);
+						     af9015_rc_setup_hashes);
 
 	/* try to load remote based USB iManufacturer string */
 	if (!rc->map_name && vid == USB_VID_AFATECH) {
-		/* Check USB manufacturer and product strings and try
-		   to determine correct remote in case of chip vendor
-		   reference IDs are used.
-		   DO NOT ADD ANYTHING NEW HERE. Use hashes instead. */
+		/*
+		 * Check USB manufacturer and product strings and try
+		 * to determine correct remote in case of chip vendor
+		 * reference IDs are used.
+		 * DO NOT ADD ANYTHING NEW HERE. Use hashes instead.
+		 */
 		char manufacturer[10];
+
 		memset(manufacturer, 0, sizeof(manufacturer));
 		usb_string(d->udev, d->udev->descriptor.iManufacturer,
-			manufacturer, sizeof(manufacturer));
+			   manufacturer, sizeof(manufacturer));
 		if (!strcmp("MSI", manufacturer)) {
-			/* iManufacturer 1 MSI
-			   iProduct      2 MSI K-VOX */
-			rc->map_name = af9015_rc_setup_match(
-					AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
-					af9015_rc_setup_modparam);
+			/*
+			 * iManufacturer 1 MSI
+			 * iProduct      2 MSI K-VOX
+			 */
+			rc->map_name = af9015_rc_setup_match(AF9015_REMOTE_MSI_DIGIVOX_MINI_II_V3,
+							     af9015_rc_setup_modparam);
 		}
 	}
 
@@ -1409,8 +1411,10 @@ static void af9015_disconnect(struct dvb_usb_device *d)
 	regmap_exit(state->regmap);
 }
 
-/* interface 0 is used by DVB-T receiver and
-   interface 1 is for remote controller (HID) */
+/*
+ * Interface 0 is used by DVB-T receiver and
+ * interface 1 is for remote controller (HID)
+ */
 static const struct dvb_usb_device_properties af9015_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
-- 
2.14.3
