Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41572 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513Ab2KUMuQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 07:50:16 -0500
Message-ID: <50ACCDDA.2070606@ti.com>
Date: Wed, 21 Nov 2012 14:49:30 +0200
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
Subject: Re: [PATCH v12 4/6] fbmon: add of_videomode helpers
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-5-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig09241D6A5698903053C1AEA5"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig09241D6A5698903053C1AEA5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-11-20 17:54, Steffen Trumtrar wrote:
> Add helper to get fb_videomode from devicetree.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/fbmon.c |   42 +++++++++++++++++++++++++++++++++++++++++=
-
>  include/linux/fb.h    |    7 +++++++
>  2 files changed, 48 insertions(+), 1 deletion(-)


> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index 920cbe3..41b5e49 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -15,6 +15,8 @@
>  #include <linux/slab.h>
>  #include <asm/io.h>
>  #include <linux/videomode.h>
> +#include <linux/of.h>
> +#include <linux/of_videomode.h>

Guess what? =3D)

To be honest, I don't know what the general opinion is about including
header files from header files. But I always leave them out if they are
not strictly needed.

>  struct vm_area_struct;
>  struct fb_info;
> @@ -715,6 +717,11 @@ extern void fb_destroy_modedb(struct fb_videomode =
*modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, in=
t rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> =20
> +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> +extern int of_get_fb_videomode(const struct device_node *np,
> +			       struct fb_videomode *fb,
> +			       unsigned int index);
> +#endif
>  #if IS_ENABLED(CONFIG_VIDEOMODE)
>  extern int fb_videomode_from_videomode(const struct videomode *vm,
>  				       struct fb_videomode *fbmode);

Do you really need these #ifs in the header files? They do make it look
a bit messy. If somebody uses the functions and CONFIG_VIDEOMODE is not
enabled, he'll get a linker error anyway.

 Tomi



--------------enig09241D6A5698903053C1AEA5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrM3aAAoJEPo9qoy8lh71UA4QAIsNHXhDVDdpYMaHRr31ywwQ
Rw97qMUy85bOg1TJ8BFXSAV2Lp3sTgSSBolPcYksauFsKeCupiB3UtKaBUAhDatn
ZKFx3vPbVHh5yu9D+cybOJy5YeN43wyPVZwIZVVAZzcG+XI/X6TqMkGKUoTbh9OO
L6gqMqlIOHdYI4eDkNBO+hJilGXPYhKD5sYz3sTcraAsw+MlwSa4aQqwHh+w9azY
3NAWSamFqVlpeK7j3ALJDC0axwVprFa21K1LyUqUSdVJyj0dxyuv+nBCop7+sQme
lo/3R/YPwA34E3F/Df8FANaNaFqHJ9eOCIqOpgf55fcjCcCvMw59uaAYTSXgx8mY
rbnjcQcIy4tEsCYH8diz1SMGRkFcyg1FXw66b3uuh8xX76w59zftPO3o9hsqfrvO
HvBc0/8upNMY/ZNLb1rhAVTn4fzfmN0XEYd/a7gwX3+w8HoF/oszYPDpzRAhujjX
4rZM4W6hS2z/ZswxycqEj9U08tr2mcyizFGN77li3PXliH/UI2JkREQmtIvtRPb9
VO7UX8iu85qgCIxqop2xXbnSG24EWBmpFwwiLG5NZJsdPwdx4KDdv1x6+cx1WF/H
69j1RAqhk0ATiJD5jfaj3SfYGm1BnOdo5yjRvhau56Lyb/ahYjBgX8U52SRehrKZ
Mr7FzgNL7Zz/0pmen0+o
=Q6T5
-----END PGP SIGNATURE-----

--------------enig09241D6A5698903053C1AEA5--
