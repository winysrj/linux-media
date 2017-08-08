Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47382 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752341AbdHHM4T (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 08:56:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH 4/5] uvcvideo: Convert from using an atomic variable to a reference count
Date: Tue,  8 Aug 2017 15:56:23 +0300
Message-Id: <20170808125624.11328-5-laurent.pinchart@ideasonboard.com>
In-Reply-To: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
References: <20170808125624.11328-1-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

When adding support for metadata nodes, we'll have to keep video
devices registered until all metadata nodes are closed too. Since
this has nothing to do with stream counting, replace the nstreams
atomic variable with a reference counter.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 25 +++++++++----------------
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 4f463bf2b877..0fc8a736ed17 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1802,8 +1802,9 @@ static int uvc_scan_device(struct uvc_device *dev)
  * already been canceled by the USB core. There is no need to kill the
  * interrupt URB manually.
  */
-static void uvc_delete(struct uvc_device *dev)
+static void uvc_delete(struct kref *kref)
 {
+	struct uvc_device *dev = container_of(kref, struct uvc_device, ref);
 	struct list_head *p, *n;
 
 	uvc_status_cleanup(dev);
@@ -1854,11 +1855,7 @@ static void uvc_release(struct video_device *vdev)
 	struct uvc_streaming *stream = video_get_drvdata(vdev);
 	struct uvc_device *dev = stream->dev;
 
-	/* Decrement the registered streams count and delete the device when it
-	 * reaches zero.
-	 */
-	if (atomic_dec_and_test(&dev->nstreams))
-		uvc_delete(dev);
+	kref_put(&dev->ref, uvc_delete);
 }
 
 /*
@@ -1870,10 +1867,10 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
 	/* Unregistering all video devices might result in uvc_delete() being
 	 * called from inside the loop if there's no open file handle. To avoid
-	 * that, increment the stream count before iterating over the streams
-	 * and decrement it when done.
+	 * that, increment the refcount before iterating over the streams and
+	 * decrement it when done.
 	 */
-	atomic_inc(&dev->nstreams);
+	kref_get(&dev->ref);
 
 	list_for_each_entry(stream, &dev->streams, list) {
 		if (!video_is_registered(&stream->vdev))
@@ -1884,11 +1881,7 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		uvc_debugfs_cleanup_stream(stream);
 	}
 
-	/* Decrement the stream count and call uvc_delete explicitly if there
-	 * are no stream left.
-	 */
-	if (atomic_dec_and_test(&dev->nstreams))
-		uvc_delete(dev);
+	kref_put(&dev->ref, uvc_delete);
 }
 
 static int uvc_register_video(struct uvc_device *dev,
@@ -1946,7 +1939,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	atomic_inc(&dev->nstreams);
+	kref_get(&dev->ref);
 	return 0;
 }
 
@@ -2031,7 +2024,7 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
-	atomic_set(&dev->nstreams, 0);
+	kref_init(&dev->ref);
 	atomic_set(&dev->nmappings, 0);
 	mutex_init(&dev->lock);
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 296b69bb3fb2..34c7ee6cc9e5 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -575,7 +575,7 @@ struct uvc_device {
 
 	/* Video Streaming interfaces */
 	struct list_head streams;
-	atomic_t nstreams;
+	struct kref ref;
 
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
-- 
Regards,

Laurent Pinchart
