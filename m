Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:64950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2KNMMQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 07:12:16 -0500
Date: Wed, 14 Nov 2012 13:12:07 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v9 3/6] fbmon: add videomode helpers
Message-ID: <20121114121207.GD2803@avionic-0098.mockup.avionic-design.de>
References: <1352893403-21168-1-git-send-email-s.trumtrar@pengutronix.de>
 <1352893403-21168-4-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Content-Disposition: inline
In-Reply-To: <1352893403-21168-4-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 14, 2012 at 12:43:20PM +0100, Steffen Trumtrar wrote:
> Add a function to convert from the generic videomode to a fb_videomode.
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  drivers/video/fbmon.c |   38 ++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h    |    5 +++++
>  2 files changed, 43 insertions(+)
>=20
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index cef6557..cccef17 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -31,6 +31,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <video/edid.h>
> +#include <linux/videomode.h>
>  #ifdef CONFIG_PPC_OF
>  #include <asm/prom.h>
>  #include <asm/pci-bridge.h>
> @@ -1373,6 +1374,43 @@ int fb_get_mode(int flags, u32 val, struct fb_var_=
screeninfo *var, struct fb_inf
>  	kfree(timings);
>  	return err;
>  }
> +
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int fb_videomode_from_videomode(struct videomode *vm, struct fb_videomod=
e *fbmode)
> +{
> +	fbmode->xres =3D vm->hactive;
> +	fbmode->left_margin =3D vm->hback_porch;
> +	fbmode->right_margin =3D vm->hfront_porch;
> +	fbmode->hsync_len =3D vm->hsync_len;
> +
> +	fbmode->yres =3D vm->vactive;
> +	fbmode->upper_margin =3D vm->vback_porch;
> +	fbmode->lower_margin =3D vm->vfront_porch;
> +	fbmode->vsync_len =3D vm->vsync_len;
> +
> +	fbmode->pixclock =3D KHZ2PICOS(vm->pixelclock / 1000);
> +
> +	fbmode->sync =3D 0;
> +	fbmode->vmode =3D 0;
> +	if (vm->hah)
> +		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
> +	if (vm->vah)
> +		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
> +	if (vm->interlaced)
> +		fbmode->vmode |=3D FB_VMODE_INTERLACED;
> +	if (vm->doublescan)
> +		fbmode->vmode |=3D FB_VMODE_DOUBLE;
> +	if (vm->de)
> +		fbmode->sync |=3D FB_SYNC_DATA_ENABLE_HIGH_ACT;
> +	fbmode->refresh =3D (vm->pixelclock*1000) / (vm->hactive * vm->vactive);

CodingStyle that you should have spaces around '*'. Also I'm not sure if
that formula is correct. Shouldn't the blanking intervals be counted as
well? So:

	unsigned int htotal =3D vm->hactive + vm->hfront_porch +
			      vm->hback_porch + vm->hsync_len;
	unsigned int vtotal =3D vm->vactive + vm->vfront_porch +
			      vm->vback_porch + vm->vsync_len;

	fbmode->refresh =3D (vm->pixelclock * 1000) / (htotal * vtotal);

?

> +	fbmode->flag =3D 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> +#endif
> +
> +

Gratuitous blank line.

>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..6a3a675 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -14,6 +14,7 @@
>  #include <linux/backlight.h>
>  #include <linux/slab.h>
>  #include <asm/io.h>
> +#include <linux/videomode.h>
> =20
>  struct vm_area_struct;
>  struct fb_info;
> @@ -714,6 +715,10 @@ extern void fb_destroy_modedb(struct fb_videomode *m=
odedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int =
rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> =20
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +extern int fb_videomode_from_videomode(struct videomode *vm,
> +				       struct fb_videomode *fbmode);
> +#endif
>  /* drivers/video/modedb.c */

These in turn could use an extra blank line.

Thierry

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQo4qXAAoJEN0jrNd/PrOhPp0QAKnDR5xQNeuo1AHCiFDdir3r
LLakTtimwaGLkOWFnm7wUuOQ/b1c0lMO5jw4aMy++JcCM4uSIb1bDtJo2GIFPlR9
wnE7SjlJhoN11mcLvrj0cCd9VDrWRV7VlwNCl8BtS7WKsTifF42gdxbJcld2yjjX
jGDSaMoPixgdU1NRY57o50Vdj2H1pNlmXzM/pMn6/F2PppSyTHeouhu4GQen76fG
n/OVZu/MFO+A4ZuSvXwUo77LE5WFBa17UoigYfRNLV9DJFV22QQxiCP1J1Albvwg
tGie6DMg/h+nhotdGex5ZdJ/j5tJw4TfJ3DkhNCnr2Sk3x7YGIOPMyvMBbACt6P1
JzxxRRnoKMY59xYp7U8xamFAjX0dAaOdev2r9oLs4QWJ5EpIgOty1s6/NsCTUhH6
GHaFJQ/WhRytSfbVDfnsBRPFHl5UOYriCCQFpLzSLjP4GeWV+Cw/q7GGPbLdzErr
RoOkSNbqXEMv0TJmCfHy9t4JgEzcXrw0i4Va3By/HgQH7z4jTYU3Euwkt23BwcC+
YjZlYVbx4q0bAiCAWC0lgFq1oiKqtxF8paq7VkHFTBN+E097PsbeTV5cSRDcocWp
kqhmz8KGbZ9YIWIWa3vF97z/OnWWZRBxwWJ8QxhBYXp/hHDiQGJ+91PrPEi6cHZT
jPZFlA3B21xJiSCXq28G
=I1z0
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
