Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:40494 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab2BYBt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Feb 2012 20:49:29 -0500
Date: Sat, 25 Feb 2012 03:49:25 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH v3 29/33] omap3isp: Configure CSI-2 phy based on
 platform data
Message-ID: <20120225014925.GF12602@valkosipuli.localdomain>
References: <20120220015605.GI7784@valkosipuli.localdomain>
 <1329703032-31314-29-git-send-email-sakari.ailus@iki.fi>
 <4450280.jxRHUOfzMq@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4450280.jxRHUOfzMq@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 22, 2012 at 12:21:50PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Monday 20 February 2012 03:57:08 Sakari Ailus wrote:
> > Configure CSI-2 phy based on platform data in the ISP driver. For that, the
> > new V4L2_CID_IMAGE_SOURCE_PIXEL_RATE control is used. Previously the same
> > was configured from the board code.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> [snip]
> 
> > diff --git a/drivers/media/video/omap3isp/ispcsiphy.c
> > b/drivers/media/video/omap3isp/ispcsiphy.c index 5be37ce..902477d 100644
> > --- a/drivers/media/video/omap3isp/ispcsiphy.c
> > +++ b/drivers/media/video/omap3isp/ispcsiphy.c
> > @@ -28,41 +28,13 @@
> >  #include <linux/device.h>
> >  #include <linux/regulator/consumer.h>
> > 
> > +#include "../../../../arch/arm/mach-omap2/control.h"
> 
> I expect you will have to fix that somehow, but as far as I'm concerned,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks. I don't think I like this any more than you do, but my understandint
is there is no good solution to this _right now_, and the proper solution
won't be that far away anyway, so I just intend to keep it as-is for now.

Cheers,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
