Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46942 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752441AbdBCVHa (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 3 Feb 2017 16:07:30 -0500
Date: Fri, 3 Feb 2017 22:07:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, robh+dt@kernel.org,
        devicetree@vger.kernel.org, ivo.g.dimitrov.75@gmail.com,
        sre@kernel.org, linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devicetree: Add video bus switch
Message-ID: <20170203210728.GB18379@amd>
References: <20161023200355.GA5391@amd>
 <20161119232943.GF13965@valkosipuli.retiisi.org.uk>
 <20161214122451.GB27011@amd>
 <20161222100104.GA30917@amd>
 <20161222133938.GA30259@amd>
 <20161224152031.GA8420@amd>
 <20170203123508.GA10286@amd>
 <20170203133219.GD26759@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <20170203133219.GD26759@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-02-03 14:32:19, Pali Roh=E1r wrote:
> On Friday 03 February 2017 13:35:08 Pavel Machek wrote:
> > N900 contains front and back camera, with a switch between the
> > two. This adds support for the switch component, and it is now
> > possible to select between front and back cameras during runtime.
>=20
> IIRC for controlling cameras on N900 there are two GPIOs. Should not you
> have both in switch driver?

I guess you recall wrongly :-). Switch seems to work. The issue was
with switch GPIO also serving as reset GPIO for one sensor, or
something like that, if _I_ recall correctly ;-).

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAliU8RAACgkQMOfwapXb+vJuGwCeJg/gENrQJmdW+OVEQLMaf80z
D/MAnA/u65YzW2dhO+g5sSVhaNIp6nra
=k0UH
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
