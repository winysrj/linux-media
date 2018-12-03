Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it1-f193.google.com ([209.85.166.193]:38924 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbeLCTje (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Dec 2018 14:39:34 -0500
Received: by mail-it1-f193.google.com with SMTP id a6so10468290itl.4
        for <linux-media@vger.kernel.org>; Mon, 03 Dec 2018 11:39:33 -0800 (PST)
MIME-Version: 1.0
References: <cover.b1632e0c1a10c3f9f674e00142a554fa79eac762.1543826654.git-series.maxime.ripard@bootlin.com>
 <445b7d9c5d6b62f3f2b00fcbe97bcf65865f7200.1543826654.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <445b7d9c5d6b62f3f2b00fcbe97bcf65865f7200.1543826654.git-series.maxime.ripard@bootlin.com>
From: Adam Ford <aford173@gmail.com>
Date: Mon, 3 Dec 2018 13:39:21 -0600
Message-ID: <CAHCN7xJzZJMQ45dFgMhn3yQRDfE7=WCa4fMdosuu+9qfhhdKiw@mail.gmail.com>
Subject: Re: [PATCH v6 01/12] media: ov5640: Fix set format regression
To: maxime.ripard@bootlin.com
Cc: mchehab@kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, thomas.petazzoni@bootlin.com,
        mylene.josserand@bootlin.com, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com, hugues.fruchet@st.com,
        loic.poulain@linaro.org, sam@elite-embedded.com,
        Steve Longerbeam <slongerbeam@gmail.com>, daniel@zonque.org,
        jacopo@jmondi.org, jacopo+renesas@jmondi.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 3, 2018 at 2:45 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> From: Jacopo Mondi <jacopo+renesas@jmondi.org>
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
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>

Tested-by: Adam Ford <aford173@gmail.com> #imx6 w/ CSI2 interface on
4.19.6 and 4.20-RC5
> ---
>  drivers/media/i2c/ov5640.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index a91d91715d00..807bd0e386a4 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -2021,6 +2021,7 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
>         struct ov5640_dev *sensor = to_ov5640_dev(sd);
>         const struct ov5640_mode_info *new_mode;
>         struct v4l2_mbus_framefmt *mbus_fmt = &format->format;
> +       struct v4l2_mbus_framefmt *fmt;
>         int ret;
>
>         if (format->pad != 0)
> @@ -2038,22 +2039,20 @@ static int ov5640_set_fmt(struct v4l2_subdev *sd,
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
> git-series 0.9.1
