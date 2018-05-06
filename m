Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:35934 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbeEFOUF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:20:05 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v5 07/14] media: ov772x: omit consumer ID when getting clock reference
Date: Sun,  6 May 2018 23:19:22 +0900
Message-Id: <1525616369-8843-8-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently the ov772x driver obtains a clock with a specific consumer ID.
As there's a single clock for this driver, we could omit clock-names
property in device tree by passing NULL as a consumer ID to clk_get().

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Suggested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5
- No changes

 arch/sh/boards/mach-migor/setup.c | 2 +-
 drivers/media/i2c/ov772x.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 73b9ee4..11f8001 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -593,7 +593,7 @@ static int __init migor_devices_setup(void)
 	}
 
 	/* Add a clock alias for ov7725 xclk source. */
-	clk_add_alias("xclk", "0-0021", "video_clk", NULL);
+	clk_add_alias(NULL, "0-0021", "video_clk", NULL);
 
 	/* Register GPIOs for video sources. */
 	gpiod_add_lookup_table(&ov7725_gpios);
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 97a65ce..f939e28 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1300,7 +1300,7 @@ static int ov772x_probe(struct i2c_client *client,
 	if (priv->hdl.error)
 		return priv->hdl.error;
 
-	priv->clk = clk_get(&client->dev, "xclk");
+	priv->clk = clk_get(&client->dev, NULL);
 	if (IS_ERR(priv->clk)) {
 		dev_err(&client->dev, "Unable to get xclk clock\n");
 		ret = PTR_ERR(priv->clk);
-- 
2.7.4
