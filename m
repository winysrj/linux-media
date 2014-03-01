Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46216 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752972AbaCAQJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Mar 2014 11:09:55 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, k.debski@samsung.com,
	laurent.pinchart@ideasonboard.com
Subject: [PATH v6 05.1/11] v4l: Timestamp flags will soon contain timestamp source, not just type
Date: Sat,  1 Mar 2014 18:13:07 +0200
Message-Id: <1393690387-4826-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1393679828-25878-6-git-send-email-sakari.ailus@iki.fi>
References: <1393679828-25878-6-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mask out other bits when comparing timestamp types.

Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
---
This change was missing from the set. The check needs to be changed as there
will be also timestamp source flags, not just timestamp type flags in the
field.

 drivers/media/v4l2-core/videobuf2-core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 411429c..521350a 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1473,7 +1473,8 @@ static int vb2_internal_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 		 * For output buffers copy the timestamp if needed,
 		 * and the timecode field and flag if needed.
 		 */
-		if (q->timestamp_flags == V4L2_BUF_FLAG_TIMESTAMP_COPY)
+		if ((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		    V4L2_BUF_FLAG_TIMESTAMP_COPY)
 			vb->v4l2_buf.timestamp = b->timestamp;
 		vb->v4l2_buf.flags |= b->flags & V4L2_BUF_FLAG_TIMECODE;
 		if (b->flags & V4L2_BUF_FLAG_TIMECODE)
@@ -2230,7 +2231,8 @@ int vb2_queue_init(struct vb2_queue *q)
 		return -EINVAL;
 
 	/* Warn that the driver should choose an appropriate timestamp type */
-	WARN_ON(q->timestamp_flags == V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
+	WARN_ON((q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
+		V4L2_BUF_FLAG_TIMESTAMP_UNKNOWN);
 
 	INIT_LIST_HEAD(&q->queued_list);
 	INIT_LIST_HEAD(&q->done_list);
-- 
1.7.10.4

