Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35586 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2BBOlN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 09:41:13 -0500
Received: by qcqw6 with SMTP id w6so1416444qcq.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 06:41:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAO8GWqknNtFOUUKKEqL053jR5WwqOmraHGsy9h4OnU=-yj7XOQ@mail.gmail.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <20120130220139.GB16140@valkosipuli.localdomain> <CAO8GWqmxZbyrZoc-35RGpREJ7Z0ixQ3L+1xBkdhGbYT_31t-Og@mail.gmail.com>
 <201202021119.44794.laurent.pinchart@ideasonboard.com> <CAO8GWqknNtFOUUKKEqL053jR5WwqOmraHGsy9h4OnU=-yj7XOQ@mail.gmail.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 2 Feb 2012 20:10:51 +0530
Message-ID: <CAO_48GGmKib+7j6NNWan8ncXLmfLw7QHaiB+xDdeeqV8WyUxAQ@mail.gmail.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
To: "Clark, Rob" <rob@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Daniel Vetter <daniel@ffwll.ch>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2 February 2012 19:31, Clark, Rob <rob@ti.com> wrote:
> On Thu, Feb 2, 2012 at 4:19 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Rob,
>>
>> On Tuesday 31 January 2012 16:38:35 Clark, Rob wrote:
>>> On Mon, Jan 30, 2012 at 4:01 PM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
>>> >> So to summarize I understand your constraints - gpu drivers have worked
>>> >> like v4l a few years ago. The thing I'm trying to achieve with this
>>> >> constant yelling is just to raise awereness for these issues so that
>>> >> people aren't suprised when drm starts pulling tricks on dma_bufs.
>>> >
>>> > I think we should be able to mark dma_bufs non-relocatable so also DRM
>>> > can work with these buffers. Or alternatively, as Laurent proposed, V4L2
>>> > be prepared for moving the buffers around. Are there other reasons to do
>>> > so than paging them out of system memory to make room for something
>>> > else?
>>>
>>> fwiw, from GPU perspective, the DRM device wouldn't be actively
>>> relocating buffers just for the fun of it.  I think it is more that we
>>> want to give the GPU driver the flexibility to relocate when it really
>>> needs to.  For example, maybe user has camera app running, then puts
>>> it in the background and opens firefox which tries to allocate a big
>>> set of pixmaps putting pressure on GPU memory..
>>
>> On an embedded system putting the camera application in the background will
>> usually stop streaming, so buffers will be unmapped. On other systems, or even
>> on some embedded systems, that will not be the case though.
>>
>> I'm perfectly fine with relocating buffers when needed. What I want is to
>> avoid unmapping and remapping them for every frame if they haven't moved. I'm
>> sure we can come up with an API to handle that.
>>
>>> I guess the root issue is who is doing the IOMMU programming for the camera
>>> driver. I guess if this is something built in to the camera driver then when
>>> it calls dma_buf_map() it probably wants some hint that the backing pages
>>> haven't moved so in the common case (ie. buffer hasn't moved) it doesn't
>>> have to do anything expensive.
>>
>> It will likely depend on the camera hardware. For the OMAP3 ISP, the driver
>> calls the IOMMU API explictly, but if I understand it correctly there's a plan
>> to move IOMMU support to the DMA API.
>>
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
>
> I was leaning towards door #3.. rogue hw is a good point, but I think
> that would be an issue in general if hw kept accessing the buffer when
> it wasn't supposed to.
>
Yes, I feel #3 is a fair way of solving this.
> BR,
> -R
>
>> Variations around those 3 possible solutions are possible.
>>
>> --
>> Regards,
>>
>> Laurent Pinchart
Thanks and regards,
~Sumit.
