Return-path: <linux-media-owner@vger.kernel.org>
Received: from sauhun.de ([88.99.104.3]:57648 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751978AbeENVhX (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 May 2018 17:37:23 -0400
Date: Mon, 14 May 2018 23:37:20 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-i2c@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>,
        Russell King <linux@armlinux.org.uk>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        Sergey Lapin <slapin@ossfans.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-mips@linux-mips.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] i2c: i2c-gpio: move header to platform_data
Message-ID: <20180514213719.o6ceftp2quem3s7f@ninjato>
References: <20180419200015.15095-1-wsa@the-dreams.de>
 <20180419200015.15095-2-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tcoidkrh63ciwaqm"
Content-Disposition: inline
In-Reply-To: <20180419200015.15095-2-wsa@the-dreams.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--tcoidkrh63ciwaqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>  arch/arm/mach-ks8695/board-acs5k.c               | 2 +-
>  arch/arm/mach-sa1100/simpad.c                    | 2 +-
>  arch/mips/alchemy/board-gpr.c                    | 2 +-

Those still need acks...

> diff --git a/arch/arm/mach-ks8695/board-acs5k.c b/arch/arm/mach-ks8695/bo=
ard-acs5k.c
> index 937eb1d47e7b..ef835d82cdb9 100644
> --- a/arch/arm/mach-ks8695/board-acs5k.c
> +++ b/arch/arm/mach-ks8695/board-acs5k.c
> @@ -19,7 +19,7 @@
>  #include <linux/gpio/machine.h>
>  #include <linux/i2c.h>
>  #include <linux/i2c-algo-bit.h>
> -#include <linux/i2c-gpio.h>
> +#include <linux/platform_data/i2c-gpio.h>
>  #include <linux/platform_data/pca953x.h>
> =20
>  #include <linux/mtd/mtd.h>

=2E..

> diff --git a/arch/arm/mach-sa1100/simpad.c b/arch/arm/mach-sa1100/simpad.c
> index ace010479eb6..49a61e6f3c5f 100644
> --- a/arch/arm/mach-sa1100/simpad.c
> +++ b/arch/arm/mach-sa1100/simpad.c
> @@ -37,7 +37,7 @@
>  #include <linux/input.h>
>  #include <linux/gpio_keys.h>
>  #include <linux/leds.h>
> -#include <linux/i2c-gpio.h>
> +#include <linux/platform_data/i2c-gpio.h>
> =20
>  #include "generic.h"
> =20
> diff --git a/arch/mips/alchemy/board-gpr.c b/arch/mips/alchemy/board-gpr.c
> index 4e79dbd54a33..fa75d75b5ba9 100644
> --- a/arch/mips/alchemy/board-gpr.c
> +++ b/arch/mips/alchemy/board-gpr.c
> @@ -29,7 +29,7 @@
>  #include <linux/leds.h>
>  #include <linux/gpio.h>
>  #include <linux/i2c.h>
> -#include <linux/i2c-gpio.h>
> +#include <linux/platform_data/i2c-gpio.h>
>  #include <linux/gpio/machine.h>
>  #include <asm/bootinfo.h>
>  #include <asm/idle.h>

=2E.. and this was the shortened diff for those.

Greg, Russell, Ralf, James? Is it okay if I take this via my tree?

Thanks,

   Wolfram


--tcoidkrh63ciwaqm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlr6AYsACgkQFA3kzBSg
KbbazA//bpr6/qUgGIXnVTTVquilOsWl6XIWFNDxE7TweCbHbjHsf72+og1lNDGd
oqyZuuuBrNg749CO9e9mvgkefDr7q80j84bzRwj0uvmULtAB/kvHV67kepBmmqJ0
xrmTOquVT4owzbiE46lJWPMp5x1K1JII7/lsWk9Ftlq2SzZX0Z/64y9MCcod23Iq
7JaAraqsGRQAu39/DqO+oQugPqX2zPnp1BSXDIM5UUJUXBKjzdpS9JpUUJTqiVM0
9hBcYxd8aE4SQrhkiVArvELgO1gvERL13q6LNe185j+9c8Jo5ACR9mSCGi+oRzPC
4ZAtlWjluD7nXr6ZnaAd7IEg2LVnO9SSDuztnMGXN8c3taV+jb6EnhGmubuGn6yM
sug3NzFRT29jvyn3jLwZjZfJDQtuTlQz6+VtsrrIRNyrEohgWAd/ZrJJr91tV0DK
31DCDEYWZ4t0b9ZSty+EQ2LrBrxZoZo0cQ+jW1/2SI6dJbB3zLNSMyTKx56AjYR/
NGqPw5sIkpoylOkVKUOvz9VTsidTroNE49/jMzkUIaepIrO8Zh5sqSRo8W2TEuGJ
VwU/QYzKhGrOtHd5n9nXYqikcRjet+rFGSwtQQCpOKRuu7lcZZ5l6965wBGHEocu
XVJlX0I6t956kRNIEdgrAVWT1PbAHcm4ztc4NMby6j8DiozPSbw=
=rmj3
-----END PGP SIGNATURE-----

--tcoidkrh63ciwaqm--
