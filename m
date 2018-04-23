Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:62053 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755385AbeDWOWi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 10:22:38 -0400
Date: Mon, 23 Apr 2018 11:22:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
Message-ID: <20180423112227.61fbc02b@vento.lan>
In-Reply-To: <5379683.QunLsIS18Z@amdc3058>
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <c6ef815da57085bf7e98753463e551905f5d2706.1524245455.git.mchehab@s-opensource.com>
        <2542100.cElVns0SR0@amdc3058>
        <CGME20180423135655eucas1p1a935ce9c167e52cf1e76adcc0b4486e4@eucas1p1.samsung.com>
        <5379683.QunLsIS18Z@amdc3058>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 15:56:53 +0200
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:

> On Monday, April 23, 2018 02:47:28 PM Bartlomiej Zolnierkiewicz wrote:
> > On Friday, April 20, 2018 01:42:51 PM Mauro Carvalho Chehab wrote:  
> > > Add stubs for omapfb_dss.h, in the case it is included by
> > > some driver when CONFIG_FB_OMAP2 is not defined, with can
> > > happen on ARM when DRM_OMAP is not 'n'.
> > > 
> > > That allows building such driver(s) with COMPILE_TEST.
> > > 
> > > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> > 
> > This patch should be dropped (together with patch #6/7) as it was
> > superseded by a better solution suggested by Laurent:
> > 
> > https://patchwork.kernel.org/patch/10325193/
> > 
> > ACK-ed by Tomi:
> > 
> > https://www.spinics.net/lists/dri-devel/msg171918.html
> > 
> > and already merged by you (commit 7378f1149884 "media: omap2:
> > omapfb: allow building it with COMPILE_TEST")..  
> 
> Hmm, I see now while this patch is still included:
> 
> menuconfig FB_OMAP2
>         tristate "OMAP2+ frame buffer support"
>         depends on FB
>         depends on DRM_OMAP = n
> 
> Ideally we should be able to build both drivers in the same kernel
> (especially as modules).
> 
> I was hoping that it could be fixed easily but then I discovered
> the root source of the problem:
> 
> drivers/gpu/drm/omapdrm/dss/display.o: In function `omapdss_unregister_display':
> display.c:(.text+0x2c): multiple definition of `omapdss_unregister_display'
> drivers/video/fbdev/omap2/omapfb/dss/display.o:display.c:(.text+0x198): first defined here
> ...

Yes, and declared on two different places:

drivers/gpu/drm/omapdrm/dss/omapdss.h:void omapdss_unregister_display(struct omap_dss_device *dssdev);
include/video/omapfb_dss.h:void omapdss_unregister_display(struct omap_dss_device *dssdev);

one alternative would be to give different names to it, and a common
header for both.

At such header, it could be doing something like:

static inline void omapdss_unregister_display(struct omap_dss_device *dssdev)
{
#if enabled(CONFIG_DRM_OMAP)
	omapdss_unregister_display_drm(struct omap_dss_device *dssdev);
#else
	omapdss_unregister_display_fb(struct omap_dss_device *dssdev);
##endif
}

Yet, after a very quick check, it seems that nowadays only the
media omap driver uses the symbols at FB_OMAP:

$ git grep omapfb_dss.h
drivers/media/platform/omap/omap_vout.c:#include <video/omapfb_dss.h>
drivers/media/platform/omap/omap_voutdef.h:#include <video/omapfb_dss.h>
drivers/media/platform/omap/omap_voutlib.c:#include <video/omapfb_dss.h>

So, perhaps just renaming the common symbols and changing FB_OMAP2 to:

	menuconfig FB_OMAP2
	         tristate "OMAP2+ frame buffer support"
	         depends on FB
	         depends on (DRM_OMAP = n) || COMPILE_TEST

would be enough to allow to build both on ARM.

> I need some more time to think about this..
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics

Thanks,
Mauro
