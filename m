Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:54502 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752852AbeBFVbS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Feb 2018 16:31:18 -0500
Subject: Re: [PATCH 5/5] add module parameters for default values
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1517950905-5015-1-git-send-email-floe@butterbrot.org>
 <1517950905-5015-6-git-send-email-floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c64ae317-d393-1784-1184-4a24a2907112@xs4all.nl>
Date: Tue, 6 Feb 2018 22:31:13 +0100
MIME-Version: 1.0
In-Reply-To: <1517950905-5015-6-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2018 10:01 PM, Florian Echtler wrote:
> To allow setting custom parameters for the sensor directly at startup, the
> three primary controls are exposed as module parameters in this patch.
> 
> Signed-off-by: Florian Echtler <floe@butterbrot.org>
> ---
>  drivers/input/touchscreen/sur40.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 66ef7e6..d1fcb95 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -167,6 +167,17 @@ struct sur40_image_header {
>  #define SUR40_BACKLIGHT_MIN 0x00
>  #define SUR40_BACKLIGHT_DEF 0x01
>  
> +/* module parameters */
> +static uint brightness = SUR40_BRIGHTNESS_DEF;
> +module_param(brightness, uint, 0644);
> +MODULE_PARM_DESC(brightness, "set default brightness");
> +static uint contrast = SUR40_CONTRAST_DEF;
> +module_param(contrast, uint, 0644);
> +MODULE_PARM_DESC(contrast, "set default contrast");
> +static uint gain = SUR40_GAIN_DEF;
> +module_param(gain, uint, 0644);
> +MODULE_PARM_DESC(contrast, "set default gain");

contrast -> gain

Isn't 'initial gain' better than 'default gain'?

If I load this module with gain=X, will the gain control also
start off at X? I didn't see any code for that.

It might be useful to add the allowed range in the description.
E.g.: "set initial gain, range=0-255". Perhaps mention even the
default value, but I'm not sure if that's really needed.

Regards,

	Hans

> +
>  static const struct v4l2_pix_format sur40_pix_format[] = {
>  	{
>  		.pixelformat = V4L2_TCH_FMT_TU08,
> @@ -374,6 +385,11 @@ static void sur40_open(struct input_polled_dev *polldev)
>  
>  	dev_dbg(sur40->dev, "open\n");
>  	sur40_init(sur40);
> +
> +	/* set default values */
> +	sur40_set_irlevel(sur40, brightness & 0xFF);
> +	sur40_set_vsvideo(sur40, ((contrast & 0x0F) << 4) | (gain & 0x0F));
> +	sur40_set_preprocessor(sur40, SUR40_BACKLIGHT_DEF);
>  }
>  
>  /* Disable device, polling has stopped. */
> 
