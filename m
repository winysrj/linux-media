Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36558 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFWRvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 13:51:17 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: [RESEND PATCH v2 0/5] ir-rx51 driver fixes
Date: Thu, 23 Jun 2016 19:51:12 +0200
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pavel@ucw.cz
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1798920.5QaCsbmn86";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201606231951.12788@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1798920.5QaCsbmn86
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 22 June 2016 21:22:16 Ivaylo Dimitrov wrote:
> ir-rx51 is a driver for Nokia N900 IR transmitter. The current series
> fixes the remaining problems in the driver:
>=20
>  - replace GP timer 9 with PWM framework usage
>  - replace pulse width timer dmtimer usage with hrtimer
>  - add DT support to the driver
>  - add driver to the board DTS
>=20
> Patch 2 is needed so the driver to function correctly, without it PWM
> refuses to set the needed carrier frequency.
>=20
> Changes compared to v1:
>  - removed [PATCH 5/7] ARM: OMAP: dmtimer: Do not call PM runtime
>    functions when not needed.
>  - DT compatible string changed to "nokia,n900-ir"
>=20
> Ivaylo Dimitrov (5):
>   ir-rx51: Fix build after multiarch changes broke it
>   pwm: omap-dmtimer: Allow for setting dmtimer clock source
>   ir-rx51: use PWM framework instead of OMAP dmtimer
>   ir-rx51: add DT support to driver
>   ir-rx51: use hrtimer instead of dmtimer
>=20
>  .../devicetree/bindings/media/nokia,n900-ir        |  20 ++
>  .../devicetree/bindings/pwm/pwm-omap-dmtimer.txt   |   4 +
>  arch/arm/mach-omap2/board-rx51-peripherals.c       |   5 -
>  arch/arm/mach-omap2/pdata-quirks.c                 |  10 +-
>  drivers/media/rc/Kconfig                           |   2 +-
>  drivers/media/rc/ir-rx51.c                         | 229
> +++++++-------------- drivers/pwm/pwm-omap-dmtimer.c               =20
>     |  12 +- include/linux/platform_data/media/ir-rx51.h        | =20
> 3 -
>  8 files changed, 111 insertions(+), 174 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/media/nokia,n900-ir

Looks good, you can add my Acked-by.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1798920.5QaCsbmn86
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAldsIZAACgkQi/DJPQPkQ1IRJQCgvnRoCjjA9wOZApFWqdoo27s6
yM8AoMkGr22EdEV3fCzAxD4ixkuzX8fx
=tL8L
-----END PGP SIGNATURE-----

--nextPart1798920.5QaCsbmn86--
