Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47113 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaCRNe4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Mar 2014 09:34:56 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Josh Wu <josh.wu@atmel.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	m.chehab@samsung.com, nicolas.ferre@atmel.com,
	linux-arm-kernel@lists.infradead.org, grant.likely@linaro.org,
	galak@codeaurora.org, rob@landley.net, mark.rutland@arm.com,
	robh+dt@kernel.org, ijc+devicetree@hellion.org.uk,
	pawel.moll@arm.com, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] [media] atmel-isi: add primary DT support
Date: Tue, 18 Mar 2014 14:36:40 +0100
Message-ID: <2118978.g8dAYX7V8K@avalon>
In-Reply-To: <1395141594-6065-1-git-send-email-josh.wu@atmel.com>
References: <1395141238-5948-1-git-send-email-josh.wu@atmel.com> <1395141594-6065-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

Thank you for the patch.

On Tuesday 18 March 2014 19:19:54 Josh Wu wrote:
> This patch add the DT support for Atmel ISI driver.
> It use the same v4l2 DT interface that defined in video-interfaces.txt.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Cc: devicetree@vger.kernel.org
> ---
>  .../devicetree/bindings/media/atmel-isi.txt        |   51 +++++++++++++++++
>  drivers/media/platform/soc_camera/atmel-isi.c      |   33 ++++++++++++-
>  2 files changed, 82 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/atmel-isi.txt
> b/Documentation/devicetree/bindings/media/atmel-isi.txt new file mode
> 100644
> index 0000000..07f00eb
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/atmel-isi.txt
> @@ -0,0 +1,51 @@
> +Atmel Image Sensor Interface (ISI) SoC Camera Subsystem
> +----------------------------------------------
> +
> +Required properties:
> +- compatible: must be "atmel,at91sam9g45-isi"
> +- reg: physical base address and length of the registers set for the
> device;
> +- interrupts: should contain IRQ line for the ISI;
> +- clocks: list of clock specifiers, corresponding to entries in
> +          the clock-names property;
> +- clock-names: must contain "isi_clk", which is the isi peripherial clock.
> +               "isi_mck" is optinal, it is the master clock output to
> sensor.

The mck clock should be handled by the sensor driver instead. I know we have a 
legacy mode in the atmel-isi driver to manage that clock internally, but let's 
not propagate that to DT. I would also drop the "isi_" prefix from the isi_clk 
name.

You should also describe the port node. You can just mention the related 
bindings document, and state that the ISI has a single port.

> +Optional properties:
> +- atmel,isi-disable-preview: a boolean property to disable the preview
> channel;

That doesn't really sound like a hardware property to me. Isn't it full mode 
related to software configuration instead, which should be performed at 
runtime by userspace ?

> +
> +Example:
> +	isi: isi@f0034000 {
> +		compatible = "atmel,at91sam9g45-isi";
> +		reg = <0xf0034000 0x4000>;
> +		interrupts = <37 IRQ_TYPE_LEVEL_HIGH 5>;
> +
> +		clocks = <&isi_clk>, <&pck1>;
> +		clock-names = "isi_clk", "isi_mck";
> +
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&pinctrl_isi &pinctrl_pck1_as_isi_mck>;
> +
> +		port {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			isi_0: endpoint {
> +				remote-endpoint = <&ov2640_0>;
> +			};
> +		};
> +	};
> +
> +	i2c1: i2c@f0018000 {
> +		ov2640: camera@0x30 {
> +			compatible = "omnivision,ov2640";
> +			reg = <0x30>;
> +
> +			port {
> +				ov2640_0: endpoint {
> +					remote-endpoint = <&isi_0>;
> +					bus-width = <8>;
> +				};
> +			};
> +		};
> +	};
> +
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c
> b/drivers/media/platform/soc_camera/atmel-isi.c index 93bf1cb..1822129
> 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -19,6 +19,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> 
> @@ -33,6 +34,7 @@
>  #define VID_LIMIT_BYTES			(16 * 1024 * 1024)
>  #define MIN_FRAME_RATE			15
>  #define FRAME_INTERVAL_MILLI_SEC	(1000 / MIN_FRAME_RATE)
> +#define ISI_DEFAULT_MCLK_FREQ		25000000
> 
>  /* Frame buffer descriptor */
>  struct fbd {
> @@ -878,6 +880,22 @@ static int atmel_isi_remove(struct platform_device
> *pdev) return 0;
>  }
> 
> +static int atmel_isi_probe_dt(struct atmel_isi *isi,
> +			struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +
> +	isi->pdata.full_mode = !of_property_read_bool(node,
> +			"atmel,isi-disable-preview");
> +
> +	/* Default settings for ISI */
> +	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
> +	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;
> +	isi->pdata.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10;
> +
> +	return 0;
> +}
> +
>  static int atmel_isi_probe(struct platform_device *pdev)
>  {
>  	unsigned int irq;
> @@ -889,7 +907,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
> struct isi_platform_data *pdata;
> 
>  	pdata = dev->platform_data;
> -	if (!pdata || !pdata->data_width_flags) {
> +	if ((!pdata || !pdata->data_width_flags) && !pdev->dev.of_node) {
>  		dev_err(&pdev->dev,
>  			"No config available for Atmel ISI\n");
>  		return -EINVAL;
> @@ -905,7 +923,11 @@ static int atmel_isi_probe(struct platform_device
> *pdev) if (IS_ERR(isi->pclk))
>  		return PTR_ERR(isi->pclk);
> 
> -	memcpy(&isi->pdata, pdata, sizeof(struct isi_platform_data));
> +	if (pdata)
> +		memcpy(&isi->pdata, pdata, sizeof(struct isi_platform_data));
> +	else	/* dt probe */
> +		atmel_isi_probe_dt(isi, pdev);
> +
>  	isi->active = NULL;
>  	spin_lock_init(&isi->lock);
>  	INIT_LIST_HEAD(&isi->video_buffer_list);
> @@ -1007,11 +1029,18 @@ err_alloc_ctx:
>  	return ret;
>  }
> 
> +static const struct of_device_id atmel_isi_of_match[] = {
> +	{ .compatible = "atmel,at91sam9g45-isi" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, atmel_isi_of_match);
> +
>  static struct platform_driver atmel_isi_driver = {
>  	.remove		= atmel_isi_remove,
>  	.driver		= {
>  		.name = "atmel_isi",
>  		.owner = THIS_MODULE,
> +		.of_match_table = atmel_isi_of_match,
>  	},
>  };

-- 
Regards,

Laurent Pinchart

