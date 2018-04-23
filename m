Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:40782 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755215AbeDWN4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 09:56:06 -0400
Date: Mon, 23 Apr 2018 10:55:57 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
Message-ID: <20180423105557.267c5ecf@vento.lan>
In-Reply-To: <2542100.cElVns0SR0@amdc3058>
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <CGME20180420174303epcas3p14e08a828d2547e3365085f43b165d34b@epcas3p1.samsung.com>
        <c6ef815da57085bf7e98753463e551905f5d2706.1524245455.git.mchehab@s-opensource.com>
        <2542100.cElVns0SR0@amdc3058>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 23 Apr 2018 14:47:28 +0200
Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:

> On Friday, April 20, 2018 01:42:51 PM Mauro Carvalho Chehab wrote:
> > Add stubs for omapfb_dss.h, in the case it is included by
> > some driver when CONFIG_FB_OMAP2 is not defined, with can
> > happen on ARM when DRM_OMAP is not 'n'.
> > 
> > That allows building such driver(s) with COMPILE_TEST.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> This patch should be dropped (together with patch #6/7) as it was
> superseded by a better solution suggested by Laurent:
> 
> https://patchwork.kernel.org/patch/10325193/
> 
> ACK-ed by Tomi:
> 
> https://www.spinics.net/lists/dri-devel/msg171918.html
> 
> and already merged by you (commit 7378f1149884 "media: omap2:
> omapfb: allow building it with COMPILE_TEST")..

I "ressurected" this patch due to patch 6/7.

The problem with the solution already acked/merged is that
it works *only* if you don't try to build for ARM.

At the moment you want to build a FB_OMAP2-dependent driver
on ARM with allyesc onfig, DRM_OMAP will be true, and FB_OMAP2
will be disabled:

	menuconfig FB_OMAP2
        	tristate "OMAP2+ frame buffer support"
	        depends on FB
        	depends on DRM_OMAP = n

One solution might be to change the depends on to:
        	depends on (DRM_OMAP = n || COMPILE_TEST)

But someone pointed me that the above check was added to avoid building
duplicated symbols. So, the above would cause build failures.

So, in order to build for ARM with DRM_OMAP selected (allyesconfig,
allmodconfig), we have the following alternatives:

	1) apply patch 5/7;
	2) make sure that FB_OMAP2 and DRM_OMAP won't declare the
	   same non-static symbols;
	3) redesign FB_OMAP2 to work with DRM_OMAP built.

I suspect that (1) is easier.

Thanks,
Mauro
