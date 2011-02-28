Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46735 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab1B1K2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 05:28:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Mon, 28 Feb 2011 11:28:58 +0100
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <4D6902AA.6060805@gmail.com> <201102261456.18736.hverkuil@xs4all.nl>
In-Reply-To: <201102261456.18736.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102281128.58488.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Saturday 26 February 2011 14:56:18 Hans Verkuil wrote:
> On Saturday, February 26, 2011 14:39:54 Sylwester Nawrocki wrote:
> > On 02/26/2011 02:03 PM, Guennadi Liakhovetski wrote:
> > > On Sat, 26 Feb 2011, Hans Verkuil wrote:
> > >> On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
> > >> 
> > >> <snip>
> > >> 
> > >>>>> configure the sensor to react on an external trigger provided by
> > >>>>> the flash controller is needed, and that could be a control on the
> > >>>>> flash sub-device. What we would probably miss is a way to issue a
> > >>>>> STREAMON with a number of frames to capture. A new ioctl is
> > >>>>> probably needed there. Maybe that would be an opportunity to
> > >>>>> create a new stream-control ioctl that could replace STREAMON and
> > >>>>> STREAMOFF in the long term (we could extend the subdev s_stream
> > >>>>> operation, and easily map STREAMON and STREAMOFF to the new ioctl
> > >>>>> in video_ioctl2 internally).
> > >>>> 
> > >>>> How would this be different from queueing n frames (in total; count
> > >>>> dequeueing, too) and issuing streamon? --- Except that when the last
> > >>>> frame is processed the pipeline could be stopped already before
> > >>>> issuing STREAMOFF. That does indeed have some benefits. Something
> > >>>> else?
> > >>> 
> > >>> Well, you usually see in your host driver, that the videobuffer queue
> > >>> is empty (no more free buffers are available), so, you stop
> > >>> streaming immediately too.
> > >> 
> > >> This probably assumes that the host driver knows that this is a
> > >> special queue? Because in general drivers will simply keep capturing
> > >> in the last buffer and not release it to userspace until a new buffer
> > >> is queued.
> > > 
> > > Yes, I know about this spec requirement, but I also know, that not all
> > > drivers do that and not everyone is happy about that requirement:)
> > 
> > Right, similarly a v4l2 output device is not releasing the last buffer
> > to userland and keeps sending its content until a new buffer is queued to
> > the driver. But in case of capture device the requirement is a pain,
> > since it only causes draining the power source, when from a user view
> > the video capture is stopped. Also it limits a minimum number of buffers
> > that could be used in preview pipeline.
> 
> No, we can't change this. We can of course add some setting that will
> explicitly request different behavior.
> 
> The reason this is done this way comes from the traditional TV/webcam
> viewing apps. If for some reason the app can't keep up with the capture
> rate, then frames should just be dropped silently. All apps assume this
> behavior. In a normal user environment this scenario is perfectly normal
> (e.g. you use a webcam app, then do a CPU intensive make run).

Why couldn't drivers drop frames silently without a capture buffer ? If the 
hardware can be paused, the driver could just do that when the last buffer is 
given back to userspace, and resume the hardware when the next buffer is 
queued.

> I agree that you might want different behavior in an embedded environment,
> but that should be requested explicitly.
> 
> > In still capture mode (single shot) we might want to use only one buffer
> > so adhering to the requirement would not allow this, would it?
> 
> That's one of the problems with still capture mode, yes.
> 
> I have not yet seen a proposal for this that I really like. Most are too
> specific to this use-case (snapshot) and I'd like to see something more
> general.

I don't think snapshot capture is *that* special. I don't expect most embedded 
SoCs to implement snapshot capture in hardware. What usually happens is that 
the hardware provides some support (like two independent video streams for 
instance, or the ability to capture a given number of frames) and the 
scheduling is performed in userspace. Good quality snapshot capture requires 
complex algorithms and involves several hardware pieces (ISP, flash 
controller, lens controller, ...), so it can't be implemented in the kernel.

-- 
Regards,

Laurent Pinchart
