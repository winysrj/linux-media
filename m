Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:55032 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbaEDKhq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 May 2014 06:37:46 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so615497wes.41
        for <linux-media@vger.kernel.org>; Sun, 04 May 2014 03:37:45 -0700 (PDT)
From: Alessandro Miceli <angelofsky1980@gmail.com>
To: linux-media@vger.kernel.org
Cc: Alessandro Miceli <angelofsky1980@gmail.com>
Subject: [PATCH] Added Sveon STV20 device based on Realtek 2832U and FC0012 tuner
Date: Sun,  4 May 2014 12:37:15 +0200
Message-Id: <1399199835-25033-1-git-send-email-angelofsky1980@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
---
 drivers/media/dvb-core/dvb-usb-ids.h    |    1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/dvb-core/dvb-usb-ids.h b/drivers/media/dvb-core/dvb-usb-ids.h
index 1bdc0e7..71c987b 100644
--- a/drivers/media/dvb-core/dvb-usb-ids.h
+++ b/drivers/media/dvb-core/dvb-usb-ids.h
@@ -361,6 +361,7 @@
 #define USB_PID_FRIIO_WHITE				0x0001
 #define USB_PID_TVWAY_PLUS				0x0002
 #define USB_PID_SVEON_STV20				0xe39d
+#define USB_PID_SVEON_STV20_RTL2832U			0xd39d
 #define USB_PID_SVEON_STV22				0xe401
 #define USB_PID_SVEON_STV22_IT9137			0xe411
 #define USB_PID_AZUREWAVE_AZ6027			0x3275
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index dcbd392..0b63c3f 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1537,6 +1537,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KYE, 0x707f,
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
+		&rtl2832u_props, "Sveon STV20", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.7.9.5

