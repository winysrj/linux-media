Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:36200 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbbDUNKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:10:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	g.liakhovetski@gmx.de, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 10/15] vb2: add helper function to queue request-specific buffer.
Date: Tue, 21 Apr 2015 14:58:53 +0200
Message-Id: <1429621138-17213-11-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
References: <1429621138-17213-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The vb2_qbuf_request() function will queue any buffers for the given request
that are in state PREPARED.

Useful when drivers have to implement the req_queue callback.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/videobuf2-core.c | 18 ++++++++++++++++++
 include/media/videobuf2-core.h           |  1 +
 2 files changed, 19 insertions(+)

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index da513b1..4ab65b6 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -1923,6 +1923,24 @@ int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b)
 }
 EXPORT_SYMBOL_GPL(vb2_qbuf);
 
+int vb2_qbuf_request(struct vb2_queue *q, u16 request, struct vb2_buffer **p_buf)
+{
+	int buffer;
+
+	for (buffer = 0; buffer < q->num_buffers; buffer++) {
+		struct vb2_buffer *vb = q->bufs[buffer];
+
+		if (vb->v4l2_buf.request == request &&
+		    vb->state == VB2_BUF_STATE_PREPARED) {
+			if (p_buf)
+				*p_buf = vb;
+			return vb2_qbuf(q, &vb->v4l2_buf);
+		}
+	}
+	return -ENOENT;
+}
+EXPORT_SYMBOL_GPL(vb2_qbuf_request);
+
 /**
  * __vb2_wait_for_done_vb() - wait for a buffer to become available
  * for dequeuing
diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
index a3e3596..82fa2a6 100644
--- a/include/media/videobuf2-core.h
+++ b/include/media/videobuf2-core.h
@@ -461,6 +461,7 @@ void vb2_queue_release(struct vb2_queue *q);
 void vb2_queue_error(struct vb2_queue *q);
 
 int vb2_qbuf(struct vb2_queue *q, struct v4l2_buffer *b);
+int vb2_qbuf_request(struct vb2_queue *q, u16 request, struct vb2_buffer **p_buf);
 int vb2_expbuf(struct vb2_queue *q, struct v4l2_exportbuffer *eb);
 int vb2_dqbuf(struct vb2_queue *q, struct v4l2_buffer *b, bool nonblocking);
 
-- 
2.1.4

