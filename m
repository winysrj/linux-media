Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40262 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751070AbcKBIPQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2016 04:15:16 -0400
Date: Wed, 2 Nov 2016 09:15:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, sre@kernel.org,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161102081512.GB21488@amd>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023203315.GC6391@amd>
 <20161031225408.GB3217@valkosipuli.retiisi.org.uk>
 <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="ZfOjI3PrQbgiZnxM"
Content-Disposition: inline
In-Reply-To: <7bf0bd23-e7fc-8dae-8d57-2477b942acbc@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >>I'll have to go through the patches, et8ek8 driver is probably not
> >>enough to get useful video. platform/video-bus-switch.c is needed for
> >>camera switching, then some omap3isp patches to bind flash and
> >>autofocus into the subdevice.
> >>
> >>Then, device tree support on n900 can be added.
> >
> >I briefly discussed with with Sebastian.
> >
> >Do you think the elusive support for the secondary camera is worth keepi=
ng
> >out the main camera from the DT in mainline? As long as there's a reason=
able
> >way to get it working, I'd just merge that. If someone ever gets the
> >secondary camera working properly and nicely with the video bus switch,
> >that's cool, we'll somehow deal with the problem then. But frankly I don=
't
> >think it's very useful even if we get there: the quality is really bad.
> >
>=20
> Yes, lets merge what we have till now, it will be way easier to improve on
> it once it is part of the mainline.
>=20
> BTW, I have (had) patched VBS working almost without problems, when it co=
mes
> to it I'll dig it.

Do you have a version that switches on runtime?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--ZfOjI3PrQbgiZnxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgZoJAACgkQMOfwapXb+vKJFwCcCi7h6H0qolU5Nar4b84SB6g0
gGAAn3KXVCZ83tTRakDbo4rgs3/bUE83
=HfZu
-----END PGP SIGNATURE-----

--ZfOjI3PrQbgiZnxM--
