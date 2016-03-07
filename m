Return-path: <linux-media-owner@vger.kernel.org>
Received: from mleia.com ([178.79.152.223]:44729 "EHLO mail.mleia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752427AbcCGSji (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Mar 2016 13:39:38 -0500
From: Vladimir Zapolskiy <vz@mleia.com>
To: Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH] media: i2c/adp1653: fix check of devm_gpiod_get() error code
Date: Mon,  7 Mar 2016 20:39:32 +0200
Message-Id: <1457375972-9923-1-git-send-email-vz@mleia.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The devm_gpiod_get() function returns either a valid pointer to
struct gpio_desc or ERR_PTR() error value, check for NULL is bogus.

Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
---
 drivers/media/i2c/adp1653.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index fb7ed73..9e1731c 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -466,9 +466,9 @@ static int adp1653_of_init(struct i2c_client *client,
 	of_node_put(child);
 
 	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
-	if (!pd->enable_gpio) {
+	if (IS_ERR(pd->enable_gpio)) {
 		dev_err(&client->dev, "Error getting GPIO\n");
-		return -EINVAL;
+		return PTR_ERR(pd->enable_gpio);
 	}
 
 	return 0;
-- 
2.1.4

