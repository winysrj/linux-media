Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54200 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751297AbdBOIJN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 03:09:13 -0500
Date: Wed, 15 Feb 2017 09:09:09 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v3 1/2] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20170215080909.GA3693@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
 <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
 <20170214224750.GE11317@amd>
 <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <f3ba8ca3-0931-604e-d84c-43c0e43857db@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> On 02/15/17 00:47, Pavel Machek wrote:
> > On Tue 2017-02-14 14:20:22, Sakari Ailus wrote:
> >> Add a V4L2 control class for voice coil lens driver devices. These are
> >> simple devices that are used to move a camera lens from its resting
> >> position.
> >>
> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >=20
> > Looks good to me.
> >=20
> > I wonder... should we somehow expose the range of diopters to
> > userspace? I believe userland camera application will need that
> > information.
>=20
> It'd certainly be useful to be able to provide more information.
>=20
> The question is: where to store it, and how? It depends on the voice
> coil, the spring constant, the lens and the distance of the lens from
> the sensor --- at least. Probably the sensor size as well.
>=20
> On voice coil lenses it is also somewhat inexact.

I was thinking read-only attribute providing minimum and maximum
diopters in case there's linear relationship as on N900.

+#define V4L2_CID_VOICE_DIOPTERS_AT_REST (V4L2_CID_VOICE_COIL_CLASS_BASE + =
2)
+#define V4L2_CID_VOICE_DIOPTERS_AT_MAX (V4L2_CID_VOICE_COIL_CLASS_BASE + 3)

?

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlikDKUACgkQMOfwapXb+vKFdQCfSC8YRxOmZBBmX6TvpvFVwO9Z
d2oAn1EBIcUHXKp7FdpJi03tJnBp7v0R
=aoZh
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
