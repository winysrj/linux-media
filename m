Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:60646 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbeENIFD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 04:05:03 -0400
Date: Mon, 14 May 2018 10:04:38 +0200
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Niklas =?utf-8?Q?S=C3=B6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-renesas-soc@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        jacopo mondi <jacopo@jmondi.org>
Subject: Re: [PATCH v15 2/2] rcar-csi2: add Renesas R-Car MIPI CSI-2 receiver
 driver
Message-ID: <20180514080438.murnmys62t5g3tgf@flea>
References: <20180513191917.20681-1-niklas.soderlund+renesas@ragnatech.se>
 <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="zkofwe233cx4payr"
Content-Disposition: inline
In-Reply-To: <20180513191917.20681-3-niklas.soderlund+renesas@ragnatech.se>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--zkofwe233cx4payr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 13, 2018 at 09:19:17PM +0200, Niklas S=F6derlund wrote:
> A V4L2 driver for Renesas R-Car MIPI CSI-2 receiver. The driver
> supports the R-Car Gen3 SoCs where separate CSI-2 hardware blocks are
> connected between the video sources and the video grabbers (VIN).
>=20
> Driver is based on a prototype by Koji Matsuoka in the Renesas BSP.
>=20
> Signed-off-by: Niklas S=F6derlund <niklas.soderlund+renesas@ragnatech.se>

Reviewed-by: Maxime Ripard <maxime.ripard@bootlin.com>

Maxime

--=20
Maxime Ripard, Bootlin (formerly Free Electrons)
Embedded Linux and Kernel engineering
https://bootlin.com

--zkofwe233cx4payr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEE0VqZU19dR2zEVaqr0rTAlCFNr3QFAlr5QxUACgkQ0rTAlCFN
r3SZig/+KEOPHz8Fhx4D9RTOLiRgfcwIeGpa8P2tDX+O4hcsvJreZdj2PmqQVMVa
rGn7eYyk2WK3PW8Vxsf9VuosWwlhO3Zd0FPcyIEiTmLoF9gCnXLNExS+tLRXJOj6
Er07xfFXjMDjtVEDN6DzBDNpp1V1uKynMiFl0n2MisRWmCKVdlYxZWpBIS1sWt7U
itksM0CJNFGT9SFs97isDc01afi33+zhsrE/AhiogUBbmEf+D4FKNM7r18sVa0ly
WoivmylrGsb6v1IBQqB4FKrm3xFFldPw4zC5CMpu/wyUjjKPjxeUEa3aL58Mei8v
A+uJEmrWaI6Ns7tMYcRPKFuwwjb++SRswGjhoRM1ts3IpyTvEPekQXB4X4JEtpi1
tutp2t1Uf7buJh3jXLwJgJdOQM5uDQjpiMwtoR/1OSkOfV3TE7UvgH93AK9278Kd
jbNhzwaib/1JQDHgbP+6i33JVq7gr9R5gfSLzb1R7pApa7h4B1moAD9Fy+YOaU9x
9ZZCc1rlTNSA2aqMSl8G+PR8o19I1M1Uthb+6DFN4YJqlKg4EiOiSgS+pgtOEdFa
W9TFxK1n/KMjjxf6B8OTrn9RQ3dwXlzhZnqllXtPBb9gFzMd/OQAYDzw+KFiBBCU
k50WOgUIrP394oNeHfXKngdWf8xBcVf9aEF8uILKraZiBxUgz2w=
=3g2C
-----END PGP SIGNATURE-----

--zkofwe233cx4payr--
