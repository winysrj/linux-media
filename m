Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21971 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913Ab2FTLvL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jun 2012 07:51:11 -0400
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M5W001FXZMDXI80@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Jun 2012 12:51:49 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M5W001BLZL73W00@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 20 Jun 2012 12:51:09 +0100 (BST)
Message-id: <4FE1B92A.7080702@samsung.com>
Date: Wed, 20 Jun 2012 13:51:06 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de
Subject: Re: [PATCHv7 06/15] v4l: vb2-dma-contig: remove reference of alloc_ctx
 from a buffer
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
 <1339681069-8483-7-git-send-email-t.stanislaws@samsung.com>
 <63837768.yEisOgrV5B@avalon>
In-reply-to: <63837768.yEisOgrV5B@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 06/19/2012 11:00 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Thursday 14 June 2012 15:37:40 Tomasz Stanislawski wrote:
>> This patch removes a reference to alloc_ctx from an instance of a DMA
>> contiguous buffer. It helps to avoid a risk of a dangling pointer if the
>> context is released while the buffer is still valid.
> 
> Can this really happen ? All drivers except marvell-ccic seem to call 
> vb2_dma_contig_cleanup_ctx() in their remove handler and probe cleanup path 
> only. Freeing the context while buffers are still around would be a driver 
> bug, and I expect drivers to destroy the queue in that case anyway.
> 
> This being said, removing the dereference step is a good idea, so I think the
> patch should be applied, possibly with a different commit message.
>

The problem may happen if a DMABUF sharing is used.
- process A uses V4L2 queue to create a buffer
- process A exports a buffer and shares it with the process B (by sockets or /proc/pid/fd)
- the process A gets killed, queue is destroyed
- someone call rmmod on v4l driver, alloc_ctx is freed
- process B keeps reference to a buffer that has a dangling reference to alloc_ctx

The presented scenario might be a bit too pathological and artificial.
Moreover it involves root privileges. But it is possible to trigger this bug.
One solution might be keeping reference count in alloc_ctx but it would
be easier to get rid of the reference to alloc_ctx from vb2-dma-contig buffer.

BTW. I decided to drop 'Remove unneeded allocation context structure'
because Marek Szyprowski is working on extension to vb2-dma-contig
that allow to create buffers with no kernel mappings. That feature
involved additional parameter to alloc_ctx other than pointer to
the device.

Regards,
Tomasz Stanislawski

>> Moreover it removes one
>> dereference step while accessing a device structure.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
>> +		dma_free_coherent(buf->dev, buf->size, buf->vaddr,
>>  				  buf->dma_addr);
>>  		kfree(buf);
>>  	}

