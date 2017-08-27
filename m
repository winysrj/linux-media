Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:34030 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751182AbdH0QbC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 12:31:02 -0400
Received: by mail-qk0-f194.google.com with SMTP id a77so3598806qkb.1
        for <linux-media@vger.kernel.org>; Sun, 27 Aug 2017 09:31:01 -0700 (PDT)
From: Fabio Estevam <festevam@gmail.com>
To: mchehab@kernel.org
Cc: hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH 2/4] [media] mt9m111: Propagate the real error on v4l2_clk_get() failure
Date: Sun, 27 Aug 2017 13:30:36 -0300
Message-Id: <1503851438-4949-2-git-send-email-festevam@gmail.com>
In-Reply-To: <1503851438-4949-1-git-send-email-festevam@gmail.com>
References: <1503851438-4949-1-git-send-email-festevam@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

v4l2_clk_get() may return different error codes other than -EPROBE_DEFER,
so it is better to return the real error code instead.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
 drivers/media/i2c/mt9m111.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 99b992e..b1665d9 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -945,7 +945,7 @@ static int mt9m111_probe(struct i2c_client *client,
 
 	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(mt9m111->clk))
-		return -EPROBE_DEFER;
+		return PTR_ERR(mt9m111->clk);
 
 	/* Default HIGHPOWER context */
 	mt9m111->ctx = &context_b;
-- 
2.7.4
