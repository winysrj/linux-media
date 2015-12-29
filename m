Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35042 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbbL2Kay (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2015 05:30:54 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH] [media] uvcvideo: Fix build if !MEDIA_CONTROLLER
Date: Tue, 29 Dec 2015 11:30:52 +0100
Message-Id: <1451385052-20158-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Thierry Reding <treding@nvidia.com>

Accesses to the UVC device's mdev field need to be protected by a
preprocessor conditional to avoid build errors, since the field is only
included if the MEDIA_CONTROLLER option is selected.

Fixes: 1590ad7b5271 ("[media] media-device: split media initialization and registration")
Cc: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4dfd3eb814e7..fc63f9aae63e 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1937,9 +1937,11 @@ static int uvc_probe(struct usb_interface *intf,
 	if (uvc_register_chains(dev) < 0)
 		goto error;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
 	if (media_device_register(&dev->mdev) < 0)
 		goto error;
+#endif
 
 	/* Save our data pointer in the interface data. */
 	usb_set_intfdata(intf, dev);
-- 
2.5.0

