Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33608 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752506AbdF2R4u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 13:56:50 -0400
Received: by mail-wm0-f67.google.com with SMTP id j85so3956874wmj.0
        for <linux-media@vger.kernel.org>; Thu, 29 Jun 2017 10:56:49 -0700 (PDT)
From: Nuno Henriques <nuno.amhenriques@gmail.com>
To: linux-media@vger.kernel.org
Cc: Nuno Henriques <nuno.amhenriques@gmail.com>
Subject: [PATCH] Added support for the TerraTec T1 DVB-T USB tuner [IT9135 chipset]
Date: Thu, 29 Jun 2017 18:55:54 +0100
Message-Id: <20170629175554.19099-1-nuno.amhenriques@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Nuno Henriques <nuno.amhenriques@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index e200aa6f2d2f..5b6041d462bc 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -279,6 +279,7 @@
 #define USB_PID_TERRATEC_H7				0x10b4
 #define USB_PID_TERRATEC_H7_2				0x10a3
 #define USB_PID_TERRATEC_H7_3				0x10a5
+#define USB_PID_TERRATEC_T1				0x10ae
 #define USB_PID_TERRATEC_T3				0x10a0
 #define USB_PID_TERRATEC_T5				0x10a1
 #define USB_PID_NOXON_DAB_STICK				0x00b3
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 4df9486e19b9..ccf4a5c68877 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2108,6 +2108,8 @@ static const struct usb_device_id af9035_id_table[] = {
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_CTVDIGDUAL_V2,
 		&af9035_props, "Digital Dual TV Receiver CTVDIGDUAL_V2",
 							RC_MAP_IT913X_V1) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, USB_PID_TERRATEC_T1,
+		&af9035_props, "TerraTec T1", RC_MAP_IT913X_V1) },
 	/* XXX: that same ID [0ccd:0099] is used by af9015 driver too */
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x0099,
 		&af9035_props, "TerraTec Cinergy T Stick Dual RC (rev. 2)",
-- 
2.13.2
