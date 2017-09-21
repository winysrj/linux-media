Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00252a01.pphosted.com ([91.207.212.211]:56404 "EHLO
        mx08-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751387AbdIULlE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 07:41:04 -0400
Received: from pps.filterd (m0102629.ppops.net [127.0.0.1])
        by mx08-00252a01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v8LBeDG4017510
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 12:41:03 +0100
Received: from mail-pf0-f197.google.com (mail-pf0-f197.google.com [209.85.192.197])
        by mx08-00252a01.pphosted.com with ESMTP id 2d0reg2hem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 12:41:02 +0100
Received: by mail-pf0-f197.google.com with SMTP id x78so9871776pff.7
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 04:41:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170921102428.30709-1-p.zabel@pengutronix.de>
References: <20170921102428.30709-1-p.zabel@pengutronix.de>
From: Dave Stevenson <dave.stevenson@raspberrypi.org>
Date: Thu, 21 Sep 2017 12:41:00 +0100
Message-ID: <CAAoAYcPckrO5-Z1quY+TCsMMgr7mRDsaqy5B3yYtSCBBdn0LiA@mail.gmail.com>
Subject: Re: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp

On 21 September 2017 at 11:24, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> g_mbus_config was supposed to indicate all supported lane numbers, not
> only the number of those currently in active use. Since the tc358743
> can dynamically reduce the number of active lanes if the required
> bandwidth allows for it, report all lane numbers up to the connected
> number of lanes as supported.
> To allow communicating the number of currently active lanes, add a new
> bitfield to the v4l2_mbus_config flags. This is a temporary fix, until
> a better solution is found.
>
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/tc358743.c  | 22 ++++++++++++----------
>  include/media/v4l2-mediabus.h |  8 ++++++++
>  2 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index e6f5c363ccab5..e2a9e6a18a49d 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1464,21 +1464,22 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
>         /* Support for non-continuous CSI-2 clock is missing in the driver */
>         cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
>
> -       switch (state->csi_lanes_in_use) {
> -       case 1:
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
> +
> +       if (state->csi_lanes_in_use > 4)

One could suggest
if (state->csi_lanes_in_use > state->bus.num_data_lanes)
here. Needing to use more lanes than are configured is surely an
error, although that may be detectable at the other end. See below
too.

>                 return -EINVAL;
> +
> +       if (state->csi_lanes_in_use < state->bus.num_data_lanes) {
> +               const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
> +
> +               cfg->flags |= (state->csi_lanes_in_use << __ffs(mask)) & mask;
>         }
>
>         return 0;
> @@ -1885,6 +1886,7 @@ static int tc358743_probe(struct i2c_client *client,
>         if (pdata) {
>                 state->pdata = *pdata;
>                 state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +               state->bus.num_data_lanes = 4;
>         } else {
>                 err = tc358743_probe_of(state);
>                 if (err == -ENODEV)
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 93f8afcb7a220..3467d97be5f5b 100644
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
> +#define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)

I know this was Hans' suggested define, but are we saying 4 lanes is
not a valid value? If it is then the mask needs to be at least (7 <<
10).

4 lanes is not necessarily "all available lanes".
- There are now CSI2 devices supporting up to 8 lanes (although
V4L2_FWNODE_CSI2_MAX_DATA_LANES limits you to 4 at the moment).
- Or you could have 2 lanes configured in DT and ask TC358743 for (eg)
1080P60 UYVY at 594Mbps (needs 4 lanes) which passes the current logic
in the TC358743 driver and would return 0, when it is actually going
to use 4 lanes. That could be classed as a driver bug though.

My view is that if a driver is going to report how many lanes to use
then it should always report it explicitly. The default 0 value should
only be used for devices that will never change it from the DT
settings. Perhaps others disagree

Otherwise the patch works for me.

  Dave.

>  /**
>   * enum v4l2_mbus_type - media bus type
> --
> 2.11.0
>
