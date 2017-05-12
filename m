Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:5717 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750713AbdELCnB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 11 May 2017 22:43:01 -0400
From: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Houlong Wei <houlong.wei@mediatek.com>
CC: <srv_heupstream@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Wu-Cheng Li <wuchengli@google.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Subject: [PATCH v2] [media] mtk-mdp: Fix g_/s_selection capture/compose logic
Date: Fri, 12 May 2017 10:42:50 +0800
Message-ID: <1494556970-12278-1-git-send-email-minghsiu.tsai@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Kurtz <djkurtz@chromium.org>

Experiments show that the:
 (1) mtk-mdp uses the _MPLANE form of CAPTURE/OUTPUT
 (2) CAPTURE types use CROP targets, and OUTPUT types use COMPOSE targets

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Signed-off-by: Minghsiu Tsai <minghsiu.tsai@mediatek.com>
Signed-off-by: Houlong Wei <houlong.wei@mediatek.com>

---
Changes in v2:
. Can not use *_MPLANE type in g_/s_selection 
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 13afe48..e18ac626 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -838,10 +838,10 @@ static int mtk_mdp_m2m_g_selection(struct file *file, void *fh,
 	bool valid = false;
 
 	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (mtk_mdp_is_target_compose(s->target))
+		if (mtk_mdp_is_target_crop(s->target))
 			valid = true;
 	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (mtk_mdp_is_target_crop(s->target))
+		if (mtk_mdp_is_target_compose(s->target))
 			valid = true;
 	}
 	if (!valid) {
@@ -908,10 +908,10 @@ static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
 	bool valid = false;
 
 	if (s->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (s->target == V4L2_SEL_TGT_COMPOSE)
+		if (s->target == V4L2_SEL_TGT_CROP)
 			valid = true;
 	} else if (s->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
-		if (s->target == V4L2_SEL_TGT_CROP)
+		if (s->target == V4L2_SEL_TGT_COMPOSE)
 			valid = true;
 	}
 	if (!valid) {
@@ -925,7 +925,7 @@ static int mtk_mdp_m2m_s_selection(struct file *file, void *fh,
 	if (ret)
 		return ret;
 
-	if (mtk_mdp_is_target_crop(s->target))
+	if (mtk_mdp_is_target_compose(s->target))
 		frame = &ctx->s_frame;
 	else
 		frame = &ctx->d_frame;
-- 
1.9.1
