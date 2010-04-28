Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64812 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab0D1HFn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Apr 2010 03:05:43 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L1K00K73RPG05@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Apr 2010 08:05:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1K000VYRPGEX@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Apr 2010 08:05:40 +0100 (BST)
Date: Wed, 28 Apr 2010 09:05:22 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: [PATCH 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
In-reply-to: <1272438323-4790-1-git-send-email-p.osciak@samsung.com>
To: linux-media@vger.kernel.org
Cc: p.osciak@samsung.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <1272438323-4790-3-git-send-email-p.osciak@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1272438323-4790-1-git-send-email-p.osciak@samsung.com>
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
index 03b32e4..7d33784 100644
--- a/drivers/media/video/videobuf-core.c
+++ b/drivers/media/video/videobuf-core.c
@@ -285,8 +285,10 @@ static void videobuf_status(struct videobuf_queue *q, struct v4l2_buffer *b,
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
@@ -670,6 +672,7 @@ int videobuf_dqbuf(struct videobuf_queue *q,
 
 	MAGIC_CHECK(q->int_ops->magic, MAGIC_QTYPE_OPS);
 
+	memset(b, 0, sizeof(*b));
 	mutex_lock(&q->vb_lock);
 
 	retval = stream_next_buffer(q, &buf, nonblocking);
@@ -681,23 +684,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
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

