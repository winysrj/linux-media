Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:55684 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731882AbeHNSpe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 14:45:34 -0400
From: Todor Tomov <todor.tomov@linaro.org>
To: mchehab@kernel.org, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de,
        Todor Tomov <todor.tomov@linaro.org>
Subject: [PATCH] media: camss: Use managed memory allocations
Date: Tue, 14 Aug 2018 18:57:35 +0300
Message-Id: <1534262255-32270-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Use managed memory allocations for structs which are used until
the driver is removed.

Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
---
 drivers/media/platform/qcom/camss/camss-ispif.c |  4 ++--
 drivers/media/platform/qcom/camss/camss.c       | 11 ++++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-ispif.c b/drivers/media/platform/qcom/camss/camss-ispif.c
index 7f26902..ca7b091 100644
--- a/drivers/media/platform/qcom/camss/camss-ispif.c
+++ b/drivers/media/platform/qcom/camss/camss-ispif.c
@@ -1076,8 +1076,8 @@ int msm_ispif_subdev_init(struct ispif_device *ispif,
 	else
 		return -EINVAL;
 
-	ispif->line = kcalloc(ispif->line_num, sizeof(*ispif->line),
-			      GFP_KERNEL);
+	ispif->line = devm_kcalloc(dev, ispif->line_num, sizeof(*ispif->line),
+				   GFP_KERNEL);
 	if (!ispif->line)
 		return -ENOMEM;
 
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index dcc0c30..3304f7a 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -848,17 +848,18 @@ static int camss_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	camss->csiphy = kcalloc(camss->csiphy_num, sizeof(*camss->csiphy),
-				GFP_KERNEL);
+	camss->csiphy = devm_kcalloc(dev, camss->csiphy_num,
+				     sizeof(*camss->csiphy), GFP_KERNEL);
 	if (!camss->csiphy)
 		return -ENOMEM;
 
-	camss->csid = kcalloc(camss->csid_num, sizeof(*camss->csid),
-			      GFP_KERNEL);
+	camss->csid = devm_kcalloc(dev, camss->csid_num, sizeof(*camss->csid),
+				   GFP_KERNEL);
 	if (!camss->csid)
 		return -ENOMEM;
 
-	camss->vfe = kcalloc(camss->vfe_num, sizeof(*camss->vfe), GFP_KERNEL);
+	camss->vfe = devm_kcalloc(dev, camss->vfe_num, sizeof(*camss->vfe),
+				  GFP_KERNEL);
 	if (!camss->vfe)
 		return -ENOMEM;
 
-- 
2.7.4
