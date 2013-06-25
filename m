Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52129 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab3FYUz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jun 2013 16:55:28 -0400
Date: Tue, 25 Jun 2013 23:54:52 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<t.figa@samsung.com>, <devicetree-discuss@lists.ozlabs.org>,
	<kgene.kim@samsung.com>, <dh09.lee@samsung.com>,
	<jg1.han@samsung.com>, <inki.dae@samsung.com>,
	<plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130625205452.GC9748@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
 <51C9D714.4000703@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <51C9D714.4000703@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jun 25, 2013 at 07:44:52PM +0200, Sylwester Nawrocki wrote:
> >> +struct exynos_video_phy {
> >> +	spinlock_t slock;
> >> +	struct phy *phys[NUM_PHYS];
> >=20
> > more than one phy ? This means you should instantiate driver multiple
> > drivers. Each phy id should call probe again.
>=20
> Why ? This single PHY _provider_ can well handle multiple PHYs.
> I don't see a good reason to further complicate this driver like
> this. Please note that MIPI-CSIS 0 and MIPI DSIM 0 share MMIO
> register, so does MIPI CSIS 1 and MIPI DSIM 1. There are only 2
> registers for those 4 PHYs. I could have the involved object
> multiplied, but it would have been just a waste of resources
> with no difference to the PHY consumers.

alright, I misunderstood your code then. When I looked over your id
usage I missed the "/2" part and assumed that you would have separate
EXYNOS_MIPI_PHY_CONTROL() register for each ;-)

My bad, you can disregard the other comments.

> >> +static int exynos_video_phy_probe(struct platform_device *pdev)
> >> +{
> >> +	struct exynos_video_phy *state;
> >> +	struct device *dev =3D &pdev->dev;
> >> +	struct resource *res;
> >> +	struct phy_provider *phy_provider;
> >> +	int i;
> >> +
> >> +	state =3D devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> >> +	if (!state)
> >> +		return -ENOMEM;
> >> +
> >> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +
> >> +	state->regs =3D devm_ioremap_resource(dev, res);
> >> +	if (IS_ERR(state->regs))
> >> +		return PTR_ERR(state->regs);
> >> +
> >> +	dev_set_drvdata(dev, state);
> >=20
> > you can use platform_set_drvdata(pdev, state);
>=20
> I had it in the previous version, but changed for symmetry with
> dev_set_drvdata(). I guess those could be replaced with
> phy_{get, set}_drvdata as you suggested.

hmm, you do need to set the drvdata() to the phy object, but also to the
pdev object (should you need it on a suspend/resume callback, for
instance). Those are separate struct device instances.

> >> +static const struct of_device_id exynos_video_phy_of_match[] =3D {
> >> +	{ .compatible =3D "samsung,s5pv210-mipi-video-phy" },
> >=20
> > and this should contain all PHY IDs:
> >=20
> > 	{ .compatible =3D "samsung,s5pv210-mipi-video-dsim0-phy",
> > 		.data =3D (const void *) DSIM0, },
> > 	{ .compatible =3D "samsung,s5pv210-mipi-video-dsim1-phy",
> > 		.data =3D (const void *) DSIM1, },
> > 	{ .compatible =3D "samsung,s5pv210-mipi-video-csi0-phy"
> > 		.data =3D (const void *) CSI0, },
> > 	{ .compatible =3D "samsung,s5pv210-mipi-video-csi1-phy"
> > 		.data =3D (const void *) CSI1, },
> >=20
> > then on your probe you can fetch that data field and use it as phy->id.
>=20
> This looks wrong to me, it doesn't look like a right usage of 'compatible'
> property. MIPI-CSIS0/MIPI-DSIM0, MIPI-CSIS1/MIPI-DSIM1 are identical pair=
s,
> so one compatible property would need to be used for them. We don't use
> different compatible strings for different instances of same device.
> And MIPI DSIM and MIPI CSIS share one MMIO register, so they need to be
> handled by one provider, to synchronize accesses. That's one of the main
> reasons I turned to the generic PHY framework for those devices.

understood :-)

> >> +static struct platform_driver exynos_video_phy_driver =3D {
> >> +	.probe	=3D exynos_video_phy_probe,
> >=20
> > you *must* provide a remove method. drivers with NULL remove are
> > non-removable :-)
>=20
> Oops, my bad. I've forgotten to update this, after enabling build
> as module. Will update and test that. It will be an empty callback
> though.

right, because of devm.

--=20
balbi

--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRygOcAAoJEIaOsuA1yqRESeAP/3ZhQKKAuFwfSS60Q7C2Vt0Y
LFGBMMAg2vwmXmRRXEQaZtJBArYMb3sm4P6pU0gbpEfYMB38MiwgNFE9Gcli99zB
M60pcT12pa4dPr6Hrgb/oTPu5mQYHAz2EnVn2EktjFAjkSBYW6Xi1Sz0dNtfc2fs
FcT3V+nqhPdv2gMtUwI9c1k1il1Z0BpoLgVTidvM60BfyfDPKOVbHzvcxMhYMNjq
4KVN16FgBhbFKa3Bk/mMiM2T+8J5OYYlZ9MvY0lsqkMniXxm28oWG3eGCRVywvQq
ZiJboBOy5ZEdEaT4cBWs46DdLGBdlCbxYz8/QrE+tw3e8+zRSx+9cUMnKJy7NMQW
60yBngZ54Ypv8yQ9iTwYiNepDN7R76sb+L4ox9/neJUKHD2OuSf80W2rfx/wf/L4
5g2IASxt6M5MnKIIyEmsKL0UDai3P+g7OLQSMIqETzgFbxBCr2Ffu3FHUexQNRLm
BJtZePujspQahHmyHs7M1/+7qbLqoyaBipbsOI94k9r68rQ467u3P4/02F3NRE3q
WArYPuN9pPN+o+3DRXmaNmQS/qEzNvDbpaW4gRbCHflVP1QDPVlnlszFsH/gqMvQ
qLKGpA7knmJCq939J4zdz82ilroPFi/9NK7oASWHIWuYOywepCgGYpbPp7zLvts2
Xtkh7OVV7og7B81/O2dY
=cnVo
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
