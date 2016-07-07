Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37784 "EHLO
	mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbcGGPEy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 11:04:54 -0400
Received: by mail-it0-f51.google.com with SMTP id f6so22058816ith.0
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 08:04:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-5-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com> <1467846004-12731-5-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 08:04:47 -0700
Message-ID: <CAJ+vNU116Jw0XA8U6iUyhpSSKXsoTSD3qCJxBemkrL60+EvoWg@mail.gmail.com>
Subject: Re: [PATCH 04/11] media: adv7180: implement g_parm
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Steve Longerbeam <steve_longerbeam@mentor.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:59 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Implement g_parm to return the current standard's frame period.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv7180.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 38e5161..42816d4 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -741,6 +741,27 @@ static int adv7180_g_mbus_config(struct v4l2_subdev *sd,
>         return 0;
>  }
>
> +static int adv7180_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *a)
> +{
> +       struct adv7180_state *state = to_state(sd);
> +       struct v4l2_captureparm *cparm = &a->parm.capture;
> +
> +       if (a->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +               return -EINVAL;
> +
> +       memset(a, 0, sizeof(*a));
> +       a->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +       if (state->curr_norm & V4L2_STD_525_60) {
> +               cparm->timeperframe.numerator = 1001;
> +               cparm->timeperframe.denominator = 30000;
> +       } else {
> +               cparm->timeperframe.numerator = 1;
> +               cparm->timeperframe.denominator = 25;
> +       }
> +
> +       return 0;
> +}
> +
>  static int adv7180_cropcap(struct v4l2_subdev *sd, struct v4l2_cropcap *cropcap)
>  {
>         struct adv7180_state *state = to_state(sd);
> @@ -765,6 +786,7 @@ static int adv7180_g_tvnorms(struct v4l2_subdev *sd, v4l2_std_id *norm)
>  static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>         .s_std = adv7180_s_std,
>         .g_std = adv7180_g_std,
> +       .g_parm = adv7180_g_parm,
>         .querystd = adv7180_querystd,
>         .g_input_status = adv7180_g_input_status,
>         .s_routing = adv7180_s_routing,
> --

Steve,

Tested on an IMX6 Gateworks Ventana with IMX6 capture drivers [1].

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Added to Cc:
Cc: Lars-Peter Clausen <lars@metafoo.de>

Regards,

Tim

[1] - http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/102914
