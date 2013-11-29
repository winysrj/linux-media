Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43066 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab3K2Wu5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Nov 2013 17:50:57 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH 1/6] v4l: vsp1: Supply frames to the DU continuously
Date: Fri, 29 Nov 2013 23:50:47 +0100
Message-Id: <1385765452-25754-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1385765452-25754-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When operating in DU output mode (deep pipeline to the DU through the
LIF), the VSP1 needs to constantly supply frames to the display. To
ensure reuse the last queued buffer instead of returning it to the user.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 4b0ac07..b4687a8 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -488,11 +488,17 @@ static bool vsp1_pipeline_ready(struct vsp1_pipeline *pipe)
  * This function completes the current buffer by filling its sequence number,
  * time stamp and payload size, and hands it back to the videobuf core.
  *
+ * When operating in DU output mode (deep pipeline to the DU through the LIF),
+ * the VSP1 needs to constantly supply frames to the display. In that case, if
+ * no other buffer is queued, reuse the one that has just been processed instead
+ * of handing it back to the videobuf core.
+ *
  * Return the next queued buffer or NULL if the queue is empty.
  */
 static struct vsp1_video_buffer *
 vsp1_video_complete_buffer(struct vsp1_video *video)
 {
+	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
 	struct vsp1_video_buffer *next = NULL;
 	struct vsp1_video_buffer *done;
 	unsigned long flags;
@@ -507,6 +513,13 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
 
 	done = list_first_entry(&video->irqqueue,
 				struct vsp1_video_buffer, queue);
+
+	/* In DU output mode reuse the buffer if the list is singular. */
+	if (pipe->lif && list_is_singular(&video->irqqueue)) {
+		spin_unlock_irqrestore(&video->irqlock, flags);
+		return done;
+	}
+
 	list_del(&done->queue);
 
 	if (!list_empty(&video->irqqueue))
-- 
1.8.3.2

