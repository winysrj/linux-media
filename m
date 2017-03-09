Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:39881 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdCIUI0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 15:08:26 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 3/3] [media] coda: get rid of unused vars
Date: Thu,  9 Mar 2017 17:08:18 -0300
Message-Id: <c167861e48f35b109f15f4d046f2857ac6186980.1489090091.git.mchehab@s-opensource.com>
In-Reply-To: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
References: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
In-Reply-To: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
References: <311737bbe02ab45e7b0c27e95a312b57fc31b21a.1489090091.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some vars are not used, as warned by gcc:

drivers/media/platform/coda/coda-common.c: In function 'coda_buf_is_end_of_stream':
drivers/media/platform/coda/coda-common.c:816:20: warning: variable 'src_vq' set but not used [-Wunused-but-set-variable]
  struct vb2_queue *src_vq;
                    ^~~~~~
drivers/media/platform/coda/coda-common.c: In function 'coda_buf_queue':
drivers/media/platform/coda/coda-common.c:1315:22: warning: variable 'q_data' set but not used [-Wunused-but-set-variable]
  struct coda_q_data *q_data;
                      ^~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/coda/coda-common.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index eb6548f46cba..cb76c96759b9 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -813,9 +813,7 @@ static int coda_qbuf(struct file *file, void *priv,
 static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
 				      struct vb2_v4l2_buffer *buf)
 {
-	struct vb2_queue *src_vq;
-
-	src_vq = v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
+	v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
 
 	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
 		(buf->sequence == (ctx->qsequence - 1)));
@@ -1312,9 +1310,6 @@ static void coda_buf_queue(struct vb2_buffer *vb)
 	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
 	struct coda_ctx *ctx = vb2_get_drv_priv(vb->vb2_queue);
 	struct vb2_queue *vq = vb->vb2_queue;
-	struct coda_q_data *q_data;
-
-	q_data = get_q_data(ctx, vb->vb2_queue->type);
 
 	/*
 	 * In the decoder case, immediately try to copy the buffer into the
-- 
2.9.3
