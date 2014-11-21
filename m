Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52974 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751175AbaKUIzN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 03:55:13 -0500
Date: Fri, 21 Nov 2014 09:51:07 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 4/9] rc: sunxi-cir: Add support for an optional reset
 controller
Message-ID: <20141121085107.GM24143@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-5-git-send-email-hdegoede@redhat.com>
 <20141120142831.003fb63e@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lRF4gxo9Z9M++D0O"
Content-Disposition: inline
In-Reply-To: <20141120142831.003fb63e@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--lRF4gxo9Z9M++D0O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, Nov 20, 2014 at 02:28:31PM -0200, Mauro Carvalho Chehab wrote:
> Em Thu, 20 Nov 2014 16:55:23 +0100
> Hans de Goede <hdegoede@redhat.com> escreveu:
>=20
> > On sun6i the cir block is attached to the reset controller, add support
> > for de-asserting the reset if a reset controller is specified in dt.
> >=20
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>=20
> As this is meant to be merged via some other tree:
>=20
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Again, I think it'll be perfectly fine in your tree :)

Once the documentation is updated,
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--lRF4gxo9Z9M++D0O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbvz7AAoJEBx+YmzsjxAgoDoP/RB1X7qt9AejV6y1SANDQdQV
JAwggSwpyrTFkgcS71EpbFlPmC7PEZC5cJCH5WJ1wUAxsqb7BNYaWgN7arHisORq
H6VxBbh5czCkHiVFUxVseFbERI1V12NU9vt2zVGtRf8HCOLye+xHsqb91sNUd1OM
yZQo/fNKJeB3mPVu/A0Gnx4ZGhcgsBw3VIysxrtkykNR2iwXiOJrBahQ0srTWfuW
aS4mOZlG7gCSLTWOia9lNa4b5oS1hiEeVjIJogswngNVTas7CIEKIHr9mHaiR9/W
ogifA8B055TaanmSSsX1NRPB5en1/S60VczKvBQruqon8/lwdRexCQIq19TygDr7
q/7eMzFwnKm/CmrvJQRXwcZWo4t6mP7IhineC3KbzLC23s67d4NgdetgYWhoW6Qy
+VHA9JrGDwhr6mAWngldAINROAtYzLdmpXXbL4GtgWNKldGNB+VhEihHMBUwGHeh
v9B/Tlk3R0kNPyI2jT4wUyCdTnLl/fvHNc9ujVMMrIZwVPJz1Gz6/AS31YNZlJZO
4p0hG0LzqQtl7m1GdtlBTPdFoE/wE7ce199WL1bGgmiddRE1cQ+vt9tDaM6MrosE
ngmpvcIdTWWfcBxHLlreYOhDJeA0Hc2NgqzyBJz96YI+BNuYkE6eW5pbrZsh7M1B
baCewwWTWY9+c9k2yRyZ
=n+LL
-----END PGP SIGNATURE-----

--lRF4gxo9Z9M++D0O--
