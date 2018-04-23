Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:53024 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754756AbeDWMI2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:08:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: architt@codeaurora.org, a.hajda@samsung.com, airlied@linux.ie,
        daniel@ffwll.ch, peda@axentia.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] drm: bridge: thc63lvd1024: Add support for LVDS mode map
Date: Mon, 23 Apr 2018 15:08:39 +0300
Message-ID: <11465771.5tI9t3u2ch@avalon>
In-Reply-To: <1524130269-32688-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org> <1524130269-32688-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 19 April 2018 12:31:04 EEST Jacopo Mondi wrote:
> The THC63LVD1024 LVDS to RGB bridge supports two different LVDS mapping
> modes, selectable by means of an external pin.
> 
> Add support for configurable LVDS input mapping modes, using the newly
> introduced support for bridge input image formats.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> drivers/gpu/drm/bridge/thc63lvd1024.c | 41 +++++++++++++++++++++++++++++++++
> 1 file changed, 41 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/thc63lvd1024.c
> b/drivers/gpu/drm/bridge/thc63lvd1024.c index 48527f8..a3071a1 100644
> --- a/drivers/gpu/drm/bridge/thc63lvd1024.c
> +++ b/drivers/gpu/drm/bridge/thc63lvd1024.c
> @@ -10,9 +10,15 @@
>  #include <drm/drm_panel.h>
> 
>  #include <linux/gpio/consumer.h>
> +#include <linux/of.h>
>  #include <linux/of_graph.h>
>  #include <linux/regulator/consumer.h>
> 
> +enum thc63_lvds_mapping_mode {
> +	THC63_LVDS_MAP_MODE2,
> +	THC63_LVDS_MAP_MODE1,
> +};
> +
>  enum thc63_ports {
>  	THC63_LVDS_IN0,
>  	THC63_LVDS_IN1,
> @@ -116,6 +122,37 @@ static int thc63_parse_dt(struct thc63_dev *thc63)
>  	return 0;
>  }
> 
> +static int thc63_set_bus_fmt(struct thc63_dev *thc63)
> +{
> +	u32 bus_fmt;
> +	u32 map;
> +	int ret;
> +
> +	ret = of_property_read_u32(thc63->dev->of_node, "thine,map", &map);
> +	if (ret) {
> +		dev_err(thc63->dev,
> +			"Unable to parse property \"thine,map\": %d\n", ret);
> +		return ret;

Given that the property is currently not defined, I think you should select a 
default instead of returning an error to preserve backward compatibility. You 
can print a warning message to get the DT updated, maybe something like

	u32 map = 0;
	...

	ret = of_property_read_u32(thc63->dev->of_node, "thine,map", &map);
	if (ret)
		dev_warn(thc63->dev,
			 "Unable to parse thine,map property (%d), defaulting to 0\n",
			 ret);

> +	}
> +
> +	switch (map) {
> +	case THC63_LVDS_MAP_MODE1:
> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
> +		break;
> +	case THC63_LVDS_MAP_MODE2:
> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;
> +		break;
> +	default:
> +		dev_err(thc63->dev,
> +			"Invalid value for property \"thine,map\": %u\n", map);
> +		return -EINVAL;

This is fin as invalid property values should be rejected.

> +	}
> +
> +	drm_bridge_set_bus_formats(&thc63->bridge, &bus_fmt, 1);
> +
> +	return 0;
> +}
> +
>  static int thc63_gpio_init(struct thc63_dev *thc63)
>  {
>  	thc63->oe = devm_gpiod_get_optional(thc63->dev, "oe", GPIOD_OUT_LOW);
> @@ -166,6 +203,10 @@ static int thc63_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
> 
> +	ret = thc63_set_bus_fmt(thc63);
> +	if (ret)
> +		return ret;
> +

Or you could move the code to thc63_parse_dt() as you're parsing DT.

>  	thc63->bridge.driver_private = thc63;
>  	thc63->bridge.of_node = pdev->dev.of_node;
>  	thc63->bridge.funcs = &thc63_bridge_func;

-- 
Regards,

Laurent Pinchart
