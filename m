Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33220 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaBVWS3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Feb 2014 17:18:29 -0500
Message-ID: <53092231.6080402@gmail.com>
Date: Sat, 22 Feb 2014 23:18:25 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
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
Subject: Re: [PATCH v4 07/10] exynos4-is: Add clock provider for the SCLK_CAM
 clock outputs
References: <1392925237-31394-1-git-send-email-s.nawrocki@samsung.com> <1392925237-31394-9-git-send-email-s.nawrocki@samsung.com> <20140221160504.GG20449@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140221160504.GG20449@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/21/2014 05:05 PM, Mark Rutland wrote:
>> ---
>>   drivers/media/platform/exynos4-is/media-dev.c |  110 +++++++++++++++++++++++++
>>   drivers/media/platform/exynos4-is/media-dev.h |   19 ++++-
>>   2 files changed, 128 insertions(+), 1 deletion(-)
...
>
>> +static int fimc_md_register_clk_provider(struct fimc_md *fmd)
>> +{
>> +	struct cam_clk_provider *cp =&fmd->clk_provider;
>> +	struct device *dev =&fmd->pdev->dev;
>> +	int i, ret;
>> +
>> +	for (i = 0; i<  ARRAY_SIZE(cp->clks); i++) {
>> +		struct cam_clk *camclk =&cp->camclk[i];
>> +		struct clk_init_data init;
>> +
>> +		ret = of_property_read_string_index(dev->of_node,
>> +					"clock-output-names", i,&init.name);
>
> Are there not well-defined names for the clock outputs of the block?

There are, but this driver handles multiple SoCs so I thought it's better
to define these names in devicetree. They are supposed to be unique. Isn't
that what the clock-output-names property is for ?

>> +		if (ret<  0)
>> +			break;
>> +
>> +		ret = of_property_read_string_index(dev->of_node,
>> +					"clock-names", i, init.parent_names);
>
> This shouldn't be a parent name. It should be the input line name.
>
> I don't think this makes sense.
>
> Why do you need the name of the parent clock?

As explained in previous e-mail, it is needed to maintain the clock tree,
the parent clock names must be set properly. As the above is not correct
I could hard code these names or retrieve with __clk_get_name() from proper
input clocks. of_clk_get_parent_name() cannot be used.

>> +		if (ret<  0)
>> +			break;
>> +
>> +		init.num_parents = 1;
>> +		init.ops =&cam_clk_ops;
>> +		init.flags = CLK_SET_RATE_PARENT;
>> +		camclk->hw.init =&init;
>> +		camclk->fmd = fmd;
>> +
>> +		cp->clks[i] = clk_register(NULL,&camclk->hw);
>> +		if (IS_ERR(cp->clks[i])) {
>> +			dev_err(dev, "failed to register clock: %s (%ld)\n",
>> +					init.name, PTR_ERR(cp->clks[i]));
>> +			ret = PTR_ERR(cp->clks[i]);
>> +			goto err;
>> +		}
>> +		cp->num_clocks++;
>> +	}
>> +
>> +	if (cp->num_clocks == 0) {
>> +		dev_warn(dev, "clk provider not registered\n");
>> +		return 0;
>> +	}
>> +
>> +	cp->clk_data.clks = cp->clks;
>> +	cp->clk_data.clk_num = cp->num_clocks;
>> +	cp->of_node = dev->of_node;
>> +	ret = of_clk_add_provider(dev->of_node, of_clk_src_onecell_get,
>> +				&cp->clk_data);
>
> Are _all_ of the input clock lines available to children in hardware?

This code is only for two clocks, ARRAY_SIZE(cp->clks) == 2 and
cp->num_clocks can't be greater than 2. Nevertheless, for some SoC
variants this driver handles (e.g. S5PV210) there can be only up to
two clocks listed in the camera node.

The camera interface IP block doesn't generate the clock itself, it just
passes it through when is active, i.e. its other clocks are enabled and
the power domain activated.

> The binding and commit message(s) implied only two clocks were, so
> what's the point in exporting clocks which aren't available?

I'm not sure what makes you think there is more than two ?

--
Regards,
Sylwester
