Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39958 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932257AbeDWTry (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 15:47:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with COMPILE_TEST && DRM_OMAP
Date: Mon, 23 Apr 2018 22:48:06 +0300
Message-ID: <2458408.nymfr4Soza@avalon>
In-Reply-To: <20180423112227.61fbc02b@vento.lan>
References: <cover.1524245455.git.mchehab@s-opensource.com> <5379683.QunLsIS18Z@amdc3058> <20180423112227.61fbc02b@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Monday, 23 April 2018 17:22:27 EEST Mauro Carvalho Chehab wrote:
> Em Mon, 23 Apr 2018 15:56:53 +0200 Bartlomiej Zolnierkiewicz escreveu:
> > On Monday, April 23, 2018 02:47:28 PM Bartlomiej Zolnierkiewicz wrote:
> >> On Friday, April 20, 2018 01:42:51 PM Mauro Carvalho Chehab wrote:
> >>> Add stubs for omapfb_dss.h, in the case it is included by
> >>> some driver when CONFIG_FB_OMAP2 is not defined, with can
> >>> happen on ARM when DRM_OMAP is not 'n'.
> >>> 
> >>> That allows building such driver(s) with COMPILE_TEST.
> >>> 
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> >> 
> >> This patch should be dropped (together with patch #6/7) as it was
> >> superseded by a better solution suggested by Laurent:
> >> 
> >> https://patchwork.kernel.org/patch/10325193/
> >> 
> >> ACK-ed by Tomi:
> >> 
> >> https://www.spinics.net/lists/dri-devel/msg171918.html
> >> 
> >> and already merged by you (commit 7378f1149884 "media: omap2:
> >> omapfb: allow building it with COMPILE_TEST")..
> > 
> > Hmm, I see now while this patch is still included:
> > 
> > menuconfig FB_OMAP2
> >         tristate "OMAP2+ frame buffer support"
> >         depends on FB
> >         depends on DRM_OMAP = n
> > 
> > Ideally we should be able to build both drivers in the same kernel
> > (especially as modules).
> > 
> > I was hoping that it could be fixed easily but then I discovered
> > the root source of the problem:
> > 
> > drivers/gpu/drm/omapdrm/dss/display.o: In function
> > `omapdss_unregister_display': display.c:(.text+0x2c): multiple definition
> > of `omapdss_unregister_display'
> > drivers/video/fbdev/omap2/omapfb/dss/display.o:display.c:(.text+0x198):
> > first defined here ...
> 
> Yes, and declared on two different places:
> 
> drivers/gpu/drm/omapdrm/dss/omapdss.h:void omapdss_unregister_display(struct
> omap_dss_device *dssdev); include/video/omapfb_dss.h:void
> omapdss_unregister_display(struct omap_dss_device *dssdev);
> 
> one alternative would be to give different names to it, and a common
> header for both.
> 
> At such header, it could be doing something like:
> 
> static inline void omapdss_unregister_display(struct omap_dss_device
> *dssdev) {
> #if enabled(CONFIG_DRM_OMAP)
> 	omapdss_unregister_display_drm(struct omap_dss_device *dssdev);
> #else
> 	omapdss_unregister_display_fb(struct omap_dss_device *dssdev);
> ##endif
> }
> 
> Yet, after a very quick check, it seems that nowadays only the
> media omap driver uses the symbols at FB_OMAP:
> 
> $ git grep omapfb_dss.h
> drivers/media/platform/omap/omap_vout.c:#include <video/omapfb_dss.h>
> drivers/media/platform/omap/omap_voutdef.h:#include <video/omapfb_dss.h>
> drivers/media/platform/omap/omap_voutlib.c:#include <video/omapfb_dss.h>
> 
> So, perhaps just renaming the common symbols and changing FB_OMAP2 to:
> 
> 	menuconfig FB_OMAP2
> 	         tristate "OMAP2+ frame buffer support"
> 	         depends on FB
> 	         depends on (DRM_OMAP = n) || COMPILE_TEST
> 
> would be enough to allow to build both on ARM.

I don't think it's worth it renaming the common symbols. They will change over 
time as omapdrm is under heavy rework, and it's painful enough without having 
to handle cross-tree changes. Let's just live with the fact that both drivers 
can't be compiled at the same time, given that omapfb is deprecated.

> > I need some more time to think about this..

-- 
Regards,

Laurent Pinchart
