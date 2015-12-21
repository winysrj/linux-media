Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:59751 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbbLUNgc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Dec 2015 08:36:32 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-media@vger.kernel.org,
	Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH] [media] uvcvideo: Only register media dev if MEDIA_CONTROLLER is defined
Date: Mon, 21 Dec 2015 10:36:18 -0300
Message-Id: <1450704978-17113-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 1590ad7b5271 ("[media] media-device: split media initialization
and registration") split the media dev initialization and registration
but introduced a build error since media_device_register() was called
unconditionally even when the MEDIA_CONTROLLER config was not enabled:

from drivers/media/usb/uvc/uvc_driver.c:14:
   drivers/media/usb/uvc/uvc_driver.c: In function 'uvc_probe':
   drivers/media/usb/uvc/uvc_driver.c:1960:32: error: 'struct uvc_device' has no member named 'mdev'
     if (media_device_register(&dev->mdev) < 0)

Fixes: 1590ad7b5271 ("[media] media-device: split media initialization and registration")
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/usb/uvc/uvc_driver.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index ddf035a23e3a..599390325c09 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1957,10 +1957,11 @@ static int uvc_probe(struct usb_interface *intf,
 	if (uvc_register_chains(dev) < 0)
 		goto error;
 
+#ifdef CONFIG_MEDIA_CONTROLLER
 	/* Register the media device node */
 	if (media_device_register(&dev->mdev) < 0)
 		goto error;
-
+#endif
 	/* Save our data pointer in the interface data. */
 	usb_set_intfdata(intf, dev);
 
-- 
2.4.3

