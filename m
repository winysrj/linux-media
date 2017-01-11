Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:50516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932692AbdAKXzl (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 18:55:41 -0500
Date: Thu, 12 Jan 2017 00:55:35 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, devicetree@vger.kernel.org,
        ivo.g.dimitrov.75@gmail.com, sakari.ailus@iki.fi,
        pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: [PATCHv2] dt: bindings: Add support for CSI1 bus
Message-ID: <20170111235535.nfvr6vzorm5unyjr@earth>
References: <20161228183036.GA13139@amd>
 <20170111225335.GA21553@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uzj3uac3twnfssco"
Content-Disposition: inline
In-Reply-To: <20170111225335.GA21553@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--uzj3uac3twnfssco
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 11, 2017 at 11:53:35PM +0100, Pavel Machek wrote:
> From: Sakari Ailus <sakari.ailus@iki.fi>
>=20
> In the vast majority of cases the bus type is known to the driver(s)
> since a receiver or transmitter can only support a single one. There
> are cases however where different options are possible.
>=20
> The existing V4L2 OF support tries to figure out the bus type and
> parse the bus parameters based on that. This does not scale too well
> as there are multiple serial busses that share common properties.
>=20
> Some hardware also supports multiple types of busses on the same
> interfaces.
>=20
> Document the CSI1/CCP2 property strobe. It signifies the clock or
> strobe mode.
> =20
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Signed-off-by: Pavel Machek <pavel@ucw.cz>
>=20
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt=
 b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 9cd2a36..08c4498 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -76,6 +76,11 @@ Optional endpoint properties
>    mode horizontal and vertical synchronization signals are provided to t=
he
>    slave device (data source) by the master device (data sink). In the ma=
ster
>    mode the data source device is also the source of the synchronization =
signals.
> +- bus-type: data bus type. Possible values are:
> +  0 - MIPI CSI2
> +  1 - parallel / Bt656
> +  2 - MIPI CSI1
> +  3 - CCP2
>  - bus-width: number of data lines actively used, valid for the parallel =
busses.
>  - data-shift: on the parallel data busses, if bus-width is used to speci=
fy the
>    number of data lines, data-shift can be used to specify which data lin=
es are
> @@ -112,7 +117,8 @@ Optional endpoint properties
>    should be the combined length of data-lanes and clock-lanes properties.
>    If the lane-polarities property is omitted, the value must be interpre=
ted
>    as 0 (normal). This property is valid for serial busses only.
> -
> +- strobe: Whether the clock signal is used as clock or strobe. Used
> +  with CCP2, for instance.
> =20
>  Example
>  -------
>=20
>=20

Reviewed-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--uzj3uac3twnfssco
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAlh2xfQACgkQ2O7X88g7
+pqUcRAAohcSG0pZG3VUvbB+aSuTXNbICPuoMQkCbkoFcQwwebLjYwYw0Tg6ZRXw
7TIxh4E9UQrmvdX3hGqskd4tYbeZNTyKOzk4Ck2C3s2MTc/7+bfarx2B32lepa3Y
Ss54vVO+GKKduzF2eV6SbcthInyMgYmT2XN/YhzQZ7gEtwpuIEc5mfDPBMrLJlxP
u5tJW0x5lOhp44z63HPibqU4Cj0z1LtkuZB7HxdHEsYX6trcUqqZTclaWbVIvq7Y
6r5STNDXLJFWWAcfaOaZdIUMtcM3z4YwwEHuBsK1SzYKqr2IQL8Qy36aN9HCbdzo
KZ1aEkiDJS1Sy7NMqCqV3HgUKFg6siS20606py8W40gHfc0VMYcc+60WLYRrj9C2
82UTU6MsW9/xsyPDpr3nD2l2lMzbkYBdkPgxDq6UliXUD6+jnwD4QHmCei3eBXMM
lPfhtoBmUXZ37NK5niQMBny5WtfBhI78l+ihIvSID/+i9iqjkfkS9kgYaana6cLX
mkzvu8Mo45qA4dzsLUqy0JTvuBXzouZ/1b1ObJQlOEoCpCIuoeaCmOSVk02oKB5e
deGBFMn9pk2X7atf8jL3LrpN8N4eGp9y2w4lUO5rAkH1hfGmXME+tLGnm4LBtJfS
QxrNogH+SffqDvXVdAujEoMpFroPYnqvjn+wovdFfKQOlviJpto=
=/s8l
-----END PGP SIGNATURE-----

--uzj3uac3twnfssco--
