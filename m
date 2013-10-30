Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39651 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3J3FlS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Oct 2013 01:41:18 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>
Subject: [PATCH 4/4] rtl28xxu: add 15f4:0131 Astrometa DVB-T2
Date: Wed, 30 Oct 2013 07:40:36 +0200
Message-Id: <1383111636-19743-4-git-send-email-crope@iki.fi>
In-Reply-To: <1383111636-19743-1-git-send-email-crope@iki.fi>
References: <1383111636-19743-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Components are RTL2832P + R828D + MN88472.

Currently support only DVB-T as there is no driver for MN88472 demod.

Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 8c600b7..ecca036 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1427,6 +1427,9 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Leadtek WinFast DTV Dongle mini", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_GTEK, USB_PID_CPYTO_REDI_PC50A,
 		&rtl2832u_props, "Crypto ReDi PC 50 A", NULL) },
+
+	{ DVB_USB_DEVICE(USB_VID_HANFTEK, 0x0131,
+		&rtl2832u_props, "Astrometa DVB-T2", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.8.3.1

