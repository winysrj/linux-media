Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45714 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752663AbaCANOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 08:14:00 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATH v6 06/10] v4l: Handle buffer timestamp flags correctly
Date: Sat,  1 Mar 2014 15:17:03 +0200
Message-Id: <1393679828-25878-7-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
References: <1393679828-25878-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

For COPY timestamps, buffer timestamp source flags will traverse the queue
untouched.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
 drivers/media/v4l2-core/videobuf2-core.c |   26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 3dda083..7afeb6b 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -488,7 +488,22 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
 	 * Clear any buffer state related flags.
 	 */
 	b->flags &= ~V4L2_BUFFER_MASK_FLAGS;
-	b->flags |= q->timestamp_flags;
+	if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+		/*
+		 * For COPY timestamps, we just set the timestamp type
+		 * here. The timestamp source is already in b->flags.
+		 */
+		b->flags |= q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK;
+	} else {
+		/*
+		 * For non-COPY timestamps, drop timestamp source and
+		 * obtain the timestamp type and source from the
+		 * queue.
+		 */
+		b->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+		b->flags |= q->timestamp_flags;
+	}
 
 	switch (vb->state) {
 	case VB2_BUF_STATE_QUEUED:
@@ -1031,6 +1046,15 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
 
 	/* Zero flags that the vb2 core handles */
 	vb->v4l2_buf.flags = b->flags & ~V4L2_BUFFER_MASK_FLAGS;
+	if ((vb->vb2_queue->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) !=
+	    V4L2_BUF_FLAG_TIMESTAMP_COPY) {
+		/*
+		 * Non-COPY timestamps will get their timestamp and
+		 * timestamp source flags from the queue.
+		 */
+		vb->v4l2_buf.flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+	}
+
 	if (V4L2_TYPE_IS_OUTPUT(b->type)) {
 		/*
 		 * For output buffers mask out the timecode flag:
-- 
1.7.10.4

