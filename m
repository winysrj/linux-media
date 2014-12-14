Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50191 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbaLNI3u (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Dec 2014 03:29:50 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 16/18] rtl28xxu: add support for RTL2831U/RTL2830 PID filter
Date: Sun, 14 Dec 2014 10:28:41 +0200
Message-Id: <1418545723-9536-16-git-send-email-crope@iki.fi>
In-Reply-To: <1418545723-9536-1-git-send-email-crope@iki.fi>
References: <1418545723-9536-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

RTL2830 demod integrated to RTL2831U has PID filter. PID filtering
is provided by rtl2830 demod driver. Add support for it.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 4f94e0e..747a56d 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1568,6 +1568,24 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 #define rtl2832u_get_rc_config NULL
 #endif
 
+static int rtl28xxu_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+
+	return pdata->pid_filter_ctrl(adap->fe[0], onoff);
+}
+
+static int rtl28xxu_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
+{
+	struct dvb_usb_device *d = adap_to_d(adap);
+	struct rtl28xxu_priv *priv = d_to_priv(d);
+	struct rtl2830_platform_data *pdata = &priv->rtl2830_platform_data;
+
+	return pdata->pid_filter(adap->fe[0], index, pid, onoff);
+}
+
 static const struct dvb_usb_device_properties rtl2831u_props = {
 	.driver_name = KBUILD_MODNAME,
 	.owner = THIS_MODULE,
@@ -1586,6 +1604,13 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.num_adapters = 1,
 	.adapter = {
 		{
+			.caps = DVB_USB_ADAP_HAS_PID_FILTER |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+			.pid_filter_count = 32,
+			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
+			.pid_filter = rtl28xxu_pid_filter,
+
 			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
 		},
 	},
-- 
http://palosaari.fi/

