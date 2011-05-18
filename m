Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316Ab1ERHuz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 May 2011 03:50:55 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 2/2] OMAP3BEAGLE: Add support for mt9p031 sensor (LI-5M03 module).
Date: Wed, 18 May 2011 09:50:54 +0200
Cc: Javier Martin <javier.martin@vista-silicon.com>,
	linux-media@vger.kernel.org, beagleboard@googlegroups.com,
	carlighting@yahoo.co.nz, g.liakhovetski@gmx.de,
	linux-arm-kernel@lists.infradead.org
References: <1305624528-5595-1-git-send-email-javier.martin@vista-silicon.com> <1305624528-5595-3-git-send-email-javier.martin@vista-silicon.com> <20110517230821.GA5913@n2100.arm.linux.org.uk>
In-Reply-To: <20110517230821.GA5913@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180950.55287.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Russell,

On Wednesday 18 May 2011 01:08:21 Russell King - ARM Linux wrote:
> On Tue, May 17, 2011 at 11:28:48AM +0200, Javier Martin wrote:
> > +#include "devices.h"
> > +#include "../../../drivers/media/video/omap3isp/isp.h"
> > +#include "../../../drivers/media/video/omap3isp/ispreg.h"
> 
> This suggests that there's something very wrong with what's going on;
> it suggests that you're trying to access driver internals which should
> be handled via some better means.  And it looks like it's this:

> > @@ -654,6 +715,62 @@ static void __init beagle_opp_init(void)
> > 
> >  	return;
> >  
> >  }
> > 
> > +extern struct platform_device omap3isp_device;
> > +
> > +static int beagle_cam_set_xclk(struct v4l2_subdev *subdev, int hz)
> > +{
> > +	struct isp_device *isp = platform_get_drvdata(&omap3isp_device);
> > +	int ret;
> > +
> > +	ret = isp->platform_cb.set_xclk(isp, hz, MT9P031_XCLK);
> > +	return 0;
> > +}
> 
> That really needs fixing in a different way.

I plan to look into whether I can expose the OMAP3 ISP clocks through the 
Linux clock framework.

-- 
Regards,

Laurent Pinchart
