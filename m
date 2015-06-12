Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53362 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbFLHrj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2015 03:47:39 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Pavel Machek <pavel@ucw.cz>, Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: kernel@pengutronix.de, Alexandre Courbot <gnurou@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-media@vger.kernel.org
Subject: [PATCH] media: i2c/adp1653: set enable gpio to output
Date: Fri, 12 Jun 2015 09:47:28 +0200
Message-Id: <1434095248-31057-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without setting the direction of a gpio to output a call to
gpiod_set_value doesn't have a defined outcome.

Furthermore this is one caller less that stops us making the flags
argument to gpiod_get*() mandatory.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

this patch applies to next and is only necessary on top of 074c57a25fa2
([media] media: i2c/adp1653: Devicetree support for adp1653).

Note I plan to make the flags parameter mandatory for 4.3. So unless
this change gets into 4.2, would it be ok to let it go in via the gpio
tree?

Best regards
Uwe

 drivers/media/i2c/adp1653.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index c70ababce954..5dd39775d6ca 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -465,7 +465,7 @@ static int adp1653_of_init(struct i2c_client *client,
 
 	of_node_put(child);
 
-	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable");
+	pd->enable_gpio = devm_gpiod_get(&client->dev, "enable", GPIOD_OUT_LOW);
 	if (!pd->enable_gpio) {
 		dev_err(&client->dev, "Error getting GPIO\n");
 		return -EINVAL;
-- 
2.1.4

