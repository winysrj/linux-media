Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60525 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab3AGBMn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 Jan 2013 20:12:43 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>, linux-omap@vger.kernel.org
Subject: Re: [PATCH] omap3isp: Don't include <plat/cpu.h>
Date: Mon, 07 Jan 2013 02:14:20 +0100
Message-ID: <30855273.UsAOH7UnCd@avalon>
In-Reply-To: <20130106111039.627d5dab@redhat.com>
References: <1357248204-9863-1-git-send-email-laurent.pinchart@ideasonboard.com> <20130103225541.GK25633@atomide.com> <20130106111039.627d5dab@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sunday 06 January 2013 11:10:39 Mauro Carvalho Chehab wrote:
> Em Thu, 3 Jan 2013 14:55:41 -0800 Tony Lindgren escreveu:
> > * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [130103 13:24]:
> > > The plat/*.h headers are not available to drivers in multiplatform
> > > kernels. As the header isn't needed, just remove it.
> > 
> > Please consider merging this for the -rc cycle, so I can make
> > plat/cpu.h produce an error for omap2+ to prevent new drivers
> > including it.
> 
> Ok, I'll add it to the list of patches for 3.8.

Thank you.

Could you please also add "omap3isp: Don't include deleted OMAP plat/ header 
files" to that list ? And Sakari, could you please ack it ?

> > Acked-by: Tony Lindgren <tony@atomide.com>
> > 
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > > 
> > >  drivers/media/platform/omap3isp/isp.c |    2 --
> > >  1 files changed, 0 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/platform/omap3isp/isp.c
> > > b/drivers/media/platform/omap3isp/isp.c index 50cea08..07eea5b 100644
> > > --- a/drivers/media/platform/omap3isp/isp.c
> > > +++ b/drivers/media/platform/omap3isp/isp.c
> > > @@ -71,8 +71,6 @@
> > > 
> > >  #include <media/v4l2-common.h>
> > >  #include <media/v4l2-device.h>
> > > 
> > > -#include <plat/cpu.h>
> > > -
> > > 
> > >  #include "isp.h"
> > >  #include "ispreg.h"
> > >  #include "ispccdc.h"

-- 
Regards,

Laurent Pinchart

