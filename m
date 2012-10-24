Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58615 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017Ab2JXXwm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 19:52:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
Date: Thu, 25 Oct 2012 01:53:32 +0200
Message-ID: <2126833.cqGngBPXg2@avalon>
In-Reply-To: <20121024223412.GM5605@atomide.com>
References: <20121018202707.11834.1438.stgit@muffinssi.local> <2071397.IU49JkAq1T@avalon> <20121024223412.GM5605@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Wednesday 24 October 2012 15:34:12 Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121019 02:41]:
> > On Thursday 18 October 2012 13:28:42 Tony Lindgren wrote:
> > > --- a/arch/arm/mach-omap2/iommu2.c
> > > +++ b/arch/arm/mach-omap2/iommu2.c
> > > @@ -17,6 +17,7 @@
> > > 
> > >  #include <linux/module.h>
> > >  #include <linux/slab.h>
> > >  #include <linux/stringify.h>
> > > 
> > > +#include <linux/omap-iommu.h>
> > 
> > Nitpicking, please keep the headers sorted alphabetically, here and in all
> > locations below (especially the OMAP3 ISP driver).
> > 
> > (OK, there's already one misplaced #include, but let's not make it worse
> > :-))
>
> This is fixed now.
> 
> > > --- /dev/null
> > > +++ b/include/linux/omap-iommu.h
> > > @@ -0,0 +1,47 @@
> > > +/*
> > > + * omap iommu: simple virtual address space management
> > > + *
> > > + * Copyright (C) 2008-2009 Nokia Corporation
> > > + *
> > > + * Written by Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or modify
> > > + * it under the terms of the GNU General Public License version 2 as
> > > + * published by the Free Software Foundation.
> > > + */
> > 
> > Missing #ifndef #define ... #endif
> 
> I've added it as _OMAP_IOMMU_H_, looks like both intel-iommu.h and
> amd-iommu.h have it.
> 
> Hopefully that's OK for you as a base to do further iommu patches
> on, updated patch below.
> 
> BTW, doing a test compile on v3.7-rc2, I'm seeing the following warnings
> for omap3isp for isp_video_ioctl_ops:
> 
> drivers/media/platform/omap3isp/ispvideo.c:1213: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/ispccdc.c:2303: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/ispccdc.c:2304: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/isph3a_aewb.c:282: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/isph3a_aewb.c:283: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/isph3a_af.c:347: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/isph3a_af.c:348: warning: initialization
> from incompatible pointer type
> drivers/media/platform/omap3isp/isphist.c:453: warning: initialization from
> incompatible pointer type
> drivers/media/platform/omap3isp/isphist.c:454: warning: initialization from
> incompatible pointer type

I've just sent a pull request to linux-media for v3.7 with fixes for those.
 
-- 
Regards,

Laurent Pinchart

