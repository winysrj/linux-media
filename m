Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:36566 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080Ab1CHTMG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 14:12:06 -0500
Subject: Re: Yet another memory provider: can linaro organize a meeting?
From: Andy Walls <awalls@md.metrocast.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linaro-dev@lists.linaro.org,
	linux-media@vger.kernel.org, Jonghun Han <jonghun.han@samsung.com>
In-Reply-To: <201103081652.20561.laurent.pinchart@ideasonboard.com>
References: <201103080913.59231.hverkuil@xs4all.nl>
	 <1299592870.2083.67.camel@morgan.silverblock.net>
	 <201103081652.20561.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Mar 2011 14:12:45 -0500
Message-ID: <1299611565.24699.12.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi LAurent,

On Tue, 2011-03-08 at 16:52 +0100, Laurent Pinchart wrote:
> Hi Andy,

[snip]

> > > It really shouldn't be that hard to get everyone involved together and
> > > settle on a single solution (either based on an existing proposal or
> > > create a 'the best of' vendor-neutral solution).
> > 
> > "Single" might be making the problem impossibly hard to solve well.
> > One-size-fits-all solutions have a tendency to fall short on meeting
> > someone's critical requirement.  I will agree that "less than n", for
> > some small n, is certainly desirable.
> > 
> > The memory allocators and managers are ideally satisfying the
> > requirements imposed by device hardware, what userspace applications are
> > expected to do with the buffers, and system performance.  (And maybe the
> > platform architecture, I/O bus, and dedicated video memory?)
> 
> In the embedded world, a very common use case is to capture video data from an 
> ISP (V4L2+MC), process it in a DSP (V4L2+M2M, tidspbridge, ...) and display it 
> on the GPU (OpenGL/ES). We need to be able to share a data buffer between the 
> ISP and the DSP, and another buffer between the DSP and the GPU. If processing 
> is not required, sharing a data buffer between the ISP and the GPU is 
> required. Achieving zero-copy requires a single memory management solution 
> used by the ISP, the DSP and the GPU.

Ah.  I guess I misunderstood what was meant by "memory provider" to some
extent.  

So what I read is a common way of providing in kernel persistent buffers
(buffer objects? buffer entities?) for drivers and userspace
applications to pass around by reference (no copies).  Userspace may or
may not want to see the contents of the buffer objects.

So I understand now why a single solution is desirable.

Regards,
Andy

