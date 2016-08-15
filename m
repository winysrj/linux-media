Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:38199 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752113AbcHODJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Aug 2016 23:09:13 -0400
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
Subject: [PATCH for v4.8] vcodec:mediatek: Fix visible_height larger than coded_height issue in s_fmt_out
Date: Mon, 15 Aug 2016 11:08:03 +0800
Message-ID: <1471230483-23568-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The original code add extra 32 line to visible_height.
It is incorrect, 32 line should be add to coded_height.
The purpose is that user space could calcuate real buffer size needed by using
coded_width * coded_height.
But this method will make v4l2-compliance test fail, since g_fmt != s_fmt(g_fmt)
So remove extend visible_height or coded_height, user space should just
use sizeimage to get real buffer size needed

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index a145130..cd36c9e 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -487,7 +487,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
 	struct mtk_q_data *q_data;
 	int ret, i;
 	struct mtk_video_fmt *fmt;
-	unsigned int pitch_w_div16;
 	struct v4l2_pix_format_mplane *pix_fmt_mp = &f->fmt.pix_mp;
 
 	vq = v4l2_m2m_get_vq(ctx->m2m_ctx, f->type);
@@ -530,15 +529,6 @@ static int vidioc_venc_s_fmt_out(struct file *file, void *priv,
 	q_data->coded_width = f->fmt.pix_mp.width;
 	q_data->coded_height = f->fmt.pix_mp.height;
 
-	pitch_w_div16 = DIV_ROUND_UP(q_data->visible_width, 16);
-	if (pitch_w_div16 % 8 != 0) {
-		/* Adjust returned width/height, so application could correctly
-		 * allocate hw required memory
-		 */
-		q_data->visible_height += 32;
-		vidioc_try_fmt(f, q_data->fmt);
-	}
-
 	q_data->field = f->fmt.pix_mp.field;
 	ctx->colorspace = f->fmt.pix_mp.colorspace;
 	ctx->ycbcr_enc = f->fmt.pix_mp.ycbcr_enc;
-- 
1.7.9.5

