Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:53914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaLSV7X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Dec 2014 16:59:23 -0500
Date: Fri, 19 Dec 2014 19:17:08 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Chen-Yu Tsai <wens@csie.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi <linux-sunxi@googlegroups.com>
Subject: Re: [linux-sunxi] [PATCH v2 04/13] rc: sunxi-cir: Add support for an
 optional reset controller
Message-ID: <20141219181708.GQ4820@lukather>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
 <1418836704-15689-5-git-send-email-hdegoede@redhat.com>
 <CAGb2v65BW7NABQXK877DkMNqDdBeuZ55wQHFkTexbWACFC4zFA@mail.gmail.com>
 <54929552.8090707@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NEaRsfQExFH3jWtg"
Content-Disposition: inline
In-Reply-To: <54929552.8090707@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--NEaRsfQExFH3jWtg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Dec 18, 2014 at 09:50:26AM +0100, Hans de Goede wrote:
> Hi,
>=20
> On 18-12-14 03:48, Chen-Yu Tsai wrote:
> >Hi,
> >
> >On Thu, Dec 18, 2014 at 1:18 AM, Hans de Goede <hdegoede@redhat.com> wro=
te:
> >>On sun6i the cir block is attached to the reset controller, add support
> >>for de-asserting the reset if a reset controller is specified in dt.
> >>
> >>Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >>Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> >>Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> >>---
> >>  .../devicetree/bindings/media/sunxi-ir.txt         |  2 ++
> >>  drivers/media/rc/sunxi-cir.c                       | 25 +++++++++++++=
+++++++--
> >>  2 files changed, 25 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Doc=
umentation/devicetree/bindings/media/sunxi-ir.txt
> >>index 23dd5ad..6b70b9b 100644
> >>--- a/Documentation/devicetree/bindings/media/sunxi-ir.txt
> >>+++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> >>@@ -10,6 +10,7 @@ Required properties:
> >>
> >>  Optional properties:
> >>  - linux,rc-map-name : Remote control map name.
> >>+- resets : phandle + reset specifier pair
> >
> >Should it be optional? Or should we use a sun6i compatible with
> >a mandatory reset phandle? I mean, the driver/hardware is not
> >going to work with the reset missing on sun6i.
> >
> >Seems we are doing it one way for some of our drivers, and
> >the other (optional) way for more generic ones, like USB.
>=20
> I do not believe that we should add a new compatible just because
> the reset line of a block is hooked up differently. It is the
> exact same ip-block. Only now the reset is not controlled
> through the apb-gate, but controlled separately.

He has a point though. Your driver might very well probe nicely and
everything, but still wouldn't be functional at all because the reset
line wouldn't have been specified in the DT.

The easiest way to deal with that would be in the bindings doc to
update it with a compatible for the A31, and mentionning that the
reset property is mandatory there.

Note that the code itself might not change at all though. I'd just
like to avoid any potential breaking of the DT bindings themselves. If
we further want to refine the code, we can do that however we want.

I have a slight preference for a clean error if reset is missing, but
I won't get in the way just for that.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--NEaRsfQExFH3jWtg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUlGukAAoJEBx+YmzsjxAg/ZkQAK5FbIyn6/fazAyjy93YFKcs
H+x40VE0ycy9zwlh5WvQmf8ECTX2ZPxhr4C47lUYFHq78nn5ka+1zroXnui8iXvz
nyjrdZvAUF2ZNCILHOVQ38y8HyJ8qfQv4n0d6kWPhbakO+UZvzOwxlzawcFLuwtI
eTqQib7x5VKNbcVnoP+KYfZg2NsP9PxWyPnFmVsrpwMoHIiHkcTOHFexBlxQeZob
oDfCR/advkcnP8mHbPJ2LgnNf3zrf9MLWiiKH2VafN7/p82czHo5D0N6IYj3AyTA
UxA24NOIFZQh2Ea6QBh9S7fUrmHPe10fAzo3oYB9pqqbphrZDveWmuMcnlEapuni
789Ep979VKNwEi/roirODSlLSoouI1VCetwqFmZMmKC5kM0Hklb83Xbmk5gDHJLL
bhfys8DjTqqnNYqgyS4w1HVJANP/33wE82KKUdnewqAEumeXRYf3XOO91Z6Zh/SY
ANQBk2HcSIB+wvWpoSqpzJgNk2HzWiWtlHFI3Tg/orAi+OOD+WhzIKZvz31O2jUr
z0SHezhB02A9O9RHlRQMnRAyVbalzzU48dQ/DZGK2oTQKt1PdtN61SpO52YQDaox
XMtfbsUDTiKOm4HEsb8tEOZ8SKMpeN8uPqYe8wWadOdutRKyibv4ylaNKpqiv4dU
A3Hnu3fNHKdI99d1kX1v
=TzHO
-----END PGP SIGNATURE-----

--NEaRsfQExFH3jWtg--
