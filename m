Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:50010 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359Ab2BDLn7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Feb 2012 06:43:59 -0500
Message-ID: <4F2D19E2.7060309@iki.fi>
Date: Sat, 04 Feb 2012 13:43:30 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: "Clark, Rob" <rob@ti.com>
CC: Daniel Vetter <daniel@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201201729.00230.laurent.pinchart@ideasonboard.com> <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com> <201201231048.47433.laurent.pinchart@ideasonboard.com> <CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com> <20120125232816.GA15297@valkosipuli.localdomain> <20120126112726.GC3896@phenom.ffwll.local> <4F25278B.3090903@iki.fi> <20120129130340.GA4312@phenom.ffwll.local> <20120130220139.GB16140@valkosipuli.localdomain> <CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
In-Reply-To: <CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

Clark, Rob wrote:
> On Mon, Jan 30, 2012 at 4:01 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>
>>> So to summarize I understand your constraints - gpu drivers have worked
>>> like v4l a few years ago. The thing I'm trying to achieve with this
>>> constant yelling is just to raise awereness for these issues so that
>>> people aren't suprised when drm starts pulling tricks on dma_bufs.
>>
>> I think we should be able to mark dma_bufs non-relocatable so also DRM can
>> work with these buffers. Or alternatively, as Laurent proposed, V4L2 be
>> prepared for moving the buffers around. Are there other reasons to do so
>> than paging them out of system memory to make room for something else?
> 
> fwiw, from GPU perspective, the DRM device wouldn't be actively
> relocating buffers just for the fun of it.  I think it is more that we
> want to give the GPU driver the flexibility to relocate when it really
> needs to.  For example, maybe user has camera app running, then puts
> it in the background and opens firefox which tries to allocate a big
> set of pixmaps putting pressure on GPU memory..
> 
> I guess the root issue is who is doing the IOMMU programming for the
> camera driver.  I guess if this is something built in to the camera
> driver then when it calls dma_buf_map() it probably wants some hint
> that the backing pages haven't moved so in the common case (ie. buffer
> hasn't moved) it doesn't have to do anything expensive.
> 
> On omap4 v4l2+drm example I have running, it is actually the DRM
> driver doing the "IOMMU" programming.. so v4l2 camera really doesn't
> need to care about it.  (And the IOMMU programming here is pretty

This part sounds odd to me. Well, I guess it _could_ be done that way,
but the ISP IOMMU could be as well different as the one in DRM. That's
the case on OMAP 3, for example.

> fast.)  But I suppose this maybe doesn't represent all cases.  I
> suppose if a camera didn't really sit behind an IOMMU but uses
> something more like a DMA descriptor list would want to know if it
> needed to regenerate it's descriptor list.  Or likewise if camera has
> an IOMMU that isn't really using the IOMMU framework (although maybe
> that is easier to solve).  But I think a hint returned from
> dma_buf_map() would do the job?

An alternative to IOMMU I think in practice would mean CMA-allocated
buffers.

I need to think about this a bit and understand how this would really
work to properly comment this.

For example, how does one mlock() something that isn't mapped to process
memory --- think of a dma buffer not mapped to the user space process
address space?

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
