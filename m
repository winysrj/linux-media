Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8892 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab2GZOb2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 10:31:28 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M7R003GBV16LI10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jul 2012 15:31:54 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M7R00CL3V0CTD10@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 26 Jul 2012 15:31:25 +0100 (BST)
Message-id: <501154BC.5050505@samsung.com>
Date: Thu, 26 Jul 2012 16:31:24 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
Cc: linux-media@vger.kernel.org, sungchun.kang@samsung.com,
	khw0178.kim@samsung.com, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, sy0816.kang@samsung.com,
	posciak@google.com, alim.akhtar@gmail.com, prashanth.g@samsung.com,
	joshi@samsung.com, shaik.samsung@gmail.com
Subject: Re: [PATCH v3 3/5] media: gscaler: Add core functionality for the
 G-Scaler driver
References: <1343219191-3969-1-git-send-email-shaik.ameer@samsung.com>
 <1343219191-3969-4-git-send-email-shaik.ameer@samsung.com>
In-reply-to: <1343219191-3969-4-git-send-email-shaik.ameer@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

Thank you for addressing my comments.

On 07/25/2012 02:26 PM, Shaik Ameer Basha wrote:
> +static int gsc_probe(struct platform_device *pdev)
> +{
> +	struct gsc_dev *gsc;
> +	struct resource *res;
> +	struct gsc_driverdata *drv_data = gsc_get_drv_data(pdev);
> +	struct device *dev = &pdev->dev;
> +	int ret = 0;
> +
> +	gsc = devm_kzalloc(dev, sizeof(struct gsc_dev), GFP_KERNEL);
> +	if (!gsc)
> +		return -ENOMEM;
> +
> +	if (dev->of_node)
> +		gsc->id = of_alias_get_id(pdev->dev.of_node, "gsc");
> +	else
> +		gsc->id = pdev->id;
> +
> +	if (gsc->id < 0 || gsc->id >= drv_data->num_entities) {
> +		dev_err(dev, "Invalid platform device id: %d\n", gsc->id);
> +		return -EINVAL;
> +	}
> +
> +	pdev->id = gsc->id;
> +	gsc->variant = drv_data->variant[gsc->id];
> +	gsc->pdev = pdev;
> +	gsc->pdata = dev->platform_data;
> +
> +	init_waitqueue_head(&gsc->irq_queue);
> +	spin_lock_init(&gsc->slock);
> +	mutex_init(&gsc->lock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	gsc->regs = devm_request_and_ioremap(dev, res);
> +	if (!gsc->regs) {
> +		dev_err(dev, "failed to map registers\n");
> +		return -ENOENT;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if (!res) {
> +		dev_err(dev, "failed to get IRQ resource\n");
> +		return -ENXIO;
> +	}
> +
> +	ret = gsc_clk_get(gsc);
> +	if (ret)
> +		return ret;
> +
> +	ret = devm_request_irq(dev, res->start, gsc_irq_handler,
> +				0, pdev->name, gsc);

One more small note, this should be:

		0, dev_name(&pdev->dev), gsc);

Then it's easier to identify which interrupts come from which
gscaler instance.


Regards,
Sylwester
