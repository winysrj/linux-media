Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37592 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757749Ab3DDLUI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 07:20:08 -0400
Date: Thu, 4 Apr 2013 14:20:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] omap3isp: Use the common clock framework
Message-ID: <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1365073719-8038-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365073719-8038-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I don't remember when did I see equally nice patch to the omap3isp driver!
:-) Thanks!

A few comments below.

On Thu, Apr 04, 2013 at 01:08:38PM +0200, Laurent Pinchart wrote:
...
> +static int isp_xclk_set_rate(struct clk_hw *hw, unsigned long rate,
> +			     unsigned long parent_rate)
> +{
> +	struct isp_xclk *xclk = to_isp_xclk(hw);
> +	unsigned long flags;
> +	u32 divider;
> +
> +	divider = isp_xclk_calc_divider(&rate, parent_rate);
> +
> +	spin_lock_irqsave(&xclk->lock, flags);
> +
> +	xclk->divider = divider;
> +	if (xclk->enabled)
> +		isp_xclk_update(xclk, divider);
> +
> +	spin_unlock_irqrestore(&xclk->lock, flags);
> +
> +	dev_dbg(xclk->isp->dev, "%s: cam_xclk%c set to %lu Hz (div %u)\n",
> +		__func__, xclk->id == ISP_XCLK_A ? 'a' : 'b', rate, divider);
> +	return 0;
> +}
> +
> +static const struct clk_ops isp_xclk_ops = {
> +	.prepare = isp_xclk_prepare,
> +	.unprepare = isp_xclk_unprepare,
> +	.enable = isp_xclk_enable,
> +	.disable = isp_xclk_disable,
> +	.recalc_rate = isp_xclk_recalc_rate,
> +	.round_rate = isp_xclk_round_rate,
> +	.set_rate = isp_xclk_set_rate,
> +};
> +
> +static const char *isp_xclk_parent_name = "cam_mclk";
> +
> +static const struct clk_init_data isp_xclk_init_data = {
> +	.name = "cam_xclk",
> +	.ops = &isp_xclk_ops,
> +	.parent_names = &isp_xclk_parent_name,
> +	.num_parents = 1,
> +};

isp_xclk_init_data is unused.

> +static int isp_xclk_init(struct isp_device *isp)
> +{
> +	struct isp_platform_data *pdata = isp->pdata;
> +	struct clk_init_data init;

Init can be declared inside the loop.

> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
> +		struct isp_xclk *xclk = &isp->xclks[i];
> +		struct clk *clk;
> +
> +		xclk->isp = isp;
> +		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
> +		xclk->divider = 1;
> +		spin_lock_init(&xclk->lock);
> +
> +		init.name = i == 0 ? "cam_xclka" : "cam_xclkb";
> +		init.ops = &isp_xclk_ops;
> +		init.parent_names = &isp_xclk_parent_name;
> +		init.num_parents = 1;
> +
> +		xclk->hw.init = &init;
> +
> +		clk = devm_clk_register(isp->dev, &xclk->hw);
> +		if (IS_ERR(clk))
> +			return PTR_ERR(clk);
> +
> +		if (pdata->xclks[i].con_id == NULL &&
> +		    pdata->xclks[i].dev_id == NULL)
> +			continue;
> +
> +		xclk->lookup = kzalloc(sizeof(*xclk->lookup), GFP_KERNEL);

How about devm_kzalloc()? You'd save a bit of error handling (which is btw.
missing now, as well as kfree in cleanup).

> +		if (xclk->lookup == NULL)
> +			return -ENOMEM;
> +
> +		xclk->lookup->con_id = pdata->xclks[i].con_id;
> +		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
> +		xclk->lookup->clk = clk;
> +
> +		clkdev_add(xclk->lookup);
> +	}
> +
> +	return 0;
> +}
> +
> +static void isp_xclk_cleanup(struct isp_device *isp)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
> +		struct isp_xclk *xclk = &isp->xclks[i];
> +
> +		if (xclk->lookup)
> +			clkdev_drop(xclk->lookup);
> +	}
> +}

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
