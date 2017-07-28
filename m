Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52809 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751806AbdG1Mdf (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Jul 2017 08:33:35 -0400
Received: from axis700.grange ([87.78.105.5]) by mail.gmx.com (mrgmx101
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MdFwl-1dIiGE1gm3-00IQjr for
 <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:33:33 +0200
Received: from 200r.grange (200r.grange [192.168.1.16])
        by axis700.grange (Postfix) with ESMTP id 3F6928B119
        for <linux-media@vger.kernel.org>; Fri, 28 Jul 2017 14:30:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-media@vger.kernel.org
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
Subject: [PATCH 3/6 v5]  uvcvideo: convert from using an atomic variable to a reference count
Date: Fri, 28 Jul 2017 14:33:22 +0200
Message-Id: <1501245205-15802-4-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
References: <1501245205-15802-1-git-send-email-g.liakhovetski@gmx.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When adding support for metadata nodes, we'll have to keep video
devices registered until all metadata nodes are closed too. Since
this has nothing to do with stream counting, replace the nstreams
atomic variable with a reference counter.

Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
---
 drivers/media/usb/uvc/uvc_driver.c | 31 +++++++++++++++++--------------
 drivers/media/usb/uvc/uvcvideo.h   |  2 +-
 2 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 70842c5..cfe33bf 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1849,16 +1849,20 @@ static void uvc_delete(struct uvc_device *dev)
 	kfree(dev);
 }
 
+static void uvc_kref_release(struct kref *kref)
+{
+	struct uvc_device *dev = container_of(kref, struct uvc_device, ref);
+
+	uvc_delete(dev);
+}
+
 static void uvc_release(struct video_device *vdev)
 {
 	struct uvc_streaming *stream = video_get_drvdata(vdev);
 	struct uvc_device *dev = stream->dev;
 
-	/* Decrement the registered streams count and delete the device when it
-	 * reaches zero.
-	 */
-	if (atomic_dec_and_test(&dev->nstreams))
-		uvc_delete(dev);
+	/* Decrement the refcount and delete the device when it reaches zero */
+	kref_put(&dev->ref, uvc_kref_release);
 }
 
 /*
@@ -1870,10 +1874,10 @@ static void uvc_unregister_video(struct uvc_device *dev)
 
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
@@ -1884,11 +1888,10 @@ static void uvc_unregister_video(struct uvc_device *dev)
 		uvc_debugfs_cleanup_stream(stream);
 	}
 
-	/* Decrement the stream count and call uvc_delete explicitly if there
-	 * are no stream left.
+	/* Decrement the refcount and call uvc_delete explicitly if there are no
+	 * stream left.
 	 */
-	if (atomic_dec_and_test(&dev->nstreams))
-		uvc_delete(dev);
+	kref_put(&dev->ref, uvc_kref_release);
 }
 
 static int uvc_register_video(struct uvc_device *dev,
@@ -1946,7 +1949,7 @@ static int uvc_register_video(struct uvc_device *dev,
 	else
 		stream->chain->caps |= V4L2_CAP_VIDEO_OUTPUT;
 
-	atomic_inc(&dev->nstreams);
+	kref_get(&dev->ref);
 	return 0;
 }
 
@@ -2031,7 +2034,7 @@ static int uvc_probe(struct usb_interface *intf,
 	INIT_LIST_HEAD(&dev->entities);
 	INIT_LIST_HEAD(&dev->chains);
 	INIT_LIST_HEAD(&dev->streams);
-	atomic_set(&dev->nstreams, 0);
+	kref_init(&dev->ref);
 	atomic_set(&dev->nmappings, 0);
 	mutex_init(&dev->lock);
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 15e415e..f157cf7 100644
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
1.9.3
