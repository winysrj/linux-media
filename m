Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:57085 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3FZMtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 08:49:07 -0400
Message-ID: <51CAE30F.9070700@ti.com>
Date: Wed, 26 Jun 2013 18:18:15 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<kyungmin.park@samsung.com>, <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<inki.dae@samsung.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com> <20130625150649.GA21334@arwen.pp.htv.fi> <51C9D714.4000703@samsung.com> <20130625205452.GC9748@arwen.pp.htv.fi> <51CACEBE.9000505@ti.com> <51CAD89E.3060800@samsung.com>
In-Reply-To: <51CAD89E.3060800@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 26 June 2013 05:33 PM, Sylwester Nawrocki wrote:
> On 06/26/2013 01:21 PM, Kishon Vijay Abraham I wrote:
>>>>>> +static int exynos_video_phy_probe(struct platform_device *pdev)
>>>>>>>>>> +{
>>>>>>>>>> +	struct exynos_video_phy *state;
>>>>>>>>>> +	struct device *dev = &pdev->dev;
>>>>>>>>>> +	struct resource *res;
>>>>>>>>>> +	struct phy_provider *phy_provider;
>>>>>>>>>> +	int i;
>>>>>>>>>> +
>>>>>>>>>> +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
>>>>>>>>>> +	if (!state)
>>>>>>>>>> +		return -ENOMEM;
>>>>>>>>>> +
>>>>>>>>>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>>>>>>>> +
>>>>>>>>>> +	state->regs = devm_ioremap_resource(dev, res);
>>>>>>>>>> +	if (IS_ERR(state->regs))
>>>>>>>>>> +		return PTR_ERR(state->regs);
>>>>>>>>>> +
>>>>>>>>>> +	dev_set_drvdata(dev, state);
>>>>>>>>
>>>>>>>> you can use platform_set_drvdata(pdev, state);
>>>>>>
>>>>>> I had it in the previous version, but changed for symmetry with
>>>>>> dev_set_drvdata(). I guess those could be replaced with
>>>>>> phy_{get, set}_drvdata as you suggested.
>>
>> right. currently I was setting dev_set_drvdata of phy (core) device
>> in phy-core.c and the corresponding dev_get_drvdata in phy provider driver
>> which is little confusing.
>> So I'll add phy_set_drvdata and phy_get_drvdata in phy.h (as suggested by
>> Felipe) to be used by phy provider drivers. So after creating the PHY, the
>> phy provider should use phy_set_drvdata and in phy_ops, it can use
>> phy_get_drvdata. (I'll remove the dev_set_drvdata in phy_create).
>>
>> This also means _void *priv_ in phy_create is useless. So I'll be removing
>> _priv_ from phy_create.
>
> Yeah, sounds good. Then in the phy ops phy_get_drvdata(&phy->dev) would
> be used and in a custom of_xlate dev_get_drvdata(dev) (assuming the phy
> provider sets drvdata on its device beforehand).

thats correct. btw when you send the next version just have MODULE_LICENSE set
to GPL v2. Apart from that this patch looks good to me.

Thanks
Kishon
