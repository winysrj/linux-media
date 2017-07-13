Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:46704 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751280AbdGMPir (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:38:47 -0400
Date: Thu, 13 Jul 2017 18:38:43 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Helen Koike <helen.koike@collabora.com>
Subject: Re: [PATCH] media: vimc: cleanup a few warnings
Message-ID: <20170713153842.xupjvsf2nfkvtkyy@valkosipuli.retiisi.org.uk>
References: <ea42b2bdf113f7c2533c83986657647934b4e839.1499859983.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea42b2bdf113f7c2533c83986657647934b4e839.1499859983.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wed, Jul 12, 2017 at 08:46:30AM -0300, Mauro Carvalho Chehab wrote:
> The const structs uded by MODULE_DEVICE_TABLE()
> may never be used with COMPILE_TEST:
> 
> drivers/media/platform/vimc/vimc-capture.c:528:40: warning: 'vimc_cap_driver_ids' defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_cap_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc/vimc-debayer.c:588:40: warning: 'vimc_deb_driver_ids' defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_deb_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc/vimc-scaler.c:442:40: warning: 'vimc_sca_driver_ids' defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_sca_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> drivers/media/platform/vimc/vimc-sensor.c:376:40: warning: 'vimc_sen_driver_ids' defined but not used [-Wunused-const-variable=]
>  static const struct platform_device_id vimc_sen_driver_ids[] = {
>                                         ^~~~~~~~~~~~~~~~~~~
> 
> So, add the proper notation to avoid warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/platform/vimc/vimc-capture.c | 3 ++-
>  drivers/media/platform/vimc/vimc-debayer.c | 3 ++-
>  drivers/media/platform/vimc/vimc-scaler.c  | 3 ++-
>  drivers/media/platform/vimc/vimc-sensor.c  | 3 ++-
>  4 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> index 14cb32e21130..c6f4a407e019 100644
> --- a/drivers/media/platform/vimc/vimc-capture.c
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -525,7 +525,8 @@ static struct platform_driver vimc_cap_pdrv = {
>  	},
>  };
>  
> -static const struct platform_device_id vimc_cap_driver_ids[] = {
> +static const __maybe_unused
> +struct platform_device_id vimc_cap_driver_ids[] = {
>  	{
>  		.name           = VIMC_CAP_DRV_NAME,
>  	},
> diff --git a/drivers/media/platform/vimc/vimc-debayer.c b/drivers/media/platform/vimc/vimc-debayer.c
> index 35b15bd4d61d..428454e33b75 100644
> --- a/drivers/media/platform/vimc/vimc-debayer.c
> +++ b/drivers/media/platform/vimc/vimc-debayer.c
> @@ -585,7 +585,8 @@ static struct platform_driver vimc_deb_pdrv = {
>  	},
>  };
>  
> -static const struct platform_device_id vimc_deb_driver_ids[] = {
> +static const __maybe_unused
> +struct platform_device_id vimc_deb_driver_ids[] = {
>  	{
>  		.name           = VIMC_DEB_DRV_NAME,
>  	},
> diff --git a/drivers/media/platform/vimc/vimc-scaler.c b/drivers/media/platform/vimc/vimc-scaler.c
> index fe77505d2679..35bf3b32108f 100644
> --- a/drivers/media/platform/vimc/vimc-scaler.c
> +++ b/drivers/media/platform/vimc/vimc-scaler.c
> @@ -439,7 +439,8 @@ static struct platform_driver vimc_sca_pdrv = {
>  	},
>  };
>  
> -static const struct platform_device_id vimc_sca_driver_ids[] = {
> +static const __maybe_unused
> +struct platform_device_id vimc_sca_driver_ids[] = {
>  	{
>  		.name           = VIMC_SCA_DRV_NAME,
>  	},
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> index ebdbbe8c05ed..9ad2be111a14 100644
> --- a/drivers/media/platform/vimc/vimc-sensor.c
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -373,7 +373,8 @@ static struct platform_driver vimc_sen_pdrv = {
>  	},
>  };
>  
> -static const struct platform_device_id vimc_sen_driver_ids[] = {
> +static const __maybe_unused
> +struct platform_device_id vimc_sen_driver_ids[] = {
>  	{
>  		.name           = VIMC_SEN_DRV_NAME,
>  	},

Shouldn't these be set to the corresponding driver structs' id_table
fields? Or do I miss something...?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
