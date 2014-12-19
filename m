Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53924 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751416AbaLSV7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:23 -0500
Date: Fri, 19 Dec 2014 19:17:59 +0100
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
Subject: Re: [PATCH v2 01/13] pinctrl: sun6i: Add some missing functions
Message-ID: <20141219181759.GR4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-2-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sxhug0Teuf3tiWmo"
Content-Disposition: inline
In-Reply-To: <1418836704-15689-2-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--sxhug0Teuf3tiWmo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 06:18:12PM +0100, Hans de Goede wrote:
> While working on pinctrl for the A31s, I noticed that function 4 of
> PA15 - PA18 was missing, add these.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sxhug0Teuf3tiWmo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlGvXAAoJEBx+YmzsjxAgmkUP/RiFk1KZzF5Yxkxtzay8exrN
y4LaOXm6oZpsJiEw8Oi2srMVuus6+O3LULEljEOLXAqEFyozLLklzh4dKcTCBjyO
4dzL7czXnuSHslCNKXas1ffx5U2n/j/UA10zR6B8TzYA2yO8krHB4g+TyolgUpo5
D1WDIdKCFz/ZWQUjUoGPgcw5LEi0/pRumy8f9eC6WVNsOiHq5A5GLC22vW4nBqq6
PnwmDNvgRYL+8MjTubjddAGW8I9e4ntTg+Clxo/k1vHOjwJd7VKU6Tz5Admnjrkf
RJiW3rrjE9vB+VEEzlvR1JadTVkf2loVVRNvN/erFgMlWiBUV8LU5rXSlQ5kAfnE
BkaSegIBLc70Pk3jRSDK2P3TZAJeT8BV3NEoI/wng1worH84EcuBaM7qxpEGRCgs
YJBUvHr7FHzl35ZCfkT6U7zwOpnyU46MhjaENCrEHtqiFFLONdQO7YUDv4fq0Hry
RwXt1yI09tVwgKy7tgsUGG7iRizlZ1Q130+W8W+vBcYedINadO964Ooa7yI1FCiC
WJalAFaInTKGnYEt2BZc4VL56o9h9kD+I537B/s0M3F+iUN5WWNJ/D6TK/TeMvJc
0iUMTGln7fZxh+9Jprmxtv1Yuq1IP22PlkqT2NUGKsgGt9PsX519cCKh0y6j7N//
pqOvHyUnbfeCG4oC1DKY
=lo/c
-----END PGP SIGNATURE-----

--sxhug0Teuf3tiWmo--
