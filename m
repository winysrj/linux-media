Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21277 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752388AbaEMRJe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 May 2014 13:09:34 -0400
Message-id: <537251CA.3070005@samsung.com>
Date: Tue, 13 May 2014 19:09:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Shawn Guo <shawn.guo@freescale.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH 3/3] media: mx2-emmaprp: Add devicetree support
References: <1399015119-24000-1-git-send-email-shc_work@mail.ru>
In-reply-to: <1399015119-24000-1-git-send-email-shc_work@mail.ru>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 02/05/14 09:18, Alexander Shiyan wrote:
> This patch adds devicetree support for the Freescale enhanced Multimedia
> Accelerator (eMMA) video Pre-processor (PrP).
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  .../devicetree/bindings/media/fsl-imx-emmaprp.txt     | 19 +++++++++++++++++++
>  drivers/media/platform/mx2_emmaprp.c                  |  8 ++++++++
>  2 files changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> new file mode 100644
> index 0000000..9e8238f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/fsl-imx-emmaprp.txt
> @@ -0,0 +1,19 @@
> +* Freescale enhanced Multimedia Accelerator (eMMA) video Pre-processor (PrP)
> +  for i.MX.
> +
> +Required properties:
> +- compatible : Shall contain "fsl,imx21-emmaprp".
> +- reg        : Offset and length of the register set for the device.
> +- interrupts : Should contain eMMA PrP interrupt number.
> +- clocks     : Should contain the ahb and ipg clocks, in the order
> +               determined by the clock-names property.
> +- clock-names: Should be "ahb", "ipg".
> +
> +Example:
> +	emmaprp: emmaprp@10026400 {
> +		compatible = "fsl,imx27-emmaprp", "fsl,imx21-emmaprp";

Is "fsl,imx27-emmaprp" compatible documented somewhere ?

> +		reg = <0x10026400 0x100>;
> +		interrupts = <51>;
> +		clocks = <&clks 49>, <&clks 68>;
> +		clock-names = "ipg", "ahb";
> +	};
> diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
> index fa8f7ca..0646bda 100644
> --- a/drivers/media/platform/mx2_emmaprp.c
> +++ b/drivers/media/platform/mx2_emmaprp.c
> @@ -18,6 +18,7 @@
>   */
>  #include <linux/module.h>
>  #include <linux/clk.h>
> +#include <linux/of.h>
>  #include <linux/slab.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> @@ -1005,12 +1006,19 @@ static int emmaprp_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static const struct of_device_id __maybe_unused emmaprp_dt_ids[] = {
> +	{ .compatible = "fsl,imx21-emmaprp", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, emmaprp_dt_ids);
> +
>  static struct platform_driver emmaprp_pdrv = {
>  	.probe		= emmaprp_probe,
>  	.remove		= emmaprp_remove,
>  	.driver		= {
>  		.name	= MEM2MEM_NAME,
>  		.owner	= THIS_MODULE,
> +		.of_match_table = of_match_ptr(emmaprp_dt_ids),
>  	},
>  };
>  module_platform_driver(emmaprp_pdrv);

I believe documentation and driver changes should be in separate patches.
Otherwise looks good.

-- 
Thanks,
Sylwester
