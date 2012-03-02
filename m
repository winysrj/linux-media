Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39624 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2CBSFV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Mar 2012 13:05:21 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Kruno Mrak <kruno.mrak@matrix-vision.de>
Subject: Re: [PATCH] omap3isp: Fix frame number propagation
Date: Fri, 02 Mar 2012 19:05:38 +0100
Message-ID: <5501569.eNOdF1POb9@avalon>
In-Reply-To: <20120302175858.GE15695@valkosipuli.localdomain>
References: <1330685342-15139-1-git-send-email-laurent.pinchart@ideasonboard.com> <20120302175858.GE15695@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Friday 02 March 2012 19:58:59 Sakari Ailus wrote:
> On Fri, Mar 02, 2012 at 11:49:02AM +0100, Laurent Pinchart wrote:
> > When propagating the frame number through the pipeline, the frame number
> > must be incremented at frame start by the appropriate IRQ handler. This
> > was properly handled for the CSI2 and CCP2 receivers, but not when the
> > CCDC parallel interface is used.
> > 
> > ADD frame number incrementation to the HS/VS interrupt handler. As the
> > HS/VS interrupt is also generated for frames received by the CSI2 and
> > CCP2 receivers, remove explicit propagation handling from the serial
> > receivers.
> > 
> > Reported-by: Kruno Mrak <kruno.mrak@matrix-vision.de>
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/video/omap3isp/isp.c     |    8 --------
> >  drivers/media/video/omap3isp/ispccdc.c |    3 +++
> >  drivers/media/video/omap3isp/ispccp2.c |   23 -----------------------
> >  drivers/media/video/omap3isp/ispcsi2.c |   20 +++-----------------
> >  drivers/media/video/omap3isp/ispcsi2.h |    1 -
> >  5 files changed, 6 insertions(+), 49 deletions(-)
> 
> Thanks for the patch, Laurent!
> 
> Also, this patch simplifies frame numbering a lot.
> 
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> Tested-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Using CSI-2 receiver writing straight to memory, that is.
> 
> There's a slight dependency to my patches; are you going to submit this
> first or how shall we proceed? No conflicts but there's some fuzz
> nonetheless.

I'd like to submit the patch for v3.4. If your patch set is ready for v3.4 as 
well, we can push both through the same tree.

-- 
Regards,

Laurent Pinchart

