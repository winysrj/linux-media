Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:38710 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750757AbeASESQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 23:18:16 -0500
Received: by mail-ua0-f195.google.com with SMTP id t7so285974uae.5
        for <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 20:18:16 -0800 (PST)
Received: from mail-ua0-f182.google.com (mail-ua0-f182.google.com. [209.85.217.182])
        by smtp.gmail.com with ESMTPSA id d206sm439785vka.13.2018.01.18.20.18.14
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jan 2018 20:18:14 -0800 (PST)
Received: by mail-ua0-f182.google.com with SMTP id p1so288693uab.4
        for <linux-media@vger.kernel.org>; Thu, 18 Jan 2018 20:18:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1516333071-9766-1-git-send-email-andy.yeh@intel.com>
References: <1516333071-9766-1-git-send-email-andy.yeh@intel.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 19 Jan 2018 13:17:53 +0900
Message-ID: <CAAFQd5Aq4oX+-ux0r4SjyWAyRUA1DJ34mgBmcvuY6HpG9SJ++g@mail.gmail.com>
Subject: Re: [PATCH v4] media: imx258: Add imx258 camera sensor driver
To: Andy Yeh <andy.yeh@intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch. Please see my comments inline.

On Fri, Jan 19, 2018 at 12:37 PM, Andy Yeh <andy.yeh@intel.com> wrote:
> Add a V4L2 sub-device driver for the Sony IMX258 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
>
> Signed-off-by: Andy Yeh <andy.yeh@intel.com>
> ---
> - v2->v3
> -- Update the streaming function to remove SW_STANDBY in the beginning.
> -- Adjust the delay time from 1ms to 12ms before set stream-on register.
> - v3->v4
> -- fix the sd.entity to make code be compiled on the mainline kernel.
> -- " - imx258->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV_SENSOR;"
> -- " + imx258->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;"
>
>  MAINTAINERS                |    7 +
>  drivers/media/i2c/Kconfig  |   11 +
>  drivers/media/i2c/Makefile |    1 +
>  drivers/media/i2c/imx258.c | 1148 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 1167 insertions(+)
>  create mode 100644 drivers/media/i2c/imx258.c
[snip]
> +static int imx258_set_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +       struct imx258 *imx258 =
> +               container_of(ctrl->handler, struct imx258, ctrl_handler);
> +       struct i2c_client *client = v4l2_get_subdevdata(&imx258->sd);
> +       s64 max;
> +       int ret = 0;
> +
> +       /* Propagate change of current control to all related controls */
> +       if (ctrl->id == V4L2_CID_VBLANK) {
> +               /* Update max exposure while meeting expected vblanking */
> +               max = imx258->cur_mode->height + ctrl->val - 8;
> +               __v4l2_ctrl_modify_range(imx258->exposure,
> +                                        imx258->exposure->minimum,
> +                                        max, imx258->exposure->step, max);
> +       }
> +
> +       /*
> +        * Applying V4L2 control value only happens
> +        * when power is up for streaming
> +        */
> +       if (pm_runtime_get_if_in_use(&client->dev) <= 0)
> +               return 0;

This won't work if runtime PM is not compiled in or is disabled at
runtime, i.e. pm_runtime_get_if_in_use() returns -EINVAL.

But actually, do we need to care about runtime PM here? Could we just
return early if we're not streaming? Then the controls would be
handled when streaming starts, since we call
__v4l2_ctrl_handler_setup() from _start_streaming().

Best regards,
Tomasz
