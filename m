Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:49453 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753342AbdJMLsY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 13 Oct 2017 07:48:24 -0400
Date: Fri, 13 Oct 2017 13:48:22 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        Cyprian Wronka <cwronka@cadence.com>,
        Richard Sproul <sproul@cadence.com>,
        Alan Douglas <adouglas@cadence.com>,
        Steve Creaney <screaney@cadence.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>, nm@ti.com
Subject: Re: [PATCH v4 2/2] v4l: cadence: Add Cadence MIPI-CSI2 RX driver
Message-ID: <20171013114822.vem6bbgy4vw2lx77@flea.lan>
References: <20170922100823.18184-1-maxime.ripard@free-electrons.com>
 <20170922100823.18184-3-maxime.ripard@free-electrons.com>
 <20170929172709.GA3163@ti.com>
 <20171011092409.ndtr3fdo2oj3zueb@flea.lan>
 <20171011132258.GB25400@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="shlcvjfyecllhxq3"
Content-Disposition: inline
In-Reply-To: <20171011132258.GB25400@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--shlcvjfyecllhxq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Wed, Oct 11, 2017 at 01:22:59PM +0000, Benoit Parrot wrote:
> Maxime Ripard <maxime.ripard@free-electrons.com> wrote on Wed [2017-Oct-1=
1 11:24:09 +0200]:
> > On Fri, Sep 29, 2017 at 05:27:09PM +0000, Benoit Parrot wrote:
> > > > +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> > > > +				struct platform_device *pdev)
> > > > +{
> > > > +	struct resource *res;
> > > > +	unsigned char i;
> > > > +	u32 reg;
> > > > +
> > > > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > > +	csi2rx->base =3D devm_ioremap_resource(&pdev->dev, res);
> > > > +	if (IS_ERR(csi2rx->base))
> > > > +		return PTR_ERR(csi2rx->base);
> > > > +
> > > > +	csi2rx->sys_clk =3D devm_clk_get(&pdev->dev, "sys_clk");
> > > > +	if (IS_ERR(csi2rx->sys_clk)) {
> > > > +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
> > > > +		return PTR_ERR(csi2rx->sys_clk);
> > > > +	}
> > > > +
> > > > +	csi2rx->p_clk =3D devm_clk_get(&pdev->dev, "p_clk");
> > > > +	if (IS_ERR(csi2rx->p_clk)) {
> > > > +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> > > > +		return PTR_ERR(csi2rx->p_clk);
> > > > +	}
> > > > +
> > > > +	csi2rx->dphy =3D devm_phy_optional_get(&pdev->dev, "dphy");
> > > > +	if (IS_ERR(csi2rx->dphy)) {
> > > > +		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
> > > > +		return PTR_ERR(csi2rx->dphy);
> > > > +	}
> > > > +
> > > > +	/*
> > > > +	 * FIXME: Once we'll have external D-PHY support, the check
> > > > +	 * will need to be removed.
> > > > +	 */
> > > > +	if (csi2rx->dphy) {
> > > > +		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
> > > > +		return -EINVAL;
> > > > +	}
> > >=20
> > > I understand that in your current environment you do not have a
> > > DPHY. But I am wondering in a real setup where you will have either
> > > an internal or an external DPHY, how are they going to interact with
> > > this driver or vice-versa?
> >=20
> > It's difficult to give an answer with so little details. How would you
> > choose between those two PHYs? Is there a mux, or should we just power
> > one of the two? If that's the case, is there any use case were we
> > might want to power both? If not, which one should we favor, in which
> > situations?
>=20
> Oops, I guess I should clarify, in this case I did not mean we would
> have both an internal and an external DPHY. I just meant one or the other.

Ok, my bad :)

> Basically just want to see how you would actually handle a DPHY here
> whether it's internal or external?
>=20
> For instance, using direct register access from within this driver
> or make use of an separate phy driver...

So internal would be easy, the only internal D-PHY that is supposed to
be integrated is Cadence's, and its registers would be located in the
same memory region, so that driver would handle it.

In the external case, the ideal solution would be to extend the phy
framework to deal with more phy types. CSI would be a good candidate,
but we also have that issue with the DSI patches Boris has been
sending, and other phy types like USB.

The idea would be to extend it (or subclass it) to allow to pass more
configuration data that would allow to implement a D-PHY driver of its
own. That's the long term goal obviously, and we haven't started
working on that. So we might have to settle for in-drivers quirks
short term.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--shlcvjfyecllhxq3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ4KgGAAoJEBx+YmzsjxAgUDoP/0yQCqxc7xkRVvtQZQgy+iA5
3aiqOEdjASK0qLX1kEaL0mg7CWw6Tzum6iJPWhcMNeErtgLk489SDIZpPSxDKdFf
ZFAoTaxxRL5V2RoNDX2lj1RQSk4frW5GDjyK1G0oL8tP45G40UfihhVa+bErviY1
Q3uFYXtQwRuLRw8VUz52h4YUYbJZcHL+vAnNm8Sqw9gi87dr1953hUw+8WUqeb5x
/T5mowk9xeG/z3f6+o99036rFVM5GJLAAvN8SKgLZBE/zDIFRHnY0h6ydmB5JFhN
lN0zkPesgIXLEsVdCNaYTlFXC2QbzeowffN80BE9J+six6XmN/BOw9bJAYGv9aGE
dpnHOCkKka9ne1J6g1Ti/NUGoqobxQ5iJiLoyJgHNKgBqu4uveEeedY8QGZz1HfU
XvOvnVQM1ftEM6UhNUKbx1KBx3xh47pUM8CIivGWJaGjX8Adnvk+GQSlnsZHdg6W
ECtnLIP1YJaa12b1XQ4TCDRCWkmStBd1s9TzLVHbYNG+eSfsSOM1lB+QRdaEFCTm
yNcZc7Bm0/0OSxOWhNnbvugifqBZ0ESrSjW65byoHgiiHGxTsnYC4QuT5BB91eIS
MwNMN5kaJRnmBl/4kaVYnhCXocE24+ud7qgde8PK8H9Fm+a9wX6GMDra+dBc74Ar
3GvY/oKn/PkwI/NcYKzz
=qpdm
-----END PGP SIGNATURE-----

--shlcvjfyecllhxq3--
