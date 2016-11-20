Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58008 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753032AbcKTPb6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 20 Nov 2016 10:31:58 -0500
Date: Sun, 20 Nov 2016 16:31:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161120153153.GD5189@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oj4kGyHlBMXGt3Le"
Content-Disposition: inline
In-Reply-To: <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--oj4kGyHlBMXGt3Le
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > +	/* V4L2_CID_EXPOSURE */
> > +	min =3D et8ek8_exposure_rows_to_us(sensor, 1);
> > +	max =3D et8ek8_exposure_rows_to_us(sensor,
> > +				sensor->current_reglist->mode.max_exp);
>=20
> Haven't I suggested to use lines instead? I vaguely remember doing so...
> this would remove quite some code from the driver.

Lines ... lines ... no, I don't think I understand how to use lines
here. I guess I could switch units from us to rows here...?

Is it good idea? For userspace, microseconds are really a nice
interface, because ... well, that's what photographers are used to
think about (ISO 400, time 1/100). fcam also uses usec internally.

In the current camera code, I do autogain in small resolution, then
use same parameters (gain, time) at higher resolution. I guess I could
do the same with the non-microseconds interface, but then I'd have to
move the microsecond computation into userspace. And userspace is
not really good place to do that, as it does not know (and should not
have to know!) such low level details.

So... can we keep the interface as it is?

Thanks,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--oj4kGyHlBMXGt3Le
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgxwekACgkQMOfwapXb+vJTMgCgsUICeBsVljgpDShQEMHWKiwK
rgwAnilLEH+dvLHuxG3DAUiTHR1f7hJw
=kDlM
-----END PGP SIGNATURE-----

--oj4kGyHlBMXGt3Le--
