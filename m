Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:44406 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753382AbeEURCJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 13:02:09 -0400
From: Ezequiel Garcia <ezequiel@collabora.com>
To: linux-media@vger.kernel.org
Cc: kernel@collabora.com, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Pawel Osciak <pawel@osciak.com>,
        Alexandre Courbot <acourbot@chromium.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Brian Starkey <brian.starkey@arm.com>,
        linux-kernel@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v10 10/16] vb2: mark codec drivers as unordered
Date: Mon, 21 May 2018 13:59:40 -0300
Message-Id: <20180521165946.11778-11-ezequiel@collabora.com>
In-Reply-To: <20180521165946.11778-1-ezequiel@collabora.com>
References: <20180521165946.11778-1-ezequiel@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo Padovan <gustavo.padovan@collabora.com>

In preparation to have full support to explicit fence we are
marking codec as non-ordered preventively. It is easier and safer from an
uAPI point of view to move from unordered to ordered than the opposite.

v2: mark only codec drivers as unordered (Nicolas and Hans)

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.com>
Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
---
 drivers/media/platform/coda/coda-common.c          | 1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 1 +
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c | 1 +
 drivers/media/platform/qcom/venus/vdec.c           | 1 +
 drivers/media/platform/qcom/venus/venc.c           | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c       | 1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c       | 1 +
 7 files changed, 7 insertions(+)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 04e35d70ce2e..cac36a11efa2 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -1649,6 +1649,7 @@ static const struct vb2_ops coda_qops = {
 	.stop_streaming		= coda_stop_streaming,
 	.wait_prepare		= vb2_ops_wait_prepare,
 	.wait_finish		= vb2_ops_wait_finish,
+	.is_unordered		= vb2_ops_is_unordered,
 };
 
 static int coda_s_ctrl(struct v4l2_ctrl *ctrl)
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 86f0a7134365..a4a02f3790fa 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -1445,6 +1445,7 @@ static const struct vb2_ops mtk_vdec_vb2_ops = {
 	.buf_finish	= vb2ops_vdec_buf_finish,
 	.start_streaming	= vb2ops_vdec_start_streaming,
 	.stop_streaming	= vb2ops_vdec_stop_streaming,
+	.is_unordered	= vb2_ops_is_unordered,
 };
 
 const struct v4l2_ioctl_ops mtk_vdec_ioctl_ops = {
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 1b1a28abbf1f..d37d670346b9 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -931,6 +931,7 @@ static const struct vb2_ops mtk_venc_vb2_ops = {
 	.wait_finish		= vb2_ops_wait_finish,
 	.start_streaming	= vb2ops_venc_start_streaming,
 	.stop_streaming		= vb2ops_venc_stop_streaming,
+	.is_unordered		= vb2_ops_is_unordered,
 };
 
 static int mtk_venc_encode_header(void *priv)
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index 49bbd1861d3a..8d7b4fc95880 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -794,6 +794,7 @@ static const struct vb2_ops vdec_vb2_ops = {
 	.start_streaming = vdec_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.is_unordered = vb2_ops_is_unordered,
 };
 
 static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 6b2ce479584e..713c79ba9639 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -983,6 +983,7 @@ static const struct vb2_ops venc_vb2_ops = {
 	.start_streaming = venc_start_streaming,
 	.stop_streaming = venus_helper_vb2_stop_streaming,
 	.buf_queue = venus_helper_vb2_buf_queue,
+	.is_unordered = vb2_ops_is_unordered,
 };
 
 static void venc_buf_done(struct venus_inst *inst, unsigned int buf_type,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 5cf4d9921264..4402a5d621b2 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -1105,6 +1105,7 @@ static struct vb2_ops s5p_mfc_dec_qops = {
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
 	.buf_queue		= s5p_mfc_buf_queue,
+	.is_unordered		= vb2_ops_is_unordered,
 };
 
 const struct s5p_mfc_codec_ops *get_dec_codec_ops(void)
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 5c0462ca9993..376bd8eab8d8 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -2613,6 +2613,7 @@ static struct vb2_ops s5p_mfc_enc_qops = {
 	.start_streaming	= s5p_mfc_start_streaming,
 	.stop_streaming		= s5p_mfc_stop_streaming,
 	.buf_queue		= s5p_mfc_buf_queue,
+	.is_unordered		= vb2_ops_is_unordered,
 };
 
 const struct s5p_mfc_codec_ops *get_enc_codec_ops(void)
-- 
2.16.3
