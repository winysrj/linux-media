Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:37170 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423640AbeCBTO2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2018 14:14:28 -0500
Received: by mail-qk0-f193.google.com with SMTP id y137so13270048qka.4
        for <linux-media@vger.kernel.org>; Fri, 02 Mar 2018 11:14:28 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: slongerbeam@gmail.com, p.zabel@pengutronix.de,
        gustavo@embeddedor.com, linux-media@vger.kernel.org,
        Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 2/2] media: imx-media-csi: Do not propagate the error when pinctrl is not found
Date: Fri,  2 Mar 2018 16:14:09 -0300
Message-Id: <1520018049-5216-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1520018049-5216-1-git-send-email-festevam@gmail.com>
References: <1520018049-5216-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

Since commit 52e17089d185 ("media: imx: Don't initialize vars that
won't be used") imx_csi_probe() fails to probe after propagating the
devm_pinctrl_get_select_default() error.

devm_pinctrl_get_select_default() may return -ENODEV when the CSI pinctrl
entry is not found, so better not to propagate the error in the -ENODEV
case to avoid a regression.

Suggested-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/staging/media/imx/imx-media-csi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
index 4f290a0..5af66f6 100644
--- a/drivers/staging/media/imx/imx-media-csi.c
+++ b/drivers/staging/media/imx/imx-media-csi.c
@@ -1799,7 +1799,10 @@ static int imx_csi_probe(struct platform_device *pdev)
 	pinctrl = devm_pinctrl_get_select_default(priv->dev);
 	if (IS_ERR(pinctrl)) {
 		ret = PTR_ERR(pinctrl);
-		goto free;
+		dev_dbg(priv->dev,
+			"devm_pinctrl_get_select_default() failed: %d", ret);
+		if (ret != -ENODEV)
+			goto free;
 	}
 
 	ret = v4l2_async_register_subdev(&priv->sd);
-- 
2.7.4
