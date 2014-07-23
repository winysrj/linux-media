Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:50180 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbaGWKUH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 06:20:07 -0400
Date: Wed, 23 Jul 2014 12:20:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	magnus.damm@opensource.se, horms@verge.net.au,
	linux-kernel@lists.codethink.co.uk
Subject: Re: [PATCH 3/6] rcar_vin: add devicetree support
In-Reply-To: <1404599185-12353-4-git-send-email-ben.dooks@codethink.co.uk>
Message-ID: <Pine.LNX.4.64.1407230944550.30243@axis700.grange>
References: <1404599185-12353-1-git-send-email-ben.dooks@codethink.co.uk>
 <1404599185-12353-4-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ben,

I'd love to push this for 3.17, but we have to at least show this to DT 
maintainers... Personally, I have one remark:

On Sat, 5 Jul 2014, Ben Dooks wrote:

> Add support for devicetree probe for the rcar-vin
> driver.
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  .../devicetree/bindings/media/rcar_vin.txt         | 86 ++++++++++++++++++++++
>  drivers/media/platform/soc_camera/rcar_vin.c       | 72 ++++++++++++++++--
>  2 files changed, 151 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/rcar_vin.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> new file mode 100644
> index 0000000..10fefa9
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -0,0 +1,86 @@
> +Renesas RCar Video Input driver (rcar_vin)
> +------------------------------------------
> +
> +The rcar_vin device provides video input capabilities for the Renesas R-Car
> +family of devices. The current blocks are always slaves and suppot one input
> +channel which can be either RGB, YUYV or BT656.
> +
> + - compatible: Must be one of the following
> +   - "renesas,vin-r8a7791" for the R8A7791 device
> +   - "renesas,vin-r8a7790" for the R8A7790 device
> +   - "renesas,vin-r8a7779" for the R8A7779 device
> +   - "renesas,vin-r8a7778" for the R8A7778 device
> + - reg: the register base and size for the device registers
> + - interrupts: the interrupt for the device
> + - clocks: Reference to the parent clock
> +
> +Additionally, an alias named vinX will need to be created to specify
> +which video input device this is.
> +
> +The per-board settings:
> + - port sub-node describing a single endpoint connected to the vin
> +   as described in video-interfaces.txt[1]. Only the first one will
> +   be considered as each vin interface has one input port.
> +
> +   These settings are used to work out video input format and widths
> +   into the system.
> +
> +
> +Device node example
> +-------------------
> +
> +	aliases {
> +	       vin0 = &vin0;
> +	};
> +
> +        vin0: vin@0xe6ef0000 {
> +                compatible = "renesas,vin-r8a7790";
> +                clocks = <&mstp8_clks R8A7790_CLK_VIN0>;
> +                reg = <0 0xe6ef0000 0 0x1000>;
> +                interrupts = <0 188 IRQ_TYPE_LEVEL_HIGH>;
> +                status = "disabled";
> +        };
> +
> +Board setup example (vin1 composite video input)
> +------------------------------------------------
> +
> +&i2c2   {
> +        status = "ok";
> +        pinctrl-0 = <&i2c2_pins>;
> +        pinctrl-names = "default";
> +
> +        adv7180@020 {

The above should be

> +        adv7180@20 {

no "0" in the I2C address. 020 looks like an octal number, which it isn't. 
I'll fix this and try to resubmit today with extended Cc.

Thanks
Guennadi

> +                compatible = "adi,adv7180";
> +                reg = <0x20>;
> +                remote = <&vin1>;
> +
> +                port {
> +                        adv7180: endpoint {
> +                                bus-width = <8>;
> +                                remote-endpoint = <&vin1ep0>;
> +                        };
> +                };
> +        };
> +};
> +
> +/* composite video input */
> +&vin1 {
> +        pinctrl-0 = <&vin1_pins>;
> +        pinctrl-names = "default";
> +
> +        status = "ok";
> +
> +        port {
> +                #address-cells = <1>;
> +                #size-cells = <0>;
> +
> +                vin1ep0: endpoint {
> +                        remote-endpoint = <&adv7180>;
> +                        bus-width = <8>;
> +                };
> +        };
> +};
> +
> +
> +
> +[1] video-interfaces.txt common video media interface
> diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/platform/soc_camera/rcar_vin.c
> index 7c4299d..eb196ef 100644
> --- a/drivers/media/platform/soc_camera/rcar_vin.c
> +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> @@ -24,6 +24,8 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #include <media/soc_camera.h>
>  #include <media/soc_mediabus.h>
> @@ -32,6 +34,7 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-mediabus.h>
>  #include <media/v4l2-subdev.h>
> +#include <media/v4l2-of.h>
>  #include <media/videobuf2-dma-contig.h>
>  
>  #include "soc_scale_crop.h"
> @@ -1390,6 +1393,17 @@ static struct soc_camera_host_ops rcar_vin_host_ops = {
>  	.init_videobuf2	= rcar_vin_init_videobuf2,
>  };
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id rcar_vin_of_table[] = {
> +	{ .compatible = "renesas,vin-r8a7791", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7790", .data = (void *)RCAR_GEN2 },
> +	{ .compatible = "renesas,vin-r8a7779", .data = (void *)RCAR_H1 },
> +	{ .compatible = "renesas,vin-r8a7778", .data = (void *)RCAR_M1 },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, rcar_vin_of_table);
> +#endif
> +
>  static struct platform_device_id rcar_vin_id_table[] = {
>  	{ "r8a7791-vin",  RCAR_GEN2 },
>  	{ "r8a7790-vin",  RCAR_GEN2 },
> @@ -1402,15 +1416,52 @@ MODULE_DEVICE_TABLE(platform, rcar_vin_id_table);
>  
>  static int rcar_vin_probe(struct platform_device *pdev)
>  {
> +	const struct of_device_id *match = NULL;
>  	struct rcar_vin_priv *priv;
>  	struct resource *mem;
>  	struct rcar_vin_platform_data *pdata;
> +	unsigned int pdata_flags;
>  	int irq, ret;
>  
> -	pdata = pdev->dev.platform_data;
> -	if (!pdata || !pdata->flags) {
> -		dev_err(&pdev->dev, "platform data not set\n");
> -		return -EINVAL;
> +	if (pdev->dev.of_node) {
> +		struct v4l2_of_endpoint ep;
> +		struct device_node *np;
> +
> +		match = of_match_device(of_match_ptr(rcar_vin_of_table),
> +					&pdev->dev);
> +
> +		np = of_graph_get_next_endpoint(pdev->dev.of_node, NULL);
> +		if (!np) {
> +			dev_err(&pdev->dev, "could not find endpoint\n");
> +			return -EINVAL;
> +		}
> +
> +		ret = v4l2_of_parse_endpoint(np, &ep);
> +		if (ret) {
> +			dev_err(&pdev->dev, "could not parse endpoint\n");
> +			return ret;
> +		}
> +
> +		if (ep.bus_type == V4L2_MBUS_BT656)
> +			pdata_flags = RCAR_VIN_BT656;
> +		else {
> +			pdata_flags = 0;
> +			if (ep.bus.parallel.flags & V4L2_MBUS_HSYNC_ACTIVE_LOW)
> +				pdata_flags |= RCAR_VIN_HSYNC_ACTIVE_LOW;
> +			if (ep.bus.parallel.flags & V4L2_MBUS_VSYNC_ACTIVE_LOW)
> +				pdata_flags |= RCAR_VIN_VSYNC_ACTIVE_LOW;
> +		}
> +
> +		of_node_put(np);
> +
> +		dev_dbg(&pdev->dev, "pdata_flags = %08x\n", pdata_flags);
> +	} else {
> +		pdata = pdev->dev.platform_data;
> +		if (!pdata || !pdata->flags) {
> +			dev_err(&pdev->dev, "platform data not set\n");
> +			return -EINVAL;
> +		}
> +		pdata_flags = pdata->flags;
>  	}
>  
>  	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> @@ -1441,12 +1492,18 @@ static int rcar_vin_probe(struct platform_device *pdev)
>  
>  	priv->ici.priv = priv;
>  	priv->ici.v4l2_dev.dev = &pdev->dev;
> -	priv->ici.nr = pdev->id;
>  	priv->ici.drv_name = dev_name(&pdev->dev);
>  	priv->ici.ops = &rcar_vin_host_ops;
>  
> -	priv->pdata_flags = pdata->flags;
> -	priv->chip = pdev->id_entry->driver_data;
> +	priv->pdata_flags = pdata_flags;
> +	if (!match) {
> +		priv->ici.nr = pdev->id;
> +		priv->chip = pdev->id_entry->driver_data;
> +	} else {
> +		priv->ici.nr = of_alias_get_id(pdev->dev.of_node, "vin");
> +		priv->chip = (enum chip_id)match->data;
> +	};
> +
>  	spin_lock_init(&priv->lock);
>  	INIT_LIST_HEAD(&priv->capture);
>  
> @@ -1487,6 +1544,7 @@ static struct platform_driver rcar_vin_driver = {
>  	.driver		= {
>  		.name		= DRV_NAME,
>  		.owner		= THIS_MODULE,
> +		.of_match_table	= of_match_ptr(rcar_vin_of_table),
>  	},
>  	.id_table	= rcar_vin_id_table,
>  };
> -- 
> 2.0.0
> 
