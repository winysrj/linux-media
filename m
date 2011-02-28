Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34658 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab1B1Ppw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 10:45:52 -0500
Message-ID: <4D6BC32C.70408@suse.cz>
Date: Mon, 28 Feb 2011 16:45:48 +0100
From: Jiri Slaby <jslaby@suse.cz>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: mchehab@infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, jirislaby@gmail.com,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v2 -resend#1 1/1] V4L: videobuf, don't use dma addr as
 physical
References: <1298885822-10083-1-git-send-email-jslaby@suse.cz> <201102281153.30585.laurent.pinchart@ideasonboard.com> <4D6BBA3F.2000205@suse.cz> <201102281615.02193.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102281615.02193.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 02/28/2011 04:14 PM, Laurent Pinchart wrote:
> Hi Jiri,
> 
> On Monday 28 February 2011 16:07:43 Jiri Slaby wrote:
>> On 02/28/2011 11:53 AM, Laurent Pinchart wrote:
>>> On Monday 28 February 2011 10:37:02 Jiri Slaby wrote:
>>>> mem->dma_handle is a dma address obtained by dma_alloc_coherent which
>>>> needn't be a physical address in presence of IOMMU. So ensure we are
>>>> remapping (remap_pfn_range) the right page in __videobuf_mmap_mapper
>>>> by using virt_to_phys(mem->vaddr) and not mem->dma_handle.
>>>
>>> Quoting arch/arm/include/asm/memory.h,
>>>
>>> /*
>>>
>>>  * These are *only* valid on the kernel direct mapped RAM memory.
>>
>> Which the DMA allocation shall be.
>>
>>>  * Note: Drivers should NOT use these.
>>
>> This is weird.
>>
>>> They are the wrong
>>>
>>>  * translation for translating DMA addresses.  Use the driver
>>>  * DMA support - see dma-mapping.h.
>>
>> Yes, ACK, and vice versa. DMA addresses cannot be used as physical ones.
>>
>>>  */
>>>
>>> static inline unsigned long virt_to_phys(const volatile void *x)
>>> {
>>>
>>>         return __virt_to_phys((unsigned long)(x));
>>>
>>> }
>>>
>>> Why would you use physically contiguous memory if you have an IOMMU
>>> anyway ?
>>
>> Sorry, what? When IOMMU is used, dma_alloc_* functions may return "tags"
>> as a DMA address, not a physical address. So using these DMA "addresses"
>> directly (e.g. in remap_pfn_range) is a bug.
> 
> What I mean is that videobuf-dma-contig is meant to be used by drivers that 
> require physically contiguous memory. If the system has an IOMMU, why would 
> drivers need that ?

Aha. They actually need not but they would need do the mapping
themselves which they currently do not.

IOW the vbuf-dma-contig allocator is used unconditionally in the few
drivers I checked.

BUT Even if they need only one page and use vbuf-dma-contig, which I
don't see a reason not to, it will cause problems too.

regards,
-- 
js
suse labs
