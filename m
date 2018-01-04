Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49955 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752486AbeADUlR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Jan 2018 15:41:17 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: magnus.damm@gmail.com, geert@glider.be, mchehab@kernel.org,
        hverkuil@xs4all.nl, festevam@gmail.com, sakari.ailus@iki.fi,
        robh+dt@kernel.org, mark.rutland@arm.com,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/9] v4l: platform: Add Renesas CEU driver
Date: Thu, 04 Jan 2018 22:41:40 +0200
Message-ID: <1661119.HFTSOmjBYx@avalon>
In-Reply-To: <1515081797-17174-4-git-send-email-jacopo+renesas@jmondi.org>
References: <1515081797-17174-1-git-send-email-jacopo+renesas@jmondi.org> <1515081797-17174-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patch.

On Thursday, 4 January 2018 18:03:11 EET Jacopo Mondi wrote:
> Add driver for Renesas Capture Engine Unit (CEU).
> 
> The CEU interface supports capturing 'data' (YUV422) and 'images'
> (NV[12|21|16|61]).
> 
> This driver aims to replace the soc_camera-based sh_mobile_ceu one.
> 
> Tested with ov7670 camera sensor, providing YUYV_2X8 data on Renesas RZ
> platform GR-Peach.
> 
> Tested with ov7725 camera sensor on SH4 platform Migo-R.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  drivers/media/platform/Kconfig       |    9 +
>  drivers/media/platform/Makefile      |    1 +
>  drivers/media/platform/renesas-ceu.c | 1649 +++++++++++++++++++++++++++++++
>  3 files changed, 1659 insertions(+)
>  create mode 100644 drivers/media/platform/renesas-ceu.c

[snip]

> diff --git a/drivers/media/platform/renesas-ceu.c
> b/drivers/media/platform/renesas-ceu.c new file mode 100644
> index 0000000..a614859
> --- /dev/null
> +++ b/drivers/media/platform/renesas-ceu.c

[snip]

> +/*
> + * struct ceu_data - Platform specific CEU data
> + * @irq_mask: CETCR mask with all interrupt sources enabled. The mask
> differs
> + *	      between SH4 and RZ platforms.
> + */
> +struct ceu_data {
> +	u32 irq_mask;
> +};
> +
> +const struct ceu_data ceu_data_rz = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_RZ,
> +};
> +
> +const struct ceu_data ceu_data_sh4 = {
> +	.irq_mask = CEU_CETCR_ALL_IRQS_SH4,
> +};

These two can be const.

> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id ceu_of_match[] = {
> +	{ .compatible = "renesas,r7s72100-ceu", .data = &ceu_data_rz },
> +	{ .compatible = "renesas,ceu", .data = &ceu_data_rz },

Do you need both ? What's your policy for compatible strings ? As far as I 
understand there's no generic CEU, as the SH4 and RZ versions are not 
compatible. Should the "renesas,ceu" compatible string then be replaced by 
"renesas,rz-ceu" and the first entry dropped ?

> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, ceu_of_match);
> +#endif
> +
> +static int ceu_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	const struct ceu_data *ceu_data;
> +	struct ceu_device *ceudev;
> +	struct resource *res;
> +	unsigned int irq;
> +	int num_subdevs;
> +	int ret;
> +
> +	ceudev = kzalloc(sizeof(*ceudev), GFP_KERNEL);
> +	if (!ceudev)
> +		return -ENOMEM;
> +
> +	platform_set_drvdata(pdev, ceudev);
> +	ceudev->dev = dev;
> +
> +	INIT_LIST_HEAD(&ceudev->capture);
> +	spin_lock_init(&ceudev->lock);
> +	mutex_init(&ceudev->mlock);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ceudev->base = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(ceudev->base))
> +		goto error_free_ceudev;
> +
> +	ret = platform_get_irq(pdev, 0);
> +	if (ret < 0) {
> +		dev_err(dev, "Failed to request irq: %d\n", ret);

s/request/get/ (it was correct in v2).

> +		goto error_free_ceudev;
> +	}
> +	irq = ret;
> +
> +	ret = devm_request_irq(dev, irq, ceu_irq,
> +			       0, dev_name(dev), ceudev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register CEU interrupt.\n");

s/register/request/ (this is the message that should have been changed).

> +		return ret;

You're leaking ceudev here.

> +	}
> +
> +	pm_runtime_enable(dev);
> +
> +	ret = v4l2_device_register(dev, &ceudev->v4l2_dev);
> +	if (ret)
> +		goto error_pm_disable;
> +
> +	if (IS_ENABLED(CONFIG_OF) && dev->of_node) {
> +		ceu_data = of_match_device(ceu_of_match, dev)->data;
> +		num_subdevs = ceu_parse_dt(ceudev);
> +	} else if (dev->platform_data) {
> +		/* Assume SH4 if booting with platform data. */
> +		ceu_data = &ceu_data_sh4;
> +		num_subdevs = ceu_parse_platform_data(ceudev,
> +						      dev->platform_data);
> +	} else {
> +		num_subdevs = -EINVAL;
> +	}
> +
> +	if (num_subdevs < 0) {
> +		ret = num_subdevs;
> +		goto error_v4l2_unregister;
> +	}
> +	ceudev->irq_mask = ceu_data->irq_mask;
> +
> +	ceudev->notifier.v4l2_dev	= &ceudev->v4l2_dev;
> +	ceudev->notifier.subdevs	= ceudev->asds;
> +	ceudev->notifier.num_subdevs	= num_subdevs;
> +	ceudev->notifier.ops		= &ceu_notify_ops;
> +	ret = v4l2_async_notifier_register(&ceudev->v4l2_dev,
> +					   &ceudev->notifier);
> +	if (ret)
> +		goto error_v4l2_unregister;
> +
> +	dev_info(dev, "Renesas Capture Engine Unit %s\n", dev_name(dev));
> +
> +	return 0;
> +
> +error_v4l2_unregister:
> +	v4l2_device_unregister(&ceudev->v4l2_dev);
> +error_pm_disable:
> +	pm_runtime_disable(dev);
> +error_free_ceudev:
> +	kfree(ceudev);
> +
> +	return ret;
> +}

-- 
Regards,

Laurent Pinchart
