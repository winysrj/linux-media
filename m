Return-path: <linux-media-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52175 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab3KDEDa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 3 Nov 2013 23:03:30 -0500
Message-ID: <1383537790.2764.69.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCHv2 07/29] platform drivers: Fix build on cris and frv
 archs
From: Ben Hutchings <ben@decadent.org.uk>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Date: Mon, 04 Nov 2013 04:03:10 +0000
In-Reply-To: <1383399097-11615-8-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
	 <1383399097-11615-8-git-send-email-m.chehab@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-9406QhFl8yHJJxnEPrhl"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-9406QhFl8yHJJxnEPrhl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-11-02 at 11:31 -0200, Mauro Carvalho Chehab wrote:
> On cris and frv archs, the functions below aren't defined:
> 	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':
> 	drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of fu=
nction 'ioread32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':
> 	drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of fu=
nction 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
> 	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of =
function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
> 	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of =
function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
> 	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of =
function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
> 	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of =
function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_setu=
p':
> 	drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit decl=
aration of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> 	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_requ=
est_capture_stop':
> 	drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit decl=
aration of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
>=20
> While this is not fixed, remove those 3 drivers from building on
> those archs.
[...]

Well where does this stop?  There will be many other drivers that are
broken if those functions are missing, and there's going to be a lot of
churn if we disable them all and then reenable when the architecture
headers are fixed.

cris selects the generic implementations (CONFIG_GENERIC_IOMAP) but I
think arch/cris/include/asm/io.h is missing
#include <asm-generic/iomap.h>.

frv defines these functions inline in arch/frv/include/asm/io.h so I
don't know what the problem is there.

Ben.

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-9406QhFl8yHJJxnEPrhl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUnccfue/yOyVhhEJAQrAgxAAuGXX+sWYarmAXIu0a4llRlW2l7FOOI5c
vdHHDm0MC/7P/V9E9JQh5Nz0ItXAdfWHWrTkjMWLKGKguaiH8Jv1lyta4GM55AdM
RWL/t9eW9cFL5Lq58lCOFDqC1yGlS81z2L7LEFv1QevSqHfMpxdRjXMCY3qSRRFL
VdYqFzdjmYIyvApjGkvMZVsmIGsWpM21vu6RtdTIKHDPVGZvaVrydF8oPi31BXe0
c5M6gV+rVvIjYS4U/U3a6DIDNXRdHVWPe975XMimhYPH9q3D5JiFptXPJjtdI4MJ
+zpKfJ1U25lp9XuX3zWraJx5Epb1z8TmN8r3rRlDOgUTGMzd1l4XVXqzOwFfxpiz
fchH16A0tZlJW3xkhCeVECDfhZctOAi+f6aoy+kMyYISa5Lls5kOS+HVbVct3oOD
8cOi+V6HmU3k5nnsv0tnEkQaywRreqBAb+T/uPDSbFul1sJMdYMrnulj77lqImIi
LlKbH3mMsPSLN4VwKDBd57HJuHWLRkUFYLbzOmKPmOEZAvqRiWmZsxPH76PmKIPp
6tRBG8+gvQITOEI9NnecNgEYoGSY13mQX8TTc8ChBmnaR2aUDJ0MG2BEStLgSXqg
0kBcyw1O4BhzDm1/oQZ0nwwhDesctON+BOduQS/z2cFsoSLu4x54KPjJ9RpNgz5Q
1L12G6BOM40=
=eiqr
-----END PGP SIGNATURE-----

--=-9406QhFl8yHJJxnEPrhl--
