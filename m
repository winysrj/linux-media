Return-path: <mchehab@pedra>
Received: from mailrelay.signet.nl ([217.21.241.31]:42686 "EHLO
	mailrelay.signet.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1BJKBz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Feb 2011 05:01:55 -0500
Message-ID: <4D539D0E.2080102@siliconhive.com>
Date: Thu, 10 Feb 2011 00:08:46 -0800
From: Jozef Kruger <jozef.kruger@siliconhive.com>
MIME-Version: 1.0
To: "Gao, Bin" <bin.gao@intel.com>
CC: "Wang, Wen W" <wen.w.wang@intel.com>,
	"Kanigeri, Hari K" <hari.k.kanigeri@intel.com>,
	"Iyer, Sundar" <sundar.iyer@intel.com>,
	"Yang, Jianwei" <jianwei.yang@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"umg-meego-handset-kernel@umglistsvr.jf.intel.com"
	<umg-meego-handset-kernel@umglistsvr.jf.intel.com>
Subject: Re: Memory allocation in Video4Linux
References: <D5AB6E638E5A3E4B8F4406B113A5A19A32F923C4@shsmsx501.ccr.corp.intel.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923D8@shsmsx501.ccr.corp.intel.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A32F923DC@shsmsx501.ccr.corp.intel.com>	<C039722627B15F489AB215B00C0A3E6608B074BC74@bgsmsx501.gar.corp.intel.com>	<A787B2DEAF88474996451E847A0AFAB7F264B7A4@rrsmsx508.amr.corp.intel.com> <D5AB6E638E5A3E4B8F4406B113A5A19A32F92445@shsmsx501.ccr.corp.intel.com> <06F569D088CFBC4497658761DA003E13015636076A@rrsmsx505.amr.corp.intel.com>
In-Reply-To: <06F569D088CFBC4497658761DA003E13015636076A@rrsmsx505.amr.corp.intel.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Bin,

the ISP in Medfield has it's own MMU. This needs to be programmed.

So in fact we have 2 problems:
1. how to allocate large memory address space (allocating pages is not
the problem).
2. if we re-use OS functionality for this, we need to keep the ISP MMU
up to date.
This means it needs to be programmed with the L1 page table base address
and the
TLB needs to be flushed whenever something changes in the page tables.

I don't think you need any ISP specific documentation for this. The ISP
MMU behaves the
same as the IA MMU does.

Best regards,
Jozef

On 02/09/2011 11:59 PM, Gao, Bin wrote:
> Penwell has IOMMU feature?
> As far as I know only part of Intel server processors have this feature which is designed originally for VT(virtualization technology).
>
> Wen,
> Can you refer to other ISP Soc drivers and see how they are dealing with this issue?
> I don't understand why you need to manage MMU inside ISP, I think the real problem is how can we allocate a large number of memory pages from IA side where ISP can access to by DMA.
> Any ISP document can be shared to help us understand what's the problem?
>
> -Bin
>
> -----Original Message-----
> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On Behalf Of Wang, Wen W
> Sent: Tuesday, February 08, 2011 11:27 PM
> To: Kanigeri, Hari K; Iyer, Sundar; Yang, Jianwei; linux-media@vger.kernel.org; umg-meego-handset-kernel@umglistsvr.jf.intel.com
> Cc: Jozef Kruger
> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in Video4Linux
>
> Hi Hari,
>
> You are right. What we need is virtual address.
>
> Currently we alloc pages (alloc_pages()) for any request. Store those pages for an image buffer into a list. We also manage the virtual address for ISP by ourself (the range from 0 to 4GB) and the page table for our MMU which is independent to system MMU page table.
>
> Thanks
> Wen
>
>> -----Original Message-----
>> From: Kanigeri, Hari K
>> Sent: 2011Äê2ÔÂ9ÈÕ 15:22
>> To: Iyer, Sundar; Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org;
>> umg-meego-handset-kernel@umglistsvr.jf.intel.com
>> Cc: Jozef Kruger
>> Subject: RE: Memory allocation in Video4Linux
>>
>>
>>
>>> -----Original Message-----
>>> From: umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com
>>> [mailto:umg-meego-handset-kernel-bounces@umglistsvr.jf.intel.com] On
>>> Behalf Of Iyer, Sundar
>>> Sent: Wednesday, February 09, 2011 12:20 PM
>>> To: Wang, Wen W; Yang, Jianwei; linux-media@vger.kernel.org; umg-meego-
>>> handset-kernel@umglistsvr.jf.intel.com
>>> Cc: Jozef Kruger
>>> Subject: Re: [Umg-meego-handset-kernel] Memory allocation in
>>> Video4Linux
>>>
>>> I remember some Continous Memory Allocator (CMA) being iterated down a
>>> few versions on
>>> some mailing lists? IIRC, it is also for large buffers and management
>>> for video IPs.
>> I believe CMA is for allocating physically contiguous memory and from what Wen
>> mentioned he also needs virtual memory management, which the IOMMU will
>> provide. Please check the open source discussion on CMA, the last I heard CMA
>> proposal was shot down.
>> Reference: http://www.spinics.net/lists/linux-media/msg26875.html
>>
>> Wen, how are you currently allocating physical memory ?
>>
>>
>> Thank you,
>> Best regards,
>> Hari
> _______________________________________________
> Umg-meego-handset-kernel mailing list
> Umg-meego-handset-kernel@umglistsvr.jf.intel.com
> http://umglistsvr.jf.intel.com/mailman/listinfo/umg-meego-handset-kernel

-- 
Jozef Kruger
Senior Customer Solutions Architect
Silicon Hive Inc.
2025 Gateway Place, Suite 230
San Jose, CA 95110
phone: +1 408 512 2969
cell:  +1 408 644 7533
fax:   +1 408 437 6014
jozef.kruger@siliconhive.com
http://www.siliconhive.com

