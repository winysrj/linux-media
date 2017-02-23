Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([92.60.52.57]:33411 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751110AbdBWK3d (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Feb 2017 05:29:33 -0500
From: Lubomir Rintel <lkundrak@v3.sk>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.xyz>,
        Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] usbtv: add a new usbid
Date: Thu, 23 Feb 2017 11:28:32 +0100
Message-Id: <20170223102832.31409-1-lkundrak@v3.sk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Icenowy Zheng <icenowy@aosc.xyz>

A new usbid of UTV007 is found in a newly bought device.

The usbid is 1f71:3301.

The ID on the chip is:
UTV007
A89029.1
1520L18K1

Both video and audio is tested with the modified usbtv driver.

Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Icenowy Zheng <icenowy@aosc.xyz>
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
I'm resending this one, since the earlier two attempts by the original author 
don't seem to have made it to linux-media@ or lkmk@, possibly due to spam 
filters or something and thus patchwork didn't pick it up.

 drivers/media/usb/usbtv/usbtv-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index ceb953b..cae6378 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -144,6 +144,7 @@ static void usbtv_disconnect(struct usb_interface *intf)
 
 static struct usb_device_id usbtv_id_table[] = {
 	{ USB_DEVICE(0x1b71, 0x3002) },
+	{ USB_DEVICE(0x1f71, 0x3301) },
 	{}
 };
 MODULE_DEVICE_TABLE(usb, usbtv_id_table);
-- 
2.9.3
