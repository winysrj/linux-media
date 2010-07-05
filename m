Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o65FVqwD026208
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 11:31:52 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o65FVgIs018297
	for <video4linux-list@redhat.com>; Mon, 5 Jul 2010 11:31:43 -0400
Message-ID: <4C31FAD9.6050808@2net.co.uk>
Date: Mon, 05 Jul 2010 16:31:37 +0100
From: Chris Simmonds <chris.simmonds@2net.co.uk>
MIME-Version: 1.0
To: Eric Nelson <eric.nelson@boundarydevices.com>
Subject: Re: Contiguous memory allocations
References: <1278103660.6034.16.camel@localhost> <4C31AF7E.7090602@2net.co.uk>
	<4C31EBD3.2010607@boundarydevices.com>
In-Reply-To: <4C31EBD3.2010607@boundarydevices.com>
Cc: video4linux-list@redhat.com
Reply-To: chris@2net.co.uk
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

On 05/07/10 15:27, Eric Nelson wrote:
> On 07/05/2010 03:10 AM, Chris Simmonds wrote:
>> On 02/07/10 21:47, Eric Nelson wrote:
>>> Does anyone know if there's a common infrastructure for allocation
>>> of DMA'able memory by drivers and applications above the straight
>>> kernel API (dma_alloc_coherent)?
>>>
>>> I'm working with Freescale i.MX51 drivers to do 720P video
>>> input and output and the embedded calls to dma_alloc_coherent
>>> fail except when used right after boot because of fragmentation.
>>>
>>> I'm fighting the urge to write yet another special-purpose allocator
>>> for video buffers thinking this must be a common problem with a
>>> solution already, but I can't seem to locate one.
>>>
>>> The closest thing I've found is the bigphysarea patch, which doesn't
>>> appear to be supported or headed toward main-line.
>>>
>>> Thanks in advance,
>>
>> dma_alloc_coherent is pretty much just a wrapper round get_free_pages,
>> which is the lowest level allocator in the kernel. So, no there is no
>> other option (but see below). The simplest thing is to make sure your
>> driver is loaded at boot time and to grab all the memory you need then
>> and never let it go. That's what I do.
>>
> Thanks Chris.
>
> The trouble is always "how much"? If we don't know at startup what kind of
> video's needed or what size(s) of camera input may be needed, it's
> impossible
> to tune. In the current Freescale kernels, there are at least 4 separate
> drivers that allocate RAM, sometimes for internal use, but mostly in
> response
> to userspace calls (ioctl).
>
> - frame-buffer driver
> - Video Processing Unit (VPU) - video encode/decode
> - V4L2 output device - allows access to YUV output layer, color blending
> - Image Processing Unit (IPU) - allows userspace bitblts through DMA
>
> With this number of calls, tuning with separate kernel command-line args
> seems
> unworkable.

I think the kernel developers don't like this kind of on-the-side 
allocator because they tend to be dedicated to solving one kind of problem.

Here are a few thoughts about the imx51 specifically, based on my 
experience. First, the size of the memory pool used for 
dma_alloc_coherent is set in plat-mxc/include/mach/memory.h where it is 
hard coded to 64 MiB. You could try bumping that up a bit.

Second, you could re-do the buffer allocation and replace 
dma_alloc_coherent with kmalloc and then use dma_map_single to lock it 
down while dma is taking place. This way you avoid the 64M dma pool 
limit and you speed up buffer access via mmap because the memory is 
cached. In my case I got a two fold speed improvement reading frames 
into application memory. I have to admit that my case was a bit 
specialised though and it may not be worth the effort for you.

Bye for now,
Chris.


-- 
Chris Simmonds                   2net Limited
chris@2net.co.uk                 http://www.2net.co.uk/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
