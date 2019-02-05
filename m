Return-Path: <SRS0=c0D3=QM=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 240AFC282CB
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 21:20:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ECDE020823
	for <linux-media@archiver.kernel.org>; Tue,  5 Feb 2019 21:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfBEVUq (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 5 Feb 2019 16:20:46 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:41990 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbfBEVUq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2019 16:20:46 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 952B1280229
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH] media: v4l2-mem2mem: Rename v4l2_m2m_buf_copy_data to v4l2_m2m_buf_copy_metadata
Date:   Tue,  5 Feb 2019 18:20:33 -0300
Message-Id: <20190205212033.15448-1-ezequiel@collabora.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

The v4l2_m2m_buf_copy_data helper is used to copy the buffer
metadata, such as its timestamp and its flags.

Therefore, the v4l2_m2m_buf_copy_metadata name is more clear
and avoids confusion with a payload data copy.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/vicodec/vicodec-core.c |  4 ++--
 drivers/media/platform/vim2m.c                |  2 +-
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  8 ++++----
 include/media/v4l2-mem2mem.h                  | 14 +++++++-------
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 3703b587e25e..3bf6cc4daff3 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -199,7 +199,7 @@ static int device_process(struct vicodec_ctx *ctx,
 
 	dst_vb->sequence = q_dst->sequence++;
 	dst_vb->flags &= ~V4L2_BUF_FLAG_LAST;
-	v4l2_m2m_buf_copy_data(src_vb, dst_vb, !ctx->is_enc);
+	v4l2_m2m_buf_copy_metadata(src_vb, dst_vb, !ctx->is_enc);
 
 	return 0;
 }
@@ -414,7 +414,7 @@ static void set_last_buffer(struct vb2_v4l2_buffer *dst_buf,
 	vb2_set_plane_payload(&dst_buf->vb2_buf, 0, 0);
 	dst_buf->sequence = q_dst->sequence++;
 
-	v4l2_m2m_buf_copy_data(src_buf, dst_buf, !ctx->is_enc);
+	v4l2_m2m_buf_copy_metadata(src_buf, dst_buf, !ctx->is_enc);
 	dst_buf->flags |= V4L2_BUF_FLAG_LAST;
 	v4l2_m2m_buf_done(dst_buf, VB2_BUF_STATE_DONE);
 }
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index e31c14c7d37f..0768f7a9e34f 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -432,7 +432,7 @@ static int device_process(struct vim2m_ctx *ctx,
 	out_vb->sequence = get_q_data(ctx,
 				      V4L2_BUF_TYPE_VIDEO_CAPTURE)->sequence++;
 	in_vb->sequence = q_data_in->sequence++;
-	v4l2_m2m_buf_copy_data(in_vb, out_vb, true);
+	v4l2_m2m_buf_copy_metadata(in_vb, out_vb, true);
 
 	if (ctx->mode & MEM2MEM_VFLIP) {
 		start = height - 1;
diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
index 631f4e2aa942..1494d0d5951a 100644
--- a/drivers/media/v4l2-core/v4l2-mem2mem.c
+++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
@@ -975,9 +975,9 @@ void v4l2_m2m_buf_queue(struct v4l2_m2m_ctx *m2m_ctx,
 }
 EXPORT_SYMBOL_GPL(v4l2_m2m_buf_queue);
 
-void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
-			    struct vb2_v4l2_buffer *cap_vb,
-			    bool copy_frame_flags)
+void v4l2_m2m_buf_copy_metadata(const struct vb2_v4l2_buffer *out_vb,
+				struct vb2_v4l2_buffer *cap_vb,
+				bool copy_frame_flags)
 {
 	u32 mask = V4L2_BUF_FLAG_TIMECODE | V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
 
@@ -993,7 +993,7 @@ void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
 	cap_vb->flags &= ~mask;
 	cap_vb->flags |= out_vb->flags & mask;
 }
-EXPORT_SYMBOL_GPL(v4l2_m2m_buf_copy_data);
+EXPORT_SYMBOL_GPL(v4l2_m2m_buf_copy_metadata);
 
 void v4l2_m2m_request_queue(struct media_request *req)
 {
diff --git a/include/media/v4l2-mem2mem.h b/include/media/v4l2-mem2mem.h
index 43e447dcf69d..47c6d9aa0bf4 100644
--- a/include/media/v4l2-mem2mem.h
+++ b/include/media/v4l2-mem2mem.h
@@ -623,11 +623,11 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
 }
 
 /**
- * v4l2_m2m_buf_copy_data() - copy buffer data from the output buffer to the
- * capture buffer
+ * v4l2_m2m_buf_copy_metadata() - copy buffer metadata from
+ * the output buffer to the capture buffer
  *
- * @out_vb: the output buffer that is the source of the data.
- * @cap_vb: the capture buffer that will receive the data.
+ * @out_vb: the output buffer that is the source of the metadata.
+ * @cap_vb: the capture buffer that will receive the metadata.
  * @copy_frame_flags: copy the KEY/B/PFRAME flags as well.
  *
  * This helper function copies the timestamp, timecode (if the TIMECODE
@@ -638,9 +638,9 @@ v4l2_m2m_dst_buf_remove_by_idx(struct v4l2_m2m_ctx *m2m_ctx, unsigned int idx)
  * flags are not copied. This is typically needed for encoders that
  * set this bits explicitly.
  */
-void v4l2_m2m_buf_copy_data(const struct vb2_v4l2_buffer *out_vb,
-			    struct vb2_v4l2_buffer *cap_vb,
-			    bool copy_frame_flags);
+void v4l2_m2m_buf_copy_metadata(const struct vb2_v4l2_buffer *out_vb,
+				struct vb2_v4l2_buffer *cap_vb,
+				bool copy_frame_flags);
 
 /* v4l2 request helper */
 
-- 
2.20.1

