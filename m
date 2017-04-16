Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.aosc.io ([199.195.250.187]:49374 "EHLO hermes.aosc.io"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752264AbdDPHAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 16 Apr 2017 03:00:08 -0400
From: Icenowy Zheng <icenowy@aosc.io>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>
Subject: [PATCH RESEND2] [media] usbtv: add a new usbid
Date: Sun, 16 Apr 2017 14:51:16 +0800
Message-Id: <20170416065116.61662-1-icenowy@aosc.io>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A new usbid of UTV007 is found in a newly bought device.

The usbid is 1f71:3301.

The ID on the chip is:
UTV007
A89029.1
1520L18K1

Both video and audio is tested with the modified usbtv driver.

Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
Acked-by: Lubomir Rintel <lkundrak@v3.sk>
---

Added Lubomir's ACK in the second time of resend.

The old patch may be lost because the old aosc.xyz mail is using Yandex's
service -- which is rejected by many mail providers. As part of AOSC mailing
system refactor, we got a new mailing system, so that the patch is now
resent.

 drivers/media/usb/usbtv/usbtv-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index ceb953be0770..cae637845876 100644
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
2.12.2
