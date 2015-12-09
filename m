Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35468 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbbLINrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Dec 2015 08:47:00 -0500
Received: by lfdl133 with SMTP id l133so34406495lfd.2
        for <linux-media@vger.kernel.org>; Wed, 09 Dec 2015 05:46:59 -0800 (PST)
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-gpio@vger.kernel.org, Johan Hovold <johan@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Michael Welling <mwelling@ieee.org>,
	Markus Pargmann <mpa@pengutronix.de>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	linux-media@vger.kernel.org
Subject: [PATCH 160/182] [media]: cxd2830r: use gpiochip data pointer
Date: Wed,  9 Dec 2015 14:46:55 +0100
Message-Id: <1449668815-6072-1-git-send-email-linus.walleij@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This makes the driver use the data pointer added to the gpio_chip
to store a pointer to the state container instead of relying on
container_of().

Cc: Antti Palosaari <crope@iki.fi>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
Mauro: please ACK this so I can merge it in the GPIO tree.
---
 drivers/media/dvb-frontends/cxd2820r_core.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 24a457d9d803..ba4cb7557aa5 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -606,8 +606,7 @@ static int cxd2820r_i2c_gate_ctrl(struct dvb_frontend *fe, int enable)
 static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
 		int val)
 {
-	struct cxd2820r_priv *priv =
-			container_of(chip, struct cxd2820r_priv, gpio_chip);
+	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
 	u8 gpio[GPIO_COUNT];
 
 	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
@@ -620,8 +619,7 @@ static int cxd2820r_gpio_direction_output(struct gpio_chip *chip, unsigned nr,
 
 static void cxd2820r_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
 {
-	struct cxd2820r_priv *priv =
-			container_of(chip, struct cxd2820r_priv, gpio_chip);
+	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
 	u8 gpio[GPIO_COUNT];
 
 	dev_dbg(&priv->i2c->dev, "%s: nr=%d val=%d\n", __func__, nr, val);
@@ -636,8 +634,7 @@ static void cxd2820r_gpio_set(struct gpio_chip *chip, unsigned nr, int val)
 
 static int cxd2820r_gpio_get(struct gpio_chip *chip, unsigned nr)
 {
-	struct cxd2820r_priv *priv =
-			container_of(chip, struct cxd2820r_priv, gpio_chip);
+	struct cxd2820r_priv *priv = gpiochip_get_data(chip);
 
 	dev_dbg(&priv->i2c->dev, "%s: nr=%d\n", __func__, nr);
 
@@ -731,7 +728,7 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *cfg,
 		priv->gpio_chip.base = -1; /* dynamic allocation */
 		priv->gpio_chip.ngpio = GPIO_COUNT;
 		priv->gpio_chip.can_sleep = 1;
-		ret = gpiochip_add(&priv->gpio_chip);
+		ret = gpiochip_add_data(&priv->gpio_chip, priv);
 		if (ret)
 			goto error;
 
-- 
2.4.3

