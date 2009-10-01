Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:49569 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627AbZJAQ6e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 12:58:34 -0400
From: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Thu, 1 Oct 2009 11:58:31 -0500
Subject: RE: dqbuf in blocking mode
Message-ID: <A24693684029E5489D1D202277BE89444C9C94C4@dlee02.ent.ti.com>
References: <A24693684029E5489D1D202277BE89444C9C902B@dlee02.ent.ti.com>
 <200910011534.28019.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910011534.28019.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, 

> -----Original Message-----
> From: linux-media-owner@vger.kernel.org 
> [mailto:linux-media-owner@vger.kernel.org] On Behalf Of 
> Laurent Pinchart
> Sent: Thursday, October 01, 2009 8:34 AM
> To: Aguirre Rodriguez, Sergio Alberto
> Cc: Linux Media Mailing List
> Subject: Re: dqbuf in blocking mode
> 
> Hi Sergio,
> 
> On Thursday 01 October 2009 13:56:19 Aguirre Rodriguez, 
> Sergio Alberto wrote:
> > Hi all,
> > 
> > I was wondering how acceptable is to requeue a buffer in a 
> dqbuf call
> > if the videbuf_dqbuf returns error?
> > 
> > See, here's our current omap3 camera dqbuf function code:
> > 
> > static int vidioc_dqbuf(struct file *file, void *fh, struct 
> v4l2_buffer *b)
> > {
> > 	struct omap34xxcam_fh *ofh = fh;
> > 	int rval;
> > 
> > videobuf_dqbuf_again:
> > 	rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
> > 
> > 	/*
> > 	 * This is a hack. We don't want to show -EIO to the user
> > 	 * space. Requeue the buffer and try again if we're not doing
> > 	 * this in non-blocking mode.
> > 	 */
> 
> If I'm not mistaken videobuf_dqbuf() only returns -EIO if the 
> buffer state is 
> VIDEOBUF_ERROR. This is the direct result of either
> 
> - videobuf_queue_cancel() being called, or
> - the device driver marking the buffer as erroneous because 
> of a (possibly 
> transient) device error
> 
> In the first case VIDIOC_DQBUF should in my opinion return 
> with an error. In 
> the second case things are not that clear. A transient error 
> could be hidden 
> from the application, or, if returned to the application 
> through -EIO, 
> shouldn't be treated as a fatal error. Non-transient errors 
> should result in 
> the application stopping video streaming.
> 
> Unfortunately there V4L2 API doesn't offer a way to find out 
> if the error is 
> transient or fatal:
> 
> "EIO		VIDIOC_DQBUF failed due to an internal error. 
> Can also indicate 
> temporary problems like signal loss. Note the driver might 
> dequeue an (empty) 
> buffer despite returning an error, or even stop capturing."
> 
> -EIO can mean many different things that need to be handled 
> differently by 
> applications. I especially hate the "the driver might dequeue 
> an (empty) 
> buffer despite returning an error".
> 
> Drivers should always or never dequeue a buffer when an error 
> occurs, not 
> sometimes. The problem is for the application to recognize 
> the difference 
> between a transient and a fatal error in a backward-compatible way.

I think there are 2 different problems we are talking about here.

Problem #1: Incomplete DQBUF communication from driver to userspace.
            (which is what you're talking about)

Problem #2: Should an internal requeue of a failed buffer be allowed?

About #1, I agree with all your points.

But about #2, I'm not sure what's your stand on it... Most probably you're
thinking that it is acceptable to lock the call _just_ if its a transient error,
therefore depending on solving problem #1 first.

What are your toughts on this?

Regards,
Sergio

> 
> > 	if (rval == -EIO) {
> > 		videobuf_qbuf(&ofh->vbq, b);
> > 		if (!(file->f_flags & O_NONBLOCK))
> > 			goto videobuf_dqbuf_again;
> > 		/*
> > 		 * We don't have a videobuf_buffer now --- maybe next
> > 		 * time...
> > 		 */
> > 		rval = -EAGAIN;
> > 	}
> > 
> > 	return rval;
> > }
> > 
> > Is anything wrong with doing this? Or perhaphs something 
> better to do?
> 
> --
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 