Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:58961 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753575Ab2AaPih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 10:38:37 -0500
Received: by mail-tul01m020-f169.google.com with SMTP id ta7so87292obb.28
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 07:38:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120130220139.GB16140@valkosipuli.localdomain>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
	<201201201729.00230.laurent.pinchart@ideasonboard.com>
	<000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com>
	<201201231048.47433.laurent.pinchart@ideasonboard.com>
	<CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com>
	<20120125232816.GA15297@valkosipuli.localdomain>
	<20120126112726.GC3896@phenom.ffwll.local>
	<4F25278B.3090903@iki.fi>
	<20120129130340.GA4312@phenom.ffwll.local>
	<20120130220139.GB16140@valkosipuli.localdomain>
Date: Tue, 31 Jan 2012 09:38:35 -0600
Message-ID: <CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
From: "Clark, Rob" <rob@ti.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 30, 2012 at 4:01 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>
>> So to summarize I understand your constraints - gpu drivers have worked
>> like v4l a few years ago. The thing I'm trying to achieve with this
>> constant yelling is just to raise awereness for these issues so that
>> people aren't suprised when drm starts pulling tricks on dma_bufs.
>
> I think we should be able to mark dma_bufs non-relocatable so also DRM can
> work with these buffers. Or alternatively, as Laurent proposed, V4L2 be
> prepared for moving the buffers around. Are there other reasons to do so
> than paging them out of system memory to make room for something else?

fwiw, from GPU perspective, the DRM device wouldn't be actively
relocating buffers just for the fun of it.  I think it is more that we
want to give the GPU driver the flexibility to relocate when it really
needs to.  For example, maybe user has camera app running, then puts
it in the background and opens firefox which tries to allocate a big
set of pixmaps putting pressure on GPU memory..

I guess the root issue is who is doing the IOMMU programming for the
camera driver.  I guess if this is something built in to the camera
driver then when it calls dma_buf_map() it probably wants some hint
that the backing pages haven't moved so in the common case (ie. buffer
hasn't moved) it doesn't have to do anything expensive.

On omap4 v4l2+drm example I have running, it is actually the DRM
driver doing the "IOMMU" programming.. so v4l2 camera really doesn't
need to care about it.  (And the IOMMU programming here is pretty
fast.)  But I suppose this maybe doesn't represent all cases.  I
suppose if a camera didn't really sit behind an IOMMU but uses
something more like a DMA descriptor list would want to know if it
needed to regenerate it's descriptor list.  Or likewise if camera has
an IOMMU that isn't really using the IOMMU framework (although maybe
that is easier to solve).  But I think a hint returned from
dma_buf_map() would do the job?

BR,
-R
