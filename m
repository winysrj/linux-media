Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60712 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab2KUL6b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Nov 2012 06:58:31 -0500
Date: Wed, 21 Nov 2012 12:58:18 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Leela Krishna Amudala <leelakrishna.a@gmail.com>
Cc: "Manjunathappa, Prakash" <prakash.pm@ti.com>,
	"devicetree-discuss@lists.ozlabs.org"
	<devicetree-discuss@lists.ozlabs.org>,
	"linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
	David Airlie <airlied@linux.ie>,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	"Valkeinen, Tomi" <tomi.valkeinen@ti.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"kernel@pengutronix.de" <kernel@pengutronix.de>,
	Guennady Liakhovetski <g.liakhovetski@gmx.de>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v12 3/6] fbmon: add videomode helpers
Message-ID: <20121121115818.GD14013@pengutronix.de>
References: <1353426896-6045-1-git-send-email-s.trumtrar@pengutronix.de>
 <1353426896-6045-4-git-send-email-s.trumtrar@pengutronix.de>
 <A73F36158E33644199EB82C5EC81C7BC3E9FA769@DBDE01.ent.ti.com>
 <CAL1wa8dQ4QL0SzbXdo8nogBfBjQ8GpaJ134v6zu_iMkWQeXefA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1wa8dQ4QL0SzbXdo8nogBfBjQ8GpaJ134v6zu_iMkWQeXefA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

On Wed, Nov 21, 2012 at 04:39:01PM +0530, Leela Krishna Amudala wrote:
> Yes,
> Even I got the same build error.
> later I fixed it by including "#include <linux/mxsfb.h>"
> 
> Best Wishes,
> Leela Krishna.
> 
> On Wed, Nov 21, 2012 at 3:39 PM, Manjunathappa, Prakash
> <prakash.pm@ti.com> wrote:
> > Hi Steffen,
> >
> > I am trying to add DT support for da8xx-fb driver on top of your patches.
> > Encountered below build error. Sorry for reporting it late.
> >
> > On Tue, Nov 20, 2012 at 21:24:53, Steffen Trumtrar wrote:
> >> Add a function to convert from the generic videomode to a fb_videomode.
> >>
> >> Signed-off-by: Steffen Trumtrar <s.trumtrar@pengutronix.de>
> >> Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
> >> Acked-by: Thierry Reding <thierry.reding@avionic-design.de>
> >> Tested-by: Thierry Reding <thierry.reding@avionic-design.de>
> >> Tested-by: Philipp Zabel <p.zabel@pengutronix.de>
> >> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >> ---
> >>  drivers/video/fbmon.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
> >>  include/linux/fb.h    |    6 ++++++
> >>  2 files changed, 52 insertions(+)
> >>
> >> diff --git a/drivers/video/fbmon.c b/drivers/video/fbmon.c
> >> index cef6557..c1939a6 100644
> >> --- a/drivers/video/fbmon.c
> >> +++ b/drivers/video/fbmon.c
> >> @@ -31,6 +31,7 @@
> >>  #include <linux/pci.h>
> >>  #include <linux/slab.h>
> >>  #include <video/edid.h>
> >> +#include <linux/videomode.h>
> >>  #ifdef CONFIG_PPC_OF
> >>  #include <asm/prom.h>
> >>  #include <asm/pci-bridge.h>
> >> @@ -1373,6 +1374,51 @@ int fb_get_mode(int flags, u32 val, struct fb_var_screeninfo *var, struct fb_inf
> >>       kfree(timings);
> >>       return err;
> >>  }
> >> +
> >> +#if IS_ENABLED(CONFIG_VIDEOMODE)
> >> +int fb_videomode_from_videomode(const struct videomode *vm,
> >> +                             struct fb_videomode *fbmode)
> >> +{
> >> +     unsigned int htotal, vtotal;
> >> +
> >> +     fbmode->xres = vm->hactive;
> >> +     fbmode->left_margin = vm->hback_porch;
> >> +     fbmode->right_margin = vm->hfront_porch;
> >> +     fbmode->hsync_len = vm->hsync_len;
> >> +
> >> +     fbmode->yres = vm->vactive;
> >> +     fbmode->upper_margin = vm->vback_porch;
> >> +     fbmode->lower_margin = vm->vfront_porch;
> >> +     fbmode->vsync_len = vm->vsync_len;
> >> +
> >> +     fbmode->pixclock = KHZ2PICOS(vm->pixelclock / 1000);
> >> +
> >> +     fbmode->sync = 0;
> >> +     fbmode->vmode = 0;
> >> +     if (vm->hah)
> >> +             fbmode->sync |= FB_SYNC_HOR_HIGH_ACT;
> >> +     if (vm->vah)
> >> +             fbmode->sync |= FB_SYNC_VERT_HIGH_ACT;
> >> +     if (vm->interlaced)
> >> +             fbmode->vmode |= FB_VMODE_INTERLACED;
> >> +     if (vm->doublescan)
> >> +             fbmode->vmode |= FB_VMODE_DOUBLE;
> >> +     if (vm->de)
> >> +             fbmode->sync |= FB_SYNC_DATA_ENABLE_HIGH_ACT;
> >
> > "FB_SYNC_DATA_ENABLE_HIGH_ACT" seems to be mxsfb specific flag, I am getting
> > build error on this. Please let me know if I am missing something.
> >
> > Thanks,
> > Prakash
> >

I compile-tested the series and didn't have that error. But obviously I should
have. As this is a mxsfs flag, I will throw it out.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
