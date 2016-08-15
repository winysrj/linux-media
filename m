Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:14966 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752673AbcHOCr1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 22:47:27 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH for v4.8] vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
Date: Mon, 15 Aug 2016 10:47:20 +0800
Message-ID: <1471229240-38268-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch fix that mtk_vcodec_venc_release should be called after v4l2_m2m_ctx_release

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |    7 ++++++-
 .../media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c |    6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index b1f0acb..a145130 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -1354,5 +1354,10 @@ int mtk_venc_lock(struct mtk_vcodec_ctx *ctx)
 
 void mtk_vcodec_enc_release(struct mtk_vcodec_ctx *ctx)
 {
-	venc_if_deinit(ctx);
+	int ret = venc_if_deinit(ctx);
+
+	if (ret)
+		mtk_v4l2_err("venc_if_deinit failed=%d", ret);
+
+	ctx->state = MTK_STATE_FREE;
 }
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
index c7806ec..5cd2151 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c
@@ -218,11 +218,15 @@ static int fops_vcodec_release(struct file *file)
 	mtk_v4l2_debug(1, "[%d] encoder", ctx->id);
 	mutex_lock(&dev->dev_mutex);
 
+	/*
+	 * Call v4l2_m2m_ctx_release to make sure the worker thread is not
+	 * running after venc_if_deinit.
+	 */
+	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 	mtk_vcodec_enc_release(ctx);
 	v4l2_fh_del(&ctx->fh);
 	v4l2_fh_exit(&ctx->fh);
 	v4l2_ctrl_handler_free(&ctx->ctrl_hdl);
-	v4l2_m2m_ctx_release(ctx->m2m_ctx);
 
 	list_del_init(&ctx->list);
 	dev->num_instances--;
-- 
1.7.9.5

