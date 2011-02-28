Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38092 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab1B1KYc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:24:32 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Mon, 28 Feb 2011 11:24:40 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <201102261331.26681.hverkuil@xs4all.nl> <Pine.LNX.4.64.1102261350001.31455@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1102261350001.31455@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281124.41134.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday 26 February 2011 14:03:53 Guennadi Liakhovetski wrote:
> On Sat, 26 Feb 2011, Hans Verkuil wrote:
> > On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
> > 
> > <snip>
> > 
> > > > > configure the sensor to react on an external trigger provided by
> > > > > the flash controller is needed, and that could be a control on the
> > > > > flash sub-device. What we would probably miss is a way to issue a
> > > > > STREAMON with a number of frames to capture. A new ioctl is
> > > > > probably needed there. Maybe that would be an opportunity to
> > > > > create a new stream-control ioctl that could replace STREAMON and
> > > > > STREAMOFF in the long term (we could extend the subdev s_stream
> > > > > operation, and easily map STREAMON and STREAMOFF to the new ioctl
> > > > > in video_ioctl2 internally).
> > > > 
> > > > How would this be different from queueing n frames (in total; count
> > > > dequeueing, too) and issuing streamon? --- Except that when the last
> > > > frame is processed the pipeline could be stopped already before
> > > > issuing STREAMOFF. That does indeed have some benefits. Something
> > > > else?
> > > 
> > > Well, you usually see in your host driver, that the videobuffer queue
> > > is empty (no more free buffers are available), so, you stop streaming
> > > immediately too.
> > 
> > This probably assumes that the host driver knows that this is a special
> > queue? Because in general drivers will simply keep capturing in the last
> > buffer and not release it to userspace until a new buffer is queued.
> 
> Yes, I know about this spec requirement, but I also know, that not all
> drivers do that and not everyone is happy about that requirement:)

Is it a requirement, or just something some drivers do ? Several drivers just 
stop capturing when no buffer is available, and resume when a new buffer is 
queued.

> > That said, it wouldn't be hard to add some flag somewhere that puts a
> > queue in a 'stop streaming on last buffer capture' mode.
> 
> No, it wouldn't... But TBH this doesn't seem like the most elegant and
> complete solution. Maybe we have to think a bit more about it - which
> soncequences switching into the snapshot mode has on the host driver,
> apart from stopping after N frames. So, this is one of the possibilities,
> not sure if the best one.

-- 
Regards,

Laurent Pinchart
