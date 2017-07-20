Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55314 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934472AbdGTHdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 03:33:00 -0400
Date: Thu, 20 Jul 2017 09:32:59 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] v4l: Add support for CSI-1 and CCP2 busses
Message-ID: <20170720073259.GA11817@amd>
References: <20170705230019.5461-1-sakari.ailus@linux.intel.com>
 <20170705230019.5461-6-sakari.ailus@linux.intel.com>
 <20170719163751.3fd7c891@vento.lan>
 <20170719205329.akt2tcspq7ri3xh4@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <20170719205329.akt2tcspq7ri3xh4@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > +void v4l2_fwnode_endpoint_parse_csi1_bus(struct fwnode_handle *fwnod=
e,
> > > +					 struct v4l2_fwnode_endpoint *vep,
> > > +					 u32 bus_type)
> > > +{
> > > +       struct v4l2_fwnode_bus_mipi_csi1 *bus =3D &vep->bus.mipi_csi1;
> > > +       u32 v;
> > > +
> > > +       if (!fwnode_property_read_u32(fwnode, "clock-inv", &v))
> > > +               bus->clock_inv =3D v;
=2E..
> > This function is indented with whitespaces! Next time, please check with
> > checkpatch.
> >=20
> > I fixed when merging it upstream.
>=20
> Well, what can I say?

You can probably blame Pavel copy/pasting patches from emails.

Sorry about that.

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllwXKoACgkQMOfwapXb+vJK9ACaAoSAd0zdvh1qDa1UaRK46hjl
KzoAnjZDppJJemBtSBszJuVN7KTBJNiv
=KEjs
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
