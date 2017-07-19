Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34491 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdGSDes (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 23:34:48 -0400
Received: by mail-qk0-f195.google.com with SMTP id q66so4860020qki.1
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 20:34:48 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@s-opensource.com
Cc: hans.verkuil@cisco.com, corbet@lwn.net,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 1/2] [media] ov7670: Return the real error code
Date: Wed, 19 Jul 2017 00:34:18 -0300
Message-Id: <1500435259-5838-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

When devm_clk_get() fails the real error code should be propagated,
instead of always returning -EPROBE_DEFER.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov7670.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 7270c68..552a881 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1614,7 +1614,7 @@ static int ov7670_probe(struct i2c_client *client,
 
 	info->clk = devm_clk_get(&client->dev, "xclk");
 	if (IS_ERR(info->clk))
-		return -EPROBE_DEFER;
+		return PTR_ERR(info->clk);
 	clk_prepare_enable(info->clk);
 
 	ret = ov7670_init_gpio(client, info);
-- 
2.7.4
