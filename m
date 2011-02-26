Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2357 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab1BZMbf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 07:31:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Sat, 26 Feb 2011 13:31:26 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <20110225135314.GF23853@valkosipuli.localdomain> <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102251708080.26361@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261331.26681.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:

<snip>

> > > configure the sensor to react on an external trigger provided by the flash 
> > > controller is needed, and that could be a control on the flash sub-device. 
> > > What we would probably miss is a way to issue a STREAMON with a number of 
> > > frames to capture. A new ioctl is probably needed there. Maybe that would be 
> > > an opportunity to create a new stream-control ioctl that could replace 
> > > STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream 
> > > operation, and easily map STREAMON and STREAMOFF to the new ioctl in 
> > > video_ioctl2 internally).
> > 
> > How would this be different from queueing n frames (in total; count
> > dequeueing, too) and issuing streamon? --- Except that when the last frame
> > is processed the pipeline could be stopped already before issuing STREAMOFF.
> > That does indeed have some benefits. Something else?
> 
> Well, you usually see in your host driver, that the videobuffer queue is 
> empty (no more free buffers are available), so, you stop streaming 
> immediately too.

This probably assumes that the host driver knows that this is a special queue?
Because in general drivers will simply keep capturing in the last buffer and not
release it to userspace until a new buffer is queued.

That said, it wouldn't be hard to add some flag somewhere that puts a queue in
a 'stop streaming on last buffer capture' mode.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
