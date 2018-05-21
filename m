Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:39849 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbeEUKZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 06:25:47 -0400
Received: by mail-wr0-f193.google.com with SMTP id w18-v6so11703499wrn.6
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 03:25:46 -0700 (PDT)
From: Philipp Zabel <philipp.zabel@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
        linux-media@vger.kernel.org,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] media: uvcvideo: Fix driver reference counting
Date: Mon, 21 May 2018 12:24:58 +0200
Message-Id: <20180521102458.3288-1-philipp.zabel@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kref_init initializes the reference count to 1, not 0. This additional
reference is never released since the conversion to reference counters.
As a result, uvc_delete is not called anymore when UVC cameras are
disconnected.
Fix this by adding an additional kref_put in uvc_disconnect and in the
probe error path. This also allows to remove the temporary additional
reference in uvc_unregister_video.

Fixes: 9d15cd958c17 ("media: uvcvideo: Convert from using an atomic variable to a reference count")
Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 2469b49b2b30..8e138201330f 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1871,13 +1871,6 @@ static void uvc_unregister_video(struct uvc_device *dev)
 {
 	struct uvc_streaming *stream;
 
-	/* Unregistering all video devices might result in uvc_delete() being
-	 * called from inside the loop if there's no open file handle. To avoid
-	 * that, increment the refcount before iterating over the streams and
-	 * decrement it when done.
-	 */
-	kref_get(&dev->ref);
-
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (!video_is_registered(&stream->vdev))
 			continue;
@@ -1887,8 +1880,6 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
 		uvc_debugfs_cleanup_stream(stream);
 	}
-
-	kref_put(&dev->ref, uvc_delete);
 }
 
 int uvc_register_video_device(struct uvc_device *dev,
@@ -2184,6 +2175,7 @@ static int uvc_probe(struct usb_interface *intf,
 
 error:
 	uvc_unregister_video(dev);
+	kref_put(&dev->ref, uvc_delete);
 	return -ENODEV;
 }
 
@@ -2201,6 +2193,7 @@ static void uvc_disconnect(struct usb_interface *intf)
 		return;
 
 	uvc_unregister_video(dev);
+	kref_put(&dev->ref, uvc_delete);
 }
 
 static int uvc_suspend(struct usb_interface *intf, pm_message_t message)
-- 
2.17.0
