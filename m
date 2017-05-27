Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42198 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750746AbdE0VGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 27 May 2017 17:06:39 -0400
Date: Sat, 27 May 2017 23:06:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] Doc*/media/uapi: fix control name
Message-ID: <20170527210634.GA4246@amd>
References: <20170527081239.GA9484@amd>
 <20170527193035.GW29527@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20170527193035.GW29527@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2017-05-27 22:30:35, Sakari Ailus wrote:
> On Sat, May 27, 2017 at 10:12:40AM +0200, Pavel Machek wrote:
> > V4L2_CID_EXPOSURE_BIAS does not exist, fix documentation.
> >=20
> > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> >=20
> > diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Docum=
entation/media/uapi/v4l/extended-controls.rst
> > index abb1057..76c5b1a 100644
> > --- a/Documentation/media/uapi/v4l/extended-controls.rst
> > +++ b/Documentation/media/uapi/v4l/extended-controls.rst
> > @@ -2019,7 +2019,7 @@ enum v4l2_exposure_auto_type -
> >      dynamically vary the frame rate. By default this feature is disabl=
ed
> >      (0) and the frame rate must remain constant.
> > =20
> > -``V4L2_CID_EXPOSURE_BIAS (integer menu)``
> > +``V4L2_CID_AUTO_EXPOSURE_BIAS (integer menu)``
> >      Determines the automatic exposure compensation, it is effective on=
ly
> >      when ``V4L2_CID_EXPOSURE_AUTO`` control is set to ``AUTO``,
> >      ``SHUTTER_PRIORITY`` or ``APERTURE_PRIORITY``. It is expressed in
> >=20
>=20
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>=20
> Generally linux-media is enough, for other lists such as LKML this is just
> noise.

Well, this is what get_maintainer suggested. LKML is used to a lot of
traffic ;-) [I know, I am subscribed.]
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkp6loACgkQMOfwapXb+vLGVgCfT7SV37hvSQwgQHWlDiUey3O5
+34AoK4es58suOBsPk01sAn9qWcEnm3C
=u4VZ
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
