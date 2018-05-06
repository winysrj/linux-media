Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:34336 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbeEFOUD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2018 10:20:03 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH v5 06/14] media: ov772x: use generic names for reset and powerdown gpios
Date: Sun,  6 May 2018 23:19:21 +0900
Message-Id: <1525616369-8843-7-git-send-email-akinobu.mita@gmail.com>
In-Reply-To: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
References: <1525616369-8843-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ov772x driver uses "rstb-gpios" and "pwdn-gpios" for reset and
powerdown pins.  However, using generic names for these gpios is
preferred.  ("reset-gpios" and "powerdown-gpios" respectively)

There is only one mainline user for these gpios, so rename to generic
names.

Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Reviewed-by: Jacopo Mondi <jacopo@jmondi.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
* v5
- No changes

 arch/sh/boards/mach-migor/setup.c | 5 +++--
 drivers/media/i2c/ov772x.c        | 8 ++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/sh/boards/mach-migor/setup.c b/arch/sh/boards/mach-migor/setup.c
index 271dfc2..73b9ee4 100644
--- a/arch/sh/boards/mach-migor/setup.c
+++ b/arch/sh/boards/mach-migor/setup.c
@@ -351,8 +351,9 @@ static struct platform_device migor_ceu_device = {
 static struct gpiod_lookup_table ov7725_gpios = {
 	.dev_id		= "0-0021",
 	.table		= {
-		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "pwdn", GPIO_ACTIVE_HIGH),
-		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "rstb", GPIO_ACTIVE_LOW),
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT0, "powerdown",
+			    GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("sh7722_pfc", GPIO_PTT3, "reset", GPIO_ACTIVE_LOW),
 	},
 };
 
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index bb5327f..97a65ce 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -837,10 +837,10 @@ static int ov772x_power_on(struct ov772x_priv *priv)
 	 * available to handle this cleanly, request the GPIO temporarily
 	 * to avoid conflicts.
 	 */
-	priv->rstb_gpio = gpiod_get_optional(&client->dev, "rstb",
+	priv->rstb_gpio = gpiod_get_optional(&client->dev, "reset",
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->rstb_gpio)) {
-		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
+		dev_info(&client->dev, "Unable to get GPIO \"reset\"");
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
@@ -1307,10 +1307,10 @@ static int ov772x_probe(struct i2c_client *client,
 		goto error_ctrl_free;
 	}
 
-	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "pwdn",
+	priv->pwdn_gpio = gpiod_get_optional(&client->dev, "powerdown",
 					     GPIOD_OUT_LOW);
 	if (IS_ERR(priv->pwdn_gpio)) {
-		dev_info(&client->dev, "Unable to get GPIO \"pwdn\"");
+		dev_info(&client->dev, "Unable to get GPIO \"powerdown\"");
 		ret = PTR_ERR(priv->pwdn_gpio);
 		goto error_clk_put;
 	}
-- 
2.7.4
