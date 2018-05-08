Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:42543 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbeEHLFV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 8 May 2018 07:05:21 -0400
Date: Tue, 8 May 2018 13:05:17 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/2] uvcvideo: send a control event when a Control
 Change interrupt arrives
In-Reply-To: <3321819.nzIFIPUmca@avalon>
Message-ID: <alpine.DEB.2.20.1805081253280.9684@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <2079648.niC1Apbgeu@avalon> <alpine.DEB.2.20.1804100848040.29394@axis700.grange> <3321819.nzIFIPUmca@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

One more comment-to-comment:

On Mon, 7 May 2018, Laurent Pinchart wrote:

> Hi Guennadi,
> 
> On Tuesday, 10 April 2018 14:31:35 EEST Guennadi Liakhovetski wrote:
> > On Fri, 23 Mar 2018, Laurent Pinchart wrote:
> > > On Friday, 23 March 2018 11:24:00 EET Laurent Pinchart wrote:
> > >> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > >> 
> > >> UVC defines a method of handling asynchronous controls, which sends a
> > >> USB packet over the interrupt pipe. This patch implements support for
> > >> such packets by sending a control event to the user. Since this can
> > >> involve USB traffic and, therefore, scheduling, this has to be done
> > >> in a work queue.
> > >> 
> > >> Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>
> > >> ---
> > >> 
> > >>  drivers/media/usb/uvc/uvc_ctrl.c   | 166 +++++++++++++++++++++++++++---
> > >>  drivers/media/usb/uvc/uvc_status.c | 111 ++++++++++++++++++++++---
> > >>  drivers/media/usb/uvc/uvc_v4l2.c   |   4 +-
> > >>  drivers/media/usb/uvc/uvcvideo.h   |  15 +++-
> > >>  include/uapi/linux/uvcvideo.h      |   2 +
> > >>  5 files changed, 269 insertions(+), 29 deletions(-)

[snip]

> > >> diff --git a/drivers/media/usb/uvc/uvc_status.c
> > >> b/drivers/media/usb/uvc/uvc_status.c index 7b710410584a..d1d83aed6a1d
> > >> 100644
> > >> --- a/drivers/media/usb/uvc/uvc_status.c
> > >> +++ b/drivers/media/usb/uvc/uvc_status.c

[snip]

> > >> +				ctrl = uvc_event_entity_ctrl(entity,
> > >> +							     status->bSelector);
> > >> +				/*
> > >> +				 * Some buggy cameras send asynchronous Control
> > >> +				 * Change events for control, other than the
> > >> +				 * ones, that had been changed, even though the
> > >> +				 * AutoUpdate flag isn't set for the control.
> > >> +				 */
> > > 
> > > That's lots of commas, I'm not sure what you mean here. Are there cameras
> > > that send event for controls that haven't changed ? Or cameras that send
> > > events for controls that don't have the auto-update flag set ? Do you
> > > know what cameras are affected ?
> > 
> > I meant a case like
> > 
> > set_control(x=X)
> > interrupt(x=X)
> > interrupt(y=Y)
> > 
> > where y is a different control and it doesn't have an auto-update flag
> > set. I think those were some early versions of our cameras, but as far as
> > I can see, we need the check anyway for autoupdate controls, so, I can
> > just remove the comment.
> 
> OK. But now that I read the comment again, how is it related to the check ? 
> Why do you need ctrl->handle->chain == *chain ? Isn't that only a partial 
> guard for the case above, as both x and y could be part of the same chain ?

The uvc_event_entity_ctrl() function checks the selector, so, a selector + 
chain should be unique?

Thanks
Guennadi
