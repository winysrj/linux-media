Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35760 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab2KUKKU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 05:10:20 -0500
From: "Manjunathappa, Prakash" <prakash.pm@ti.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>
CC: Rob Herring <robherring2@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	David Airlie <airlied@linux.ie>
Subject: RE: [PATCH v12 3/6] fbmon: add videomode helpers
Date: Wed, 21 Nov 2012 10:09:51 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3E9FA769@DBDE01.ent.ti.com>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

I am trying to add DT support for da8xx-fb driver on top of your patches.
Encountered below build error. Sorry for reporting it late.

On Tue, Nov 20, 2012 at 21:24:53, Steffen Trumtrar wrote:
> Add a function to convert from the generic videomode to a fb_videomode.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/video/fbmon.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h    |    6 ++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index cef6557..c1939a6 100644
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
> @@ -1373,6 +1374,51 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
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
> +	fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
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
> +	if (vm->de)
> +		fbmode->sync |= FB_SYNC_DATA_ENABLE_HIGH_ACT;

"FB_SYNC_DATA_ENABLE_HIGH_ACT" seems to be mxsfb specific flag, I am getting
build error on this. Please let me know if I am missing something.

Thanks,
Prakash

> +	fbmode->flag = 0;
> +
> +	htotal = vm->hactive + vm->hfront_porch + vm->hback_porch +
> +		 vm->hsync_len;
> +	vtotal = vm->vactive + vm->vfront_porch + vm->vback_porch +
> +		 vm->vsync_len;
> +	fbmode->refresh = (vm->pixelclock * 1000) / (htotal * vtotal);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fb_videomode_from_videomode);
> +#endif
> +
> +
>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..920cbe3 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -14,6 +14,7 @@
>  #include <linux/backlight.h>
>  #include <linux/slab.h>
>  #include <asm/io.h>
> +#include <linux/videomode.h>
>  
>  struct vm_area_struct;
>  struct fb_info;
> @@ -714,6 +715,11 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
>  
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +extern int fb_videomode_from_videomode(const struct videomode *vm,
> +				       struct fb_videomode *fbmode);
> +#endif
> +
>  /* drivers/video/modedb.c */
>  #define VESA_MODEDB_SIZE 34
>  extern void fb_var_to_videomode(struct fb_videomode *mode,
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

