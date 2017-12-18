Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41588 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756998AbdLRHqb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 02:46:31 -0500
Date: Mon, 18 Dec 2017 08:46:19 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/5] media: dt: bindings: Update binding documentation
 for sunxi IR controller
Message-ID: <20171218074619.36urdgt6wnhshadf@flea.lan>
References: <20171217224547.21481-1-embed3d@gmail.com>
 <20171217224547.21481-3-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mrtqlcsyttby52cw"
Content-Disposition: inline
In-Reply-To: <20171217224547.21481-3-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--mrtqlcsyttby52cw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Dec 17, 2017 at 11:45:44PM +0100, Philipp Rossak wrote:
> This patch updates documentation for Device-Tree bindings for sunxi IR
> controller and adds the new optional property for the base clock
> frequency.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/sunxi-ir.txt | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Docum=
entation/devicetree/bindings/media/sunxi-ir.txt
> index 91648c569b1e..9f45bab07d6e 100644
> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> @@ -11,6 +11,7 @@ Required properties:
>  Optional properties:
>  - linux,rc-map-name: see rc.txt file in the same directory.
>  - resets : phandle + reset specifier pair
> +- clock-frequency  : overrides the default base clock frequency (8 MHz)

You're at least missing the unit one needs to use, but something like:
IR Receiver clock frequency, in Hertz. Defaults to 8MHz if missing.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--mrtqlcsyttby52cw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlo3ckcACgkQ0rTAlCFN
r3THnA//VbYF7OiAeHx3nPIPBMzGhVLtHeSZa3CmJqkU2CA987+nxiADIjuo0SZ/
Su+C53tstCWkUzLJs5KQrpNQSP56zoVc5InSjqhH4K4/APdJ/ueQE57xdEAIhk6y
98KChRx8gp0DzcaoZ1iGKF0y7gjUyasmR/6WAWGH/SfQy/H7cPqSQR2dLLsJZl+Y
d4szo5EVen0wwWQ1rjSS3fCEXA8702bjOZDBsxjGCemsU0bKg94q+9v+TxtRiDjv
FUIa2+DHv46Bt/Uqv43vA6SL74cJ//EmIn6xI/T4xEneeA5C49tH9jY6WF21egFJ
3oRClZ4u2rUZaVx8icha1Ab2ZiQwJ+792AlA3reHoD40ei3zOH2EKjJNxh8uOlqg
A7sNbF9Sf1dBVxrXK1HM0vZnctT126HTSyS0H2AXSwsimJ8VfnN9xDbswo6gaQEN
zsRrgPXOj8hKQAVXuG0QggyWvcgYtqfe+NYUqhJ/aatHXPQp0kzAobRIiiUHnYFd
AbNQj1jUaR/RsSGm4JHasoX7EpZE4Dm+u3gw8sDNgN3ve07zbJM+ldkSHcwl/+cd
TSNnZJkdwWzf0XMCOBkgSXOE+7toBxQCDz6XkAYyJ5acxvBaPxmKLWu8xVn9Vffw
7jSGlzNQtzoKCfWkX2Xs550aeRkiIA3GziU59n8/8tTaX5+WVcY=
=czX2
-----END PGP SIGNATURE-----

--mrtqlcsyttby52cw--
