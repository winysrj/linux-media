Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53935 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751792AbaLSV7Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:24 -0500
Date: Fri, 19 Dec 2014 19:22:26 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 03/13] ARM: sunxi: Add "allwinner,sun6i-a31s" to
 mach-sunxi
Message-ID: <20141219182226.GT4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MET8MpPxp2u2c48q"
Content-Disposition: inline
In-Reply-To: <1418836704-15689-4-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--MET8MpPxp2u2c48q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 06:18:14PM +0100, Hans de Goede wrote:
> So far the A31s is 100% compatible with the A31, still lets do the same
> as what we've done for the A13 / A10s and give it its own compatible stri=
ng,
> in case we need to differentiate later.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Applied, thanks!

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--MET8MpPxp2u2c48q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlGziAAoJEBx+YmzsjxAgD/UQAJGuMifYk2mAaprQmI83kZOJ
f3LLFmlvgieV3FzOGSqMiJPh6SI6ZC0ud/0NJi1sI6ONmcSOaYmiS38u0u5lZacO
+M0mQ8OmFS49qfKIffqUZC82/K7leYCv84bOf9kMOQ6mpbX6As07Q9wY1E06EkGo
19CRzt1aDOm1KKVPbxS3AOBCkDq1FyjiBc+oL81tO8Tos85vBQ65a6JC1yI84Rlx
bsdjBUUpbuisC7uRW3eNylVTBnDvtm+YTms4xKvu5oc6qiVS6/lprPuAYSAXYm9j
jdej9hLTNT3LLIbTjmayWj9W33SOOF3N03HXH5cCw2R5B4rvW7V6Hq12TzEqzCAq
fXelcmlktpY/wtoAeHer39PO5OireyUSy5JtWzSX9xwYLNxN3uB6YWTBDEipXsLs
Nha4WPbgyp/kMKP1Ni6cDzGYHdk8oNFS9IWo/18+YpiBehRlZJmnLOxoYH8A05JW
HgN3dIH7wdpT/msLZ08nAJvIIOq41mHbtEMeeFFoHU0XydotqAcGunhaban7ngtx
fHJ3fJybqQ5eJB5JJlGFY/86TA+Y/F3qrEA0OHJOgogpDCTlLkL/4xsmGp/eaKAA
EVsItTp5BmIP7Nvzu1fZhq0uiSHewXvgZonaEpHqZbWrrQzGxa7/OOqlxRSzy6xL
nOgUd8Uex05jEjBAV5rF
=uh+1
-----END PGP SIGNATURE-----

--MET8MpPxp2u2c48q--
