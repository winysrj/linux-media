Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36021 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2KFTRW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 14:17:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hubert Lin <hubertwslin@gmail.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH] rtl28xxu: 1d19:1102 Dexatek DK mini DVB-T Dongle
Date: Tue,  6 Nov 2012 21:16:47 +0200
Message-Id: <1352229407-30411-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new USB ID as driver supports it.

Reported-by: Hubert Lin <hubertwslin@gmail.com>
Tested-by: Hubert Lin <hubertwslin@gmail.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index adabba8..0149cdd 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1346,6 +1346,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
 		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
+		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.7

