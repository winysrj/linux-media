Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49828 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2JaRRT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 13:17:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de
Subject: Re: [PATCH v7 4/8] video: add videomode helpers
Date: Wed, 31 Oct 2012 18:18:10 +0100
Message-ID: <2142756.CuAAJDxjqo@avalon>
In-Reply-To: <1351675689-26814-5-git-send-email-s.trumtrar@pengutronix.de>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de> <1351675689-26814-5-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

Thanks for the patch.

On Wednesday 31 October 2012 10:28:04 Steffen Trumtrar wrote:
> Add helper functions to convert from display timings to a generic videomode
> structure. This videomode can then be converted to the corresponding
> subsystem mode representation (e.g. fb_videomode).
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  drivers/video/Kconfig     |    6 ++++++
>  drivers/video/Makefile    |    1 +
>  drivers/video/videomode.c |   44 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/videomode.h |   36 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 87 insertions(+)
>  create mode 100644 drivers/video/videomode.c
>  create mode 100644 include/linux/videomode.h
> 
> diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
> index 1421fc8..45dd393 100644
> --- a/drivers/video/Kconfig
> +++ b/drivers/video/Kconfig
> @@ -38,6 +38,12 @@ config DISPLAY_TIMING
>         help
>           Say Y here, to use the display timing helpers.
> 
> +config VIDEOMODE
> +       bool "Enable videomode helpers"

Shouldn't this option should be automatically selected through a select 
statement in other options that depend on it instead of manually selected ? 
Same for the DISPLAY_TIMING option in 1/8.

There's so little code here, do you think it would be a good idea to merge 
patches 1/8 and 4/8 and have a single Kconfig option ?

> +       help
> +         Say Y here, to use the generic videomode helpers. This allows
> +	 converting from display timings to fb_videomode and drm_display_mode
> +
>  menuconfig FB
>  	tristate "Support for frame buffer devices"
>  	---help---
> diff --git a/drivers/video/Makefile b/drivers/video/Makefile
> index 552c045..fc30439 100644
> --- a/drivers/video/Makefile
> +++ b/drivers/video/Makefile
> @@ -168,3 +168,4 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
>  #video output switch sysfs driver
>  obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
>  obj-$(CONFIG_DISPLAY_TIMING) += display_timing.o
> +obj-$(CONFIG_VIDEOMODE) += videomode.o
> diff --git a/drivers/video/videomode.c b/drivers/video/videomode.c
> new file mode 100644
> index 0000000..a9fe010
> --- /dev/null
> +++ b/drivers/video/videomode.c
> @@ -0,0 +1,44 @@
> +/*
> + * generic display timing functions
> + *
> + * Copyright (c) 2012 Steffen Trumtrar <s.trumtrar@pengutronix.de>,
> Pengutronix + *
> + * This file is released under the GPLv2
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/export.h>
> +#include <linux/errno.h>
> +#include <linux/display_timing.h>
> +#include <linux/videomode.h>

As in 1/8, I try to keep #include's sorted alphabetically, but I won't push 
for it here either :-)

> +
> +int videomode_from_timing(struct display_timings *disp, struct videomode
> *vm,
> +			  int index)

unsigned int for index ?

> +{
> +	struct display_timing *dt = NULL;

No need to initialize dt to NULL.

> +	dt = display_timings_get(disp, index);
> +	if (!dt) {
> +		pr_err("%s: no signal timings found\n", __func__);

I wonder whether this really deserves a pr_err() here. Would this be a caller 
bug, or can there be valid use cases where this function would return an error 
?

> +		return -EINVAL;
> +	}
> +
> +	vm->pixelclock = display_timing_get_value(&dt->pixelclock, 0);
> +	vm->hactive = display_timing_get_value(&dt->hactive, 0);
> +	vm->hfront_porch = display_timing_get_value(&dt->hfront_porch, 0);
> +	vm->hback_porch = display_timing_get_value(&dt->hback_porch, 0);
> +	vm->hsync_len = display_timing_get_value(&dt->hsync_len, 0);
> +
> +	vm->vactive = display_timing_get_value(&dt->vactive, 0);
> +	vm->vfront_porch = display_timing_get_value(&dt->vfront_porch, 0);
> +	vm->vback_porch = display_timing_get_value(&dt->vback_porch, 0);
> +	vm->vsync_len = display_timing_get_value(&dt->vsync_len, 0);
> +
> +	vm->vah = dt->vsync_pol_active;
> +	vm->hah = dt->hsync_pol_active;
> +	vm->interlaced = dt->interlaced;
> +	vm->doublescan = dt->doublescan;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(videomode_from_timing);
> diff --git a/include/linux/videomode.h b/include/linux/videomode.h
> new file mode 100644
> index 0000000..f932147
> --- /dev/null
> +++ b/include/linux/videomode.h
> @@ -0,0 +1,36 @@
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
> +
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
> +	bool interlaced;
> +	bool doublescan;
> +};
> +
> +int videomode_from_timing(struct display_timings *disp, struct videomode
> *vm,
> +			  int index);
> +#endif
-- 
Regards,

Laurent Pinchart

