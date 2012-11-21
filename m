Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38965 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab2KULhx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 06:37:53 -0500
Message-ID: <50ACBCE4.60701@ti.com>
Date: Wed, 21 Nov 2012 13:37:08 +0200
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
Subject: Re: [PATCH v12 1/6] video: add display_timing and videomode
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de> <1353426896-6045-2-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-2-git-send-email-s.trumtrar@pengutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig7B8E20EC1036AA7EB2975329"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--------------enig7B8E20EC1036AA7EB2975329
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-20 17:54, Steffen Trumtrar wrote:
> Add display_timing structure and the according helper functions. This a=
llows
> the description of a display via its supported timing parameters.
>=20
> Every timing parameter can be specified as a single value or a range
> <min typ max>.
>=20
> Also, add helper functions to convert from display timings to a generic=
 videomode
> structure. This videomode can then be converted to the corresponding su=
bsystem
> mode representation (e.g. fb_videomode).

Sorry for reviewing this so late.

One thing I'd like to see is some explanation of the structs involved.
For example, in this patch you present structs videomode, display_timing
and display_timings without giving any hint what they represent.

I'm not asking for you to write a long documentation, but perhaps the
header files could include a few lines of comments above the structs,
explaining the idea.

> +void display_timings_release(struct display_timings *disp)
> +{
> +	if (disp->timings) {
> +		unsigned int i;
> +
> +		for (i =3D 0; i < disp->num_timings; i++)
> +			kfree(disp->timings[i]);
> +		kfree(disp->timings);
> +	}
> +	kfree(disp);
> +}
> +EXPORT_SYMBOL_GPL(display_timings_release);

Perhaps this will become clearer after reading the following patches,
but it feels a bit odd to add a release function, without anything in
this patch that would actually allocate the timings.

> diff --git a/drivers/video/videomode.c b/drivers/video/videomode.c
> new file mode 100644
> index 0000000..e24f879
> --- /dev/null
> +++ b/drivers/video/videomode.c
> @@ -0,0 +1,46 @@
> +/*
> + * generic display timing functions
> + *
> + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>, Pe=
ngutronix
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#include <linux/export.h>
> +#include <linux/errno.h>
> +#include <linux/display_timing.h>
> +#include <linux/kernel.h>
> +#include <linux/videomode.h>
> +
> +int videomode_from_timing(const struct display_timings *disp,
> +			  struct videomode *vm, unsigned int index)
> +{
> +	struct display_timing *dt;
> +
> +	dt =3D display_timings_get(disp, index);
> +	if (!dt)
> +		return -EINVAL;
> +
> +	vm->pixelclock =3D display_timing_get_value(&dt->pixelclock, 0);
> +	vm->hactive =3D display_timing_get_value(&dt->hactive, 0);
> +	vm->hfront_porch =3D display_timing_get_value(&dt->hfront_porch, 0);
> +	vm->hback_porch =3D display_timing_get_value(&dt->hback_porch, 0);
> +	vm->hsync_len =3D display_timing_get_value(&dt->hsync_len, 0);
> +
> +	vm->vactive =3D display_timing_get_value(&dt->vactive, 0);
> +	vm->vfront_porch =3D display_timing_get_value(&dt->vfront_porch, 0);
> +	vm->vback_porch =3D display_timing_get_value(&dt->vback_porch, 0);
> +	vm->vsync_len =3D display_timing_get_value(&dt->vsync_len, 0);

Shouldn't all these calls get the typical value, with index 1?

> +
> +	vm->vah =3D dt->vsync_pol_active;
> +	vm->hah =3D dt->hsync_pol_active;
> +	vm->de =3D dt->de_pol_active;
> +	vm->pixelclk_pol =3D dt->pixelclk_pol;
> +
> +	vm->interlaced =3D dt->interlaced;
> +	vm->doublescan =3D dt->doublescan;
> +
> +	return 0;
> +}
> +
> +EXPORT_SYMBOL_GPL(videomode_from_timing);
> diff --git a/include/linux/display_timing.h b/include/linux/display_tim=
ing.h
> new file mode 100644
> index 0000000..d5bf03f
> --- /dev/null
> +++ b/include/linux/display_timing.h
> @@ -0,0 +1,70 @@
> +/*
> + * Copyright 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>
> + *
> + * description of display timings
> + *
> + * This file is released under the GPLv2
> + */
> +
> +#ifndef __LINUX_DISPLAY_TIMINGS_H
> +#define __LINUX_DISPLAY_TIMINGS_H
> +
> +#include <linux/types.h>

What is this needed for? u32? I don't see it defined in types.h

> +
> +struct timing_entry {
> +	u32 min;
> +	u32 typ;
> +	u32 max;
> +};
> +
> +struct display_timing {
> +	struct timing_entry pixelclock;
> +
> +	struct timing_entry hactive;
> +	struct timing_entry hfront_porch;
> +	struct timing_entry hback_porch;
> +	struct timing_entry hsync_len;
> +
> +	struct timing_entry vactive;
> +	struct timing_entry vfront_porch;
> +	struct timing_entry vback_porch;
> +	struct timing_entry vsync_len;
> +
> +	unsigned int vsync_pol_active;
> +	unsigned int hsync_pol_active;
> +	unsigned int de_pol_active;
> +	unsigned int pixelclk_pol;
> +	bool interlaced;
> +	bool doublescan;
> +};
> +
> +struct display_timings {
> +	unsigned int num_timings;
> +	unsigned int native_mode;
> +
> +	struct display_timing **timings;
> +};
> +
> +/*
> + * placeholder function until ranges are really needed
> + * the index parameter should then be used to select one of [min typ m=
ax]
> + */
> +static inline u32 display_timing_get_value(const struct timing_entry *=
te,
> +					   unsigned int index)
> +{
> +	return te->typ;
> +}

Why did you opt for a placeholder here? It feels trivial to me to have
support to get the min/typ/max value properly.

> +static inline struct display_timing *display_timings_get(const struct
> +							 display_timings *disp,
> +							 unsigned int index)
> +{
> +	if (disp->num_timings > index)
> +		return disp->timings[index];
> +	else
> +		return NULL;
> +}
> +
> +void display_timings_release(struct display_timings *disp);
> +
> +#endif
> diff --git a/include/linux/videomode.h b/include/linux/videomode.h
> new file mode 100644
> index 0000000..5d3e796
> --- /dev/null
> +++ b/include/linux/videomode.h
> @@ -0,0 +1,40 @@
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
> +#include <linux/display_timing.h>

This is not needed, just add:

struct display_timings;

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
> +	u32 hah;
> +	u32 vah;
> +	u32 de;
> +	u32 pixelclk_pol;
> +
> +	bool interlaced;
> +	bool doublescan;
> +};
> +
> +int videomode_from_timing(const struct display_timings *disp,
> +			  struct videomode *vm, unsigned int index);
> +

Are this and the few other functions above meant to be used from
drivers? If so, some explanation of the parameters here would be nice.
If they are just framework internal, they don't probably need that.

 Tomi



--------------enig7B8E20EC1036AA7EB2975329
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBAgAGBQJQrLzkAAoJEPo9qoy8lh71vWsP+gLWZMn8izCWAj3Zddv24QTW
4tPZofzo9nLeruUYn+seelY5lYlEZAQv4bjoFAyVJJFoKaLvj8DLGiL00Vkv6TqZ
TC2yRDwj6HT0CIxFxP8544qN31F2VE00ZX1mezChn1U3eiInxCceUJF3L0fu4vhX
Of3S46p89sLCT6DUeuOPdbTNOWbgayTAyUjJ6vZRDyuqAnWy7BNuv3RZPzh4Lo1B
JoBl1nmH8d3t/BAuVKJC1bdTSPIHeqwcC5YFHX9zZQ5KJFVUr+6zoavvtD3jSHux
ekoBy0d6D1K+HXG8SAPRS5NTM0aYfTVDsamg/7BxCGocBkbQmnuOui8Y9Yl27TwB
Rb6Ram9xM/4gEcMSYCfF1Cddjv3rBLD5dhrPkFLD91pTm5AjMPAA/UuHvpRBCmcN
xN8Ho+sijDDMa1yzrENERVLa3ZFxrG+LbP/G5nY+ilTefnV4NLeN/bUED5q+OZcs
w0rg98loQEk5atjE9JtMlDXbJdiI1ahvY88MBzjKg7l7sn4Zdk8e3OfmcwRLsTh/
HiCVW6DTymRetxVo6UiMqSNXec+IJ9FbRsMwEkH9yi6ftAWOFco5SndljjPSeCyo
M8wH0b3ZtG0EmNSJ5nyWDvV2txlV7Y6HWgb6bMqNllopN0f8nBlyEGdPsToumWAB
uxaQV2eO7TDLLwPtf3wV
=b69s
-----END PGP SIGNATURE-----

--------------enig7B8E20EC1036AA7EB2975329--
