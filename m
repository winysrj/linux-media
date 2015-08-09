Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc2s11.hotmail.com ([157.55.1.150]:55873 "EHLO
	DUB004-OMC2S11.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754532AbbHIOnM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Aug 2015 10:43:12 -0400
Message-ID: <DUB128-DS34AACE45DAD5FC6ADB9C6EA710@phx.gbl>
From: Graham Eccleston <grahameccleston_@hotmail.com>
To: <linux-media@vger.kernel.org>
Subject: [PATCH] Compro U650F support
Date: Sun, 9 Aug 2015 15:38:07 +0100
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Added Compro U650F to the rtl28xxu devices.

Reported-by: Graham Eccleston
Signed-off-by: Graham Eccleston <grahameccleston_@hotmail.com>

diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c 
b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index c3cac4c..31a9d4c 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1885,6 +1885,8 @@ static const struct usb_device_id rtl28xxu_id_table[] 
= {
                &rtl28xxu_props, "MSI DIGIVOX Micro HD", NULL) },
        { DVB_USB_DEVICE(USB_VID_COMPRO, 0x0620,
                &rtl28xxu_props, "Compro VideoMate U620F", NULL) },
+       { DVB_USB_DEVICE(USB_VID_COMPRO, 0x0650,
+                &rtl28xxu_props, "Compro VideoMate U650F", NULL) },
        { DVB_USB_DEVICE(USB_VID_KWORLD_2, 0xd394,
                &rtl28xxu_props, "MaxMedia HU394-T", NULL) },
        { DVB_USB_DEVICE(USB_VID_LEADTEK, 0x6a03, 

