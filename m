Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:32795 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935AbaHEJT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Aug 2014 05:19:57 -0400
From: Malcolm Priestley <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
	Antti Palosaari <crope@iki.fi>, <stable@vger.kernel.org>
Subject: [PATCH] af9035: new IDs: add support for PCTV 78e and PCTV 79e
Date: Tue,  5 Aug 2014 10:19:16 +0100
Message-Id: <1407230356-3475-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

add the following IDs
USB_PID_PCTV_78E (0x025a) for PCTV 78e
USB_PID_PCTV_79E (0x0262) for PCTV 79e

For these it9135 devices.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Antti Palosaari <crope@iki.fi>
Cc: <stable@vger.kernel.org> # v3.14+
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 2 ++
 drivers/media/usb/dvb-usb-v2/af9035.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 5135a09..12ce19c 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -280,6 +280,8 @@
 #define USB_PID_PCTV_400E				0x020f
 #define USB_PID_PCTV_450E				0x0222
 #define USB_PID_PCTV_452E				0x021f
+#define USB_PID_PCTV_78E				0x025a
+#define USB_PID_PCTV_79E				0x0262
 #define USB_PID_REALTEK_RTL2831U			0x2831
 #define USB_PID_REALTEK_RTL2832U			0x2832
 #define USB_PID_TECHNOTREND_CONNECT_S2_3600		0x3007
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 75ec1c6..c82beac 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1575,6 +1575,10 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Leadtek WinFast DTV Dongle Dual", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_HAUPPAUGE, 0xf900,
 		&af9035_props, "Hauppauge WinTV-MiniStick 2", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_78E,
+		&af9035_props, "PCTV 78e", RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_PCTV, USB_PID_PCTV_79E,
+		&af9035_props, "PCTV 79e", RC_MAP_IT913X_V2) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
2.0.1

