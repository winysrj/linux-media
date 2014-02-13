Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60541 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751695AbaBMS6f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Feb 2014 13:58:35 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/2] af9035: use af9033 PID filters
Date: Thu, 13 Feb 2014 20:58:18 +0200
Message-Id: <1392317898-22040-2-git-send-email-crope@iki.fi>
In-Reply-To: <1392317898-22040-1-git-send-email-crope@iki.fi>
References: <1392317898-22040-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PID filters are property of af9033 demod. Use PID filters from af9033
driver as it provides those now.

Allow possible dual mode on USB 1.1 mode too as bandwidth could be
just enough when filters are used on both frontends.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/af9035.c | 61 ++++++-----------------------------
 1 file changed, 10 insertions(+), 51 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1434d37..31d09a2 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -945,12 +945,7 @@ static int af9035_frontend_callback(void *adapter_priv, int component,
 static int af9035_get_adapter_count(struct dvb_usb_device *d)
 {
 	struct state *state = d_to_priv(d);
-
-	/* disable 2nd adapter as we don't have PID filters implemented */
-	if (d->udev->speed == USB_SPEED_FULL)
-		return 1;
-	else
-		return state->dual_mode + 1;
+	return state->dual_mode + 1;
 }
 
 static int af9035_frontend_attach(struct dvb_usb_adapter *adap)
@@ -1376,58 +1371,15 @@ static int af9035_get_stream_config(struct dvb_frontend *fe, u8 *ts_type,
 	return 0;
 }
 
-/*
- * FIXME: PID filter is property of demodulator and should be moved to the
- * correct driver. Also we support only adapter #0 PID filter and will
- * disable adapter #1 if USB1.1 is used.
- */
 static int af9035_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret;
-
-	dev_dbg(&d->udev->dev, "%s: onoff=%d\n", __func__, onoff);
-
-	ret = af9035_wr_reg_mask(d, 0x80f993, onoff, 0x01);
-	if (ret < 0)
-		goto err;
-
-	return 0;
-
-err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-
-	return ret;
+	return af9033_pid_filter_ctrl(adap->fe[0], onoff);
 }
 
 static int af9035_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid,
 		int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret;
-	u8 wbuf[2] = {(pid >> 0) & 0xff, (pid >> 8) & 0xff};
-
-	dev_dbg(&d->udev->dev, "%s: index=%d pid=%04x onoff=%d\n",
-			__func__, index, pid, onoff);
-
-	ret = af9035_wr_regs(d, 0x80f996, wbuf, 2);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg(d, 0x80f994, onoff);
-	if (ret < 0)
-		goto err;
-
-	ret = af9035_wr_reg(d, 0x80f995, index);
-	if (ret < 0)
-		goto err;
-
-	return 0;
-
-err:
-	dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
-
-	return ret;
+	return af9033_pid_filter(adap->fe[0], index, pid, onoff);
 }
 
 static int af9035_probe(struct usb_interface *intf,
@@ -1501,6 +1453,13 @@ static const struct dvb_usb_device_properties af9035_props = {
 
 			.stream = DVB_USB_STREAM_BULK(0x84, 6, 87 * 188),
 		}, {
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+			.pid_filter_count = 32,
+			.pid_filter_ctrl = af9035_pid_filter_ctrl,
+			.pid_filter = af9035_pid_filter,
+
 			.stream = DVB_USB_STREAM_BULK(0x85, 6, 87 * 188),
 		},
 	},
-- 
1.8.5.3

