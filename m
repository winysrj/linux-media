Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50560 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3D2LfW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Apr 2013 07:35:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	Rob Landley <rob@landley.net>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] media: i2c: mt9p031: add OF support
Date: Mon, 29 Apr 2013 13:35:27 +0200
Message-ID: <3228007.esFOONCu9m@avalon>
In-Reply-To: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1367222401-26649-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

Thank you for the patch. Please see below for a couple of comments in addition 
to the ones I've just sent (in reply to Sascha's e-mail).

On Monday 29 April 2013 13:30:01 Prabhakar Lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add OF support for the mt9p031 sensor driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

[snip]

> ---
>  .../devicetree/bindings/media/i2c/mt9p031.txt      |   43 ++++++++++++++
>  drivers/media/i2c/mt9p031.c                        |   61 ++++++++++++++++-
>  2 files changed, 103 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt new file mode
> 100644
> index 0000000..b985e63
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/mt9p031.txt
> @@ -0,0 +1,43 @@
> +* Aptina 1/2.5-Inch 5Mp CMOS Digital Image Sensor
> +
> +The Aptina MT9P031 is a 1/2.5-inch CMOS active pixel digital image sensor
> +with an active imaging pixel array of 2592H x 1944V. It incorporates
> +sophisticated camera functions on-chip such as windowing, column and row
> +skip mode, and snapshot mode. It is programmable through a simple two-wire
> +serial interface.
> +The MT9P031 is a progressive-scan sensor that generates a stream of pixel
> +data at a constant frame rate. It uses an on-chip, phase-locked loop (PLL)
> +to generate all internal clocks from a single master input clock running
> +between 6 and 27 MHz. The maximum pixel rate is 96 Mp/s, corresponding to
> +a clock rate of 96 MHz.

Isn't this text (directly copied from the datasheet) under Aptina's copyright 
?

> +Required Properties :
> +- compatible : value should be either one among the following
> +	(a) "aptina,mt9p031-sensor" for mt9p031 sensor
> +	(b) "aptina,mt9p031m-sensor" for mt9p031m sensor
> +
> +- ext_freq: Input clock frequency.
> +
> +- target_freq:  Pixel clock frequency.
> +
> +Optional Properties :
> +-reset: Chip reset GPIO (If not specified defaults to -1)
> +
> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +	mt9p031@5d {
> +		compatible = "aptina,mt9p031-sensor";
> +		reg = <0x5d>;
> +
> +		port {
> +			mt9p031_1: endpoint {
> +				ext_freq = <6000000>;
> +				target_freq = <96000000>;
> +			};
> +		};
> +	};
> +	...
> +};
> \ No newline at end of file
> diff --git a/drivers/media/i2c/mt9p031.c b/drivers/media/i2c/mt9p031.c
> index 28cf95b..66078a6 100644
> --- a/drivers/media/i2c/mt9p031.c
> +++ b/drivers/media/i2c/mt9p031.c
> @@ -23,11 +23,13 @@
>  #include <linux/regulator/consumer.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> +#include <linux/of_device.h>
> 
>  #include <media/mt9p031.h>
>  #include <media/v4l2-chip-ident.h>
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
>  #include <media/v4l2-subdev.h>
> 
>  #include "aptina-pll.h"
> @@ -928,10 +930,66 @@ static const struct v4l2_subdev_internal_ops
> mt9p031_subdev_internal_ops = { * Driver initialization and probing
>   */
> 
> +#if defined(CONFIG_OF)
> +static const struct of_device_id mt9p031_of_match[] = {
> +	{.compatible = "aptina,mt9p031-sensor", },
> +	{.compatible = "aptina,mt9p031m-sensor", },

As you'll need to resubmit anyway, please add a space between '{' and '.'

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, mt9p031_of_match);
> +
> +static struct mt9p031_platform_data
> +	*mt9p031_get_pdata(struct i2c_client *client)
> +
> +{
> +	if (!client->dev.platform_data && client->dev.of_node) {
> +		struct device_node *np;
> +		struct mt9p031_platform_data *pdata;
> +		int ret;
> +
> +		np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +		if (!np)
> +			return NULL;
> +
> +		pdata = devm_kzalloc(&client->dev,
> +				     sizeof(struct mt9p031_platform_data),
> +				     GFP_KERNEL);
> +		if (!pdata) {
> +			pr_warn("mt9p031 failed allocate memeory\n");
> +			return NULL;
> +		}
> +		ret = of_property_read_u32(np, "reset", &pdata->reset);
> +		if (ret == -EINVAL)
> +			pdata->reset = -1;
> +		else if (ret == -ENODATA)
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "ext_freq", &pdata->ext_freq))
> +			return NULL;
> +
> +		if (of_property_read_u32(np, "target_freq",
> +					 &pdata->target_freq))
> +			return NULL;
> +
> +		return pdata;
> +	}
> +
> +	return NULL;
> +}
> +#else
> +#define mt9p031_of_match NULL
> +
> +static struct mt9p031_platform_data
> +	*mt9p031_get_pdata(struct i2c_client *client)
> +{
> +	return client->dev.platform_data;
> +}
> +#endif
> +
>  static int mt9p031_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *did)
>  {
> -	struct mt9p031_platform_data *pdata = client->dev.platform_data;
> +	struct mt9p031_platform_data *pdata = mt9p031_get_pdata(client);
>  	struct i2c_adapter *adapter = to_i2c_adapter(client->dev.parent);
>  	struct mt9p031 *mt9p031;
>  	unsigned int i;
> @@ -1072,6 +1130,7 @@ MODULE_DEVICE_TABLE(i2c, mt9p031_id);
> 
>  static struct i2c_driver mt9p031_i2c_driver = {
>  	.driver = {
> +		.of_match_table = mt9p031_of_match,

You can use the of_match_ptr() macro instead of defining mt9p031_of_match as 
NULL above.

>  		.name = "mt9p031",
>  	},
>  	.probe          = mt9p031_probe,
-- 
Regards,

Laurent Pinchart

