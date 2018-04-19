Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:38018 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbeDSMpl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 08:45:41 -0400
Date: Thu, 19 Apr 2018 15:45:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rui Miguel Silva <rui.silva@linaro.org>
Cc: mchehab@kernel.org, sakari.ailus@linux.intel.com,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, devel@driverdev.osuosl.org,
        devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 05/15] media: staging/imx7: add MIPI CSI-2 receiver
 subdev for i.MX7
Message-ID: <20180419124515.r4336zu4ecsu3k6k@mwanda>
References: <20180419101812.30688-1-rui.silva@linaro.org>
 <20180419101812.30688-6-rui.silva@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180419101812.30688-6-rui.silva@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> +static int mipi_csis_clk_get(struct csi_state *state)
> +{
> +	struct device *dev = &state->pdev->dev;
> +	int ret = true;

Better to leave ret unitialized.

> +
> +	state->mipi_clk = devm_clk_get(dev, "mipi");
> +	if (IS_ERR(state->mipi_clk)) {
> +		dev_err(dev, "Could not get mipi csi clock\n");
> +		return -ENODEV;
> +	}
> +
> +	state->phy_clk = devm_clk_get(dev, "phy");
> +	if (IS_ERR(state->phy_clk)) {
> +		dev_err(dev, "Could not get mipi phy clock\n");
> +		return -ENODEV;
> +	}
> +
> +	/* Set clock rate */
> +	if (state->clk_frequency)
> +		ret = clk_set_rate(state->mipi_clk, state->clk_frequency);
> +	else
> +		dev_warn(dev, "No clock frequency specified!\n");
> +	if (ret < 0) {
> +		dev_err(dev, "set rate=%d failed: %d\n", state->clk_frequency,
> +			ret);
> +		return -EINVAL;

Preserve the error code.

> +	}
> +
> +	return ret;

This could be "return 0;" (let's not return true).  It might be nicer
like:

	if (!state->clk_frequency) {
		dev_warn(dev, "No clock frequency specified!\n");
		return 0;
	}

	ret = clk_set_rate(state->mipi_clk, state->clk_frequency);
	if (ret < 0)
		dev_err(dev, "set rate=%d failed: %d\n", state->clk_frequency,
			ret);

	return ret;


> +}
> +

[ snip ]

> +static irqreturn_t mipi_csis_irq_handler(int irq, void *dev_id)
> +{
> +	struct csi_state *state = dev_id;
> +	unsigned long flags;
> +	u32 status;
> +	int i;
> +
> +	status = mipi_csis_read(state, MIPI_CSIS_INTSRC);
> +
> +	spin_lock_irqsave(&state->slock, flags);
> +
> +	/* Update the event/error counters */
> +	if ((status & MIPI_CSIS_INTSRC_ERRORS) || 1) {
                                                 ^^^
Was this supposed to make it into the published code?

> +		for (i = 0; i < MIPI_CSIS_NUM_EVENTS; i++) {
> +			if (!(status & state->events[i].mask))
> +				continue;
> +			state->events[i].counter++;
> +		}
> +	}
> +	spin_unlock_irqrestore(&state->slock, flags);
> +
> +	mipi_csis_write(state, MIPI_CSIS_INTSRC, status);
> +
> +	return IRQ_HANDLED;
> +}
> +

regards,
dan carpenter
