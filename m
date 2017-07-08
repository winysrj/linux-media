Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46924 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751858AbdGHXGM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 8 Jul 2017 19:06:12 -0400
Date: Sun, 9 Jul 2017 02:06:06 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        " H. Nikolaus Schaller" <hns@goldelico.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Yannick Fertre <yannick.fertre@st.com>
Subject: Re: [PATCH v2 3/7] [media] ov9650: add device tree support
Message-ID: <20170708230606.zva4m52anvffo2vb@valkosipuli.retiisi.org.uk>
References: <1499073368-31905-1-git-send-email-hugues.fruchet@st.com>
 <1499073368-31905-4-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499073368-31905-4-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hugues,

On Mon, Jul 03, 2017 at 11:16:04AM +0200, Hugues Fruchet wrote:
> Allows use of device tree configuration data.
> If no device tree data is there, configuration is taken from platform data.
> In order to keep GPIOs configuration compatible between both way of doing,
> GPIOs are switched to descriptor-based interface.
> 
> Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  drivers/media/i2c/Kconfig  |  2 +-
>  drivers/media/i2c/ov9650.c | 77 ++++++++++++++++++++++++++++++++++------------
>  2 files changed, 59 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
> index 121b3b5..168115c 100644
> --- a/drivers/media/i2c/Kconfig
> +++ b/drivers/media/i2c/Kconfig
> @@ -615,7 +615,7 @@ config VIDEO_OV7670
>  
>  config VIDEO_OV9650
>  	tristate "OmniVision OV9650/OV9652 sensor support"
> -	depends on I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	depends on GPIOLIB && I2C && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
>  	---help---
>  	  This is a V4L2 sensor-level driver for the Omnivision
>  	  OV9650 and OV9652 camera sensors.
> diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
> index 1e4e99e..7e9a902 100644
> --- a/drivers/media/i2c/ov9650.c
> +++ b/drivers/media/i2c/ov9650.c
> @@ -11,12 +11,14 @@
>   * it under the terms of the GNU General Public License version 2 as
>   * published by the Free Software Foundation.
>   */
> +#include <linux/clk.h>
>  #include <linux/delay.h>
>  #include <linux/gpio.h>
>  #include <linux/i2c.h>
>  #include <linux/kernel.h>
>  #include <linux/media.h>
>  #include <linux/module.h>
> +#include <linux/of_gpio.h>
>  #include <linux/ratelimit.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
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
> @@ -511,10 +514,10 @@ static int ov965x_set_color_matrix(struct ov965x *ov965x)
>  	return 0;
>  }
>  
> -static void ov965x_gpio_set(int gpio, int val)
> +static void ov965x_gpio_set(struct gpio_desc *gpio, int val)
>  {
> -	if (gpio_is_valid(gpio))
> -		gpio_set_value(gpio, val);
> +	if (gpio)
> +		gpiod_set_value_cansleep(gpio, val);

gpiod_set_value_cansleep() can manage with NULL gpio parameter, no need to
check it.

>  }
>  
>  static void __ov965x_set_power(struct ov965x *ov965x, int on)
> @@ -1406,24 +1409,28 @@ static int ov965x_configure_gpios(struct ov965x *ov965x,
>  				  const struct ov9650_platform_data *pdata)
>  {
>  	int ret, i;
> +	int gpios[NUM_GPIOS];
>  
> -	ov965x->gpios[GPIO_PWDN] = pdata->gpio_pwdn;
> -	ov965x->gpios[GPIO_RST]  = pdata->gpio_reset;
> +	gpios[GPIO_PWDN] = pdata->gpio_pwdn;
> +	gpios[GPIO_RST]  = pdata->gpio_reset;
>  
> -	for (i = 0; i < ARRAY_SIZE(ov965x->gpios); i++) {
> -		int gpio = ov965x->gpios[i];
> +	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
> +		int gpio = gpios[i];
>  
>  		if (!gpio_is_valid(gpio))
>  			continue;
>  		ret = devm_gpio_request_one(&ov965x->client->dev, gpio,
> -					    GPIOF_OUT_INIT_HIGH, "OV965X");
> -		if (ret < 0)
> +					    GPIOF_OUT_INIT_HIGH, DRIVER_NAME);

DRIVER_NAME is different from "OV965X". Is this an intended change?

> +		if (ret < 0) {
> +			dev_err(&ov965x->client->dev,
> +				"Failed to request gpio%d (%d)\n", gpio, ret);
>  			return ret;
> +		}
>  		v4l2_dbg(1, debug, &ov965x->sd, "set gpio %d to 1\n", gpio);
>  
>  		gpio_set_value(gpio, 1);
>  		gpio_export(gpio, 0);
> -		ov965x->gpios[i] = gpio;
> +		ov965x->gpios[i] = gpio_to_desc(gpio);
>  	}
>  
>  	return 0;
> @@ -1469,14 +1476,10 @@ static int ov965x_probe(struct i2c_client *client,
>  	struct v4l2_subdev *sd;
>  	struct ov965x *ov965x;
>  	int ret;
> +	struct device_node *np = client->dev.of_node;

It'd be nice to declare this next to pdata, rather than after ret and other
short declarations.

>  
> -	if (pdata == NULL) {
> -		dev_err(&client->dev, "platform data not specified\n");
> -		return -EINVAL;
> -	}
> -
> -	if (pdata->mclk_frequency == 0) {
> -		dev_err(&client->dev, "MCLK frequency not specified\n");
> +	if (!pdata && !np) {
> +		dev_err(&client->dev, "Platform data or device tree data must be provided\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1486,7 +1489,35 @@ static int ov965x_probe(struct i2c_client *client,
>  
>  	mutex_init(&ov965x->lock);
>  	ov965x->client = client;
> -	ov965x->mclk_frequency = pdata->mclk_frequency;
> +	mutex_init(&ov965x->lock);
> +
> +	if (np) {
> +		/* Device tree */
> +		ov965x->gpios[GPIO_RST] =
> +			devm_gpiod_get_optional(&client->dev, "resetb",
> +						GPIOD_OUT_LOW);
> +		ov965x->gpios[GPIO_PWDN] =
> +			devm_gpiod_get_optional(&client->dev, "pwdn",
> +						GPIOD_OUT_HIGH);
> +
> +		ov965x->clk = devm_clk_get(&client->dev, NULL);
> +		if (IS_ERR(ov965x->clk)) {
> +			dev_err(&client->dev, "Could not get clock\n");

mutex_destroy() should called on an initialised mutex if probe is going to
fail. It's certainly not a problem introduced by this patch, but it'd be
nice to fix that (in a separate patch) now that it's found. The same goes
for remove below.

> +			return PTR_ERR(ov965x->clk);
> +		}
> +		ov965x->mclk_frequency = clk_get_rate(ov965x->clk);
> +	} else {
> +		/* Platform data */
> +		ret = ov965x_configure_gpios(ov965x, pdata);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (pdata->mclk_frequency == 0) {
> +			dev_err(&client->dev, "MCLK frequency is mandatory\n");
> +			return -EINVAL;
> +		}
> +		ov965x->mclk_frequency = pdata->mclk_frequency;
> +	}
>  
>  	sd = &ov965x->sd;
>  	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
> @@ -1551,9 +1582,17 @@ static int ov965x_remove(struct i2c_client *client)
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
> +		.of_match_table = of_match_ptr(ov965x_of_match),
>  	},
>  	.probe		= ov965x_probe,
>  	.remove		= ov965x_remove,

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
