Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:60281 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab0DUMMY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Apr 2010 08:12:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L18006HP78E1M70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:12:19 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1800FQK77P7T@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Apr 2010 13:11:49 +0100 (BST)
Date: Wed, 21 Apr 2010 13:39:44 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH v3 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
In-reply-to: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <1271849985-368-3-git-send-email-p.osciak@samsung.com>
References: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hverkuil@xs4all.nl>

For recoverable stream errors dqbuf() now returns 0 and the error flag
is set instead of returning EIO.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/videobuf-core.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/media/video/videobuf-core.c b/drivers/media/video/videobuf-core.c
index 63d7043..1cf084f 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -286,8 +286,10 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
 	case VIDEOBUF_ACTIVE:
 		b->flags |= V4L2_BUF_FLAG_QUEUED;
 		break;
-	case VIDEOBUF_DONE:
 	case VIDEOBUF_ERROR:
+		b->flags |= V4L2_BUF_FLAG_ERROR;
+		/* fall through */
+	case VIDEOBUF_DONE:
 		b->flags |= V4L2_BUF_FLAG_DONE;
 		break;
 	case VIDEOBUF_NEEDS_INIT:
@@ -668,6 +670,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
+	memset(b, 0, sizeof(*b));
 	mutex_lock(&q->vb_lock);
 
 	retval = stream_next_buffer(q, &buf, nonblocking);
@@ -679,23 +682,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 	switch (buf->state) {
 	case VIDEOBUF_ERROR:
 		dprintk(1, "dqbuf: state is error\n");
-		retval = -EIO;
-		CALL(q, sync, q, buf);
-		buf->state = VIDEOBUF_IDLE;
 		break;
 	case VIDEOBUF_DONE:
 		dprintk(1, "dqbuf: state is done\n");
-		CALL(q, sync, q, buf);
-		buf->state = VIDEOBUF_IDLE;
 		break;
 	default:
 		dprintk(1, "dqbuf: state invalid\n");
 		retval = -EINVAL;
 		goto done;
 	}
-	list_del(&buf->stream);
-	memset(b, 0, sizeof(*b));
+	CALL(q, sync, q, buf);
 	videobuf_status(q, b, buf, q->type);
+	list_del(&buf->stream);
+	buf->state = VIDEOBUF_IDLE;
+	b->flags &= ~V4L2_BUF_FLAG_DONE;
 done:
 	mutex_unlock(&q->vb_lock);
 	return retval;
-- 
1.7.1.rc1.12.ga601

