Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:44430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754399AbdEIQkC (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 May 2017 12:40:02 -0400
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: laurent.pinchart@ideasonboard.com
Cc: dri-devel@lists.freedesktop.org, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v3 1/2] Revert "[media] v4l: vsp1: Supply frames to the DU continuously"
Date: Tue,  9 May 2017 17:39:51 +0100
Message-Id: <bdf682b44a1ea5060d46f81620b82ff528fdd68a.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ebf0f0df2d74f2a209e8b628269e3cac27d4a2ab.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ebf0f0df2d74f2a209e8b628269e3cac27d4a2ab.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
In-Reply-To: <cover.ebf0f0df2d74f2a209e8b628269e3cac27d4a2ab.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
References: <cover.ebf0f0df2d74f2a209e8b628269e3cac27d4a2ab.1494347923.git-series.kieran.bingham+renesas@ideasonboard.com>
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
index eab3c3ea85d7..47b5c24043d7 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -304,11 +304,6 @@ static struct v4l2_rect vsp1_video_partition(struct vsp1_pipeline *pipe,
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
@@ -330,12 +325,6 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
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
git-series 0.9.1
