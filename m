Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:38959 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752652AbeDPRbC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 13:31:02 -0400
Received: by mail-qk0-f193.google.com with SMTP id j73so17420590qke.6
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 10:31:02 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: hverkuil@xs4all.nl, p.zabel@pengutronix.de, gustavo@embeddedor.com,
        slongerbeam@gmail.com, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH v2] media: imx-media-csi: Fix inconsistent IS_ERR and PTR_ERR
Date: Mon, 16 Apr 2018 14:28:56 -0300
Message-Id: <1523899736-31360-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: From: Gustavo A. R. Silva <gustavo@embeddedor.com>

Fix inconsistent IS_ERR and PTR_ERR in imx_csi_probe.
The proper pointer to be passed as argument is pinctrl
instead of priv->vdev.

This issue was detected with the help of Coccinelle.

Fixes: 52e17089d185 ("media: imx: Don't initialize vars that won't be used")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
Acked-by: Philipp Zabel <p.zabel@pengutronix.de>
---
Changes since v1:
- Rebased against 4.17-rc1

 drivers/staging/media/imx/imx-media-csi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 16cab40..aeab05f 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1799,7 +1799,7 @@ static int imx_csi_probe(struct platform_device *pdev)
 	priv->dev->of_node = pdata->of_node;
 	pinctrl = devm_pinctrl_get_select_default(priv->dev);
 	if (IS_ERR(pinctrl)) {
-		ret = PTR_ERR(priv->vdev);
+		ret = PTR_ERR(pinctrl);
 		dev_dbg(priv->dev,
 			"devm_pinctrl_get_select_default() failed: %d\n", ret);
 		if (ret != -ENODEV)
-- 
2.7.4
