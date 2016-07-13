Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:12103 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752600AbcGMIFk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 04:05:40 -0400
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>
CC: Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <Tiffany.lin@mediatek.com>,
	Tiffany Lin <tiffany.lin@mediatek.com>
Subject: [PATCH] [media] mtk-vcodec: fix default OUTPUT buffer size
Date: Wed, 13 Jul 2016 16:05:23 +0800
Message-ID: <1468397123-9808-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When calculate OUTPUT buffer size in vidioc_try_fmt, it will
add more size hw need in each plane.
But in mtk_vcodec_enc_set_default_params, it do not add
same size in each plane.
This makes v4l2-compliance test fail.
This patch fix the issue.

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 907a6d1..3ed3f2d 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -328,10 +328,11 @@ static int vidioc_try_fmt(struct v4l2_format *f, struct mtk_video_fmt *fmt)
 			pix_fmt_mp->height += 32;
 
 		mtk_v4l2_debug(0,
-			"before resize width=%d, height=%d, after resize width=%d, height=%d, sizeimage=%d",
+			"before resize width=%d, height=%d, after resize width=%d, height=%d, sizeimage=%d %d",
 			tmp_w, tmp_h, pix_fmt_mp->width,
 			pix_fmt_mp->height,
-			pix_fmt_mp->width * pix_fmt_mp->height);
+			pix_fmt_mp->plane_fmt[0].sizeimage,
+			pix_fmt_mp->plane_fmt[1].sizeimage);
 
 		pix_fmt_mp->num_planes = fmt->num_planes;
 		pix_fmt_mp->plane_fmt[0].sizeimage =
@@ -1166,9 +1167,13 @@ void mtk_vcodec_enc_set_default_params(struct mtk_vcodec_ctx *ctx)
 		(q_data->coded_height + 32) <= MTK_VENC_MAX_H)
 		q_data->coded_height += 32;
 
-	q_data->sizeimage[0] = q_data->coded_width * q_data->coded_height;
+	q_data->sizeimage[0] =
+		q_data->coded_width * q_data->coded_height+
+		((ALIGN(q_data->coded_width, 16) * 2) * 16);
 	q_data->bytesperline[0] = q_data->coded_width;
-	q_data->sizeimage[1] = q_data->sizeimage[0] / 2;
+	q_data->sizeimage[1] =
+		(q_data->coded_width * q_data->coded_height) / 2 +
+		(ALIGN(q_data->coded_width, 16) * 16);
 	q_data->bytesperline[1] = q_data->coded_width;
 
 	q_data = &ctx->q_data[MTK_Q_DATA_DST];
-- 
1.7.9.5

