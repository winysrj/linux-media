Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:20996 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752217AbeCWVS3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 17:18:29 -0400
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, acourbot@chromium.org
Subject: [RFC v2 10/10] vim2m: Request support
Date: Fri, 23 Mar 2018 23:17:44 +0200
Message-Id: <1521839864-10146-11-git-send-email-sakari.ailus@linux.intel.com>
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 drivers/media/platform/vim2m.c | 49 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 43 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 9b6b456..a8fe3ea 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 
 #include <linux/platform_device.h>
+#include <media/media-device.h>
 #include <media/v4l2-mem2mem.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ioctl.h>
@@ -138,6 +139,7 @@ static struct vim2m_fmt *find_format(struct v4l2_format *f)
 }
 
 struct vim2m_dev {
+	struct media_device	mdev;
 	struct v4l2_device	v4l2_dev;
 	struct video_device	vfd;
 
@@ -200,6 +202,7 @@ static struct vim2m_q_data *get_q_data(struct vim2m_ctx *ctx,
 
 
 static int device_process(struct vim2m_ctx *ctx,
+			  struct v4l2_m2m_request *vreq,
 			  struct vb2_v4l2_buffer *in_vb,
 			  struct vb2_v4l2_buffer *out_vb)
 {
@@ -377,12 +380,21 @@ static void device_run(void *priv)
 {
 	struct vim2m_ctx *ctx = priv;
 	struct vim2m_dev *dev = ctx->dev;
-	struct vb2_v4l2_buffer *src_buf, *dst_buf;
-
-	src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
-	dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	struct vb2_v4l2_buffer *src_buf = NULL, *dst_buf = NULL;
+	struct v4l2_m2m_request *vreq;
+
+	vreq = v4l2_m2m_next_req(ctx->fh.m2m_ctx);
+	if (vreq) {
+		src_buf = to_vb2_v4l2_buffer(
+			media_request_object_to_vb2_buffer(vreq->out_ref->new));
+		dst_buf = to_vb2_v4l2_buffer(
+			media_request_object_to_vb2_buffer(vreq->cap_ref->new));
+	} else {
+		src_buf = v4l2_m2m_next_src_buf(ctx->fh.m2m_ctx);
+		dst_buf = v4l2_m2m_next_dst_buf(ctx->fh.m2m_ctx);
+	}
 
-	device_process(ctx, src_buf, dst_buf);
+	device_process(ctx, vreq, src_buf, dst_buf);
 
 	/* Run a timer, which simulates a hardware irq  */
 	schedule_irq(dev, ctx->transtime);
@@ -989,6 +1001,12 @@ static const struct v4l2_m2m_ops m2m_ops = {
 	.job_abort	= job_abort,
 };
 
+static const struct media_device_ops vim2m_mdev_ops = {
+	.req_alloc = v4l2_m2m_req_alloc,
+	.req_free = v4l2_m2m_req_free,
+	.req_queue = v4l2_m2m_req_queue,
+};
+
 static int vim2m_probe(struct platform_device *pdev)
 {
 	struct vim2m_dev *dev;
@@ -1001,9 +1019,17 @@ static int vim2m_probe(struct platform_device *pdev)
 
 	spin_lock_init(&dev->irqlock);
 
+	dev->mdev.dev = &pdev->dev;
+	dev->mdev.ops = &vim2m_mdev_ops;
+	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	snprintf(dev->mdev.bus_info, sizeof(dev->mdev.bus_info), "platform:%s",
+		 MEM2MEM_NAME);
+	media_device_init(&dev->mdev);
+
+	dev->v4l2_dev.mdev = &dev->mdev;
 	ret = v4l2_device_register(&pdev->dev, &dev->v4l2_dev);
 	if (ret)
-		return ret;
+		goto err_cleanup_mdev;
 
 	atomic_set(&dev->num_inst, 0);
 	mutex_init(&dev->dev_mutex);
@@ -1018,6 +1044,8 @@ static int vim2m_probe(struct platform_device *pdev)
 		goto err_unreg_v4l2_dev;
 	}
 
+	v4l2_m2m_allow_requests(dev->m2m_dev, &dev->mdev);
+
 	dev->vfd = vim2m_videodev;
 	vfd = &dev->vfd;
 	vfd->lock = &dev->dev_mutex;
@@ -1034,6 +1062,10 @@ static int vim2m_probe(struct platform_device *pdev)
 	v4l2_info(&dev->v4l2_dev,
 			"Device registered as /dev/video%d\n", vfd->num);
 
+	ret = media_device_register(&dev->mdev);
+	if (ret)
+		goto err_unreg_vdev;
+
 	return 0;
 
 err_unreg_vdev:
@@ -1043,6 +1075,9 @@ static int vim2m_probe(struct platform_device *pdev)
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
+err_cleanup_mdev:
+	media_device_cleanup(&dev->mdev);
+
 	return ret;
 }
 
@@ -1055,6 +1090,8 @@ static int vim2m_remove(struct platform_device *pdev)
 	del_timer_sync(&dev->timer);
 	video_unregister_device(&dev->vfd);
 	v4l2_device_unregister(&dev->v4l2_dev);
+	media_device_unregister(&dev->mdev);
+	media_device_cleanup(&dev->mdev);
 
 	return 0;
 }
-- 
2.7.4
