Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56612 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2JLBHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Oct 2012 21:07:08 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Tony Lindgren <tony@atomide.com>, Ido Yariv <ido@wizery.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] [media] omap3isp: Fix compilation error in ispreg.h
Date: Fri, 12 Oct 2012 03:07:53 +0200
Message-ID: <1748868.I6tVCYli6M@avalon>
In-Reply-To: <20121007101718.073aed3b@infradead.org>
References: <20120927195526.GP4840@atomide.com> <20121002163158.GR4840@atomide.com> <20121007101718.073aed3b@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sunday 07 October 2012 10:17:18 Mauro Carvalho Chehab wrote:
> Em Tue, 2 Oct 2012 09:31:58 -0700 Tony Lindgren escreveu:
> > * Ido Yariv <ido@wizery.com> [121001 15:48]:
> > > Commit c49f34bc ("ARM: OMAP2+ Move SoC specific headers to be local to
> > > mach-omap2") moved omap34xx.h to mach-omap2. This broke omap3isp, as it
> > > includes omap34xx.h.
> > > 
> > > Instead of moving omap34xx to platform_data, simply add the two
> > > definitions the driver needs and remove the include altogether.
> > > 
> > > Signed-off-by: Ido Yariv <ido@wizery.com>
> > 
> > I'm assuming that Mauro picks this one up, sorry
> > for breaking it.
> 
> Picked, thanks.
> 
> With regards to the other patches in this series, IMHO, it
> makes more sense to go through arm omap tree, so, for the
> patches on this series that touch at drivers/media/platform/*:
> 
> Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> > Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> > > ---
> > > 
> > >  drivers/media/platform/omap3isp/ispreg.h | 6 +++---
> > >  1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/omap3isp/ispreg.h
> > > b/drivers/media/platform/omap3isp/ispreg.h index 084ea77..e2c57f3
> > > 100644
> > > --- a/drivers/media/platform/omap3isp/ispreg.h
> > > +++ b/drivers/media/platform/omap3isp/ispreg.h
> > > @@ -27,13 +27,13 @@
> > > 
> > >  #ifndef OMAP3_ISP_REG_H
> > >  #define OMAP3_ISP_REG_H
> > > 
> > > -#include <plat/omap34xx.h>
> > > -
> > > -
> > > 
> > >  #define CM_CAM_MCLK_HZ			172800000	/* Hz */
> > >  
> > >  /* ISP Submodules offset */
> > > 
> > > +#define L4_34XX_BASE			0x48000000
> > > +#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
> > > +
> > > 
> > >  #define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
> > >  #define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))

I'll send a follow-up patch that removes all those definitions as they're 
actually not needed.

-- 
Regards,

Laurent Pinchart

