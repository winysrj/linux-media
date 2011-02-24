Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49886 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab1BXOvv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 09:51:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [st-ericsson] v4l2 vs omx for camera
Date: Thu, 24 Feb 2011 15:51:47 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, "Clark, Rob" <rob@ti.com>,
	Robert Fekete <robert.fekete@linaro.org>,
	"linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
	Harald Gustafsson <harald.gustafsson@ericsson.com>,
	gstreamer-devel@lists.freedesktop.org,
	"ST-Ericsson LT Mailing List" <st-ericsson@lists.linaro.org>,
	linux-media@vger.kernel.org
References: <AANLkTik=Yc9cb9r7Ro=evRoxd61KVE=8m7Z5+dNwDzVd@mail.gmail.com> <201102241417.12586.hverkuil@xs4all.nl> <AANLkTikG7EGcNV=h1vs-LKMT0Vw6_4jwvSeYtAW4Hy6f@mail.gmail.com>
In-Reply-To: <AANLkTikG7EGcNV=h1vs-LKMT0Vw6_4jwvSeYtAW4Hy6f@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201102241551.47535.laurent.pinchart@ideasonboard.com>
Content-Type: Text/Plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thursday 24 February 2011 15:48:20 Kyungmin Park wrote:
> On Thu, Feb 24, 2011 at 10:17 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Tuesday, February 22, 2011 03:44:19 Clark, Rob wrote:
> >> On Fri, Feb 18, 2011 at 10:39 AM, Robert Fekete wrote:
> >> > Hi,
> >> > 
> >> > In order to expand this knowledge outside of Linaro I took the Liberty
> >> > of inviting both linux-media@vger.kernel.org and
> >> > gstreamer-devel@lists.freedesktop.org. For any newcomer I really
> >> > recommend to do some catch-up reading on
> >> > http://lists.linaro.org/pipermail/linaro-dev/2011-February/thread.html
> >> > ("v4l2 vs omx for camera" thread) before making any comments. And sign
> >> > up for Linaro-dev while you are at it :-)
> >> > 
> >> > To make a long story short:
> >> > Different vendors provide custom OpenMax solutions for say Camera/ISP.
> >> > In the Linux eco-system there is V4L2 doing much of this work already
> >> > and is evolving with mediacontroller as well. Then there is the
> >> > integration in Gstreamer...Which solution is the best way forward.
> >> > Current discussions so far puts V4L2 greatly in favor of OMX.
> >> > Please have in mind that OpenMAX as a concept is more like GStreamer
> >> > in many senses. The question is whether Camera drivers should have
> >> > OMX or V4L2 as the driver front end? This may perhaps apply to video
> >> > codecs as well. Then there is how to in best of ways make use of this
> >> > in GStreamer in order to achieve no copy highly efficient multimedia
> >> > pipelines. Is gst-omx the way forward?
> >> 
> >> just fwiw, there were some patches to make v4l2src work with userptr
> >> buffers in case the camera has an mmu and can handle any random
> >> non-physically-contiguous buffer..  so there is in theory no reason
> >> why a gst capture pipeline could not be zero copy and capture directly
> >> into buffers allocated from the display
> > 
> > V4L2 also allows userspace to pass pointers to contiguous physical
> > memory. On TI systems this memory is usually obtained via the
> > out-of-tree cmem module.
> > 
> >> Certainly a more general way to allocate buffers that any of the hw
> >> blocks (display, imaging, video encoders/decoders, 3d/2d hw, etc)
> >> could use, and possibly share across-process for some zero copy DRI
> >> style rendering, would be nice.  Perhaps V4L2_MEMORY_GEM?
> > 
> > There are two parts to this: first of all you need a way to allocate
> > large buffers. The CMA patch series is available (but not yet merged)
> > that does this. I'm not sure of the latest status of this series.
> 
> Still ARM maintainer doesn't agree these patches since it's not solve
> the ARM memory different attribute mapping problem.
> but try to send the CMA v9 patch soon.
> 
> We need really require the physical memory management module. Each
> chip vendors use the their own implementations.
> Our approach called it as CMA, others called it as cmem, carveout,
> hwmon and so on.
> 
> I think Laurent's approaches is similar one.

Just for the record, my global buffers pool RFC didn't try to solve the 
contiguous memory allocation problem. It aimed at providing drivers (and 
applications) with an API to allocate and use buffers. How the memory is 
allocated is outside the scope of the global buffers pool, CMA makes perfect 
sense for that.

> We will try it again to merge CMA.

-- 
Regards,

Laurent Pinchart
