Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48102 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750837AbdE2Hca (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 29 May 2017 03:32:30 -0400
Date: Mon, 29 May 2017 09:32:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        pali.rohar@gmail.com, sre@kernel.org,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com
Subject: Re: [patch, libv4l]: add sdlcam example for testing digital still
 camera functionality
Message-ID: <20170529073227.GA11921@amd>
References: <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170521103315.GA10716@amd>
 <57f24742-f039-dce3-8c8f-65b114dfd7d2@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
In-Reply-To: <57f24742-f039-dce3-8c8f-65b114dfd7d2@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2017-05-29 08:13:22, Hans Verkuil wrote:
> Hi Pavel,
>=20
> On 05/21/2017 12:33 PM, Pavel Machek wrote:
> >Add simple SDL-based application for capturing photos. Manual
> >focus/gain/exposure can be set, flash can be controlled and
> >autofocus/autogain can be selected if camera supports that.
> >
> >It is already useful for testing autofocus/autogain improvements to
> >the libraries on Nokia N900.
> >
> >Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> I think this is more suitable as a github project. To be honest, I feel t=
hat
> v4l-utils already contains too many random utilities, so I prefer not to =
add
> to that.

> On the other hand, there is nothing against sharing this as on github as =
it
> certainly can be useful.

Can I get you to reconsider that?

Originally, I planed to keep the utility separate, but then I got
comments from Mauro ( https://lkml.org/lkml/2017/4/24/457 ) explaining
that hard sdl dependency is not acceptable etc, and how I should do
automake.

So I had a lot of fun with automake integration, and generally doing
things right.

So getting "we all ready have too many utilities" _now_ is quite an
unwelcome surprise.

Regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkrzosACgkQMOfwapXb+vI5eQCfW6Z0bVht7AgqkwCaD8MwHt3A
bfcAn2+d7Seu+eKIGo3P/CE0nx6g549F
=NMRs
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
