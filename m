Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:51586 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751546AbdFVPGm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Jun 2017 11:06:42 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC: <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>,
        Hugues Fruchet <hugues.fruchet@st.com>
Subject: [PATCH v1 2/6] [media] ov9650: add device tree support
Date: Thu, 22 Jun 2017 17:05:38 +0200
Message-ID: <1498143942-12682-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Allows use of device tree configuration data.
If no device tree data is there, configuration is taken from platform data.
In order to keep GPIOs configuration compatible between both way of doing,
GPIOs are switched to descriptor-based interface.

Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 drivers/media/i2c/Kconfig  |  2 +-
 drivers/media/i2c/ov9650.c | 81 ++++++++++++++++++++++++++++++++++------------
 2 files changed, 61 insertions(+), 22 deletions(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index c380e24..efea14d 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -595,7 +595,7 @@ config VIDEO_OV7670
 
 config VIDEO_OV9650
 	tristate "OmniVision OV9650/OV9652 sensor support"
-	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
+	depends on GPIOLIB && I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
 	---help---
 	  This is a V4L2 sensor-level driver for the Omnivision
 	  OV9650 and OV9652 camera sensors.
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 2de2fbb..8340a45 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -11,12 +11,14 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <linux/clk.h>
 #include <linux/delay.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/media.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/ratelimit.h>
 #include <linux/slab.h>
 #include <linux/string.h>
@@ -249,9 +251,10 @@ struct ov965x {
 	struct v4l2_subdev sd;
 	struct media_pad pad;
 	enum v4l2_mbus_type bus_type;
-	int gpios[NUM_GPIOS];
+	struct gpio_desc *gpios[NUM_GPIOS];
 	/* External master clock frequency */
 	unsigned long mclk_frequency;
+	struct clk *clk;
 
 	/* Protects the struct fields below */
 	struct mutex lock;
@@ -511,10 +514,10 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
 	return 0;
 }
 
-static void ov965x_gpio_set(int gpio, int val)
+static void ov965x_gpio_set(struct gpio_desc *gpio, int val)
 {
-	if (gpio_is_valid(gpio))
-		gpio_set_value(gpio, val);
+	if (gpio)
+		gpiod_set_value_cansleep(gpio, val);
 }
 
 static void __ov965x_set_power(struct ov965x *ov965x, int on)
@@ -1406,24 +1409,28 @@ static int ov965x_configure_gpios(struct ov965x *ov965x,
 				  const struct ov9650_platform_data *pdata)
 {
 	int ret, i;
+	int gpios[NUM_GPIOS];
 
-	ov965x->gpios[GPIO_PWDN] = pdata->gpio_pwdn;
-	ov965x->gpios[GPIO_RST]  = pdata->gpio_reset;
+	gpios[GPIO_PWDN] = pdata->gpio_pwdn;
+	gpios[GPIO_RST]  = pdata->gpio_reset;
 
-	for (i = 0; i < ARRAY_SIZE(ov965x->gpios); i++) {
-		int gpio = ov965x->gpios[i];
+	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
+		int gpio = gpios[i];
 
 		if (!gpio_is_valid(gpio))
 			continue;
 		ret = devm_gpio_request_one(&ov965x->client->dev, gpio,
-					    GPIOF_OUT_INIT_HIGH, "OV965X");
-		if (ret < 0)
+					    GPIOF_OUT_INIT_HIGH, DRIVER_NAME);
+		if (ret < 0) {
+			dev_err(&ov965x->client->dev,
+				"Failed to request gpio%d (%d)\n", gpio, ret);
 			return ret;
+		}
 		v4l2_dbg(1, debug, &ov965x->sd, "set gpio %d to 1\n", gpio);
 
 		gpio_set_value(gpio, 1);
 		gpio_export(gpio, 0);
-		ov965x->gpios[i] = gpio;
+		ov965x->gpios[i] = gpio_to_desc(gpio);
 	}
 
 	return 0;
@@ -1469,14 +1476,10 @@ static int ov965x_probe(struct i2c_client *client,
 	struct v4l2_subdev *sd;
 	struct ov965x *ov965x;
 	int ret;
+	struct device_node *np = client->dev.of_node;
 
-	if (pdata == NULL) {
-		dev_err(&client->dev, "platform data not specified\n");
-		return -EINVAL;
-	}
-
-	if (pdata->mclk_frequency == 0) {
-		dev_err(&client->dev, "MCLK frequency not specified\n");
+	if (!pdata && !np) {
+		dev_err(&client->dev, "Platform data or device tree data must be provided\n");
 		return -EINVAL;
 	}
 
@@ -1486,7 +1489,36 @@ static int ov965x_probe(struct i2c_client *client,
 
 	mutex_init(&ov965x->lock);
 	ov965x->client = client;
-	ov965x->mclk_frequency = pdata->mclk_frequency;
+	mutex_init(&ov965x->lock);
+
+	if (np) {
+		/* Device tree */
+		ov965x->gpios[GPIO_RST] =
+			devm_gpiod_get_optional(&client->dev, "resetb",
+						GPIOD_OUT_LOW);
+		ov965x->gpios[GPIO_PWDN] =
+			devm_gpiod_get_optional(&client->dev, "pwdn",
+						GPIOD_OUT_HIGH);
+
+		ov965x->clk = devm_clk_get(&client->dev, NULL);
+		if (IS_ERR(ov965x->clk)) {
+			dev_err(&client->dev, "Could not get clock\n");
+			return PTR_ERR(ov965x->clk);
+		}
+		ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
+	} else {
+		/* Platform data */
+		ret = ov965x_configure_gpios(ov965x, pdata);
+		if (ret < 0)
+			return ret;
+
+		if (pdata->mclk_frequency == 0) {
+			dev_err(&client->dev, "MCLK frequency is mandatory\n");
+			return -EINVAL;
+		}
+		ov965x->mclk_frequency = pdata->mclk_frequency;
+	}
+
 
 	sd = &ov965x->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
@@ -1545,15 +1577,22 @@ static int ov965x_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id ov965x_id[] = {
-	{ "OV9650", 0 },
-	{ "OV9652", 0 },
+	{ "OV9650", 0x9650 },
+	{ "OV9652", 0x9652 },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(i2c, ov965x_id);
 
+static const struct of_device_id ov965x_of_match[] = {
+	{ .compatible = "ovti,ov9650", .data = (void *)0x9650 },
+	{ .compatible = "ovti,ov9652", .data = (void *)0x9652 },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(of, ov965x_of_match);
 static struct i2c_driver ov965x_i2c_driver = {
 	.driver = {
 		.name	= DRIVER_NAME,
+		.of_match_table = of_match_ptr(ov965x_of_match),
 	},
 	.probe		= ov965x_probe,
 	.remove		= ov965x_remove,
-- 
1.9.1
