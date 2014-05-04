Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59028 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbaEDWIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 May 2014 18:08:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/3] rtl28xxu: add [1b80:d39d] Sveon STV20
Date: Mon,  5 May 2014 01:07:28 +0300
Message-Id: <1399241249-12065-2-git-send-email-crope@iki.fi>
In-Reply-To: <1399241249-12065-1-git-send-email-crope@iki.fi>
References: <1399241249-12065-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alessandro Miceli <angelofsky1980@gmail.com>

Added Sveon STV20 device based on Realtek RTL2832U and FC0012 tuner

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
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
index df60b5f..007be1a 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1539,6 +1539,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Genius TVGo DVB-T03", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd395,
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
+		&rtl2832u_props, "Sveon STV20", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.9.0

