Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38797 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab2BBUXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 15:23:03 -0500
Received: by wgbdt10 with SMTP id dt10so3023916wgb.1
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 12:23:01 -0800 (PST)
Date: Thu, 2 Feb 2012 21:23:03 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Clark, Rob" <rob@ti.com>, Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120202202303.GB4107@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <20120130220139.GB16140@valkosipuli.localdomain>
 <CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
 <201202021119.44794.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201202021119.44794.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 2, 2012 at 11:19, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>> On omap4 v4l2+drm example I have running, it is actually the DRM driver
>> doing the "IOMMU" programming.. so v4l2 camera really doesn't need to care
>> about it.  (And the IOMMU programming here is pretty fast.)  But I suppose
>> this maybe doesn't represent all cases. I suppose if a camera didn't really
>> sit behind an IOMMU but uses something more like a DMA descriptor list would
>> want to know if it needed to regenerate it's descriptor list. Or likewise if
>> camera has an IOMMU that isn't really using the IOMMU framework (although
>> maybe that is easier to solve).  But I think a hint returned from
>> dma_buf_map() would do the job?
>
> I see at least three possible solutions to this problem.
>
> 1. At dma_buf_unmap() time, the exporter will tell the importer that the
> buffer will move, and that it should be unmapped from whatever the importer
> mapped it to. That's probably the easiest solution to implement on the
> importer's side, but I expect it to be difficult for the exporter to know at
> dma_buf_unmap() time if the buffer will need to be moved or not.
>
> 2. Adding a callback to request the importer to unmap the buffer. This might
> be racy, and locking might be difficult to handle.
>
> 3. At dma_buf_unmap() time, keep importer's mappings around. The exporter is
> then free to move the buffer if needed, in which case the mappings will be
> invalid. This shouldn't be a problem in theory, as the buffer isn't being used
> by the importer at that time, but can cause stability issues when dealing with
> rogue hardware as this would punch holes in the IOMMU fence. At dma_buf_map()
> time the exporter would tell the importer whether the buffer moved or not. If
> it moved, the importer will tear down the mappings it kept, and create new
> ones.
>
> Variations around those 3 possible solutions are possible.

While preparing my fosdem presentation about dma_buf I've thought quite a
bit what we still need for forceful unmap support/persistent
mappings/dynamic dma_buf/whatever you want to call it. And it's a lot, and
we have quite a few lower hanging fruits to reap (like cpu access and mmap
support for importer). So I propose instead:

4. Just hang onto the device mappings for as long as it's convenient and/or
necessary and feel guilty about it.

The reason is that going fully static isn't worse than a half-baked
dynamic version of dma_buf, but the half-baked dynamic one has the
downside that we can ignore the issue and feel good about things ;-)

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch

