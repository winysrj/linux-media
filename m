Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33275 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752380Ab3GXPqL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Jul 2013 11:46:11 -0400
Date: Wed, 24 Jul 2013 18:45:36 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] smiapp: re-use clamp_t instead of min(..., max(...))
Message-ID: <20130724154536.GE12281@valkosipuli.retiisi.org.uk>
References: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374679278-9856-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch.

(Drop Mauro from cc.)

On Wed, Jul 24, 2013 at 06:21:18PM +0300, Andy Shevchenko wrote:
> clamp_t does the job to put a variable into the given range.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/media/i2c/smiapp/smiapp-core.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
> index 7ac7580..914e52f 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -1835,12 +1835,12 @@ static void smiapp_set_compose_scaler(struct v4l2_subdev *subdev,
>  		* sensor->limits[SMIAPP_LIMIT_SCALER_N_MIN]
>  		/ sensor->limits[SMIAPP_LIMIT_MIN_X_OUTPUT_SIZE];
>  
> -	a = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> -		max(a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> -	b = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> -		max(b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> -	max_m = min(sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX],
> -		    max(max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN]));
> +	a = clamp_t(u32, a, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
> +		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
> +	b = clamp_t(u32, b, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
> +		    sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);
> +	max_m = clamp_t(u32, max_m, sensor->limits[SMIAPP_LIMIT_SCALER_M_MIN],
> +			sensor->limits[SMIAPP_LIMIT_SCALER_M_MAX]);

Do you need clamp_t()? Wouldn't plain clamp() do?

I can change it if you're ok with that.

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
