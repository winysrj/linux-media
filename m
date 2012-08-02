Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25928 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2HBQbU (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Aug 2012 12:31:20 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8400AQZZ94J7A0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Aug 2012 17:31:52 +0100 (BST)
Received: from [106.116.147.108] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8400IOUZ84GX30@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Aug 2012 17:31:18 +0100 (BST)
Message-id: <501AAB51.5050408@samsung.com>
Date: Thu, 02 Aug 2012 18:31:13 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dima Zavin <dmitriyz@google.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, airlied@redhat.com,
	m.szyprowski@samsung.com, kyungmin.park@samsung.com,
	sumit.semwal@ti.com, daeinki@gmail.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, remi@remlab.net,
	subashrp@gmail.com, mchehab@redhat.com, g.liakhovetski@gmx.de,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCHv7 03/15] v4l: vb2: add support for shared buffer (dma_buf)
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com>
 <201206261140.37666.hverkuil@xs4all.nl>
 <CAPz4a6Cn9-f+nP6HeC94oiyJGqxesz40pWGp1ZxnA-gJZ4e=dQ@mail.gmail.com>
 <2867746.1nlzVAXyL8@avalon>
In-reply-to: <2867746.1nlzVAXyL8@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent, Hi Dima,

On 06/27/2012 10:40 PM, Laurent Pinchart wrote:
> Hi Dima,
> 
> On Tuesday 26 June 2012 13:53:34 Dima Zavin wrote:
>> On Tue, Jun 26, 2012 at 2:40 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On Tue 26 June 2012 11:11:06 Laurent Pinchart wrote:
>>>> On Tuesday 26 June 2012 10:40:44 Tomasz Stanislawski wrote:
>>>>> Hi Dima Zavin,
>>>>> Thank you for the patch and for a ping remainder :).
>>>>>
>>>>> You are right. The unmap is missing in __vb2_queue_cancel.
>>>>> I will apply your fix into next version of V4L2 support for dmabuf.
>>>>>
>>>>> Please refer to some comments below.
>>>>>
>>>>> On 06/20/2012 08:12 AM, Dima Zavin wrote:
>>>>>> Tomasz,
>>>>>>
>>>>>> I've encountered an issue with this patch when userspace does several
>>>>>> stream_on/stream_off cycles. When the user tries to qbuf a buffer
>>>>>> after doing stream_off, we trigger the "dmabuf already pinned"
>>>>>> warning since we didn't unmap the buffer as dqbuf was never called.
>>>>>>
>>>>>> The below patch adds calls to unmap in queue_cancel, but my feeling
>>>>>> is that we probably should be calling detach too (i.e. put_dmabuf).
>>>>
>>>> According to the V4L2 specification, the "VIDIOC_STREAMOFF ioctl, apart
>>>> of aborting or finishing any DMA in progress, unlocks any user pointer
>>>> buffers locked in physical memory, and it removes all buffers from the
>>>> incoming and outgoing queues".
>>>
>>> Correct. And what that means in practice is that after a streamoff all
>>> buffers are returned to the state they had just before STREAMON was
>>> called.
>>
>> That can't be right. The buffers had to have been returned to the
>> state just *after REQBUFS*, not just *before STREAMON*. You need to
>> re-enqueue buffers before calling STREAMON. I assume that's what you
>> meant?
> 
> Your interpretation is correct.
> 

So now we should decide what should be changed: the spec or vb2 ?
Bringing the queue state back to *after REQBUFS* may make the
next (STREAMON + QBUFs) very costly operations.

Reattaching and mapping a DMABUF might trigger DMA allocation and
*will* trigger creation of IOMMU mappings. In case of a user pointer,
calling next get_user_pages may cause numerous fault events and
will *create* new IOMMU mapping.

Is there any need to do such a cleanup if the destruction of buffers
and all caches can be explicitly executed by REQBUFS(count = 0) ?

Maybe it would be easier to change the spec by removing
"apart of ... in physical memory" part?

STREAMOFF should mean stopping streaming, and that resources are no
longer used. DMABUFs are unmapped but unmapping does not mean releasing.
The exporter may keep the resource in its caches.

Currently, vb2 does not follow the policy from the spec.
The put_userptr ops is called on:
- VIDIOC_REBUFS
- VIDIOC_CREATE_BUFS
- vb2_queue_release() which is usually called on close() syscall

The put_userptr is not called and streamoff therefore the user pages
are locked after STREAMOFF.

BTW. What does 'buffer locked' mean?

Does it mean that a buffer is pinned or referenced by a driver/HW?

Regards,
Tomasz Stanislawski


>>> So after STREAMOFF you can immediately queue all buffers again with QBUF
>>> and call STREAMON to restart streaming. No mmap or other operations
>>> should be required. This behavior must be kept.
>>>
>>> VIDIOC_REQBUFS() or a close() are the only two operations that will
>>> actually free the buffers completely.
>>>
>>> In practice, a STREAMOFF is either followed by a STREAMON at a later time,
>>> or almost immediately followed by REQBUFS or close() to tear down the
>>> buffers. So I don't think the buffers should be detached at streamoff.
>>
>> I agree. I was leaning this way which is why I left it out of my patch
>> and wanted to hear your guys' opinion as you are much more familiar
>> with the intended behavior than I am.
>>
>> Thanks!
> 
> You're welcome. Thank you for reporting the problem and providing a patch.
> 

