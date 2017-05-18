Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40971
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756004AbdEROGz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 10:06:55 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 4/4] [media] mtk_vcodec_dec: return error at mtk_vdec_pic_info_update()
Date: Thu, 18 May 2017 11:06:46 -0300
Message-Id: <3a15120de0eb6f4e67d83126a95cc4a80b788f4b.1495116400.git.mchehab@s-opensource.com>
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
In-Reply-To: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Gcc 7.1 complains that:

	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c: In function 'mtk_vdec_pic_info_update':
	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:284:6: warning: variable 'ret' set but not used [-Wunused-but-set-variable]
	  int ret;
	      ^~~

Indeed, if debug is disabled, "ret" is never used. The best
fix for it seems to make the fuction to return an error code.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index a60b538686ea..843510979ad8 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -278,7 +278,7 @@ static void mtk_vdec_flush_decoder(struct mtk_vcodec_ctx *ctx)
 	clean_free_buffer(ctx);
 }
 
-static void mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
+static int mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
 {
 	unsigned int dpbsize = 0;
 	int ret;
@@ -288,7 +288,7 @@ static void mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
 				&ctx->last_decoded_picinfo)) {
 		mtk_v4l2_err("[%d]Error!! Cannot get param : GET_PARAM_PICTURE_INFO ERR",
 				ctx->id);
-		return;
+		return -EINVAL;
 	}
 
 	if (ctx->last_decoded_picinfo.pic_w == 0 ||
@@ -296,12 +296,12 @@ static void mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
 		ctx->last_decoded_picinfo.buf_w == 0 ||
 		ctx->last_decoded_picinfo.buf_h == 0) {
 		mtk_v4l2_err("Cannot get correct pic info");
-		return;
+		return -EINVAL;
 	}
 
 	if ((ctx->last_decoded_picinfo.pic_w == ctx->picinfo.pic_w) ||
 	    (ctx->last_decoded_picinfo.pic_h == ctx->picinfo.pic_h))
-		return;
+		return 0;
 
 	mtk_v4l2_debug(1,
 			"[%d]-> new(%d,%d), old(%d,%d), real(%d,%d)",
@@ -316,6 +316,8 @@ static void mtk_vdec_pic_info_update(struct mtk_vcodec_ctx *ctx)
 		mtk_v4l2_err("Incorrect dpb size, ret=%d", ret);
 
 	ctx->dpb_size = dpbsize;
+
+	return ret;
 }
 
 static void mtk_vdec_worker(struct work_struct *work)
-- 
2.9.3
