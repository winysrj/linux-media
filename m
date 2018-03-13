Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:60265 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932443AbeCMXkQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:16 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 15/18] af9015: enhance streaming config
Date: Wed, 14 Mar 2018 01:39:41 +0200
Message-Id: <20180313233944.7234-15-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Replace static stream settings by one which enables and disables
stream interface when needed (TS streaming control).

1) Configure both TS IF and USB endpoints according to current use case

2) Disable streaming USB endpoints when streaming is stopped and
enable when streaming is started. Reduces sleep power consumption
slightly.

3) Reduce USB buffersize slightly, from 130848 to 98136 bytes

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 220 ++++++++++++++++++----------------
 drivers/media/usb/dvb-usb-v2/af9015.h |  14 +--
 2 files changed, 115 insertions(+), 119 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index 1f352307a00a..99e3b14d493e 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -607,11 +607,121 @@ static int af9015_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 	dev_dbg(&intf->dev, "adap %u\n", fe_to_adap(fe)->id);
 
 	if (d->udev->speed == USB_SPEED_FULL)
-		stream->u.bulk.buffersize = TS_USB11_FRAME_SIZE;
+		stream->u.bulk.buffersize = 5 * 188;
 
 	return 0;
 }
 
+static int af9015_streaming_ctrl(struct dvb_frontend *fe, int onoff)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	struct af9015_state *state = d_to_priv(d);
+	struct usb_interface *intf = d->intf;
+	int ret;
+	unsigned int utmp1, utmp2, reg1, reg2;
+	u8 buf[2];
+	const unsigned int adap_id = fe_to_adap(fe)->id;
+
+	dev_dbg(&intf->dev, "adap id %d, onoff %d\n", adap_id, onoff);
+
+	if (state->usb_ts_if_configured[adap_id] == false) {
+		dev_dbg(&intf->dev, "set usb and ts interface\n");
+
+		/* USB IF stream settings */
+		utmp1 = (d->udev->speed == USB_SPEED_FULL ? 5 : 87) * 188 / 4;
+		utmp2 = (d->udev->speed == USB_SPEED_FULL ? 64 : 512) / 4;
+
+		buf[0] = (utmp1 >> 0) & 0xff;
+		buf[1] = (utmp1 >> 8) & 0xff;
+		if (adap_id == 0) {
+			/* 1st USB IF (EP4) stream settings */
+			reg1 = 0xdd88;
+			reg2 = 0xdd0c;
+		} else {
+			/* 2nd USB IF (EP5) stream settings */
+			reg1 = 0xdd8a;
+			reg2 = 0xdd0d;
+		}
+
+		ret = af9015_write_regs(d, reg1, buf, 2);
+		if (ret)
+			goto err;
+		ret = af9015_write_reg(d, reg2, utmp2);
+		if (ret)
+			goto err;
+
+		/* TS IF settings */
+		if (state->dual_mode) {
+			ret = af9015_set_reg_bit(d, 0xd50b, 0);
+			if (ret)
+				goto err;
+			ret = af9015_set_reg_bit(d, 0xd520, 4);
+			if (ret)
+				goto err;
+		} else {
+			ret = af9015_clear_reg_bit(d, 0xd50b, 0);
+			if (ret)
+				goto err;
+			ret = af9015_clear_reg_bit(d, 0xd520, 4);
+			if (ret)
+				goto err;
+		}
+
+		state->usb_ts_if_configured[adap_id] = true;
+	}
+
+	if (adap_id == 0 && onoff) {
+		/* Adapter 0 stream on. EP4: clear NAK, enable, clear reset */
+		ret = af9015_clear_reg_bit(d, 0xdd13, 5);
+		if (ret)
+			goto err;
+		ret = af9015_set_reg_bit(d, 0xdd11, 5);
+		if (ret)
+			goto err;
+		ret = af9015_clear_reg_bit(d, 0xd507, 2);
+		if (ret)
+			goto err;
+	} else if (adap_id == 1 && onoff) {
+		/* Adapter 1 stream on. EP5: clear NAK, enable, clear reset */
+		ret = af9015_clear_reg_bit(d, 0xdd13, 6);
+		if (ret)
+			goto err;
+		ret = af9015_set_reg_bit(d, 0xdd11, 6);
+		if (ret)
+			goto err;
+		ret = af9015_clear_reg_bit(d, 0xd50b, 1);
+		if (ret)
+			goto err;
+	} else if (adap_id == 0 && !onoff) {
+		/* Adapter 0 stream off. EP4: set reset, disable, set NAK */
+		ret = af9015_set_reg_bit(d, 0xd507, 2);
+		if (ret)
+			goto err;
+		ret = af9015_clear_reg_bit(d, 0xdd11, 5);
+		if (ret)
+			goto err;
+		ret = af9015_set_reg_bit(d, 0xdd13, 5);
+		if (ret)
+			goto err;
+	} else if (adap_id == 1 && !onoff) {
+		/* Adapter 1 stream off. EP5: set reset, disable, set NAK */
+		ret = af9015_set_reg_bit(d, 0xd50b, 1);
+		if (ret)
+			goto err;
+		ret = af9015_clear_reg_bit(d, 0xdd11, 6);
+		if (ret)
+			goto err;
+		ret = af9015_set_reg_bit(d, 0xdd13, 6);
+		if (ret)
+			goto err;
+	}
+
+	return 0;
+err:
+	dev_dbg(&intf->dev, "failed %d\n", ret);
+	return ret;
+}
+
 static int af9015_get_adapter_count(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
@@ -1061,105 +1171,6 @@ static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index,
 	return ret;
 }
 
-static int af9015_init_endpoint(struct dvb_usb_device *d)
-{
-	struct af9015_state *state = d_to_priv(d);
-	struct usb_interface *intf = d->intf;
-	int ret;
-	u16 frame_size;
-	u8  packet_size;
-
-	dev_dbg(&intf->dev, "usb speed %u\n", d->udev->speed);
-
-	if (d->udev->speed == USB_SPEED_FULL) {
-		frame_size = TS_USB11_FRAME_SIZE/4;
-		packet_size = TS_USB11_MAX_PACKET_SIZE/4;
-	} else {
-		frame_size = TS_USB20_FRAME_SIZE/4;
-		packet_size = TS_USB20_MAX_PACKET_SIZE/4;
-	}
-
-	ret = af9015_set_reg_bit(d, 0xd507, 2); /* assert EP4 reset */
-	if (ret)
-		goto error;
-	ret = af9015_set_reg_bit(d, 0xd50b, 1); /* assert EP5 reset */
-	if (ret)
-		goto error;
-	ret = af9015_clear_reg_bit(d, 0xdd11, 5); /* disable EP4 */
-	if (ret)
-		goto error;
-	ret = af9015_clear_reg_bit(d, 0xdd11, 6); /* disable EP5 */
-	if (ret)
-		goto error;
-	ret = af9015_set_reg_bit(d, 0xdd11, 5); /* enable EP4 */
-	if (ret)
-		goto error;
-	if (state->dual_mode) {
-		ret = af9015_set_reg_bit(d, 0xdd11, 6); /* enable EP5 */
-		if (ret)
-			goto error;
-	}
-	ret = af9015_clear_reg_bit(d, 0xdd13, 5); /* disable EP4 NAK */
-	if (ret)
-		goto error;
-	if (state->dual_mode) {
-		ret = af9015_clear_reg_bit(d, 0xdd13, 6); /* disable EP5 NAK */
-		if (ret)
-			goto error;
-	}
-	/* EP4 xfer length */
-	ret = af9015_write_reg(d, 0xdd88, frame_size & 0xff);
-	if (ret)
-		goto error;
-	ret = af9015_write_reg(d, 0xdd89, frame_size >> 8);
-	if (ret)
-		goto error;
-	/* EP5 xfer length */
-	ret = af9015_write_reg(d, 0xdd8a, frame_size & 0xff);
-	if (ret)
-		goto error;
-	ret = af9015_write_reg(d, 0xdd8b, frame_size >> 8);
-	if (ret)
-		goto error;
-	ret = af9015_write_reg(d, 0xdd0c, packet_size); /* EP4 packet size */
-	if (ret)
-		goto error;
-	ret = af9015_write_reg(d, 0xdd0d, packet_size); /* EP5 packet size */
-	if (ret)
-		goto error;
-	ret = af9015_clear_reg_bit(d, 0xd507, 2); /* negate EP4 reset */
-	if (ret)
-		goto error;
-	if (state->dual_mode) {
-		ret = af9015_clear_reg_bit(d, 0xd50b, 1); /* negate EP5 reset */
-		if (ret)
-			goto error;
-	}
-
-	/* enable / disable mp2if2 */
-	if (state->dual_mode) {
-		ret = af9015_set_reg_bit(d, 0xd50b, 0);
-		if (ret)
-			goto error;
-		ret = af9015_set_reg_bit(d, 0xd520, 4);
-		if (ret)
-			goto error;
-	} else {
-		ret = af9015_clear_reg_bit(d, 0xd50b, 0);
-		if (ret)
-			goto error;
-		ret = af9015_clear_reg_bit(d, 0xd520, 4);
-		if (ret)
-			goto error;
-	}
-
-error:
-	if (ret)
-		dev_err(&intf->dev, "endpoint init failed %d\n", ret);
-
-	return ret;
-}
-
 static int af9015_init(struct dvb_usb_device *d)
 {
 	struct af9015_state *state = d_to_priv(d);
@@ -1175,10 +1186,6 @@ static int af9015_init(struct dvb_usb_device *d)
 	if (ret)
 		goto error;
 
-	ret = af9015_init_endpoint(d);
-	if (ret)
-		goto error;
-
 error:
 	return ret;
 }
@@ -1412,6 +1419,7 @@ static struct dvb_usb_device_properties af9015_props = {
 	.init = af9015_init,
 	.get_rc_config = af9015_get_rc_config,
 	.get_stream_config = af9015_get_stream_config,
+	.streaming_ctrl = af9015_streaming_ctrl,
 
 	.get_adapter_count = af9015_get_adapter_count,
 	.adapter = {
@@ -1422,7 +1430,7 @@ static struct dvb_usb_device_properties af9015_props = {
 			.pid_filter = af9015_pid_filter,
 			.pid_filter_ctrl = af9015_pid_filter_ctrl,
 
-			.stream = DVB_USB_STREAM_BULK(0x84, 8, TS_USB20_FRAME_SIZE),
+			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
 		}, {
 			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
@@ -1430,7 +1438,7 @@ static struct dvb_usb_device_properties af9015_props = {
 			.pid_filter = af9015_pid_filter,
 			.pid_filter_ctrl = af9015_pid_filter_ctrl,
 
-			.stream = DVB_USB_STREAM_BULK(0x85, 8, TS_USB20_FRAME_SIZE),
+			.stream = DVB_USB_STREAM_BULK(0x85, 6, 87 * 188),
 		},
 	},
 };
diff --git a/drivers/media/usb/dvb-usb-v2/af9015.h b/drivers/media/usb/dvb-usb-v2/af9015.h
index 97339bf3749b..28710aaf058a 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.h
+++ b/drivers/media/usb/dvb-usb-v2/af9015.h
@@ -34,19 +34,6 @@
 
 #define AF9015_FIRMWARE "dvb-usb-af9015.fw"
 
-/* Windows driver uses packet count 21 for USB1.1 and 348 for USB2.0.
-   We use smaller - about 1/4 from the original, 5 and 87. */
-#define TS_PACKET_SIZE            188
-
-#define TS_USB20_PACKET_COUNT      87
-#define TS_USB20_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB20_PACKET_COUNT)
-
-#define TS_USB11_PACKET_COUNT       5
-#define TS_USB11_FRAME_SIZE       (TS_PACKET_SIZE*TS_USB11_PACKET_COUNT)
-
-#define TS_USB20_MAX_PACKET_SIZE  512
-#define TS_USB11_MAX_PACKET_SIZE   64
-
 #define AF9015_I2C_EEPROM  0x50
 #define AF9015_I2C_DEMOD   0x1c
 #define AF9015_USB_TIMEOUT 2000
@@ -128,6 +115,7 @@ struct af9015_state {
 	struct af9013_platform_data af9013_pdata[2];
 	struct i2c_client *demod_i2c_client[2];
 	u8 af9013_i2c_addr[2];
+	bool usb_ts_if_configured[2];
 
 	/* for demod callback override */
 	int (*set_frontend[2]) (struct dvb_frontend *fe);
-- 
2.14.3
