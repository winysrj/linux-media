Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:60490 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752608AbaECRuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 May 2014 13:50:08 -0400
Date: Sat, 3 May 2014 10:49:38 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: =?utf-8?B?0JDQu9C10LrRgdCw0L3QtNGAINCR0LXRgNGB0LXQvdC10LI=?=
	<bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, rdunlap@infradead.org,
	ijc+devicetree@hellion.org.uk, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3] sunxi: Add support for consumer infrared devices
Message-ID: <20140503174938.GB15342@lukather>
References: <64a9c1e2-4db7-4486-841f-11adde303e32@googlegroups.com>
 <87de0ee4-8501-474c-b955-2fdb019c73cf@googlegroups.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <87de0ee4-8501-474c-b955-2fdb019c73cf@googlegroups.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 02:06:27AM -0700, =D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=
=B0=D0=BD=D0=B4=D1=80 =D0=91=D0=B5=D1=80=D1=81=D0=B5=D0=BD=D0=B5=D0=B2 wrot=
e:
> Also setting clock-frequency via DT is not implenented yet for sunxi=20
> clocks. I can try to add this functionality too.

The clock frequency should be on the device node, not the clock
one. On such cases, it's up to the device to call clk_set_rate and not
to expect the clock to run at the proper frequency.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZSwyAAoJEBx+YmzsjxAguTEQAI21UyNCz78ab1oHRwttseeO
fCtOpkURG3oGvQ9i+YFxq+qS7zeyYTxIjJ/fwB9Rt45jaNJZjr0IHsRioTpO3qub
VsmJrCO8gpOUh5Rjq0uV/a7c2BG3NOwyNOYrCxVwbZfYC51gwZ2beULFq4S5WHva
mN3aj2diub3YQgdJmGamhynxCf3Ofqy6DSab9dpxur0pWS37lo1X0R39PhyDuJJ+
qIVJBWentuxXP2oecF2/4Zvrv5iTlMmM/xMug1B/ualkaYg5JwxxgeJHihVVU+fS
rFnEfgYLIRkzLS3BVBK6BpA3NqlyeFa7iH14wMwv+juSb5T+oqRtRUi9X8s+0p/e
AgWw6MIGX/KsnkQyyqoHzqlmogA8O29FFl3dQqVyF7m+oO6Yu1T9NarJ+0I5A0P5
G88Pt/j42tGtqYs1UcdiLdZJhl25bi05MMBM2VD8rk9az8g4rCRq8kZWpYw9HDuV
oOhu936FVrC57bA+2cQVCtc2SJATLqAK03UZS+itjzEcV1hvP494Am6i9wWzdHuT
O57t11ZnQ6AztcD6R8jiB6ja7SDBr3yKq6ZsvufkUuE60yl0hly4O0/u5D6gUYsb
Ag9bTBVxAIUg5C/yZSpEzaxar3sMsXBIAP9ds+ufEwOp3+7cixiSLQhLpoVuyMpa
NZUfYq1yqyOsBdjPgMVo
=gztJ
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
