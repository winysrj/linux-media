Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33124 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932304AbdCWNWp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 23 Mar 2017 09:22:45 -0400
Date: Thu, 23 Mar 2017 14:22:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: sre@kernel.org, pali.rohar@gmail.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, laurent.pinchart@ideasonboard.com,
        mchehab@kernel.org, ivo.g.dimitrov.75@gmail.com
Subject: Re: Updates, autofocus, 5Mpix mode on N900? Re: [RFC 08/13]
 smiapp-pll: Take existing divisor into account in minimum divisor check
Message-ID: <20170323132242.GA8563@amd>
References: <20170214134004.GA8570@amd>
 <20170214220503.GO16975@valkosipuli.retiisi.org.uk>
 <20170215112757.GA8974@amd>
 <20170228140921.GA8917@amd>
 <20170228141620.GB3220@valkosipuli.retiisi.org.uk>
 <20170322234651.GB5831@amd>
 <20170323073207.GO10701@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <20170323073207.GO10701@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Plus I have played with v4l-utils, and managed to implement autofocus
> > and autoexposure -- it was easier than expected. I believe you
> > mentioned you had some patches to automatically initialize the
> > pipeline. Do you and can I have them?
>=20
> It was an early prototype and it wasn't really functional yet.
>=20
> Given a video node, it can find possible pipelines to the image sources w=
ith
> common formats. I.e. the ccdc -> rsz path is not available for raw
> cameras.

> C (especially without helper libraries) wasn't particularly suitable for =
the
> task, the data structures I had didn't end up too nice. What would also be
> necessary is to associate library or application specific data to entitie=
s,
> this could be as simple as key-value pairs with both key and value being
> pointers.

Could I get a copy, anyway? Need not be perfect, but starting point
would be welcome.

Thanks,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAljTzCIACgkQMOfwapXb+vK6xACfQ/Wi4sll/1xFLYAhfqwo2NeL
FpcAoJ074yDFI/Y+Qu+obx9rfgMiJME3
=t1Lw
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
