Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36814 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932351AbeB1Toe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 28 Feb 2018 14:44:34 -0500
Date: Wed, 28 Feb 2018 20:44:30 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Claudiu Beznea <claudiu.beznea@microchip.com>
Cc: shc_work@mail.ru, kgene@kernel.org, krzk@kernel.org,
        linux@armlinux.org.uk, mturquette@baylibre.com,
        sboyd@codeaurora.org, jani.nikula@linux.intel.com,
        joonas.lahtinen@linux.intel.com, rodrigo.vivi@intel.com,
        airlied@linux.ie, kamil@wypas.org, b.zolnierkie@samsung.com,
        jdelvare@suse.com, linux@roeck-us.net, dmitry.torokhov@gmail.com,
        rpurdie@rpsys.net, jacek.anaszewski@gmail.com, pavel@ucw.cz,
        mchehab@kernel.org, sean@mess.org, lee.jones@linaro.org,
        daniel.thompson@linaro.org, jingoohan1@gmail.com, milo.kim@ti.com,
        robh+dt@kernel.org, mark.rutland@arm.com, corbet@lwn.net,
        nicolas.ferre@microchip.com, alexandre.belloni@free-electrons.com,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-clk@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 05/10] pwm: add PWM mode to pwm_config()
Message-ID: <20180228194429.GD22932@mithrandir>
References: <1519300881-8136-1-git-send-email-claudiu.beznea@microchip.com>
 <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Content-Disposition: inline
In-Reply-To: <1519300881-8136-6-git-send-email-claudiu.beznea@microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2018 at 02:01:16PM +0200, Claudiu Beznea wrote:
> Add PWM mode to pwm_config() function. The drivers which uses pwm_config()
> were adapted to this change.
>=20
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  arch/arm/mach-s3c24xx/mach-rx1950.c  | 11 +++++++++--
>  drivers/bus/ts-nbus.c                |  2 +-
>  drivers/clk/clk-pwm.c                |  3 ++-
>  drivers/gpu/drm/i915/intel_panel.c   | 17 ++++++++++++++---
>  drivers/hwmon/pwm-fan.c              |  2 +-
>  drivers/input/misc/max77693-haptic.c |  2 +-
>  drivers/input/misc/max8997_haptic.c  |  6 +++++-
>  drivers/leds/leds-pwm.c              |  5 ++++-
>  drivers/media/rc/ir-rx51.c           |  5 ++++-
>  drivers/media/rc/pwm-ir-tx.c         |  5 ++++-
>  drivers/video/backlight/lm3630a_bl.c |  4 +++-
>  drivers/video/backlight/lp855x_bl.c  |  4 +++-
>  drivers/video/backlight/lp8788_bl.c  |  5 ++++-
>  drivers/video/backlight/pwm_bl.c     | 11 +++++++++--
>  drivers/video/fbdev/ssd1307fb.c      |  3 ++-
>  include/linux/pwm.h                  |  6 ++++--
>  16 files changed, 70 insertions(+), 21 deletions(-)

I don't think it makes sense to leak mode support into the legacy API.
The pwm_config() function is considered legacy and should eventually go
away. As such it doesn't make sense to integrate a new feature such as
PWM modes into it. All users of pwm_config() assume normal mode, and
that's what pwm_config() should provide.

Anyone that needs something other than normal mode should use the new
atomic PWM API.

Thierry

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAlqXBpoACgkQ3SOs138+
s6GLrhAAuRLaoghLArJWd7JYjdi7JlVWdIer5OiGaY3qO2G2OnJBxBWctd+VJ/t+
uTtC29oNgm7jzgwf7JiGUm3yVMx/S2rW6+s0JbeVp0xXBO7Lhd6EMZbSzOC3BBHB
0RyqgEGoZRfaI++4LM9L6sMvHQ5lEt0PimKAug9MsXsxWOW88slB4Ll9Z/APl/Wr
mCWW1qN2fs2F1hQdFAhE3ujMogEfRuW0/KwFkHa223ud/i1LJNe0jkIMnEYgWsCX
x1my31QvhyMRxYQwp1FA3eAqHGnWo3yTXZYOYGBc3nJdm0UVQL59XX0UXduCVVPo
YDwxSRZn04DADA5nBXplNIpG7qsELxrLUXcnB84D6Jstz17m4NSDknnHh/XkHgS7
Q0SM/+jDqLzHHlhnCWmAJ9SBbvvrUDnXlCoMzmDoTzGN7fp74wFT1flIXILA91Lh
AF/x1TWs5HV78+fowFUWVK2Fhc0zyNGYmDd7wQ2jlKjxETDcmXH+IoRHn48bcuio
FphZkj4Un2o5X9O7jSRi5vHuJcmlHT30NsWgMduK9dWzq0wXih6zH/TTQk8N2rHM
2+eijd/BDQum2RuK8mg2klvye5jrXp7f+iT305hUYoz4fmmMddqFiybi1nUHkTkA
UG05BweYZ6hjEkpavMW0zeGEvWuZWwZZNHzKaOpJ/aRseA7Jpb0=
=zbqh
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
