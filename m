Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:52756 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757928AbaKUIaX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Nov 2014 03:30:23 -0500
Date: Fri, 21 Nov 2014 09:26:20 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
	Emilio Lopez <emilio@elopez.com.ar>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com
Subject: Re: [PATCH 5/9] rc: sunxi-cir: Add support for the larger fifo found
 on sun5i and sun6i
Message-ID: <20141121082620.GJ24143@lukather>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
 <1416498928-1300-6-git-send-email-hdegoede@redhat.com>
 <20141120142856.16b6562d@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="apbmkPN6Hu/1dI3g"
Content-Disposition: inline
In-Reply-To: <20141120142856.16b6562d@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--apbmkPN6Hu/1dI3g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

On Thu, Nov 20, 2014 at 02:28:56PM -0200, Mauro Carvalho Chehab wrote:
> Em Thu, 20 Nov 2014 16:55:24 +0100
> Hans de Goede <hdegoede@redhat.com> escreveu:
>=20
> > Add support for the larger fifo found on sun5i and sun6i, having a sepa=
rate
> > compatible for the ir found on sun5i & sun6i also is useful if we ever =
want
> > to add ir transmit support, because the sun5i & sun6i version do not ha=
ve
> > transmit support.
> >=20
> > Note this commits also adds checking for the end-of-packet interrupt fl=
ag
> > (which was already enabled), as the fifo-data-available interrupt flag =
only
> > gets set when the trigger-level is exceeded. So far we've been getting =
away
> > with not doing this because of the low trigger-level, but this is somet=
hing
> > which we should have done since day one.
> >=20
> > Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>=20
> As this is meant to be merged via some other tree:
>=20
> Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

I think merging it through your tree would be just fine.

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--apbmkPN6Hu/1dI3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUbvcsAAoJEBx+YmzsjxAgWTkP/RTsNmPjmq4rC7DZIYDJM7B0
sBdSsIE92j60ed3h8YN5eGukNtVauL5xZjqaoKH/w2a9LY/UFJ0euw2oe89lelR9
jpRLhQ/Q//UAuZ+AnVVBf2T8dTDgixZWd3yfkeSAQ0tg995YQpriGcWKMYP3lXWn
SpMXWxiJE1AEXMuouhTwCS2lty34C28qHaPfgsSeMFY2yccAp8A6fg+cuuUDXWdO
hWc82iTyeU78E+sos/rr7tmpvG9nHoh21cwkKiutLDLKWIlGk4FWlMFl4FzSGYwc
4zDz89JmVLy4y0N9ZZxALgrxedq4DUeaOj58T298I1g0XjPrOrrAgyTew2lqyBU8
xCgYoYYvdLO446Tt1YpwoTdlhkvFH5cOrpc094NL8dvwu0gz5ng0b7zguOSMOKqy
S8xM3PvLt3PavSaMLfCog1mTZjYFHk8YRocOtZl3VkMpxQcOEQaUlJVn3OioqVEo
pa0cHVaRnGKFl5TKw5pjOaVu9rhrjJWWXa1MxY6B6N2JKj9PoUKrjJqnQfahPQqH
kTFXtacSrJWfMIBXLKmb5Jopbc+uCMIMNzhwBXsIVyAHrYKzb1cV1aoB4UO3ERzl
etmuRTyRadcYl6FGo5X282uchRM2jzglD4cW9xU6DV+hu754qzsFW0JoMJcUiIvo
F9bBN1f7syvXHBX70gPx
=x2+7
-----END PGP SIGNATURE-----

--apbmkPN6Hu/1dI3g--
