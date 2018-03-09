Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:43444 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932575AbeCIRuD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 12:50:03 -0500
From: Gustavo Padovan <gustavo@padovan.org>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>
Subject: [PATCH v8 07/13] [media] vb2: mark codec drivers as unordered
Date: Fri,  9 Mar 2018 14:49:14 -0300
Message-Id: <20180309174920.22373-8-gustavo@padovan.org>
In-Reply-To: <20180309174920.22373-1-gustavo@padovan.org>
References: <20180309174920.22373-1-gustavo@padovan.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

In preparation to have full support to explicit fence we are
marking codec as non-ordered preventively. It is easier and safer from an
uAPI point of view to move from unordered to ordered than the opposite.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
---
 drivers/media/platform/coda/coda-common.c          | 1 +
 drivers/media/platform/exynos-gsc/gsc-m2m.c        | 1 +
 drivers/media/platform/exynos4-is/fimc-m2m.c       | 1 +
 drivers/media/platform/m2m-deinterlace.c           | 1 +
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c    | 1 +
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c       | 1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1 +
 drivers/media/platform/mx2_emmaprp.c               | 1 +
 drivers/media/platform/qcom/venus/vdec.c           | 1 +
 drivers/media/platform/qcom/venus/venc.c           | 1 +
 drivers/media/platform/rcar_fdp1.c                 | 1 +
 drivers/media/platform/rcar_jpu.c                  | 1 +
 drivers/media/platform/rockchip/rga/rga-buf.c      | 1 +
 drivers/media/platform/s5p-g2d/g2d.c               | 1 +
 drivers/media/platform/s5p-jpeg/jpeg-core.c        | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 1 +
 drivers/media/platform/sh_veu.c                    | 1 +
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c      | 1 +
 drivers/media/platform/ti-vpe/vpe.c                | 1 +
 drivers/media/platform/vim2m.c                     | 1 +
 22 files changed, 22 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04e35d70ce2e..6deb29fe6eb7 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1649,6 +1649,7 @@ static const struct vb2_ops coda_qops = {
 	.stop_streaming		= coda_stop_streaming,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index e9ff27949a91..10c3e4659d38 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -286,6 +286,7 @@ static const struct vb2_ops gsc_m2m_qops = {
 	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = gsc_m2m_stop_streaming,
 	.start_streaming = gsc_m2m_start_streaming,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int gsc_m2m_querycap(struct file *file, void *fh,
diff --git a/drivers/media/platform/exynos4-is/fimc-m2m.c b/drivers/media/platform/exynos4-is/fimc-m2m.c
index a19f8b164a47..dfc487a582c0 100644
--- a/drivers/media/platform/exynos4-is/fimc-m2m.c
+++ b/drivers/media/platform/exynos4-is/fimc-m2m.c
@@ -227,6 +227,7 @@ static const struct vb2_ops fimc_qops = {
 	.wait_finish	 = vb2_ops_wait_finish,
 	.stop_streaming	 = stop_streaming,
 	.start_streaming = start_streaming,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 /*
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 1e4195144f39..35a0f45d2a51 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -856,6 +856,7 @@ static const struct vb2_ops deinterlace_qops = {
 	.queue_setup	 = deinterlace_queue_setup,
 	.buf_prepare	 = deinterlace_buf_prepare,
 	.buf_queue	 = deinterlace_buf_queue,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 226f90886484..34a4b5b2e1b5 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -764,6 +764,7 @@ static const struct vb2_ops mtk_jpeg_qops = {
 	.wait_finish        = vb2_ops_wait_finish,
 	.start_streaming    = mtk_jpeg_start_streaming,
 	.stop_streaming     = mtk_jpeg_stop_streaming,
+	.is_unordered       = vb2_ops_set_unordered,
 };
 
 static void mtk_jpeg_set_dec_src(struct mtk_jpeg_ctx *ctx,
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 583d47724ee8..f3bb9f277f55 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -629,6 +629,7 @@ static const struct vb2_ops mtk_mdp_m2m_qops = {
 	.wait_finish	 = mtk_mdp_ctx_lock,
 	.stop_streaming	 = mtk_mdp_m2m_stop_streaming,
 	.start_streaming = mtk_mdp_m2m_start_streaming,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int mtk_mdp_m2m_querycap(struct file *file, void *fh,
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 86f0a7134365..4f33e9741248 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1445,6 +1445,7 @@ static const struct vb2_ops mtk_vdec_vb2_ops = {
 	.buf_finish	= vb2ops_vdec_buf_finish,
 	.start_streaming	= vb2ops_vdec_start_streaming,
 	.stop_streaming	= vb2ops_vdec_stop_streaming,
+	.is_unordered	= vb2_ops_set_unordered,
 };
 
 const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops = {
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 1b1a28abbf1f..fd763249d7bd 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -931,6 +931,7 @@ static const struct vb2_ops mtk_venc_vb2_ops = {
 	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= vb2ops_venc_start_streaming,
 	.stop_streaming		= vb2ops_venc_stop_streaming,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 static int mtk_venc_encode_header(void *priv)
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 5a8eff60e95f..d03becff66cf 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -747,6 +747,7 @@ static const struct vb2_ops emmaprp_qops = {
 	.queue_setup	 = emmaprp_queue_setup,
 	.buf_prepare	 = emmaprp_buf_prepare,
 	.buf_queue	 = emmaprp_buf_queue,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index c9e9576bb08a..20acbfe2150d 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -793,6 +793,7 @@ static const struct vb2_ops vdec_vb2_ops = {
 	.start_streaming = vdec_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.is_unordered = vb2_ops_set_unordered,
 };
 
 static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index e3a10a852cad..abefae68ce5a 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -982,6 +982,7 @@ static const struct vb2_ops venc_vb2_ops = {
 	.start_streaming = venc_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.is_unordered = vb2_ops_set_unordered,
 };
 
 static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index b13dec3081e5..6a744a9c1738 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2040,6 +2040,7 @@ static const struct vb2_ops fdp1_qops = {
 	.stop_streaming  = fdp1_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index f6092ae45912..b4b2e2cf5d1a 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -1192,6 +1192,7 @@ static const struct vb2_ops jpu_qops = {
 	.stop_streaming		= jpu_stop_streaming,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 static int jpu_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/rockchip/rga/rga-buf.c b/drivers/media/platform/rockchip/rga/rga-buf.c
index fa1ba98c96dc..48932f34144d 100644
--- a/drivers/media/platform/rockchip/rga/rga-buf.c
+++ b/drivers/media/platform/rockchip/rga/rga-buf.c
@@ -112,6 +112,7 @@ const struct vb2_ops rga_qops = {
 	.wait_finish = vb2_ops_wait_finish,
 	.start_streaming = rga_buf_start_streaming,
 	.stop_streaming = rga_buf_stop_streaming,
+	.is_unordered = vb2_ops_set_unordered,
 };
 
 /* RGA MMU is a 1-Level MMU, so it can't be used through the IOMMU API.
diff --git a/drivers/media/platform/s5p-g2d/g2d.c b/drivers/media/platform/s5p-g2d/g2d.c
index 66aa8cf1d048..cb7d916bfc8b 100644
--- a/drivers/media/platform/s5p-g2d/g2d.c
+++ b/drivers/media/platform/s5p-g2d/g2d.c
@@ -142,6 +142,7 @@ static const struct vb2_ops g2d_qops = {
 	.queue_setup	= g2d_queue_setup,
 	.buf_prepare	= g2d_buf_prepare,
 	.buf_queue	= g2d_buf_queue,
+	.is_unordered	= vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 79b63da27f53..28485e6b9cc8 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -2648,6 +2648,7 @@ static const struct vb2_ops s5p_jpeg_qops = {
 	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= s5p_jpeg_start_streaming,
 	.stop_streaming		= s5p_jpeg_stop_streaming,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 8937b0af7cb3..369db08dbcae 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1099,6 +1099,7 @@ static struct vb2_ops s5p_mfc_dec_qops = {
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
 	.buf_queue		= s5p_mfc_buf_queue,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 const struct s5p_mfc_codec_ops *get_dec_codec_ops(void)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 0d5d465561be..fece496c2a8e 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -2036,6 +2036,7 @@ static struct vb2_ops s5p_mfc_enc_qops = {
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
 	.buf_queue		= s5p_mfc_buf_queue,
+	.is_unordered		= vb2_ops_set_unordered,
 };
 
 const struct s5p_mfc_codec_ops *get_enc_codec_ops(void)
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1a0cde017fdf..0682b50a67fc 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -927,6 +927,7 @@ static const struct vb2_ops sh_veu_qops = {
 	.buf_queue	 = sh_veu_buf_queue,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int sh_veu_queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index bf4ca16db440..0cfdc5a67855 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -535,6 +535,7 @@ static const struct vb2_ops bdisp_qops = {
 	.wait_finish     = vb2_ops_wait_finish,
 	.stop_streaming  = bdisp_stop_streaming,
 	.start_streaming = bdisp_start_streaming,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv,
diff --git a/drivers/media/platform/ti-vpe/vpe.c b/drivers/media/platform/ti-vpe/vpe.c
index e395aa85c8ad..c2d838884e1c 100644
--- a/drivers/media/platform/ti-vpe/vpe.c
+++ b/drivers/media/platform/ti-vpe/vpe.c
@@ -2202,6 +2202,7 @@ static const struct vb2_ops vpe_qops = {
 	.wait_finish	 = vb2_ops_wait_finish,
 	.start_streaming = vpe_start_streaming,
 	.stop_streaming  = vpe_stop_streaming,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq,
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 065483e62db4..e1a54a28b082 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -823,6 +823,7 @@ static const struct vb2_ops vim2m_qops = {
 	.stop_streaming  = vim2m_stop_streaming,
 	.wait_prepare	 = vb2_ops_wait_prepare,
 	.wait_finish	 = vb2_ops_wait_finish,
+	.is_unordered	 = vb2_ops_set_unordered,
 };
 
 static int queue_init(void *priv, struct vb2_queue *src_vq, struct vb2_queue *dst_vq)
-- 
2.14.3
