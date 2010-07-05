Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx06.extmail.prod.ext.phx2.redhat.com
	[10.5.110.10])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o65GFCMQ010410
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 12:15:12 -0400
Received: from smtpauth01.csee.onr.siteprotect.com
	(smtpauth01.csee.onr.siteprotect.com [64.26.60.145])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o65GF2hG025577
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 12:15:02 -0400
Message-ID: <4C320502.3010001@boundarydevices.com>
Date: Mon, 05 Jul 2010 09:14:58 -0700
From: Eric Nelson <eric.nelson@boundarydevices.com>
MIME-Version: 1.0
To: chris@2net.co.uk
Subject: Re: Contiguous memory allocations
References: <1278103660.6034.16.camel@localhost> <4C31AF7E.7090602@2net.co.uk>
	<4C31EBD3.2010607@boundarydevices.com>
	<4C31FAD9.6050808@2net.co.uk>
In-Reply-To: <4C31FAD9.6050808@2net.co.uk>
Cc: video4linux-list@redhat.com, Chris Simmonds <chris.simmonds@2net.co.uk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On 07/05/2010 08:31 AM, Chris Simmonds wrote:
> On 05/07/10 15:27, Eric Nelson wrote:
>> On 07/05/2010 03:10 AM, Chris Simmonds wrote:
>>> On 02/07/10 21:47, Eric Nelson wrote:
>>>> Does anyone know if there's a common infrastructure for allocation
>>>> of DMA'able memory by drivers and applications above the straight
>>>> kernel API (dma_alloc_coherent)?
>>>>
>>>> I'm working with Freescale i.MX51 drivers to do 720P video
>>>> input and output and the embedded calls to dma_alloc_coherent
>>>> fail except when used right after boot because of fragmentation.
>>>>
>>>> I'm fighting the urge to write yet another special-purpose allocator
>>>> for video buffers thinking this must be a common problem with a
>>>> solution already, but I can't seem to locate one.
>>>>
>>>> The closest thing I've found is the bigphysarea patch, which doesn't
>>>> appear to be supported or headed toward main-line.
>>>>
>>>> Thanks in advance,
>>>
>>> dma_alloc_coherent is pretty much just a wrapper round get_free_pages,
>>> which is the lowest level allocator in the kernel. So, no there is no
>>> other option (but see below). The simplest thing is to make sure your
>>> driver is loaded at boot time and to grab all the memory you need then
>>> and never let it go. That's what I do.
>>>
>> Thanks Chris.
>>
>> The trouble is always "how much"? If we don't know at startup what
>> kind of video's needed or what size(s) of camera input may be needed, it's
>> impossible to tune. In the current Freescale kernels, there are at least
 >> 4 separate drivers that allocate RAM, sometimes for internal use, but
 >> mostly in response to userspace calls (ioctl).
>>
>> - frame-buffer driver
>> - Video Processing Unit (VPU) - video encode/decode
>> - V4L2 output device - allows access to YUV output layer, color blending
>> - Image Processing Unit (IPU) - allows userspace bitblts through DMA
>>
>> With this number of calls, tuning with separate kernel command-line args
>> seems unworkable.
>
> I think the kernel developers don't like this kind of on-the-side
> allocator because they tend to be dedicated to solving one kind of problem.
>

They've certainly rejected bigphysarea. I suspected that there are other
special-purpose allocators embedded in many drivers, but grepping drivers/video
shows only a few (2 x Freescale and sis).

I suspect this is because much is being done in userspace a.la. DirectFB.

> Here are a few thoughts about the imx51 specifically, based on my
> experience. First, the size of the memory pool used for dma_alloc_coherent
 > is set in plat-mxc/include/mach/memory.h where it is hard coded to
 > 64 MiB. You could try bumping that up a bit.
>
I did that, and it did help. The latest Freescale kernel patches do that as
well, bumping it to 96M.

The problem still exists, though, especially under Ubuntu 10.04 if the
compcache (ramzswap) module is loaded.

> Second, you could re-do the buffer allocation and replace
> dma_alloc_coherent with kmalloc and then use dma_map_single to lock it
> down while dma is taking place. This way you avoid the 64M dma pool
> limit and you speed up buffer access via mmap because the memory is
> cached. In my case I got a two fold speed improvement reading frames
> into application memory. I have to admit that my case was a bit
> specialised though and it may not be worth the effort for you.
>
> Bye for now,
> Chris.
>
>
Thanks again for the feedback, Chris.

Regards,


Eric

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
