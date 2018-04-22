Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-eopbgr20118.outbound.protection.outlook.com ([40.107.2.118]:4384
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753472AbeDVUC5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 22 Apr 2018 16:02:57 -0400
Subject: Re: [PATCH 3/8] drm: bridge: thc63lvd1024: Add support for LVDS mode
 map
To: Jacopo Mondi <jacopo+renesas@jmondi.org>, architt@codeaurora.org,
        a.hajda@samsung.com, Laurent.pinchart@ideasonboard.com,
        airlied@linux.ie
Cc: daniel@ffwll.ch, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
 <1524130269-32688-4-git-send-email-jacopo+renesas@jmondi.org>
From: Peter Rosin <peda@axentia.se>
Message-ID: <86c2d4c9-8079-9f25-f24a-58c7866a8274@axentia.se>
Date: Sun, 22 Apr 2018 22:02:51 +0200
MIME-Version: 1.0
In-Reply-To: <1524130269-32688-4-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2018-04-19 11:31, Jacopo Mondi wrote:
> The THC63LVD1024 LVDS to RGB bridge supports two different LVDS mapping
> modes, selectable by means of an external pin.
> 
> Add support for configurable LVDS input mapping modes, using the newly
> introduced support for bridge input image formats.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/gpu/drm/bridge/thc63lvd1024.c | 41 +++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/drivers/gpu/drm/bridge/thc63lvd1024.c b/drivers/gpu/drm/bridge/thc63lvd1024.c
> index 48527f8..a3071a1 100644
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
> +	}
> +
> +	switch (map) {
> +	case THC63_LVDS_MAP_MODE1:
> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA;
> +		break;
> +	case THC63_LVDS_MAP_MODE2:
> +		bus_fmt = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG;

Why do you assume rgb888/1x7x4 here? It might as well be rgb666/1x7x3
or rgb101010/1x7x5, no?

Cheers,
Peter

> +		break;
> +	default:
> +		dev_err(thc63->dev,
> +			"Invalid value for property \"thine,map\": %u\n", map);
> +		return -EINVAL;
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
>  	thc63->bridge.driver_private = thc63;
>  	thc63->bridge.of_node = pdev->dev.of_node;
>  	thc63->bridge.funcs = &thc63_bridge_func;
> 
