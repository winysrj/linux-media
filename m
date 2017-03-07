Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:36789 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755678AbdCGPqq (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 10:46:46 -0500
Received: by mail-pg0-f42.google.com with SMTP id 187so1757660pgb.3
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 07:46:46 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, hans.verkuil@cisco.com,
        wuchengli@google.com
Cc: djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH v2 1/1] mtk-vcodec: check the vp9 decoder buffer index from VPU.
Date: Tue,  7 Mar 2017 22:42:07 +0800
Message-Id: <20170307144207.133234-2-wuchengli@chromium.org>
In-Reply-To: <20170307144207.133234-1-wuchengli@chromium.org>
References: <20170307144207.133234-1-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

VPU firmware has a bug and may return invalid buffer index for
some vp9 videos. Check the buffer indexes before accessing the
buffer.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 23 ++++++++++++++-----
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h |  2 ++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
 4 files changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 502877a4b1df..8a9285a84d47 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -420,6 +420,11 @@ static void mtk_vdec_worker(struct work_struct *work)
 			dst_buf->index,
 			ret, res_chg);
 		src_buf = v4l2_m2m_src_buf_remove(ctx->m2m_ctx);
+		if (ret == -EIO) {
+			mutex_lock(&ctx->lock);
+			src_buf_info->error = true;
+			mutex_unlock(&ctx->lock);
+		}
 		v4l2_m2m_buf_done(&src_buf_info->vb, VB2_BUF_STATE_ERROR);
 	} else if (res_chg == false) {
 		/*
@@ -1176,6 +1181,11 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
 			       ctx->id, src_buf->index,
 			       src_mem.size, ret, res_chg);
+		if (ret == -EIO) {
+			mtk_v4l2_err("[%d] Unrecoverable error in vdec_if_decode.",
+					ctx->id);
+			ctx->state = MTK_STATE_ABORT;
+		}
 		return;
 	}
 
@@ -1217,14 +1227,17 @@ static void vb2ops_vdec_buf_finish(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vb2_v4l2;
 	struct mtk_video_dec_buf *buf;
 
-	if (vb->vb2_queue->type != V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
-		return;
-
 	vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
 	buf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
 	mutex_lock(&ctx->lock);
-	buf->queued_in_v4l2 = false;
-	buf->queued_in_vb2 = false;
+	if (buf->error) {
+		mtk_v4l2_err("Unrecoverable error on buffer.");
+		ctx->state = MTK_STATE_ABORT;
+	}
+	if (vb->vb2_queue->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
+		buf->queued_in_v4l2 = false;
+		buf->queued_in_vb2 = false;
+	}
 	mutex_unlock(&ctx->lock);
 }
 
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
index 362f5a85762e..dc4fc1df63c5 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.h
@@ -50,6 +50,7 @@ struct vdec_fb {
  * @queued_in_v4l2:	Capture buffer is in v4l2 driver, but not in vb2
  *			queue yet
  * @lastframe:		Intput buffer is last buffer - EOS
+ * @error:		An unrecoverable error occurs on this buffer.
  * @frame_buffer:	Decode status, and buffer information of Capture buffer
  *
  * Note : These status information help us track and debug buffer state
@@ -63,6 +64,7 @@ struct mtk_video_dec_buf {
 	bool	queued_in_vb2;
 	bool	queued_in_v4l2;
 	bool	lastframe;
+	bool	error;
 	struct vdec_fb	frame_buffer;
 };
 
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index e91a3b425b0c..5539b1853f16 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -718,6 +718,26 @@ static void get_free_fb(struct vdec_vp9_inst *inst, struct vdec_fb **out_fb)
 	*out_fb = fb;
 }
 
+static int validate_vsi_array_indexes(struct vdec_vp9_inst *inst,
+		struct vdec_vp9_vsi *vsi) {
+	if (vsi->sf_frm_idx >= VP9_MAX_FRM_BUF_NUM - 1) {
+		mtk_vcodec_err(inst, "Invalid vsi->sf_frm_idx=%u.",
+				vsi->sf_frm_idx);
+		return -EIO;
+	}
+	if (vsi->frm_to_show_idx >= VP9_MAX_FRM_BUF_NUM) {
+		mtk_vcodec_err(inst, "Invalid vsi->frm_to_show_idx=%u.",
+				vsi->frm_to_show_idx);
+		return -EIO;
+	}
+	if (vsi->new_fb_idx >= VP9_MAX_FRM_BUF_NUM) {
+		mtk_vcodec_err(inst, "Invalid vsi->new_fb_idx=%u.",
+				vsi->new_fb_idx);
+		return -EIO;
+	}
+	return 0;
+}
+
 static void vdec_vp9_deinit(unsigned long h_vdec)
 {
 	struct vdec_vp9_inst *inst = (struct vdec_vp9_inst *)h_vdec;
@@ -834,6 +854,12 @@ static int vdec_vp9_decode(unsigned long h_vdec, struct mtk_vcodec_mem *bs,
 			goto DECODE_ERROR;
 		}
 
+		ret = validate_vsi_array_indexes(inst, vsi);
+		if (ret) {
+			mtk_vcodec_err(inst, "Invalid values from VPU.");
+			goto DECODE_ERROR;
+		}
+
 		if (vsi->resolution_changed) {
 			if (!vp9_alloc_work_buf(inst)) {
 				ret = -EINVAL;
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
index db6b5205ffb1..ded1154481cd 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.h
@@ -85,6 +85,8 @@ void vdec_if_deinit(struct mtk_vcodec_ctx *ctx);
  * @res_chg	: [out] resolution change happens if current bs have different
  *	picture width/height
  * Note: To flush the decoder when reaching EOF, set input bitstream as NULL.
+ *
+ * Return: 0 on success. -EIO on unrecoverable error.
  */
 int vdec_if_decode(struct mtk_vcodec_ctx *ctx, struct mtk_vcodec_mem *bs,
 		   struct vdec_fb *fb, bool *res_chg);
-- 
2.12.0.rc1.440.g5b76565f74-goog
