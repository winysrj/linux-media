Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37640 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751497AbcIULJ7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Sep 2016 07:09:59 -0400
Date: Wed, 21 Sep 2016 14:09:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Songjun Wu <songjun.wu@microchip.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 5/7] ov7670: add devicetree support
Message-ID: <20160921110918.GB18295@valkosipuli.retiisi.org.uk>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1471415383-38531-6-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Aug 17, 2016 at 08:29:41AM +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add DT support. Use it to get the reset and pwdn pins (if there are any).
> Tested with one sensor requiring reset/pwdn and one sensor that doesn't
> have reset/pwdn pins.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  .../devicetree/bindings/media/i2c/ov7670.txt       | 44 +++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  drivers/media/i2c/ov7670.c                         | 51 ++++++++++++++++++++++
>  3 files changed, 96 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov7670.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov7670.txt b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> new file mode 100644
> index 0000000..3231c47
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/ov7670.txt
> @@ -0,0 +1,44 @@
> +* Omnivision OV7670 CMOS sensor
> +
> +The Omnivision OV7670 sensor support multiple resolutions output, such as
> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
> +output format.
> +
> +Required Properties:
> +- compatible: should be "ovti,ov7670"
> +- clocks: reference to the xvclk input clock.
> +- clock-names: should be "xvclk".

Where does "xvclk" come from? Why not "xclk"?

> +
> +Optional Properties:
> +- resetb-gpios: reference to the GPIO connected to the resetb pin, if any.
> +- pwdn-gpios: reference to the GPIO connected to the pwdn pin, if any.
> +
> +The device node must contain one 'port' child node for its digital output
> +video port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c1: i2c@f0018000 {
> +		status = "okay";
> +
> +		ov7670: camera@0x21 {
> +			compatible = "ovti,ov7670";
> +			reg = <0x21>;
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&pinctrl_pck0_as_isi_mck &pinctrl_sensor_power &pinctrl_sensor_reset>;
> +			resetb-gpios = <&pioE 11 GPIO_ACTIVE_LOW>;
> +			pwdn-gpios = <&pioE 13 GPIO_ACTIVE_HIGH>;
> +			clocks = <&pck0>;
> +			clock-names = "xvclk";
> +			assigned-clocks = <&pck0>;
> +			assigned-clock-rates = <24000000>;

What's the difference between assigned-clocks and just clocks?

The example in video-interfaces.txt uses "clocks" and "clock-frequency" for
the purpose.

> +

How about the regulators? This sensor requires three. You probably have
fixed regulators there if things just work.

> +			port {
> +				ov7670_0: endpoint {
> +					remote-endpoint = <&isi_0>;
> +					bus-width = <8>;
> +				};
> +			};
> +		};
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 20bb1d0..1fec3a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8615,6 +8615,7 @@ L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/i2c/ov7670.c
> +F:	Documentation/devicetree/bindings/media/i2c/ov7670.txt
>  
>  ONENAND FLASH DRIVER
>  M:	Kyungmin Park <kyungmin.park@samsung.com>
> diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
> index 57adf3d..a401b99 100644
> --- a/drivers/media/i2c/ov7670.c
> +++ b/drivers/media/i2c/ov7670.c
> @@ -17,6 +17,9 @@
>  #include <linux/i2c.h>
>  #include <linux/delay.h>
>  #include <linux/videodev2.h>
> +#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
> +#include <linux/of_gpio.h>

You don't need at least of_gpio here. Probably linux/gpio.h is redundant as
well.

>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-clk.h>
> @@ -231,6 +234,8 @@ struct ov7670_info {
>  	};
>  	struct ov7670_format_struct *fmt;  /* Current format */
>  	struct v4l2_clk *clk;
> +	struct gpio_desc *resetb_gpio;
> +	struct gpio_desc *pwdn_gpio;
>  	int min_width;			/* Filter out smaller sizes */
>  	int min_height;			/* Filter out smaller sizes */
>  	int clock_speed;		/* External clock speed (MHz) */
> @@ -1551,6 +1556,40 @@ static const struct ov7670_devtype ov7670_devdata[] = {
>  	},
>  };
>  
> +static int ov7670_probe_dt(struct i2c_client *client,
> +		struct ov7670_info *info)
> +{
> +	/* Request the reset GPIO deasserted */
> +	info->resetb_gpio = devm_gpiod_get_optional(&client->dev, "resetb",
> +			GPIOD_OUT_LOW);
> +	if (!info->resetb_gpio)
> +		dev_dbg(&client->dev, "resetb gpio is not assigned!\n");

AFAIR the GPIO framework already complains vocally if the GPIO can't be
found.

> +	else if (IS_ERR(info->resetb_gpio)) {
> +		dev_info(&client->dev, "no resetb\n");
> +		return PTR_ERR(info->resetb_gpio);
> +	}
> +
> +	/* Request the power down GPIO asserted */
> +	info->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "pwdn",
> +			GPIOD_OUT_LOW);
> +	if (!info->pwdn_gpio)
> +		dev_dbg(&client->dev, "pwdn gpio is not assigned!\n");
> +	else if (IS_ERR(info->pwdn_gpio)) {
> +		dev_info(&client->dev, "no pwdn\n");
> +		return PTR_ERR(info->pwdn_gpio);
> +	}
> +
> +	if (info->resetb_gpio) {
> +		/* Active the resetb pin to perform a reset pulse */
> +		gpiod_direction_output(info->resetb_gpio, 1);
> +		usleep_range(3000, 5000);

Don't you typically do this when you power on the device rather than here?

> +		gpiod_direction_output(info->resetb_gpio, 0);
> +	}
> +	usleep_range(3000, 5000);
> +
> +	return 0;
> +}
> +
>  static int ov7670_probe(struct i2c_client *client,
>  			const struct i2c_device_id *id)
>  {
> @@ -1596,6 +1635,10 @@ static int ov7670_probe(struct i2c_client *client,
>  		return -EPROBE_DEFER;
>  	v4l2_clk_enable(info->clk);
>  
> +	ret = ov7670_probe_dt(client, info);

How did this use to work before this patch? :-)

> +	if (ret)
> +		return ret;
> +
>  	info->clock_speed = v4l2_clk_get_rate(info->clk) / 1000000;
>  	if (info->clock_speed < 12 ||
>  	    info->clock_speed > 48)
> @@ -1707,6 +1750,14 @@ static const struct i2c_device_id ov7670_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, ov7670_id);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ov7670_of_match[] = {
> +	{ .compatible = "ovti,ov7670", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, ov7670_of_match);
> +#endif
> +
>  static struct i2c_driver ov7670_driver = {
>  	.driver = {
>  		.name	= "ov7670",

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
