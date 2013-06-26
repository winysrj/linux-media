Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55792 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751285Ab3FZMXc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jun 2013 08:23:32 -0400
Date: Wed, 26 Jun 2013 15:22:38 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Kishon Vijay Abraham I <kishon@ti.com>, <balbi@ti.com>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-samsung-soc@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<kyungmin.park@samsung.com>, <t.figa@samsung.com>,
	<devicetree-discuss@lists.ozlabs.org>, <kgene.kim@samsung.com>,
	<dh09.lee@samsung.com>, <jg1.han@samsung.com>,
	<inki.dae@samsung.com>, <plagnioj@jcrosoft.com>,
	<linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] phy: Add driver for Exynos MIPI CSIS/DSIM DPHYs
Message-ID: <20130626122238.GD12640@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1372170110-12993-1-git-send-email-s.nawrocki@samsung.com>
 <20130625150649.GA21334@arwen.pp.htv.fi>
 <51C9D714.4000703@samsung.com>
 <20130625205452.GC9748@arwen.pp.htv.fi>
 <51CACEBE.9000505@ti.com>
 <51CAD89E.3060800@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jz4B0QKJ3xxfGEtb"
Content-Disposition: inline
In-Reply-To: <51CAD89E.3060800@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Jz4B0QKJ3xxfGEtb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2013 at 02:03:42PM +0200, Sylwester Nawrocki wrote:
> On 06/26/2013 01:21 PM, Kishon Vijay Abraham I wrote:
> >>>>> +static int exynos_video_phy_probe(struct platform_device *pdev)
> >>>>> >>>> +{
> >>>>> >>>> +	struct exynos_video_phy *state;
> >>>>> >>>> +	struct device *dev =3D &pdev->dev;
> >>>>> >>>> +	struct resource *res;
> >>>>> >>>> +	struct phy_provider *phy_provider;
> >>>>> >>>> +	int i;
> >>>>> >>>> +
> >>>>> >>>> +	state =3D devm_kzalloc(dev, sizeof(*state), GFP_KERNEL);
> >>>>> >>>> +	if (!state)
> >>>>> >>>> +		return -ENOMEM;
> >>>>> >>>> +
> >>>>> >>>> +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >>>>> >>>> +
> >>>>> >>>> +	state->regs =3D devm_ioremap_resource(dev, res);
> >>>>> >>>> +	if (IS_ERR(state->regs))
> >>>>> >>>> +		return PTR_ERR(state->regs);
> >>>>> >>>> +
> >>>>> >>>> +	dev_set_drvdata(dev, state);
> >>>> >>>
> >>>> >>> you can use platform_set_drvdata(pdev, state);
> >>> >>
> >>> >> I had it in the previous version, but changed for symmetry with
> >>> >> dev_set_drvdata(). I guess those could be replaced with
> >>> >> phy_{get, set}_drvdata as you suggested.
> >
> > right. currently I was setting dev_set_drvdata of phy (core) device
> > in phy-core.c and the corresponding dev_get_drvdata in phy provider dri=
ver
> > which is little confusing.
> > So I'll add phy_set_drvdata and phy_get_drvdata in phy.h (as suggested =
by
> > Felipe) to be used by phy provider drivers. So after creating the PHY, =
the
> > phy provider should use phy_set_drvdata and in phy_ops, it can use
> > phy_get_drvdata. (I'll remove the dev_set_drvdata in phy_create).
> >=20
> > This also means _void *priv_ in phy_create is useless. So I'll be remov=
ing
> > _priv_ from phy_create.
>=20
> Yeah, sounds good. Then in the phy ops phy_get_drvdata(&phy->dev) would

phy_get_drvdata(phy);

accessing the dev pointer will be done inside the helper :-)

--=20
balbi

--Jz4B0QKJ3xxfGEtb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRyt0OAAoJEIaOsuA1yqRERVQP/AyZQwbTCqa5RcE9pEsO1HS2
d1hbQjV11Wfl/O5WQwk1MV/7+x1tdvPhOlbytfVwnKgoNPkQEoV89ntKMDl9Cl6g
YWOB1Bl4xvsmdmxopbaScTDiZy0IWG2Ilxkn4MjLtX9qqx+gFte9haNlYZMOJvgT
TlxT1GBxPfRFiqfQP7GqJ7XZ6goyE1EytqFIg4EW1rPpMujUT2lAKWyFUuEjBckz
4Vfry1oRBoYOWr0ex76AXvDOY6DlFMlv1uCXH+bJM8MltgMemNOVWv1Ozh6D71yN
Jq0T5hHl0kskAHkkQzz6SSsHBp44+o1MfaCXskFmE+BvpHZn6DsE4l5dhAW3r8BH
4GGyVRsxUfKDwVF4BeI3rY0elEMN0NNx59GzbXMoKsh+xBVikMlVrUL8iXldWFK9
qf0lVZdTo0q25KvQIhnrk53d1YscdOBbjWOxwtKffCbEfJ6XUH63gccE8/k4VRBU
xc+ylw/QfwEiCz1FrsgEgX8IcGi20B52o9VEuQuSSfRrwVwjTQbxyWWkNqVYRlAX
YjF97C9ApO4EMnWB4YRCISh0vxJMLrVW0MjUZDLPaYHPzcR2Q6MmS4L0Rv3supz5
8lpzUpPcvPc3r1/46xZxjufZt2545ntZWnPXEcXY1YZ59gY90NW2cmjS+7Q9Sbps
Pf/IBMB6mxAm266/9jjo
=FNei
-----END PGP SIGNATURE-----

--Jz4B0QKJ3xxfGEtb--
