Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:54446 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817AbaGOSCv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Jul 2014 14:02:51 -0400
Date: Tue, 15 Jul 2014 13:02:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <hans.verkuil@cisco.com>, Tony Lindgren <tony@atomide.com>,
	Benoit Cousson <bcousson@baylibre.com>, <robh+dt@kernel.org>,
	<linux@arm.linux.org.uk>,
	Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
	Linux ARM Kernel Mailing List
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>, <archit@ti.com>,
	<detheridge@ti.com>, <sakari.ailus@iki.fi>,
	<laurent.pinchart@ideasonboard.com>, <devicetree@vger.kernel.org>
Subject: Re: [RFC/PATCH 5/5] ARM: dts: am437x-sk-evm: add vpfe support and
 ov2659 sensor
Message-ID: <20140715180204.GB5098@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405447012-5340-1-git-send-email-balbi@ti.com>
 <1405447012-5340-6-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <1405447012-5340-6-git-send-email-balbi@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 15, 2014 at 12:56:52PM -0500, Felipe Balbi wrote:
> From: Darren Etheridge <detheridge@ti.com>
>=20
> Adding necessary dts nodes to enable vpfe and ov2659 sensor on the correc=
t i2c

clearly this doesn't add ov2659 sensor support because we can't release
the driver for it. I'll fix the patch subject and commit log locally.

--=20
balbi

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxWycAAoJEIaOsuA1yqREKS0QAIhBMunn466IygPdJGKyabKw
OOPcUH5CYwX6LZIpEbYJSZOuOTpTvjroeElK0C+7/Z/czGNCv6ctGmzLzrk+/ixo
tZJ8wkYHfUE+MIv9jo0A8Z8+8nINloCz/j0+E9F2ULSt+PGBiXIb0gTAVjgJhne+
eWD+CISm7KPF98mBHoERsco/hfmSoB3U2R1V4BL5wsQkdtccaXCa09TsKV2F2EnA
ZWDKXPEILE0r+zrIl5PJOyTVfhFAmM7JvOY3ThiLU7xjS3RMLM6W0OCYLCaYblAT
QEtdQ3qZuisPB6kuFrZSIzhcC9vtOtybzzN//bOBKfz5AxWo19HlEFjDd7D0/PxZ
PeLRWXR/T9IEgRbfWov4pIDwvCqzDI7gWMGWixQgJqC7ZgQuvSiM+CRDj/rJZhRI
kcgi5xwEJWDu7gd5iLYfautM2zhl0vn9nTULmHLQtWdHyYGXef58EkaBWfAJM4lT
QIPOfu5BugbfAgPZiDgIgG2d/fimlJb3r1/GuNBsy35UDvUzG7UHxVafUd2rnaE8
pfF7zVIE5gCKjE33XlPkMZGE/bKJe3hc90AVwjt6hpjZIRoetYF4Cx8HczJ8OE8B
LmFAjsGmodpq4IJ6BQbZeU3Xi+EJw42vSFhaO3iPQsLrLsILEa5dIOlqfcy7AIks
hIEl/jC62g49I7iEh9fm
=gaRx
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
