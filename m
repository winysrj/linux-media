Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:42752 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932187AbcIFFvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 01:51:55 -0400
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
Subject: [PATCH] vcodec: mediatek: Add V4L2_CAP_TIMEPERFRAME capability setting
Date: Tue, 6 Sep 2016 13:51:45 +0800
Message-ID: <1473141105-47201-1-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch setting V4L2_CAP_TIMEPERFRAME capability in
vidioc_venc_s/g_parm functions

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 34fd89c..d0c2b9a 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -243,6 +243,8 @@ static int vidioc_venc_s_parm(struct file *file, void *priv,
 			a->parm.output.timeperframe.numerator;
 	ctx->param_change |= MTK_ENCODE_PARAM_FRAMERATE;
 
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
+
 	return 0;
 }
 
@@ -254,6 +256,7 @@ static int vidioc_venc_g_parm(struct file *file, void *priv,
 	if (a->type != V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
 		return -EINVAL;
 
+	a->parm.output.capability = V4L2_CAP_TIMEPERFRAME;
 	a->parm.output.timeperframe.denominator =
 			ctx->enc_params.framerate_num;
 	a->parm.output.timeperframe.numerator =
-- 
1.7.9.5

