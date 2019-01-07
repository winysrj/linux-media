Return-Path: <SRS0=8vfi=PP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 347E3C43387
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7ED2089F
	for <linux-media@archiver.kernel.org>; Mon,  7 Jan 2019 11:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727043AbfAGLer (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 7 Jan 2019 06:34:47 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:47017 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726917AbfAGLer (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Jan 2019 06:34:47 -0500
Received: from tschai.fritz.box ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id gTB4gFRVhBDyIgTB7gNVGO; Mon, 07 Jan 2019 12:34:45 +0100
From:   hverkuil-cisco@xs4all.nl
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCHv6 1/8] v4l2-mem2mem: add v4l2_m2m_buf_copy_data helper function
Date:   Mon,  7 Jan 2019 12:34:34 +0100
Message-Id: <20190107113441.21569-2-hverkuil-cisco@xs4all.nl>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
References: <20190107113441.21569-1-hverkuil-cisco@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfL7yrtaprygR5r3Y6+G/G6g5EWnu3yOv6gz2s0phEE2+inUfwGJyeCoBj6LREXXenpzUVoghw7H+rrR1kwa9Z5NAScEhOD8NZICiaVswZWE6EOdsudZo
 Bi5DNELkmDufrtvXA5Xa6cMCAhv4oqJSKBvHiN3NsI7XF2e6bwm4SD1BeNDp2CkVH6JeNOsPtsciE4hVnLwckYNLvKe0i7NCPvLPt+7o6nJvWc6mxERkRGjA
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Memory-to-memory devices should copy various parts of
struct v4l2_buffer from the output buffer to the capture buffer.

Add a helper function that does that to simplify the driver code.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reviewed-by: Alexandre Courbot <acourbot@chromium.org>
---
 drivers/media/v4l2-core/v4l2-mem2mem.c | 20 ++++++++++++++++++++
 include/media/v4l2-mem2mem.h           | 20 ++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 5bbdec55b7d7..631f4e2aa942 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -975,6 +975,26 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
+void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
+			    struct vb2_v4l2_buffer *cap_vb,
+			    bool copy_frame_flags)
+{
+	u32 mask = V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
+
+	if (copy_frame_flags)
+		mask |= V4L2_BUF_FLAG_KEYFRAME | V4L2_BUF_FLAG_PFRAME |
+			V4L2_BUF_FLAG_BFRAME;
+
+	cap_vb->vb2_buf.timestamp = out_vb->vb2_buf.timestamp;
+
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
index 5467264771ec..43e447dcf69d 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -622,6 +622,26 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
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
+ * buffer flag was set), field and the TIMECODE, KEYFRAME, BFRAME, PFRAME
+ * and TSTAMP_SRC_MASK flags from @out_vb to @cap_vb.
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
2.19.2

