Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:52953 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933127AbcFTTOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 15:14:00 -0400
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-renesas-soc@vger.kernel.org
Subject: [PATCH 24/24] v4l: vsp1: Stop the pipeline upon the first STREAMOFF
Date: Mon, 20 Jun 2016 22:10:42 +0300
Message-Id: <1466449842-29502-25-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The device is stopped when STREAMOFF is called on the last video node in
the pipeline. This results in possible memory corruption and/or crashes,
as userspace could free buffers while the hardware is still writing to
them, and the frame completion interrupt handler could try to access
buffers that don't exist anymore.

Fix this by stopping the pipeline upon the first STREAMOFF call, not the
last.

Reported-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/platform/vsp1/vsp1_video.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index f2cb19bd86ca..7d491b7b29e2 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -686,7 +686,7 @@ static void vsp1_video_stop_streaming(struct vb2_queue *vq)
 	int ret;
 
 	mutex_lock(&pipe->lock);
-	if (--pipe->stream_count == 0) {
+	if (--pipe->stream_count == pipe->num_inputs) {
 		/* Stop the pipeline. */
 		ret = vsp1_pipeline_stop(pipe);
 		if (ret == -ETIMEDOUT)
-- 
Regards,

Laurent Pinchart

