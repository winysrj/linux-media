Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:18590 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752800AbeAGJyP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 Jan 2018 04:54:15 -0500
Date: Sun, 7 Jan 2018 11:54:12 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-media@vger.kernel.org,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Rob Herring <robh@kernel.org>
Subject: Re: [PATCH] media: ov9650: support device tree probing
Message-ID: <20180107095412.7n3u2grptkfmowwp@kekkonen.localdomain>
References: <1515174543-31121-1-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1515174543-31121-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Akinobu,

Thanks for the patch. Please see my comments below.

On Sat, Jan 06, 2018 at 02:49:03AM +0900, Akinobu Mita wrote:
> The ov9650 driver currently only supports legacy platform data probe.
> This change adds device tree probing.
> 
> There has been an attempt to add device tree support for ov9650 driver
> by Hugues Fruchet as a part of the patchset that adds support of OV9655
> camera (http://www.spinics.net/lists/linux-media/msg117903.html), but
> it wasn't merged into mainline because creating a separate driver for
> OV9655 is preferred.
> 
> This is very similar to Hugues's patch, but not supporting new device.
> 
> Cc: H. Nikolaus Schaller <hns@goldelico.com>
> Cc: Hugues Fruchet <hugues.fruchet@st.com>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> ---
>  .../devicetree/bindings/media/i2c/ov9650.txt       |  35 +++++++
>  drivers/media/i2c/ov9650.c                         | 107 ++++++++++++++++-----
>  2 files changed, 117 insertions(+), 25 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov9650.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov9650.txt b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
> new file mode 100644
> index 0000000..aa5024d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov9650.txt
> @@ -0,0 +1,35 @@
> +* Omnivision OV9650/OV9652 CMOS sensor
> +
> +Required Properties:
> +- compatible: should be one of
> +	"ovti,ov9650"
> +	"ovti,ov9652"
> +- clocks: reference to the xvclk input clock.
> +
> +Optional Properties:
> +- reset-gpios: reference to the GPIO connected to the resetb pin, if any.
> +  Active is high.
> +- powerdown-gpios: reference to the GPIO connected to the pwdn pin, if any.
> +  Active is high.
> +
> +The device node must contain one 'port' child node for its digital output

s/must/shall/

Please do say there's one 'endpoint' as well.

> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +&i2c0 {
> +	ov9650: camera@30 {
> +		compatible = "ovti,ov9650";
> +		reg = <0x30>;
> +		reset-gpios = <&axi_gpio_0 0 GPIO_ACTIVE_HIGH>;
> +		powerdown-gpios = <&axi_gpio_0 1 GPIO_ACTIVE_HIGH>;
> +		clocks = <&xclk>;
> +
> +		port {
> +			ov9650_0: endpoint {
> +				remote-endpoint = <&vcap1_in0>;
> +			};
> +		};
> +	};
> +};
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 69433e1..1affdc0 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -11,8 +11,10 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/i2c.h>
>  #include <linux/kernel.h>
>  #include <linux/media.h>
> @@ -249,9 +251,10 @@ struct ov965x {
>  	struct v4l2_subdev sd;
>  	struct media_pad pad;
>  	enum v4l2_mbus_type bus_type;
> -	int gpios[NUM_GPIOS];
> +	struct gpio_desc *gpios[NUM_GPIOS];
>  	/* External master clock frequency */
>  	unsigned long mclk_frequency;
> +	struct clk *clk;
>  
>  	/* Protects the struct fields below */
>  	struct mutex lock;
> @@ -513,10 +516,9 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
>  	return 0;
>  }
>  
> -static void ov965x_gpio_set(int gpio, int val)
> +static void ov965x_gpio_set(struct gpio_desc *gpio, int val)

Could you call gpiod_set_value_cansleep() directly?

>  {
> -	if (gpio_is_valid(gpio))
> -		gpio_set_value(gpio, val);
> +	gpiod_set_value_cansleep(gpio, val);
>  }
>  
>  static void __ov965x_set_power(struct ov965x *ov965x, int on)
> @@ -1408,16 +1410,17 @@ static const struct v4l2_subdev_ops ov965x_subdev_ops = {
>  /*
>   * Reset and power down GPIOs configuration
>   */
> -static int ov965x_configure_gpios(struct ov965x *ov965x,
> -				  const struct ov9650_platform_data *pdata)
> +static int ov965x_configure_gpios_pdata(struct ov965x *ov965x,
> +				const struct ov9650_platform_data *pdata)
>  {
>  	int ret, i;
> +	int gpios[NUM_GPIOS];
>  
> -	ov965x->gpios[GPIO_PWDN] = pdata->gpio_pwdn;
> -	ov965x->gpios[GPIO_RST]  = pdata->gpio_reset;
> +	gpios[GPIO_PWDN] = pdata->gpio_pwdn;
> +	gpios[GPIO_RST]  = pdata->gpio_reset;
>  
>  	for (i = 0; i < ARRAY_SIZE(ov965x->gpios); i++) {
> -		int gpio = ov965x->gpios[i];
> +		int gpio = gpios[i];
>  
>  		if (!gpio_is_valid(gpio))
>  			continue;
> @@ -1427,14 +1430,52 @@ static int ov965x_configure_gpios(struct ov965x *ov965x,
>  			return ret;
>  		v4l2_dbg(1, debug, &ov965x->sd, "set gpio %d to 1\n", gpio);
>  
> -		gpio_set_value(gpio, 1);
> +		gpio_set_value_cansleep(gpio, 1);
>  		gpio_export(gpio, 0);
> -		ov965x->gpios[i] = gpio;
> +		ov965x->gpios[i] = gpio_to_desc(gpio);
> +	}
> +
> +	return 0;
> +}
> +
> +static int ov965x_configure_gpios(struct ov965x *ov965x)
> +{
> +	struct device *dev = &ov965x->client->dev;
> +
> +	ov965x->gpios[GPIO_PWDN] = devm_gpiod_get_optional(dev, "powerdown",
> +							GPIOD_OUT_HIGH);
> +	if (IS_ERR(ov965x->gpios[GPIO_PWDN])) {
> +		dev_info(dev, "can't get %s GPIO\n", "powerdown");
> +		return PTR_ERR(ov965x->gpios[GPIO_PWDN]);
> +	}
> +
> +	ov965x->gpios[GPIO_RST] = devm_gpiod_get_optional(dev, "reset",
> +							GPIOD_OUT_HIGH);
> +	if (IS_ERR(ov965x->gpios[GPIO_RST])) {
> +		dev_info(dev, "can't get %s GPIO\n", "reset");
> +		return PTR_ERR(ov965x->gpios[GPIO_RST]);
>  	}
>  
>  	return 0;
>  }
>  
> +static int ov965x_configure_clk(struct ov965x *ov965x)
> +{
> +	int ret;
> +
> +	ov965x->clk = devm_clk_get(&ov965x->client->dev, NULL);
> +	if (IS_ERR(ov965x->clk))
> +		return PTR_ERR(ov965x->clk);
> +
> +	ret = clk_prepare_enable(ov965x->clk);

The driver has an s_power callback; this should go there.

> +	if (ret)
> +		return ret;
> +
> +	ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
> +
> +	return 0;
> +}
> +
>  static int ov965x_detect_sensor(struct v4l2_subdev *sd)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> @@ -1476,23 +1517,25 @@ static int ov965x_probe(struct i2c_client *client,
>  	struct ov965x *ov965x;
>  	int ret;
>  
> -	if (!pdata) {
> -		dev_err(&client->dev, "platform data not specified\n");
> -		return -EINVAL;
> -	}
> -
> -	if (pdata->mclk_frequency == 0) {
> -		dev_err(&client->dev, "MCLK frequency not specified\n");
> -		return -EINVAL;
> -	}
> -
>  	ov965x = devm_kzalloc(&client->dev, sizeof(*ov965x), GFP_KERNEL);
>  	if (!ov965x)
>  		return -ENOMEM;
>  
>  	mutex_init(&ov965x->lock);
>  	ov965x->client = client;
> -	ov965x->mclk_frequency = pdata->mclk_frequency;
> +
> +	if (pdata) {
> +		ov965x->mclk_frequency = pdata->mclk_frequency;
> +		if (ov965x->mclk_frequency == 0) {
> +			dev_err(&client->dev, "MCLK frequency not specified\n");
> +			ret = -EINVAL;
> +			goto err_mutex;
> +		}
> +	} else {
> +		ret = ov965x_configure_clk(ov965x);
> +		if (ret)
> +			goto err_mutex;
> +	}
>  
>  	sd = &ov965x->sd;
>  	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
> @@ -1502,15 +1545,18 @@ static int ov965x_probe(struct i2c_client *client,
>  	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
>  		     V4L2_SUBDEV_FL_HAS_EVENTS;
>  
> -	ret = ov965x_configure_gpios(ov965x, pdata);
> +	if (pdata)
> +		ret = ov965x_configure_gpios_pdata(ov965x, pdata);
> +	else
> +		ret = ov965x_configure_gpios(ov965x);
>  	if (ret < 0)
> -		goto err_mutex;
> +		goto err_clk;
>  
>  	ov965x->pad.flags = MEDIA_PAD_FL_SOURCE;
>  	sd->entity.function = MEDIA_ENT_F_CAM_SENSOR;
>  	ret = media_entity_pads_init(&sd->entity, 1, &ov965x->pad);
>  	if (ret < 0)
> -		goto err_mutex;
> +		goto err_clk;
>  
>  	ret = ov965x_initialize_controls(ov965x);
>  	if (ret < 0)
> @@ -1536,6 +1582,8 @@ static int ov965x_probe(struct i2c_client *client,
>  	v4l2_ctrl_handler_free(sd->ctrl_handler);
>  err_me:
>  	media_entity_cleanup(&sd->entity);
> +err_clk:
> +	clk_disable_unprepare(ov965x->clk);
>  err_mutex:
>  	mutex_destroy(&ov965x->lock);
>  	return ret;
> @@ -1549,6 +1597,7 @@ static int ov965x_remove(struct i2c_client *client)
>  	v4l2_async_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(sd->ctrl_handler);
>  	media_entity_cleanup(&sd->entity);
> +	clk_disable_unprepare(ov965x->clk);
>  	mutex_destroy(&ov965x->lock);
>  
>  	return 0;
> @@ -1561,9 +1610,17 @@ static const struct i2c_device_id ov965x_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov965x_id);
>  
> +static const struct of_device_id ov965x_of_match[] = {
> +	{ .compatible = "ovti,ov9650", },
> +	{ .compatible = "ovti,ov9652", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, ov965x_of_match);
> +
>  static struct i2c_driver ov965x_i2c_driver = {
>  	.driver = {
>  		.name	= DRIVER_NAME,
> +		.of_match_table = ov965x_of_match,
>  	},
>  	.probe		= ov965x_probe,
>  	.remove		= ov965x_remove,

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
