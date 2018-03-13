Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([91.232.154.25]:58831 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932772AbeCMXkP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Mar 2018 19:40:15 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 12/18] af9015: use af9013 demod pid filters
Date: Wed, 14 Mar 2018 01:39:38 +0200
Message-Id: <20180313233944.7234-12-crope@iki.fi>
In-Reply-To: <20180313233944.7234-1-crope@iki.fi>
References: <20180313233944.7234-1-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PID filters are moved to af9013 demod driver as those are property of
demod. As pid filters are now implemented correctly by demod driver,
we could enable pid filter support for possible slave demod too on
dual tuner configuration.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9015.c | 49 +++++++++++++----------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9015.c b/drivers/media/usb/dvb-usb-v2/af9015.c
index f07aa42535e5..8e2f704c6ca5 100644
--- a/drivers/media/usb/dvb-usb-v2/af9015.c
+++ b/drivers/media/usb/dvb-usb-v2/af9015.c
@@ -474,10 +474,6 @@ static int af9015_read_config(struct dvb_usb_device *d)
 	state->dual_mode = val;
 	dev_dbg(&intf->dev, "ts mode %02x\n", state->dual_mode);
 
-	/* disable 2nd adapter because we don't have PID-filters */
-	if (d->udev->speed == USB_SPEED_FULL)
-		state->dual_mode = 0;
-
 	state->af9013_i2c_addr[0] = AF9015_I2C_DEMOD;
 
 	if (state->dual_mode) {
@@ -1045,43 +1041,28 @@ static int af9015_tuner_attach(struct dvb_usb_adapter *adap)
 
 static int af9015_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct usb_interface *intf = d->intf;
+	struct af9015_state *state = adap_to_priv(adap);
+	struct af9013_platform_data *pdata = &state->af9013_pdata[adap->id];
 	int ret;
 
-	dev_dbg(&intf->dev, "onoff %d\n", onoff);
-
-	if (onoff)
-		ret = af9015_set_reg_bit(d, 0xd503, 0);
-	else
-		ret = af9015_clear_reg_bit(d, 0xd503, 0);
+	mutex_lock(&state->fe_mutex);
+	ret = pdata->pid_filter_ctrl(adap->fe[0], onoff);
+	mutex_unlock(&state->fe_mutex);
 
 	return ret;
 }
 
-static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
-	int onoff)
+static int af9015_pid_filter(struct dvb_usb_adapter *adap, int index,
+			     u16 pid, int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct usb_interface *intf = d->intf;
+	struct af9015_state *state = adap_to_priv(adap);
+	struct af9013_platform_data *pdata = &state->af9013_pdata[adap->id];
 	int ret;
-	u8 idx;
-
-	dev_dbg(&intf->dev, "index %d, pid %04x, onoff %d\n",
-		index, pid, onoff);
 
-	ret = af9015_write_reg(d, 0xd505, (pid & 0xff));
-	if (ret)
-		goto error;
-
-	ret = af9015_write_reg(d, 0xd506, (pid >> 8));
-	if (ret)
-		goto error;
-
-	idx = ((index & 0x1f) | (1 << 5));
-	ret = af9015_write_reg(d, 0xd504, idx);
+	mutex_lock(&state->fe_mutex);
+	ret = pdata->pid_filter(adap->fe[0], index, pid, onoff);
+	mutex_unlock(&state->fe_mutex);
 
-error:
 	return ret;
 }
 
@@ -1448,6 +1429,12 @@ static struct dvb_usb_device_properties af9015_props = {
 
 			.stream = DVB_USB_STREAM_BULK(0x84, 8, TS_USB20_FRAME_SIZE),
 		}, {
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+			.pid_filter_count = 32,
+			.pid_filter = af9015_pid_filter,
+			.pid_filter_ctrl = af9015_pid_filter_ctrl,
+
 			.stream = DVB_USB_STREAM_BULK(0x85, 8, TS_USB20_FRAME_SIZE),
 		},
 	},
-- 
2.14.3
