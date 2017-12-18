Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:53781 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752901AbdLROWn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Dec 2017 09:22:43 -0500
Date: Mon, 18 Dec 2017 15:22:41 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Philipp Rossak <embed3d@gmail.com>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        wens@csie.org, linux@armlinux.org.uk, sean@mess.org,
        p.zabel@pengutronix.de, andi.shyti@samsung.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/6] media: dt: bindings: Update binding documentation
 for sunxi IR controller
Message-ID: <20171218142241.6hhuyr74pxtvpoyp@flea.lan>
References: <20171218141146.23746-1-embed3d@gmail.com>
 <20171218141146.23746-3-embed3d@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="l27nkbgfnc4drjpy"
Content-Disposition: inline
In-Reply-To: <20171218141146.23746-3-embed3d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--l27nkbgfnc4drjpy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 18, 2017 at 03:11:42PM +0100, Philipp Rossak wrote:
> This patch updates documentation for Device-Tree bindings for sunxi IR
> controller and adds the new optional property for the base clock
> frequency.
>=20
> Signed-off-by: Philipp Rossak <embed3d@gmail.com>
> ---
>  Documentation/devicetree/bindings/media/sunxi-ir.txt | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Docum=
entation/devicetree/bindings/media/sunxi-ir.txt
> index 91648c569b1e..3d7f18780fae 100644
> --- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> @@ -11,6 +11,8 @@ Required properties:
>  Optional properties:
>  - linux,rc-map-name: see rc.txt file in the same directory.
>  - resets : phandle + reset specifier pair
> +- clock-frequency  : IR Receiver clock frequency, in Herz. Defaults to 8=
 MHz
                                                        ^ Hertz

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--l27nkbgfnc4drjpy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlo3zzAACgkQ0rTAlCFN
r3Twwg/+Oa+JIKmBtj5Ue6oj2o6JXFx7NcuuC/DFhReZhGfc+RDHK47/AmEjG251
cHuZgxf+1C/yeh8+/bL4Or7hXF69SfjgIbuRhLnMkePm7/Ri6kLYkreQiOibAz8v
wkqNmKpx7MPojJyUKa1wXA5VYq6kpv7KJuGk3fqC1t0NyH3fHExKTmdwX9YQLrxL
r6lK0EtFTlLrA62T7b8xGKv4NuGOGczApa2AOlyeStkhv5x6clRFQAwqC1h3D2Rb
C/0GBhEcaNJx9oIHWhyQhpQh4qrYzihFrFP1pVtMsL/ekD10nlWKWeTaojE6n5yB
wo3fgjspTu7rYN+eJtM8742uaF1mYPvtwO2BAV1ivPvonVmmUy/XmjDcZKV8qQyU
XjrcY1u9i98dRxQv38xYoQea7qtK9TWtxotROiYa/TYSl2InnyRbnp+DZofpxiGv
W/s5wgSM9Y+IP78YkFP3K/nWp1f9Q63b19x3X3Dxsxg+g3GeVB94QibTVOCxg0Qt
Oioj8OBxcTOENCFNJsoDI233js8lcNrl/Z+qHjZit7DYE5wiVVrr12y2o69y9ZMe
3gJQdO24BPQqjtkh8oFyE/YOpMOPofohN7y0VDmHg+FCSZvg5eLZwBTbN2VUvbsD
AaNR4aq6whLKIXENcQPwNGUvUXT0AkQuy5BykLjfjiuHsIVuK+s=
=U66p
-----END PGP SIGNATURE-----

--l27nkbgfnc4drjpy--
