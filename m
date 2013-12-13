Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2495 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3LMQOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Dec 2013 11:14:12 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: [REVIEW PATCH 7/9] vb2: return ENOBUFS in start_streaming in case of too few buffers.
Date: Fri, 13 Dec 2013 17:13:44 +0100
Message-Id: <1386951226-27655-8-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
References: <1386951226-27655-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This works together with the retry_start_streaming mechanism to allow userspace
to start streaming even if not all required buffers have been queued.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Kamil Debski <k.debski@samsung.com>
Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---
 drivers/media/platform/davinci/vpbe_display.c   | 2 +-
 drivers/media/platform/davinci/vpif_capture.c   | 2 +-
 drivers/media/platform/davinci/vpif_display.c   | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c    | 2 +-
 drivers/media/platform/s5p-tv/mixer_video.c     | 2 +-
 drivers/media/platform/soc_camera/mx2_camera.c  | 2 +-
 drivers/staging/media/davinci_vpfe/vpfe_video.c | 2 ++
 7 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index eac472b..b02aba4 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -347,7 +347,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* If buffer queue is empty, return error */
 	if (list_empty(&layer->dma_queue)) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
-		return -EINVAL;
+		return -ENOBUFS;
 	}
 	/* Get the next frame from the buffer queue */
 	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 52ac5e6..735ec47 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -277,7 +277,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (list_empty(&common->dma_queue)) {
 		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_dbg(1, debug, "buffer queue is empty\n");
-		return -EIO;
+		return -ENOBUFS;
 	}
 
 	/* Get the next frame from the buffer queue */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index c31bcf1..9d115cd 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -239,7 +239,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (list_empty(&common->dma_queue)) {
 		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_err("buffer queue is empty\n");
-		return -EIO;
+		return -ENOBUFS;
 	}
 
 	/* Get the next frame from the buffer queue */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ff3b6c..f0b41f8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1863,7 +1863,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 		if (ctx->src_bufs_cnt < ctx->pb_count) {
 			mfc_err("Need minimum %d OUTPUT buffers\n",
 					ctx->pb_count);
-			return -EINVAL;
+			return -ENOBUFS;
 		}
 	}
 
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 81b97db..c5059ba 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -948,7 +948,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	if (count == 0) {
 		mxr_dbg(mdev, "no output buffers queued\n");
-		return -EINVAL;
+		return -ENOBUFS;
 	}
 
 	/* block any changes in output configuration */
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 45a0276..d73abca 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -659,7 +659,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	unsigned long flags;
 
 	if (count < 2)
-		return -EINVAL;
+		return -ENOBUFS;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 24d98a6..c1a4625 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1201,6 +1201,8 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long addr;
 	int ret;
 
+	if (count == 0)
+		return -ENOBUFS;
 	ret = mutex_lock_interruptible(&video->lock);
 	if (ret)
 		goto streamoff;
-- 
1.8.4.3

