Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:28705 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2JLG21 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Oct 2012 02:28:27 -0400
Received: from eusync2.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBR00J58ONXUE50@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 07:28:45 +0100 (BST)
Received: from [106.116.147.108] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBR000PRONCVJ20@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Oct 2012 07:28:25 +0100 (BST)
Message-id: <5077B887.4080702@samsung.com>
Date: Fri, 12 Oct 2012 08:28:23 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 21/26] v4l: vb2-dma-contig: add reference counting for a
 device from allocator context
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1349880405-26049-22-git-send-email-t.stanislaws@samsung.com>
 <1557711.XL0Wq5VHNW@avalon>
In-reply-to: <1557711.XL0Wq5VHNW@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,
Thank your your review.

On 10/11/2012 11:49 PM, Laurent Pinchart wrote:
> Hi Tomasz,
> 
> Thanks for the patch.
> 
> On Wednesday 10 October 2012 16:46:40 Tomasz Stanislawski wrote:
>> This patch adds taking reference to the device for MMAP buffers.
>>
>> Such buffers, may be exported using DMABUF mechanism. If the driver that
>> created a queue is unloaded then the queue is released, the device might be
>> released too.  However, buffers cannot be released if they are referenced by
>> DMABUF descriptor(s). The device pointer kept in a buffer must be valid for
>> the whole buffer's lifetime. Therefore MMAP buffers should take a reference
>> to the device to avoid risk of dangling pointers.
>>
>> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> But two small comments below.
> 
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> b/drivers/media/v4l2-core/videobuf2-dma-contig.c index b138b5c..2d661fd
>> 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -148,6 +148,7 @@ static void vb2_dc_put(void *buf_priv)
>>  		kfree(buf->sgt_base);
>>  	}
>>  	dma_free_coherent(buf->dev, buf->size, buf->vaddr, buf->dma_addr);
>> +	put_device(buf->dev);
>>  	kfree(buf);
>>  }
>>
>> @@ -168,6 +169,9 @@ static void *vb2_dc_alloc(void *alloc_ctx, unsigned long
>> size) return ERR_PTR(-ENOMEM);
>>  	}
>>
>> +	/* prevent the device from release while the buffer is exported */
> 
> s/prevent/Prevent/ ?
> 

s/release/being released/ ?

>> +	get_device(dev);
>> +
>>  	buf->dev = dev;
> 
> What about just
> 
> 	buf->dev = get_device(dev);
> 

Right, sorry I missed that from your previous review :).

Regards,
Tomasz Stanislawski

>>  	buf->size = size;

