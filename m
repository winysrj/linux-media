Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58366 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752129AbaLUWkG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 17:40:06 -0500
Date: Sun, 21 Dec 2014 23:39:41 +0100
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
Message-ID: <20141221223941.GC4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-13-git-send-email-hdegoede@redhat.com>
 <20141219183450.GZ4820@lukather>
 <54954E77.4070302@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2pi4Gp0KyRJpQ5Nw"
Content-Disposition: inline
In-Reply-To: <54954E77.4070302@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--2pi4Gp0KyRJpQ5Nw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 20, 2014 at 11:24:55AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 19-12-14 19:34, Maxime Ripard wrote:
> >On Wed, Dec 17, 2014 at 06:18:23PM +0100, Hans de Goede wrote:
> >>Add a dtsi file for A31s based boards.
> >>
> >>Since the  A31s is the same die as the A31 in a different package, this=
 dtsi
> >>simply includes sun6i-a31.dtsi and then overrides the pinctrl compatibl=
e to
> >>reflect the different package, everything else is identical.
> >>
> >>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>---
> >>Changes in v2:
> >>-include sun6i-a31.dtsi and override the pinctrl compatible, rather then
> >>  copying everything
> >>---
> >>  arch/arm/boot/dts/sun6i-a31s.dtsi | 62 ++++++++++++++++++++++++++++++=
+++++++++
> >>  1 file changed, 62 insertions(+)
> >>  create mode 100644 arch/arm/boot/dts/sun6i-a31s.dtsi
> >>
> >>diff --git a/arch/arm/boot/dts/sun6i-a31s.dtsi b/arch/arm/boot/dts/sun6=
i-a31s.dtsi
> >>new file mode 100644
> >>index 0000000..d0bd2b9
> >>--- /dev/null
> >>+++ b/arch/arm/boot/dts/sun6i-a31s.dtsi
> >>@@ -0,0 +1,62 @@
> >>+/*
> >>+ * Copyright 2014 Hans de Goede <hdegoede@redhat.com>
> >>+ *
> >>+ * This file is dual-licensed: you can use it either under the terms
> >>+ * of the GPL or the X11 license, at your option. Note that this dual
> >>+ * licensing only applies to this file, and not this project as a
> >>+ * whole.
> >>+ *
> >>+ *  a) This library is free software; you can redistribute it and/or
> >>+ *     modify it under the terms of the GNU General Public License as
> >>+ *     published by the Free Software Foundation; either version 2 of =
the
> >>+ *     License, or (at your option) any later version.
> >>+ *
> >>+ *     This library is distributed in the hope that it will be useful,
> >>+ *     but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>+ *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>+ *     GNU General Public License for more details.
> >>+ *
> >>+ *     You should have received a copy of the GNU General Public
> >>+ *     License along with this library; if not, write to the Free
> >>+ *     Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston,
> >>+ *     MA 02110-1301 USA
> >>+ *
> >>+ * Or, alternatively,
> >>+ *
> >>+ *  b) Permission is hereby granted, free of charge, to any person
> >>+ *     obtaining a copy of this software and associated documentation
> >>+ *     files (the "Software"), to deal in the Software without
> >>+ *     restriction, including without limitation the rights to use,
> >>+ *     copy, modify, merge, publish, distribute, sublicense, and/or
> >>+ *     sell copies of the Software, and to permit persons to whom the
> >>+ *     Software is furnished to do so, subject to the following
> >>+ *     conditions:
> >>+ *
> >>+ *     The above copyright notice and this permission notice shall be
> >>+ *     included in all copies or substantial portions of the Software.
> >>+ *
> >>+ *     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> >>+ *     EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
> >>+ *     OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> >>+ *     NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
> >>+ *     HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
> >>+ *     WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> >>+ *     FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
> >>+ *     OTHER DEALINGS IN THE SOFTWARE.
> >>+ */
> >>+
> >>+/*
> >>+ * The A31s is the same die as the A31 in a different package, this is
> >>+ * reflected by it having different pinctrl compatible everything else=
 is
> >>+ * identical.
> >>+ */
> >>+
> >>+/include/ "sun6i-a31.dtsi"
> >>+
> >>+/ {
> >>+	soc@01c00000 {
> >>+		pio: pinctrl@01c20800 {
> >>+			compatible =3D "allwinner,sun6i-a31s-pinctrl";
> >>+		};
> >>+	};
> >>+};
> >
> >Given your previous changes, you should also update the enable-method.
>=20
> I've not added a new compatible for the enable-method, given that
> this is the exact same die, so the 2 are 100?% compatible, just like you
> insisted that "allwinner,sun4i-a10-mod0-clk" should be used for the ir-clk
> since it was 100% compatible to that I believe that the enable method
> should use the existing compatible and not invent a new one for something
> which is 100% compatible.

Yeah, you have a point and I agree, but your patch 3 does add a
CPU_METHOD_OF_DECLARE for the A31s.

Since I was going to push the branch now that 3.19-rc1 is out, do you
want me to edit your patch before doing so?


> >Also, for this patch and the next one, Arnd just warned me that we
> >shouldn't duplicate the DT path, and that we should switch to the new
> >trend on using label references (like what TI or Amlogic does for
> >example).
>=20
> Ok, so something like this, right ?  :
>=20
> &pio {
> 	compatible =3D "allwinner,sun6i-a31s-pinctrl";
> };

Yep.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2pi4Gp0KyRJpQ5Nw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUl0wtAAoJEBx+YmzsjxAgd4sQAL1BghBpOmAVIBpcBsukI5xB
nTrWry8ESYenWCmIk10PKvf2oBlzrZbJPsFzy0uXL/GoZ3hIct8CgEhEF6+Bpf9D
jhsMSXt/zgkw7kf5AQ8B0NNiKktZT2JKf48Dtc3r7J2K0vKXc+EpwecKDkz2rXBR
SlgnGL/5oieNY/KvsSP53UF6LbdilZZE3Ypuel1P6iVwl8lEv1+srJkdT+mMvBoT
5krw1jeiGx60pe+mR16fhU6lp6mDAGPqLiofq7zYHASnDbimAgcZtCEOrt3wdf0N
Z8weSYx8uOHh69uS6V4Dxc0I5CvlQlNwWB1uMw1i19r/2AtqEypM+ZLDwcuoAtDx
pCyPMpC8eJcb2uBULJOhE1bpj/kGpez3xZ+wPR68I9DG31+vBjvs0iFruGgslO66
AcyICsbVsPGxbTQfG/w7YmWz+txnxcmbe/4GahDWb+fhdVT/gMXg0hq3Hg8pfxGJ
tyQTHaaVAOyJgnwxA8dByHPVHecnWOCKzn75TfIqdyN4kuZAZSTle9mOtaLI0+sf
Z2kt1HCTFT9dbLZbC1Dm+aYtGa7258Yy9RNvDdbdrTFB9XVyJjbJKZY0lwiEcZcZ
QtgahvhDBsa+CUxIaruulwyGfGmvBRg0ct4EuPyPhqlcoU1kxJwfvEsescQPBovu
o1E4F4Aiu2qKXg8RHv2R
=zmXJ
-----END PGP SIGNATURE-----

--2pi4Gp0KyRJpQ5Nw--
