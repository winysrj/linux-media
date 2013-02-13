Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:41852 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3BMB50 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 20:57:26 -0500
Received: by mail-wi0-f173.google.com with SMTP id hq4so5139426wib.12
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 17:57:22 -0800 (PST)
From: Alistair Buxton <a.j.buxton@gmail.com>
To: crope@iki.fi
Cc: Alistair Buxton <a.j.buxton@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] [media] rtl28xxu: Add USB IDs for Compro VideoMate U620F.
Date: Wed, 13 Feb 2013 01:58:47 +0000
Message-Id: <1360720727-22212-1-git-send-email-a.j.buxton@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Alistair Buxton <a.j.buxton@gmail.com>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a4c302d..d8a8a88 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1352,6 +1352,8 @@ static const struct usb_device_id rtl28xxu_id_table[] = {
 		&rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
 	{ DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
 		&rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
+	{ DVB_USB_DEVICE(USB_VID_COMPRO, 0x0620,
+		&rtl2832u_props, "Compro VideoMate U620F", NULL) },
 	{ }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.10.4

