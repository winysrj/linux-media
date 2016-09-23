Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:52765 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966538AbcIWSlu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Sep 2016 14:41:50 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 2/2] media: mt9m111: add regulator support
Date: Fri, 23 Sep 2016 20:41:40 +0200
Message-Id: <1474656100-7415-2-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1474656100-7415-1-git-send-email-robert.jarzmik@free.fr>
References: <1474656100-7415-1-git-send-email-robert.jarzmik@free.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In the soc_camera removal, the board specific power callback was
dropped. This at least will remove the power optimization from ezx and
em-x270 pxa based boards.

As to recreate the same level of functionality, make the mt9m111 have a
regulator providing it its power, so that board designers can plug in a
gpio based or ldo regulator, mimicking their former soc_camera power
hook.

Fixes: 5c10113cc668 ("media: mt9m111: make a standalone v4l2 subdevice")
Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
---
 drivers/media/i2c/mt9m111.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/media/i2c/mt9m111.c b/drivers/media/i2c/mt9m111.c
index 72e71b762827..bb8ed4927e44 100644
--- a/drivers/media/i2c/mt9m111.c
+++ b/drivers/media/i2c/mt9m111.c
@@ -13,6 +13,7 @@
 #include <linux/log2.h>
 #include <linux/gpio.h>
 #include <linux/delay.h>
+#include <linux/regulator/consumer.h>
 #include <linux/v4l2-mediabus.h>
 #include <linux/module.h>
 
@@ -215,6 +216,7 @@ struct mt9m111 {
 	int power_count;
 	const struct mt9m111_datafmt *fmt;
 	int lastpage;	/* PageMap cache value */
+	struct regulator *regulator;
 };
 
 /* Find a data format by a pixel code */
@@ -788,6 +790,9 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 	if (ret < 0)
 		return ret;
 
+	if (mt9m111->regulator)
+		regulator_enable(mt9m111->regulator);
+
 	ret = mt9m111_resume(mt9m111);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to resume the sensor: %d\n", ret);
@@ -800,6 +805,8 @@ static int mt9m111_power_on(struct mt9m111 *mt9m111)
 static void mt9m111_power_off(struct mt9m111 *mt9m111)
 {
 	mt9m111_suspend(mt9m111);
+	if (mt9m111->regulator)
+		regulator_disable(mt9m111->regulator);
 	v4l2_clk_disable(mt9m111->clk);
 }
 
@@ -943,6 +950,13 @@ static int mt9m111_probe(struct i2c_client *client,
 	if (!mt9m111)
 		return -ENOMEM;
 
+	mt9m111->regulator = devm_regulator_get(&client->dev, "vdd");
+	if (IS_ERR(mt9m111->regulator)) {
+		dev_err(&client->dev, "regulator not found: %d\n",
+			PTR_ERR(mt9m111->regulator));
+		return PTR_ERR(mt9m111->regulator);
+	}
+
 	mt9m111->clk = v4l2_clk_get(&client->dev, "mclk");
 	if (IS_ERR(mt9m111->clk))
 		return -EPROBE_DEFER;
-- 
2.1.4

