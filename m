Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47219 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab2EVQVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 12:21:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [Q] vb2 userptr: struct vb2_ops::buf_cleanup() is called without buf_init()
Date: Tue, 22 May 2012 18:21:32 +0200
Message-ID: <1400345.yHxUgq6vV0@avalon>
In-Reply-To: <Pine.LNX.4.64.1205210902060.30522@axis700.grange>
References: <Pine.LNX.4.64.1205210902060.30522@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

(CC'ing Pawel and Marek)

On Monday 21 May 2012 10:30:19 Guennadi Liakhovetski wrote:
> Hi
> 
> A recent report
> 
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47594
> 
> has revealed the following asymmetry in how videobuf2 functions:
> 
> as is also documented in videobuf2-core.h, the user's struct
> vb2_ops::buf_init() method in the MMAP case is called after allocating the
> respective buffer, which happens at REQBUFS time, in the USERPTR case it
> is called after acquiring a new buffer at QBUF time. If the allocation in
> MMAP case fails, the respective buffer simply doesn't get created.
> However, if acquiring a new USERPTR buffer at QBUF time fails, the buffer
> object remains on the queue, but the user-provided .buf_init() method is
> not called for it. When the queue is destroyed, the user's .buf_cleanup()
> method is called on an uninitialised buffer. This is exactly the reason
> for the BUG() in the above referenced report.
> 
> Therefore my question: is this videobuf2-core behaviour really correct and
> we should be prepared in .buf_cleanup() to process uninitialised buffers,
> or should the videobuf2-core be adjusted?

>From a driver's point of view, it would make sense not to call .buf_cleanup() 
if .buf_init() hasn't been called. Otherwise each driver would need to check 
whether the buffer has been initialized, which would lead to code duplication.

A new buffer state would help tracking this in the vb2 core. I haven't tried 
to implement it though, so I might be underestimating the effort.

-- 
Regards,

Laurent Pinchart

