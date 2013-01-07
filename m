Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32768 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab3AGIHD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 03:07:03 -0500
Date: Mon, 7 Jan 2013 09:06:48 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: "devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	David Airlie <airlied@linux.ie>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv16 5/7] fbmon: add of_videomode helpers
Message-ID: <20130107080648.GB23478@pengutronix.de>
References: <1355850256-16135-1-git-send-email-s.trumtrar@pengutronix.de>
 <1355850256-16135-6-git-send-email-s.trumtrar@pengutronix.de>
 <C8443D0743D26F4388EA172BF4E2A7A93EA7FB02@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA7FB02@DBDE01.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Afzal,

On Mon, Jan 07, 2013 at 06:10:13AM +0000, Mohammed, Afzal wrote:
> Hi Steffen,
> 
> On Tue, Dec 18, 2012 at 22:34:14, Steffen Trumtrar wrote:
> > Add helper to get fb_videomode from devicetree.
> 
> >  drivers/video/fbmon.c |   42 ++++++++++++++++++++++++++++++++++++++++++
> >  include/linux/fb.h    |    4 ++++
> 
> This breaks DaVinci (da8xx_omapl_defconfig), following change was
> required to get it build if OF_VIDEOMODE or/and FB_MODE_HELPERS
> is not defined. There may be better solutions, following was the
> one that was used by me to test this series.
> 
> ---8<----------
> 
> diff --git a/include/linux/fb.h b/include/linux/fb.h
> index 58b9860..0ce30d1 100644
> --- a/include/linux/fb.h
> +++ b/include/linux/fb.h
> @@ -716,9 +716,19 @@ extern void fb_destroy_modedb(struct fb_videomode *modedb);
>  extern int fb_find_mode_cvt(struct fb_videomode *mode, int margins, int rb);
>  extern unsigned char *fb_ddc_read(struct i2c_adapter *adapter);
> 
> +#if defined(CONFIG_OF_VIDEOMODE) && defined(CONFIG_FB_MODE_HELPERS)
>  extern int of_get_fb_videomode(struct device_node *np,
>                                struct fb_videomode *fb,
>                                int index);
> +#else
> +static inline int of_get_fb_videomode(struct device_node *np,
> +                                     struct fb_videomode *fb,
> +                                     int index)
> +{
> +       return -EINVAL;
> +}
> +#endif
> +
>  extern int fb_videomode_from_videomode(const struct videomode *vm,
>                                        struct fb_videomode *fbmode);
> 
> ---8<----------
> 

I just did a quick "make da8xx_omapl_defconfig && make" and it builds just fine.
On what version did you apply the series?
At the moment I have the series sitting on 3.7. Didn't try any 3.8-rcx yet.
But fixing this shouldn't be a problem.

> 
> > +#if IS_ENABLED(CONFIG_OF_VIDEOMODE)
> 
> As _OF_VIDEOMODE is a bool type CONFIG, isn't,
> 
> #ifdef CONFIG_OF_VIDEOMODE
> 
> sufficient ?
> 

Yes, that is right. But I think IS_ENABLED is the preferred way to do it, isn't it?

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
