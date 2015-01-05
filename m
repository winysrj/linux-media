Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:43163 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752946AbbAEJKE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jan 2015 04:10:04 -0500
Date: Mon, 5 Jan 2015 10:08:25 +0100
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
Message-ID: <20150105090825.GA31311@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-13-git-send-email-hdegoede@redhat.com>
 <20141219183450.GZ4820@lukather>
 <54954E77.4070302@redhat.com>
 <20141221223941.GC4820@lukather>
 <549820A4.9090900@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <549820A4.9090900@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 22, 2014 at 02:46:12PM +0100, Hans de Goede wrote:
> On 21-12-14 23:39, Maxime Ripard wrote:
> >On Sat, Dec 20, 2014 at 11:24:55AM +0100, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 19-12-14 19:34, Maxime Ripard wrote:
> >>>On Wed, Dec 17, 2014 at 06:18:23PM +0100, Hans de Goede wrote:
> >>>>Add a dtsi file for A31s based boards.
> >>>>
> >>>>Since the  A31s is the same die as the A31 in a different package, th=
is dtsi
> >>>>simply includes sun6i-a31.dtsi and then overrides the pinctrl compati=
ble to
> >>>>reflect the different package, everything else is identical.
> >>>>
> >>>>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>>>---
> >>>>Changes in v2:
> >>>>-include sun6i-a31.dtsi and override the pinctrl compatible, rather t=
hen
> >>>>  copying everything
> >>>>---
> >>>>  arch/arm/boot/dts/sun6i-a31s.dtsi | 62 ++++++++++++++++++++++++++++=
+++++++++++
> >>>>  1 file changed, 62 insertions(+)
> >>>>  create mode 100644 arch/arm/boot/dts/sun6i-a31s.dtsi
> >>>>
> >>>>diff --git a/arch/arm/boot/dts/sun6i-a31s.dtsi b/arch/arm/boot/dts/su=
n6i-a31s.dtsi
> >>>>new file mode 100644
> >>>>index 0000000..d0bd2b9
> >>>>--- /dev/null
> >>>>+++ b/arch/arm/boot/dts/sun6i-a31s.dtsi
> >>>>@@ -0,0 +1,62 @@
> >>>>+/*
> >>>>+ * Copyright 2014 Hans de Goede <hdegoede@redhat.com>
> >>>>+ *
> >>>>+ * This file is dual-licensed: you can use it either under the terms
> >>>>+ * of the GPL or the X11 license, at your option. Note that this dual
> >>>>+ * licensing only applies to this file, and not this project as a
> >>>>+ * whole.
> >>>>+ *
> >>>>+ *  a) This library is free software; you can redistribute it and/or
> >>>>+ *     modify it under the terms of the GNU General Public License as
> >>>>+ *     published by the Free Software Foundation; either version 2 o=
f the
> >>>>+ *     License, or (at your option) any later version.
> >>>>+ *
> >>>>+ *     This library is distributed in the hope that it will be usefu=
l,
> >>>>+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>>>+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>>>+ *     GNU General Public License for more details.
> >>>>+ *
> >>>>+ *     You should have received a copy of the GNU General Public
> >>>>+ *     License along with this library; if not, write to the Free
> >>>>+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Bosto=
n,
> >>>>+ *     MA 02110-1301 USA
> >>>>+ *
> >>>>+ * Or, alternatively,
> >>>>+ *
> >>>>+ *  b) Permission is hereby granted, free of charge, to any person
> >>>>+ *     obtaining a copy of this software and associated documentation
> >>>>+ *     files (the "Software"), to deal in the Software without
> >>>>+ *     restriction, including without limitation the rights to use,
> >>>>+ *     copy, modify, merge, publish, distribute, sublicense, and/or
> >>>>+ *     sell copies of the Software, and to permit persons to whom the
> >>>>+ *     Software is furnished to do so, subject to the following
> >>>>+ *     conditions:
> >>>>+ *
> >>>>+ *     The above copyright notice and this permission notice shall be
> >>>>+ *     included in all copies or substantial portions of the Softwar=
e.
> >>>>+ *
> >>>>+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIN=
D,
> >>>>+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTI=
ES
> >>>>+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> >>>>+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> >>>>+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> >>>>+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> >>>>+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> >>>>+ *     OTHER DEALINGS IN THE SOFTWARE.
> >>>>+ */
> >>>>+
> >>>>+/*
> >>>>+ * The A31s is the same die as the A31 in a different package, this =
is
> >>>>+ * reflected by it having different pinctrl compatible everything el=
se is
> >>>>+ * identical.
> >>>>+ */
> >>>>+
> >>>>+/include/ "sun6i-a31.dtsi"
> >>>>+
> >>>>+/ {
> >>>>+	soc@01c00000 {
> >>>>+		pio: pinctrl@01c20800 {
> >>>>+			compatible =3D "allwinner,sun6i-a31s-pinctrl";
> >>>>+		};
> >>>>+	};
> >>>>+};
> >>>
> >>>Given your previous changes, you should also update the enable-method.
> >>
> >>I've not added a new compatible for the enable-method, given that
> >>this is the exact same die, so the 2 are 100?% compatible, just like you
> >>insisted that "allwinner,sun4i-a10-mod0-clk" should be used for the ir-=
clk
> >>since it was 100% compatible to that I believe that the enable method
> >>should use the existing compatible and not invent a new one for somethi=
ng
> >>which is 100% compatible.
> >
> >Yeah, you have a point and I agree, but your patch 3 does add a
> >CPU_METHOD_OF_DECLARE for the A31s.
>=20
> Ah right, it does, my bad.
>=20
> >Since I was going to push the branch now that 3.19-rc1 is out, do you
> >want me to edit your patch before doing so?
>=20
> Yes, please drop the addition of the extra CPU_METHOD_OF_DECLARE, or let
> me know if you want a new version instead.

I just modified it, and pushed it, no need to resend it.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUqlSJAAoJEBx+YmzsjxAg+fsQAJlxbubHCLiQFMfz4GCo7SVa
JQ8eHw8GOUQygyK9Kftsijdgs4JBIVH6E/V0NBeTZ63lMz+/AggniSfbVezej2yr
k9Ngams6TPyn9EytQT+/lyEyCLlIgnGf45TWFSwq7KqTBRdonH6y4wn+VXrRKFbo
C9+zVk63JWMX0+VNVVHseK1qMkmnlLFkcsRaeEBhmcNdTp0tOyYqWLEjdP29GwJm
Xb+/1dfK4VkJoNwQXK3CWar/nSfKN2isKQJ6akrAgu9K8AE55pYxK7b+sfS5fmDu
gSCQRKdVI6QGuZqpw3UD/7LbGoc0kYTzFp4Tn0fQAcyDSeNmxn3BnAkg5SHFr06x
eQvgPpQNucnAYP81Jyy6lrCyqvP/f9bEuz/yMJrXm4gcevBSAmjITELtJL1lNzV8
sgOeFS7+worCZ7YtPzsq53Cgewiwkq8lfBtfOs7hDhyqHDXrTKNYPReTOmLiSsg/
3Q3ZbNFFUqYsDjs5QDVEYfuhkz5DRV1bRSt0WSju4dvTrdU9TAgE0RC0mfL7oDft
wjO31VlNpfvWx8NwKZEdzAioxc2pwuMJ4PCMUlvtTtxn0dkDZHecl+Y8nCEpbGGL
j9VZyYO73/GrLHf5NlLId/CiW38vEltNLgHEibUSBV07/Daod13qqZ+X/HkRkDGP
Kgk1AZ1243g3jWeHEK1+
=iDUh
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
