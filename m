Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33334 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751628AbeA3Iji (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 03:39:38 -0500
Date: Tue, 30 Jan 2018 09:39:27 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v4 4/6] arm: dts: sun8i: a83t: Add support for the cir
 interface
Message-ID: <20180130083927.z4jcilqm3aludncb@flea.lan>
References: <20180129155810.7867-1-embed3d@gmail.com>
 <20180129155810.7867-5-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="rkwxsw3xptbos3il"
Content-Disposition: inline
In-Reply-To: <20180129155810.7867-5-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--rkwxsw3xptbos3il
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, Jan 29, 2018 at 04:58:08PM +0100, Philipp Rossak wrote:
> The cir interface is like on the H3 located at 0x01f02000 and is exactly
> the same. This patch adds support for the ir interface on the A83T.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  arch/arm/boot/dts/sun8i-a83t.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-=
a83t.dtsi
> index 06e96db7c41a..ddc0d592107f 100644
> --- a/arch/arm/boot/dts/sun8i-a83t.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
> @@ -605,6 +605,16 @@
>  			#reset-cells =3D <1>;
>  		};
> =20
> +		cir: cir@01f02000 {

r_cir: ir@1f02000

> +			compatible =3D "allwinner,sun5i-a13-ir";

You should have an A83t compatible there first.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--rkwxsw3xptbos3il
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpwLz4ACgkQ0rTAlCFN
r3QUTQ/+K2G0LlAJyeSazKoN1KZt64PQ8gZUXOIONSBiR4hsfnIpFgPwF3v1VAel
jZDHmFgK+yadwIcbCiNR8C9XTd+yDhafsenkTuieZhFz4WYNVjO9qg+BLvb5ZceI
gjrhQreyXKbUuIhJqqH4Ed6+zTEDfC6Gxr4EMV9Zqw/nvgBX0DB0gvmtuC2sxf+e
aY8y4mh5GlNl8X1/iTkYNtetaipoBpc0/klqFPemxqy1RvPwYFjQeqq/QII3zKbL
ySNskN9nXCW9rRr6kQXPfy5NLxgCYt23uUglEjfRSNUebTAvOQIIoE6kqSqIaLQ9
vmglu7jfi9gWsl8LBZd7BjcP4aSjCj048OIRSA4cEoDIugsVFKPyZ9g6app+W9Gd
ASE3Xc1hxDU1G2+Hsl5XWxbtMZPNq6+F9H/MpvTonF28tBS6e1A0Qtxjp3RmUYG4
pKsZZSVZlnvQfs9XlOCEp11DIIPsyx0YnAJnZ+VgfBCG0x9kzL+ioDJc8UU8fWiv
q5Ec0g1ae2YHZdOPIZJ6uly9t8hyLfrGlf4e4kjOXTR7+EqYj/ub/1F1D60UZxE9
9kBlv/hW0d0s4LMfaWw6g7WCalDz0wkUq5/hlU/0cOyR0koNzndG96OehiMgfj70
w7SWoJ2TIjS7mXd7TP5MA/ScfJE6uL5TiHGJ5SHYchNefNtzXBs=
=m2gq
-----END PGP SIGNATURE-----

--rkwxsw3xptbos3il--
