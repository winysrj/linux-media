Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754584AbcJUN7u (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Oct 2016 09:59:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tiffany Lin <tiffany.lin@mediatek.com>,
        Andrew-CT Chen <andrew-ct.chen@mediatek.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: [PATCH] mtk-vcodec: fix some smatch warnings
Date: Fri, 21 Oct 2016 11:58:42 -0200
Message-Id: <066110a3574ef835ba47a0996343474288da72cc.1477058315.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix this bug:
	drivers/media/platform/mtk-vcodec/vdec_drv_if.c:38 vdec_if_init() info: ignoring unreachable code.

With is indeed a real problem that prevents the driver to work!

While here, also remove an used var, as reported by smatch:

	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c: In function 'mtk_vcodec_init_dec_pm':
	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c:29:17: warning: variable 'dev' set but not used [-Wunused-but-set-variable]
	  struct device *dev;
	                 ^~~

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c | 2 --
 drivers/media/platform/mtk-vcodec/vdec_drv_if.c       | 1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
index 18182f5676d8..79ca03ac449c 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec_pm.c
@@ -26,14 +26,12 @@ int mtk_vcodec_init_dec_pm(struct mtk_vcodec_dev *mtkdev)
 {
 	struct device_node *node;
 	struct platform_device *pdev;
-	struct device *dev;
 	struct mtk_vcodec_pm *pm;
 	int ret = 0;
 
 	pdev = mtkdev->plat_dev;
 	pm = &mtkdev->pm;
 	pm->mtkdev = mtkdev;
-	dev = &pdev->dev;
 	node = of_parse_phandle(pdev->dev.of_node, "mediatek,larb", 0);
 	if (!node) {
 		mtk_v4l2_err("of_parse_phandle mediatek,larb fail!");
diff --git a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
index 3cb04ef45144..9813b2ffd5fa 100644
--- a/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec_drv_if.c
@@ -31,6 +31,7 @@ int vdec_if_init(struct mtk_vcodec_ctx *ctx, unsigned int fourcc)
 	switch (fourcc) {
 	case V4L2_PIX_FMT_H264:
 	case V4L2_PIX_FMT_VP8:
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.7.4

