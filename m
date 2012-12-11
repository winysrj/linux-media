Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43829 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab2LKN6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Dec 2012 08:58:51 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	LMML <linux-media@vger.kernel.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [RFC PATCH] vb2: force output buffers to fault into memory
Date: Tue, 11 Dec 2012 15:00:04 +0100
Message-ID: <2206167.Ej7sUhClDy@avalon>
In-Reply-To: <50C1FD4A.7020808@samsung.com>
References: <201212041648.40108.hverkuil@xs4all.nl> <2230570.TblGvim78c@avalon> <50C1FD4A.7020808@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek,

On Friday 07 December 2012 15:29:30 Marek Szyprowski wrote:
> On 12/6/2012 2:23 AM, Laurent Pinchart wrote:
> > On Tuesday 04 December 2012 16:48:40 Hans Verkuil wrote:
> > > (repost after accidentally using HTML formatting)
> > > 
> > > This needs a good review. The change is minor, but as I am not a mm
> > > expert, I'd like to get some more feedback on this. The dma-sg change
> > > has been successfully tested on our hardware, but I don't have any
> > > hardware to test the vmalloc change.
> > > 
> > > Note that the 'write' attribute is still stored internally and used to
> > > tell whether set_page_dirty_lock() should be called during put_userptr.
> > > 
> > > It is my understanding that that still makes sense, so I didn't change
> > > that.
> > > 
> > > Regards,
> > > 
> > > 	Hans
> > > 
> > > --- start patch ---
> > > 
> > > When calling get_user_pages for output buffers, the 'write' argument is
> > > set to 0 (since the DMA isn't writing to memory), This can cause
> > > unexpected results:
> > > 
> > > If you calloc() buffer memory and do not fill that memory afterwards,
> > > then the kernel assigns most of that memory to one single physical
> > > 'zero' page.
> > > 
> > > If you queue that buffer to the V4L2 driver, then it will call
> > > get_user_pages and store the results. Next you dequeue it, fill the
> > > buffer and queue it again. Now the V4L2 core code sees the same userptr
> > > and length and expects it to be the same buffer that it got before and
> > > it will reuse the results of the previous get_user_pages call. But that
> > > still points to zero pages, whereas userspace filled it up and so
> > > changed the buffer to use different pages. In other words, the pages the
> > > V4L2 core knows about are no longer correct.
> > > 
> > > The solution is to always set 'write' to 1 as this will force the kernel
> > > to fault in proper pages.
> > 
> > I'm wondering if we should really force faulting pages. The buffer given
> > to the driver might be real read-only memory, in which case faulting the
> > pages would probably hurt (agreed, that's pretty unlikely, but it's still
> > a valid use case according to the API).
> > 
> > Moreover, this wouldn't fix all similar userptr-related issues. An
> > application could remap a completely different memory area to the same
> > userspace address between two QBUF calls, and videobuf2 would not handle
> > that properly. That's also a valid use case according to the API, and it
> > would be pretty difficult to handle it correctly in an efficient way on
> > the kernel side. I think we could modify the spec to forbid mapping
> > changes between QBUF calls, and in that case the zero-page mapping
> > situation you described could be forbidden as well. If we clearly
> > document it in the spec we could push the responsibility of faulting the
> > pages to userspace.
> 
> I've spent some time thinking on this issue and I came to the conclusion
> that it might be a good idea extend the v4l2 spec with such case. Changing
> the write parameter for get_user_pages() is only a workaround, which doesn't
> even work for all possible use cases, so I agree with Laurent that user ptr
> usage should be much better documented. I only wonder if it a good idea to
> require faulting in pages from the user space application. Can we assume
> that memset(ptr, 0, buf_size) will do the job in all cases? I expect yes,
> but I would like to be really sure,

Good question, I would also guess that memset should do, but I'm no expert on 
memory management code.

> this will be probably put into the documentation for the reference code.

At the end of the day it's just an API contract, like all the others. The 
USERPTR API should, in my opinion, require userspace to provide a buffer 
backed by usable pages (for non PFNMAP buffers) or usable physical memory (for 
PFNMAP buffers). Otherwise the kernel will need to switch to a guesswork mode, 
which is hackish at best.

Of course people should use DMABUF instead of USERPTR when possible :-)

-- 
Regards,

Laurent Pinchart

