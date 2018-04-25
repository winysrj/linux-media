Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:47039 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754479AbeDYKrk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Apr 2018 06:47:40 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20180425104738euoutp01a1bbe09b476c13e39e9e80aa03a3c91b~oqA99Fc2Y1388013880euoutp01k
        for <linux-media@vger.kernel.org>; Wed, 25 Apr 2018 10:47:38 +0000 (GMT)
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH 5/7] omapfb: omapfb_dss.h: add stubs to build with
 COMPILE_TEST && DRM_OMAP
Date: Wed, 25 Apr 2018 12:47:34 +0200
Message-ID: <52576986.R85hrt8lfa@amdc3058>
In-Reply-To: <20180423105557.267c5ecf@vento.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
References: <cover.1524245455.git.mchehab@s-opensource.com>
        <2542100.cElVns0SR0@amdc3058> <20180423105557.267c5ecf@vento.lan>
        <CGME20180425104736eucas1p1b448ce1c188b661c5e743217511110d7@eucas1p1.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, April 23, 2018 10:55:57 AM Mauro Carvalho Chehab wrote:
> Em Mon, 23 Apr 2018 14:47:28 +0200
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> escreveu:
> 
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
> I "ressurected" this patch due to patch 6/7.
> 
> The problem with the solution already acked/merged is that
> it works *only* if you don't try to build for ARM.
> 
> At the moment you want to build a FB_OMAP2-dependent driver
> on ARM with allyesc onfig, DRM_OMAP will be true, and FB_OMAP2
> will be disabled:
> 
> 	menuconfig FB_OMAP2
>         	tristate "OMAP2+ frame buffer support"
> 	        depends on FB
>         	depends on DRM_OMAP = n
> 
> One solution might be to change the depends on to:
>         	depends on (DRM_OMAP = n || COMPILE_TEST)
> 
> But someone pointed me that the above check was added to avoid building
> duplicated symbols. So, the above would cause build failures.
> 
> So, in order to build for ARM with DRM_OMAP selected (allyesconfig,
> allmodconfig), we have the following alternatives:
> 
> 	1) apply patch 5/7;
> 	2) make sure that FB_OMAP2 and DRM_OMAP won't declare the
> 	   same non-static symbols;
> 	3) redesign FB_OMAP2 to work with DRM_OMAP built.
> 
> I suspect that (1) is easier.

I agree.

You can merge this patch through your tree with:

Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics
