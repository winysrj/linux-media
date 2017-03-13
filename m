Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36393 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751700AbdCMTUt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Mar 2017 15:20:49 -0400
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [RFC 02/10] [media] vb2: split out queueing from vb_core_qbuf()
Date: Mon, 13 Mar 2017 16:20:27 -0300
Message-Id: <20170313192035.29859-3-gustavo@padovan.org>
In-Reply-To: <20170313192035.29859-1-gustavo@padovan.org>
References: <20170313192035.29859-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

In order to support explicit synchronization we need to divide
vb2_core_qbuf() in two parts one, to be executed before the fence
signals and another one after that, to do the actual queueing of
the buffer.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 65 ++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index 94afbbf9..0e30fcd 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1363,29 +1363,10 @@ static int vb2_start_streaming(struct vb2_queue *q)
 	return ret;
 }
 
-int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+static int __vb2_core_qbuf(struct vb2_buffer *vb, struct vb2_queue *q)
 {
-	struct vb2_buffer *vb;
 	int ret;
 
-	vb = q->bufs[index];
-
-	switch (vb->state) {
-	case VB2_BUF_STATE_DEQUEUED:
-		ret = __buf_prepare(vb, pb);
-		if (ret)
-			return ret;
-		break;
-	case VB2_BUF_STATE_PREPARED:
-		break;
-	case VB2_BUF_STATE_PREPARING:
-		dprintk(1, "buffer still being prepared\n");
-		return -EINVAL;
-	default:
-		dprintk(1, "invalid buffer state %d\n", vb->state);
-		return -EINVAL;
-	}
-
 	/*
 	 * Add to the queued buffers list, a buffer will stay on it until
 	 * dequeued in dqbuf.
@@ -1395,11 +1376,6 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	q->waiting_for_buffers = false;
 	vb->state = VB2_BUF_STATE_QUEUED;
 
-	if (pb)
-		call_void_bufop(q, copy_timestamp, vb, pb);
-
-	trace_vb2_qbuf(q, vb);
-
 	/*
 	 * If already streaming, give the buffer to driver for processing.
 	 * If not, the buffer will be given to driver on next streamon.
@@ -1407,10 +1383,6 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	if (q->start_streaming_called)
 		__enqueue_in_driver(vb);
 
-	/* Fill buffer information for the userspace */
-	if (pb)
-		call_void_bufop(q, fill_user_buffer, vb, pb);
-
 	/*
 	 * If streamon has been called, and we haven't yet called
 	 * start_streaming() since not enough buffers were queued, and
@@ -1427,6 +1399,41 @@ int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
 	dprintk(1, "qbuf of buffer %d succeeded\n", vb->index);
 	return 0;
 }
+
+int vb2_core_qbuf(struct vb2_queue *q, unsigned int index, void *pb)
+{
+	struct vb2_buffer *vb;
+	int ret;
+
+	vb = q->bufs[index];
+
+	switch (vb->state) {
+	case VB2_BUF_STATE_DEQUEUED:
+		ret = __buf_prepare(vb, pb);
+		if (ret)
+			return ret;
+		break;
+	case VB2_BUF_STATE_PREPARED:
+		break;
+	case VB2_BUF_STATE_PREPARING:
+		dprintk(1, "buffer still being prepared\n");
+		return -EINVAL;
+	default:
+		dprintk(1, "invalid buffer state %d\n", vb->state);
+		return -EINVAL;
+	}
+
+	if (pb)
+		call_void_bufop(q, copy_timestamp, vb, pb);
+
+	trace_vb2_qbuf(q, vb);
+
+	/* Fill buffer information for the userspace */
+	if (pb)
+		call_void_bufop(q, fill_user_buffer, vb, pb);
+
+	return __vb2_core_qbuf(vb, q);
+}
 EXPORT_SYMBOL_GPL(vb2_core_qbuf);
 
 /**
-- 
2.9.3
