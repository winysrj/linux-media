Return-path: <linux-media-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42645 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932264AbaBUQFj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Feb 2014 11:05:39 -0500
Date: Fri, 21 Feb 2014 16:05:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"robh+dt@kernel.org" <robh+dt@kernel.org>,
	"galak@codeaurora.org" <galak@codeaurora.org>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"kgene.kim@samsung.com" <kgene.kim@samsung.com>,
	"a.hajda@samsung.com" <a.hajda@samsung.com>
Subject: Re: [PATCH v4 07/10] exynos4-is: Add clock provider for the
 SCLK_CAM clock outputs
Message-ID: <20140221160504.GG20449@e106331-lin.cambridge.arm.com>
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com>
 <1392925237-31394-9-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392925237-31394-9-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 20, 2014 at 07:40:34PM +0000, Sylwester Nawrocki wrote:
> This patch adds clock provider so the the SCLK_CAM0/1 output clocks
> can be accessed by image sensor devices through the clk API.
> 
> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Changes since v3:
>  - use clock-output-names DT property instead of hard coding names
>    of registered clocks in the driver; first two entries of the
>    clock-names property value are used to specify parent clocks of
>    cam_{a,b}_clkout clocks, rather than hard coding it to sclk_cam{0,1}
>    in the driver.
>  - addressed issues pointed out in review by Mauro.
> 
> Changes since v2:
>  - use 'camera' DT node drirectly as clock provider node, rather than
>   creating additional clock-controller child node.
>  - DT binding documentation moved to a separate patch.
> ---
>  drivers/media/platform/exynos4-is/media-dev.c |  110 +++++++++++++++++++++++++
>  drivers/media/platform/exynos4-is/media-dev.h |   19 ++++-
>  2 files changed, 128 insertions(+), 1 deletion(-)

[...]

> +static int fimc_md_register_clk_provider(struct fimc_md *fmd)
> +{
> +	struct cam_clk_provider *cp = &fmd->clk_provider;
> +	struct device *dev = &fmd->pdev->dev;
> +	int i, ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(cp->clks); i++) {
> +		struct cam_clk *camclk = &cp->camclk[i];
> +		struct clk_init_data init;
> +
> +		ret = of_property_read_string_index(dev->of_node,
> +					"clock-output-names", i, &init.name);

Are there not well-defined names for the clock outputs of the block?

> +		if (ret < 0)
> +			break;
> +
> +		ret = of_property_read_string_index(dev->of_node,
> +					"clock-names", i, init.parent_names);

This shouldn't be a parent name. It should be the input line name.

I don't think this makes sense.

Why do you need the name of the parent clock?

> +		if (ret < 0)
> +			break;
> +
> +		init.num_parents = 1;
> +		init.ops = &cam_clk_ops;
> +		init.flags = CLK_SET_RATE_PARENT;
> +		camclk->hw.init = &init;
> +		camclk->fmd = fmd;
> +
> +		cp->clks[i] = clk_register(NULL, &camclk->hw);
> +		if (IS_ERR(cp->clks[i])) {
> +			dev_err(dev, "failed to register clock: %s (%ld)\n",
> +					init.name, PTR_ERR(cp->clks[i]));
> +			ret = PTR_ERR(cp->clks[i]);
> +			goto err;
> +		}
> +		cp->num_clocks++;
> +	}
> +
> +	if (cp->num_clocks == 0) {
> +		dev_warn(dev, "clk provider not registered\n");
> +		return 0;
> +	}
> +
> +	cp->clk_data.clks = cp->clks;
> +	cp->clk_data.clk_num = cp->num_clocks;
> +	cp->of_node = dev->of_node;
> +	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
> +				  &cp->clk_data);

Are _all_ of the input clock lines available to children in hardware?

The binding and commit message(s) implied only two clocks were, so
what's the point in exporting clocks which aren't available?

Thanks,
Mark.
