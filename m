Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33264 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751707AbeA3Iio (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 03:38:44 -0500
Date: Tue, 30 Jan 2018 09:38:32 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 3/6] arm: dts: sun8i: a83t: Add the cir pin for the
 A83T
Message-ID: <20180130083832.hkcivcyrko3s7xku@flea.lan>
References: <20180129155810.7867-1-embed3d@gmail.com>
 <20180129155810.7867-4-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="64wxm6e4cwgjxphx"
Content-Disposition: inline
In-Reply-To: <20180129155810.7867-4-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--64wxm6e4cwgjxphx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, Jan 29, 2018 at 04:58:07PM +0100, Philipp Rossak wrote:
> The CIR Pin of the A83T is located at PL12.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t.dtsi | 5 +++++
>  1 file changed, 5 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-=
a83t.dtsi
> index de5119a2a91c..06e96db7c41a 100644
> --- a/arch/arm/boot/dts/sun8i-a83t.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
> @@ -617,6 +617,11 @@
>  			interrupt-controller;
>  			#interrupt-cells =3D <3>;
> =20
> +			cir_pins: cir-pins@0 {
> +				pins =3D "PL12";
> +				function =3D "s_cir_rx";
> +			};
> +

Sorry for not noticing this earlier, but this should be r_cir_pin, and
you should drop the unit-address that generates a dtc warning.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--64wxm6e4cwgjxphx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpwLwcACgkQ0rTAlCFN
r3R/5Q/+KyUnV11FiInL0yUwpZS5v0V4YJLrGkQRFqV3WVpl6gRHB3lLOvMZdmT5
6MGelxL1mcqROydU+YVL+iX1HxQWWD0IFeCfAtdyDRWnjJpBa8k3bW0NaingfSHT
LgxKh6IzCjR9u21nC1FOsP/QgsNiRnmO8+uuTloEjARqIUvOLRb/xACpYZyl4JQv
6Y780GMVyCs3seE3pctM2sCGaGBw+XUt4EvPfa3k3L8LvqRPwehLd5f4MZGIcHaT
kgGqH+jjTARhv3PdopmsPdEo0BGUUXpq10yq1z7Mp7tJhNq7QvE884ZA7JsS48/F
6IR6d2Fk+LXaIpADHjBZkwRXbL6GLa+2w0Qi4aV+bDKivqG3S/Mn9uvSXC2ndH0D
YPcC2QAcUPvuo55HRhBfuJgsqXVG3WuSzr+mBe440RKH0IEL2lCPPtrwm3n67aXy
OS1fRIxXZOOynjNhaJRC5vCfA50cwNK2rPuvlNbJNCCn5vS9EQqE5cq8kWdO9/44
ZHRqxGLLqSgNEP3JqPN6TusL53zBImB/ObyoOrDJZMf0WKkXbSDkgBTnJukaEjq8
J9rJ0d/lMzKrni9/RYLfE3/jiv7oecw/UA1NjIPCdwubjlu8kyVT93j+DB3QCX7j
tw4NAOnzp6Qa5d/aG8IyHdAXwTkFKSVchShca4E7xRAcrFfXG+0=
=3joX
-----END PGP SIGNATURE-----

--64wxm6e4cwgjxphx--
