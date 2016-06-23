Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35529 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbcFWRs4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 13:48:56 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Subject: Re: [RESEND PATCH v2 1/5] ir-rx51: Fix build after multiarch changes broke it
Date: Thu, 23 Jun 2016 19:48:51 +0200
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	thierry.reding@gmail.com, bcousson@baylibre.com, tony@atomide.com,
	linux@arm.linux.org.uk, mchehab@osg.samsung.com,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-pwm@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	sre@kernel.org, pavel@ucw.cz,
	Neil Armstrong <narmstrong@baylibre.com>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com> <1466623341-30130-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
In-Reply-To: <1466623341-30130-2-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1585174.WKcMGT8M56";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201606231948.51640@pali>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--nextPart1585174.WKcMGT8M56
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 22 June 2016 21:22:17 Ivaylo Dimitrov wrote:
> The ir-rx51 driver for n900 has been disabled since the multiarch
> changes as plat include directory no longer is SoC specific.
>=20
> Let's fix it with minimal changes to pass the dmtimer calls in
> pdata. Then the following changes can be done while things can
> be tested to be working for each change:
>=20
> 1. Change the non-pwm dmtimer to use just hrtimer if possible
>=20
> 2. Change the pwm dmtimer to use Linux PWM API with the new
>    drivers/pwm/pwm-omap-dmtimer.c and remove the direct calls
>    to dmtimer functions
>=20
> 3. Parse configuration from device tree and drop the pdata
>=20
> Note compilation of this depends on the previous patch
> "ARM: OMAP2+: Add more functions to pwm pdata for ir-rx51".

I think that this extensive description is not needed for commit=20
message. Just for email discussion.

> Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Neil Armstrong <narmstrong@baylibre.com>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Acked-by: Pavel Machek <pavel@ucw.cz>
> ---

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart1585174.WKcMGT8M56
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAldsIQMACgkQi/DJPQPkQ1IJCACeKz/cuSf/mBaB43BuBBQwqXIU
6gsAoIhuqhaNZo1mFjURPiILMMJvmMd8
=h5mv
-----END PGP SIGNATURE-----

--nextPart1585174.WKcMGT8M56--
