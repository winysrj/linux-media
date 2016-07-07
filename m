Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:36175 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbcGGPZ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:25:29 -0400
Received: by mail-io0-f181.google.com with SMTP id l202so22664087ioe.3
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 08:25:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com> <1467846004-12731-8-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 08:25:26 -0700
Message-ID: <CAJ+vNU1UstB_fnH8vpEEQYEmFDcNfF1swNUhKWxsJYpt2BMdqQ@mail.gmail.com>
Subject: Re: [PATCH 07/11] media: adv7180: change mbus format to UYVY
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	Simon Horman <horms+renesas@verge.net.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 4:00 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Change the media bus format from YUYV8_2X8 to UYVY8_2X8. Colors
> now look correct when capturing with the i.mx6 backend. The other
> option is to set the SWPC bit in register 0x27 to swap the Cr and Cb
> output samples.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv7180.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index fff887c..427695d 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -654,7 +654,7 @@ static int adv7180_enum_mbus_code(struct v4l2_subdev *sd,
>         if (code->index != 0)
>                 return -EINVAL;
>
> -       code->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +       code->code = MEDIA_BUS_FMT_UYVY8_2X8;
>
>         return 0;
>  }
> @@ -664,7 +664,7 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
>  {
>         struct adv7180_state *state = to_state(sd);
>
> -       fmt->code = MEDIA_BUS_FMT_YUYV8_2X8;
> +       fmt->code = MEDIA_BUS_FMT_UYVY8_2X8;
>         fmt->colorspace = V4L2_COLORSPACE_SMPTE170M;
>         fmt->width = 720;
>         fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> --

Steve,

Tested on an IMX6 Gateworks Ventana with IMX6 capture drivers [1].

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Added to Cc:
Cc: Lars-Peter Clausen <lars@metafoo.de>

Also adding Cc's to the people who are using the adv7180 on other
boards (renesas r8a779* boards) so we can get some feedback and/or
Tested-by from them:
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Simon Horman <horms+renesas@verge.net.au>

Regards,

Tim

[1] - http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/102914
