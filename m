Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:25307 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab2EYTxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 15:53:10 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Fri, 25 May 2012 21:52:48 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC/PATCH 09/13] media: s5k6aa: Add support for device tree based
 instantiation
In-reply-to: <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, b.zolnierkie@samsung.com
Message-id: <1337975573-27117-9-git-send-email-s.nawrocki@samsung.com>
References: <4FBFE1EC.9060209@samsung.com>
 <1337975573-27117-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The driver initializes all board related properties except the s_power()
callback to board code. The platforms that require this callback are not
supported by this driver yet for CONFIG_OF=y.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../bindings/camera/samsung-s5k6aafx.txt           |   57 +++++++++
 drivers/media/video/s5k6aa.c                       |  129 ++++++++++++++------
 2 files changed, 146 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt

diff --git a/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
new file mode 100644
index 0000000..6685a9c
--- /dev/null
+++ b/Documentation/devicetree/bindings/camera/samsung-s5k6aafx.txt
@@ -0,0 +1,57 @@
+Samsung S5K6AAFX camera sensor
+------------------------------
+
+Required properties:
+
+- compatible : "samsung,s5k6aafx";
+- reg : base address of the device on I2C bus;
+- video-itu-601-bus : parallel bus with HSYNC and VSYNC - ITU-R BT.601;
+- vdd_core-supply : digital core voltage supply 1.5V (1.4V to 1.6V);
+- vdda-supply : analog power voltage supply 2.8V (2.6V to 3.0V);
+- vdd_reg-supply : regulator input power voltage supply 1.8V (1.7V to 1.9V)
+		   or 2.8V (2.6V to 3.0);
+- vddio-supply : I/O voltage supply 1.8V (1.65V to 1.95V)
+		 or 2.8V (2.5V to 3.1V);
+
+Optional properties:
+
+- clock-frequency : the IP's main (system bus) clock frequency in Hz, the default
+		    value when this property is not specified is 24 MHz;
+- data-lanes : number of physical lanes used (default 2 if not specified);
+- gpio-stby : specifies the S5K6AA_STBY GPIO
+- gpio-rst : specifies the S5K6AA_RST GPIO
+- samsung,s5k6aa-inv-stby : set inverted S5K6AA_STBY GPIO level;
+- samsung,s5k6aa-inv-rst : set inverted S5K6AA_RST GPIO level;
+- samsung,s5k6aa-hflip : set the default horizontal image flipping;
+- samsung,s5k6aa-vflip : set the default vertical image flipping;
+
+
+Example:
+
+	gpl2: gpio-controller@0 {
+	};
+
+	reg0: regulator@0 {
+	};
+
+	reg1: regulator@1 {
+	};
+
+	reg2: regulator@2 {
+	};
+
+	reg3: regulator@3 {
+	};
+
+	s5k6aafx@3c {
+		compatible = "samsung,s5k6aafx";
+		reg = <0x3c>;
+		clock-frequency = <24000000>;
+		gpio-rst = <&gpl2 0 2 0 3>;
+		gpio-stby = <&gpl2 1 2 0 3>;
+		video-itu-601-bus;
+		vdd_core-supply = <&reg0>;
+		vdda-supply = <&reg1>;
+		vdd_reg-supply = <&reg2>;
+		vddio-supply = <&reg3>;
+	};
diff --git a/drivers/media/video/s5k6aa.c b/drivers/media/video/s5k6aa.c
index 6625e46..ed172bb 100644
--- a/drivers/media/video/s5k6aa.c
+++ b/drivers/media/video/s5k6aa.c
@@ -20,6 +20,7 @@
 #include <linux/i2c.h>
 #include <linux/media.h>
 #include <linux/module.h>
+#include <linux/of_gpio.h>
 #include <linux/regulator/consumer.h>
 #include <linux/slab.h>
 
@@ -232,14 +233,14 @@ struct s5k6aa {
 	struct media_pad pad;
 
 	enum v4l2_mbus_type bus_type;
-	u8 mipi_lanes;
+	u32 mipi_lanes;
 
 	int (*s_power)(int enable);
 	struct regulator_bulk_data supplies[S5K6AA_NUM_SUPPLIES];
 	struct s5k6aa_gpio gpio[GPIO_NUM];
 
 	/* external master clock frequency */
-	unsigned long mclk_frequency;
+	u32 mclk_frequency;
 	/* ISP internal master clock frequency */
 	u16 clk_fop;
 	/* output pixel clock frequency range */
@@ -1519,68 +1520,109 @@ static void s5k6aa_free_gpios(struct s5k6aa *s5k6aa)
 	}
 }
 
-static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa,
-				  const struct s5k6aa_platform_data *pdata)
+static int s5k6aa_configure_gpios(struct s5k6aa *s5k6aa, struct device *dev)
 {
-	const struct s5k6aa_gpio *gpio = &pdata->gpio_stby;
+	const struct s5k6aa_platform_data *pdata = dev->platform_data;
+	struct device_node *np = dev->of_node;
+	const struct s5k6aa_gpio *pgpio;
+	struct s5k6aa_gpio gpio = { 0 };
 	int ret;
 
 	s5k6aa->gpio[STBY].gpio = -EINVAL;
 	s5k6aa->gpio[RST].gpio  = -EINVAL;
 
-	ret = s5k6aa_configure_gpio(gpio->gpio, gpio->level, "S5K6AA_STBY");
+	if (np) {
+		gpio.gpio = of_get_named_gpio(np, "gpio-stby", 0);
+		if (!of_get_property(np, "samsung,s5k6aa-inv-stby", NULL))
+			gpio.level = 1;
+	}
+	pgpio = np ? &gpio : &pdata->gpio_stby;
+	ret = s5k6aa_configure_gpio(pgpio->gpio, pgpio->level, "S5K6AA_STBY");
 	if (ret) {
 		s5k6aa_free_gpios(s5k6aa);
 		return ret;
 	}
-	s5k6aa->gpio[STBY] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
+	s5k6aa->gpio[STBY] = *pgpio;
 
-	gpio = &pdata->gpio_reset;
-	ret = s5k6aa_configure_gpio(gpio->gpio, gpio->level, "S5K6AA_RST");
-	if (ret) {
-		s5k6aa_free_gpios(s5k6aa);
-		return ret;
+	if (np) {
+		gpio.gpio = of_get_named_gpio(np, "gpio-rst", 0);
+		if (!of_get_property(np, "samsung,s5k6aa-inv-rst", NULL))
+			gpio.level = 1;
+	}
+	pgpio = np ? &gpio : &pdata->gpio_reset;
+	ret = s5k6aa_configure_gpio(pgpio->gpio, pgpio->level, "S5K6AA_RST");
+	if (ret)
+		goto err;
+
+	s5k6aa->gpio[RST] = *pgpio;
+	return 0;
+ err:
+	s5k6aa_free_gpios(s5k6aa);
+	return ret;
+}
+
+static int s5k6aa_get_platform_data(struct s5k6aa *s5k6aa,
+				    struct i2c_client *client)
+{
+	const struct s5k6aa_platform_data *pdata = client->dev.platform_data;
+	struct device_node *np = client->dev.of_node;
+	const char *bus_type;
+
+	if (np == NULL) {
+		if (pdata == NULL) {
+			dev_err(&client->dev, "Platform data not specified\n");
+			return -EINVAL;
+		}
+		s5k6aa->mclk_frequency = pdata->mclk_frequency;
+		s5k6aa->bus_type = pdata->bus_type;
+		s5k6aa->mipi_lanes = pdata->nlanes;
+		s5k6aa->s_power	= pdata->set_power;
+		s5k6aa->inv_hflip = pdata->horiz_flip;
+		s5k6aa->inv_vflip = pdata->vert_flip;
+		return 0;
 	}
-	s5k6aa->gpio[RST] = *gpio;
-	if (gpio_is_valid(gpio->gpio))
-		gpio_set_value(gpio->gpio, 0);
 
+	if (of_property_read_u32(np, "clock-frequency",
+				  &s5k6aa->mclk_frequency))
+		s5k6aa->mclk_frequency = 24000000UL;
+
+	if (of_property_read_u32(np, "data-lanes", &s5k6aa->mipi_lanes))
+		s5k6aa->mipi_lanes = 2;
+
+	if (!of_property_read_string(np, "video-bus-type", &bus_type) &&
+	    !strcmp(bus_type, "mipi-csi2"))
+		s5k6aa->bus_type = V4L2_MBUS_CSI2;
+	else
+		s5k6aa->bus_type = V4L2_MBUS_PARALLEL;
+
+	s5k6aa->inv_hflip = of_property_read_bool(np, "samsung,s5k6aa-hflip");
+	s5k6aa->inv_vflip = of_property_read_bool(np, "samsung,s5k6aa-vflip");
 	return 0;
 }
 
+
 static int s5k6aa_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	const struct s5k6aa_platform_data *pdata = client->dev.platform_data;
 	struct v4l2_subdev *sd;
 	struct s5k6aa *s5k6aa;
-	int i, ret;
+	int i, ret = -EINVAL;
 
-	if (pdata == NULL) {
-		dev_err(&client->dev, "Platform data not specified\n");
-		return -EINVAL;
-	}
+	s5k6aa = devm_kzalloc(&client->dev, sizeof(*s5k6aa), GFP_KERNEL);
+	if (!s5k6aa)
+		return -ENOMEM;
 
-	if (pdata->mclk_frequency == 0) {
+	ret = s5k6aa_get_platform_data(s5k6aa, client);
+	if (ret < 0)
+		return ret;
+
+	if (s5k6aa->mclk_frequency == 0) {
 		dev_err(&client->dev, "MCLK frequency not specified\n");
 		return -EINVAL;
 	}
 
-	s5k6aa = kzalloc(sizeof(*s5k6aa), GFP_KERNEL);
-	if (!s5k6aa)
-		return -ENOMEM;
-
 	mutex_init(&s5k6aa->lock);
 
-	s5k6aa->mclk_frequency = pdata->mclk_frequency;
-	s5k6aa->bus_type = pdata->bus_type;
-	s5k6aa->mipi_lanes = pdata->nlanes;
-	s5k6aa->s_power	= pdata->set_power;
-	s5k6aa->inv_hflip = pdata->horiz_flip;
-	s5k6aa->inv_vflip = pdata->vert_flip;
-
 	sd = &s5k6aa->sd;
 	v4l2_i2c_subdev_init(sd, client, &s5k6aa_subdev_ops);
 	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
@@ -1592,9 +1634,9 @@ static int s5k6aa_probe(struct i2c_client *client,
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;
 	ret = media_entity_init(&sd->entity, 1, &s5k6aa->pad, 0);
 	if (ret)
-		goto out_err1;
+		return ret;
 
-	ret = s5k6aa_configure_gpios(s5k6aa, pdata);
+	ret = s5k6aa_configure_gpios(s5k6aa, &client->dev);
 	if (ret)
 		goto out_err2;
 
@@ -1627,8 +1669,6 @@ out_err3:
 	s5k6aa_free_gpios(s5k6aa);
 out_err2:
 	media_entity_cleanup(&s5k6aa->sd.entity);
-out_err1:
-	kfree(s5k6aa);
 	return ret;
 }
 
@@ -1642,7 +1682,6 @@ static int s5k6aa_remove(struct i2c_client *client)
 	media_entity_cleanup(&sd->entity);
 	regulator_bulk_free(S5K6AA_NUM_SUPPLIES, s5k6aa->supplies);
 	s5k6aa_free_gpios(s5k6aa);
-	kfree(s5k6aa);
 
 	return 0;
 }
@@ -1653,9 +1692,18 @@ static const struct i2c_device_id s5k6aa_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, s5k6aa_id);
 
+#ifdef CONFIG_OF
+static const struct of_device_id s5k6aa_of_match[] __devinitconst = {
+	{ .compatible = "samsung,s5k6aafx" },
+	{ /* sentinel */ },
+};
+MODULE_DEVICE_TABLE(of, s5k6aa_of_match);
+#endif
+
 
 static struct i2c_driver s5k6aa_i2c_driver = {
 	.driver = {
+		.of_match_table = of_match_ptr(s5k6aa_of_match),
 		.name = DRIVER_NAME
 	},
 	.probe		= s5k6aa_probe,
@@ -1665,6 +1713,7 @@ static struct i2c_driver s5k6aa_i2c_driver = {
 
 module_i2c_driver(s5k6aa_i2c_driver);
 
+MODULE_ALIAS("i2c:s5k6aafx");
 MODULE_DESCRIPTION("Samsung S5K6AA(FX) SXGA camera driver");
 MODULE_AUTHOR("Sylwester Nawrocki <s.nawrocki@samsung.com>");
 MODULE_LICENSE("GPL");
-- 
1.7.10

