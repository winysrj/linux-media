Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:50633 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab1LFWlj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 17:41:39 -0500
Date: Wed, 7 Dec 2011 00:41:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	'Sebastian =?iso-8859-1?Q?Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Message-ID: <20111206224134.GE938@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
 <20111206143538.GD938@valkosipuli.localdomain>
 <4EDE40D0.9080704@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EDE40D0.9080704@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 06, 2011 at 02:20:32PM -0200, Mauro Carvalho Chehab wrote:
> >>>>>1) After all the frames with the old resolution are dequeued a buffer with the
> >>>>>following flags V4L2_BUF_FLAG_ERROR | V4L2_BUF_FLAG_WRONGFORMAT is returned.
> >>>>>2) To acknowledge the resolution change the application should STREAMOFF, check
> >>>>>what has changed and then STREAMON.
> >>>>
> >>>>I don't think this is needed, if the buffer size is enough to support the new
> >>>>format.
> >>>
> >>>Sometimes not, but sometimes there are buffer line alignment requirements
> >>>which must be communicated to the driver using S_FMT. If the frames are
> >>>decoded using a driver-decided format, it might be impossible to actually
> >>>use these decoded frames.
> >>>
> >>>That's why there's streamoff and streamon.
> >>
> >>Don't get me wrong. What I'm saying is that there are valid cases where
> >>there's no need to streamoff/streamon. What I'm saying is that, when
> >>there's no need to do it, just don't rise the V4L2_BUF_FLAG_ERROR flag.
> >>The V4L2_BUF_FLAG_FORMATCHANGED still makes sense.
> >
> >I try not to. :)
> >
> >The issue is that it's the user space which knows how it is going to use the
> >buffers it dequeues from a device. It's not possible for the driver know
> >that --- unless explicitly told by the user. This could be a new flag, if we
> >need differing behaviour as it seems here.
> >
> >The user may queue the same memory buffers to another device, which I
> >consider to be a common use case in embedded systems. The line alignment
> >requirements of the two (or more) devices often are not the same.
> 
> So what?
> 
> You're probably not referring to queuing the same buffer at the same time
> to two separate devices. If they're being queued at different times, I can't
> see any issue.

The buffers are used in separate devices at different times. If the decoder
has a line alignment requirement of 32, but the display output device has
128, chances are good that the new bytesperline won't be suitable to be
displayed.

> >>>>Btw, a few drivers (bttv comes into my mind) properly handles format changes.
> >>>>This were there in order to support a bad behavior found on a few V4L1 applications,
> >>>>where the applications were first calling STREAMON and then setting the buffer.
> >>>
> >>>The buffers do not have a format, the video device queue has. If the format
> >>>changes during streaming it is impossible to find that out using the current
> >>>API.
> >>
> >>Yes, but extending it to proper support it is the scope of this RFC. Yet, several
> >>drivers allow to resize the "format" (e. g. the resolution of the image) without
> >>streamon/streamoff, via an explicit call to S_FMT.
> >>
> >>So, whatever change at the API is done, it should keep supporting format changes
> >>(in practice, resolution changes) without the need of re-initializing the DMA engine,
> >>of course when such change won't break the capability for userspace to decode
> >>the new frames.
> >
> >Stopping and starting the queue does not involve additional penalty: a
> >memory-to-memory device processes buffers one at a time, and most of the
> >hardware stops between the buffers in any case before being started by the
> >software again. The buffers are not affected either; they stay mapped and
> >pinned to memory.
> 
> This is true only on memory-to-memory devices (although the V4L2 spec is incomplete
> with regards to this specific type of device).

That's true. Would this be a candidate for a new V4L2 profile?

> >>>>If I'm not mistaken, the old vlc V4L1 driver used to do that.
> >>>>
> >>>>What bttv used to do is to allocate a buffer big enough to support the max resolution.
> >>>>So, any format changes (size increase or decrease) would fit into the allocated
> >>>>buffers.
> >>>>
> >>>>Depending on how applications want to handle format changes, and how big is the
> >>>>amount of memory on the system, a similar approach may be done with CREATE_BUFFERS:
> >>>>just allocate enough space for the maximum supported resolution for that stream,
> >>>>and let the resolution changes, as required.
> >>>
> >>>I'm not fully certain it is always possible to find out the largest stream
> >>>resolution. I'd like an answer from someone knowing more about video codecs
> >>>than I do.
> >>
> >>When the input or output is some hardware device, there is a maximum resolution
> >>(sensor resolution, monitor resolution, pixel sampling rate, etc). A pure DSP block
> >>doesn't have it, but, anyway, it should be up to the userspace application to decide
> >>if it wants to over-allocate a buffer, in order to cover a scenario where the
> >>resolution may change or not.
> >
> >In this case, allocating bigger buffers than necessary is a big
> >disadvantage, and forcing the application to requeue the compressed data
> >to the OUTPUT queue doesn't sound very appealing either. This could involve
> >the application having to queue several buffers which already have been
> >decoded earlier on. Also figuring out how many is a task for the decoder,
> >not the application.
> 
> Sorry, but it seems I missed what scenario you're considering... M2M, Output, Capture? All?
> some specific pipeline?

In this caase it's memory-to-memory device.

...

> >>>>>3) The application should check with G_FMT how did the format change and the
> >>>>>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE control to check how many buffers are
> >>>>>required.
> >>>>>4) Now it is necessary to resume processing:
> >>>>>   A. If there is no need to change the size of buffers or their number the
> >>>>>application needs only to STREAMON.
> >>>>>   B. If it is necessary to allocate bigger buffers the application should use
> >>>>>CREATE_BUFS to allocate new buffers, the old should be left until the
> >>>>>application is finished and frees them with the DESTROY_BUFS call. S_FMT
> >>>>>should be used to adjust the new format (if necessary and possible in HW).
> >>>>
> >>>>If the application already cleaned the DMA transfers with STREAMOFF, it can
> >>>>also just re-queue the buffers with REQBUFS, e. g. vb2 should be smart enough to
> >>>>accept both ways to allocate buffers.
> >>>
> >>>No need to REQBUFS after streaming has been stopped. STREAMOFF won't harm
> >>>the buffers in any way anymore --- as it did in videobuf1.
> >>
> >>OK, but userspace applications may use REQBUFS instead of CREATE_BUFFERS, as REQBUFS
> >>is part of the API.
> >
> >True. But new REQBUFS, as far as I remember, re-allocates the buffers,
> >causing a glitch to the stream. That's why CREATE_BUFS was proposed.
> 
> True, but also STREAMOFF will glitch the stream, in the general case (capture or output
> devices).

Right. For those buffers to be affected, they'd have to be mmap buffers.

The buffers are displayed elsewhere using different APIs. With CREATE_BUFS
it's possible to keep the old buffers around as long as they are needed.

> >>>That's a good point. It's more related to changes in stream properties ---
> >>>the frame rate of the stream could change, too. That might be when you could
> >>>like to have more buffers in the queue. I don't think this is critical
> >>>either.
> >>>
> >>>This could also depend on the properties of the codec. Again, I'd wish a
> >>>comment from someone who knows codecs well. Some codecs need to be able to
> >>>access buffers which have already been decoded to decode more buffers. Key
> >>>frames, simply.
> >>
> >>Ok, but let's not add unneeded things at the API if you're not sure. If we have
> >>such need for a given hardware, then add it. Otherwise, keep it simple.
> >
> >This is not so much dependent on hardware but on the standards which the
> >cdoecs implement.
> 
> Could you please elaborate it? On what scenario this is needed?

This is a property of the stream, not a property of the decoder. To
reconstruct each frame, a part of the stream is required and already decoded
frames may be used to accelerate the decoding. What those parts are. depends
on the codec, not a particular implementation.

Anyone with more knowledge of codecs than myself might be able to give a
concrete example. Sebastian?

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
