Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38346 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdIULEe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Sep 2017 07:04:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id x17so4870053wmd.5
        for <linux-media@vger.kernel.org>; Thu, 21 Sep 2017 04:04:34 -0700 (PDT)
Subject: Re: [PATCH] tc358743: fix connected/active CSI-2 lane reporting
To: Philipp Zabel <p.zabel@pengutronix.de>, linux-media@vger.kernel.org
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
References: <20170921102428.30709-1-p.zabel@pengutronix.de>
From: Ian Arkver <ian.arkver.dev@gmail.com>
Message-ID: <f3d4ce20-d3aa-f76f-0d07-e8153e3558a9@gmail.com>
Date: Thu, 21 Sep 2017 12:04:31 +0100
MIME-Version: 1.0
In-Reply-To: <20170921102428.30709-1-p.zabel@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp

On 21/09/17 11:24, Philipp Zabel wrote:
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
>   drivers/media/i2c/tc358743.c  | 22 ++++++++++++----------
>   include/media/v4l2-mediabus.h |  8 ++++++++
>   2 files changed, 20 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index e6f5c363ccab5..e2a9e6a18a49d 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1464,21 +1464,22 @@ static int tc358743_g_mbus_config(struct v4l2_subdev *sd,
>   	/* Support for non-continuous CSI-2 clock is missing in the driver */
>   	cfg->flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
>   
> -	switch (state->csi_lanes_in_use) {
> -	case 1:
> +	if (state->bus.num_data_lanes > 0)
>   		cfg->flags |= V4L2_MBUS_CSI2_1_LANE;
> -		break;
> -	case 2:
> +	if (state->bus.num_data_lanes > 1)
>   		cfg->flags |= V4L2_MBUS_CSI2_2_LANE;
> -		break;
> -	case 3:
> +	if (state->bus.num_data_lanes > 2)
>   		cfg->flags |= V4L2_MBUS_CSI2_3_LANE;
> -		break;
> -	case 4:
> +	if (state->bus.num_data_lanes > 3)
>   		cfg->flags |= V4L2_MBUS_CSI2_4_LANE;
> -		break;
> -	default:
> +
> +	if (state->csi_lanes_in_use > 4)
>   		return -EINVAL;
> +

My understanding of Hans' comment:
"I'd also add a comment that all other flags must be 0 if the device 
tree is used. This to avoid mixing the two."

is that all the above should only happen if (!!state->pdata).

I don't know if this would break any existing DT-using bridge drivers.

Regards,
Ian

> +	if (state->csi_lanes_in_use < state->bus.num_data_lanes) {
> +		const u32 mask = V4L2_MBUS_CSI2_LANE_MASK;
> +
> +		cfg->flags |= (state->csi_lanes_in_use << __ffs(mask)) & mask;
>   	}
>   
>   	return 0;
> @@ -1885,6 +1886,7 @@ static int tc358743_probe(struct i2c_client *client,
>   	if (pdata) {
>   		state->pdata = *pdata;
>   		state->bus.flags = V4L2_MBUS_CSI2_CONTINUOUS_CLOCK;
> +		state->bus.num_data_lanes = 4;
>   	} else {
>   		err = tc358743_probe_of(state);
>   		if (err == -ENODEV)
> diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
> index 93f8afcb7a220..3467d97be5f5b 100644
> --- a/include/media/v4l2-mediabus.h
> +++ b/include/media/v4l2-mediabus.h
> @@ -63,6 +63,14 @@
>   					 V4L2_MBUS_CSI2_3_LANE | V4L2_MBUS_CSI2_4_LANE)
>   #define V4L2_MBUS_CSI2_CHANNELS		(V4L2_MBUS_CSI2_CHANNEL_0 | V4L2_MBUS_CSI2_CHANNEL_1 | \
>   					 V4L2_MBUS_CSI2_CHANNEL_2 | V4L2_MBUS_CSI2_CHANNEL_3)
> +/*
> + * Number of lanes in use, 0 == use all available lanes (default)
> + *
> + * This is a temporary fix for devices that need to reduce the number of active
> + * lanes for certain modes, until g_mbus_config() can be replaced with a better
> + * solution.
> + */
> +#define V4L2_MBUS_CSI2_LANE_MASK                (3 << 10)
>   
>   /**
>    * enum v4l2_mbus_type - media bus type
> 
