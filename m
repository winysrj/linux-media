Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:42393 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FYPHZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 11:07:25 -0400
Date: Tue, 25 Jun 2013 18:06:50 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<balbi@ti.com>, <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<inki.dae@samsung.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130625150649.GA21334@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 25, 2013 at 04:21:46PM +0200, Sylwester Nawrocki wrote:
> +enum phy_id {
> +	PHY_CSIS0,
> +	PHY_DSIM0,
> +	PHY_CSIS1,
> +	PHY_DSIM1,
> +	NUM_PHYS

please prepend these with EXYNOS_PHY_ or EXYNOS_MIPI_PHY_

> +struct exynos_video_phy {
> +	spinlock_t slock;
> +	struct phy *phys[NUM_PHYS];

more than one phy ? This means you should instantiate driver multiple
drivers. Each phy id should call probe again.

> +static int __set_phy_state(struct exynos_video_phy *state,
> +				enum phy_id id, unsigned int on)
> +{
> +	void __iomem *addr;
> +	unsigned long flags;
> +	u32 reg, reset;
> +
> +	if (WARN_ON(id > NUM_PHYS))
> +		return -EINVAL;

you don't want to do this, actually. It'll bug you everytime you want to
add another phy ID :-)

> +	addr =3D state->regs + EXYNOS_MIPI_PHY_CONTROL(id / 2);
> +
> +	if (id =3D=3D PHY_DSIM0 || id =3D=3D PHY_DSIM1)
> +		reset =3D EXYNOS_MIPI_PHY_MRESETN;
> +	else
> +		reset =3D EXYNOS_MIPI_PHY_SRESETN;
> +
> +	spin_lock_irqsave(&state->slock, flags);
> +	reg =3D readl(addr);
> +	if (on)
> +		reg |=3D reset;
> +	else
> +		reg &=3D ~reset;
> +	writel(reg, addr);
> +
> +	/* Clear ENABLE bit only if MRESETN, SRESETN bits are not set. */
> +	if (on)
> +		reg |=3D EXYNOS_MIPI_PHY_ENABLE;
> +	else if (!(reg & EXYNOS_MIPI_PHY_RESET_MASK))
> +		reg &=3D ~EXYNOS_MIPI_PHY_ENABLE;
> +
> +	writel(reg, addr);
> +	spin_unlock_irqrestore(&state->slock, flags);
> +
> +	pr_debug("%s(): id: %d, on: %d, addr: %#x, base: %#x\n",
> +		 __func__, id, on, (u32)addr, (u32)state->regs);

use dev_dbg() instead.

> +
> +	return 0;
> +}
> +
> +static int exynos_video_phy_power_on(struct phy *phy)
> +{
> +	struct exynos_video_phy *state =3D dev_get_drvdata(&phy->dev);

looks like we should have phy_get_drvdata() helper :-) Kishon ?

> +static struct phy *exynos_video_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct exynos_video_phy *state =3D dev_get_drvdata(dev);
> +
> +	if (WARN_ON(args->args[0] > NUM_PHYS))
> +		return NULL;

please remove this check.

> +	return state->phys[args->args[0]];

and your xlate is 'wrong'.

> +}
> +
> +static struct phy_ops exynos_video_phy_ops =3D {
> +	.power_on	=3D exynos_video_phy_power_on,
> +	.power_off	=3D exynos_video_phy_power_off,
> +	.owner		=3D THIS_MODULE,
> +};
> +
> +static int exynos_video_phy_probe(struct platform_device *pdev)
> +{
> +	struct exynos_video_phy *state;
> +	struct device *dev =3D &pdev->dev;
> +	struct resource *res;
> +	struct phy_provider *phy_provider;
> +	int i;
> +
> +	state =3D devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> +	if (!state)
> +		return -ENOMEM;
> +
> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +
> +	state->regs =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(state->regs))
> +		return PTR_ERR(state->regs);
> +
> +	dev_set_drvdata(dev, state);

you can use platform_set_drvdata(pdev, state);

same thing though, no strong feelings.

> +	phy_provider =3D devm_of_phy_provider_register(dev,
> +					exynos_video_phy_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
> +	for (i =3D 0; i < NUM_PHYS; i++) {
> +		char label[8];
> +
> +		snprintf(label, sizeof(label), "%s.%d",
> +				i =3D=3D PHY_DSIM0 || i =3D=3D PHY_DSIM1 ?
> +				"dsim" : "csis", i / 2);
> +
> +		state->phys[i] =3D devm_phy_create(dev, i, &exynos_video_phy_ops,
> +								label, state);
> +		if (IS_ERR(state->phys[i])) {
> +			dev_err(dev, "failed to create PHY %s\n", label);
> +			return PTR_ERR(state->phys[i]);
> +		}
> +	}

this really doesn't look correct to me. It looks like you have multiple
PHYs, one for each ID. So your probe should be called for each PHY ID
and you have several phy_providers too.

> +static const struct of_device_id exynos_video_phy_of_match[] =3D {
> +	{ .compatible =3D "samsung,s5pv210-mipi-video-phy" },

and this should contain all PHY IDs:

	{ .compatible =3D "samsung,s5pv210-mipi-video-dsim0-phy",
		.data =3D (const void *) DSIM0, },
	{ .compatible =3D "samsung,s5pv210-mipi-video-dsim1-phy",
		.data =3D (const void *) DSIM1, },
	{ .compatible =3D "samsung,s5pv210-mipi-video-csi0-phy"
		.data =3D (const void *) CSI0, },
	{ .compatible =3D "samsung,s5pv210-mipi-video-csi1-phy"
		.data =3D (const void *) CSI1, },

then on your probe you can fetch that data field and use it as phy->id.

> +static struct platform_driver exynos_video_phy_driver =3D {
> +	.probe	=3D exynos_video_phy_probe,

you *must* provide a remove method. drivers with NULL remove are
non-removable :-)

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRybIJAAoJEIaOsuA1yqRE2K4QAKIVYLVEAUmSfjw4QDEr95QA
shRIurhJHHmEEOWMijrXymiJ8Fuj/efB8ElSNSq0uuLq8bY2pCI6/zvLCDAFwryf
lTXmF0enwBrx8GzTVjagUhjq+MdhZayjSaYl8mhJEIaDfD+fKMe6UsoVDAUtM8Fq
sikoQ5cvHxQjIhiUa3FjK8yBhlHpBgLnz3RPmuxDZGIrWI6K/kNf55C/8R9OqWCJ
vPfU637QlKKbkYizgij9QrM97OATIz1cjvz20vDVSeqHLTjA0qmxnHq4hQZNe8OX
f62CHbClM4aRbNmb6TmqeV8WGYcklJauej7JhpznXqdau713fS0yvHbYANrBN2/N
XlMw+nO8REC7GzKwDRyFWmD1Ta47DO+5n+WHOZvEd52vDC4FuI7V3vRD179HIj/h
Y9qYGuoZrmZlzY5LfMo5FBan2XVKVlLm1+EAw2iLn6MAjOH9WgOnpmL8uVgDesh9
thk0duHIae1I9I62ocB46Nqdy6gFmxUphVX0Gg87h6TpdkRQFNoRdspe86EkaOo7
gYb5m26Rz3pyjF16eezjfpzvAXU15uNd6LXsyNK4jT+nocU3qr0x7ZYoxDrDNtu7
pXiAkd7EBOOp7gQOmrEiPsbYDbQvNj9CV6qIADQkTATc2hxBhYBARPvnv148Hq8c
cVgRnwYwot0w2J7vvavT
=kEo3
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
