Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:44553 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752666AbeBSNaX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Feb 2018 08:30:23 -0500
Subject: Re: [PATCH v2.1 4/9] staging: atomisp: i2c: Disable non-preview
 configurations
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com
References: <20180122123125.24709-5-hverkuil@xs4all.nl>
 <20180219132719.20452-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <482d5ffa-4cec-b760-96f3-6a538ce9a2e9@xs4all.nl>
Date: Mon, 19 Feb 2018 14:30:18 +0100
MIME-Version: 1.0
In-Reply-To: <20180219132719.20452-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/19/2018 02:27 PM, Sakari Ailus wrote:
> These sensor drivers have use case specific mode lists. There's no need
> for this nor there is a standard API for selecting the mode list. Disable
> configurations for non-preview modes until configuration selection is
> improved so that all the configurations are always usable.

It's a bit confusing. This seems contradictory: if there is no need for it,
then it can be removed. Or there is a need for it, but we don't have a
standard API to do it. You can't have both, can you?

Or did you mean that this functionality is currently unused, and that if
we wanted to use it, we first need a new API? That would actually make sense.

Regards,

	Hans

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro and Hans,
> 
> Would you like this one better?
> 
>  drivers/staging/media/atomisp/i2c/gc2235.h        | 6 ++++++
>  drivers/staging/media/atomisp/i2c/ov2722.h        | 6 ++++++
>  drivers/staging/media/atomisp/i2c/ov5693/ov5693.h | 6 ++++++
>  3 files changed, 18 insertions(+)
> 
> diff --git a/drivers/staging/media/atomisp/i2c/gc2235.h b/drivers/staging/media/atomisp/i2c/gc2235.h
> index 45a54fea5466..0e805bcfa4d8 100644
> --- a/drivers/staging/media/atomisp/i2c/gc2235.h
> +++ b/drivers/staging/media/atomisp/i2c/gc2235.h
> @@ -574,6 +574,11 @@ static struct gc2235_resolution gc2235_res_preview[] = {
>  };
>  #define N_RES_PREVIEW (ARRAY_SIZE(gc2235_res_preview))
>  
> +/*
> + * Disable non-preview configurations until the configuration selection is
> + * improved.
> + */
> +#if 0
>  static struct gc2235_resolution gc2235_res_still[] = {
>  	{
>  		.desc = "gc2235_1600_900_30fps",
> @@ -658,6 +663,7 @@ static struct gc2235_resolution gc2235_res_video[] = {
>  
>  };
>  #define N_RES_VIDEO (ARRAY_SIZE(gc2235_res_video))
> +#endif
>  
>  static struct gc2235_resolution *gc2235_res = gc2235_res_preview;
>  static unsigned long N_RES = N_RES_PREVIEW;
> diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
> index d8a973d71699..028b04aaaa8f 100644
> --- a/drivers/staging/media/atomisp/i2c/ov2722.h
> +++ b/drivers/staging/media/atomisp/i2c/ov2722.h
> @@ -1148,6 +1148,11 @@ struct ov2722_resolution ov2722_res_preview[] = {
>  };
>  #define N_RES_PREVIEW (ARRAY_SIZE(ov2722_res_preview))
>  
> +/*
> + * Disable non-preview configurations until the configuration selection is
> + * improved.
> + */
> +#if 0
>  struct ov2722_resolution ov2722_res_still[] = {
>  	{
>  		.desc = "ov2722_480P_30fps",
> @@ -1250,6 +1255,7 @@ struct ov2722_resolution ov2722_res_video[] = {
>  	},
>  };
>  #define N_RES_VIDEO (ARRAY_SIZE(ov2722_res_video))
> +#endif
>  
>  static struct ov2722_resolution *ov2722_res = ov2722_res_preview;
>  static unsigned long N_RES = N_RES_PREVIEW;
> diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> index 68cfcb4a6c3c..6d27dd849a62 100644
> --- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> +++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
> @@ -1147,6 +1147,11 @@ struct ov5693_resolution ov5693_res_preview[] = {
>  };
>  #define N_RES_PREVIEW (ARRAY_SIZE(ov5693_res_preview))
>  
> +/*
> + * Disable non-preview configurations until the configuration selection is
> + * improved.
> + */
> +#if 0
>  struct ov5693_resolution ov5693_res_still[] = {
>  	{
>  		.desc = "ov5693_736x496_30fps",
> @@ -1364,6 +1369,7 @@ struct ov5693_resolution ov5693_res_video[] = {
>  	},
>  };
>  #define N_RES_VIDEO (ARRAY_SIZE(ov5693_res_video))
> +#endif
>  
>  static struct ov5693_resolution *ov5693_res = ov5693_res_preview;
>  static unsigned long N_RES = N_RES_PREVIEW;
> 
