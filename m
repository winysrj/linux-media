Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:46532 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752026AbcHAOAI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2016 10:00:08 -0400
Subject: Re: Memory freeing when dmabuf fds are exported with VIDIOC_EXPBUF
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <36bf3ef2-e43a-3910-16e2-b51439be5622@igel.co.jp>
 <1654646.5z1yHJNanq@avalon> <826e1919-49c9-c65c-8911-17baf34c1421@xs4all.nl>
 <1677075.k8UG1Er7L0@avalon>
Cc: Kazunori Kobayashi <kkobayas@igel.co.jp>,
	linux-media@vger.kernel.org,
	Damian Hobson-Garcia <dhobsong@igel.co.jp>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b3161f8d-b958-41ca-f0e6-65a16c63f22c@xs4all.nl>
Date: Mon, 1 Aug 2016 15:59:54 +0200
MIME-Version: 1.0
In-Reply-To: <1677075.k8UG1Er7L0@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/01/2016 03:49 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday 01 Aug 2016 14:27:48 Hans Verkuil wrote:
>> On 08/01/2016 02:17 PM, Laurent Pinchart wrote:
>>> On Monday 01 Aug 2016 12:56:55 Hans Verkuil wrote:
>>>> On 07/27/2016 02:57 PM, Laurent Pinchart wrote:
>>>>> On Wednesday 27 Jul 2016 16:51:47 Kazunori Kobayashi wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I have a question about memory freeing by calling REQBUF(0) before all
>>>>>> the dmabuf fds exported with VIDIOC_EXPBUF are closed.
>>>>>>
>>>>>> In calling REQBUF(0), videobuf2-core returns -EBUSY when the reference
>>>>>> count of a vb2 buffer is more than 1. When dmabuf fds are not exported
>>>>>> (usual V4L2_MEMORY_MMAP case), the check is no problem, but when dmabuf
>>>>>> fds are exported and some of them are not closed (in other words the
>>>>>> references to that memory are left), we cannot succeed in calling
>>>>>> REQBUF(0) despite being able to free the memory after all the
>>>>>> references are dropped.
>>>>>>
>>>>>> Actually REQBUF(0) does not force a vb2 buffer to be freed but
>>>>>> decreases the refcount of it. Also all the vb2 memory allocators that
>>>>>> support dmabuf exporting (dma-contig, dma-sg, vmalloc) implements
>>>>>> memory freeing by release() of dma_buf_ops, so I think there is no need
>>>>>> to return -EBUSY when exporting dmabuf fds.
>>>>>>
>>>>>> Could you please tell me what you think?
>>>>>
>>>>> I think you're right. vb2 allocates the vb2_buffer and the
>>>>> memops-specific structure separately. videobuf2-core.c will free the
>>>>> vb2_buffer instance, but won't touch the memops-specific structure or
>>>>> the buffer memory. Both of these are reference-counted in the memops
>>>>> allocators. We could thus allow REQBUFS(0) to proceed even when buffers
>>>>> have been exported (or at least after fixing the small issues we'll run
>>>>> into, I have a feeling that this is too easy to be true).
>>>>>
>>>>> Hans, Marek, any opinion on this ?
>>>>
>>>> What is the use-case for this? What you are doing here is to either free
>>>> all existing buffers or reallocate buffers. We can decide to rely on
>>>> refcounting, but then you would create a second set of buffers (when
>>>> re-allocating) or leave a lot of unfreed memory behind. That's pretty
>>>> hard
>>>> on the memory usage.
>>>
>>> Speaking of which, we have no way today to really limit memory usage. I
>>> wonder whether we should try to integrate support for resource limits in
>>> V4L2.
>>
>> I'm opposed to that. We had drivers in the past that did that (perhaps there
>> are still a few old ones left), but I removed those checks. In practice
>> this all depends on the use-case. And if you try to allocate more buffers
>> than there is memory, you just get ENOMEM. Which is what it is there for.
>>
>> After all, how to decide what limit to use? If someone wants to use all 32
>> buffers for some reason, or allocate larger buffers than strictly needed,
>> then they should be able to do so. Perhaps you want to be able to capture a
>> burst of high quality snapshots without having to process them immediately.
>> Or other video streams are going to be composed into the buffers so you
>> need to make them larger.
>>
>> The only real limits are the amount of physical (DMAable) memory and the
>> artificial 32 buffer limit which we already know is insufficient in
>> certain use-cases.
> 
> When the user running V4L2 applications has full control over the system, 
> perhaps, but how about shared systems where the system administrator wants to 
> control resource usage per user ? Containers also come to mind, per-cgroup 
> memory limits should be honoured.

If an administrator explicitly restricts memory usage, then it would make sense
to honor that. Are those checks perhaps already done deep in the mm code? I've
no idea what would be involved.

> And even for single-user systems, having the system start trashing because a 
> random 3rd party video application decided to allocate a large number of 
> buffers for no good reason provides a pretty bad user experience.
> 

How would you know it is 'for no good reason'? Like any other application if it
uses too much memory either don't use it or fix it. It's not up to the kernel
to limit this arbitrarily.

My opinion, of course.

Regards,

	Hans
