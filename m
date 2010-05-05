Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0EEXwt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 May 2010 19:52:49 -0400
Message-ID: <4BE204CC.6080406@redhat.com>
Date: Wed, 05 May 2010 20:52:44 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: "Aguirre, Sergio" <saaguirre@ti.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [videobuf] Query: Condition bytesize limit in videobuf_reqbufs
 -> buf_setup() call?
References: <A24693684029E5489D1D202277BE894455257D13@dlee02.ent.ti.com> <4BE1FE22.8000909@redhat.com> <A24693684029E5489D1D202277BE894455257ED2@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE894455257ED2@dlee02.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Aguirre, Sergio wrote:
> 
>> -----Original Message-----
>> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
>> Sent: Wednesday, May 05, 2010 6:24 PM
>> To: Aguirre, Sergio
>> Cc: linux-media@vger.kernel.org
>> Subject: Re: [videobuf] Query: Condition bytesize limit in
>> videobuf_reqbufs -> buf_setup() call?
>>
>> Aguirre, Sergio wrote:
>>> Hi all,
>>>
>>> While working on an old port of the omap3 camera-isp driver,
>>> I have faced some problem.
>>>
>>> Basically, when calling VIDIOC_REQBUFS with a certain buffer
>>> Count, we had a software limit for total size, calculated depending on:
>>>
>>>   Total bytesize = bytesperline x height x count
>>>
>>> So, we had an arbitrary limit to, say 32 MB, which was generic.
>>>
>>> Now, we want to condition it ONLY when MMAP buffers will be used.
>>> Meaning, we don't want to keep that policy when the kernel is not
>>> allocating the space
>>>
>>> But the thing is that, according to videobuf documentation, buf_setup is
>>> the one who should put a RAM usage limit. BUT the memory type passed to
>>> reqbufs is not propagated to buf_setup, therefore forcing me to go to a
>>> non-standard memory limitation in my reqbufs callback function, instead
>>> of doing it properly inside buf_setup.
>>>
>>> Is this scenario a good consideration to change buf_setup API, and
>>> propagate buffers memory type aswell?
>> I don't see any problem on propagating the memory type to buffer_setup, if
>> this is really needed. Yet, I can't see why you would restrict the buffer
>> size to 32 MB on one case, and not restrict the size at all with non-MMAP
>> types.
> 
> Ok, my reason for doing that is because I thought that there should be a memory limit in whichever place you're doing the buffer allocations.
> 
> MMAP is allocating buffers in kernel, so kernel should provide a memory restriction, if applies.
> 
> USERPTR is allocating buffers in userspace, so userspace should provide a memory restriction, if applies.
> 
> Please correct me if my reasoning is not correct.
>

Your rationale makes some sense.

For the effects of the remaining discussion, let's forget about videobuf-vmalloc,
as I'm assuming your troubles are with a driver using videobuf-contig 
or videobuf-dma_sg.

With all memory types, kernel will need to command DMA transfers to those 
buffers. It still keeps sense to have a restriction on kernelspace, 
to avoid, for example, the risk of  userspace to fill all DMA capable 
memory with video buffers, preventing its usage by other subsystems 
(usb, disk, net, etc). So, such limit should still be enforced in kernel, 
otherwise, you may open an space for DoS attacks.

The limit between read(), MMAP, USERPTR and OVERLAY might eventually be different, but
I can't see why you might want to put different limits for each case, as the resource
that this check is protecting is the DMA-capable memory area. No matter how you're allocating
it, you'll need to enforce the same degree of protection.

-- 

Cheers,
Mauro
