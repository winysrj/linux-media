Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58549 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1CHPwA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 10:52:00 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: Yet another memory provider: can linaro organize a meeting?
Date: Tue, 8 Mar 2011 16:52:20 +0100
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
References: <201103080913.59231.hverkuil@xs4all.nl> <1299592870.2083.67.camel@morgan.silverblock.net>
In-Reply-To: <1299592870.2083.67.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103081652.20561.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Tuesday 08 March 2011 15:01:10 Andy Walls wrote:
> On Tue, 2011-03-08 at 09:13 +0100, Hans Verkuil wrote:
> > Hi all,
> > 
> > We had a discussion yesterday regarding ways in which linaro can assist
> > V4L2 development. One topic was that of sorting out memory providers like
> > GEM and HWMEM.
> > 
> > Today I learned of yet another one: UMP from ARM.
> > 
> > http://blogs.arm.com/multimedia/249-making-the-mali-gpu-device-driver-ope
> > n-source/page__cid__133__show__newcomment/
> > 
> > This is getting out of hand. I think that organizing a meeting to solve
> > this mess should be on the top of the list. Companies keep on solving
> > the same problem time and again and since none of it enters the mainline
> > kernel any driver using it is also impossible to upstream.
> > 
> > All these memory-related modules have the same purpose: make it possible
> > to allocate/reserve large amounts of memory and share it between
> > different subsystems (primarily framebuffer, GPU and V4L).

[snip]

> > It really shouldn't be that hard to get everyone involved together and
> > settle on a single solution (either based on an existing proposal or
> > create a 'the best of' vendor-neutral solution).
> 
> "Single" might be making the problem impossibly hard to solve well.
> One-size-fits-all solutions have a tendency to fall short on meeting
> someone's critical requirement.  I will agree that "less than n", for
> some small n, is certainly desirable.
> 
> The memory allocators and managers are ideally satisfying the
> requirements imposed by device hardware, what userspace applications are
> expected to do with the buffers, and system performance.  (And maybe the
> platform architecture, I/O bus, and dedicated video memory?)

In the embedded world, a very common use case is to capture video data from an 
ISP (V4L2+MC), process it in a DSP (V4L2+M2M, tidspbridge, ...) and display it 
on the GPU (OpenGL/ES). We need to be able to share a data buffer between the 
ISP and the DSP, and another buffer between the DSP and the GPU. If processing 
is not required, sharing a data buffer between the ISP and the GPU is 
required. Achieving zero-copy requires a single memory management solution 
used by the ISP, the DSP and the GPU.

-- 
Regards,

Laurent Pinchart
