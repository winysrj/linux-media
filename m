Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3222 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab3KUPWn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Nov 2013 10:22:43 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, pawel@osciak.com,
	awalls@md.metrocast.net, laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 6/8] vb2: return ENODATA in start_streaming in case of too few buffers.
Date: Thu, 21 Nov 2013 16:22:04 +0100
Message-Id: <1385047326-23099-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
References: <1385047326-23099-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
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
index eac472b..53be7fc 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -347,7 +347,7 @@ static int vpbe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	/* If buffer queue is empty, return error */
 	if (list_empty(&layer->dma_queue)) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "buffer queue is empty\n");
-		return -EINVAL;
+		return -ENODATA;
 	}
 	/* Get the next frame from the buffer queue */
 	layer->next_frm = layer->cur_frm = list_entry(layer->dma_queue.next,
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index 52ac5e6..4b04a27 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -277,7 +277,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (list_empty(&common->dma_queue)) {
 		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_dbg(1, debug, "buffer queue is empty\n");
-		return -EIO;
+		return -ENODATA;
 	}
 
 	/* Get the next frame from the buffer queue */
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index c31bcf1..c5070dc 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -239,7 +239,7 @@ static int vpif_start_streaming(struct vb2_queue *vq, unsigned int count)
 	if (list_empty(&common->dma_queue)) {
 		spin_unlock_irqrestore(&common->irqlock, flags);
 		vpif_err("buffer queue is empty\n");
-		return -EIO;
+		return -ENODATA;
 	}
 
 	/* Get the next frame from the buffer queue */
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 4ff3b6c..3bdfe85 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1863,7 +1863,7 @@ static int s5p_mfc_start_streaming(struct vb2_queue *q, unsigned int count)
 		if (ctx->src_bufs_cnt < ctx->pb_count) {
 			mfc_err("Need minimum %d OUTPUT buffers\n",
 					ctx->pb_count);
-			return -EINVAL;
+			return -ENODATA;
 		}
 	}
 
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 641b1f0..7d2fe64 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -948,7 +948,7 @@ static int start_streaming(struct vb2_queue *vq, unsigned int count)
 
 	if (count == 0) {
 		mxr_dbg(mdev, "no output buffers queued\n");
-		return -EINVAL;
+		return -ENODATA;
 	}
 
 	/* block any changes in output configuration */
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 45a0276..587e3d1 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -659,7 +659,7 @@ static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
 	unsigned long flags;
 
 	if (count < 2)
-		return -EINVAL;
+		return -ENODATA;
 
 	spin_lock_irqsave(&pcdev->lock, flags);
 
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 24d98a6..a81b0ab 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -1201,6 +1201,8 @@ static int vpfe_start_streaming(struct vb2_queue *vq, unsigned int count)
 	unsigned long addr;
 	int ret;
 
+	if (count == 0)
+		return -ENODATA;
 	ret = mutex_lock_interruptible(&video->lock);
 	if (ret)
 		goto streamoff;
-- 
1.8.4.3

