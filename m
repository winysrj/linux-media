Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:35878 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934701AbeFOTID (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 15:08:03 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v4 07/17] staging: bcm2835-camera: Provide lock for vb2_queue
Date: Fri, 15 Jun 2018 16:07:27 -0300
Message-Id: <20180615190737.24139-8-ezequiel@collabora.com>
In-Reply-To: <20180615190737.24139-1-ezequiel@collabora.com>
References: <20180615190737.24139-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the device mutex to protect the vb2_queue.
This allows to replace the ad-hoc wait_{prepare, finish}
with vb2_ops_wait_{prepare, finish}.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../bcm2835-camera/bcm2835-camera.c           | 24 ++++---------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index ce26741ae9d9..6dd0c838db05 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -628,20 +628,6 @@ static void stop_streaming(struct vb2_queue *vq)
 		v4l2_err(&dev->v4l2_dev, "Failed to disable camera\n");
 }
 
-static void bm2835_mmal_lock(struct vb2_queue *vq)
-{
-	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
-
-	mutex_lock(&dev->mutex);
-}
-
-static void bm2835_mmal_unlock(struct vb2_queue *vq)
-{
-	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
-
-	mutex_unlock(&dev->mutex);
-}
-
 static const struct vb2_ops bm2835_mmal_video_qops = {
 	.queue_setup = queue_setup,
 	.buf_init = buffer_init,
@@ -650,8 +636,8 @@ static const struct vb2_ops bm2835_mmal_video_qops = {
 	.buf_queue = buffer_queue,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
-	.wait_prepare = bm2835_mmal_unlock,
-	.wait_finish = bm2835_mmal_lock,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------
@@ -1864,6 +1850,8 @@ static int bcm2835_mmal_probe(struct platform_device *pdev)
 			goto cleanup_gdev;
 		}
 
+		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
+		mutex_init(&dev->mutex);
 		dev->camera_num = camera;
 		dev->max_width = resolutions[camera][0];
 		dev->max_height = resolutions[camera][1];
@@ -1908,13 +1896,11 @@ static int bcm2835_mmal_probe(struct platform_device *pdev)
 		q->ops = &bm2835_mmal_video_qops;
 		q->mem_ops = &vb2_vmalloc_memops;
 		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
+		q->lock = &dev->mutex;
 		ret = vb2_queue_init(q);
 		if (ret < 0)
 			goto unreg_dev;
 
-		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
-		mutex_init(&dev->mutex);
-
 		/* initialise video devices */
 		ret = bm2835_mmal_init_device(dev, &dev->vdev);
 		if (ret < 0)
-- 
2.17.1
