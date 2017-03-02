Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54989 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdCBV1v (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 2 Mar 2017 16:27:51 -0500
Date: Thu, 2 Mar 2017 22:03:52 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, mchehab@kernel.org,
        ivo.g.dimitrov.75@gmail.com
Subject: Re: subdevice config into pointer (was Re: [PATCH 1/4] v4l2:
 device_register_subdev_nodes: allow calling multiple times)
Message-ID: <20170302210352.GA15572@amd>
References: <d315073f004ce46e0198fd614398e046ffe649e7.1487111824.git.pavel@ucw.cz>
 <20170302090727.GC27818@amd>
 <20170302141617.GG3220@valkosipuli.retiisi.org.uk>
 <2358884.6crJRnJuOY@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <2358884.6crJRnJuOY@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > >  static int isp_fwnode_parse(struct device *dev, struct fwnode_handle
> > >  *fwn,
> > > =20
> > >  			    struct isp_async_subdev *isd)
> > > =20
> > >  {
> > >=20
> > > -	struct isp_bus_cfg *buscfg =3D &isd->bus;
> > > +	struct isp_bus_cfg *buscfg;
> > >=20
> > >  	struct v4l2_fwnode_endpoint vfwn;
> > >  	unsigned int i;
> > >  	int ret;
> > >  	bool csi1 =3D false;
> > >=20
> > > +	buscfg =3D devm_kzalloc(dev, sizeof(*isd->bus), GFP_KERNEL);
>=20
> Given that you recently get rid of devm_kzalloc() in the driver, let's no=
t=20
> introduce a new one here.

What is wrong with devm_kzalloc()?
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAli4iLgACgkQMOfwapXb+vLsxQCfaVTmXcNuxqHZV1zKHHvNo8nw
kWoAoJUbA+6WT3Zxp7vmqSqUXEHxoFrp
=8mpL
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
