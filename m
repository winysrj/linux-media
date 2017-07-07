Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35284 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdGGQsp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 12:48:45 -0400
Date: Fri, 7 Jul 2017 18:48:43 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>
Subject: Re: [PATCH v2 4/6] [media] rc: pwm-ir-tx: add new driver
Message-ID: <20170707164843.GA13592@amd>
References: <cover.1499419624.git.sean@mess.org>
 <ae8550faaabeb0d1c9f3b65f29ea32bd8c259146.1499419624.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <ae8550faaabeb0d1c9f3b65f29ea32bd8c259146.1499419624.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2017-07-07 10:52:02, Sean Young wrote:
> This is new driver which uses pwm, so it is more power-efficient
> than the bit banging gpio-ir-tx driver.
>=20
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  MAINTAINERS                  |   6 ++
>  drivers/media/rc/Kconfig     |  12 ++++
>  drivers/media/rc/Makefile    |   1 +
>  drivers/media/rc/pwm-ir-tx.c | 138 +++++++++++++++++++++++++++++++++++++=
++++++
>  4 files changed, 157 insertions(+)
>  create mode 100644 drivers/media/rc/pwm-ir-tx.c

nothing apparently wrong.

Reviewed-by: Pavel Machek <pavel@ucw.cz>

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAllfu2sACgkQMOfwapXb+vJt/ACgs496ZAuWjPgykiTEqJOtG9NB
1/cAoMEruz7Z/rsiDh5FdyVHJ9JMoF2U
=Jz0d
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
