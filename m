Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:58134 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3BQVs0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Feb 2013 16:48:26 -0500
Received: by mail-we0-f173.google.com with SMTP id r5so4215278wey.32
        for <linux-media@vger.kernel.org>; Sun, 17 Feb 2013 13:48:25 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 17 Feb 2013 22:48:24 +0100
Message-ID: <CAA=TYk98hQuu09bkBhrE_C0a-b1wb-i6Tc=Ds_AAEvHgZ=ZJAQ@mail.gmail.com>
Subject: [PATCH] af9035: add ID [0bda:00aa] TerraTec Cinergy T Stick (rev. 2)
From: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: gennarone@gmail.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antti,

this patch adds USB ID for alternative "Terratec Cinergy T Stick".
Tested by a friend: works similarly to 0ccd:0093 version (af9035+tua9001)

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
