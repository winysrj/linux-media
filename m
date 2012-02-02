Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:39577 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756021Ab2BBUtD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 15:49:03 -0500
Received: by obbup6 with SMTP id up6so3434548obb.10
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 12:49:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120202202303.GB4107@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
	<20120130220139.GB16140@valkosipuli.localdomain>
	<CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
	<201202021119.44794.laurent.pinchart@ideasonboard.com>
	<20120202202303.GB4107@phenom.ffwll.local>
Date: Thu, 2 Feb 2012 14:49:00 -0600
Message-ID: <CAO8GWqkX7zhvVvQLnDJ4D5pKm=PAEpTM-dXeiA92G-K4HsYneg@mail.gmail.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
From: "Clark, Rob" <rob@ti.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 2, 2012 at 2:23 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, Feb 2, 2012 at 11:19, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
>>> On omap4 v4l2+drm example I have running, it is actually the DRM driver
>>> doing the "IOMMU" programming.. so v4l2 camera really doesn't need to care
>>> about it.  (And the IOMMU programming here is pretty fast.)  But I suppose
>>> this maybe doesn't represent all cases. I suppose if a camera didn't really
>>> sit behind an IOMMU but uses something more like a DMA descriptor list would
>>> want to know if it needed to regenerate it's descriptor list. Or likewise if
>>> camera has an IOMMU that isn't really using the IOMMU framework (although
>>> maybe that is easier to solve).  But I think a hint returned from
>>> dma_buf_map() would do the job?
>>
>> I see at least three possible solutions to this problem.
>>
>> 1. At dma_buf_unmap() time, the exporter will tell the importer that the
>> buffer will move, and that it should be unmapped from whatever the importer
>> mapped it to. That's probably the easiest solution to implement on the
>> importer's side, but I expect it to be difficult for the exporter to know at
>> dma_buf_unmap() time if the buffer will need to be moved or not.
>>
>> 2. Adding a callback to request the importer to unmap the buffer. This might
>> be racy, and locking might be difficult to handle.
>>
>> 3. At dma_buf_unmap() time, keep importer's mappings around. The exporter is
>> then free to move the buffer if needed, in which case the mappings will be
>> invalid. This shouldn't be a problem in theory, as the buffer isn't being used
>> by the importer at that time, but can cause stability issues when dealing with
>> rogue hardware as this would punch holes in the IOMMU fence. At dma_buf_map()
>> time the exporter would tell the importer whether the buffer moved or not. If
>> it moved, the importer will tear down the mappings it kept, and create new
>> ones.
>>
>> Variations around those 3 possible solutions are possible.
>
> While preparing my fosdem presentation about dma_buf I've thought quite a
> bit what we still need for forceful unmap support/persistent
> mappings/dynamic dma_buf/whatever you want to call it. And it's a lot, and
> we have quite a few lower hanging fruits to reap (like cpu access and mmap
> support for importer). So I propose instead:
>
> 4. Just hang onto the device mappings for as long as it's convenient and/or
> necessary and feel guilty about it.

for v4l2/vb2, I'd like to at least request some sort of
BUF_PREPARE_IS_EXPENSIVE flag, so we don't penalize devices where
remapping is not expensive.  Ie. the camera driver could set this flag
so vb2 core knows not unmap()/re-map() between frames.

In my case, for v4l2 + encoder, I really need the unmapping/remapping
between frames, at least if there is anything else going on competing
for buffers.  But in my case, the exporter remaps to a contiguous
(sorta) "virtual" address that the camera can see, so there is no
expensive mapping on the importer side of things.


BR,
-R


> The reason is that going fully static isn't worse than a half-baked
> dynamic version of dma_buf, but the half-baked dynamic one has the
> downside that we can ignore the issue and feel good about things ;-)
>
> Cheers, Daniel
> --
> Daniel Vetter
> daniel.vetter@ffwll.ch - +41 (0) 79 364 57 48 - http://blog.ffwll.ch
>
