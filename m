Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35259 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751644AbcLTMh7 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Dec 2016 07:37:59 -0500
Date: Tue, 20 Dec 2016 13:37:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        ivo.g.dimitrov.75@gmail.com, sre@kernel.org,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161220123756.GA23035@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161214130310.GA15405@pali>
 <20161214201202.GB28424@amd>
 <20161218220105.GS16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20161218220105.GS16630@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I think WARN() is good. It's a driver bug and it deserves to be notified.
=2E..
> I guess it's been like this since 2008 or so. I guess the comment could be
> simply removed, it's not a real problem.
=2E..
> AFAIR the module is called Stingray.

Ok, so it seems we are pretty good? Can you take the patch now? Device
tree documentation is in

Subject: [PATCH v6] media: et8ek8: add device tree binding documentation

and we have

Acked-by: Rob Herring <robh@kernel.org>

on that.

Thanks and best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAlhZJiQACgkQMOfwapXb+vLuGQCY0pn8gEwCqJE9M+riJ1L9h8Og
5gCfeUj6LRLjSvl5Dj66RNPiU84YzSU=
=6tQj
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
