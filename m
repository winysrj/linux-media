Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:59975 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753846AbeBGNUg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 08:20:36 -0500
Subject: Re: [PATCH 2/4] add default settings and module parameters for video
 controls
To: Florian Echtler <floe@butterbrot.org>, linux-media@vger.kernel.org
Cc: linux-input@vger.kernel.org, modin@yuri.at
References: <1518008438-26603-1-git-send-email-floe@butterbrot.org>
 <1518008438-26603-3-git-send-email-floe@butterbrot.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <40460636-1de2-c280-fe23-ec93f27242ed@xs4all.nl>
Date: Wed, 7 Feb 2018 14:20:30 +0100
MIME-Version: 1.0
In-Reply-To: <1518008438-26603-3-git-send-email-floe@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/18 14:00, Florian Echtler wrote:
> This patch adds parameter definitions and module parameters for the four
> userspace controls that the SUR40 can currently provide.
> 
> Signed-off-by: Florian Echtler <floe@butterbrot.org>
> ---
>  drivers/input/touchscreen/sur40.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/input/touchscreen/sur40.c b/drivers/input/touchscreen/sur40.c
> index 8375b06..8a5b031 100644
> --- a/drivers/input/touchscreen/sur40.c
> +++ b/drivers/input/touchscreen/sur40.c
> @@ -149,6 +149,34 @@ struct sur40_image_header {
>  #define SUR40_TOUCH	0x02
>  #define SUR40_TAG	0x04
>  
> +/* video controls */
> +#define SUR40_BRIGHTNESS_MAX 0xFF
> +#define SUR40_BRIGHTNESS_MIN 0x00
> +#define SUR40_BRIGHTNESS_DEF 0xFF
> +
> +#define SUR40_CONTRAST_MAX 0x0F
> +#define SUR40_CONTRAST_MIN 0x00
> +#define SUR40_CONTRAST_DEF 0x0A

It's kernel style to use lowercase hex values.

> +
> +#define SUR40_GAIN_MAX 0x09
> +#define SUR40_GAIN_MIN 0x00
> +#define SUR40_GAIN_DEF 0x08
> +
> +#define SUR40_BACKLIGHT_MAX 0x01
> +#define SUR40_BACKLIGHT_MIN 0x00
> +#define SUR40_BACKLIGHT_DEF 0x01
> +
> +/* module parameters */
> +static uint brightness = SUR40_BRIGHTNESS_DEF;
> +module_param(brightness, uint, 0644);
> +MODULE_PARM_DESC(brightness, "set initial brightness");

No range in the param description? I think you can do some macro magic so you
can use the MIN/MAX defines in the string.

Regards,

	Hans

> +static uint contrast = SUR40_CONTRAST_DEF;
> +module_param(contrast, uint, 0644);
> +MODULE_PARM_DESC(contrast, "set initial contrast");
> +static uint gain = SUR40_GAIN_DEF;
> +module_param(gain, uint, 0644);
> +MODULE_PARM_DESC(gain, "set initial gain");
> +
>  static const struct v4l2_pix_format sur40_pix_format[] = {
>  	{
>  		.pixelformat = V4L2_TCH_FMT_TU08,
> 
