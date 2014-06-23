Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47310 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbaFWXyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jun 2014 19:54:04 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH v2 07/23] v4l: vsp1: Release buffers at stream stop
Date: Tue, 24 Jun 2014 01:54:13 +0200
Message-Id: <1403567669-18539-8-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

videobuf2 expects no buffer to be owned by the driver when the
stop_stream queue operation returns. As the vsp1 driver fails to do so,
a warning is generated at stream top time.

Fix this by mark releasing all buffers queued on the IRQ queue in the
stop_stream operation handler and marking them as erroneous.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index c717e28..9bb156c 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -742,6 +742,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 {
 	struct vsp1_video *video = vb2_get_drv_priv(vq);
 	struct vsp1_pipeline *pipe = to_vsp1_pipeline(&video->video.entity);
+	struct vsp1_video_buffer *buffer;
 	unsigned long flags;
 	int ret;
 
@@ -759,6 +760,8 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 
 	/* Remove all buffers from the IRQ queue. */
 	spin_lock_irqsave(&video->irqlock, flags);
+	list_for_each_entry(buffer, &video->irqqueue, queue)
+		vb2_buffer_done(&buffer->buf, VB2_BUF_STATE_ERROR);
 	INIT_LIST_HEAD(&video->irqqueue);
 	spin_unlock_irqrestore(&video->irqlock, flags);
 }
-- 
1.8.5.5

