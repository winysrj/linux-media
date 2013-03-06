Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:42423 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab3CFLzI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 06:55:08 -0500
From: Shaik Ameer Basha <shaik.ameer@samsung.com>
To: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org
Cc: s.nawrocki@samsung.com, shaik.samsung@gmail.com
Subject: [RFC 11/12] media: m5mols: Adding dt support to m5mols driver
Date: Wed,  6 Mar 2013 17:23:57 +0530
Message-Id: <1362570838-4737-12-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the dt support to m5mols driver.

Signed-off-by: Shaik Ameer Basha <shaik.ameer@samsung.com>
---
 drivers/media/i2c/m5mols/m5mols_core.c |   54 +++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index d4e7567..21c66ef 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -19,6 +19,8 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
+#include <linux/of_gpio.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/regulator/consumer.h>
 #include <linux/videodev2.h>
 #include <linux/module.h>
@@ -926,13 +928,38 @@ static irqreturn_t m5mols_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static const struct of_device_id m5mols_match[];
+
 static int m5mols_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	const struct m5mols_platform_data *pdata = client->dev.platform_data;
+	struct m5mols_platform_data *pdata;
 	struct m5mols_info *info;
+	const struct of_device_id *of_id;
 	struct v4l2_subdev *sd;
 	int ret;
+	struct pinctrl *pctrl;
+	int eint_gpio = 0;
+
+	if (client->dev.of_node) {
+		of_id = of_match_node(m5mols_match, client->dev.of_node);
+		if (of_id)
+			pdata = (struct m5mols_platform_data *)of_id->data;
+		client->dev.platform_data = pdata;
+	} else {
+		pdata = client->dev.platform_data;
+	}
+
+	if (!pdata)
+		return -EINVAL;
+
+	pctrl = devm_pinctrl_get_select_default(&client->dev);
+	if (client->dev.of_node) {
+		eint_gpio = of_get_named_gpio(client->dev.of_node, "gpios", 0);
+		client->irq = gpio_to_irq(eint_gpio);
+		pdata->gpio_reset = of_get_named_gpio(client->dev.of_node,
+								"gpios", 1);
+	}
 
 	if (pdata == NULL) {
 		dev_err(&client->dev, "No platform data\n");
@@ -1040,9 +1067,34 @@ static const struct i2c_device_id m5mols_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, m5mols_id);
 
+static int m5mols_set_power(struct device *dev, int on)
+{
+	struct m5mols_platform_data *pdata =
+			(struct m5mols_platform_data *)dev->platform_data;
+	gpio_set_value(pdata->gpio_reset, !on);
+	gpio_set_value(pdata->gpio_reset, !!on);
+	return 0;
+}
+
+static struct m5mols_platform_data m5mols_drvdata = {
+	.gpio_reset	= 0,
+	.reset_polarity	= 0,
+	.set_power	= m5mols_set_power,
+};
+
+static const struct of_device_id m5mols_match[] = {
+	{
+		.compatible = "fujitsu,m-5mols",
+		.data = &m5mols_drvdata,
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, m5mols_match);
+
 static struct i2c_driver m5mols_i2c_driver = {
 	.driver = {
 		.name	= MODULE_NAME,
+		.of_match_table = m5mols_match,
 	},
 	.probe		= m5mols_probe,
 	.remove		= m5mols_remove,
-- 
1.7.9.5

