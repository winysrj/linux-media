Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55031 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaEDWIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 May 2014 18:08:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Alessandro Miceli <angelofsky1980@gmail.com>,
	Antti Palosaari <crope@iki.fi>
Subject: [PATCH 3/3] rtl28xxu: add [1b80:d3af] Sveon STV27
Date: Mon,  5 May 2014 01:07:29 +0300
Message-Id: <1399241249-12065-3-git-send-email-crope@iki.fi>
In-Reply-To: <1399241249-12065-1-git-send-email-crope@iki.fi>
References: <1399241249-12065-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Alessandro Miceli <angelofsky1980@gmail.com>

Added support for Sveon STV27 device (rtl2832u + FC0013 tuner)

Signed-off-by: Alessandro Miceli <angelofsky1980@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/dvb-core/dvb-usb-ids.h    | 1 +
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
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
index 007be1a..a676e44 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1541,6 +1541,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Peak DVB-T USB", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV20_RTL2832U,
 		&rtl2832u_props, "Sveon STV20", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_KWORLD_2, USB_PID_SVEON_STV27,
+		&rtl2832u_props, "Sveon STV27", NULL) },
 
 	/* RTL2832P devices: */
 	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
-- 
1.9.0

