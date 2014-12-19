Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53972 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaLSV72 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:28 -0500
Date: Fri, 19 Dec 2014 19:34:50 +0100
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
Subject: Re: [PATCH v2 12/13] ARM: dts: sun6i: Add sun6i-a31s.dtsi
Message-ID: <20141219183450.GZ4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-13-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hNrqBtd35jzZL4Yk"
Content-Disposition: inline
In-Reply-To: <1418836704-15689-13-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--hNrqBtd35jzZL4Yk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 06:18:23PM +0100, Hans de Goede wrote:
> Add a dtsi file for A31s based boards.
>=20
> Since the  A31s is the same die as the A31 in a different package, this d=
tsi
> simply includes sun6i-a31.dtsi and then overrides the pinctrl compatible =
to
> reflect the different package, everything else is identical.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
> Changes in v2:
> -include sun6i-a31.dtsi and override the pinctrl compatible, rather then
>  copying everything
> ---
>  arch/arm/boot/dts/sun6i-a31s.dtsi | 62 +++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sun6i-a31s.dtsi
>=20
> diff --git a/arch/arm/boot/dts/sun6i-a31s.dtsi b/arch/arm/boot/dts/sun6i-=
a31s.dtsi
> new file mode 100644
> index 0000000..d0bd2b9
> --- /dev/null
> +++ b/arch/arm/boot/dts/sun6i-a31s.dtsi
> @@ -0,0 +1,62 @@
> +/*
> + * Copyright 2014 Hans de Goede <hdegoede@redhat.com>
> + *
> + * This file is dual-licensed: you can use it either under the terms
> + * of the GPL or the X11 license, at your option. Note that this dual
> + * licensing only applies to this file, and not this project as a
> + * whole.
> + *
> + *  a) This library is free software; you can redistribute it and/or
> + *     modify it under the terms of the GNU General Public License as
> + *     published by the Free Software Foundation; either version 2 of the
> + *     License, or (at your option) any later version.
> + *
> + *     This library is distributed in the hope that it will be useful,
> + *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *     GNU General Public License for more details.
> + *
> + *     You should have received a copy of the GNU General Public
> + *     License along with this library; if not, write to the Free
> + *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
> + *     MA 02110-1301 USA
> + *
> + * Or, alternatively,
> + *
> + *  b) Permission is hereby granted, free of charge, to any person
> + *     obtaining a copy of this software and associated documentation
> + *     files (the "Software"), to deal in the Software without
> + *     restriction, including without limitation the rights to use,
> + *     copy, modify, merge, publish, distribute, sublicense, and/or
> + *     sell copies of the Software, and to permit persons to whom the
> + *     Software is furnished to do so, subject to the following
> + *     conditions:
> + *
> + *     The above copyright notice and this permission notice shall be
> + *     included in all copies or substantial portions of the Software.
> + *
> + *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> + *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> + *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> + *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> + *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> + *     OTHER DEALINGS IN THE SOFTWARE.
> + */
> +
> +/*
> + * The A31s is the same die as the A31 in a different package, this is
> + * reflected by it having different pinctrl compatible everything else is
> + * identical.
> + */
> +
> +/include/ "sun6i-a31.dtsi"
> +
> +/ {
> +	soc@01c00000 {
> +		pio: pinctrl@01c20800 {
> +			compatible =3D "allwinner,sun6i-a31s-pinctrl";
> +		};
> +	};
> +};

Given your previous changes, you should also update the enable-method.

Also, for this patch and the next one, Arnd just warned me that we
shouldn't duplicate the DT path, and that we should switch to the new
trend on using label references (like what TI or Amlogic does for
example).

I'll take care on converting the existing users, but could you repost
these patches with this ?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--hNrqBtd35jzZL4Yk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlG/KAAoJEBx+YmzsjxAggLMQALBMFncEvs13h/cXsmGPv3XE
hn0AQ5zTePhBoBuEeMy0ffnIO5YwpZhA57dx5aTl2T8g8nSrlqEWShWg+JK7gjPG
uBZgrYzQb2Hcv3CM57u2hmeI/vm9g8hFoTGuQF3MvkvXoBMb3UEld0la+XIlqmGG
Q0XClbB+j//S8DimZSbW/kHJUgj+AyAZAqHEpa5UTR6rhxa/7dQ7w5qUDONZhG0P
3MWDKAgHC1Aaf1X3dKhk6eAxTxvTvhq1CstIxiiMVkiKqTTyZ3683ihPcKjmwFFy
HoRBfbtI5FF3drkIu8OqLBGksPSr2FoXbgqmN1FL8w1/KminlBNbBEs74uNFoIDf
/JjdaWAmipLhwhzUwP7VAzUxNhKVhoVIAiUuHIoLHGJAtZOzWtZVSNLZrlOk6UTS
Q98egLNhQd+g0vj1WM5ymSDHTkhzF37kbLM1c0SKCAzlkgk4dvNsWsxltCDCyqms
4fEvddFel1+hPB0Jf8KoWQ/6Xk6Oz556RVo+8UnHEbzDE7jXAltPNpNgwBKNfZub
HdiMx9ooRkcPe0y6AeaU41o1qNQc5zRru+sp3/sbpaRsZaVP5bBJhEEp/x0/HIeg
aXKHEmPTB6dLPk6fnnXiiK4sV5rKqkpqASbZr2xPLM+EPzxGckWJrQsXz7KleJEE
DU2EwoiyasTSJAmVvAUy
=4ksf
-----END PGP SIGNATURE-----

--hNrqBtd35jzZL4Yk--
