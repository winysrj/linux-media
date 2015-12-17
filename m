Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44651 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934228AbbLQIlO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Dec 2015 03:41:14 -0500
From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Subject: [PATCH/RFC 34/48] vb2: Add helper function to queue request-specific buffer.
Date: Thu, 17 Dec 2015 10:40:12 +0200
Message-Id: <1450341626-6695-35-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1450341626-6695-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2_qbuf_request() function will queue any buffers for the given request
that are in state PREPARED.

Useful when drivers have to implement the req_queue callback.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-v4l2.c | 31 +++++++++++++++++++++++++++++++
 include/media/videobuf2-v4l2.h           |  1 +
 2 files changed, 32 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-v4l2.c b/drivers/media/v4l2-core/videobuf2-v4l2.c
index 0db7d67092ab..1f649b15990f 100644
--- a/drivers/media/v4l2-core/videobuf2-v4l2.c
+++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
@@ -113,6 +113,9 @@ static int __set_timestamp(struct vb2_buffer *vb, const void *pb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct vb2_queue *q = vb->vb2_queue;
 
+	if (!pb)
+		return 0;
+
 	if (q->is_output) {
 		/*
 		 * For output buffers copy the timestamp if needed,
@@ -188,6 +191,9 @@ static int __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
 	struct vb2_queue *q = vb->vb2_queue;
 	unsigned int plane;
 
+	if (!pb)
+		return 0;
+
 	/* Copy back data such as timestamp, flags, etc. */
 	b->index = vb->index;
 	b->type = vb->type;
@@ -578,6 +584,31 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
+int vb2_qbuf_request(struct vb2_queue *q, u16 request, struct vb2_buffer **p_buf)
+{
+	unsigned int buffer;
+
+	for (buffer = 0; buffer < q->num_buffers; buffer++) {
+		struct vb2_buffer *vb = q->bufs[buffer];
+		struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
+
+		if (vbuf->request == request &&
+		    vb->state == VB2_BUF_STATE_PREPARED) {
+			if (p_buf)
+				*p_buf = vb;
+			/*
+			 * The buffer has already been prepared so we can skip
+			 * the vb2_queue_or_prepare_buf() call in vb2_qbuf() and
+			 * call the core function directly.
+			 */
+			return vb2_core_qbuf(q, vb->index, NULL);
+		}
+	}
+
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(vb2_qbuf_request);
+
 static int vb2_internal_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b,
 		bool nonblocking)
 {
diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
index 7cb428fc66ad..bc742a174f2b 100644
--- a/include/media/videobuf2-v4l2.h
+++ b/include/media/videobuf2-v4l2.h
@@ -59,6 +59,7 @@ int vb2_create_bufs(struct vb2_queue *q, struct v4l2_create_buffers *create);
 int vb2_prepare_buf(struct vb2_queue *q, struct v4l2_buffer *b);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_qbuf_request(struct vb2_queue *q, u16 request, struct vb2_buffer **p_buf);
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
-- 
2.4.10

