Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64121 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab3FYRoz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 13:44:55 -0400
Message-id: <51C9D714.4000703@samsung.com>
Date: Tue, 25 Jun 2013 19:44:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: balbi@ti.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, kishon@ti.com,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	t.figa@samsung.com, devicetree-discuss@lists.ozlabs.org,
	kgene.kim@samsung.com, dh09.lee@samsung.com, jg1.han@samsung.com,
	inki.dae@samsung.com, plagnioj@jcrosoft.com,
	linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
In-reply-to: <20130625150649.GA21334@arwen.pp.htv.fi>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

Thanks for the review.

On 06/25/2013 05:06 PM, Felipe Balbi wrote:
> On Tue, Jun 25, 2013 at 04:21:46PM +0200, Sylwester Nawrocki wrote:
>> +enum phy_id {
>> +	PHY_CSIS0,
>> +	PHY_DSIM0,
>> +	PHY_CSIS1,
>> +	PHY_DSIM1,
>> +	NUM_PHYS
> 
> please prepend these with EXYNOS_PHY_ or EXYNOS_MIPI_PHY_

OK, will fix that.

>> +struct exynos_video_phy {
>> +	spinlock_t slock;
>> +	struct phy *phys[NUM_PHYS];
> 
> more than one phy ? This means you should instantiate driver multiple
> drivers. Each phy id should call probe again.

Why ? This single PHY _provider_ can well handle multiple PHYs.
I don't see a good reason to further complicate this driver like
this. Please note that MIPI-CSIS 0 and MIPI DSIM 0 share MMIO
register, so does MIPI CSIS 1 and MIPI DSIM 1. There are only 2
registers for those 4 PHYs. I could have the involved object
multiplied, but it would have been just a waste of resources
with no difference to the PHY consumers.

>> +static int __set_phy_state(struct exynos_video_phy *state,
>> +				enum phy_id id, unsigned int on)
>> +{
>> +	void __iomem *addr;
>> +	unsigned long flags;
>> +	u32 reg, reset;
>> +
>> +	if (WARN_ON(id > NUM_PHYS))
>> +		return -EINVAL;
> 
> you don't want to do this, actually. It'll bug you everytime you want to
> add another phy ID :-)

If there is an SoC with more PHYs enum phy_id would be extended, and this
part would not need to be touched. OTOH @id cannot be normally greater
than NUM_PHYS. I think I'll drop that then.

>> +	addr = state->regs + EXYNOS_MIPI_PHY_CONTROL(id / 2);
>> +
>> +	if (id == PHY_DSIM0 || id == PHY_DSIM1)
>> +		reset = EXYNOS_MIPI_PHY_MRESETN;
>> +	else
>> +		reset = EXYNOS_MIPI_PHY_SRESETN;
>> +
>> +	spin_lock_irqsave(&state->slock, flags);
>> +	reg = readl(addr);
>> +	if (on)
>> +		reg |= reset;
>> +	else
>> +		reg &= ~reset;
>> +	writel(reg, addr);
>> +
>> +	/* Clear ENABLE bit only if MRESETN, SRESETN bits are not set. */
>> +	if (on)
>> +		reg |= EXYNOS_MIPI_PHY_ENABLE;
>> +	else if (!(reg & EXYNOS_MIPI_PHY_RESET_MASK))
>> +		reg &= ~EXYNOS_MIPI_PHY_ENABLE;
>> +
>> +	writel(reg, addr);
>> +	spin_unlock_irqrestore(&state->slock, flags);
>> +
>> +	pr_debug("%s(): id: %d, on: %d, addr: %#x, base: %#x\n",
>> +		 __func__, id, on, (u32)addr, (u32)state->regs);
> 
> use dev_dbg() instead.
> 
>> +
>> +	return 0;
>> +}
>> +
>> +static int exynos_video_phy_power_on(struct phy *phy)
>> +{
>> +	struct exynos_video_phy *state = dev_get_drvdata(&phy->dev);
> 
> looks like we should have phy_get_drvdata() helper :-) Kishon ?

Indeed, that might be useful.

>> +static struct phy *exynos_video_phy_xlate(struct device *dev,
>> +					struct of_phandle_args *args)
>> +{
>> +	struct exynos_video_phy *state = dev_get_drvdata(dev);
>> +
>> +	if (WARN_ON(args->args[0] > NUM_PHYS))
>> +		return NULL;
> 
> please remove this check.

args->args[0] comes from DT as the PHY id and there is nothing
preventing it from being greater or equal to the state->phys[]
array length, unless I'm missing something. Actually it should
have been 'if (args->args[0] >= NUM_PHYS)'.

>> +	return state->phys[args->args[0]];
> 
> and your xlate is 'wrong'.

What exactly is wrong here ?

>> +}
>> +
>> +static struct phy_ops exynos_video_phy_ops = {
>> +	.power_on	= exynos_video_phy_power_on,
>> +	.power_off	= exynos_video_phy_power_off,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int exynos_video_phy_probe(struct platform_device *pdev)
>> +{
>> +	struct exynos_video_phy *state;
>> +	struct device *dev = &pdev->dev;
>> +	struct resource *res;
>> +	struct phy_provider *phy_provider;
>> +	int i;
>> +
>> +	state = devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
>> +	if (!state)
>> +		return -ENOMEM;
>> +
>> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +
>> +	state->regs = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(state->regs))
>> +		return PTR_ERR(state->regs);
>> +
>> +	dev_set_drvdata(dev, state);
> 
> you can use platform_set_drvdata(pdev, state);

I had it in the previous version, but changed for symmetry with
dev_set_drvdata(). I guess those could be replaced with
phy_{get, set}_drvdata as you suggested.

> same thing though, no strong feelings.
> 
>> +	phy_provider = devm_of_phy_provider_register(dev,
>> +					exynos_video_phy_xlate);
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>> +	for (i = 0; i < NUM_PHYS; i++) {
>> +		char label[8];
>> +
>> +		snprintf(label, sizeof(label), "%s.%d",
>> +				i == PHY_DSIM0 || i == PHY_DSIM1 ?
>> +				"dsim" : "csis", i / 2);
>> +
>> +		state->phys[i] = devm_phy_create(dev, i, &exynos_video_phy_ops,
>> +								label, state);
>> +		if (IS_ERR(state->phys[i])) {
>> +			dev_err(dev, "failed to create PHY %s\n", label);
>> +			return PTR_ERR(state->phys[i]);
>> +		}
>> +	}
> 
> this really doesn't look correct to me. It looks like you have multiple
> PHYs, one for each ID. So your probe should be called for each PHY ID
> and you have several phy_providers too.

Yes, multiple PHY objects, but a single provider. There is no need
whatsoever for multiple PHY providers.

>> +static const struct of_device_id exynos_video_phy_of_match[] = {
>> +	{ .compatible = "samsung,s5pv210-mipi-video-phy" },
> 
> and this should contain all PHY IDs:
> 
> 	{ .compatible = "samsung,s5pv210-mipi-video-dsim0-phy",
> 		.data = (const void *) DSIM0, },
> 	{ .compatible = "samsung,s5pv210-mipi-video-dsim1-phy",
> 		.data = (const void *) DSIM1, },
> 	{ .compatible = "samsung,s5pv210-mipi-video-csi0-phy"
> 		.data = (const void *) CSI0, },
> 	{ .compatible = "samsung,s5pv210-mipi-video-csi1-phy"
> 		.data = (const void *) CSI1, },
> 
> then on your probe you can fetch that data field and use it as phy->id.

This looks wrong to me, it doesn't look like a right usage of 'compatible'
property. MIPI-CSIS0/MIPI-DSIM0, MIPI-CSIS1/MIPI-DSIM1 are identical pairs,
so one compatible property would need to be used for them. We don't use
different compatible strings for different instances of same device.
And MIPI DSIM and MIPI CSIS share one MMIO register, so they need to be
handled by one provider, to synchronize accesses. That's one of the main
reasons I turned to the generic PHY framework for those devices.

>> +static struct platform_driver exynos_video_phy_driver = {
>> +	.probe	= exynos_video_phy_probe,
> 
> you *must* provide a remove method. drivers with NULL remove are
> non-removable :-)

Oops, my bad. I've forgotten to update this, after enabling build
as module. Will update and test that. It will be an empty callback
though.


Thanks,
Sylwester
