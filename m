Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43728 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab2KWKwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Nov 2012 05:52:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	Rob Herring <robherring2@gmail.com>,
	linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>, kernel@pengutronix.de,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: Re: [PATCHv14 4/7] fbmon: add videomode helpers
Date: Fri, 23 Nov 2012 11:53:10 +0100
Message-ID: <2828625.Bdym394lFc@avalon>
In-Reply-To: <1353661467-28545-5-git-send-email-s.trumtrar@pengutronix.de>
References: <1353661467-28545-1-git-send-email-s.trumtrar@pengutronix.de> <1353661467-28545-5-git-send-email-s.trumtrar@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

On Friday 23 November 2012 10:04:24 Steffen Trumtrar wrote:
> Add a function to convert from the generic videomode to a fb_videomode.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/fbmon.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h    |    6 ++++++
>  2 files changed, 55 insertions(+)
> 
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index cef6557..bcbfe8f 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -31,6 +31,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <video/edid.h>
> +#include <linux/videomode.h>

You could move this one line up to keep headers sorted alphabetically 
(assuming they are in the first place).

>  #ifdef CONFIG_PPC_OF
>  #include <asm/prom.h>
>  #include <asm/pci-bridge.h>
> @@ -1373,6 +1374,54 @@ int fb_get_mode(int flags, u32 val, struct
> fb_var_screeninfo *var, struct fb_inf kfree(timings);
>  	return err;
>  }
> +
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int fb_videomode_from_videomode(const struct videomode *vm,
> +				struct fb_videomode *fbmode)

This is inside the #if CONFIG_FB_MODE_HELPERS block, is that intentional ?

> +{
> +	unsigned int htotal, vtotal;
> +
> +	fbmode->xres = vm->hactive;
> +	fbmode->left_margin = vm->hback_porch;
> +	fbmode->right_margin = vm->hfront_porch;
> +	fbmode->hsync_len = vm->hsync_len;
> +
> +	fbmode->yres = vm->vactive;
> +	fbmode->upper_margin = vm->vback_porch;
> +	fbmode->lower_margin = vm->vfront_porch;
> +	fbmode->vsync_len = vm->vsync_len;
> +
> +	/* prevent division by zero in KHZ2PICOS macro */
> +	fbmode->pixclock = vm->pixelclock ? KHZ2PICOS(vm->pixelclock / 1000) : 0;
> +
> +	fbmode->sync = 0;
> +	fbmode->vmode = 0;
> +	if (vm->hah)
> +		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> +	if (vm->vah)
> +		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> +	if (vm->interlaced)
> +		fbmode->vmode |= FB_VMODE_INTERLACED;
> +	if (vm->doublescan)
> +		fbmode->vmode |= FB_VMODE_DOUBLE;
> +	fbmode->flag = 0;
> +
> +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> +		 vm->hsync_len;
> +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> +		 vm->vsync_len;
> +	/* prevent division by zero */
> +	if (htotal && vtotal)
> +		fbmode->refresh = vm->pixelclock / (htotal * vtotal);
> +	else
> +		fbmode->refresh = vm->pixelclock;

What about returning an error if htotal * vtotal == 0 ? The input is clearly 
invalid in that case. I would then set fbmode->refresh to 0, setting it to vm-
>pixelclock doesn't really make sense.

> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> +#endif
> +
> +

A single blank line should be enough.

>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..4404ec2 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -19,6 +19,7 @@ struct vm_area_struct;
>  struct fb_info;
>  struct device;
>  struct file;
> +struct videomode;
> 
>  /* Definitions below are used in the parsed monitor specs */
>  #define FB_DPMS_ACTIVE_OFF	1
> @@ -714,6 +715,11 @@ extern void fb_destroy_modedb(struct fb_videomode
> *modedb); extern int fb_find_mode_cvt(struct fb_videomode *mode, int
> margins, int rb); extern unsigned char *fb_ddc_read(struct i2c_adapter
> *adapter);
> 
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +extern int fb_videomode_from_videomode(const struct videomode *vm,
> +				       struct fb_videomode *fbmode);
> +#endif
> +
>  /* drivers/video/modedb.c */
>  #define VESA_MODEDB_SIZE 34
>  extern void fb_var_to_videomode(struct fb_videomode *mode,
-- 
Regards,

Laurent Pinchart

