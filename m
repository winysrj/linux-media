Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:45443 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbZJANcf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Oct 2009 09:32:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>
Subject: Re: dqbuf in blocking mode
Date: Thu, 1 Oct 2009 15:34:27 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <A24693684029E5489D1D202277BE89444C9C902B@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE89444C9C902B@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910011534.28019.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergio,

On Thursday 01 October 2009 13:56:19 Aguirre Rodriguez, Sergio Alberto wrote:
> Hi all,
> 
> I was wondering how acceptable is to requeue a buffer in a dqbuf call
> if the videbuf_dqbuf returns error?
> 
> See, here's our current omap3 camera dqbuf function code:
> 
> static int vidioc_dqbuf(struct file *file, void *fh, struct v4l2_buffer *b)
> {
> 	struct omap34xxcam_fh *ofh = fh;
> 	int rval;
> 
> videobuf_dqbuf_again:
> 	rval = videobuf_dqbuf(&ofh->vbq, b, file->f_flags & O_NONBLOCK);
> 
> 	/*
> 	 * This is a hack. We don't want to show -EIO to the user
> 	 * space. Requeue the buffer and try again if we're not doing
> 	 * this in non-blocking mode.
> 	 */

If I'm not mistaken videobuf_dqbuf() only returns -EIO if the buffer state is 
VIDEOBUF_ERROR. This is the direct result of either

- videobuf_queue_cancel() being called, or
- the device driver marking the buffer as erroneous because of a (possibly 
transient) device error

In the first case VIDIOC_DQBUF should in my opinion return with an error. In 
the second case things are not that clear. A transient error could be hidden 
from the application, or, if returned to the application through -EIO, 
shouldn't be treated as a fatal error. Non-transient errors should result in 
the application stopping video streaming.

Unfortunately there V4L2 API doesn't offer a way to find out if the error is 
transient or fatal:

"EIO		VIDIOC_DQBUF failed due to an internal error. Can also indicate 
temporary problems like signal loss. Note the driver might dequeue an (empty) 
buffer despite returning an error, or even stop capturing."

-EIO can mean many different things that need to be handled differently by 
applications. I especially hate the "the driver might dequeue an (empty) 
buffer despite returning an error".

Drivers should always or never dequeue a buffer when an error occurs, not 
sometimes. The problem is for the application to recognize the difference 
between a transient and a fatal error in a backward-compatible way.

> 	if (rval == -EIO) {
> 		videobuf_qbuf(&ofh->vbq, b);
> 		if (!(file->f_flags & O_NONBLOCK))
> 			goto videobuf_dqbuf_again;
> 		/*
> 		 * We don't have a videobuf_buffer now --- maybe next
> 		 * time...
> 		 */
> 		rval = -EAGAIN;
> 	}
> 
> 	return rval;
> }
> 
> Is anything wrong with doing this? Or perhaphs something better to do?

--
Regards,

Laurent Pinchart
