Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33730 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH0QbA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 12:31:00 -0400
Received: by mail-qk0-f195.google.com with SMTP id i69so2322893qkh.0
        for <linux-media@vger.kernel.org>; Sun, 27 Aug 2017 09:31:00 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 1/4] [media] max2175: Propagate the real error on devm_clk_get() failure
Date: Sun, 27 Aug 2017 13:30:35 -0300
Message-Id: <1503851438-4949-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

When devm_clk_get() fails we should return the real error code
instead of always returning -ENODEV.

This allows defer probe to happen in the case the clock provider has
not been enabled by the time max2175 driver gets probed.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/max2175.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index a4736a8..bf0e821 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -1319,7 +1319,7 @@ static int max2175_probe(struct i2c_client *client,
 	if (IS_ERR(clk)) {
 		ret = PTR_ERR(clk);
 		dev_err(&client->dev, "cannot get clock %d\n", ret);
-		return -ENODEV;
+		return ret;
 	}
 
 	regmap = devm_regmap_init_i2c(client, &max2175_regmap_config);
-- 
2.7.4
