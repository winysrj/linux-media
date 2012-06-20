Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:43472 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2FTNBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 09:01:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCHv7 06/15] v4l: vb2-dma-contig: remove reference of alloc_ctx from a buffer
Date: Wed, 20 Jun 2012 15:02:03 +0200
Message-ID: <10987802.sqhHAxo7hi@avalon>
In-Reply-To: <4FE1B92A.7080702@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <63837768.yEisOgrV5B@avalon> <4FE1B92A.7080702@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Wednesday 20 June 2012 13:51:06 Tomasz Stanislawski wrote:
> On 06/19/2012 11:00 PM, Laurent Pinchart wrote:
> > On Thursday 14 June 2012 15:37:40 Tomasz Stanislawski wrote:
> >> This patch removes a reference to alloc_ctx from an instance of a DMA
> >> contiguous buffer. It helps to avoid a risk of a dangling pointer if the
> >> context is released while the buffer is still valid.
> > 
> > Can this really happen ? All drivers except marvell-ccic seem to call
> > vb2_dma_contig_cleanup_ctx() in their remove handler and probe cleanup
> > path only. Freeing the context while buffers are still around would be a
> > driver bug, and I expect drivers to destroy the queue in that case anyway.
> > 
> > This being said, removing the dereference step is a good idea, so I think
> > the patch should be applied, possibly with a different commit message.
>
> The problem may happen if a DMABUF sharing is used.
> - process A uses V4L2 queue to create a buffer
> - process A exports a buffer and shares it with the process B (by sockets or
> /proc/pid/fd) - the process A gets killed, queue is destroyed
> - someone call rmmod on v4l driver, alloc_ctx is freed

That's where the problem is in my opinion. As long as a buffer is in use, the 
queue should not get destroyed and the context should not be freed. If the 
driver is removed it will kfree the structure that embeds the queue, and even 
possible free the whole memory region that backs the buffers. We would then  
have much bigger trouble than just a dangling context pointer.

>From a V4L2 point of view this needs to be solved for the dmabuf exporter role 
only, so it's not a huge concern in the context of this patch set, but we of 
course need to address the issue.

> - process B keeps reference to a buffer that has a dangling reference to
> alloc_ctx
> 
> The presented scenario might be a bit too pathological and artificial.
> Moreover it involves root privileges. But it is possible to trigger this
> bug. One solution might be keeping reference count in alloc_ctx but it
> would be easier to get rid of the reference to alloc_ctx from
> vb2-dma-contig buffer.
> 
> BTW. I decided to drop 'Remove unneeded allocation context structure'
> because Marek Szyprowski is working on extension to vb2-dma-contig
> that allow to create buffers with no kernel mappings. That feature
> involved additional parameter to alloc_ctx other than pointer to
> the device.

OK.

-- 
Regards,

Laurent Pinchart

