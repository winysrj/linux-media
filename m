Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50119 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3AYIEn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jan 2013 03:04:43 -0500
Date: Fri, 25 Jan 2013 09:04:26 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: "Mohammed, Afzal" <afzal@ti.com>
Cc: Leela Krishna Amudala <leelakrishna.a@gmail.com>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	David Airlie <airlied@linux.ie>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Rob Clark <robdclark@gmail.com>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v16 RESEND 0/7] of: add display helper
Message-ID: <20130125080426.GA6937@pengutronix.de>
References: <1358766482-6275-1-git-send-email-s.trumtrar@pengutronix.de>
 <CAF6AEGvFNA1gc_5XWqL_baEnn8DTn0R-xqui034rg3Eo-V_6Qw@mail.gmail.com>
 <20130123091202.GA11828@pengutronix.de>
 <CAL1wa8d6wXdxgVJ=c2ma2Adm-RkF3S5ga219dSrh1fFo0L9X8w@mail.gmail.com>
 <20130124081958.GA28406@pengutronix.de>
 <C8443D0743D26F4388EA172BF4E2A7A93EA928F9@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93EA928F9@DBDE01.ent.ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Afzal,

On Thu, Jan 24, 2013 at 08:47:02AM +0000, Mohammed, Afzal wrote:
> Hi Steffen,
> 
> On Thu, Jan 24, 2013 at 13:49:58, Steffen Trumtrar wrote:
> 
> > Thanks. I'll use that opportunity for a v17 that is rebased onto 3.8-rc4.
> 
> As you are going to have a v17, if you can fold the diff[1]
> (that I mentioned earlier) into the patch,
> "fbmon: add of_videomode helpers", it would be helpful. 
> 

I thought about it and I will not include that patch. Sorry.
In one of the previous versions of the series I had something like that and
it was suggested to remove it. If I leave it like it is, one gets a compile
time error like you do. And that is correct, because you shouldn't use the
function if you do not have of_videomode enabled. You should use one of the
underlying functions that are non-DT and called by of_get_fb_videomode.

Regards,
Steffen

> Regards
> Afzal
> 
> [1]
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

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
