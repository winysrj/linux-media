Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62449 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3FYSFc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 14:05:32 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>, balbi@ti.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.figa@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	inki.dae@samsung.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Date: Tue, 25 Jun 2013 20:05:31 +0200
Message-ID: <3490805.zE8M3ZYxso@flatron>
In-Reply-To: <51C9D714.4000703@samsung.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com> <20130625150649.GA21334@arwen.pp.htv.fi> <51C9D714.4000703@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester, Felipe,

On Tuesday 25 of June 2013 19:44:52 Sylwester Nawrocki wrote:
> Hi Felipe,
> 
> Thanks for the review.
> 
> On 06/25/2013 05:06 PM, Felipe Balbi wrote:
> > On Tue, Jun 25, 2013 at 04:21:46PM +0200, Sylwester Nawrocki wrote:
> >> +enum phy_id {
> >> +	PHY_CSIS0,
> >> +	PHY_DSIM0,
> >> +	PHY_CSIS1,
> >> +	PHY_DSIM1,
> >> +	NUM_PHYS
> > 
> > please prepend these with EXYNOS_PHY_ or EXYNOS_MIPI_PHY_
> 
> OK, will fix that.
> 
> >> +struct exynos_video_phy {
> >> +	spinlock_t slock;
> >> +	struct phy *phys[NUM_PHYS];
> > 
> > more than one phy ? This means you should instantiate driver multiple
> > drivers. Each phy id should call probe again.
> 
> Why ? This single PHY _provider_ can well handle multiple PHYs.
> I don't see a good reason to further complicate this driver like
> this. Please note that MIPI-CSIS 0 and MIPI DSIM 0 share MMIO
> register, so does MIPI CSIS 1 and MIPI DSIM 1. There are only 2
> registers for those 4 PHYs. I could have the involved object
> multiplied, but it would have been just a waste of resources
> with no difference to the PHY consumers.

IMHO one driver instance should represent one instance of IP block. Since 
this is a single IP block containing multiple PHYs with shared control 
interface, I think Sylwester did the right thing.

[snip]
> >> +static struct phy *exynos_video_phy_xlate(struct device *dev,
> >> +					struct of_phandle_args *args)
> >> +{
> >> +	struct exynos_video_phy *state = dev_get_drvdata(dev);
> >> +
> >> +	if (WARN_ON(args->args[0] > NUM_PHYS))
> >> +		return NULL;
> > 
> > please remove this check.
> 
> args->args[0] comes from DT as the PHY id and there is nothing
> preventing it from being greater or equal to the state->phys[]
> array length, unless I'm missing something. Actually it should
> have been 'if (args->args[0] >= NUM_PHYS)'.

The xlate() callback gets directly whatever parsed from device tree, so it 
is possible for an out of range value to get here and so this check is 
valid. However I think it should rather return an ERR_PTR, not NULL. See 
of_phy_get().

> >> +	return state->phys[args->args[0]];
> > 
> > and your xlate is 'wrong'.
> 
> What exactly is wrong here ?

Felipe, could you elaborate a bit more on this? I can't find any serious 
problems with this code.

[snip]
> >> +	phy_provider = devm_of_phy_provider_register(dev,
> >> +					exynos_video_phy_xlate);
> >> +	if (IS_ERR(phy_provider))
> >> +		return PTR_ERR(phy_provider);
> >> +
> >> +	for (i = 0; i < NUM_PHYS; i++) {
> >> +		char label[8];
> >> +
> >> +		snprintf(label, sizeof(label), "%s.%d",
> >> +				i == PHY_DSIM0 || i == PHY_DSIM1 ?
> >> +				"dsim" : "csis", i / 2);
> >> +
> >> +		state->phys[i] = devm_phy_create(dev, i, 
&exynos_video_phy_ops,
> >> +								label, 
state);
> >> +		if (IS_ERR(state->phys[i])) {
> >> +			dev_err(dev, "failed to create PHY %s\n", label);
> >> +			return PTR_ERR(state->phys[i]);
> >> +		}
> >> +	}
> > 
> > this really doesn't look correct to me. It looks like you have
> > multiple
> > PHYs, one for each ID. So your probe should be called for each PHY ID
> > and you have several phy_providers too.
> 
> Yes, multiple PHY objects, but a single provider. There is no need
> whatsoever for multiple PHY providers.

The whole concept of whatever-provider is to allow managing multiple 
objects by one parent object, like one clock provider for the whole clock 
controller, one interrupt controller object for all interrupts of an 
interrupt controller block, etc.

This is why a phandle has args, to allow addressing subobjects inside a 
provider.

Best regards,
Tomasz

