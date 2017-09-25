Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:26109 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752558AbdIYQVu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 12:21:50 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8PGHs7V000752
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 17:21:49 +0100
Received: from mail-pf0-f197.google.com (mail-pf0-f197.google.com [209.85.192.197])
        by mx07-00252a01.pphosted.com with ESMTP id 2d5d1016f7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 17:21:48 +0100
Received: by mail-pf0-f197.google.com with SMTP id a7so14098615pfj.3
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 09:21:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170921153024.15788-1-p.zabel@pengutronix.de>
References: <20170921153024.15788-1-p.zabel@pengutronix.de>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Mon, 25 Sep 2017 17:21:45 +0100
Message-ID: <CAAoAYcPvV7jTBPyvdpOXsf9aSaMYG=iJx9TkgTCofSEUCvCJiQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] [media] tc358743: fix connected/active CSI-2 lane reporting
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 September 2017 at 16:30, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> g_mbus_config was supposed to indicate all supported lane numbers, not
> only the number of those currently in active use. Since the TC358743
> can dynamically reduce the number of active lanes if the required
> bandwidth allows for it, report all lane numbers up to the connected
> number of lanes as supported in pdata mode.
> In device tree mode, do not report lane count and clock mode at all, as
> the receiver driver can determine these from the device tree.
>
> To allow communicating the number of currently active lanes, add a new
> bitfield to the v4l2_mbus_config flags. This is a temporary fix, to be
> used only until a better solution is found.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>

Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.org>

> ---
> Changes since v1:
>  - Check csi_lanes_in_use <= num_data_lanes before writing to cfg.
>  - Increase size of lane mask to 4 bits and always explicitly report
>    number of lanes in use.
>  - Clear clock and connected lane flags in DT mode.
> ---
>  drivers/media/i2c/tc358743.c  | 30 ++++++++++++++++--------------
>  include/media/v4l2-mediabus.h |  8 ++++++++
>  2 files changed, 24 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index e6f5c363ccab5..a35043cefe128 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1458,28 +1458,29 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
>                              struct v4l2_mbus_config *cfg)
>  {
>         struct tc358743_state *state = to_state(sd);
> +       const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
> +
> +       if (state->csi_lanes_in_use > state->bus.num_data_lanes)
> +               return -EINVAL;
>
>         cfg->type = V4L2_MBUS_CSI2;
> +       cfg->flags = (state->csi_lanes_in_use << __ffs(mask)) & mask;
>
> -       /* Support for non-continuous CSI-2 clock is missing in the driver */
> -       cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +       /* In DT mode, only report the number of active lanes */
> +       if (sd->dev->of_node)
> +               return 0;
>
> -       switch (state->csi_lanes_in_use) {
> -       case 1:
> +       /* Support for non-continuous CSI-2 clock is missing in pdata mode */
> +       cfg->flags |= V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +
> +       if (state->bus.num_data_lanes > 0)
>                 cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
> -               break;
> -       case 2:
> +       if (state->bus.num_data_lanes > 1)
>                 cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
> -               break;
> -       case 3:
> +       if (state->bus.num_data_lanes > 2)
>                 cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
> -               break;
> -       case 4:
> +       if (state->bus.num_data_lanes > 3)
>                 cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
> -               break;
> -       default:
> -               return -EINVAL;
> -       }
>
>         return 0;
>  }
> @@ -1885,6 +1886,7 @@ static int tc358743_probe(struct i2c_client *client,
>         if (pdata) {
>                 state->pdata = *pdata;
>                 state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +               state->bus.num_data_lanes = 4;
>         } else {
>                 err = tc358743_probe_of(state);
>                 if (err == -ENODEV)
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 93f8afcb7a220..fc106c902bf47 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -63,6 +63,14 @@
>                                          V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
>  #define V4L2_MBUS_CSI2_CHANNELS                (V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
>                                          V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
> +/*
> + * Number of lanes in use, 0 == use all available lanes (default)
> + *
> + * This is a temporary fix for devices that need to reduce the number of active
> + * lanes for certain modes, until g_mbus_config() can be replaced with a better
> + * solution.
> + */
> +#define V4L2_MBUS_CSI2_LANE_MASK                (0xf << 10)
>
>  /**
>   * enum v4l2_mbus_type - media bus type
> --
> 2.11.0
>
