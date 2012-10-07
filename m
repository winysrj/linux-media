Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:48633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2JGNR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Oct 2012 09:17:27 -0400
Date: Sun, 7 Oct 2012 10:17:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Ido Yariv <ido@wizery.com>, Russell King <linux@arm.linux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/5] [media] omap3isp: Fix compilation error in
 ispreg.h
Message-ID: <20121007101718.073aed3b@infradead.org>
In-Reply-To: <20121002163158.GR4840@atomide.com>
References: <20120927195526.GP4840@atomide.com>
	<1349131591-10804-1-git-send-email-ido@wizery.com>
	<20121002163158.GR4840@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 2 Oct 2012 09:31:58 -0700
Tony Lindgren <tony@atomide.com> escreveu:

> * Ido Yariv <ido@wizery.com> [121001 15:48]:
> > Commit c49f34bc ("ARM: OMAP2+ Move SoC specific headers to be local to
> > mach-omap2") moved omap34xx.h to mach-omap2. This broke omap3isp, as it
> > includes omap34xx.h.
> > 
> > Instead of moving omap34xx to platform_data, simply add the two
> > definitions the driver needs and remove the include altogether.
> > 
> > Signed-off-by: Ido Yariv <ido@wizery.com>
> 
> I'm assuming that Mauro picks this one up, sorry
> for breaking it.

Picked, thanks. 

With regards to the other patches in this series, IMHO, it
makes more sense to go through arm omap tree, so, for the
patches on this series that touch at drivers/media/platform/*:

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 
> > ---
> >  drivers/media/platform/omap3isp/ispreg.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/ispreg.h b/drivers/media/platform/omap3isp/ispreg.h
> > index 084ea77..e2c57f3 100644
> > --- a/drivers/media/platform/omap3isp/ispreg.h
> > +++ b/drivers/media/platform/omap3isp/ispreg.h
> > @@ -27,13 +27,13 @@
> >  #ifndef OMAP3_ISP_REG_H
> >  #define OMAP3_ISP_REG_H
> >  
> > -#include <plat/omap34xx.h>
> > -
> > -
> >  #define CM_CAM_MCLK_HZ			172800000	/* Hz */
> >  
> >  /* ISP Submodules offset */
> >  
> > +#define L4_34XX_BASE			0x48000000
> > +#define OMAP3430_ISP_BASE		(L4_34XX_BASE + 0xBC000)
> > +
> >  #define OMAP3ISP_REG_BASE		OMAP3430_ISP_BASE
> >  #define OMAP3ISP_REG(offset)		(OMAP3ISP_REG_BASE + (offset))
> >  
> > -- 
> > 1.7.11.4
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
