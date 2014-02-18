Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.pmeerw.net ([87.118.82.44]:36126 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaBRHyG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Feb 2014 02:54:06 -0500
Date: Tue, 18 Feb 2014 08:54:01 +0100 (CET)
From: Peter Meerwald <pmeerw@pmeerw.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/2] OMAP3 ISP pipeline validation patches
In-Reply-To: <52FF3FA6.1080903@iki.fi>
Message-ID: <alpine.DEB.2.01.1402180853300.17228@pmeerw.net>
References: <1392427195-2017-1-git-send-email-laurent.pinchart@ideasonboard.com> <52FF3FA6.1080903@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> > Those two patches fix the OMAP3 ISP pipeline validation when locating the
> > external subdevice.
> > 
> > The code currently works by chance with memory-to-memory pipelines, as it
> > tries to locate the external subdevice when none is available, but ignores the
> > failure due to a bug. This patch set fixes both issues.
> > 
> > Peter, could you check whether this fixes the warning you've reported ?
> > 
> > Laurent Pinchart (2):
> >   omap3isp: Don't try to locate external subdev for mem-to-mem pipelines
> >   omap3isp: Don't ignore failure to locate external subdev
> 
> To both:
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

both
Tested-by: Peter Meerwald <pmeerw@pmeerw.net>

thanks, p.

-- 

Peter Meerwald
+43-664-2444418 (mobile)
