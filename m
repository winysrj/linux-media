Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:40490 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbbK2CKS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Nov 2015 21:10:18 -0500
Received: from benjamin-desktop.lan (c-ce09e555.03-170-73746f36.cust.bredbandsbolaget.se [85.229.9.206])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id B4401727C4
	for <linux-media@vger.kernel.org>; Sun, 29 Nov 2015 03:10:16 +0100 (CET)
From: Benjamin Larsson <benjamin@southpole.se>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] rtl28xxu: change Astrometa DVB-T2 to always use hardware pid filters
Date: Sun, 29 Nov 2015 03:10:16 +0100
Message-Id: <1448763016-10527-3-git-send-email-benjamin@southpole.se>
In-Reply-To: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
References: <1448763016-10527-1-git-send-email-benjamin@southpole.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Benjamin Larsson <benjamin@southpole.se>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 35 ++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 5a503a6..74201ec 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1848,6 +1848,39 @@ static const struct dvb_usb_device_properties rtl28xxu_props = {
 	},
 };
 
+static const struct dvb_usb_device_properties rtl28xxp_props = {
+	.driver_name = KBUILD_MODNAME,
+	.owner = THIS_MODULE,
+	.adapter_nr = adapter_nr,
+	.size_of_priv = sizeof(struct rtl28xxu_dev),
+
+	.identify_state = rtl28xxu_identify_state,
+	.power_ctrl = rtl28xxu_power_ctrl,
+	.frontend_ctrl = rtl28xxu_frontend_ctrl,
+	.i2c_algo = &rtl28xxu_i2c_algo,
+	.read_config = rtl28xxu_read_config,
+	.frontend_attach = rtl28xxu_frontend_attach,
+	.frontend_detach = rtl28xxu_frontend_detach,
+	.tuner_attach = rtl28xxu_tuner_attach,
+	.tuner_detach = rtl28xxu_tuner_detach,
+	.init = rtl28xxu_init,
+
+	.get_rc_config = rtl28xxu_get_rc_config,
+	.num_adapters = 1,
+	.adapter = {
+		{
+			.caps = DVB_USB_ADAP_NEED_PID_FILTERING |
+				DVB_USB_ADAP_PID_FILTER_CAN_BE_TURNED_OFF,
+
+			.pid_filter_count = 32,
+			.pid_filter_ctrl = rtl28xxu_pid_filter_ctrl,
+			.pid_filter = rtl28xxu_pid_filter,
+
+			.stream = DVB_USB_STREAM_BULK(0x81, 6, 8 * 512),
+		},
+	},
+};
+
 static const struct usb_device_id rtl28xxu_id_table[] = {
 	/* RTL2831U devices: */
 	{ DVB_USB_DEVICE(USB_VID_REALTEK, USB_PID_REALTEK_RTL2831U,
@@ -1919,7 +1952,7 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-		&rtl28xxu_props, "Astrometa DVB-T2", NULL) },
+		&rtl28xxp_props, "Astrometa DVB-T2", NULL) },
 	{ DVB_USB_DEVICE(0x5654, 0xca42,
 		&rtl28xxu_props, "GoTView MasterHD 3", NULL) },
 	{ }
-- 
2.1.4

