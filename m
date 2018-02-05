Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:47545 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752959AbeBEO4Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 09:56:16 -0500
Subject: Re: [PATCH 5/5] add default control values as module parameters
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517840981-12280-1-git-send-email-floe@butterbrot.org>
 <1517840981-12280-6-git-send-email-floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0be7b0ae-e0e0-7b25-fd76-8cf6387a4dd6@xs4all.nl>
Date: Mon, 5 Feb 2018 15:56:11 +0100
MIME-Version: 1.0
In-Reply-To: <1517840981-12280-6-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 03:29 PM, Florian Echtler wrote:
> Signed-off-by: Florian Echtler <floe@butterbrot.org>

Please add a change log when you make a patch.

I for one would like to know why this has to be supplied as a module option.
Some documentation in the code would be helpful as well (e.g. I have no idea
what a 'vsvideo' is).

Regards,

	Hans

> ---
>  drivers/input/touchscreen/sur40.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index c4b7cf1..d612f3f 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -173,6 +173,14 @@ int sur40_v4l2_contrast   = SUR40_CONTRAST_DEF;   /* blacklevel   */
>  int sur40_v4l2_gain       = SUR40_GAIN_DEF;       /* gain         */
>  int sur40_v4l2_backlight  = 1;                    /* preprocessor */
>  
> +/* module parameters */
> +static uint irlevel = SUR40_BRIGHTNESS_DEF;
> +module_param(irlevel, uint, 0644);
> +MODULE_PARM_DESC(irlevel, "set default irlevel");
> +static uint vsvideo = SUR40_VSVIDEO_DEF;
> +module_param(vsvideo, uint, 0644);
> +MODULE_PARM_DESC(vsvideo, "set default vsvideo");
> +
>  static const struct v4l2_pix_format sur40_pix_format[] = {
>  	{
>  		.pixelformat = V4L2_TCH_FMT_TU08,
> @@ -372,6 +380,11 @@ static void sur40_open(struct input_polled_dev *polldev)
>  
>  	dev_dbg(sur40->dev, "open\n");
>  	sur40_init(sur40);
> +
> +	/* set default values */
> +	sur40_set_irlevel(sur40, irlevel);
> +	sur40_set_vsvideo(sur40, vsvideo);
> +	sur40_set_preprocessor(sur40, SUR40_BACKLIGHT_DEF);
>  }
>  
>  /* Disable device, polling has stopped. */
> 
