Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:39510 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab2JaPaa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 31 Oct 2012 11:30:30 -0400
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
	"kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [PATCH v7 5/8] fbmon: add videomode helpers
Date: Wed, 31 Oct 2012 15:30:03 +0000
Message-ID: <A73F36158E33644199EB82C5EC81C7BC3E9E1B39@DBDE01.ent.ti.com>
References: <1351675689-26814-1-git-send-email-s.trumtrar@pengutronix.de>
 <1351675689-26814-6-git-send-email-s.trumtrar@pengutronix.de>
In-Reply-To: <1351675689-26814-6-git-send-email-s.trumtrar@pengutronix.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steffen,

On Wed, Oct 31, 2012 at 14:58:05, Steffen Trumtrar wrote:
> Add a function to convert from the generic videomode to a fb_videomode.
> 
> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> ---
>  drivers/video/fbmon.c |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/fb.h    |    2 ++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> index cef6557..b9e6ab3 100644
> --- a/drivers/video/fbmon.c
> +++ b/drivers/video/fbmon.c
> @@ -1373,6 +1373,42 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
>  	kfree(timings);
>  	return err;
>  }
> +
> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> +int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode)
> +{
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
> +

"pixelclk-inverted" property of the panel is not percolated fb_videomode.
Please let me know if I am missing something.

Thanks,
Prakash

> +	fbmode->refresh = 60;
> +	fbmode->flag = 0;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(videomode_to_fb_videomode);
> +#endif
> +
> +
>  #else
>  int fb_parse_edid(unsigned char *edid, struct fb_var_screeninfo *var)
>  {
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index c7a9571..46c665b 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -714,6 +714,8 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
>  
> +extern int videomode_to_fb_videomode(struct videomode *vm, struct fb_videomode *fbmode);
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

