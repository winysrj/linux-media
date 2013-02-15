Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:55609 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab3BOWyz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Feb 2013 17:54:55 -0500
Received: by mail-we0-f169.google.com with SMTP id t11so3342552wey.14
        for <linux-media@vger.kernel.org>; Fri, 15 Feb 2013 14:54:54 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 15 Feb 2013 23:54:54 +0100
Message-ID: <CAA=TYk8-a2NMSsZHjCygBxijGrfvd_KRDgsGWcKMFFAWMF6ubg@mail.gmail.com>
Subject: [PATCH] [media] rtl28xxu: Add USB ID for MaxMedia HU394-T
From: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: gennarone@gmail.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

please add USB ID for MaxMedia HU394-T USB DVB-T Multi (FM, DAB, DAB+)
dongle (RTL2832U+FC0012)

In Italy is branded: "DIKOM USB-DVBT HD"

lsusb:
ID 1b80:d394 Afatech

Regards


Signed-off-by: Fabrizio Gazzato <fabrizio.gazzato@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a4c302d..fc7b7a0 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1352,6 +1352,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
 		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
+      { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
+		&rtl2832u_props, "MaxMedia HU394-T", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.9.5
