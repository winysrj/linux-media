Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:47970 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727695AbeHOXF3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 19:05:29 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jacopo Mondi <jacopo@jmondi.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] media: ov772x: Disable clk on error path
Date: Wed, 15 Aug 2018 23:10:39 +0300
Message-Id: <1534363839-28509-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If ov772x_power_on() is unable to get GPIO rstb,
the clock is left undisabled.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/ov772x.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index e2550708abc8..7b62bf1fc5b1 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -828,6 +828,7 @@ static int ov772x_power_on(struct ov772x_priv *priv)
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->rstb_gpio)) {
 		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
+		clk_disable_unprepare(priv->clk);
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
-- 
2.7.4
