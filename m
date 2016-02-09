Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp09.smtpout.orange.fr ([80.12.242.131]:36514 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564AbcBIIIp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Feb 2016 03:08:45 -0500
From: Philippe Valembois <lephilousophe@users.sourceforge.net>
Cc: Philippe Valembois <lephilousophe@users.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Add support for Avermedia AverTV Volar HD 2 (TD110)
Date: Tue,  9 Feb 2016 09:08:01 +0100
Message-Id: <1455005281-25407-1-git-send-email-lephilousophe@users.sourceforge.net>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Philippe Valembois <lephilousophe@users.sourceforge.net>
---
 drivers/media/dvb-core/dvb-usb-ids.h  | 1 +
 drivers/media/usb/dvb-usb-v2/af9035.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index dbdbb84..0afad39 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -242,6 +242,7 @@
 #define USB_PID_AVERMEDIA_1867				0x1867
 #define USB_PID_AVERMEDIA_A867				0xa867
 #define USB_PID_AVERMEDIA_H335				0x0335
+#define USB_PID_AVERMEDIA_TD110				0xa110
 #define USB_PID_AVERMEDIA_TWINSTAR			0x0825
 #define USB_PID_TECHNOTREND_CONNECT_S2400               0x3006
 #define USB_PID_TECHNOTREND_CONNECT_S2400_8KEEPROM	0x3009
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index b3c09fe..2638e32 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -2053,6 +2053,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "Avermedia A835B(3835)", RC_MAP_IT913X_V2) },
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A835B_4835,
 		&af9035_props, "Avermedia A835B(4835)",	RC_MAP_IT913X_V2) },
+	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_TD110,
+		&af9035_props, "Avermedia AverTV Volar HD 2 (TD110)", RC_MAP_AVERMEDIA_RM_KS) },
 	{ DVB_USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_H335,
 		&af9035_props, "Avermedia H335", RC_MAP_IT913X_V2) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_KWORLD_UB499_2T_T09,
-- 
2.5.0

