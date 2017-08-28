Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57147 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdH1LEx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Aug 2017 07:04:53 -0400
Date: Mon, 28 Aug 2017 13:04:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, javier@dowhile0.org,
        jacek.anaszewski@gmail.com
Subject: Re: [PATCH v3 2/3] leds: as3645a: Add LED flash class driver
Message-ID: <20170828110451.GB492@amd>
References: <20170823081100.11733-1-sakari.ailus@linux.intel.com>
 <20170823081100.11733-3-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20170823081100.11733-3-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed 2017-08-23 11:10:59, Sakari Ailus wrote:
> Add a LED flash class driver for the as3654a flash controller. A V4L2 fla=
sh
> driver for it already exists (drivers/media/i2c/as3645a.c), and this driv=
er
> is based on that.

We do not want to have two drivers for same hardware... how is that
supposed to work?

Yes, we might want to have both LED and v4l2 interface for a single
LED, because v4l2 is just too hairy to use, but we should not
duplicate drivers for that.

We _might_ want to do some helpers; as these LED drivers are all quite
similar, it should be possible to have "flash led driver" and just
link it to v4l2 and LED interfaces...

								Pavel
							=09

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmj+NMACgkQMOfwapXb+vIsTQCfeJ2mbl5kw0F1KRV06I5qdava
V0gAniQ/ty/wRVriN2CtcwCkzJZu04KT
=b6lL
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
