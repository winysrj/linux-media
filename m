Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:52491 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753725AbcIHNJP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 09:09:15 -0400
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
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH v6 5/6] media: mtk-mdp: support pixelformat V4L2_PIX_FMT_MT21C
Date: Thu, 8 Sep 2016 21:09:05 +0800
Message-ID: <1473340146-6598-6-git-send-email-minghsiu.tsai@mediatek.com>
In-Reply-To: <1473340146-6598-1-git-send-email-minghsiu.tsai@mediatek.com>
References: <1473340146-6598-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add V4L2_PIX_FMT_MT21C in format list.

Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  |    8 ++++++++
 drivers/media/platform/mtk-mdp/mtk_mdp_regs.c |    4 ++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 0655027..a90972e 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -54,6 +54,14 @@ static struct mtk_mdp_pix_align mtk_mdp_size_align = {
 
 static const struct mtk_mdp_fmt mtk_mdp_formats[] = {
 	{
+		.pixelformat	= V4L2_PIX_FMT_MT21C,
+		.depth		= { 8, 4 },
+		.row_depth	= { 8, 8 },
+		.num_planes	= 2,
+		.num_comp	= 2,
+		.align		= &mtk_mdp_size_align,
+		.flags		= MTK_MDP_FMT_FLAG_OUTPUT,
+	}, {
 		.pixelformat	= V4L2_PIX_FMT_NV12M,
 		.depth		= { 8, 4 },
 		.row_depth	= { 8, 8 },
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
index a5601e1..86d57f3 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_regs.c
@@ -29,6 +29,8 @@ enum MDP_COLOR_ENUM {
 	MDP_COLOR_NV12 = MDP_COLORFMT_PACK(0, 2, 1, 1, 1, 8, 1, 0, 12),
 	MDP_COLOR_I420 = MDP_COLORFMT_PACK(0, 3, 0, 1, 1, 8, 1, 0, 8),
 	MDP_COLOR_YV12 = MDP_COLORFMT_PACK(0, 3, 0, 1, 1, 8, 1, 1, 8),
+	/* Mediatek proprietary format */
+	MDP_COLOR_420_MT21 = MDP_COLORFMT_PACK(5, 2, 1, 1, 1, 256, 1, 0, 12),
 };
 
 static int32_t mtk_mdp_map_color_format(int v4l2_format)
@@ -37,6 +39,8 @@ static int32_t mtk_mdp_map_color_format(int v4l2_format)
 	case V4L2_PIX_FMT_NV12M:
 	case V4L2_PIX_FMT_NV12:
 		return MDP_COLOR_NV12;
+	case V4L2_PIX_FMT_MT21C:
+		return MDP_COLOR_420_MT21;
 	case V4L2_PIX_FMT_YUV420M:
 	case V4L2_PIX_FMT_YUV420:
 		return MDP_COLOR_I420;
-- 
1.7.9.5

