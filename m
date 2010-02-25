Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:60327 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934206Ab0BYWNJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2010 17:13:09 -0500
Date: Thu, 25 Feb 2010 14:14:07 -0800
From: Tony Lindgren <tony@atomide.com>
To: hvaibhav@ti.com
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	hverkuil@xs4all.nl
Subject: Re: [PATCH-V6 2/2] OMAP2/3: Add V4L2 DSS driver support in device.c
Message-ID: <20100225221407.GM28173@atomide.com>
References: <hvaibhav@ti.com>
 <1266917239-7094-3-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266917239-7094-3-git-send-email-hvaibhav@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* hvaibhav@ti.com <hvaibhav@ti.com> [100223 01:25]:
> From: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> 
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> ---
>  arch/arm/plat-omap/devices.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-omap/devices.c b/arch/arm/plat-omap/devices.c
> index 30b5db7..64f2a3a 100644
> --- a/arch/arm/plat-omap/devices.c
> +++ b/arch/arm/plat-omap/devices.c
> @@ -357,6 +357,34 @@ static void omap_init_wdt(void)
>  static inline void omap_init_wdt(void) {}
>  #endif
> 
> +/*---------------------------------------------------------------------------*/
> +
> +#if defined(CONFIG_VIDEO_OMAP2_VOUT) || \
> +	defined(CONFIG_VIDEO_OMAP2_VOUT_MODULE)
> +#if defined (CONFIG_FB_OMAP2) || defined (CONFIG_FB_OMAP2_MODULE)
> +static struct resource omap_vout_resource[3 - CONFIG_FB_OMAP2_NUM_FBS] = {
> +};
> +#else
> +static struct resource omap_vout_resource[2] = {
> +};
> +#endif
> +
> +static struct platform_device omap_vout_device = {
> +	.name		= "omap_vout",
> +	.num_resources	= ARRAY_SIZE(omap_vout_resource),
> +	.resource 	= &omap_vout_resource[0],
> +	.id		= -1,
> +};
> +static void omap_init_vout(void)
> +{
> +	(void) platform_device_register(&omap_vout_device);
> +}

Allocation can still fail here, please handle the results.

> +#else
> +static inline void omap_init_vout(void) {}
> +#endif
> +
> +/*---------------------------------------------------------------------------*/
> +
>  /*
>   * This gets called after board-specific INIT_MACHINE, and initializes most
>   * on-chip peripherals accessible on this board (except for few like USB):
> @@ -387,6 +415,7 @@ static int __init omap_init_devices(void)
>  	omap_init_rng();
>  	omap_init_uwire();
>  	omap_init_wdt();
> +	omap_init_vout();
>  	return 0;
>  }
>  arch_initcall(omap_init_devices);

Looks like this should be in mach-omap2/devices.c instead if it's all
omap2/3/4 specific.

Regards,

Tony
