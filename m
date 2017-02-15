Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56450 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751421AbdBOJmc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 04:42:32 -0500
Date: Wed, 15 Feb 2017 10:42:29 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170215094228.GA8586@amd>
References: <20161228183036.GA13139@amd>
 <20170208083813.GG13854@valkosipuli.retiisi.org.uk>
 <20170208125738.GA23236@amd>
 <10545906.Gxg3yScdu4@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <10545906.Gxg3yScdu4@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > diff --git a/drivers/media/platform/omap3isp/isp.c
> > b/drivers/media/platform/omap3isp/isp.c index 0321d84..88bc7c6 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -2024,21 +2024,92 @@ enum isp_of_phy {
> >  	ISP_OF_PHY_CSIPHY2,
> >  };
> >=20
> > -static int isp_of_parse_node(struct device *dev, struct device_node *n=
ode,
> > -			     struct isp_async_subdev *isd)
> > +void __isp_of_parse_node_csi1(struct device *dev,
> > +				   struct isp_ccp2_cfg *buscfg,
> > +				   struct v4l2_of_endpoint *vep)
>=20
> This function isn't use anywhere else, you can merge it with=20
> isp_of_parse_node_csi1().

I'd prefer not to. First, it will be used separately in future, and
second, expresions would be uglier.

> > +{
> > +	buscfg->lanecfg.clk.pos =3D vep->bus.mipi_csi1.clock_lane;
> > +	buscfg->lanecfg.clk.pol =3D
> > +		vep->bus.mipi_csi1.lane_polarity[0];
> > +	dev_dbg(dev, "clock lane polarity %u, pos %u\n",
> > +		buscfg->lanecfg.clk.pol,
> > +		buscfg->lanecfg.clk.pos);
> > +
> > +	buscfg->lanecfg.data[0].pos =3D vep->bus.mipi_csi2.data_lanes[0];
> > +	buscfg->lanecfg.data[0].pol =3D
> > +		vep->bus.mipi_csi2.lane_polarities[1];
>=20
> bus.mipi_csi2 ?

Good catch. Fixed.

> > -	ret =3D v4l2_of_parse_endpoint(node, &vep);
> > -	if (ret)
> > -		return ret;
> > +	if (vep->base.port =3D=3D ISP_OF_PHY_CSIPHY1)
> > +		buscfg->interface =3D ISP_INTERFACE_CSI2C_PHY1;
> > +	else
> > +		buscfg->interface =3D ISP_INTERFACE_CSI2A_PHY2;
>=20
> I would keep this code in the caller to avoid code duplication with=20
> isp_of_parse_node_csi1().

Take a closer look. Code in _csi1 is different.

> >  		break;
> >=20
> >  	default:
> > +		return -1;
>=20
> Please use the appropriate error code.

Ok.

> > +	return 0;
> > +}
> > +
> > +static int isp_of_parse_node_endpoint(struct device *dev,
> > +				      struct device_node *node,
> > +				      struct isp_async_subdev *isd)
> > +{
> > +	struct isp_bus_cfg *buscfg;
> > +	struct v4l2_of_endpoint vep;
> > +	int ret;
> > +
> > +	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
>=20
> Why do you now need to allocate this manually ?

bus is now a pointer.

> > +	dev_dbg(dev, "parsing endpoint %s, interface %u\n", node->full_name,
> > +		vep.base.port);
> > +
> > +	if (isp_endpoint_to_buscfg(dev, vep, buscfg))
>=20
> I'm fine splitting the CSI1/CSI2 parsing code to separate functions, but =
I=20
> don't think there's a need to split isp_endpoint_to_buscfg(). You can kee=
p=20
> that part inline.

I'd prefer smaller functions here. I tried to read the original and it
was not too easy.

> > diff --git a/drivers/media/platform/omap3isp/ispccp2.c
> > b/drivers/media/platform/omap3isp/ispccp2.c index ca09523..4edb55a 1006=
44
> > --- a/drivers/media/platform/omap3isp/ispccp2.c
> > +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > @@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_device *=
ccp2,
> > u8 enable) return ret;
> >  	}
> >=20
> > +	if (isp->revision =3D=3D ISP_REVISION_2_0) {
>=20
> The isp_csiphy.c code checks phy->isp->phy_type for the same purpose,=20
> shouldn't you use that too ?

Do you want me to do phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430 check
here? Can do...

> > +		buscfg =3D &((struct isp_bus_cfg *)sensor->host_priv)->bus.ccp2;
> > +
> > +
>=20
> One blank line is enough.

Ok.

> > +		if (enable) {
> > +			csirxfe =3D OMAP343X_CONTROL_CSIRXFE_PWRDNZ |
> > +				  OMAP343X_CONTROL_CSIRXFE_RESET;
> > +
> > +			if (buscfg->phy_layer)
> > +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_SELFORM;
> > +
> > +			if (buscfg->strobe_clk_pol)
> > +				csirxfe |=3D OMAP343X_CONTROL_CSIRXFE_CSIB_INV;
> > +		} else
> > +			csirxfe =3D 0;
>=20
> You need curly braces for the else statement too.

Easy enough.

> > +
> > +		regmap_write(isp->syscon, isp->syscon_offset, csirxfe);
>=20
> Isn't this already configured by csiphy_routing_cfg_3430(), called throug=
h=20
> omap3isp_csiphy_acquire() ? You'll need to add support for the strobe/clo=
ck=20
> polarity there, but the rest should already be handled.

Let me check...

> > @@ -69,11 +69,15 @@
> >   * @V4L2_MBUS_PARALLEL:	parallel interface with hsync and vsync
> >   * @V4L2_MBUS_BT656:	parallel interface with embedded synchronisation,=
 can
> >   *			also be used for BT.1120
> > + * @V4L2_MBUS_CSI1:	MIPI CSI-1 serial interface
> > + * @V4L2_MBUS_CCP2:	CCP2 (Compact Camera Port 2)
>=20
> It would help if you could provide, in comments or in the commit message,=
 a=20
> few pointers to information about CSI-1 and CCP2.

There's not much good information :-(.

http://electronics.stackexchange.com/questions/134395/differences-between-m=
ipi-csi1-and-mipi-csi2
>=20

> >  /**
> > + * struct v4l2_of_bus_csi1 - CSI-1/CCP2 data bus structure
> > + * @clock_inv: polarity of clock/strobe signal
> > + *	       false - not inverted, true - inverted
> > + * @strobe: false - data/clock, true - data/strobe
> > + * @data_lane: the number of the data lane
> > + * @clock_lane: the number of the clock lane
> > + */
> > +struct v4l2_of_bus_mipi_csi1 {
> > +	bool clock_inv;
> > +	bool strobe;
> > +	bool lane_polarity[2];
>=20
> This field isn't documented.

Yep, automatic checker already told me. Plus, similar field elsewhere
is called "lane_polarities" but I believe "polarity" is a better name.

									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikIoQACgkQMOfwapXb+vK8cwCgpRxtFmb185i3Cz06vFmtJzkD
U1QAn1JWhXuF/dhSJxGvK8NLEqHeKZvM
=8vWi
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
