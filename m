Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965080AbcKDRyB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 Nov 2016 13:54:01 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCHv2 1/2] Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
Date: Fri,  4 Nov 2016 17:53:51 +0000
Message-Id: <1478282032-17571-2-git-send-email-kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <1478282032-17571-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
References: <1478282032-17571-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This reverts commit 3299ba5c0b21 ("[media] v4l: vsp1: Supply frames to
the DU continuously")

The DU output mode does not rely on frames being supplied on the WPF as
its pipeline is supplied from DRM. For the upcoming WPF writeback
functionality, we will choose to enable writeback mode if there is an
output buffer, or disable it (leaving the existing display pipeline
unharmed) otherwise.

Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 94b428596c4f..f10401065cd3 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -296,11 +296,6 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
  * This function completes the current buffer by filling its sequence number,
  * time stamp and payload size, and hands it back to the videobuf core.
  *
- * When operating in DU output mode (deep pipeline to the DU through the LIF),
- * the VSP1 needs to constantly supply frames to the display. In that case, if
- * no other buffer is queued, reuse the one that has just been processed instead
- * of handing it back to the videobuf core.
- *
  * Return the next queued buffer or NULL if the queue is empty.
  */
 static struct vsp1_vb2_buffer *
@@ -322,12 +317,6 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 	done = list_first_entry(&video->irqqueue,
 				struct vsp1_vb2_buffer, queue);
 
-	/* In DU output mode reuse the buffer if the list is singular. */
-	if (pipe->lif && list_is_singular(&video->irqqueue)) {
-		spin_unlock_irqrestore(&video->irqlock, flags);
-		return done;
-	}
-
 	list_del(&done->queue);
 
 	if (!list_empty(&video->irqqueue))
-- 
2.7.4

