Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2008 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1BZN4W (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Feb 2011 08:56:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <snjw23@gmail.com>
Subject: Re: [RFC] snapshot mode, flash capabilities and control
Date: Sat, 26 Feb 2011 14:56:18 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kim HeungJun <riverful@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Stanimir Varbanov <svarbanov@mm-sol.com>
References: <Pine.LNX.4.64.1102240947230.15756@axis700.grange> <Pine.LNX.4.64.1102261350001.31455@axis700.grange> <4D6902AA.6060805@gmail.com>
In-Reply-To: <4D6902AA.6060805@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102261456.18736.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, February 26, 2011 14:39:54 Sylwester Nawrocki wrote:
> On 02/26/2011 02:03 PM, Guennadi Liakhovetski wrote:
> > On Sat, 26 Feb 2011, Hans Verkuil wrote:
> > 
> >> On Friday, February 25, 2011 18:08:07 Guennadi Liakhovetski wrote:
> >>
> >> <snip>
> >>
> >>>>> configure the sensor to react on an external trigger provided by the flash
> >>>>> controller is needed, and that could be a control on the flash sub-device.
> >>>>> What we would probably miss is a way to issue a STREAMON with a number of
> >>>>> frames to capture. A new ioctl is probably needed there. Maybe that would be
> >>>>> an opportunity to create a new stream-control ioctl that could replace
> >>>>> STREAMON and STREAMOFF in the long term (we could extend the subdev s_stream
> >>>>> operation, and easily map STREAMON and STREAMOFF to the new ioctl in
> >>>>> video_ioctl2 internally).
> >>>>
> >>>> How would this be different from queueing n frames (in total; count
> >>>> dequeueing, too) and issuing streamon? --- Except that when the last frame
> >>>> is processed the pipeline could be stopped already before issuing STREAMOFF.
> >>>> That does indeed have some benefits. Something else?
> >>>
> >>> Well, you usually see in your host driver, that the videobuffer queue is
> >>> empty (no more free buffers are available), so, you stop streaming
> >>> immediately too.
> >>
> >> This probably assumes that the host driver knows that this is a special queue?
> >> Because in general drivers will simply keep capturing in the last buffer and not
> >> release it to userspace until a new buffer is queued.
> > 
> > Yes, I know about this spec requirement, but I also know, that not all
> > drivers do that and not everyone is happy about that requirement:)
> 
> Right, similarly a v4l2 output device is not releasing the last buffer
> to userland and keeps sending its content until a new buffer is queued to the driver.
> But in case of capture device the requirement is a pain, since it only causes
> draining the power source, when from a user view the video capture is stopped.
> Also it limits a minimum number of buffers that could be used in preview pipeline.

No, we can't change this. We can of course add some setting that will explicitly
request different behavior.

The reason this is done this way comes from the traditional TV/webcam viewing apps.
If for some reason the app can't keep up with the capture rate, then frames should
just be dropped silently. All apps assume this behavior. In a normal user environment
this scenario is perfectly normal (e.g. you use a webcam app, then do a CPU
intensive make run).

I agree that you might want different behavior in an embedded environment, but
that should be requested explicitly.

> In still capture mode (single shot) we might want to use only one buffer so adhering
> to the requirement would not allow this, would it?

That's one of the problems with still capture mode, yes.

I have not yet seen a proposal for this that I really like. Most are too specific
to this use-case (snapshot) and I'd like to see something more general.

Regards,

	Hans

> 
> > 
> >> That said, it wouldn't be hard to add some flag somewhere that puts a queue in
> >> a 'stop streaming on last buffer capture' mode.
> > 
> > No, it wouldn't... But TBH this doesn't seem like the most elegant and
> > complete solution. Maybe we have to think a bit more about it - which
> > soncequences switching into the snapshot mode has on the host driver,
> > apart from stopping after N frames. So, this is one of the possibilities,
> > not sure if the best one.
> > 
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
