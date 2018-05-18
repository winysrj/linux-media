Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33434 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752128AbeERSyF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 14:54:05 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, kernel@collabora.com,
        Abylay Ospan <aospan@netup.ru>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH 13/20] davinci_vpfe: Add video_device and vb2_queue locks
Date: Fri, 18 May 2018 15:52:01 -0300
Message-Id: <20180518185208.17722-14-ezequiel@collabora.com>
In-Reply-To: <20180518185208.17722-1-ezequiel@collabora.com>
References: <20180518185208.17722-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently, this driver does not serialize its video4linux
ioctls, which is a bug, as race conditions might appear.

In addition, video_device and vb2_queue locks are now both
mandatory. Add them, and implement wait_prepare and
wait_finish.

To stay on the safe side, this commit uses a single mutex
for both locks. Better latency can be obtained by separating
these if needed.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 6 +++++-
 drivers/staging/media/davinci_vpfe/vpfe_video.h | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 390fc98d07dd..1269a983455e 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1312,6 +1312,8 @@ static const struct vb2_ops video_qops = {
 	.stop_streaming		= vpfe_stop_streaming,
 	.buf_cleanup		= vpfe_buf_cleanup,
 	.buf_queue		= vpfe_buffer_queue,
+	.wait_prepare		= vb2_ops_wait_prepare,
+	.wait_finish		= vb2_ops_wait_finish,
 };
 
 /*
@@ -1357,6 +1359,7 @@ static int vpfe_reqbufs(struct file *file, void *priv,
 	q->buf_struct_size = sizeof(struct vpfe_cap_buffer);
 	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	q->dev = vpfe_dev->pdev;
+	q->lock = &video->lock;
 
 	ret = vb2_queue_init(q);
 	if (ret) {
@@ -1598,17 +1601,18 @@ int vpfe_video_init(struct vpfe_video_device *video, const char *name)
 		return -EINVAL;
 	}
 	/* Initialize field of video device */
+	mutex_init(&video->lock);
 	video->video_dev.release = video_device_release;
 	video->video_dev.fops = &vpfe_fops;
 	video->video_dev.ioctl_ops = &vpfe_ioctl_ops;
 	video->video_dev.minor = -1;
 	video->video_dev.tvnorms = 0;
+	video->video_dev.lock = &video->lock;
 	snprintf(video->video_dev.name, sizeof(video->video_dev.name),
 		 "DAVINCI VIDEO %s %s", name, direction);
 
 	spin_lock_init(&video->irqlock);
 	spin_lock_init(&video->dma_queue_lock);
-	mutex_init(&video->lock);
 	ret = media_entity_pads_init(&video->video_dev.entity,
 				1, &video->pad);
 	if (ret < 0)
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.h b/drivers/staging/media/davinci_vpfe/vpfe_video.h
index 22136d3dadcb..4bbd219e8329 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.h
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.h
@@ -128,7 +128,7 @@ struct vpfe_video_device {
 	spinlock_t				irqlock;
 	/* IRQ lock for DMA queue */
 	spinlock_t				dma_queue_lock;
-	/* lock used to access this structure */
+	/* lock used to serialize all video4linux ioctls */
 	struct mutex				lock;
 	/* number of users performing IO */
 	u32					io_usrs;
-- 
2.16.3
