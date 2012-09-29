Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40055 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757358Ab2I2SdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 14:33:25 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Nikolai Spasov <ns@codingrobot.com>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH RFC] rtl28xxu: [0ccd:00d3] TerraTec Cinergy T Stick RC (Rev. 3)
Date: Sat, 29 Sep 2012 21:32:38 +0300
Message-Id: <1348943558-8860-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is RTL2832U + E4000.

Thanks to Nikolai Spasov reporting and testing!

Reported-by: Nikolai Spasov <ns@codingrobot.com>
Tested-by: Nikolai Spasov <ns@codingrobot.com>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index f62cfba..adabba8 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1344,6 +1344,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6680,
 		&rtl2832u_props, "DigitalNow Quad DVB-T Receiver", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d3,
+		&rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.11.4

