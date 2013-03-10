Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53660 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab3CJCEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Mar 2013 21:04:39 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [REVIEW PATCH 09/41] af9035: USB1.1 support (== PID filters)
Date: Sun, 10 Mar 2013 04:03:01 +0200
Message-Id: <1362881013-5271-9-git-send-email-crope@iki.fi>
In-Reply-To: <1362881013-5271-1-git-send-email-crope@iki.fi>
References: <1362881013-5271-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 85 +++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1e1cee6..42ed0f7 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -894,7 +894,12 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 static int af9035_get_adapter_count(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
-	return state->dual_mode + 1;
+
+	/* disable 2nd adapter as we don't have PID filters implemented */
+	if (d->udev->speed == USB_SPEED_FULL)
+		return 1;
+	else
+		return state->dual_mode + 1;
 }
 
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
@@ -1201,8 +1206,8 @@ static int af9035_init(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
 	int ret, i;
-	u16 frame_size = 87 * 188 / 4;
-	u8  packet_size = 512 / 4;
+	u16 frame_size = (d->udev->speed == USB_SPEED_FULL ? 5 : 87) * 188 / 4;
+	u8 packet_size = (d->udev->speed == USB_SPEED_FULL ? 64 : 512) / 4;
 	struct reg_val_mask tab[] = {
 		{ 0x80f99d, 0x01, 0x01 },
 		{ 0x80f9a4, 0x01, 0x01 },
@@ -1328,6 +1333,72 @@ err:
 	#define af9035_get_rc_config NULL
 #endif
 
+static int af9035_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
+		struct usb_data_stream_properties *stream)
+{
+	struct dvb_usb_device *d = fe_to_d(fe);
+	dev_dbg(&d->udev->dev, "%s: adap=%d\n", __func__, fe_to_adap(fe)->id);
+
+	if (d->udev->speed == USB_SPEED_FULL)
+		stream->u.bulk.buffersize = 5 * 188;
+
+	return 0;
+}
+
+/*
+ * FIXME: PID filter is property of demodulator and should be moved to the
+ * correct driver. Also we support only adapter #0 PID filter and will
+ * disable adapter #1 if USB1.1 is used.
+ */
+static int af9035_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret;
+
+	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
+
+	ret = af9035_wr_reg_mask(d, 0x80f993, onoff, 0x01);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
+static int af9035_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
+		int onoff)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	int ret;
+	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
+
+	dev_dbg(&d->udev->dev, "%s: index=%d pid=%04x onoff=%d\n",
+			__func__, index, pid, onoff);
+
+	ret = af9035_wr_regs(d, 0x80f996, wbuf, 2);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg(d, 0x80f994, onoff);
+	if (ret < 0)
+		goto err;
+
+	ret = af9035_wr_reg(d, 0x80f995, index);
+	if (ret < 0)
+		goto err;
+
+	return 0;
+
+err:
+	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
+
+	return ret;
+}
+
 static int af9035_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
@@ -1385,10 +1456,18 @@ static const struct dvb_usb_device_properties af9035_props = {
 	.tuner_attach = af9035_tuner_attach,
 	.init = af9035_init,
 	.get_rc_config = af9035_get_rc_config,
+	.get_stream_config = af9035_get_stream_config,
 
 	.get_adapter_count = af9035_get_adapter_count,
 	.adapter = {
 		{
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+			.pid_filter_count = 32,
+			.pid_filter_ctrl = af9035_pid_filter_ctrl,
+			.pid_filter = af9035_pid_filter,
+
 			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
 		}, {
 			.stream = DVB_USB_STREAM_BULK(0x85, 6, 87 * 188),
-- 
1.7.11.7

