Return-Path: <SRS0=gp/0=PH=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C35C43387
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 11:42:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E79C218FD
	for <linux-media@archiver.kernel.org>; Sun, 30 Dec 2018 11:42:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbeL3LmI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 30 Dec 2018 06:42:08 -0500
Received: from mail.ispras.ru ([83.149.199.45]:48806 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbeL3LmH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Dec 2018 06:42:07 -0500
Received: from localhost.localdomain (ppp85-140-180-153.pppoe.mtu-net.ru [85.140.180.153])
        by mail.ispras.ru (Postfix) with ESMTPSA id C4D8B54006B;
        Sun, 30 Dec 2018 14:42:04 +0300 (MSK)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2 2/2] media: tw9910: add helper function for setting gpiod value
Date:   Sun, 30 Dec 2018 14:41:41 +0300
Message-Id: <1546170101-22732-2-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1546170101-22732-1-git-send-email-khoroshilov@ispras.ru>
References: <1546170101-22732-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

tw9910 driver tries to sleep for the smae period of time
after each gpiod_set_value(). The patch moves duplicated code
to a helper function.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/media/i2c/tw9910.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/media/i2c/tw9910.c b/drivers/media/i2c/tw9910.c
index 0971f8a34afb..8d1138e13803 100644
--- a/drivers/media/i2c/tw9910.c
+++ b/drivers/media/i2c/tw9910.c
@@ -584,6 +584,14 @@ static int tw9910_s_register(struct v4l2_subdev *sd,
 }
 #endif
 
+static void tw9910_set_gpio_value(struct gpio_desc *desc, int value)
+{
+	if (desc) {
+		gpiod_set_value(desc, value);
+		usleep_range(500, 1000);
+	}
+}
+
 static int tw9910_power_on(struct tw9910_priv *priv)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&priv->subdev);
@@ -595,10 +603,7 @@ static int tw9910_power_on(struct tw9910_priv *priv)
 			return ret;
 	}
 
-	if (priv->pdn_gpio) {
-		gpiod_set_value(priv->pdn_gpio, 0);
-		usleep_range(500, 1000);
-	}
+	tw9910_set_gpio_value(priv->pdn_gpio, 0);
 
 	/*
 	 * FIXME: The reset signal is connected to a shared GPIO on some
@@ -611,18 +616,13 @@ static int tw9910_power_on(struct tw9910_priv *priv)
 	if (IS_ERR(priv->rstb_gpio)) {
 		dev_info(&client->dev, "Unable to get GPIO \"rstb\"");
 		clk_disable_unprepare(priv->clk);
-		if (priv->pdn_gpio) {
-			gpiod_set_value(priv->pdn_gpio, 1);
-			usleep_range(500, 1000);
-		}
+		tw9910_set_gpio_value(priv->pdn_gpio, 1);
 		return PTR_ERR(priv->rstb_gpio);
 	}
 
 	if (priv->rstb_gpio) {
-		gpiod_set_value(priv->rstb_gpio, 1);
-		usleep_range(500, 1000);
-		gpiod_set_value(priv->rstb_gpio, 0);
-		usleep_range(500, 1000);
+		tw9910_set_gpio_value(priv->rstb_gpio, 1);
+		tw9910_set_gpio_value(priv->rstb_gpio, 0);
 
 		gpiod_put(priv->rstb_gpio);
 	}
@@ -633,11 +633,7 @@ static int tw9910_power_on(struct tw9910_priv *priv)
 static int tw9910_power_off(struct tw9910_priv *priv)
 {
 	clk_disable_unprepare(priv->clk);
-
-	if (priv->pdn_gpio) {
-		gpiod_set_value(priv->pdn_gpio, 1);
-		usleep_range(500, 1000);
-	}
+	tw9910_set_gpio_value(priv->pdn_gpio, 1);
 
 	return 0;
 }
-- 
2.7.4

