Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:62400 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbaEDKu4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 May 2014 06:50:56 -0400
Received: by mail-we0-f181.google.com with SMTP id q58so6432261wes.12
        for <linux-media@vger.kernel.org>; Sun, 04 May 2014 03:50:55 -0700 (PDT)
From: Alessandro Miceli <angelofsky1980@gmail.com>
To: linux-media@vger.kernel.org
Cc: Alessandro Miceli <angelofsky1980@gmail.com>
Subject: [PATCH] Added support for Sveon STV27 device (rtl2832u + FC0013 tuner)
Date: Sun,  4 May 2014 12:50:31 +0200
Message-Id: <1399200631-25641-1-git-send-email-angelofsky1980@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 71c987b..80643ef 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -376,4 +376,5 @@
 #define USB_PID_CTVDIGDUAL_V2				0xe410
 #define USB_PID_PCTV_2002E                              0x025c
 #define USB_PID_PCTV_2002E_SE                           0x025d
+#define USB_PID_SVEON_STV27                             0xd3af
 #endif
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0b63c3f..f7e10f0 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
+		&rtl2832u_props, "Sveon STV27", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.7.9.5

