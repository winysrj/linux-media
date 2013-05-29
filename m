Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53124 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280Ab3E2Db6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 23:31:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Grant Likely <grant.likely@secretlab.ca>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>, Arnd Bergmann <arnd@arndb.de>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] media: i2c: mt9p031: add OF support
Date: Wed, 29 May 2013 05:31:54 +0200
Message-ID: <8619949.XQMpgRNGdV@avalon>
In-Reply-To: <1369573734-19272-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1369573734-19272-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thanks for the patch.

On Sunday 26 May 2013 18:38:54 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the mt9p031 sensor driver.
> Alongside this patch sorts the header inclusion alphabetically.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: davinci-linux-open-source@linux.davincidsp.com
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And added to my tree with three small changes (please see below).

> ---
>  Changes for NON RFC v1:
>  1: added missing call for of_node_put().
> 
>  Changes for RFC v4 (https://patchwork.kernel.org/patch/2556251/):
>  1: Renamed "gpio-reset" property to "reset-gpios".
>  2: Dropped assigning the driver data from the of node.
> 
>  Changes for RFC v3(https://patchwork.kernel.org/patch/2515921/):
>  1: Dropped check if gpio-reset is valid.
>  2: Fixed some code nits.
>  3: Included a reference to the V4L2 DT bindings documentation.
> 
>  Changes for RFC v2 (https://patchwork.kernel.org/patch/2510201/):
>  1: Used '-' instead of '_' for device properties.
>  2: Specified gpio reset pin as phandle in device node.
>  3: Handle platform data properly even if kernel is compiled with
>     devicetree support.
>  4: Used dev_* for messages in drivers instead of pr_*.
>  5: Changed compatible property to "aptina,mt9p031" and "aptina,mt9p031m".
>  6: Sorted the header inclusion alphabetically and fixed some minor code
> nits.
> 
>  RFC v1: https://patchwork.kernel.org/patch/2498791/
> 
>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   40
> ++++++++++++++++++ drivers/media/i2c/mt9p031.c                        |  
> 43 +++++++++++++++++++- 2 files changed, 81 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt new file mode
> 100644
> index 0000000..59d613c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> @@ -0,0 +1,40 @@
> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
> +
> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor
> with +an active array size of 2592H x 1944V. It is programmable through a
> simple +two-wire serial interface.
> +
> +Required Properties :
> +- compatible : value should be either one among the following
> +	(a) "aptina,mt9p031" for mt9p031 sensor
> +	(b) "aptina,mt9p031m" for mt9p031m sensor
> +
> +- input-clock-frequency : Input clock frequency.
> +
> +- pixel-clock-frequency : Pixel clock frequency.
> +
> +Optional Properties :
> +- reset-gpios: Chip reset GPIO

There's usually no space before a colon in English.

> +For further reading of port node refer
> Documentation/devicetree/bindings/media/video-interfaces.txt.
> +
> +Example:
> +
> +	i2c0@1c22000 {
> +		...
> +		...
> +		mt9p031@5d {
> +			compatible = "aptina,mt9p031";
> +			reg = <0x5d>;
> +			reset-gpios = <&gpio3 30 0>;
> +
> +			port {
> +				mt9p031_1: endpoint {
> +					input-clock-frequency = <6000000>;
> +					pixel-clock-frequency = <96000000>;
> +				};
> +			};
> +		};
> +		...
> +	};
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index bf49899..bb1f993 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -16,9 +16,10 @@
>  #include <linux/delay.h>
>  #include <linux/device.h>
>  #include <linux/gpio.h>
> -#include <linux/module.h>
>  #include <linux/i2c.h>
>  #include <linux/log2.h>
> +#include <linux/module.h>
> +#include <linux/of_gpio.h>
>  #include <linux/pm.h>
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
> @@ -28,6 +29,7 @@
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
> 
>  #include "aptina-pll.h"
> @@ -928,10 +930,37 @@ static const struct v4l2_subdev_internal_ops
> mt9p031_subdev_internal_ops = { * Driver initialization and probing
>   */
> 
> +static struct mt9p031_platform_data *
> +mt9p031_get_pdata(struct i2c_client *client)
> +{
> +	struct mt9p031_platform_data *pdata = NULL;

No need to initialize pdata to NULL here.

> +	struct device_node *np;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!np)
> +		return NULL;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(struct mt9p031_platform_data),
> +			     GFP_KERNEL);

The preferred way to use sizeof in the kernel is sizeof(*var) instead of 
sizeof(type). I've thus replaced the above line with

	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);

> +	if (!pdata)
> +		goto done;
> +
> +	pdata->reset = of_get_named_gpio(client->dev.of_node, "reset-gpios", 0);
> +	of_property_read_u32(np, "input-clock-frequency", &pdata->ext_freq);
> +	of_property_read_u32(np, "pixel-clock-frequency", &pdata->target_freq);
> +
> +done:
> +	of_node_put(np);
> +	return pdata;
> +}
> +
>  static int mt9p031_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
> -	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> +	struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>  	struct mt9p031 *mt9p031;
>  	unsigned int i;
> @@ -1070,8 +1099,18 @@ static const struct i2c_device_id mt9p031_id[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, mt9p031_id);
> 
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id mt9p031_of_match[] = {
> +	{ .compatible = "aptina,mt9p031", },
> +	{ .compatible = "aptina,mt9p031m", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, mt9p031_of_match);
> +#endif
> +
>  static struct i2c_driver mt9p031_i2c_driver = {
>  	.driver = {
> +		.of_match_table = of_match_ptr(mt9p031_of_match),
>  		.name = "mt9p031",
>  	},
>  	.probe          = mt9p031_probe,
-- 
Regards,

Laurent Pinchart

