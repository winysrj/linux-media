Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40830 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751795AbdIVHE2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Sep 2017 03:04:28 -0400
Date: Fri, 22 Sep 2017 10:04:25 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-media@vger.kernel.org,
        Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hansverk@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mats Randgaard <matrandg@cisco.com>
Subject: Re: [PATCH] [media] tc358743: validate lane count and order
Message-ID: <20170922070425.7qnolzosl2fmql3j@valkosipuli.retiisi.org.uk>
References: <20170921153139.16657-1-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170921153139.16657-1-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Thu, Sep 21, 2017 at 05:31:39PM +0200, Philipp Zabel wrote:
> The TC358743 does not support reordering lanes, or more than 4 data
> lanes.
> 
> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> ---
>  drivers/media/i2c/tc358743.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/media/i2c/tc358743.c b/drivers/media/i2c/tc358743.c
> index a35043cefe128..b7285e45b908a 100644
> --- a/drivers/media/i2c/tc358743.c
> +++ b/drivers/media/i2c/tc358743.c
> @@ -1743,6 +1743,7 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  	struct clk *refclk;
>  	u32 bps_pr_lane;
>  	int ret = -EINVAL;
> +	int i;
>  
>  	refclk = devm_clk_get(dev, "refclk");
>  	if (IS_ERR(refclk)) {
> @@ -1771,6 +1772,21 @@ static int tc358743_probe_of(struct tc358743_state *state)
>  		goto free_endpoint;
>  	}
>  
> +	if (endpoint->bus.mipi_csi2.num_data_lanes > 4) {
> +		dev_err(dev, "invalid number of lanes\n");
> +		goto free_endpoint;
> +	}
> +
> +	for (i = 0; i < endpoint->bus.mipi_csi2.num_data_lanes; i++) {
> +		if (endpoint->bus.mipi_csi2.data_lanes[i] != i + 1)
> +			break;
> +	}

No other drivers perform such checks and if the hardware just doesn't
support it, then I'd just care about the number.

Checking that there are no more lanes configured than the hardware supports
makes definitely sense.

> +	if (i != endpoint->bus.mipi_csi2.num_data_lanes ||
> +	    endpoint->bus.mipi_csi2.clock_lane != 0) {
> +		dev_err(dev, "invalid lane order\n");
> +		goto free_endpoint;
> +	}
> +
>  	state->bus = endpoint->bus.mipi_csi2;
>  
>  	ret = clk_prepare_enable(refclk);

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
