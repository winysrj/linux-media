Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:32903 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbcHCDXs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 23:23:48 -0400
Received: by mail-pf0-f181.google.com with SMTP id y134so72539715pfg.0
        for <linux-media@vger.kernel.org>; Tue, 02 Aug 2016 20:23:43 -0700 (PDT)
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kazunori Kobayashi <kkobayas@igel.co.jp>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp>
 <2220172.K033cFnpL3@avalon> <f0518dd3-ae01-2da1-12ac-1fb041aaa709@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
Message-ID: <76ad6d96-146f-d2c0-1872-2c7977b3d3b9@igel.co.jp>
Date: Wed, 3 Aug 2016 12:23:38 +0900
MIME-Version: 1.0
In-Reply-To: <f0518dd3-ae01-2da1-12ac-1fb041aaa709@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2016-08-01 7:56 PM, Hans Verkuil wrote:
> 
> 
> On 07/27/2016 02:57 PM, Laurent Pinchart wrote:
>> Hello Kobayashi-san,
>>
>> (CC'ing Hans Verkuil and Marek Szyprowski)
>>
>> On Wednesday 27 Jul 2016 16:51:47 Kazunori Kobayashi wrote:
>>> Hi,
>>>
>>> I have a question about memory freeing by calling REQBUF(0) before all the
>>> dmabuf fds exported with VIDIOC_EXPBUF are closed.
>>>
>>> In calling REQBUF(0), videobuf2-core returns -EBUSY when the reference count
>>> of a vb2 buffer is more than 1. When dmabuf fds are not exported (usual
>>> V4L2_MEMORY_MMAP case), the check is no problem, but when dmabuf fds are
>>> exported and some of them are not closed (in other words the references to
>>> that memory are left), we cannot succeed in calling REQBUF(0) despite being
>>> able to free the memory after all the references are dropped.
>>>
>>> Actually REQBUF(0) does not force a vb2 buffer to be freed but decreases
>>> the refcount of it. Also all the vb2 memory allocators that support dmabuf
>>> exporting (dma-contig, dma-sg, vmalloc) implements memory freeing by
>>> release() of dma_buf_ops, so I think there is no need to return -EBUSY when
>>> exporting dmabuf fds.
>>>
>>> Could you please tell me what you think?
>>
>> I think you're right. vb2 allocates the vb2_buffer and the memops-specific 
>> structure separately. videobuf2-core.c will free the vb2_buffer instance, but 
>> won't touch the memops-specific structure or the buffer memory. Both of these 
>> are reference-counted in the memops allocators. We could thus allow REQBUFS(0) 
>> to proceed even when buffers have been exported (or at least after fixing the 
>> small issues we'll run into, I have a feeling that this is too easy to be 
>> true).
>>
>> Hans, Marek, any opinion on this ?
> 
> What is the use-case for this? What you are doing here is to either free all
> existing buffers or reallocate buffers. We can decide to rely on refcounting,
> but then you would create a second set of buffers (when re-allocating) or
> leave a lot of unfreed memory behind. That's pretty hard on the memory usage.

One use case is performing a buffer resize while actively streaming
buffers to the display.  It seems that it would be useful to re-allocate
new buffers (which will have some different properties) while one of the
old buffers is displayed on screen. When the new buffer replaces the old
one on screen, the old buffer(s) can be released, freeing the memory
while the resize appears seamless at the display.  This avoids the rush
to re-allocate and fill the first buffer after a resize with valid data
before the next vblank, which can cause flicker when it fails.

This method requires the application to properly close the dmabuf
handles when the buffers come off the screen, but Wayland, for example,
already provides a notification mechanism to achieve this.

Thanks,
Damian

> 
> I think the EBUSY is there to protect the user against him/herself: i.e. don't
> call this unless you know all refs are closed.
> 
> Given the typical large buffersizes we're talking about, I think that EBUSY
> makes sense.
> 
> Regards,
> 
> 	Hans
> 
>>
>>> The code that I am talking about is in
>>> drivers/media/v4l2-core/videobuf2-core.c:
>>>
>>>    if (*count == 0 || q->num_buffers != 0 || q->memory != memory) {
>>>           /*
>>>            * We already have buffers allocated, so first check if they
>>>            * are not in use and can be freed.
>>>            */
>>>           mutex_lock(&q->mmap_lock);
>>>           if (q->memory == VB2_MEMORY_MMAP && __buffers_in_use(q)) {
>>>                   mutex_unlock(&q->mmap_lock);
>>>                   dprintk(1, "memory in use, cannot free\n");
>>>                   return -EBUSY;
>>>           }
>>
