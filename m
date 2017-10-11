Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:52369 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752949AbdJKJYX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 05:24:23 -0400
Date: Wed, 11 Oct 2017 11:24:09 +0200
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
Message-ID: <20171011092409.ndtr3fdo2oj3zueb@flea.lan>
References: <20170922100823.18184-1-maxime.ripard@free-electrons.com>
 <20170922100823.18184-3-maxime.ripard@free-electrons.com>
 <20170929172709.GA3163@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5zjpskp5xiga25tl"
Content-Disposition: inline
In-Reply-To: <20170929172709.GA3163@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--5zjpskp5xiga25tl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Benoit,

On Fri, Sep 29, 2017 at 05:27:09PM +0000, Benoit Parrot wrote:
> > +static int csi2rx_get_resources(struct csi2rx_priv *csi2rx,
> > +				struct platform_device *pdev)
> > +{
> > +	struct resource *res;
> > +	unsigned char i;
> > +	u32 reg;
> > +
> > +	res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	csi2rx->base =3D devm_ioremap_resource(&pdev->dev, res);
> > +	if (IS_ERR(csi2rx->base))
> > +		return PTR_ERR(csi2rx->base);
> > +
> > +	csi2rx->sys_clk =3D devm_clk_get(&pdev->dev, "sys_clk");
> > +	if (IS_ERR(csi2rx->sys_clk)) {
> > +		dev_err(&pdev->dev, "Couldn't get sys clock\n");
> > +		return PTR_ERR(csi2rx->sys_clk);
> > +	}
> > +
> > +	csi2rx->p_clk =3D devm_clk_get(&pdev->dev, "p_clk");
> > +	if (IS_ERR(csi2rx->p_clk)) {
> > +		dev_err(&pdev->dev, "Couldn't get P clock\n");
> > +		return PTR_ERR(csi2rx->p_clk);
> > +	}
> > +
> > +	csi2rx->dphy =3D devm_phy_optional_get(&pdev->dev, "dphy");
> > +	if (IS_ERR(csi2rx->dphy)) {
> > +		dev_err(&pdev->dev, "Couldn't get external D-PHY\n");
> > +		return PTR_ERR(csi2rx->dphy);
> > +	}
> > +
> > +	/*
> > +	 * FIXME: Once we'll have external D-PHY support, the check
> > +	 * will need to be removed.
> > +	 */
> > +	if (csi2rx->dphy) {
> > +		dev_err(&pdev->dev, "External D-PHY not supported yet\n");
> > +		return -EINVAL;
> > +	}
>=20
> I understand that in your current environment you do not have a
> DPHY. But I am wondering in a real setup where you will have either
> an internal or an external DPHY, how are they going to interact with
> this driver or vice-versa?

It's difficult to give an answer with so little details. How would you
choose between those two PHYs? Is there a mux, or should we just power
one of the two? If that's the case, is there any use case were we
might want to power both? If not, which one should we favor, in which
situations?

I guess all those questions actually depend on the way the integration
has been done, and we're not quite there yet. I guess we could do
either a platform specific structure or a glue, depending on the
complexity. The platform specific compatible will allow us to do that
as we see fit anyway.

> > +
> > +	clk_prepare_enable(csi2rx->p_clk);
> > +	reg =3D readl(csi2rx->base + CSI2RX_DEVICE_CFG_REG);
> > +	clk_disable_unprepare(csi2rx->p_clk);
> > +
> > +	csi2rx->max_lanes =3D (reg & 7);
> > +	if (csi2rx->max_lanes > CSI2RX_LANES_MAX) {
> > +		dev_err(&pdev->dev, "Invalid number of lanes: %u\n",
> > +			csi2rx->max_lanes);
> > +		return -EINVAL;
> > +	}
> > +
> > +	csi2rx->max_streams =3D ((reg >> 4) & 7);
> > +	if (csi2rx->max_streams > CSI2RX_STREAMS_MAX) {
> > +		dev_err(&pdev->dev, "Invalid number of streams: %u\n",
> > +			csi2rx->max_streams);
> > +		return -EINVAL;
> > +	}
> > +
> > +	csi2rx->has_internal_dphy =3D (reg & BIT(3)) ? true : false;
> > +
> > +	/*
> > +	 * FIXME: Once we'll have internal D-PHY support, the check
> > +	 * will need to be removed.
> > +	 */
> > +	if (csi2rx->has_internal_dphy) {
> > +		dev_err(&pdev->dev, "Internal D-PHY not supported yet\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	for (i =3D 0; i < csi2rx->max_streams; i++) {
> > +		char clk_name[16];
> > +
> > +		snprintf(clk_name, sizeof(clk_name), "pixel_if%u_clk", i);
> > +		csi2rx->pixel_clk[i] =3D devm_clk_get(&pdev->dev, clk_name);
> > +		if (IS_ERR(csi2rx->pixel_clk[i])) {
> > +			dev_err(&pdev->dev, "Couldn't get clock %s\n", clk_name);
> > +			return PTR_ERR(csi2rx->pixel_clk[i]);
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int csi2rx_parse_dt(struct csi2rx_priv *csi2rx)
> > +{
> > +	struct v4l2_fwnode_endpoint v4l2_ep;
> > +	struct device_node *ep, *remote;
>=20
> *remote is now unused.

It's fixed, thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--5zjpskp5xiga25tl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZ3eM5AAoJEBx+YmzsjxAgJBEP/1WJ0AAKkqCJq0a/65xYxkYT
XktsmatVxFHU4Zt2nlPPY/7elB73mFb5ge+WjNh+jf5nStBRsAonIFpFdSN0NcX8
VTIF2NGEDjdqxQDCTbqZMKfImjbL6NIsnoEtjtnQrecSqPRdEnuq/vB1ZTWgzJmw
50VsKDWFiGr5kQN5k5Th8QMFSn9LRBdziq4vlTtJdxO0VGm2vJZ2rQQxgj1RDVrT
sJC16mZgg5U1IM6gkFSxox0sApzghM0vxAVeYrrfIY3OgSjobExLvkCEzIJ+A9kY
1pRsXkcFi1rAf1nA0SlfekU4mb9FfAgr7U5saOUjI7vgxaEOYMoSPbJFwBpBOVzS
BjTRS5mvI2gohsIn9WL8UIEtft4reqicrWXfMkDOLTvnD0LAIlyGdtBwrbRC7if6
ZS4d37Q6Z/MhHLwStFDs9TSeF7+EuD4Z2y1MoXb00JRqYhTtlUrulPahNfEY5SqV
cVe6TAKEeytj1Lux40zwXq2oKTuJP3NHq5gvT4tMd7tGrH62RjS1KJP0S/Ue4Nws
op97deXffRTGasRgk11lOHV6SYr4zwPwy16HmsuTmvR6qFMB5iWfu934IBjzP2wL
lAMBn5riGvpvruFi39Y181arYX9t6Qza3RFX/MvMTWzMcODwxvfdtegwD7jIJz45
EI1jukDCzplr/8XXFAo5
=dazb
-----END PGP SIGNATURE-----

--5zjpskp5xiga25tl--
