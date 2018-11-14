Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:41661 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733107AbeKNXvK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 18:51:10 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Alexandre Courbot <acourbot@chromium.org>,
        maxime.ripard@bootlin.com, paul.kocialkowski@bootlin.com,
        tfiga@chromium.org, Nicolas Dufresne <nicolas@ndufresne.ca>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 5/9] v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
Date: Wed, 14 Nov 2018 14:47:39 +0100
Message-Id: <20181114134743.18993-6-hverkuil@xs4all.nl>
In-Reply-To: <20181114134743.18993-1-hverkuil@xs4all.nl>
References: <20181114134743.18993-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Memory-to-memory devices should copy various parts of
struct v4l2_buffer from the output buffer to the capture buffer.

Add a helper function that does that to simplify the driver code.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 23 +++++++++++++++++++++++
 include/media/v4l2-mem2mem.h           | 21 +++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 1ed2465972ac..bfd5321fda1c 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -953,6 +953,29 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
+void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
+			    struct vb2_v4l2_buffer *cap_vb,
+			    bool copy_frame_flags)
+{
+	u32 mask = V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TAG |
+		   V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+	if (copy_frame_flags)
+		mask |= V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME |
+			V4L2_BUF_FLAG_BFRAME;
+
+	cap_vb->vb2_buf.timestamp = out_vb->vb2_buf.timestamp;
+
+	if (out_vb->flags & V4L2_BUF_FLAG_TAG)
+		cap_vb->tag = out_vb->tag;
+	if (out_vb->flags & V4L2_BUF_FLAG_TIMECODE)
+		cap_vb->timecode = out_vb->timecode;
+	cap_vb->field = out_vb->field;
+	cap_vb->flags &= ~mask;
+	cap_vb->flags |= out_vb->flags & mask;
+}
+EXPORT_SYMBOL_GPL(v4l2_m2m_buf_copy_data);
+
 void v4l2_m2m_request_queue(struct media_request *req)
 {
 	struct media_request_object *obj, *obj_safe;
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 5467264771ec..bb4feb6969d2 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -622,6 +622,27 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
 	return v4l2_m2m_buf_remove_by_idx(&m2m_ctx->cap_q_ctx, idx);
 }
 
+/**
+ * v4l2_m2m_buf_copy_data() - copy buffer data from the output buffer to the
+ * capture buffer
+ *
+ * @out_vb: the output buffer that is the source of the data.
+ * @cap_vb: the capture buffer that will receive the data.
+ * @copy_frame_flags: copy the KEY/B/PFRAME flags as well.
+ *
+ * This helper function copies the timestamp, timecode (if the TIMECODE
+ * buffer flag was set), tag (if the TAG buffer flag was set), field
+ * and the TIMECODE, TAG, KEYFRAME, BFRAME, PFRAME and TSTAMP_SRC_MASK
+ * flags from @out_vb to @cap_vb.
+ *
+ * If @copy_frame_flags is false, then the KEYFRAME, BFRAME and PFRAME
+ * flags are not copied. This is typically needed for encoders that
+ * set this bits explicitly.
+ */
+void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
+			    struct vb2_v4l2_buffer *cap_vb,
+			    bool copy_frame_flags);
+
 /* v4l2 request helper */
 
 void v4l2_m2m_request_queue(struct media_request *req);
-- 
2.19.1
