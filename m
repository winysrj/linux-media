Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:45411 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317Ab3BAJ3x (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Feb 2013 04:29:53 -0500
From: Jingoo Han <jg1.han@samsung.com>
To: 'Steffen Trumtrar' <s.trumtrar@pengutronix.de>
Cc: devicetree-discuss@lists.ozlabs.org,
	'Dave Airlie' <airlied@linux.ie>, linux-fbdev@vger.kernel.org,
	"'Mohammed, Afzal'" <afzal@ti.com>,
	'Stephen Warren' <swarren@wwwdotorg.org>,
	'Florian Tobias Schandinat' <FlorianSchandinat@gmx.de>,
	dri-devel@lists.freedesktop.org,
	'Tomi Valkeinen' <tomi.valkeinen@ti.com>,
	'Rob Herring' <robherring2@gmail.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	kernel@pengutronix.de,
	'Guennady Liakhovetski' <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, 'Jingoo Han' <jg1.han@samsung.com>
References: <1359104515-8907-1-git-send-email-s.trumtrar@pengutronix.de>
 <1359104515-8907-5-git-send-email-s.trumtrar@pengutronix.de>
In-reply-to: <1359104515-8907-5-git-send-email-s.trumtrar@pengutronix.de>
Subject: RE: [PATCH v17 4/7] fbmon: add videomode helpers
Date: Fri, 01 Feb 2013 18:29:50 +0900
Message-id: <003401ce005e$af665c50$0e3314f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: ko
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday, January 25, 2013 6:02 PM, Steffen Trumtrar wrote
> 
> Add a function to convert from the generic videomode to a fb_videomode.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Tested-by: Afzal Mohammed <Afzal@ti.com>
> Tested-by: Rob Clark <robclark@gmail.com>
> Tested-by: Leela Krishna Amudala <leelakrishna.a@gmail.com>
> ---
>  drivers/video/fbmon.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h    |    4 ++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index cef6557..17ce135 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -31,6 +31,7 @@
>  #include <linux/pci.h>
>  #include <linux/slab.h>
>  #include <video/edid.h>
> +#include <video/videomode.h>
>  #ifdef CONFIG_PPC_OF
>  #include <asm/prom.h>
>  #include <asm/pci-bridge.h>
> @@ -1373,6 +1374,57 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
>  	kfree(timings);
>  	return err;
>  }
> +
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int fb_videomode_from_videomode(const struct videomode *vm,
> +				struct fb_videomode *fbmode)
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
> +	fbmode->pixclock = vm->pixelclock ?
> +			KHZ2PICOS(vm->pixelclock / 1000) : 0;
> +
> +	fbmode->sync = 0;
> +	fbmode->vmode = 0;
> +	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)
> +		fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> +	if (vm->dmt_flags & VESA_DMT_HSYNC_HIGH)

Hi Steffen Trumtrar,

Um, it seems to be a type. 'H'SYNC -> 'V'SYNC
Thus, it would be changed as below:

    VESA_DMT_HSYNC_HIGH -> VESA_DMT_VSYNC_HIGH


Best regards,
Jingoo Han

> +		fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> +	if (vm->data_flags & DISPLAY_FLAGS_INTERLACED)
> +		fbmode->vmode |= FB_VMODE_INTERLACED;
> +	if (vm->data_flags & DISPLAY_FLAGS_DOUBLESCAN)
> +		fbmode->vmode |= FB_VMODE_DOUBLE;
> +	fbmode->flag = 0;
> +
> +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> +		 vm->hsync_len;
> +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> +		 vm->vsync_len;
> +	/* prevent division by zero */
> +	if (htotal && vtotal) {
> +		fbmode->refresh = vm->pixelclock / (htotal * vtotal);
> +	/* a mode must have htotal and vtotal != 0 or it is invalid */
> +	} else {
> +		fbmode->refresh = 0;
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> +#endif
> +
>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..100a176 100644
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
> @@ -714,6 +715,9 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> 
> +extern int fb_videomode_from_videomode(const struct videomode *vm,
> +				       struct fb_videomode *fbmode);
> +
>  /* drivers/video/modedb.c */
>  #define VESA_MODEDB_SIZE 34
>  extern void fb_var_to_videomode(struct fb_videomode *mode,
> --
> 1.7.10.4
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

