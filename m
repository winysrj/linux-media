Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:56403 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0ALAWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 19:22:08 -0500
Received: by ywh6 with SMTP id 6so21992263ywh.4
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2010 16:22:08 -0800 (PST)
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH - v4 2/4] V4L-vpfe-capture-converting dm355 ccdc driver to a platform driver
References: <1263252977-27457-1-git-send-email-m-karicheri2@ti.com>
	<1263252977-27457-2-git-send-email-m-karicheri2@ti.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 11 Jan 2010 16:22:04 -0800
In-Reply-To: <1263252977-27457-2-git-send-email-m-karicheri2@ti.com> (m-karicheri2@ti.com's message of "Mon\, 11 Jan 2010 18\:36\:15 -0500")
Message-ID: <87aawkkw9f.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

m-karicheri2@ti.com writes:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Updated based on Kevin's comments on clock configuration.

This part belongs after the '---'

> The ccdc now uses a generic name for clocks. "master" and "slave". On individual platforms
> these clocks will inherit from the platform specific clock. This will allow re-use of
> the driver for the same IP across different SoCs.
>
> Following are the changes done:-
> 	1) clocks are configured using generic clock names
> 	2) converting the driver to a platform driver
> 	3) cleanup - consolidate all static variables inside a structure, ccdc_cfg
>
> Reviewed-by: Kevin Hilman <khilman@deeprootsystems.com>
> Reviewed-by: Vaibhav Hiremath <hvaibhav@ti.com>
> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Rebased to latest linux-next tree 
> Applies to linux-next branch of v4l-dvb
>  drivers/media/video/davinci/dm355_ccdc.c |  409 +++++++++++++++++++-----------
>  1 files changed, 256 insertions(+), 153 deletions(-)
>

[...]

> -static int __init dm355_ccdc_init(void)
> +static int __init dm355_ccdc_probe(struct platform_device *pdev)
>  {
> -	printk(KERN_NOTICE "dm355_ccdc_init\n");
> -	if (vpfe_register_ccdc_device(&ccdc_hw_dev) < 0)
> -		return -1;
> -	printk(KERN_NOTICE "%s is registered with vpfe.\n",
> -		ccdc_hw_dev.name);
> +	void (*setup_pinmux)(void);
> +	struct resource	*res;
> +	int status = 0;
> +
> +	/*
> +	 * first try to register with vpfe. If not correct platform, then we
> +	 * don't have to iomap
> +	 */
> +	status = vpfe_register_ccdc_device(&ccdc_hw_dev);
> +	if (status < 0)
> +		return status;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res) {
> +		status = -ENODEV;
> +		goto fail_nores;
> +	}
> +
> +	res = request_mem_region(res->start, resource_size(res), res->name);
> +	if (!res) {
> +		status = -EBUSY;
> +		goto fail_nores;
> +	}
> +
> +	ccdc_cfg.base_addr = ioremap_nocache(res->start, resource_size(res));
> +	if (!ccdc_cfg.base_addr) {
> +		status = -ENOMEM;
> +		goto fail_nomem;
> +	}
> +
> +	/* Get and enable Master clock */
> +	ccdc_cfg.mclk = clk_get(&pdev->dev, "master");
> +	if (NULL == ccdc_cfg.mclk) {

This should be an IS_ERR() check, not a NULL pointer check.

> +		status = -ENODEV;
> +		goto fail_nomap;
> +	}
> +	if (clk_enable(ccdc_cfg.mclk)) {
> +		status = -ENODEV;
> +		goto fail_mclk;
> +	}
> +
> +	/* Get and enable Slave clock */
> +	ccdc_cfg.sclk = clk_get(&pdev->dev, "slave");
> +	if (NULL == ccdc_cfg.sclk) {

IS_ERR()

All the same comments for the dm644x version.

Kevin
