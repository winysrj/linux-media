Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tu-berlin.de ([130.149.7.33]:39157 "EHLO mail.tu-berlin.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2KFXWF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Nov 2012 18:22:05 -0500
Received: from i59f704e2.versanet.de ([89.247.4.226] helo=[192.168.178.44])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-2) with esmtpa
	for <linux-media@vger.kernel.org>
	id 1TVs9f-0002ld-G8; Wed, 07 Nov 2012 00:01:59 +0100
Message-ID: <509996BC.5060101@mailbox.tu-berlin.de>
Date: Wed, 07 Nov 2012 00:01:16 +0100
From: Andrew Karpow <andy@mailbox.tu-berlin.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] rtl28xxu: 0ccd:00d7 TerraTec Cinergy T Stick+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

added usb-id as driver supports the stick

Signed-off-by: Andrew Karpow <andy@mailbox.tu-berlin.de>
---
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index 0149cdd..093f1ac 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1348,6 +1348,8 @@ static const struct usb_device_id
rtl28xxu_id_table[] = {
        &rtl2832u_props, "TerraTec Cinergy T Stick RC (Rev. 3)", NULL) },
    { DVB_USB_DEVICE(USB_VID_DEXATEK, 0x1102,
        &rtl2832u_props, "Dexatek DK mini DVB-T Dongle", NULL) },
+   { DVB_USB_DEVICE(USB_VID_TERRATEC, 0x00d7,
+       &rtl2832u_props, "TerraTec Cinergy T Stick+", NULL) },
    { }
 };
 MODULE_DEVICE_TABLE(usb, rtl28xxu_id_table);
-- 
1.7.8.6
