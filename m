Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:30768 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932550AbcIGG4z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Sep 2016 02:56:55 -0400
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
Subject: [PATCH 3/4] vcodec: mediatek: Add V4L2_PIX_FMT_MT21C support for v4l2 decoder
Date: Wed, 7 Sep 2016 14:56:42 +0800
Message-ID: <1473231403-14900-4-git-send-email-tiffany.lin@mediatek.com>
In-Reply-To: <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
References: <1473231403-14900-1-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-2-git-send-email-tiffany.lin@mediatek.com>
 <1473231403-14900-3-git-send-email-tiffany.lin@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21C support

Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 28a8453..fd3befc 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -25,7 +25,7 @@
 #include "mtk_vcodec_dec_pm.h"
 
 #define OUT_FMT_IDX	0
-#define CAP_FMT_IDX	0
+#define CAP_FMT_IDX	3
 
 #define MTK_VDEC_MIN_W	64U
 #define MTK_VDEC_MIN_H	64U
@@ -48,6 +48,11 @@ static struct mtk_video_fmt mtk_video_formats[] = {
 		.type = MTK_FMT_DEC,
 		.num_planes = 1,
 	},
+	{
+		.fourcc = V4L2_PIX_FMT_MT21C,
+		.type = MTK_FMT_FRAME,
+		.num_planes = 2,
+	},
 };
 
 static const struct mtk_codec_framesizes mtk_vdec_framesizes[] = {
-- 
1.7.9.5

