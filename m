Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34014 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdCGGF1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 01:05:27 -0500
Received: by mail-pf0-f179.google.com with SMTP id v190so33540435pfb.1
        for <linux-media@vger.kernel.org>; Mon, 06 Mar 2017 22:03:41 -0800 (PST)
From: Wu-Cheng Li <wuchengli@chromium.org>
To: pawel@osciak.com, tiffany.lin@mediatek.com,
        andrew-ct.chen@mediatek.com, mchehab@kernel.org,
        matthias.bgg@gmail.com, hans.verkuil@cisco.com,
        wuchengli@google.com
Cc: djkurtz@chromium.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wu-Cheng Li <wuchengli@chromium.org>
Subject: [PATCH 1/1] mtk-vcodec: check the vp9 decoder buffer index from VPU.
Date: Tue,  7 Mar 2017 14:03:28 +0800
Message-Id: <20170307060328.114348-2-wuchengli@chromium.org>
In-Reply-To: <20170307060328.114348-1-wuchengli@chromium.org>
References: <20170307060328.114348-1-wuchengli@chromium.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Wu-Cheng Li <wuchengli@google.com>

VPU firmware has a bug and may return invalid buffer index for
some vp9 videos. Check the buffer indexes before accessing the
buffer.

Signed-off-by: Wu-Cheng Li <wuchengli@chromium.org>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |  6 +++++
 .../media/platform/mtk-vcodec/vdec/vdec_vp9_if.c   | 26 ++++++++++++++++++++++
 drivers/media/platform/mtk-vcodec/vdec_drv_if.h    |  2 ++
 3 files changed, 34 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 502877a4b1df..7ebcf9e57ac7 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1176,6 +1176,12 @@ static void vb2ops_vdec_buf_queue(struct vb2_buffer *vb)
 			       "[%d] vdec_if_decode() src_buf=%d, size=%zu, fail=%d, res_chg=%d",
 			       ctx->id, src_buf->index,
 			       src_mem.size, ret, res_chg);
+
+		if (ret == -EIO) {
+			mtk_v4l2_err("[%d] Unrecoverable error in vdec_if_decode.",
+					ctx->id);
+			ctx->state = MTK_STATE_ABORT;
+		}
 		return;
 	}
 
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
