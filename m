Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33438 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbcFWIYk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Jun 2016 04:24:40 -0400
Date: Thu, 23 Jun 2016 10:24:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: robh+dt@kernel.org, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	bcousson@baylibre.com, tony@atomide.com, linux@arm.linux.org.uk,
	mchehab@osg.samsung.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pwm@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, sre@kernel.org, pali.rohar@gmail.com,
	pavel@ucw.cz
Subject: Re: [RESEND PATCH v2 2/5] pwm: omap-dmtimer: Allow for setting
 dmtimer clock source
Message-ID: <20160623082436.GB8136@ulmo.ba.sec>
References: <1466623341-30130-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <1466623341-30130-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="BwCQnh7xodEAoBMC"
Content-Disposition: inline
In-Reply-To: <1466623341-30130-3-git-send-email-ivo.g.dimitrov.75@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--BwCQnh7xodEAoBMC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2016 at 10:22:18PM +0300, Ivaylo Dimitrov wrote:
> OMAP GP timers can have different input clocks that allow different PWM
> frequencies. However, there is no other way of setting the clock source b=
ut
> through clocks or clock-names properties of the timer itself. This limits
> PWM functionality to only the frequencies allowed by the particular clock
> source. Allowing setting the clock source by PWM rather than by timer
> allows different PWMs to have different ranges by not hard-wiring the clo=
ck
> source to the timer.
>=20
> Signed-off-by: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
> Acked-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/pwm/pwm-omap-dmtimer.txt |  4 ++++
>  drivers/pwm/pwm-omap-dmtimer.c                             | 12 +++++++-=
----
>  2 files changed, 11 insertions(+), 5 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--BwCQnh7xodEAoBMC
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXa5zBAAoJEN0jrNd/PrOhwlQQAKJqIX/WVu0eYrxSyfNzKumN
r0uqDlK8kPVU2XrLSiUsZmSmSLsPWbYLxvJ6b8ONrV0/CEaj6ANuI2F9Sp94u9aU
Zgl4NUWTSKbHYACj0CWgBk4PwWIbZVUZrWOTTgh73xpo4KhEnWREZjGhiYgZhQRH
Ji6RfvoRtYpw76ORkiAZ7aO1lcPCBv/fgvC/cuC+0rAwRHHS7cMz0+nd/MC+/+O3
uM9Mcq+fs1qvQ4kJKGGDMHYTv5FkXQ/eNFmDx03EUEYvOJ57Yhy0TQREH/ZsdEfm
ELfUqP7UClhqO5/FFcn9wJxIxrQssnQkpCAOks6JIsV6nMYmBwVBapYmP7px4TNL
6CohXEyx93aG99VbO1L7jvyf1PF1aIUDiNO/qFD6ZYqpcPvlr+64AdokRtfK70a0
quZ14G7iuMiywclw6Y/CilOjf8t3GCPvIOmNk7ndiE2ca4wDAqyZ7Zohk5H58LFF
5BZLbdhGh2GYr0ju/s+jBZmq2GsQzkGEv3KsjODIsH5jMxb0v95/418cbcMWLwHh
6gSLOMiY213xvTPfYY4VOyW6vtKTV09r0s3A3d5478F2k82H8r4D898yZqRpYhOv
0yBemF/xgWy88Sgpx4wnCJNUbsdwzBs31UwVvNG7IQdnQErUlRHvL2VqOU07pzCe
75BREWFVSnfAX9zhyEog
=BVNy
-----END PGP SIGNATURE-----

--BwCQnh7xodEAoBMC--
