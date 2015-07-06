Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57868 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbGFJKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 05:10:01 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>
Cc: linux-gpio@vger.kernel.org, kernel@pengutronix.de,
	Pavel Machek <pavel@ucw.cz>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH gpio-for-next 05/10] media: i2c/adp1653: set enable gpio to output
Date: Mon,  6 Jul 2015 11:09:45 +0200
Message-Id: <1436173790-29963-5-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20150706090759.GS11824@pengutronix.de>
References: <20150706090759.GS11824@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Without setting the direction of a gpio to output a call to
gpiod_set_value doesn't have a defined outcome.

Furthermore this is one caller less that stops us making the flags
argument to gpiod_get*() mandatory.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
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

