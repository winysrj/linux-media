Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:34970 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbdFPRt3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Jun 2017 13:49:29 -0400
Received: by mail-pf0-f182.google.com with SMTP id l89so25517959pfi.2
        for <linux-media@vger.kernel.org>; Fri, 16 Jun 2017 10:49:28 -0700 (PDT)
From: Kevin Hilman <khilman@baylibre.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        David Lechner <david@lechnology.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Benoit Parrot <bparrot@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] [media] davinci: vpif: adaptions for DT support
References: <20170609161026.7582-1-khilman@baylibre.com>
        <20170616084309.GI12407@valkosipuli.retiisi.org.uk>
Date: Fri, 16 Jun 2017 10:49:24 -0700
In-Reply-To: <20170616084309.GI12407@valkosipuli.retiisi.org.uk> (Sakari
        Ailus's message of "Fri, 16 Jun 2017 11:43:09 +0300")
Message-ID: <m2vanvg6vv.fsf@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sakari Ailus <sakari.ailus@iki.fi> writes:

> Hi Kevin,
>
> On Fri, Jun 09, 2017 at 09:10:26AM -0700, Kevin Hilman wrote:
>> The davinci VPIF is a single hardware block, but the existing driver
>> is broken up into a common library (vpif.c), output (vpif_display.c) and
>> intput (vpif_capture.c).
>> 
>> When migrating to DT, to better model the hardware, and because
>> registers, interrupts, etc. are all common,it was decided to
>> have a single VPIF hardware node[1].
>> 
>> Because davinci uses legacy, non-DT boot on several SoCs still, the
>> platform_drivers need to remain.  But they are also needed in DT boot.
>> Since there are no DT nodes for the display/capture parts in DT
>> boot (there is a single node for the parent/common device) we need to
>> create platform_devices somewhere to instansiate the platform_drivers.
>> 
>> When VPIF display/capture are needed for a DT boot, the VPIF node
>> will have endpoints defined for its subdevs.  Therefore, vpif_probe()
>> checks for the presence of endpoints, and if detected manually creates
>> the platform_devices for the display and capture platform_drivers.
>> 
>> [1] Documentation/devicetree/bindings/media/ti,da850-vpif.txt
>> 
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> ---
>> Changes since v1:
>> - added proper error checking to kzalloc calls
>> - rebased onto media/master
>> 
>>  drivers/media/platform/davinci/vpif.c | 57 ++++++++++++++++++++++++++++++++++-
>>  1 file changed, 56 insertions(+), 1 deletion(-)
>> 
>> diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
>> index 1b02a6363f77..c2d214dfaa3e 100644
>> --- a/drivers/media/platform/davinci/vpif.c
>> +++ b/drivers/media/platform/davinci/vpif.c
>> @@ -26,6 +26,7 @@
>>  #include <linux/pm_runtime.h>
>>  #include <linux/spinlock.h>
>>  #include <linux/v4l2-dv-timings.h>
>> +#include <linux/of_graph.h>
>>  
>>  #include "vpif.h"
>>  
>> @@ -423,7 +424,9 @@ EXPORT_SYMBOL(vpif_channel_getfid);
>>  
>>  static int vpif_probe(struct platform_device *pdev)
>>  {
>> -	static struct resource	*res;
>> +	static struct resource	*res, *res_irq;
>> +	struct platform_device *pdev_capture, *pdev_display;
>> +	struct device_node *endpoint = NULL;
>>  
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>  	vpif_base = devm_ioremap_resource(&pdev->dev, res);
>> @@ -435,6 +438,58 @@ static int vpif_probe(struct platform_device *pdev)
>>  
>>  	spin_lock_init(&vpif_lock);
>>  	dev_info(&pdev->dev, "vpif probe success\n");
>> +
>> +	/*
>> +	 * If VPIF Node has endpoints, assume "new" DT support,
>> +	 * where capture and display drivers don't have DT nodes
>> +	 * so their devices need to be registered manually here
>> +	 * for their legacy platform_drivers to work.
>> +	 */
>> +	endpoint = of_graph_get_next_endpoint(pdev->dev.of_node,
>> +					      endpoint);
>> +	if (!endpoint) 
>> +		return 0;
>> +
>> +	/*
>> +	 * For DT platforms, manually create platform_devices for
>> +	 * capture/display drivers.
>> +	 */
>> +	res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>> +	if (!res_irq) {
>> +		dev_warn(&pdev->dev, "Missing IRQ resource.\n");
>> +		return -EINVAL;
>> +	}
>> +
>> +	pdev_capture = devm_kzalloc(&pdev->dev, sizeof(*pdev_capture),
>> +				    GFP_KERNEL);
>> +	if (pdev_capture) {
>> +		pdev_capture->name = "vpif_capture";
>> +		pdev_capture->id = -1;
>> +		pdev_capture->resource = res_irq;
>> +		pdev_capture->num_resources = 1;
>> +		pdev_capture->dev.dma_mask = pdev->dev.dma_mask;
>> +		pdev_capture->dev.coherent_dma_mask = pdev->dev.coherent_dma_mask;
>> +		pdev_capture->dev.parent = &pdev->dev;
>> +		platform_device_register(pdev_capture);
>
> Don't both of these (vpif_capture and vpif_display) depend on platform data?
> Or do I miss something?

The driver can (continue to) work in legacy mode with platform_data.  In
that case, there is no VPIF DT node (or a node without endpoints).

However, with recent changes, it can also work in DT mode, where the
VPIF node and endpoints used for display/capture come from DT, in which
case these nodes are created an don't depend on platform_data at all.

Hope that clarifies things, and thanks for the review,

Kevin
