Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42318 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaFFPVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jun 2014 11:21:23 -0400
Received: from avalon.ideasonboard.com (unknown [91.178.142.25])
	by perceval.ideasonboard.com (Postfix) with ESMTPSA id 14FB0363E0
	for <linux-media@vger.kernel.org>; Fri,  6 Jun 2014 17:20:54 +0200 (CEST)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] v4l: omap4iss: Signal fatal errors to the vb2 queue
Date: Fri,  6 Jun 2014 17:21:45 +0200
Message-Id: <1402068106-32677-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1402068106-32677-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When a fatal error occurs in the pipeline signal it to the vb2 queue
with a call to vb2_queue_error(). The queue will then take care to
return -EIO when preparing buffers, remove the driver-specific code that
now duplicates that check.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/staging/media/omap4iss/iss_video.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index a54ee8c..6dc6a45 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -331,15 +331,6 @@ static int iss_video_buf_prepare(struct vb2_buffer *vb)
 	if (vb2_plane_size(vb, 0) < size)
 		return -ENOBUFS;
 
-	/* Refuse to prepare the buffer is the video node has registered an
-	 * error. We don't need to take any lock here as the operation is
-	 * inherently racy. The authoritative check will be performed in the
-	 * queue handler, which can't return an error, this check is just a best
-	 * effort to notify userspace as early as possible.
-	 */
-	if (unlikely(video->error))
-		return -EIO;
-
 	addr = vb2_dma_contig_plane_dma_addr(vb, 0);
 	if (!IS_ALIGNED(addr, 32)) {
 		dev_dbg(video->iss->dev,
@@ -363,6 +354,11 @@ static void iss_video_buf_queue(struct vb2_buffer *vb)
 
 	spin_lock_irqsave(&video->qlock, flags);
 
+	/* Mark the buffer is faulty and give it back to the queue immediately
+	 * if the video node has registered an error. vb2 will perform the same
+	 * check when preparing the buffer, but that is inherently racy, so we
+	 * need to handle the race condition with an authoritative check here.
+	 */
 	if (unlikely(video->error)) {
 		vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
 		spin_unlock_irqrestore(&video->qlock, flags);
@@ -513,6 +509,7 @@ void omap4iss_video_cancel_stream(struct iss_video *video)
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
 	}
 
+	vb2_queue_error(video->queue);
 	video->error = true;
 
 	spin_unlock_irqrestore(&video->qlock, flags);
-- 
1.8.5.5

