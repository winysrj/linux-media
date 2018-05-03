Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:43770 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbeECP1D (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 3 May 2018 11:27:03 -0400
Date: Thu, 3 May 2018 17:26:59 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        andy.yeh@intel.com
Subject: Re: [PATCH 1/2] dt-bindings: media: Add "upside-down" property to
 tell sensor orientation
Message-ID: <20180503152659.x3zh3d747kdr3ymf@earth.universe>
References: <20180502213115.24000-1-sakari.ailus@linux.intel.com>
 <20180502213115.24000-2-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="shxchfnuktkao6oe"
Content-Disposition: inline
In-Reply-To: <20180502213115.24000-2-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--shxchfnuktkao6oe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 03, 2018 at 12:31:14AM +0300, Sakari Ailus wrote:
> Camera sensors are occasionally mounted upside down. In order to use such
> a sensor without having to turn every image upside down separately, most
> camera sensors support reversing the readout order by setting both
> horizontal and vertical flipping.
>=20
> This patch adds a boolean property to tell a sensor is mounted upside
> down.
>=20
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

I think the DT binding should use a rotation property instead,
similar to the panel bindings:

Documentation/devicetree/bindings/display/panel/panel.txt

-- Sebastian

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 258b8dfddf48..2a3e4ec4ea27 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -85,6 +85,9 @@ Optional properties
> =20
>  - lens-focus: A phandle to the node of the focus lens controller.
> =20
> +- upside-down: The device, typically an image sensor, is mounted upside
> +  down in the system.
> +
> =20
>  Optional endpoint properties
>  ----------------------------
> --=20
> 2.11.0
>=20

--shxchfnuktkao6oe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlrrKkAACgkQ2O7X88g7
+podKg/+OK5f7qBFjeZEesbu5HlbwbuULn9EBuht6XdgfvI9gX/LQB063mqWcTNm
bLSLFqPJQsV22KdK3gQBYTzpDqDFt14N/1p5wybm7m5TWI5r1NqnbasBwn9PxXyb
rNflL11LJOIzP1mlYJKme6mubqPCa7hU8qxYqB27bizrC7AEJhhTqLdPNDf5+YS0
Oauxp+okJzyv2Ik1x9+zfENkF1BtT4bTrqLfE5wGZNCtQknZ6g6SPYwwi+PEMEPR
KheqakOJwDEEoAKoz89E6uBh4+chK999Hzby/YcFVtbhw+oh4CLZgh4ViXBleLDc
zgNtYnZlBcPsAOSI5yRhLhFsTqGjKb7OUrAUrCGPKMX8IjH8WO64W78WvCX0gEP2
ShBP4MWZnVAFldvweTi0FQpTgCJ9JCQ291bgt/W7iO4gJu695BbKd5FHOGO6D+JR
SB73e278RFsVUmXbSfoADAXPIuWzMrdfRSrn3ZtritoCc54mmPGfkhboWT9crYUK
Sgfm/Ra6HKRFPF2wiVjlFg4en8SOeJppAnIf2ChcQo47v/rmjjxsw5kh+igXn0wG
tdzzcqg0MAiJSMLn2fhqR1OrDqvE/jdrGxzzlu7hTnkwtcdC3CPIF7KgbOn1XRnL
kuLXELJi7wMlbRCWMkbCMs1XTsZfdIg9az3wz+62uiZ1fID2HiU=
=hU9X
-----END PGP SIGNATURE-----

--shxchfnuktkao6oe--
