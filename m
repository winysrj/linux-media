Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59045 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753820AbcLXOgU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 24 Dec 2016 09:36:20 -0500
Date: Sat, 24 Dec 2016 15:26:57 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, ivo.g.dimitrov.75@gmail.com,
        pali.rohar@gmail.com, linux-media@vger.kernel.org,
        galak@codeaurora.org, mchehab@osg.samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH] media: Add video bus switch
Message-ID: <20161224142657.GA28257@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161222143244.ykza4wdxmop2t7bg@earth>
 <20161222224226.GB31151@amd>
 <20161222234028.oxntlek2oy62cjnh@earth>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <20161222234028.oxntlek2oy62cjnh@earth>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > So... did I understood it correctly? (Needs some work to be done...)
>=20
> I had a quick look and yes, that's basically what I had in mind to
> solve the issue. If callback is not available the old system should
> be used of course.

Ok, got it to work, thanks for all the help. I'll clean it up now.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlhehbEACgkQMOfwapXb+vIoVgCfXjQfgPrxWkze1bfOaZpnJrQL
moYAnR3t+9rFsodqigq4/ADIl+nTX6dH
=YPWF
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
