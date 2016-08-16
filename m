Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49386 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753125AbcHPVNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 17:13:49 -0400
Subject: Re: [PATCH] [media] vb2: move dma-buf unmap from __vb2_dqbuf() to
 vb2_buffer_done()
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
References: <1469038941-5257-1-git-send-email-javier@osg.samsung.com>
 <3b09885c-1bec-fcbe-6c6c-9c753502cb81@xs4all.nl>
 <2c6196f7-d157-ce79-b81e-fa8c8e3ccb6e@osg.samsung.com>
 <57B37BE7.4030009@iki.fi>
 <24b9d80b-e7aa-60ea-bad9-ec62ffa04e87@osg.samsung.com>
From: Sakari Ailus <sakari.ailus@iki.fi>
Message-ID: <57B3820A.2000308@iki.fi>
Date: Wed, 17 Aug 2016 00:13:46 +0300
MIME-Version: 1.0
In-Reply-To: <24b9d80b-e7aa-60ea-bad9-ec62ffa04e87@osg.samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Javier Martinez Canillas wrote:
> Hello Sakari,
> 
> On 08/16/2016 04:47 PM, Sakari Ailus wrote:
>> Hi Javier,
>>
>> Javier Martinez Canillas wrote:
>>> Hello Hans,
>>>
>>> Thanks a lot for your feedback.
>>>
>>> On 08/13/2016 09:47 AM, Hans Verkuil wrote:
>>>> On 07/20/2016 08:22 PM, Javier Martinez Canillas wrote:
>>>>> Currently the dma-buf is unmapped when the buffer is dequeued by userspace
>>>>> but it's not used anymore after the driver finished processing the buffer.
>>>>>
>>>>> So instead of doing the dma-buf unmapping in __vb2_dqbuf(), it can be made
>>>>> in vb2_buffer_done() after the driver notified that buf processing is done.
>>>>>
>>>>> Decoupling the buffer dequeue from the dma-buf unmapping has also the side
>>>>> effect of making possible to add dma-buf fence support in the future since
>>>>> the buffer could be dequeued even before the driver has finished using it.
>>>>>
>>>>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>>>>
>>>>> ---
>>>>> Hello,
>>>>>
>>>>> I've tested this patch doing DMA buffer sharing between a
>>>>> vivid input and output device with both v4l2-ctl and gst:
>>>>>
>>>>> $ v4l2-ctl -d0 -e1 --stream-dmabuf --stream-out-mmap
>>>>> $ v4l2-ctl -d0 -e1 --stream-mmap --stream-out-dmabuf
>>>>> $ gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf ! v4l2sink device=/dev/video1 io-mode=dmabuf-import
>>>>>
>>>>> And I didn't find any issues but more testing will be appreciated.
>>>>>
>>>>> Best regards,
>>>>> Javier
>>>>>
>>>>>  drivers/media/v4l2-core/videobuf2-core.c | 34 +++++++++++++++++++++-----------
>>>>>  1 file changed, 22 insertions(+), 12 deletions(-)
>>>>>
>>>>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>>>>> index 7128b09810be..973331efaf79 100644
>>>>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>>>>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>>>>> @@ -958,6 +958,22 @@ void *vb2_plane_cookie(struct vb2_buffer *vb, unsigned int plane_no)
>>>>>  EXPORT_SYMBOL_GPL(vb2_plane_cookie);
>>>>>  
>>>>>  /**
>>>>> + * __vb2_unmap_dmabuf() - unmap dma-buf attached to buffer planes
>>>>> + */
>>>>> +static void __vb2_unmap_dmabuf(struct vb2_buffer *vb)
>>>>> +{
>>>>> +	int i;
>>>>> +
>>>>> +	for (i = 0; i < vb->num_planes; ++i) {
>>>>> +		if (!vb->planes[i].dbuf_mapped)
>>>>> +			continue;
>>>>> +		call_void_memop(vb, unmap_dmabuf,
>>>>> +				vb->planes[i].mem_priv);
>>>>
>>>> Does unmap_dmabuf work in interrupt context? Since vb2_buffer_done can be called from
>>>> an irq handler this is a concern.
>>>>
>>>
>>> Good point, I believe it shouldn't be called from atomic context since both
>>> the dma_buf_vunmap() and dma_buf_unmap_attachment() functions can sleep.
>>>  
>>>> That said, vb2_buffer_done already calls call_void_memop(vb, finish, vb->planes[plane].mem_priv);
>>>> to sync buffers, and that can take a long time as well. So it is not a good idea to
>>>> have this in vb2_buffer_done.
>>>>
>>>
>>> I see.
>>>
>>>> What I would like to see is to have vb2 handle this finish() call and the vb2_unmap_dmabuf
>>>> in some workthread or equivalent.
>>>>
>>>> It would complicate matters somewhat in vb2, but it would simplify drivers since these
>>>> actions would not longer take place in interrupt context.
>>>>
>>>> I think this patch makes sense, but I would prefer that this is moved out of the interrupt
>>>> context.
>>>>
>>>
>>> Ok, I can take a look to this and handle the finish() and unmap_dmabuf()
>>> out of interrupt context as you suggested.
>>
>> I have a patch doing the former which is a part of my cache management
>> fix patchset:
>>
>> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=b57f937627abda158ada01a3297dbb0f0a57b515>
>> <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=shortlog;h=refs/heads/vb2-dc-noncoherent>
>>
> 
> Interesting, thanks for the links.
>  
>> There were a few drivers doing nasty things with memory that I couldn't
>> quite fix back then. Just FYI.
>>
> 
> Did you mean that there were issues with moving finish mem op call to DQBUF?
> 
> Do you recall what these drivers were or what were doing that caused problems?

Not any particular drivers --- the problem is that flushing the cache
simply takes a lot of time, often milliseconds depending on the machine.
There's also no reason to do it in interrupt context. It kills realtime
performance, too.

> 
> In any case, what Hans proposed AFAIU is not to change when the finish call
> happens but to split the vb2_buffer_done() function and defer part of it to
> a workqueue or kthread. I'll give a try to that approach probably tomorrow.

There's also the context of the user space process calling DQBUF, too.
Why not to use that one instead?

-- 
Sakari Ailus
sakari.ailus@iki.fi
