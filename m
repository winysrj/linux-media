Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35866 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754430AbdCBJBr (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 04:01:47 -0500
Date: Thu, 2 Mar 2017 10:01:43 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, mchehab@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] omap3isp: add support for CSI1 bus
Message-ID: <20170302090143.GB27818@amd>
References: <20161228183036.GA13139@amd>
 <10545906.Gxg3yScdu4@avalon>
 <20170215094228.GA8586@amd>
 <2414221.XNA4JCFMRx@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Content-Disposition: inline
In-Reply-To: <2414221.XNA4JCFMRx@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > >> +
> > >> +static int isp_of_parse_node_endpoint(struct device *dev,
> > >> +				      struct device_node *node,
> > >> +				      struct isp_async_subdev *isd)
> > >> +{
> > >> +	struct isp_bus_cfg *buscfg;
> > >> +	struct v4l2_of_endpoint vep;
> > >> +	int ret;
> > >> +
> > >> +	isd->bus =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
> > >=20
> > > Why do you now need to allocate this manually ?
> >=20
> > bus is now a pointer.
>=20
> I've seen that, but why have you changed it ?

subdev support. Needs to go into separate patch. Will be done shortly.

> > >> +++ b/drivers/media/platform/omap3isp/ispccp2.c
> > >> @@ -160,6 +163,33 @@ static int ccp2_if_enable(struct isp_ccp2_device
> > >> *ccp2, u8 enable) return ret;
> > >>=20
> > >>  	}
> > >>=20
> > >> +	if (isp->revision =3D=3D ISP_REVISION_2_0) {
> > >=20
> > > The isp_csiphy.c code checks phy->isp->phy_type for the same purpose,
> > > shouldn't you use that too ?
> >=20
> > Do you want me to do phy->isp->phy_type =3D=3D ISP_PHY_TYPE_3430 check
> > here? Can do...
>=20
> Yes that's what I meant.

Ok, that's something I can do.

But code is still somewhat "interesting". Code in omap3isp_csiphy_acquire()
assumes csi2, and I don't need most of it.. so I'll just not use it,
but it looks strange. I'll post new patch shortly.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli333cACgkQMOfwapXb+vJ0kQCfTsWtvdJ9VBeNYzFJivJIetD5
j3MAn16BOfOG0Oq2dVfAEp42khmxc/8Q
=mhAp
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
