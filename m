Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40122 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573AbaLWVUi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 16:20:38 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 63/66] rtl28xxu: merge chip type specific all callbacks
Date: Tue, 23 Dec 2014 22:49:56 +0200
Message-Id: <1419367799-14263-63-git-send-email-crope@iki.fi>
In-Reply-To: <1419367799-14263-1-git-send-email-crope@iki.fi>
References: <1419367799-14263-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Merge all chip type specific prefixed (rtl2831u_ and rtl2832u_)
callback to top level callback prefixed as rtl28xxu_.

rtl2831u_foo() => rtl28xxu_foo()
rtl2832u_foo() => rtl28xxu_foo()

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 140 +++++++++++++++++++++-----------
 1 file changed, 94 insertions(+), 46 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 5bc7774..821dcba 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -523,6 +523,16 @@ err:
 	return ret;
 }
 
+static int rtl28xxu_read_config(struct dvb_usb_device *d)
+{
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return rtl2831u_read_config(d);
+	else
+		return rtl2832u_read_config(d);
+}
+
 static int rtl28xxu_identify_state(struct dvb_usb_device *d, const char **name)
 {
 	struct rtl28xxu_dev *dev = d_to_priv(d);
@@ -906,7 +916,17 @@ err:
 	return ret;
 }
 
-static int rtl2832u_frontend_detach(struct dvb_usb_adapter *adap)
+static int rtl28xxu_frontend_attach(struct dvb_usb_adapter *adap)
+{
+	struct rtl28xxu_dev *dev = adap_to_priv(adap);
+
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return rtl2831u_frontend_attach(adap);
+	else
+		return rtl2832u_frontend_attach(adap);
+}
+
+static int rtl28xxu_frontend_detach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_dev *dev = d_to_priv(d);
@@ -1172,7 +1192,17 @@ err:
 	return ret;
 }
 
-static int rtl2832u_tuner_detach(struct dvb_usb_adapter *adap)
+static int rtl28xxu_tuner_attach(struct dvb_usb_adapter *adap)
+{
+	struct rtl28xxu_dev *dev = adap_to_priv(adap);
+
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return rtl2831u_tuner_attach(adap);
+	else
+		return rtl2832u_tuner_attach(adap);
+}
+
+static int rtl28xxu_tuner_detach(struct dvb_usb_adapter *adap)
 {
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_dev *dev = d_to_priv(d);
@@ -1350,7 +1380,17 @@ err:
 	return ret;
 }
 
-static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
+static int rtl28xxu_power_ctrl(struct dvb_usb_device *d, int onoff)
+{
+	struct rtl28xxu_dev *dev = d_to_priv(d);
+
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return rtl2831u_power_ctrl(d, onoff);
+	else
+		return rtl2832u_power_ctrl(d, onoff);
+}
+
+static int rtl28xxu_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 {
 	struct dvb_usb_device *d = fe_to_d(fe);
 	struct rtl28xxu_dev *dev = fe_to_priv(fe);
@@ -1360,6 +1400,9 @@ static int rtl2832u_frontend_ctrl(struct dvb_frontend *fe, int onoff)
 
 	dev_dbg(&d->intf->dev, "fe=%d onoff=%d\n", fe->id, onoff);
 
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return 0;
+
 	/* control internal demod ADC */
 	if (fe->id == 0 && onoff)
 		val = 0x48; /* enable ADC */
@@ -1572,45 +1615,50 @@ static int rtl2832u_get_rc_config(struct dvb_usb_device *d,
 
 	return 0;
 }
-#else
-#define rtl2831u_get_rc_config NULL
-#define rtl2832u_get_rc_config NULL
-#endif
 
-static int rtl2831u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
+static int rtl28xxu_get_rc_config(struct dvb_usb_device *d,
+		struct dvb_usb_rc *rc)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
 	struct rtl28xxu_dev *dev = d_to_priv(d);
-	struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 
-	return pdata->pid_filter_ctrl(adap->fe[0], onoff);
+	if (dev->chip_id == CHIP_ID_RTL2831U)
+		return rtl2831u_get_rc_config(d, rc);
+	else
+		return rtl2832u_get_rc_config(d, rc);
 }
+#else
+#define rtl28xxu_get_rc_config NULL
+#endif
 
-static int rtl2832u_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
+static int rtl28xxu_pid_filter_ctrl(struct dvb_usb_adapter *adap, int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_dev *dev = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = adap_to_priv(adap);
 
-	return pdata->pid_filter_ctrl(adap->fe[0], onoff);
-}
+	if (dev->chip_id == CHIP_ID_RTL2831U) {
+		struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 
-static int rtl2831u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
-{
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_dev *dev = d_to_priv(d);
-	struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
+		return pdata->pid_filter_ctrl(adap->fe[0], onoff);
+	} else {
+		struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
 
-	return pdata->pid_filter(adap->fe[0], index, pid, onoff);
+		return pdata->pid_filter_ctrl(adap->fe[0], onoff);
+	}
 }
 
-static int rtl2832u_pid_filter(struct dvb_usb_adapter *adap, int index, u16 pid, int onoff)
+static int rtl28xxu_pid_filter(struct dvb_usb_adapter *adap, int index,
+			       u16 pid, int onoff)
 {
-	struct dvb_usb_device *d = adap_to_d(adap);
-	struct rtl28xxu_dev *dev = d_to_priv(d);
-	struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
+	struct rtl28xxu_dev *dev = adap_to_priv(adap);
+
+	if (dev->chip_id == CHIP_ID_RTL2831U) {
+		struct rtl2830_platform_data *pdata = &dev->rtl2830_platform_data;
 
-	return pdata->pid_filter(adap->fe[0], index, pid, onoff);
+		return pdata->pid_filter(adap->fe[0], index, pid, onoff);
+	} else {
+		struct rtl2832_platform_data *pdata = &dev->rtl2832_platform_data;
+
+		return pdata->pid_filter(adap->fe[0], index, pid, onoff);
+	}
 }
 
 static const struct dvb_usb_device_properties rtl2831u_props = {
@@ -1620,14 +1668,14 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
 	.identify_state = rtl28xxu_identify_state,
-	.power_ctrl = rtl2831u_power_ctrl,
+	.power_ctrl = rtl28xxu_power_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
-	.read_config = rtl2831u_read_config,
-	.frontend_attach = rtl2831u_frontend_attach,
-	.frontend_detach = rtl2832u_frontend_detach,
-	.tuner_attach = rtl2831u_tuner_attach,
+	.read_config = rtl28xxu_read_config,
+	.frontend_attach = rtl28xxu_frontend_attach,
+	.frontend_detach = rtl28xxu_frontend_detach,
+	.tuner_attach = rtl28xxu_tuner_attach,
 	.init = rtl28xxu_init,
-	.get_rc_config = rtl2831u_get_rc_config,
+	.get_rc_config = rtl28xxu_get_rc_config,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -1636,8 +1684,8 @@ static const struct dvb_usb_device_properties rtl2831u_props = {
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 
 			.pid_filter_count = 32,
-			.pid_filter_ctrl = rtl2831u_pid_filter_ctrl,
-			.pid_filter = rtl2831u_pid_filter,
+			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
+			.pid_filter = rtl28xxu_pid_filter,
 
 			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
 		},
@@ -1651,16 +1699,16 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 	.size_of_priv = sizeof(struct rtl28xxu_dev),
 
 	.identify_state = rtl28xxu_identify_state,
-	.power_ctrl = rtl2832u_power_ctrl,
-	.frontend_ctrl = rtl2832u_frontend_ctrl,
+	.power_ctrl = rtl28xxu_power_ctrl,
+	.frontend_ctrl = rtl28xxu_frontend_ctrl,
 	.i2c_algo = &rtl28xxu_i2c_algo,
-	.read_config = rtl2832u_read_config,
-	.frontend_attach = rtl2832u_frontend_attach,
-	.frontend_detach = rtl2832u_frontend_detach,
-	.tuner_attach = rtl2832u_tuner_attach,
-	.tuner_detach = rtl2832u_tuner_detach,
+	.read_config = rtl28xxu_read_config,
+	.frontend_attach = rtl28xxu_frontend_attach,
+	.frontend_detach = rtl28xxu_frontend_detach,
+	.tuner_attach = rtl28xxu_tuner_attach,
+	.tuner_detach = rtl28xxu_tuner_detach,
 	.init = rtl28xxu_init,
-	.get_rc_config = rtl2832u_get_rc_config,
+	.get_rc_config = rtl28xxu_get_rc_config,
 
 	.num_adapters = 1,
 	.adapter = {
@@ -1669,8 +1717,8 @@ static const struct dvb_usb_device_properties rtl2832u_props = {
 				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
 
 			.pid_filter_count = 32,
-			.pid_filter_ctrl = rtl2832u_pid_filter_ctrl,
-			.pid_filter = rtl2832u_pid_filter,
+			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
+			.pid_filter = rtl28xxu_pid_filter,
 
 			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
 		},
-- 
http://palosaari.fi/

