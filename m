Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:35912 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbeLCRBS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 12:01:18 -0500
Received: by mail-it1-f193.google.com with SMTP id c9so9652020itj.1
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 09:01:15 -0800 (PST)
MIME-Version: 1.0
References: <1543502916-21632-1-git-send-email-jacopo+renesas@jmondi.org> <1543502916-21632-2-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1543502916-21632-2-git-send-email-jacopo+renesas@jmondi.org>
From: Adam Ford <aford173@gmail.com>
Date: Mon, 3 Dec 2018 11:01:02 -0600
Message-ID: <CAHCN7x+wFe1FuXx3nW5O=nr7wv25702VnibaEzTsSh1hE=3XmQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: ov5640: Fix set format regression
To: jacopo+renesas@jmondi.org
Cc: maxime.ripard@bootlin.com, sam@elite-embedded.com,
        Steve Longerbeam <slongerbeam@gmail.com>, mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com,
        linux-media@vger.kernel.org, hugues.fruchet@st.com,
        loic.poulain@linaro.org, daniel@zonque.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Nov 29, 2018 at 8:48 AM Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
>
> The set_fmt operations updates the sensor format only when the image format
> is changed. When only the image sizes gets changed, the format do not get
> updated causing the sensor to always report the one that was previously in
> use.
>
> Without this patch, updating frame size only fails:
>   [fmt:UYVY8_2X8/640x480@1/30 field:none colorspace:srgb xfer:srgb ...]
>
> With this patch applied:
>   [fmt:UYVY8_2X8/1024x768@1/30 field:none colorspace:srgb xfer:srgb ...]
>
> Fixes: 6949d864776e ("media: ov5640: do not change mode if format or frame
> interval is unchanged")
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

For patch 1 of 2 only,

Tested-by: Adam Ford <aford173@gmail.com>    #imx6d with CSI2
interface on 4.19.6 and 4.20-RC5

It would be great if this could be applied to 4.19+

adam
> ---
>  drivers/media/i2c/ov5640.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 03a031a42b3e..c659efe918a4 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2160,6 +2160,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>         struct ov5640_dev *sensor = to_ov5640_dev(sd);
>         const struct ov5640_mode_info *new_mode;
>         struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> +       struct v4l2_mbus_framefmt *fmt;
>         int ret;
>
>         if (format->pad != 0)
> @@ -2177,22 +2178,20 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>         if (ret)
>                 goto out;
>
> -       if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
> -               struct v4l2_mbus_framefmt *fmt =
> -                       v4l2_subdev_get_try_format(sd, cfg, 0);
> +       if (format->which == V4L2_SUBDEV_FORMAT_TRY)
> +               fmt = v4l2_subdev_get_try_format(sd, cfg, 0);
> +       else
> +               fmt = &sensor->fmt;
>
> -               *fmt = *mbus_fmt;
> -               goto out;
> -       }
> +       *fmt = *mbus_fmt;
>
>         if (new_mode != sensor->current_mode) {
>                 sensor->current_mode = new_mode;
>                 sensor->pending_mode_change = true;
>         }
> -       if (mbus_fmt->code != sensor->fmt.code) {
> -               sensor->fmt = *mbus_fmt;
> +       if (mbus_fmt->code != sensor->fmt.code)
>                 sensor->pending_fmt_change = true;
> -       }
> +
>  out:
>         mutex_unlock(&sensor->lock);
>         return ret;
> --
> 2.7.4
>
