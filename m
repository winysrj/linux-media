Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:33426 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751712AbeA3Ik2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 03:40:28 -0500
Date: Tue, 30 Jan 2018 09:40:16 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v5 5/6] arm: dts: sun8i: a83t: bananapi-m3: Enable IR
 controller
Message-ID: <20180130084016.4uyrd425qpzyiyql@flea.lan>
References: <20180129155810.7867-1-embed3d@gmail.com>
 <20180129155810.7867-6-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="q22bqurpyklj4yxv"
Content-Disposition: inline
In-Reply-To: <20180129155810.7867-6-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--q22bqurpyklj4yxv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2018 at 04:58:09PM +0100, Philipp Rossak wrote:
> The Bananapi M3 has an onboard IR receiver.
> This enables the onboard IR receiver subnode.
> Unlike the other IR receivers this one needs a base clock frequency
> of 3000000 Hz (3 MHz), to be able to work.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> Acked-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts | 7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts b/arch/arm/boot=
/dts/sun8i-a83t-bananapi-m3.dts
> index 6550bf0e594b..ffc6445fd281 100644
> --- a/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> +++ b/arch/arm/boot/dts/sun8i-a83t-bananapi-m3.dts
> @@ -82,6 +82,13 @@
>  	};
>  };
> =20
> +&cir {
> +	pinctrl-names =3D "default";
> +	pinctrl-0 =3D <&cir_pins>;

If this is the only muxing option (like your node name suggests), you
can put it directly in the DTSI to remove boilerplate from all the
DTS.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--q22bqurpyklj4yxv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlpwL28ACgkQ0rTAlCFN
r3T2bw/9FDXJX9fqsxvDAQ+/QTBJvEaexiIHZbqe1RLTQY4dXSAHocmLE1ZaJfXi
GokcTKZQp2Uy7oLnGlP00V8Hp12CSu5nA6XFVNg2xZN4k9rpsm6DjYFE5xy5ks0A
wv+b5dc9c4fouJYtP8xatYBcWXCRhxCFrmiMFNCefU7MLtu2r3Z6c8/adWxNhjI4
tgSSPh2FRAPB8bjUZgHm0WPE+rYDK2yoVN/Cebnk0jl4I1EqLfcly95nFIcaiyBR
y99A9wjuNSlLvl/e6c26ZZ04hjHMKu+iQyL/iNu/1kKG2pqnwnXIeYJQYGjNm6xm
S104zJK92rYs9CWhItbxXAompsH3cce9dCtm+zPukEh8hjCRnGKxqnrCTrNltVBr
/oq2emDXBtgz0iLrddzAuLP3LnYtUL0l5UbCqyZ7lvzXatVd3TxBHI9kFsN3FgkJ
EA+nPZEYKyQlFWK3Q8c4IUAZNG0OlS9hhWaNeQx/N9I9QELlXO8CiJPUj0VsJcpZ
EkxXJyy+0DE5NqI4L0BD4Qa9mPUe0d6/YtyksMcn7YAT25uEsgRSBdhWPD3MsrId
iBy+PYjY0QMloHGRbul+gyznjGfjSxemrRmumXp1r56VbA1voVMCg+oOrRbM1nPH
ZkeCBdfgCl94ggiaixQreHlJqYxl+d1jFspC0PR6jb1/yQUbuBM=
=+1fN
-----END PGP SIGNATURE-----

--q22bqurpyklj4yxv--
