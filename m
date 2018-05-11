Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:44611 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753253AbeEKOi0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:38:26 -0400
Date: Fri, 11 May 2018 16:38:24 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org
Subject: Re: [PATCH 1/1] cadence: csi2rx: Fix csi2rx_start error handling
Message-ID: <20180511143824.4euhkkokywnphx3z@flea>
References: <20180509203130.12852-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="j2cyvqwvaxvirzz7"
Content-Disposition: inline
In-Reply-To: <20180509203130.12852-1-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--j2cyvqwvaxvirzz7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 09, 2018 at 11:31:30PM +0300, Sakari Ailus wrote:
> The clocks enabled by csi2rx_start function are intended to be disabled in
> an error path but there are two issues:
>=20
> 1) the loop condition is always true and
>=20
> 2) the first clock disabled is the the one enabling of which failed.
>=20
> Fix these two bugs by changing the loop condition as well as only disabli=
ng
> the clocks that were actually enabled.
>=20
> Reported-by: Mauro Chehab <mchehab@kernel.org>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> ---
> Hi Mauro, Maxime,
>=20
> Let me know if you're happy with this. It's intended to fix the following
> warnings (C=3D1 W=3D1):
>=20
> drivers/media/platform/cadence/cdns-csi2rx.c: In function =E2=80=98csi2rx=
_start=E2=80=99:
> drivers/media/platform/cadence/cdns-csi2rx.c:177:11: warning: comparison =
of unsigned expression >=3D 0 is always true [-Wtype-limits]
>=20
>  drivers/media/platform/cadence/cdns-csi2rx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

That works for me :)

Feel free to add my Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

Thanks!
Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--j2cyvqwvaxvirzz7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr1quAACgkQ0rTAlCFN
r3TXxg/9F242N8ovNTa4krlI1VSD7lQupFxzy9MHs76W2a8pm4RJLaItM+1Q9aAX
ac1OldyQ9JPHyH4vBTajRntVOlJTrcdoQWAn6efaFswhz8ss+9pGyVYaEnicHcpE
4k5zck131dUmpVEeRYHqo/gvdmy+/EamtpIG9BVvzBNCV66P3wxbw2gW+mpO2hMm
DwJy0yIJzDMGxoOkY50eTa6mYmNscjgLKwcisaXh71NqgV6BkV7qxUdKkX9Ouojd
jVwKChpp37bfvKEUT3RTYTM/wNUSFwC979qr5EqiLdzdOpp0MJyfm16yLf+pYpWS
ITmmi+Jg4j2VkgeXrKGEj0RG6qypz+hH3kJcd3pxHUKv3djNDD34LgNx5wefVlj1
MZ1KYFWWQ7k0qusuwmqUThMPVsX3vFdvocW5Gs+G0m3MXbvhrGzdvH/lF77iYc2L
5Ct0ChDbVGLd3F1ZntezvEbc2u+Q/oXmWhDP1OUW8vbSab5ZbAbOJDMqFnYp5rri
r8Bk5ANpi+nTkYI17LJrxk8G4wn5LFf6KWc+Ab1t+v+PrmJf9Qng4VSobvNey9yV
H6VqosyhM9NfN+3j6vC1QKrBixBg2KYbooFxjU1YLH30mGEHU2U6n7EIgpEb3sDp
tNOzPvNiZB/IrN1fpsThmpnkKoQT/Hlox6i2jS+Tx44+5vGYGrs=
=TnK5
-----END PGP SIGNATURE-----

--j2cyvqwvaxvirzz7--
