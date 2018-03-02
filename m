Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:40791 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423640AbeCBTO0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 14:14:26 -0500
Received: by mail-qt0-f195.google.com with SMTP id y6so13173792qtm.7
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2018 11:14:26 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: slongerbeam@gmail.com, p.zabel@pengutronix.de,
        gustavo@embeddedor.com, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 1/2] media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR
Date: Fri,  2 Mar 2018 16:14:08 -0300
Message-Id: <1520018049-5216-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
The proper pointer to be passed as argument is pinctrl
instead of priv->vdev.

This issue was detected with the help of Coccinelle.

Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 5a195f8..4f290a0 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1798,7 +1798,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->dev->of_node = pdata->of_node;
 	pinctrl = devm_pinctrl_get_select_default(priv->dev);
 	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(priv->vdev);
+		ret = PTR_ERR(pinctrl);
 		goto free;
 	}
 
-- 
2.7.4
