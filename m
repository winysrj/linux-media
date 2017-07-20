Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54531 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933473AbdGTGu2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Jul 2017 02:50:28 -0400
Date: Thu, 20 Jul 2017 08:50:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        jacek.anaszewski@gmail.com, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/1] v4l2-flash-led-class: Document v4l2_flash_init()
 references
Message-ID: <20170720065024.GA25904@amd>
References: <20170719115934.GA23510@amd>
 <20170719224031.12133-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20170719224031.12133-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu 2017-07-20 01:40:31, Sakari Ailus wrote:
> The v4l2_flash_init() keeps a reference to the ops struct but not to the
> config struct (nor anything it contains). Document this.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

Thanks!
							Pavel
						=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllwUrAACgkQMOfwapXb+vK4UgCgorvKo4tZOMU2FKiD7yHSkV4M
Wr4AoJLuoCjOYhkAOQmlBSMAPkGyTQ6l
=9A+7
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
