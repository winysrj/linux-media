Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab3AFNLW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 08:11:22 -0500
Date: Sun, 6 Jan 2013 11:10:39 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Don't include <plat/cpu.h>
Message-ID: <20130106111039.627d5dab@redhat.com>
In-Reply-To: <20130103225541.GK25633@atomide.com>
References: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<20130103225541.GK25633@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 3 Jan 2013 14:55:41 -0800
Tony Lindgren <tony@atomide.com> escreveu:

> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [130103 13:24]:
> > The plat/*.h headers are not available to drivers in multiplatform
> > kernels. As the header isn't needed, just remove it.
> 
> Please consider merging this for the -rc cycle, so I can make
> plat/cpu.h produce an error for omap2+ to prevent new drivers
> including it.

Ok, I'll add it to the list of patches for 3.8.

Regards,
Mauro
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
>  
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/media/platform/omap3isp/isp.c |    2 --
> >  1 files changed, 0 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
> > index 50cea08..07eea5b 100644
> > --- a/drivers/media/platform/omap3isp/isp.c
> > +++ b/drivers/media/platform/omap3isp/isp.c
> > @@ -71,8 +71,6 @@
> >  #include <media/v4l2-common.h>
> >  #include <media/v4l2-device.h>
> >  
> > -#include <plat/cpu.h>
> > -
> >  #include "isp.h"
> >  #include "ispreg.h"
> >  #include "ispccdc.h"
> > -- 
> > Regards,
> > 
> > Laurent Pinchart
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
