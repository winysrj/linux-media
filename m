Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:45903 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752673AbdCNOVi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 10:21:38 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Bin Liu <bin.liu@mediatek.com>,
        Rick Chang <rick.chang@mediatek.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH] media: mtk-jpeg: fix continuous log "Context is NULL"
Date: Tue, 14 Mar 2017 22:21:22 +0800
Message-ID: <1489501282-52137-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The symptom is continuous log "mtk-jpeg 18004000.jpegdec: Context is NULL"
in kernel log. It is becauese the error handling in irq doesn't clear
interrupt.

The calling flow like as below when issue happen
mtk_jpeg_device_run()
mtk_jpeg_job_abort()
  v4l2_m2m_job_finish() -> m2m_dev->curr_ctx = NULL;
mtk_jpeg_dec_irq()
  v4l2_m2m_get_curr_priv()
     -> m2m_dev->curr_ctx == NULL
     -> return NULL
log "Context is NULL"

There is race condition between job_abort() and irq. In order to simplify
code, don't want to add extra flag to maintain state, empty job_abort() and
clear interrupt before v4l2_m2m_get_curr_priv() in irq.

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index b10183f..c02bc7f 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -862,15 +862,6 @@ static int mtk_jpeg_job_ready(void *priv)
 
 static void mtk_jpeg_job_abort(void *priv)
 {
-	struct mtk_jpeg_ctx *ctx = priv;
-	struct mtk_jpeg_dev *jpeg = ctx->jpeg;
-	struct vb2_buffer *src_buf, *dst_buf;
-
-	src_buf = v4l2_m2m_src_buf_remove(ctx->fh.m2m_ctx);
-	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(src_buf), VB2_BUF_STATE_ERROR);
-	v4l2_m2m_buf_done(to_vb2_v4l2_buffer(dst_buf), VB2_BUF_STATE_ERROR);
-	v4l2_m2m_job_finish(jpeg->m2m_dev, ctx->fh.m2m_ctx);
 }
 
 static struct v4l2_m2m_ops mtk_jpeg_m2m_ops = {
@@ -941,6 +932,8 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	u32 dec_ret;
 	int i;
 
+	dec_ret = mtk_jpeg_dec_get_int_status(jpeg->dec_reg_base);
+	dec_irq_ret = mtk_jpeg_dec_enum_result(dec_ret);
 	ctx = v4l2_m2m_get_curr_priv(jpeg->m2m_dev);
 	if (!ctx) {
 		v4l2_err(&jpeg->v4l2_dev, "Context is NULL\n");
@@ -951,9 +944,6 @@ static irqreturn_t mtk_jpeg_dec_irq(int irq, void *priv)
 	dst_buf = v4l2_m2m_dst_buf_remove(ctx->fh.m2m_ctx);
 	jpeg_src_buf = mtk_jpeg_vb2_to_srcbuf(src_buf);
 
-	dec_ret = mtk_jpeg_dec_get_int_status(jpeg->dec_reg_base);
-	dec_irq_ret = mtk_jpeg_dec_enum_result(dec_ret);
-
 	if (dec_irq_ret >= MTK_JPEG_DEC_RESULT_UNDERFLOW)
 		mtk_jpeg_dec_reset(jpeg->dec_reg_base);
 
-- 
1.9.1
