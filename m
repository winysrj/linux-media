Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:38522 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856AbaDHQ1C (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 12:27:02 -0400
Message-id: <53442352.5050809@samsung.com>
Date: Tue, 08 Apr 2014 18:26:58 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3 4/6] v4l: vsp1: Add DT support
References: <4542787.8JEGs6DclK@avalon>
 <1396973775-5690-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-reply-to: <1396973775-5690-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 08/04/14 18:16, Laurent Pinchart wrote:

It may be worth to split DT binding documentation and the driver changes
into separate patches, and perhaps add some commit description here.
Either way fell free to stick:

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>
> ---
>  .../devicetree/bindings/media/renesas,vsp1.txt     | 43 ++++++++++++++++++
>  drivers/media/platform/vsp1/vsp1_drv.c             | 52 ++++++++++++++++++----
>  2 files changed, 87 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/renesas,vsp1.txt
> 
> Hi,
> 
> This is the second last call (I'm perfectly aware of the logic flaw in this
> sentence, thank you :-)) for DT bindings review, with a small change to the
> bindings wording compared to v2. I plan to send a pull request at the end of
> the week.
> 
> Changes since v2:
> 
> - Remove the interrupt-parent property
> - Drop of_match_ptr() as the table is always compiled in
> 
> Changes since v1:
> 
> - Drop the clock-names property, as the VSP1 uses a single clock
> 
> diff --git a/Documentation/devicetree/bindings/media/renesas,vsp1.txt b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> new file mode 100644
> index 0000000..87fe08a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/renesas,vsp1.txt
> @@ -0,0 +1,43 @@
> +* Renesas VSP1 Video Processing Engine
> +
> +The VSP1 is a video processing engine that supports up-/down-scaling, alpha
> +blending, color space conversion and various other image processing features.
> +It can be found in the Renesas R-Car second generation SoCs.
> +
> +Required properties:
> +
> +  - compatible: Must contain "renesas,vsp1"
> +
> +  - reg: Base address and length of the registers block for the VSP1.
> +  - interrupts: VSP1 interrupt specifier.
> +  - clocks: A phandle + clock-specifier pair for the VSP1 functional clock.
> +
> +  - renesas,#rpf: Number of Read Pixel Formatter (RPF) modules in the VSP1.
> +  - renesas,#uds: Number of Up Down Scaler (UDS) modules in the VSP1.
> +  - renesas,#wpf: Number of Write Pixel Formatter (WPF) modules in the VSP1.
> +
> +
> +Optional properties:
> +
> +  - renesas,has-lif: Boolean, indicates that the LCD Interface (LIF) module is
> +    available.
> +  - renesas,has-lut: Boolean, indicates that the Look Up Table (LUT) module is
> +    available.
> +  - renesas,has-sru: Boolean, indicates that the Super Resolution Unit (SRU)
> +    module is available.
> +
> +
> +Example: R8A7790 (R-Car H2) VSP1-S node
> +
> +	vsp1@fe928000 {
> +		compatible = "renesas,vsp1";
> +		reg = <0 0xfe928000 0 0x8000>;
> +		interrupts = <0 267 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&mstp1_clks R8A7790_CLK_VSP1_S>;
> +
> +		renesas,has-lut;
> +		renesas,has-sru;
> +		renesas,#rpf = <5>;
> +		renesas,#uds = <3>;
> +		renesas,#wpf = <4>;
> +	};
> diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
> index 28e1de3..c69ee06 100644
> --- a/drivers/media/platform/vsp1/vsp1_drv.c
> +++ b/drivers/media/platform/vsp1/vsp1_drv.c
> @@ -16,6 +16,7 @@
>  #include <linux/device.h>
>  #include <linux/interrupt.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/videodev2.h>
>  
> @@ -431,34 +432,59 @@ static const struct dev_pm_ops vsp1_pm_ops = {
>   * Platform Driver
>   */
>  
> -static struct vsp1_platform_data *
> -vsp1_get_platform_data(struct platform_device *pdev)
> +static int vsp1_validate_platform_data(struct platform_device *pdev,
> +				       struct vsp1_platform_data *pdata)
>  {
> -	struct vsp1_platform_data *pdata = pdev->dev.platform_data;
> -
>  	if (pdata == NULL) {
>  		dev_err(&pdev->dev, "missing platform data\n");
> -		return NULL;
> +		return -EINVAL;
>  	}
>  
>  	if (pdata->rpf_count <= 0 || pdata->rpf_count > VPS1_MAX_RPF) {
>  		dev_err(&pdev->dev, "invalid number of RPF (%u)\n",
>  			pdata->rpf_count);
> -		return NULL;
> +		return -EINVAL;
>  	}
>  
>  	if (pdata->uds_count <= 0 || pdata->uds_count > VPS1_MAX_UDS) {
>  		dev_err(&pdev->dev, "invalid number of UDS (%u)\n",
>  			pdata->uds_count);
> -		return NULL;
> +		return -EINVAL;
>  	}
>  
>  	if (pdata->wpf_count <= 0 || pdata->wpf_count > VPS1_MAX_WPF) {
>  		dev_err(&pdev->dev, "invalid number of WPF (%u)\n",
>  			pdata->wpf_count);
> -		return NULL;
> +		return -EINVAL;
>  	}
>  
> +	return 0;
> +}
> +
> +static struct vsp1_platform_data *
> +vsp1_get_platform_data(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct vsp1_platform_data *pdata;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || np == NULL)
> +		return pdev->dev.platform_data;
> +
> +	pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (pdata == NULL)
> +		return NULL;
> +
> +	if (of_property_read_bool(np, "renesas,has-lif"))
> +		pdata->features |= VSP1_HAS_LIF;
> +	if (of_property_read_bool(np, "renesas,has-lut"))
> +		pdata->features |= VSP1_HAS_LUT;
> +	if (of_property_read_bool(np, "renesas,has-sru"))
> +		pdata->features |= VSP1_HAS_SRU;
> +
> +	of_property_read_u32(np, "renesas,#rpf", &pdata->rpf_count);
> +	of_property_read_u32(np, "renesas,#uds", &pdata->uds_count);
> +	of_property_read_u32(np, "renesas,#wpf", &pdata->wpf_count);
> +
>  	return pdata;
>  }
>  
> @@ -481,6 +507,10 @@ static int vsp1_probe(struct platform_device *pdev)
>  	if (vsp1->pdata == NULL)
>  		return -ENODEV;
>  
> +	ret = vsp1_validate_platform_data(pdev, vsp1->pdata);
> +	if (ret < 0)
> +		return ret;
> +
>  	/* I/O, IRQ and clock resources */
>  	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	vsp1->mmio = devm_ioremap_resource(&pdev->dev, io);
> @@ -527,6 +557,11 @@ static int vsp1_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id vsp1_of_match[] = {
> +	{ .compatible = "renesas,vsp1" },
> +	{ },
> +};
> +
>  static struct platform_driver vsp1_platform_driver = {
>  	.probe		= vsp1_probe,
>  	.remove		= vsp1_remove,
> @@ -534,6 +569,7 @@ static struct platform_driver vsp1_platform_driver = {
>  		.owner	= THIS_MODULE,
>  		.name	= "vsp1",
>  		.pm	= &vsp1_pm_ops,
> +		.of_match_table = vsp1_of_match,
>  	},
>  };

--
Regards,
Sylwester
