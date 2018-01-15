Return-path: <linux-media-owner@vger.kernel.org>
Received: from iandouglasscott.com ([104.156.231.7]:41644 "EHLO
        iandouglasscott.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751698AbeAOAeQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Jan 2018 19:34:16 -0500
From: Ian Douglas Scott <ian@iandouglasscott.com>
To: linux-media@vger.kernel.org
Cc: Ian Douglas Scott <ian@iandouglasscott.com>
Subject: [PATCH] media: usbtv: Add USB ID 1f71:3306 to the UTV007 driver
Date: Sun, 14 Jan 2018 16:27:55 -0800
Message-Id: <20180115002755.2368-1-ian@iandouglasscott.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Ian Douglas Scott <ian@iandouglasscott.com>
---
 drivers/media/usb/usbtv/usbtv-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/usbtv/usbtv-core.c b/drivers/media/usb/usbtv/usbtv-core.c
index 127f8a0c098b..fe75a0032945 100644
--- a/drivers/media/usb/usbtv/usbtv-core.c
+++ b/drivers/media/usb/usbtv/usbtv-core.c
@@ -145,6 +145,7 @@ static void usbtv_disconnect(struct usb_interface *intf)
 static const struct usb_device_id usbtv_id_table[] = {
 	{ USB_DEVICE(0x1b71, 0x3002) },
 	{ USB_DEVICE(0x1f71, 0x3301) },
++	{ USB_DEVICE(0x1f71, 0x3306) },
 	{}
 };
 MODULE_DEVICE_TABLE(usb, usbtv_id_table);
-- 
2.15.1
