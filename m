Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:57575 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753677AbeDZJ2q (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Apr 2018 05:28:46 -0400
Date: Thu, 26 Apr 2018 11:28:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v7 1/2] uvcvideo: send a control event when a Control
 Change interrupt arrives
In-Reply-To: <alpine.DEB.2.20.1804100848040.29394@axis700.grange>
Message-ID: <alpine.DEB.2.20.1804261124480.13154@axis700.grange>
References: <20180323092401.12162-1-laurent.pinchart@ideasonboard.com> <20180323092401.12162-2-laurent.pinchart@ideasonboard.com> <2079648.niC1Apbgeu@avalon> <alpine.DEB.2.20.1804100848040.29394@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Tue, 10 Apr 2018, Guennadi Liakhovetski wrote:

[snip]

> > > @@ -1488,6 +1591,25 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
> > >  		return -EINVAL;
> > >  	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR))
> > >  		return -EACCES;
> > > +	if (ctrl->info.flags & UVC_CTRL_FLAG_ASYNCHRONOUS) {
> > > +		if (ctrl->handle)
> > > +			/*
> > > +			 * We have already sent this control to the camera
> > > +			 * recently and are currently waiting for a completion
> > > +			 * notification. The camera might already have completed
> > > +			 * its processing and is ready to accept a new control
> > > +			 * or it's still busy processing. If we send a new
> > > +			 * instance of this control now, in the former case the
> > > +			 * camera will process this one too and we'll get
> > > +			 * completions for both, but we will only deliver an
> > > +			 * event for one of them back to the user. In the latter
> > > +			 * case the camera will reply with a STALL. It's easier
> > > +			 * and more reliable to return an error now and let the
> > > +			 * user retry.
> > > +			 */
> > > +			return -EBUSY;
> > > +		ctrl->handle = handle;
> > 
> > This part worries me. If the control change event isn't received for any 
> > reason (such as a buggy device for instance, or uvc_ctrl_status_event() being 
> > called with the previous event not processed yet), the control will stay busy 
> > forever.
> > 
> > I see two approaches to fix this. One would be to forward all received control 
> > change events to all file handles unconditionally and remove the handle field 
> > from the uvc_control structure.
> 
> How is this a solution? A case of senging a repeated control to the camera 
> and causing a STALL would still be possible. If you prefer STALLs, you 
> could just remove this check here.
> 
> > Another one would be to add a timeout, storing 
> > the time at which the control has been set in the uvc_control structure, and 
> > checking whether the time difference exceeds a fixed timeout here. We could 
> > also combine the two, replacing the handle field with a timestamp field.
> 
> Don't think you can remove the handle field, there are a couple of things, 
> that need it, also you'll have to send events to all listeners, including 
> the thread, that has sent the control, which contradicts the API? Assuming 
> it hasn't set the V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK flag.
> 
> I can add a timeout, even though that doesn't seem to be very clean to me. 
> According to the UVC standard some controls can take a while to complete, 
> possibly seconds. How long would you propose that timeout to be?

How about just not checking when setting control and letting the camera 
decide? That's what the STALL mechanism is there for. The only advantage 
of using this is to provide a short-cut when we're "sure," that the 
hardware isn't ready to take a new request yet, but if implementing such a 
shortcut becomes too cumbersome, we can give control back to the hardware.

Thanks
Guennadi
