Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60933 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753489AbdGSLx3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 07:53:29 -0400
Date: Wed, 19 Jul 2017 13:53:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, sebastian.reichel@collabora.co.uk,
        robh@kernel.org, jacek.anaszewski@gmail.com
Subject: Re: [PATCH v1.1 1/1] v4l2-flash: Flash ops aren't mandatory
Message-ID: <20170719115327.GA23056@amd>
References: <1497433639-13101-6-git-send-email-sakari.ailus@linux.intel.com>
 <20170718173623.7821-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20170718173623.7821-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2017-07-18 20:36:23, Sakari Ailus wrote:
> None of the flash operations are mandatory and therefore there should be
> no need for the flash ops structure either. Accept NULL.

Well, ok, but is not the flash without any operations kind of useless?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--SUOF0GtieIMvvwua
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllvSDcACgkQMOfwapXb+vLNHgCdGc/m/JaVMaXLphXxDWzJy5Mc
URIAn0KblGKmyVta1/J1CSCtDo3Pik+D
=Rgsi
-----END PGP SIGNATURE-----

--SUOF0GtieIMvvwua--
