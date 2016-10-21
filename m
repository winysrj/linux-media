Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:36057 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754584AbcJUOAZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 10:00:25 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Minghsiu Tsai <minghsiu.tsai@mediatek.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 3/4] mtk_mdp_m2m: remove an unused struct
Date: Fri, 21 Oct 2016 11:59:18 -0200
Message-Id: <624b0ea4550b90318ec2293d80b1caa5bafd2a35.1477058332.git.mchehab@s-opensource.com>
In-Reply-To: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
In-Reply-To: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
References: <cd14afdb178cf490e257368bc899c7a0c690d140.1477058332.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c:48:33: warning: ‘mtk_mdp_size_align’ defined but not used [-Wunused-variable]
 static struct mtk_mdp_pix_align mtk_mdp_size_align = {
                                 ^~~~~~~~~~~~~~~~~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index 065502757133..33124a6c9951 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -45,13 +45,6 @@ struct mtk_mdp_pix_limit {
 	u16 target_rot_en_h;
 };
 
-static struct mtk_mdp_pix_align mtk_mdp_size_align = {
-	.org_w			= 16,
-	.org_h			= 16,
-	.target_w		= 2,
-	.target_h		= 2,
-};
-
 static const struct mtk_mdp_fmt mtk_mdp_formats[] = {
 	{
 		.pixelformat	= V4L2_PIX_FMT_NV12M,
-- 
2.7.4

