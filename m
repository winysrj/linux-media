Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:63992 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752624AbdIXSE5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Sep 2017 14:04:57 -0400
Subject: [PATCH 1/4] [media] omap3isp: Delete an error message for a failed
 memory allocation in three functions
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Message-ID: <f99181c5-b31e-1727-a6ac-9ee7acdd0a90@users.sourceforge.net>
Date: Sun, 24 Sep 2017 20:04:51 +0200
MIME-Version: 1.0
In-Reply-To: <692bab24-7990-c971-b577-b2dea4176e64@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 24 Sep 2017 18:25:44 +0200

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/platform/omap3isp/isp.c         | 4 +---
 drivers/media/platform/omap3isp/isph3a_aewb.c | 5 +----
 drivers/media/platform/omap3isp/isph3a_af.c   | 5 +----
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1a428fe9f070..874b883ac83a 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2236,10 +2236,8 @@ static int isp_probe(struct platform_device *pdev)
 	int i, m;
 
 	isp = devm_kzalloc(&pdev->dev, sizeof(*isp), GFP_KERNEL);
-	if (!isp) {
-		dev_err(&pdev->dev, "could not allocate memory\n");
+	if (!isp)
 		return -ENOMEM;
-	}
 
 	ret = fwnode_property_read_u32(of_fwnode_handle(pdev->dev.of_node),
 				       "ti,phy-type", &isp->phy_type);
diff --git a/drivers/media/platform/omap3isp/isph3a_aewb.c b/drivers/media/platform/omap3isp/isph3a_aewb.c
index d44626f20ac6..9844b9d06634 100644
--- a/drivers/media/platform/omap3isp/isph3a_aewb.c
+++ b/drivers/media/platform/omap3isp/isph3a_aewb.c
@@ -303,11 +303,8 @@ int omap3isp_h3a_aewb_init(struct isp_device *isp)
 	/* Set recover state configuration */
 	aewb_recover_cfg = devm_kzalloc(isp->dev, sizeof(*aewb_recover_cfg),
 					GFP_KERNEL);
-	if (!aewb_recover_cfg) {
-		dev_err(aewb->isp->dev,
-			"AEWB: cannot allocate memory for recover configuration.\n");
+	if (!aewb_recover_cfg)
 		return -ENOMEM;
-	}
 
 	aewb_recover_cfg->saturation_limit = OMAP3ISP_AEWB_MAX_SATURATION_LIM;
 	aewb_recover_cfg->win_height = OMAP3ISP_AEWB_MIN_WIN_H;
diff --git a/drivers/media/platform/omap3isp/isph3a_af.c b/drivers/media/platform/omap3isp/isph3a_af.c
index 99bd6cc21d86..b81e869ade8c 100644
--- a/drivers/media/platform/omap3isp/isph3a_af.c
+++ b/drivers/media/platform/omap3isp/isph3a_af.c
@@ -366,11 +366,8 @@ int omap3isp_h3a_af_init(struct isp_device *isp)
 	/* Set recover state configuration */
 	af_recover_cfg = devm_kzalloc(isp->dev, sizeof(*af_recover_cfg),
 				      GFP_KERNEL);
-	if (!af_recover_cfg) {
-		dev_err(af->isp->dev,
-			"AF: cannot allocate memory for recover configuration.\n");
+	if (!af_recover_cfg)
 		return -ENOMEM;
-	}
 
 	af_recover_cfg->paxel.h_start = OMAP3ISP_AF_PAXEL_HZSTART_MIN;
 	af_recover_cfg->paxel.width = OMAP3ISP_AF_PAXEL_WIDTH_MIN;
-- 
2.14.1
