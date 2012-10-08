Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:47271 "EHLO
	na3sys009aog133.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750883Ab2JHHV7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Oct 2012 03:21:59 -0400
Received: by mail-lb0-f174.google.com with SMTP id n3so2714960lbo.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 00:21:55 -0700 (PDT)
Message-ID: <1349680913.3227.32.camel@deskari>
Subject: Re: [PATCH 2/2 v6] of: add generic videomode description
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Date: Mon, 08 Oct 2012 10:21:53 +0300
In-Reply-To: <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
References: <1349373560-11128-1-git-send-email-s.trumtrar@pengutronix.de>
	 <1349373560-11128-3-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IEbjVDW/qbgZTGr2ctI8"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-IEbjVDW/qbgZTGr2ctI8
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-04 at 19:59 +0200, Steffen Trumtrar wrote:
> Get videomode from devicetree in a format appropriate for the
> backend. drm_display_mode and fb_videomode are supported atm.
> Uses the display signal timings from of_display_timings
>=20
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  drivers/of/Kconfig           |    5 +
>  drivers/of/Makefile          |    1 +
>  drivers/of/of_videomode.c    |  212 ++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/of_videomode.h |   41 ++++++++
>  4 files changed, 259 insertions(+)
>  create mode 100644 drivers/of/of_videomode.c
>  create mode 100644 include/linux/of_videomode.h
>=20
> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> index 646deb0..74282e2 100644
> --- a/drivers/of/Kconfig
> +++ b/drivers/of/Kconfig
> @@ -88,4 +88,9 @@ config OF_DISPLAY_TIMINGS
>  	help
>  	  helper to parse display timings from the devicetree
> =20
> +config OF_VIDEOMODE
> +	def_bool y
> +	help
> +	  helper to get videomodes from the devicetree
> +
>  endmenu # OF
> diff --git a/drivers/of/Makefile b/drivers/of/Makefile
> index c8e9603..09d556f 100644
> --- a/drivers/of/Makefile
> +++ b/drivers/of/Makefile
> @@ -12,3 +12,4 @@ obj-$(CONFIG_OF_PCI)	+=3D of_pci.o
>  obj-$(CONFIG_OF_PCI_IRQ)  +=3D of_pci_irq.o
>  obj-$(CONFIG_OF_MTD)	+=3D of_mtd.o
>  obj-$(CONFIG_OF_DISPLAY_TIMINGS) +=3D of_display_timings.o
> +obj-$(CONFIG_OF_VIDEOMODE) +=3D of_videomode.o
> diff --git a/drivers/of/of_videomode.c b/drivers/of/of_videomode.c
> new file mode 100644
> index 0000000..76ac16e
> --- /dev/null
> +++ b/drivers/of/of_videomode.c
> @@ -0,0 +1,212 @@
> +/*
> + * generic videomode helper
> + *
> + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Peng=
utronix
> + *
> + * This file is released under the GPLv2
> + */
> +#include <linux/of.h>
> +#include <linux/fb.h>
> +#include <linux/slab.h>
> +#include <drm/drm_mode.h>
> +#include <linux/of_display_timings.h>
> +#include <linux/of_videomode.h>
> +
> +void dump_fb_videomode(struct fb_videomode *m)
> +{
> +        pr_debug("fb_videomode =3D %d %d %d %d %d %d %d %d %d %d %d %d %=
d\n",
> +                m->refresh, m->xres, m->yres, m->pixclock, m->left_margi=
n,
> +                m->right_margin, m->upper_margin, m->lower_margin,
> +                m->hsync_len, m->vsync_len, m->sync, m->vmode, m->flag);
> +}
> +
> +void dump_drm_displaymode(struct drm_display_mode *m)
> +{
> +        pr_debug("drm_displaymode =3D %d %d %d %d %d %d %d %d %d\n",
> +                m->hdisplay, m->hsync_start, m->hsync_end, m->htotal,
> +                m->vdisplay, m->vsync_start, m->vsync_end, m->vtotal,
> +                m->clock);
> +}
> +
> +int videomode_from_timing(struct display_timings *disp, struct videomode=
 *vm,
> +			int index)
> +{
> +	struct signal_timing *st =3D NULL;
> +
> +	if (!vm)
> +		return -EINVAL;
> +
> +	st =3D display_timings_get(disp, index);
> +
> +	if (!st) {
> +		pr_err("%s: no signal timings found\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	vm->pixelclock =3D signal_timing_get_value(&st->pixelclock, 0);
> +	vm->hactive =3D signal_timing_get_value(&st->hactive, 0);
> +	vm->hfront_porch =3D signal_timing_get_value(&st->hfront_porch, 0);
> +	vm->hback_porch =3D signal_timing_get_value(&st->hback_porch, 0);
> +	vm->hsync_len =3D signal_timing_get_value(&st->hsync_len, 0);
> +
> +	vm->vactive =3D signal_timing_get_value(&st->vactive, 0);
> +	vm->vfront_porch =3D signal_timing_get_value(&st->vfront_porch, 0);
> +	vm->vback_porch =3D signal_timing_get_value(&st->vback_porch, 0);
> +	vm->vsync_len =3D signal_timing_get_value(&st->vsync_len, 0);
> +
> +	vm->vah =3D st->vsync_pol_active_high;
> +	vm->hah =3D st->hsync_pol_active_high;
> +	vm->interlaced =3D st->interlaced;
> +	vm->doublescan =3D st->doublescan;
> +
> +	return 0;
> +}
> +
> +int of_get_videomode(struct device_node *np, struct videomode *vm, int i=
ndex)
> +{
> +	struct display_timings *disp;
> +	int ret =3D 0;
> +
> +	disp =3D of_get_display_timing_list(np);
> +
> +	if (!disp) {
> +		pr_err("%s: no timings specified\n", __func__);
> +		return -EINVAL;
> +	}
> +
> +	if (index =3D=3D OF_DEFAULT_TIMING)
> +		index =3D disp->default_timing;
> +
> +	ret =3D videomode_from_timing(disp, vm, index);
> +
> +	if (ret)
> +		return ret;
> +
> +	display_timings_release(disp);
> +
> +	if (!vm) {
> +		pr_err("%s: could not get videomode %d\n", __func__, index);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_get_videomode);
> +
> +#if defined(CONFIG_DRM)
> +int videomode_to_display_mode(struct videomode *vm, struct drm_display_m=
ode *dmode)
> +{
> +	memset(dmode, 0, sizeof(*dmode));
> +
> +	dmode->hdisplay =3D vm->hactive;
> +	dmode->hsync_start =3D dmode->hdisplay + vm->hfront_porch;
> +	dmode->hsync_end =3D dmode->hsync_start + vm->hsync_len;
> +	dmode->htotal =3D dmode->hsync_end + vm->hback_porch;
> +
> +	dmode->vdisplay =3D vm->vactive;
> +	dmode->vsync_start =3D dmode->vdisplay + vm->vfront_porch;
> +	dmode->vsync_end =3D dmode->vsync_start + vm->vsync_len;
> +	dmode->vtotal =3D dmode->vsync_end + vm->vback_porch;
> +
> +	dmode->clock =3D vm->pixelclock / 1000;
> +
> +	if (vm->hah)
> +		dmode->flags |=3D DRM_MODE_FLAG_PHSYNC;
> +	else
> +		dmode->flags |=3D DRM_MODE_FLAG_NHSYNC;
> +	if (vm->vah)
> +		dmode->flags |=3D DRM_MODE_FLAG_PVSYNC;
> +	else
> +		dmode->flags |=3D DRM_MODE_FLAG_NVSYNC;
> +	if (vm->interlaced)
> +		dmode->flags |=3D DRM_MODE_FLAG_INTERLACE;
> +	if (vm->doublescan)
> +		dmode->flags |=3D DRM_MODE_FLAG_DBLSCAN;
> +	drm_mode_set_name(dmode);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(videomode_to_display_mode);
> +
> +int of_get_drm_display_mode(struct device_node *np, struct drm_display_m=
ode *dmode,
> +			int index)
> +{
> +	struct videomode vm;
> +	int ret;
> +
> +	ret =3D of_get_videomode(np, &vm, index);
> +
> +	if (ret)
> +		return ret;
> +
> +	videomode_to_display_mode(&vm, dmode);
> +
> +	pr_info("%s: got %dx%d display mode from %s\n", __func__, vm.hactive,
> +		vm.vactive, np->name);
> +	dump_drm_displaymode(dmode);
> +
> +	return 0;
> +
> +}
> +EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
> +#else
> +int videomode_to_display_mode(struct videomode *vm, struct drm_display_m=
ode *dmode)
> +{
> +	return 0;
> +}
> +
> +int of_get_drm_display_mode(struct device_node *np, struct drm_display_m=
ode *dmode,
> +			int index)
> +{
> +	return 0;
> +}
> +#endif
> +
> +int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode =
*fbmode)
> +{
> +	memset(fbmode, 0, sizeof(*fbmode));
> +
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
> +	fbmode->pixclock =3D KHZ2PICOS(vm->pixelclock) / 1000;
> +
> +	if (vm->hah)
> +		fbmode->sync |=3D FB_SYNC_HOR_HIGH_ACT;
> +	if (vm->vah)
> +		fbmode->sync |=3D FB_SYNC_VERT_HIGH_ACT;
> +	if (vm->interlaced)
> +		fbmode->vmode |=3D FB_VMODE_INTERLACED;
> +	if (vm->doublescan)
> +		fbmode->vmode |=3D FB_VMODE_DOUBLE;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
> +
> +int of_get_fb_videomode(struct device_node *np, struct fb_videomode *fb,
> +			int index)
> +{
> +	struct videomode vm;
> +	int ret;
> +
> +	ret =3D of_get_videomode(np, &vm, index);
> +	if (ret)
> +		return ret;
> +
> +	videomode_to_fb_videomode(&vm, fb);
> +
> +	pr_info("%s: got %dx%d display mode from %s\n", __func__, vm.hactive,
> +		vm.vactive, np->name);
> +	dump_fb_videomode(fb);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(of_get_drm_display_mode);
> diff --git a/include/linux/of_videomode.h b/include/linux/of_videomode.h
> new file mode 100644
> index 0000000..96efe01
> --- /dev/null
> +++ b/include/linux/of_videomode.h
> @@ -0,0 +1,41 @@
> +/*
> + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> + *
> + * generic videomode description
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#ifndef __LINUX_VIDEOMODE_H
> +#define __LINUX_VIDEOMODE_H
> +
> +#include <drm/drmP.h>

You don't need to include this.

> +struct videomode {
> +	u32 pixelclock;
> +	u32 refreshrate;
> +
> +	u32 hactive;
> +	u32 hfront_porch;
> +	u32 hback_porch;
> +	u32 hsync_len;
> +
> +	u32 vactive;
> +	u32 vfront_porch;
> +	u32 vback_porch;
> +	u32 vsync_len;
> +
> +	bool hah;
> +	bool vah;
> +	bool interlaced;
> +	bool doublescan;
> +
> +};

This is not really of related. And actually, neither is the struct
signal_timing in the previous patch. It would be nice to have these in a
common header that fb, drm, and others could use instead of each having
their own timing structs.=20

But that's probably out of scope for this series =3D). Did you check the
timing structs from the video related frameworks in the kernel to see if
your structs contain all the info the others have, so that, at least in
theory, everybody could use these common structs?

 Tomi


--=-IEbjVDW/qbgZTGr2ctI8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAABAgAGBQJQcn8RAAoJEPo9qoy8lh71ZBwP9jINkbvmPpNVEJJVDYojRo51
pFX47w4ZcF+a+F3OYnaW/FcekAXhCmNQwP2qkvo99RhAT3BP5vAyVjoeQMfmP5c6
1MEZE0S5fOULTodSojbyREvZbq1FbKMCOcmoSBZyg4rW6PfudQx5ScXaph/RIC2v
fi9Qb6nTb9N6JISuZKjOBZlv9AKnzJLxMcL45LmTp+E6anjOdgeGzFHO1C2aNMxw
wbD6Uie0GB9TtKMRV7txqvkfax8ackfFILlvvfcutniRdZj5dkFlF4Un3nYcQzk1
HgWXLQekzMyUCPcFb5PKiL+ZWaUFZXlgNwrlsGJNX5LGWrUTl601KPk05m5bWFQM
SZ9hQjczyjbJbNCzFXXvvgzIzNuYWNou2sqco1+heLfyVokpKMakYLPN3h3AQ0kI
sS/edrMBTaHTfcK1ttp/bpzNTaGh+8NL2MpA1ndRyr4ySt6HJT6IM8q5FEuqmEty
TuTyPUT5tsMn9K58lq2aB6rVvDs47fV1B58EFcnexd/FGAXY4vxlq8dk3MahsPVQ
hJGDXVMy+b4weu4czd8+CnV3KaiwffdWSYqLfqVx8KEse8GoJhrPOHCvFgevEj9g
co3FkKPlFHqsa+qVuNw/ruiUnyU7e5YCFoTRkj3hOCX/1/fr4e/zNUZ5ox86Ksin
sdQHexeyZvYzm0Qi5PQ=
=rBQR
-----END PGP SIGNATURE-----

--=-IEbjVDW/qbgZTGr2ctI8--

