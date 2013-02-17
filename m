Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:37103 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3BQWZg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 17:25:36 -0500
Received: by mail-wg0-f54.google.com with SMTP id fm10so4048221wgb.33
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 14:25:34 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 17 Feb 2013 23:25:34 +0100
Message-ID: <CAA=TYk_Mc552Gx98aeaB6t9_t7pfK_w5Ka==g76hez2c0ufXMg@mail.gmail.com>
Subject: [PATCH] af9035: add ID [0ccd:00aa] TerraTec Cinergy T Stick (rev. 2)
From: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, gennarone@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds USB ID for alternative "Terratec Cinergy T Stick".
Tested by a friend: works similarly to 0ccd:0093 version (af9035+tua9001)

Please delete the previous patch

Regards


Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/af9035.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
b/drivers/media/usb/dvb-usb-v2/af9035.c
index 61ae7f9..c3cd6be 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -1133,6 +1133,8 @@ static const struct usb_device_id af9035_id_table[] = {
 		&af9035_props, "AVerMedia Twinstar (A825)", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_ASUS, USB_PID_ASUS_U3100MINI_PLUS,
 		&af9035_props, "Asus U3100Mini Plus", NULL) },
+        { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00aa,
+		&af9035_props, "TerraTec Cinergy T Stick (rev. 2)", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, af9035_id_table);
-- 
1.7.9.5
