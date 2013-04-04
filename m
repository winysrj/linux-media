Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40664 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758560Ab3DDLdo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 07:33:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 1/2] omap3isp: Use the common clock framework
Date: Thu, 04 Apr 2013 13:34:43 +0200
Message-ID: <3042650.zKZtsJVg4A@avalon>
In-Reply-To: <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com> <1365073719-8038-2-git-send-email-laurent.pinchart@ideasonboard.com> <20130404112004.GG10541@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the comments.

On Thursday 04 April 2013 14:20:04 Sakari Ailus wrote:
> Hi Laurent,
> 
> I don't remember when did I see equally nice patch to the omap3isp driver!
> 
> :-) Thanks!
> 
> A few comments below.
> 
> On Thu, Apr 04, 2013 at 01:08:38PM +0200, Laurent Pinchart wrote:
> ...
> 
> > +static int isp_xclk_set_rate(struct clk_hw *hw, unsigned long rate,
> > +			     unsigned long parent_rate)
> > +{
> > +	struct isp_xclk *xclk = to_isp_xclk(hw);
> > +	unsigned long flags;
> > +	u32 divider;
> > +
> > +	divider = isp_xclk_calc_divider(&rate, parent_rate);
> > +
> > +	spin_lock_irqsave(&xclk->lock, flags);
> > +
> > +	xclk->divider = divider;
> > +	if (xclk->enabled)
> > +		isp_xclk_update(xclk, divider);
> > +
> > +	spin_unlock_irqrestore(&xclk->lock, flags);
> > +
> > +	dev_dbg(xclk->isp->dev, "%s: cam_xclk%c set to %lu Hz (div %u)\n",
> > +		__func__, xclk->id == ISP_XCLK_A ? 'a' : 'b', rate, divider);
> > +	return 0;
> > +}
> > +
> > +static const struct clk_ops isp_xclk_ops = {
> > +	.prepare = isp_xclk_prepare,
> > +	.unprepare = isp_xclk_unprepare,
> > +	.enable = isp_xclk_enable,
> > +	.disable = isp_xclk_disable,
> > +	.recalc_rate = isp_xclk_recalc_rate,
> > +	.round_rate = isp_xclk_round_rate,
> > +	.set_rate = isp_xclk_set_rate,
> > +};
> > +
> > +static const char *isp_xclk_parent_name = "cam_mclk";
> > +
> > +static const struct clk_init_data isp_xclk_init_data = {
> > +	.name = "cam_xclk",
> > +	.ops = &isp_xclk_ops,
> > +	.parent_names = &isp_xclk_parent_name,
> > +	.num_parents = 1,
> > +};
> 
> isp_xclk_init_data is unused.

Indeed. I wonder how I've missed that, the compiler should have complained. 
I'll fix it for v2.

> > +static int isp_xclk_init(struct isp_device *isp)
> > +{
> > +	struct isp_platform_data *pdata = isp->pdata;
> > +	struct clk_init_data init;
> 
> Init can be declared inside the loop.

OK.

> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
> > +		struct isp_xclk *xclk = &isp->xclks[i];
> > +		struct clk *clk;
> > +
> > +		xclk->isp = isp;
> > +		xclk->id = i == 0 ? ISP_XCLK_A : ISP_XCLK_B;
> > +		xclk->divider = 1;
> > +		spin_lock_init(&xclk->lock);
> > +
> > +		init.name = i == 0 ? "cam_xclka" : "cam_xclkb";
> > +		init.ops = &isp_xclk_ops;
> > +		init.parent_names = &isp_xclk_parent_name;
> > +		init.num_parents = 1;
> > +
> > +		xclk->hw.init = &init;
> > +
> > +		clk = devm_clk_register(isp->dev, &xclk->hw);
> > +		if (IS_ERR(clk))
> > +			return PTR_ERR(clk);
> > +
> > +		if (pdata->xclks[i].con_id == NULL &&
> > +		    pdata->xclks[i].dev_id == NULL)
> > +			continue;
> > +
> > +		xclk->lookup = kzalloc(sizeof(*xclk->lookup), GFP_KERNEL);
> 
> How about devm_kzalloc()? You'd save a bit of error handling (which is btw.
> missing now, as well as kfree in cleanup).

As Sylwester pointed out, clkdev_drop() frees the memory. I don't really like 
that clkdev_add/clkdev_drop inconsistency, that might be something worth 
fixing at some point.

> > +		if (xclk->lookup == NULL)
> > +			return -ENOMEM;
> > +
> > +		xclk->lookup->con_id = pdata->xclks[i].con_id;
> > +		xclk->lookup->dev_id = pdata->xclks[i].dev_id;
> > +		xclk->lookup->clk = clk;
> > +
> > +		clkdev_add(xclk->lookup);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static void isp_xclk_cleanup(struct isp_device *isp)
> > +{
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(isp->xclks); ++i) {
> > +		struct isp_xclk *xclk = &isp->xclks[i];
> > +
> > +		if (xclk->lookup)
> > +			clkdev_drop(xclk->lookup);
> > +	}
> > +}

-- 
Regards,

Laurent Pinchart

