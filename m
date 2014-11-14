Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:17313 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161557AbaKNSp1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 13:45:27 -0500
Date: Fri, 14 Nov 2014 10:44:54 -0800
From: Tony Lindgren <tony@atomide.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>,
	David Cohen <dacohen@gmail.com>
Subject: Re: [PATCH 1/2] mach-omap2: remove deprecated VIDEO_OMAP2 support
Message-ID: <20141114184454.GY26481@atomide.com>
References: <1415956994-5240-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415956994-5240-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Hans Verkuil <hverkuil@xs4all.nl> [141114 01:25]:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The omap2 camera driver has been deprecated for a year and is now
> going to be removed. It is unmaintained and it uses an internal API
> that has long since been superseded by a much better API. Worse, that
> internal API has been abused by out-of-kernel trees (i.MX6).
> 
> In addition, Sakari stated that these drivers have never been in a
> usable state in the mainline kernel due to missing platform data.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Sakari Ailus <sakari.ailus@iki.fi>
> Cc: David Cohen <dacohen@gmail.com>

This applies with fuzz to what I have queued but should not
cause merge conflicts and should be safe to merge along with
other camera related patches:

Acked-by: Tony Lindgren <tony@atomide.com>

> ---
>  arch/arm/mach-omap2/devices.c | 31 -------------------------------
>  1 file changed, 31 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
> index 324f02b..1b623a0 100644
> --- a/arch/arm/mach-omap2/devices.c
> +++ b/arch/arm/mach-omap2/devices.c
> @@ -101,28 +101,6 @@ static int __init omap4_l3_init(void)
>  }
>  omap_postcore_initcall(omap4_l3_init);
>  
> -#if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
> -
> -static struct resource omap2cam_resources[] = {
> -	{
> -		.start		= OMAP24XX_CAMERA_BASE,
> -		.end		= OMAP24XX_CAMERA_BASE + 0xfff,
> -		.flags		= IORESOURCE_MEM,
> -	},
> -	{
> -		.start		= 24 + OMAP_INTC_START,
> -		.flags		= IORESOURCE_IRQ,
> -	}
> -};
> -
> -static struct platform_device omap2cam_device = {
> -	.name		= "omap24xxcam",
> -	.id		= -1,
> -	.num_resources	= ARRAY_SIZE(omap2cam_resources),
> -	.resource	= omap2cam_resources,
> -};
> -#endif
> -
>  #if defined(CONFIG_IOMMU_API)
>  
>  #include <linux/platform_data/iommu-omap.h>
> @@ -245,14 +223,6 @@ int omap3_init_camera(struct isp_platform_data *pdata)
>  
>  #endif
>  
> -static inline void omap_init_camera(void)
> -{
> -#if defined(CONFIG_VIDEO_OMAP2) || defined(CONFIG_VIDEO_OMAP2_MODULE)
> -	if (cpu_is_omap24xx())
> -		platform_device_register(&omap2cam_device);
> -#endif
> -}
> -
>  #if defined(CONFIG_OMAP2PLUS_MBOX) || defined(CONFIG_OMAP2PLUS_MBOX_MODULE)
>  static inline void __init omap_init_mbox(void)
>  {
> @@ -431,7 +401,6 @@ static int __init omap2_init_devices(void)
>  	 * in alphabetical order so they're easier to sort through.
>  	 */
>  	omap_init_audio();
> -	omap_init_camera();
>  	/* If dtb is there, the devices will be created dynamically */
>  	if (!of_have_populated_dt()) {
>  		omap_init_mbox();
> -- 
> 2.1.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
