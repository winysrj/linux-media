Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53870 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752927AbdLROXo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:23:44 -0500
Date: Mon, 18 Dec 2017 15:23:42 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 3/6] arm: dts: sun8i: a83t: Add the cir pin for the
 A83T
Message-ID: <20171218142342.l4ucukeqjirtgetk@flea.lan>
References: <20171218141146.23746-1-embed3d@gmail.com>
 <20171218141146.23746-4-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="u34loavh4pt4imgn"
Content-Disposition: inline
In-Reply-To: <20171218141146.23746-4-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--u34loavh4pt4imgn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2017 at 03:11:43PM +0100, Philipp Rossak wrote:
> The CIR Pin of the A83T is located at PL12.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-=
a83t.dtsi
> index de5119a2a91c..feffca8a9a24 100644
> --- a/arch/arm/boot/dts/sun8i-a83t.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
> @@ -623,6 +623,11 @@
>  				drive-strength =3D <20>;
>  				bias-pull-up;
>  			};
> +
> +			cir_pins: cir-pins@0 {
> +				pins =3D "PL12";
> +				function =3D "s_cir_rx";
> +			};

Sorry for not noticing this earlier, but the nodes should be ordered
alphabetically.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--u34loavh4pt4imgn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlo3z20ACgkQ0rTAlCFN
r3T29g/9G4u3zo0TZqwbE9bhcb+5124WWdiKIxj3y3U2jdNUvouLDVKnRLiFA6A5
oo4Eh9GR1WqAIHLt1lWPVz4XUIgc5cn3udzRrpQDUGhP0NqV6Gf3/SbslH2eQRfC
u3qYTWca/J+ywRdrSRGAWCqW7xWMgtDDXrAQfur70skQy8TJlzyhGncCMEcGVZ0u
V4wzwCvqmMlLRqbiaDetVvSo7Typm1my36doN5YncWP2cjejR0gGLlCUiCbEFikg
GBer8vMuZZUOmUIoWbpmREFz+5vqOeUhcipYVpaQAdKl2YhNmC/v8Y1XnKRR60e/
YmY4Fl2vNLq9n+UktowR80NBIFdIeIoIHl3X1t0yR8PLDsikKLITB804srkL56n8
7+KupA5lcRR/BeOsaa4n01hXjDriVfaZGDxmH+LO0forTn6xUe/hJE/3xmMTZswI
f7hg8bet0UOSRom12sVBouHzZRlvd7qPqRZDFr33fCeo9SLn77d7mesu75xG/Y48
C9Rwv6PhcXYjCbMcfslNvlYQUX+rqoSo0hWWkII6X3XlgM8ZMcLKpBB23DYSHnsk
gb78WOCQhv6xYX7hRV8h8ky87Z6vKzMHHRTwe3L/n7ODppBDNO04czyZ7Ce2jIM/
Z2TmZLgWF9cKEiaEH5+Q9uR80t/gZGr9SOPfH0NA5Ru8Z0XYD8E=
=m8qk
-----END PGP SIGNATURE-----

--u34loavh4pt4imgn--
