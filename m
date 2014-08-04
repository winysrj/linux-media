Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4733 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaHDK1a (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 06:27:30 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com,
	Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org,
	#@tschai.lan, for@tschai.lan, v3.15@tschai.lan, and@tschai.lan,
	up@tschai.lan,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: [PATCH for v3.17 2/2] vb2: fix vb2 state check when start_streaming fails
Date: Mon,  4 Aug 2014 12:27:12 +0200
Message-Id: <1407148032-41607-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl>
References: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Commit bd994ddb2a12a3ff48cd549ec82cdceaea9614df (vb2: Fix stream start and
buffer completion race) broke the buffer state check in vb2_buffer_done.

So accept all three possible states there since I can no longer tell the
difference between vb2_buffer_done called from start_streaming or from
elsewhere.

Instead add a WARN_ON at the end of start_streaming that will check whether
any buffers were added to the done list, since that implies that the wrong
state was used as well.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org      # for v3.15 and up
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d3f2a22..7f70fd52 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1165,13 +1165,10 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
 	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
 		return;
 
-	if (!q->start_streaming_called) {
-		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
-			state = VB2_BUF_STATE_QUEUED;
-	} else if (WARN_ON(state != VB2_BUF_STATE_DONE &&
-			   state != VB2_BUF_STATE_ERROR)) {
-			state = VB2_BUF_STATE_ERROR;
-	}
+	if (WARN_ON(state != VB2_BUF_STATE_DONE &&
+		    state != VB2_BUF_STATE_ERROR &&
+		    state != VB2_BUF_STATE_QUEUED))
+		state = VB2_BUF_STATE_ERROR;
 
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	/*
@@ -1783,6 +1780,12 @@ static int vb2_start_streaming(struct vb2_queue *q)
 		/* Must be zero now */
 		WARN_ON(atomic_read(&q->owned_by_drv_count));
 	}
+	/*
+	 * If done_list is not empty, then start_streaming() didn't call
+	 * vb2_buffer_done(vb, VB2_BUF_STATE_QUEUED) but STATE_ERROR or
+	 * STATE_DONE.
+	 */
+	WARN_ON(!list_empty(&q->done_list));
 	return ret;
 }
 
-- 
2.0.1

