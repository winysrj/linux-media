Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49471 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab3FZFYc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 01:24:32 -0400
Date: Wed, 26 Jun 2013 08:23:54 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: <balbi@ti.com>, Sylwester Nawrocki <s.nawrocki@samsung.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <kishon@ti.com>,
	<linux-media@vger.kernel.org>, <kyungmin.park@samsung.com>,
	<t.figa@samsung.com>, <devicetree-discuss@lists.ozlabs.org>,
	<kgene.kim@samsung.com>, <dh09.lee@samsung.com>,
	<jg1.han@samsung.com>, <inki.dae@samsung.com>,
	<plagnioj@jcrosoft.com>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130626052353.GA12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
 <51C9D714.4000703@samsung.com>
 <20130625205452.GC9748@arwen.pp.htv.fi>
 <51CA0FE1.9090107@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <51CA0FE1.9090107@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2013 at 11:47:13PM +0200, Sylwester Nawrocki wrote:
> Hi,
>=20
> On 06/25/2013 10:54 PM, Felipe Balbi wrote:
> >>>>+static int exynos_video_phy_probe(struct platform_device *pdev)
> >>>>>  >>  +{
> >>>>>  >>  +	struct exynos_video_phy *state;
> >>>>>  >>  +	struct device *dev =3D&pdev->dev;
> >>>>>  >>  +	struct resource *res;
> >>>>>  >>  +	struct phy_provider *phy_provider;
> >>>>>  >>  +	int i;
> >>>>>  >>  +
> >>>>>  >>  +	state =3D devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> >>>>>  >>  +	if (!state)
> >>>>>  >>  +		return -ENOMEM;
> >>>>>  >>  +
> >>>>>  >>  +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>>  >>  +
> >>>>>  >>  +	state->regs =3D devm_ioremap_resource(dev, res);
> >>>>>  >>  +	if (IS_ERR(state->regs))
> >>>>>  >>  +		return PTR_ERR(state->regs);
> >>>>>  >>  +
> >>>>>  >>  +	dev_set_drvdata(dev, state);
> >>>>  >
> >>>>  >  you can use platform_set_drvdata(pdev, state);
> >>>
> >>>  I had it in the previous version, but changed for symmetry with
> >>>  dev_set_drvdata(). I guess those could be replaced with
> >>>  phy_{get, set}_drvdata as you suggested.
> >
> >hmm, you do need to set the drvdata() to the phy object, but also to the
> >pdev object (should you need it on a suspend/resume callback, for
> >instance). Those are separate struct device instances.
>=20
> Indeed, I somehow confused phy->dev with with phy->dev.parent. I'm going
> to just drop the above call, since the pdev drvdata is currently not
> referenced anywhere.

ok cool :-)

--=20
balbi

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRynrpAAoJEIaOsuA1yqRELnMQAIkKkzeFVgazZcFZtjVIDyjD
Aua6SmiixQs5snwi9P50OpG0Vm3nBTwiXoedE92rnICodJ2PxSvRBa2GTtF+HVJK
oy29Z/8xq0uzjoq2Q/2NwT2ak8Jz/eqxfCVwb/FsYFeBEXOrCpFCHlwrX5CwgDMK
jXnOD7dYYUTQQmCutXaWQAU8FdLk47Db7vFrMvHgp6YGzVCteATkRJWg18CIHewT
tzytJnxzT2tctm2srn7g4xHlJhGO6t/8tGPNK1IdV8KXynoXgyqV/6+dBWl8E2TD
r64E9IS2feoZdE2hVHCTv7xdjhLm5n+qeHKQLYMGGaZosR8+yVkA2a6Xg0gWSMt2
H3k6ghGwn0AY7LnoVqpmLmy+23JQleqiYP2JSi0ACPSUYSknayUClGeFs40I69cE
fLruUtcm4ZM5L5wPy5XyXwkzPmzqhtgPHxva2jBg6KxjdUhgahcE7GXAwtknnzLI
+YIxRknUXFsovXxkOKdkSioVLb/ZC08z40cM716/HdbW2Q9y4fm6CfgsduETSOEQ
YwWPea/jrXZtGQSr+2mApyLjk+aJ87LxDCbcxyRJ/Ubbu8PW+RnGeHxFgVLVE7jk
RhjfXdTAFsdLDjG2EgFUZJ5CmtuK7yLE0PR2I9V3i/Xxx9BrS9JcYTZe6Kz5ENn4
yO9SiWe/qVO11LfXXGCR
=2sMa
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
