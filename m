Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41282 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab1BXN1P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 08:27:15 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Clark, Rob" <rob@ti.com>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Thu, 24 Feb 2011 14:27:10 +0100
Cc: Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	gstreamer-devel@lists.freedesktop.org,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <AANLkTikg0Oj6nq6h_1-d7AQ4NQr2UyMuSemyniYZBLu3@mail.gmail.com> <AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com>
In-Reply-To: <AANLkTik89=g4fR=wC2rkpBero2e-jDVhjmUVNzKKwNjF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-Id: <201102241427.10988.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 22 February 2011 03:44:19 Clark, Rob wrote:
> On Fri, Feb 18, 2011 at 10:39 AM, Robert Fekete wrote:
> > In order to expand this knowledge outside of Linaro I took the Liberty of
> > inviting both linux-media@vger.kernel.org and
> > gstreamer-devel@lists.freedesktop.org. For any newcomer I really
> > recommend to do some catch-up reading on
> > http://lists.linaro.org/pipermail/linaro-dev/2011-February/thread.html
> > ("v4l2 vs omx for camera" thread) before making any comments. And sign up
> > for Linaro-dev while you are at it :-)
> > 
> > To make a long story short:
> > Different vendors provide custom OpenMax solutions for say Camera/ISP. In
> > the Linux eco-system there is V4L2 doing much of this work already and is
> > evolving with mediacontroller as well. Then there is the integration in
> > Gstreamer...Which solution is the best way forward. Current discussions
> > so far puts V4L2 greatly in favor of OMX.
> > Please have in mind that OpenMAX as a concept is more like GStreamer in
> > many senses. The question is whether Camera drivers should have OMX or
> > V4L2 as the driver front end? This may perhaps apply to video codecs as
> > well. Then there is how to in best of ways make use of this in GStreamer
> > in order to achieve no copy highly efficient multimedia pipelines. Is
> > gst-omx the way forward?
> 
> just fwiw, there were some patches to make v4l2src work with userptr
> buffers in case the camera has an mmu and can handle any random
> non-physically-contiguous buffer..  so there is in theory no reason
> why a gst capture pipeline could not be zero copy and capture directly
> into buffers allocated from the display
> 
> Certainly a more general way to allocate buffers that any of the hw
> blocks (display, imaging, video encoders/decoders, 3d/2d hw, etc)
> could use, and possibly share across-process for some zero copy DRI
> style rendering, would be nice.  Perhaps V4L2_MEMORY_GEM?

This is something we first discussed in the end of 2009. We need to get people 
from different subsystems around the same table, with memory management 
specialists (especially for ARM), and lay the ground for a common memory 
management system. Discussions on the V4L2 side called this the global buffers 
pool (see http://lwn.net/Articles/353044/ for instance, more information can 
be found in the linux-media list archives).

[snip]


> > Let the discussion continue...
> > 
> > On 17 February 2011 14:48, Laurent Pinchart wrote:
> >> On Thursday 10 February 2011 08:47:15 Hans Verkuil wrote:
> >> > On Thursday, February 10, 2011 08:17:31 Linus Walleij wrote:
> >> > > On Wed, Feb 9, 2011 at 8:44 PM, Harald Gustafsson wrote:
> >> > > > OMX main purpose is to handle multimedia hardware and offer an
> >> > > > interface to that HW that looks identical indenpendent of the
> >> > > > vendor delivering that hardware, much like the v4l2 or USB
> >> > > > subsystems tries to
> >> > > > do. And yes optimally it should be implemented in drivers/omx in
> >> > > > Linux
> >> > > > and a user space library on top of that.
> >> > > 
> >> > > Thanks for clarifying this part, it was unclear to me. The reason
> >> > > being
> >> > > that it seems OMX does not imply userspace/kernelspace separation,
> >> > > and I was thinking more of it as a userspace lib. Now my
> >> > > understanding is that if e.g. OpenMAX defines a certain data
> >> > > structure, say for a PCM frame or whatever, then that exact struct
> >> > > is supposed to be used by the
> >> > > kernelspace/userspace interface, and defined in the include file
> >> > > exported
> >> > > by the kernel.
> >> > > 
> >> > > > It might be that some alignment also needs to be made between 4vl2
> >> > > > and
> >> > > > other OS's implementation, to ease developing drivers for many OSs
> >> > > > (sorry I don't know these details, but you ST-E guys should know).
> >> > > 
> >> > > The basic conflict I would say is that Linux has its own API+ABI,
> >> > > which
> >> > > is defined by V4L and ALSA through a community process without much
> >> > > thought about any existing standard APIs. (In some cases also
> >> > > predating
> >> > > them.)
> >> > > 
> >> > > > By the way IL is about to finalize version 1.2 of OpenMAX IL which
> >> > > > is more than a years work of aligning all vendors and fixing
> >> > > > unclear and buggy parts.
> >> > > 
> >> > > I suspect that the basic problem with Khronos OpenMAX right now is
> >> > > how to handle communities - for example the X consortium had
> >> > > something like the same problem a while back, only member companies
> >> > > could partake in the standard process, and they need of course to
> >> > > pay an upfront fee for that, and the majority of these companies
> >> > > didn't exactly send Linux community members to the meetings.
> >> > > 
> >> > > And now all the companies who took part in OpenMAX somehow end up
> >> > > having to do a lot of upfront community work if they want to drive
> >> > > the API:s in a certain direction, discuss it again with the V4L and
> >> > > ALSA maintainers and so on. Which takes a lot of time and patience
> >> > > with uncertain outcome, since this process is autonomous from
> >> > > Khronos. Nobody seems to be doing this, I javen't seen a single patch
> >> > > aimed at trying to unify the APIs so far. I don't know if it'd be
> >> > > welcome.

Patches are usually welcome, but one issue with OMX is that it doesn't feel 
like a real Linux API. Linux developers usually don't like to be forced to use 
alien APIs that originate in other worlds (such as Windows) and don't feel 
good on Linux.

> >> > > This coupled with strict delivery deadlines and a marketing will
> >> > > to state conformance to OpenMAX of course leads companies into
> >> > > solutions breaking the Linux kernelspace API to be able to present
> >> > > this.

The end result is that Khronos publishes and API spec that chip vendors 
implement, but nobody in the community is interested in it. OMX is something 
the Linux community mostly ignores. And I don't see this changing any time 
soon, or even ever. OMX was designed without the community. If Khronos really 
want good Linux support, they need to ditch OMX and design something new with 
the community. I don't see this happening anytime soon though, so the 
community will keep working on its APIs and pushing vendors to implement them 
(or even create community-supported implementations). That's a complete waste 
of resources for everybody.

> >> From my experience with OMX, one of the issues is that companies usually
> >> extend the API to fullfill their platform's needs, without going through
> >> any standardization process. Coupled with the lack of open and free
> >> reference implementation and test tools, this more or less means that
> >> OMX implementations are not really compatible with eachother, making
> >> OMX-based solution not better than proprietary solutions.
> >> 
> >> > > Now I think we have a pretty clear view of the problem, I don't
> >> > > know what could be done about it though :-/
> >> > 
> >> > One option might be to create a OMX wrapper library around the V4L2
> >> > API. Something similar is already available for the old V4L1 API (now
> >> > removed from the kernel) that allows apps that still speak V4L1 only
> >> > to use the V4L2 API. This is done in the libv4l1 library. The various
> >> > v4l libraries are maintained here:
> >> > http://git.linuxtv.org/v4l-utils.git
> >> > 
> >> > Adding a libomx might not be such a bad idea. Linaro might be the
> >> > appropriate organization to look into this. Any missing pieces in V4L2
> >> > needed to create a fully functioning omx API can be discussed and
> >> > solved.
> >> > 
> >> > Making this part of v4l-utils means that it is centrally maintained
> >> > and automatically picked up by distros.
> >> > 
> >> > It will certainly be a non-trivial exercise, but it is a one-time job
> >> > that should solve a lot of problems. But someone has to do it...
> >> 
> >> It's an option, but why would that be needed ? Again from my (probably
> >> limited) OMX experience, platforms expose higher-level APIs to
> >> applications, implemented on top of OMX. If the OMX layer is itself
> >> implemented on top of V4L2, it would just be an extraneous useless
> >> internal layer that could (should ?) be removed completely.
> > 
> > This would be the case in a GStreamer driven multimedia, i.e. Implement
> > GStreamer elements using V4L2 directly(or camerabin using v4l2 directly).
> > Perhaps some vendors would provide a library in between as well but that
> > could be libv4l in that case. If someone would have an OpenMAX AL/IL
> > media framework an OMX component would make sense to have but in this
> > case it would be a thinner OMX component which in turn is implemented
> > using V4L2. But it might be that Khronos provides OS independent
> > components that by vendors gets implemented as the actual HW driver
> > forgetting that there is a big difference in the driver model of an RTOS
> > system compared to Linux(user/kernel space) or any OS...never mind.
> 
> Not even different vendor's omx camera implementations are
> compatible.. there seems to be too much various in ISP architecture
> and features for this.
> 
> Another point, and possibly the reason that TI went the OMX camera
> route, was that a userspace API made it possible to move the camera
> driver all to a co-processor (with advantages of reduced interrupt
> latency for SIMCOP processing, and a larger part of the code being OS
> independent)..  doing this in a kernel mode driver would have required
> even more of syslink in the kernel.

That's a very valid point. This is why we need to think about what we want as 
a Linux middleware for multimedia devices. The conclusion might be that 
everything needs to be pushed in the kernel (although I doubt that), but the 
goal is to give a clear message to chip vendors. This is in my opinion one of 
the most urgent tasks.

> But maybe it would be nice to have a way to have sensor driver on the
> linux side, pipelined with hw and imaging drivers on a co-processor
> for various algorithms and filters with configuration all exposed to
> userspace thru MCF.. I'm not immediately sure how this would work, but
> it sounds nice at least ;-)

If the IPC communication layer is in the kernel, that shouldn't be very 
difficult. If it's in userspace, we need help of userspace librairies with 
some kind of userspace driver (in my opinion at least).

> > The question is if the Linux kernel and V4L2 is ready to incorporate
> > several HW(DSP, CPU, ISP, xxHW) in an imaging pipeline for instance. The
> > reason Embedded Vendors provide custom solutions is to implement low
> > power non(or minimal) CPU intervention pipelines where dedicated HW does
> > the work most of the time(like full screen Video Playback).
> > 
> > A common way of managing memory would of course also be necessary as
> > well, like hwmem(search for hwmem in Linux-mm) handles to pass buffers
> > in between different drivers and processes all the way from
> > sources(camera, video parser/decode) to sinks(display, hdmi, video
> > encoders(record))
> 
> (ahh, ok, you have some of the same thoughts as I do regarding sharing
> buffers between various drivers)
> 
> > Perhaps GStreamer experts would like to comment on the future plans ahead
> > for zero copying/IPC and low power HW use cases? Could Gstreamer adapt
> > some ideas from OMX IL making OMX IL obsolete?
> 
> perhaps OMX should adapt some of the ideas from GStreamer ;-)

I'd very much like to see GStreamer (or something else, maybe lower level, but 
community-maintainted) replace OMX.

Does anyone have any GStreamer vs. OMX memory and CPU usage numbers ? I 
suppose it depends on the actual OMX implementations, but what I'd like to 
know is if GStreamer is too heavy for platforms on which OMX works fine.

> OpenMAX is missing some very obvious stuff to make it an API for
> portable applications like autoplugging, discovery of
> capabilities/formats supported, etc..  at least with gst I can drop in
> some hw specific plugins and have apps continue to work without code
> changes.
> 
> Anyways, it would be an easier argument to make if GStreamer was the
> one true framework across different OSs, or at least across linux and
> android.

Let's push for GStreamer on Android then :-)

-- 
Regards,

Laurent Pinchart
