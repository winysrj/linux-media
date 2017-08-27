Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36867 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH0QbG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 12:31:06 -0400
Received: by mail-qt0-f194.google.com with SMTP id g13so3490537qta.4
        for <linux-media@vger.kernel.org>; Sun, 27 Aug 2017 09:31:06 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 4/4] [media] ov2640: Check the return value from clk_prepare_enable()
Date: Sun, 27 Aug 2017 13:30:38 -0300
Message-Id: <1503851438-4949-4-git-send-email-festevam@gmail.com>
In-Reply-To: <1503851438-4949-1-git-send-email-festevam@gmail.com>
References: <1503851438-4949-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov2640.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index e6cbe01..5f013c8 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1108,7 +1108,9 @@ static int ov2640_probe(struct i2c_client *client,
 		priv->clk = devm_clk_get(&client->dev, "xvclk");
 		if (IS_ERR(priv->clk))
 			return PTR_ERR(priv->clk);
-		clk_prepare_enable(priv->clk);
+		ret = clk_prepare_enable(priv->clk);
+		if (ret)
+			return ret;
 	}
 
 	ret = ov2640_probe_dt(client, priv);
-- 
2.7.4
