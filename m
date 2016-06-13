Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35575 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933530AbcFMSRs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 14:17:48 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: tony@atomide.com
Subject: Re: [PATCH 0/7] ir-rx51 driver fixes
Date: Mon, 13 Jun 2016 20:17:38 +0200
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, robh+dt@kernel.org,
	pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org
References: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1462634508-24961-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2117302.O8jQQWhXgW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201606132017.38629@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart2117302.O8jQQWhXgW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Saturday 07 May 2016 17:21:41 Ivaylo Dimitrov wrote:
> ir-rx51 is a driver for Nokia N900 IR transmitter. The current series
> fixes the remaining problems in the driver:
>=20
>  - replace GP timer 9 with PWM framework usage
>  - replace pulse width timer dmtimer usage with hrtimer
>  - add DT support to the driver
>  - add driver to the board DTS
>=20
> Pathes 2 and 5 are needed so the driver to function correctly,
> without those PWM either refuses to set the needed carrier frequency
> (patch 2) or there are such a delays in the PWM framework, code that
> transmission duration raises to ~5s instead of half a second.
>=20
> Ivaylo Dimitrov (6):
>   pwm: omap-dmtimer: Allow for setting dmtimer clock source
>   [media] ir-rx51: use PWM framework instead of OMAP dmtimer
>   [media] ir-rx51: add DT support to driver
>   ARM: OMAP: dmtimer: Do not call PM runtime functions when not
> needed. [media] ir-rx51: use hrtimer instead of dmtimer
>   ARM: dts: n900: enable lirc-rx51 driver
>=20
> Tony Lindgren (1):
>   ir-rx51: Fix build after multiarch changes broke it
>=20
>  .../devicetree/bindings/media/nokia,lirc-rx51      |  19 ++
>  .../devicetree/bindings/pwm/pwm-omap-dmtimer.txt   |   4 +
>  arch/arm/boot/dts/omap3-n900.dts                   |  12 ++
>  arch/arm/mach-omap2/board-rx51-peripherals.c       |   5 -
>  arch/arm/mach-omap2/pdata-quirks.c                 |  10 +-
>  arch/arm/plat-omap/dmtimer.c                       |   9 +-
>  arch/arm/plat-omap/include/plat/dmtimer.h          |   1 +
>  drivers/media/rc/Kconfig                           |   2 +-
>  drivers/media/rc/ir-rx51.c                         | 229
> +++++++-------------- drivers/pwm/pwm-omap-dmtimer.c               =20
>     |  12 +- include/linux/platform_data/media/ir-rx51.h        | =20
> 3 -
>  11 files changed, 131 insertions(+), 175 deletions(-)
>  create mode 100644
> Documentation/devicetree/bindings/media/nokia,lirc-rx51

Patch series looks good, you can add my Acked-by.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2117302.O8jQQWhXgW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlde+MIACgkQi/DJPQPkQ1JHqwCfVc9Nnh3U5SKX11pQ422ZAZCx
UjEAoL9ux0X1O0a6NAFtdmj2XYNOVzKU
=09nu
-----END PGP SIGNATURE-----

--nextPart2117302.O8jQQWhXgW--
