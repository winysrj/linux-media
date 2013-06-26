Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:46826 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab3FZLWS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 07:22:18 -0400
Message-ID: <51CACEBE.9000505@ti.com>
Date: Wed, 26 Jun 2013 16:51:34 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<kyungmin.park@samsung.com>, <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<inki.dae@samsung.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com> <20130625150649.GA21334@arwen.pp.htv.fi> <51C9D714.4000703@samsung.com> <20130625205452.GC9748@arwen.pp.htv.fi>
In-Reply-To: <20130625205452.GC9748@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Wednesday 26 June 2013 02:24 AM, Felipe Balbi wrote:
> Hi,
>
> On Tue, Jun 25, 2013 at 07:44:52PM +0200, Sylwester Nawrocki wrote:
>>>> +struct exynos_video_phy {
>>>> +	spinlock_t slock;
>>>> +	struct phy *phys[NUM_PHYS];
>>>
>>> more than one phy ? This means you should instantiate driver multiple
>>> drivers. Each phy id should call probe again.
>>
>> Why ? This single PHY _provider_ can well handle multiple PHYs.
>> I don't see a good reason to further complicate this driver like
>> this. Please note that MIPI-CSIS 0 and MIPI DSIM 0 share MMIO
>> register, so does MIPI CSIS 1 and MIPI DSIM 1. There are only 2
>> registers for those 4 PHYs. I could have the involved object
>> multiplied, but it would have been just a waste of resources
>> with no difference to the PHY consumers.
>
> alright, I misunderstood your code then. When I looked over your id
> usage I missed the "/2" part and assumed that you would have separate
> EXYNOS_MIPI_PHY_CONTROL() register for each ;-)
>
> My bad, you can disregard the other comments.
>
>>>> +static int exynos_video_phy_probe(struct platform_device *pdev)
>>>> +{
>>>> +	struct exynos_video_phy *state;
>>>> +	struct device *dev = &pdev->dev;
>>>> +	struct resource *res;
>>>> +	struct phy_provider *phy_provider;
>>>> +	int i;
>>>> +
>>>> +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
>>>> +	if (!state)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> +
>>>> +	state->regs = devm_ioremap_resource(dev, res);
>>>> +	if (IS_ERR(state->regs))
>>>> +		return PTR_ERR(state->regs);
>>>> +
>>>> +	dev_set_drvdata(dev, state);
>>>
>>> you can use platform_set_drvdata(pdev, state);
>>
>> I had it in the previous version, but changed for symmetry with
>> dev_set_drvdata(). I guess those could be replaced with
>> phy_{get, set}_drvdata as you suggested.

right. currently I was setting dev_set_drvdata of phy (core) device
in phy-core.c and the corresponding dev_get_drvdata in phy provider driver
which is little confusing.
So I'll add phy_set_drvdata and phy_get_drvdata in phy.h (as suggested by
Felipe) to be used by phy provider drivers. So after creating the PHY, the
phy provider should use phy_set_drvdata and in phy_ops, it can use
phy_get_drvdata. (I'll remove the dev_set_drvdata in phy_create).

This also means _void *priv_ in phy_create is useless. So I'll be removing
_priv_ from phy_create.

Thanks
Kishon

>
> hmm, you do need to set the drvdata() to the phy object, but also to the
> pdev object (should you need it on a suspend/resume callback, for
> instance). Those are separate struct device instances.

