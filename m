Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44612 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbdBNW3P (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Feb 2017 17:29:15 -0500
Date: Tue, 14 Feb 2017 23:29:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: [RFC 07/13] v4l2: device_register_subdev_nodes: allow calling
 multiple times
Message-ID: <20170214222913.GC11317@amd>
References: <20170214134000.GA8550@amd>
 <20170214220256.GN16975@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Content-Disposition: inline
In-Reply-To: <20170214220256.GN16975@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-02-15 00:02:57, Sakari Ailus wrote:
> Hi Pavel and Sebastian,
>=20
> On Tue, Feb 14, 2017 at 02:40:00PM +0100, Pavel Machek wrote:
> > From: Sebastian Reichel <sre@kernel.org>
> >=20
> > Without this, exposure / gain controls do not work in the camera applic=
ation.
>=20
> :-)
>=20
> >=20
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > ---
> >  drivers/media/v4l2-core/v4l2-device.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >=20
> > diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2=
-core/v4l2-device.c
> > index f364cc1..b3afbe8 100644
> > --- a/drivers/media/v4l2-core/v4l2-device.c
> > +++ b/drivers/media/v4l2-core/v4l2-device.c
> > @@ -235,6 +235,9 @@ int v4l2_device_register_subdev_nodes(struct v4l2_d=
evice *v4l2_dev)
> >  		if (!(sd->flags & V4L2_SUBDEV_FL_HAS_DEVNODE))
> >  			continue;
> > =20
> > +		if(sd->devnode)
> > +			continue;
>=20
> This has been recognised as a problem but you're the first to submit a pa=
tch
> I believe. Please add an appropriate description. :-)

Ugh. Will try :-).

> s/if\(/if (/
>=20
> I think this one should go in before the rest.

Easy enough, and I'll move it to the first in the series.
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlijhLkACgkQMOfwapXb+vKDiACgjemIufJGYSEthD8TUHufdjxr
fyoAni9rgODXUtteoyrkg/bzx3Cpl3I8
=iss2
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
