Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46743 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944923AbdEZUlU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 16:41:20 -0400
Date: Fri, 26 May 2017 22:41:02 +0200
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
Message-ID: <20170526204102.GA22860@amd>
References: <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170426105300.GA857@amd>
 <20170426081330.6ca10e42@vento.lan>
 <20170426132337.GA6482@amd>
 <cedfd68d-d0fe-6fa8-2676-b61f3ddda652@gmail.com>
 <20170508222819.GA14833@amd>
 <db37ee9a-9675-d1db-5d2e-b0549ba004fd@xs4all.nl>
 <20170521103315.GA10716@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <20170521103315.GA10716@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Add simple SDL-based application for capturing photos. Manual
> focus/gain/exposure can be set, flash can be controlled and
> autofocus/autogain can be selected if camera supports that.
>=20
> It is already useful for testing autofocus/autogain improvements to
> the libraries on Nokia N900.
>=20
> Signed-off-by: Pavel Machek <pavel@ucw.cz>

Could I get some feedback here, or get you to apply the patch?

Thanks,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlkokt4ACgkQMOfwapXb+vI9fgCfZQ1W7FttW3QsmqXW73zx1y6u
AQUAoLSK/XX9xTLn+yOk3RGYQGhTTw0P
=Uo2F
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
