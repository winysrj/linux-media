Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37635 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab3FYVrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 17:47:19 -0400
Message-ID: <51CA0FE1.9090107@gmail.com>
Date: Tue, 25 Jun 2013 23:47:13 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: balbi@ti.com
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.figa@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	inki.dae@samsung.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com> <20130625150649.GA21334@arwen.pp.htv.fi> <51C9D714.4000703@samsung.com> <20130625205452.GC9748@arwen.pp.htv.fi>
In-Reply-To: <20130625205452.GC9748@arwen.pp.htv.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/25/2013 10:54 PM, Felipe Balbi wrote:
>>>> +static int exynos_video_phy_probe(struct platform_device *pdev)
>>>> >  >>  +{
>>>> >  >>  +	struct exynos_video_phy *state;
>>>> >  >>  +	struct device *dev =&pdev->dev;
>>>> >  >>  +	struct resource *res;
>>>> >  >>  +	struct phy_provider *phy_provider;
>>>> >  >>  +	int i;
>>>> >  >>  +
>>>> >  >>  +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
>>>> >  >>  +	if (!state)
>>>> >  >>  +		return -ENOMEM;
>>>> >  >>  +
>>>> >  >>  +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>> >  >>  +
>>>> >  >>  +	state->regs = devm_ioremap_resource(dev, res);
>>>> >  >>  +	if (IS_ERR(state->regs))
>>>> >  >>  +		return PTR_ERR(state->regs);
>>>> >  >>  +
>>>> >  >>  +	dev_set_drvdata(dev, state);
>>> >  >
>>> >  >  you can use platform_set_drvdata(pdev, state);
>> >
>> >  I had it in the previous version, but changed for symmetry with
>> >  dev_set_drvdata(). I guess those could be replaced with
>> >  phy_{get, set}_drvdata as you suggested.
>
> hmm, you do need to set the drvdata() to the phy object, but also to the
> pdev object (should you need it on a suspend/resume callback, for
> instance). Those are separate struct device instances.

Indeed, I somehow confused phy->dev with with phy->dev.parent. I'm going
to just drop the above call, since the pdev drvdata is currently not
referenced anywhere.


Thanks,
Sylwester
