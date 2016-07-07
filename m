Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:42639 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbcGGPS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:18:28 -0400
Subject: Re: [PATCH 07/11] media: adv7180: change mbus format to UYVY
To: Steve Longerbeam <slongerbeam@gmail.com>,
	linux-media@vger.kernel.org
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com>
 <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
Cc: Steve Longerbeam <steve_longerbeam@mentor.com>,
	=?UTF-8?Q?Niklas_S=c3=b6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <577E72C1.3000902@metafoo.de>
Date: Thu, 7 Jul 2016 17:18:25 +0200
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/07/2016 01:00 AM, Steve Longerbeam wrote:
> Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
> now look correct when capturing with the i.mx6 backend. The other
> option is to set the SWPC bit in register 0x27 to swap the Cr and Cb
> output samples.
> 
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>

The patch is certainly correct from the technical point of view. But we need
to be careful not to break any existing platforms which rely on this
setting. So the alternative solution of changing the default output order is
not an option.

Looking at things it seems like the Renesas vin driver, which is used in
combination with the adv7180 on some boards, uses the return value from
enum_mbus_code to setup the video pipeline. Adding Niklas to Cc, maybe he
can help to test this.

But otherwise

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/media/i2c/adv7180.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index fff887c..427695d 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -654,7 +654,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
>  	if (code->index != 0)
>  		return -EINVAL;
>  
> -	code->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +	code->code = MEDIA_BUS_FMT_UYVY8_2X8;
>  
>  	return 0;
>  }
> @@ -664,7 +664,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
>  {
>  	struct adv7180_state *state = to_state(sd);
>  
> -	fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +	fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
>  	fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
>  	fmt->width = 720;
>  	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> 

