Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54393 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754570AbdGNPJQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 14 Jul 2017 11:09:16 -0400
Subject: Re: [PATCH] [media] vimc: set id_table for platform drivers
To: Javier Martinez Canillas <javierm@redhat.com>,
        linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20170714085839.4322-1-javierm@redhat.com>
From: Helen Koike <helen.koike@collabora.com>
Message-ID: <557a5f0e-f4d0-c1bd-f5fe-d9c7cfb2476d@collabora.com>
Date: Fri, 14 Jul 2017 12:09:06 -0300
MIME-Version: 1.0
In-Reply-To: <20170714085839.4322-1-javierm@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks for the patch

On 2017-07-14 05:58 AM, Javier Martinez Canillas wrote:
> The vimc platform drivers define a platform device ID table but these
> are not set to the .id_table field in the platform driver structure.
> 
> So the platform device ID table is only used to fill the aliases in
> the module but are not used for matching (works because the platform
> subsystem fallbacks to the driver's name if no .id_table is set).
> 
> But this also means that the platform device ID table isn't used if
> the driver is built-in, which leads to the following build warning:
> 
> This causes the following build warnings when the driver is built-in:
> 
> drivers/media/platform/vimc//vimc-capture.c:528:40: warning: ‘vimc_cap_driver_ids’ defined but not used [-Wunused-const-variable=]
>   static const struct platform_device_id vimc_cap_driver_ids[] = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-debayer.c:588:40: warning: ‘vimc_deb_driver_ids’ defined but not used [-Wunused-const-variable=]
>   static const struct platform_device_id vimc_deb_driver_ids[] = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-scaler.c:442:40: warning: ‘vimc_sca_driver_ids’ defined but not used [-Wunused-const-variable=]
>   static const struct platform_device_id vimc_sca_driver_ids[] = {
>                                          ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc//vimc-sensor.c:376:40: warning: ‘vimc_sen_driver_ids’ defined but not used [-Wunused-const-variable=]
>   static const struct platform_device_id vimc_sen_driver_ids[] = {
>                                          ^~~~~~~~~~~~~~~~~~~
> 
> Reported-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> Suggested-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>

Seems good to me.

Reviewed-by: Helen Koike <helen.koike@collabora.com>

> 
> ---
> 
>   drivers/media/platform/vimc/vimc-capture.c | 15 ++++++++-------
>   drivers/media/platform/vimc/vimc-debayer.c | 15 ++++++++-------
>   drivers/media/platform/vimc/vimc-scaler.c  | 15 ++++++++-------
>   drivers/media/platform/vimc/vimc-sensor.c  | 15 ++++++++-------
>   4 files changed, 32 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> index 14cb32e21130..88a1e5670c72 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -517,21 +517,22 @@ static int vimc_cap_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +static const struct platform_device_id vimc_cap_driver_ids[] = {
> +	{
> +		.name           = VIMC_CAP_DRV_NAME,
> +	},
> +	{ }
> +};
> +
>   static struct platform_driver vimc_cap_pdrv = {
>   	.probe		= vimc_cap_probe,
>   	.remove		= vimc_cap_remove,
> +	.id_table	= vimc_cap_driver_ids,
>   	.driver		= {
>   		.name	= VIMC_CAP_DRV_NAME,
>   	},
>   };
>   
> -static const struct platform_device_id vimc_cap_driver_ids[] = {
> -	{
> -		.name           = VIMC_CAP_DRV_NAME,
> -	},
> -	{ }
> -};
> -
>   module_platform_driver(vimc_cap_pdrv);
>   
>   MODULE_DEVICE_TABLE(platform, vimc_cap_driver_ids);
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> index 35b15bd4d61d..033a131f67af 100644
> --- a/drivers/media/platform/vimc/vimc-debayer.c
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -577,21 +577,22 @@ static int vimc_deb_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +static const struct platform_device_id vimc_deb_driver_ids[] = {
> +	{
> +		.name           = VIMC_DEB_DRV_NAME,
> +	},
> +	{ }
> +};
> +
>   static struct platform_driver vimc_deb_pdrv = {
>   	.probe		= vimc_deb_probe,
>   	.remove		= vimc_deb_remove,
> +	.id_table	= vimc_deb_driver_ids,
>   	.driver		= {
>   		.name	= VIMC_DEB_DRV_NAME,
>   	},
>   };
>   
> -static const struct platform_device_id vimc_deb_driver_ids[] = {
> -	{
> -		.name           = VIMC_DEB_DRV_NAME,
> -	},
> -	{ }
> -};
> -
>   module_platform_driver(vimc_deb_pdrv);
>   
>   MODULE_DEVICE_TABLE(platform, vimc_deb_driver_ids);
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index fe77505d2679..0a3e086e12f3 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -431,21 +431,22 @@ static int vimc_sca_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +static const struct platform_device_id vimc_sca_driver_ids[] = {
> +	{
> +		.name           = VIMC_SCA_DRV_NAME,
> +	},
> +	{ }
> +};
> +
>   static struct platform_driver vimc_sca_pdrv = {
>   	.probe		= vimc_sca_probe,
>   	.remove		= vimc_sca_remove,
> +	.id_table	= vimc_sca_driver_ids,
>   	.driver		= {
>   		.name	= VIMC_SCA_DRV_NAME,
>   	},
>   };
>   
> -static const struct platform_device_id vimc_sca_driver_ids[] = {
> -	{
> -		.name           = VIMC_SCA_DRV_NAME,
> -	},
> -	{ }
> -};
> -
>   module_platform_driver(vimc_sca_pdrv);
>   
>   MODULE_DEVICE_TABLE(platform, vimc_sca_driver_ids);
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index ebdbbe8c05ed..615c2b18dcfc 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -365,21 +365,22 @@ static int vimc_sen_remove(struct platform_device *pdev)
>   	return 0;
>   }
>   
> +static const struct platform_device_id vimc_sen_driver_ids[] = {
> +	{
> +		.name           = VIMC_SEN_DRV_NAME,
> +	},
> +	{ }
> +};
> +
>   static struct platform_driver vimc_sen_pdrv = {
>   	.probe		= vimc_sen_probe,
>   	.remove		= vimc_sen_remove,
> +	.id_table	= vimc_sen_driver_ids,
>   	.driver		= {
>   		.name	= VIMC_SEN_DRV_NAME,
>   	},
>   };
>   
> -static const struct platform_device_id vimc_sen_driver_ids[] = {
> -	{
> -		.name           = VIMC_SEN_DRV_NAME,
> -	},
> -	{ }
> -};
> -
>   module_platform_driver(vimc_sen_pdrv);
>   
>   MODULE_DEVICE_TABLE(platform, vimc_sen_driver_ids);
> 
