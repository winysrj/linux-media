Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56670 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033167AbeEXUhH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 May 2018 16:37:07 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 10/20] staging: bcm2835-camera: Provide lock for vb2_queue
Date: Thu, 24 May 2018 17:35:10 -0300
Message-Id: <20180524203520.1598-11-ezequiel@collabora.com>
In-Reply-To: <20180524203520.1598-1-ezequiel@collabora.com>
References: <20180524203520.1598-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use the device mutex to protect the vb2_queue.
This allows to replace the ad-hoc wait_{prepare, finish}
with vb2_ops_wait_{prepare, finish}.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 .../vc04_services/bcm2835-camera/bcm2835-camera.c  | 24 +++++-----------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
index d2262275a870..2a628475a1bd 100644
--- a/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
+++ b/drivers/staging/vc04_services/bcm2835-camera/bcm2835-camera.c
@@ -601,28 +601,14 @@ static void stop_streaming(struct vb2_queue *vq)
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
 	.buf_prepare = buffer_prepare,
 	.buf_queue = buffer_queue,
 	.start_streaming = start_streaming,
 	.stop_streaming = stop_streaming,
-	.wait_prepare = bm2835_mmal_unlock,
-	.wait_finish = bm2835_mmal_lock,
+	.wait_prepare = vb2_ops_wait_prepare,
+	.wait_finish = vb2_ops_wait_finish,
 };
 
 /* ------------------------------------------------------------------
@@ -1831,6 +1817,8 @@ static int __init bm2835_mmal_init(void)
 			goto cleanup_gdev;
 		}
 
+		/* v4l2 core mutex used to protect all fops and v4l2 ioctls. */
+		mutex_init(&dev->mutex);
 		dev->camera_num = camera;
 		dev->max_width = resolutions[camera][0];
 		dev->max_height = resolutions[camera][1];
@@ -1875,13 +1863,11 @@ static int __init bm2835_mmal_init(void)
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
2.16.3
