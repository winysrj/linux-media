Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:64140 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab3KDL2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 06:28:18 -0500
Date: Mon, 04 Nov 2013 09:28:02 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	stable@vger.kernel.org
Subject: Re: [PATCHv2 07/29] platform drivers: Fix build on cris and frv archs
Message-id: <20131104092802.49fce9e6@samsung.com>
In-reply-to: <1383537790.2764.69.camel@deadeye.wl.decadent.org.uk>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
 <1383399097-11615-8-git-send-email-m.chehab@samsung.com>
 <1383537790.2764.69.camel@deadeye.wl.decadent.org.uk>
MIME-version: 1.0
Content-type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/MmNQ2nsMm5FhJ+c_WYBqITg"; protocol="application/pgp-signature"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Sig_/MmNQ2nsMm5FhJ+c_WYBqITg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Ben,

Em Mon, 04 Nov 2013 04:03:10 +0000
Ben Hutchings <ben@decadent.org.uk> escreveu:

> On Sat, 2013-11-02 at 11:31 -0200, Mauro Carvalho Chehab wrote:
> > On cris and frv archs, the functions below aren't defined:
> > 	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':
> > 	drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of =
function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':
> > 	drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of =
function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
> > 	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration o=
f function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
> > 	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration o=
f function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
> > 	drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration o=
f function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
> > 	drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration o=
f function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_se=
tup':
> > 	drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit de=
claration of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
> > 	drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_re=
quest_capture_stop':
> > 	drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit de=
claration of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
> >=20
> > While this is not fixed, remove those 3 drivers from building on
> > those archs.
> [...]
>=20
> Well where does this stop?  There will be many other drivers that are
> broken if those functions are missing, and there's going to be a lot of
> churn if we disable them all and then reenable when the architecture
> headers are fixed.
>=20
> cris selects the generic implementations (CONFIG_GENERIC_IOMAP) but I
> think arch/cris/include/asm/io.h is missing
> #include <asm-generic/iomap.h>.

Thanks for your review!

Yes, adding it is enough to get rid of the errors on cris.

> frv defines these functions inline in arch/frv/include/asm/io.h so I
> don't know what the problem is there.

One of the drivers weren't including <linux/io.h>. Probably, this were
indirectly included on other archs. That's why it failed only on frv.
The enclosed patch should fix for both:


platform drivers: Fix build on cris and frv archs

On cris and frv archs, compilation fails due to the lack of ioread32/iowrit=
e32:

        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':
        drivers/media/platform/sh_veu.c:228:2: error: implicit declaration =
of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':
        drivers/media/platform/sh_veu.c:234:2: error: implicit declaration =
of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaratio=
n of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaratio=
n of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaratio=
n of function 'ioread32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaratio=
n of function 'iowrite32' [-Werror=3Dimplicit-function-declaration]
        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin=
_setup':
        drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit=
 declaration of function 'iowrite32' [-Werror=3Dimplicit-function-declarati=
on]
        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin=
_request_capture_stop':
        drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit=
 declaration of function 'ioread32' [-Werror=3Dimplicit-function-declaratio=
n]

On cris, the reason is because asm-generic/iomap.h is not included
on asm/io.h.

On frv, the reason is because linux/io.h is not included on rcar_vin.c.

Fix both issues.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

PS.: I'll split this patch on two separate ones, sending the cris patch
to the arch maintainer, and committing the media patch via my tree.


diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 5d3047e5563b..4353cf239a13 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
=20
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
=20
 struct cris_io_operations
diff --git a/drivers/media/platform/soc_camera/rcar_vin.c b/drivers/media/p=
latform/soc_camera/rcar_vin.c
index b21f777f55e7..ddf648fab63f 100644
--- a/drivers/media/platform/soc_camera/rcar_vin.c
+++ b/drivers/media/platform/soc_camera/rcar_vin.c
@@ -14,6 +14,7 @@
  * option) any later version.
  */
=20
+#include <linux/io.h>
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>

--Sig_/MmNQ2nsMm5FhJ+c_WYBqITg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSd4TMAAoJEAhfPr2O5OEVm3cP/3qrctiwX3yy+5X8yq7c0gFE
DWg9HJuBMD5Kry3s3ZIfdHUA7pvSPy4Ajt7ojvjfs8Y8EqkVMmI4t9YdOStVMhfn
Q0HSqqxQ1qGjRDr2mtWtwvwRC6J13nsYyBCMl2msK7VuslNFE//HFE1px4rkap+M
+oHJlz1JC9nBaf9Vrj5tVxwD8K0PAN2Opt/XIPxsw7ei8Xd3/pp5KZKI1A1ZqeXR
y3KCsn3LEtglCzyaXGeuT+X4PAn4riIU1hO65nIbTFdMpQHJb2lHTmgxQvlQro7i
nHHRp+/d7YZTCyLu6xugUgFC1KlTVx50PYSLr73r8Q4NjBR68f7g+hQx9qnoX7IE
VUXJYkdVkOod4d6FrgVg3phrQrEyeofjglsS46jaRtSOOl+YIfysEXprH57lStwF
yWfjiQK4w8AersfvPM5CahWJWTXQ9ct5HjVy6XE6oAlLAEONQQQYz19kYkTY8AdL
KSzvMNimaF33FtN7pKWcuuP8Ju9c1iZorf22GhtM+yMopqNN7OA3OnngCvZnUl5j
h2iVPUoGItMzhEu1RZBIskmk2Pwmrxl3w0PACzYwsJWNB+nMKReUeKhQhdcLTpPL
F58hKC+JzC4RYyT0FdfE88BJsdLpoAdZjw3H5de0G6+xwZuPWO6GBQt9Zx03EmWC
jKvjImkfsoaHKLjs2LBo
=wQGI
-----END PGP SIGNATURE-----

--Sig_/MmNQ2nsMm5FhJ+c_WYBqITg--
