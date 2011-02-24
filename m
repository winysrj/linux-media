Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41305 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab1BXNag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 08:30:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Thu, 24 Feb 2011 14:30:34 +0100
Cc: "Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	gstreamer-devel@lists.freedesktop.org,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com> <201102241417.12586.hverkuil@xs4all.nl>
In-Reply-To: <201102241417.12586.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241430.34826.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday 24 February 2011 14:17:12 Hans Verkuil wrote:
> On Tuesday, February 22, 2011 03:44:19 Clark, Rob wrote:
> > On Fri, Feb 18, 2011 at 10:39 AM, Robert Fekete wrote:
> > > Hi,
> > > 
> > > In order to expand this knowledge outside of Linaro I took the Liberty
> > > of inviting both linux-media@vger.kernel.org and
> > > gstreamer-devel@lists.freedesktop.org. For any newcomer I really
> > > recommend to do some catch-up reading on
> > > http://lists.linaro.org/pipermail/linaro-dev/2011-February/thread.html
> > > ("v4l2 vs omx for camera" thread) before making any comments. And sign
> > > up for Linaro-dev while you are at it :-)
> > > 
> > > To make a long story short:
> > > Different vendors provide custom OpenMax solutions for say Camera/ISP.
> > > In the Linux eco-system there is V4L2 doing much of this work already
> > > and is evolving with mediacontroller as well. Then there is the
> > > integration in Gstreamer...Which solution is the best way forward.
> > > Current discussions so far puts V4L2 greatly in favor of OMX.
> > > Please have in mind that OpenMAX as a concept is more like GStreamer in
> > > many senses. The question is whether Camera drivers should have OMX or
> > > V4L2 as the driver front end? This may perhaps apply to video codecs
> > > as well. Then there is how to in best of ways make use of this in
> > > GStreamer in order to achieve no copy highly efficient multimedia
> > > pipelines. Is gst-omx the way forward?
> > 
> > just fwiw, there were some patches to make v4l2src work with userptr
> > buffers in case the camera has an mmu and can handle any random
> > non-physically-contiguous buffer..  so there is in theory no reason
> > why a gst capture pipeline could not be zero copy and capture directly
> > into buffers allocated from the display
> 
> V4L2 also allows userspace to pass pointers to contiguous physical memory.
> On TI systems this memory is usually obtained via the out-of-tree cmem
> module.

On the OMAP3 the ISP doesn't require physically contiguous memory. User 
pointers can be used quite freely, except that they introduce cache management 
issues on ARM when speculative prefetching comes into play (those issues are 
currently ignored completely).

> > Certainly a more general way to allocate buffers that any of the hw
> > blocks (display, imaging, video encoders/decoders, 3d/2d hw, etc)
> > could use, and possibly share across-process for some zero copy DRI
> > style rendering, would be nice.  Perhaps V4L2_MEMORY_GEM?
> 
> There are two parts to this: first of all you need a way to allocate large
> buffers. The CMA patch series is available (but not yet merged) that does
> this. I'm not sure of the latest status of this series.

Some platforms don't require contiguous memory. What we need is a way to 
allocate memory in the kernel with various options, and use that memory in 
various drivers (V4L2, GPU, ...)

> The other part is that everyone can use and share these buffers. There
> isn't anything for this yet. We have discussed this in the past and we
> need something generic for this that all subsystems can use. It's not a
> good idea to tie this to any specific framework like GEM. Instead any
> subsystem should be able to use the same subsystem-independent buffer pool
> API.
> 
> The actual code is probably not too bad, but trying to coordinate this over
> all subsystems is not an easy task.

[snip]

> > Not even different vendor's omx camera implementations are
> > compatible.. there seems to be too much various in ISP architecture
> > and features for this.
> > 
> > Another point, and possibly the reason that TI went the OMX camera
> > route, was that a userspace API made it possible to move the camera
> > driver all to a co-processor (with advantages of reduced interrupt
> > latency for SIMCOP processing, and a larger part of the code being OS
> > independent)..  doing this in a kernel mode driver would have required
> > even more of syslink in the kernel.
> > 
> > But maybe it would be nice to have a way to have sensor driver on the
> > linux side, pipelined with hw and imaging drivers on a co-processor
> > for various algorithms and filters with configuration all exposed to
> > userspace thru MCF.. I'm not immediately sure how this would work, but
> > it sounds nice at least ;-)
> 
> MCF? What does that stand for?

Media Controller Framework I guess.

> > > The question is if the Linux kernel and V4L2 is ready to incorporate
> > > several HW(DSP, CPU, ISP, xxHW) in an imaging pipeline for instance.
> > > The reason Embedded Vendors provide custom solutions is to implement
> > > low power non(or minimal) CPU intervention pipelines where dedicated
> > > HW does the work most of the time(like full screen Video Playback).
> > > 
> > > A common way of managing memory would of course also be necessary as
> > > well, like hwmem(search for hwmem in Linux-mm) handles to pass buffers
> > > in between different drivers and processes all the way from
> > > sources(camera, video parser/decode) to sinks(display, hdmi, video
> > > encoders(record))
> > 
> > (ahh, ok, you have some of the same thoughts as I do regarding sharing
> > buffers between various drivers)
> 
> Perhaps the time is right for someone to start working on this?

Totally. It's time to start working on lots of things :-)

-- 
Regards,

Laurent Pinchart
