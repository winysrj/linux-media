Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52696
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751190AbdFGP2q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 11:28:46 -0400
Date: Wed, 7 Jun 2017 12:28:34 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kevin Hilman <khilman@baylibre.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 4/4] [media] davinci: vpif: adaptions for DT support
Message-ID: <20170607122834.4fcb92f4@vento.lan>
In-Reply-To: <20170606233741.26718-5-khilman@baylibre.com>
References: <20170606233741.26718-1-khilman@baylibre.com>
        <20170606233741.26718-5-khilman@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue,  6 Jun 2017 16:37:41 -0700
Kevin Hilman <khilman@baylibre.com> escreveu:

> The davinci VPIF is a single hardware block, but the existing driver
> is broken up into a common library (vpif.c), output (vpif_display.c) and
> intput (vpif_capture.c).
> 
> When migrating to DT, to better model the hardware, and because
> registers, interrupts, etc. are all common,it was decided to
> have a single VPIF hardware node[1].
> 
> Because davinci uses legacy, non-DT boot on several SoCs still, the
> platform_drivers need to remain.  But they are also needed in DT boot.
> Since there are no DT nodes for the display/capture parts in DT
> boot (there is a single node for the parent/common device) we need to
> create platform_devices somewhere to instansiate the platform_drivers.
> 
> When VPIF display/capture are needed for a DT boot, the VPIF node
> will have endpoints defined for its subdevs.  Therefore, vpif_probe()
> checks for the presence of endpoints, and if detected manually creates
> the platform_devices for the display and capture platform_drivers.
> 
> [1] Documentation/devicetree/bindings/media/ti,da850-vpif.txt
> 
> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
> ---
>  drivers/media/platform/davinci/vpif.c | 49 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
> index 1b02a6363f77..502917abcb13 100644
> --- a/drivers/media/platform/davinci/vpif.c
> +++ b/drivers/media/platform/davinci/vpif.c
> @@ -26,6 +26,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/spinlock.h>
>  #include <linux/v4l2-dv-timings.h>
> +#include <linux/of_graph.h>
>  
>  #include "vpif.h"
>  
> @@ -423,7 +424,9 @@ EXPORT_SYMBOL(vpif_channel_getfid);
>  
>  static int vpif_probe(struct platform_device *pdev)
>  {
> -	static struct resource	*res;
> +	static struct resource	*res, *res_irq;
> +	struct platform_device *pdev_capture, *pdev_display;
> +	struct device_node *endpoint = NULL;
>  
>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  	vpif_base = devm_ioremap_resource(&pdev->dev, res);
> @@ -435,6 +438,50 @@ static int vpif_probe(struct platform_device *pdev)
>  
>  	spin_lock_init(&vpif_lock);
>  	dev_info(&pdev->dev, "vpif probe success\n");
> +
> +	/*
> +	 * If VPIF Node has endpoints, assume "new" DT support,
> +	 * where capture and display drivers don't have DT nodes
> +	 * so their devices need to be registered manually here
> +	 * for their legacy platform_drivers to work.
> +	 */
> +	endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
> +					      endpoint);
> +	if (!endpoint) 
> +		return 0;
> +
> +	/*
> +	 * For DT platforms, manually create platform_devices for
> +	 * capture/display drivers.
> +	 */
> +	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res_irq) {
> +		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
> +		return -EINVAL;
> +	}
> +
> +	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
> +				    GFP_KERNEL);

You need to check if it won't return NULL here...

> +	pdev_capture->name = "vpif_capture";
> +	pdev_capture->id = -1;
> +	pdev_capture->resource = res_irq;
> +	pdev_capture->num_resources = 1;
> +	pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
> +	pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
> +	pdev_capture->dev.parent = &pdev->dev;
> +	platform_device_register(pdev_capture);
> +
> +	pdev_display = devm_kzalloc(&pdev->dev, sizeof(*pdev_display),
> +				    GFP_KERNEL);

and here.

Ok, in thesis, if size is lower than page size, it shouldn't fail,
but we still want to have an explicit check[1].

[1] https://lwn.net/Articles/723317/

Thanks,
Mauro
