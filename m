Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:32831 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751560AbdGSDev (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 23:34:51 -0400
Received: by mail-qt0-f193.google.com with SMTP id 50so3662487qtz.0
        for <linux-media@vger.kernel.org>; Tue, 18 Jul 2017 20:34:51 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@s-opensource.com
Cc: hans.verkuil@cisco.com, corbet@lwn.net,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 2/2] [media] ov7670: Check the return value from clk_prepare_enable()
Date: Wed, 19 Jul 2017 00:34:19 -0300
Message-Id: <1500435259-5838-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1500435259-5838-1-git-send-email-festevam@gmail.com>
References: <1500435259-5838-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

clk_prepare_enable() may fail, so we should better check its return value
and propagate it in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/ov7670.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 552a881..e88549f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1615,7 +1615,9 @@ static int ov7670_probe(struct i2c_client *client,
 	info->clk = devm_clk_get(&client->dev, "xclk");
 	if (IS_ERR(info->clk))
 		return PTR_ERR(info->clk);
-	clk_prepare_enable(info->clk);
+	ret = clk_prepare_enable(info->clk);
+	if (ret)
+		return ret;
 
 	ret = ov7670_init_gpio(client, info);
 	if (ret)
-- 
2.7.4
