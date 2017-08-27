Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33695 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH0QbE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 12:31:04 -0400
Received: by mail-qt0-f193.google.com with SMTP id q53so3499501qtq.0
        for <linux-media@vger.kernel.org>; Sun, 27 Aug 2017 09:31:03 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 3/4] [media] ov2640: Propagate the real error on devm_clk_get() failure
Date: Sun, 27 Aug 2017 13:30:37 -0300
Message-Id: <1503851438-4949-3-git-send-email-festevam@gmail.com>
In-Reply-To: <1503851438-4949-1-git-send-email-festevam@gmail.com>
References: <1503851438-4949-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

devm_clk_get() may return different error codes other than -EPROBE_DEFER,
so it is better to return the real error code instead.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov2640.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov2640.c b/drivers/media/i2c/ov2640.c
index e6d0c1f..e6cbe01 100644
--- a/drivers/media/i2c/ov2640.c
+++ b/drivers/media/i2c/ov2640.c
@@ -1107,7 +1107,7 @@ static int ov2640_probe(struct i2c_client *client,
 	if (client->dev.of_node) {
 		priv->clk = devm_clk_get(&client->dev, "xvclk");
 		if (IS_ERR(priv->clk))
-			return -EPROBE_DEFER;
+			return PTR_ERR(priv->clk);
 		clk_prepare_enable(priv->clk);
 	}
 
-- 
2.7.4
