Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:56640 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2KUM2H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 07:28:07 -0500
Message-ID: <50ACC8C1.9020400@ti.com>
Date: Wed, 21 Nov 2012 14:27:45 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
	Rob Herring <robherring2@gmail.com>,
	<linux-fbdev@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	<linux-media@vger.kernel.org>,
	Stephen Warren <swarren@wwwdotorg.org>,
	<kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12 3/6] fbmon: add videomode helpers
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigC5A087637FE61696096833B9"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enigC5A087637FE61696096833B9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-20 17:54, Steffen Trumtrar wrote:

> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..920cbe3 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -14,6 +14,7 @@
>  #include <linux/backlight.h>
>  #include <linux/slab.h>
>  #include <asm/io.h>
> +#include <linux/videomode.h>

No need for this, just add "struct xxx;".

>  struct vm_area_struct;
>  struct fb_info;
> @@ -714,6 +715,11 @@ extern void fb_destroy_modedb(struct fb_videomode =
*modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, in=
t rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> =20
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +extern int fb_videomode_from_videomode(const struct videomode *vm,
> +				       struct fb_videomode *fbmode);
> +#endif
> +
>  /* drivers/video/modedb.c */
>  #define VESA_MODEDB_SIZE 34
>  extern void fb_var_to_videomode(struct fb_videomode *mode,
>=20



--------------enigC5A087637FE61696096833B9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrMjBAAoJEPo9qoy8lh71Q4cP/1dcAq5jTdtLB0cu++W4vXeq
Ponbk6jqAVyBp57B11VXREKXJQN3nc/OmKvhJAb8v+POUzxD11eXNLeU0Ww6l+gQ
hwxTmnTAXRnYdlS5+UWdLmxjpIIfJPkUEi15dt0+jw+JsJQVTqlGSr5FusWty9DB
XiD6coM7g1NjuZDNjHKb1r3ydSK85ZNnq/eKms1DkF/5CexT+TzPMApMWO7eZml3
I1IHR2C/DwRty1dhe27kIcWOrr32DiCwg3F8CtaamjSnybHJPYfAwMhpDFmkkUjL
hjhjV6gnZGpo9E777GRnoww/aLm65jAEt7eFwGrXhKMbw/1Jstxgyh/kCEemYfh4
fR0DoU587a2uvmjLZWmrpqfLE5uOZ6T3Gv9mfx+iRcoTBPiRCpveZH+mNHZSRe0U
9ml3dCPhX9lyvz+z5gWHAx4kzMn1/S5tEmYCKP53MiLog0eBaQ/XZ+1X8mcz8wG+
YHCy+iH1SnV0+HSFN6gs00EuCz7l9ysXd5bL5MHHyYI8PVGPAJ+Es6ymy6H4hDJ1
v6P9HfXnqPkGjZFiBXqbE31qBLe5YocqbfQzpiq5BGbliMZox3X+UfaFTFBOHfsq
CMYn/P7DCqcB0zOaHaiY7e0n1T4mhxIFM4N5jZXZN7OGTfhzk/+H2JdrQ2E7CR9f
mBEVd8ibV45KVjnnhkPm
=h0BO
-----END PGP SIGNATURE-----

--------------enigC5A087637FE61696096833B9--
