Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33865 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966338Ab0CPPA0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Mar 2010 11:00:26 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0KZD0064YR0OMB60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Mar 2010 15:00:24 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZD00D2XR0N0T@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 16 Mar 2010 15:00:24 +0000 (GMT)
Date: Tue, 16 Mar 2010 15:58:36 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Magic in videobuf
In-reply-to: <4B9E6DC4.5010301@redhat.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <001a01cac519$27e2cdf0$77a869d0$%osciak@samsung.com>
Content-language: pl
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
 <4B9E1931.8060006@redhat.com>
 <b320a5b9ff16d1df8ecc6272a7fe2c14.squirrel@webmail.xs4all.nl>
 <4B9E5EF1.2000600@redhat.com>
 <e1551c2096f8616e8b01344b1af51a51.squirrel@webmail.xs4all.nl>
 <4B9E6DC4.5010301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Mauro Carvalho Chehab wrote:
>>>>>> is anyone aware of any other uses for MAGIC_CHECK()s in videobuf code
>>>>>> besides driver debugging? I intend to remove them, as we weren't able
>>>>>> to find any particular use for them when we were discussing this at
>>>>>> the memory handling meeting in Norway...
>>>>> It is a sort of paranoid check to avoid the risk of mass memory
>>>>> corruption
>>>>> if something goes deadly wrong with the video buffers.
>>>>>
>>>>> The original videobuf, written back in 2001/2002 had this code, and
>>>>> I've
>>>>> kept it on the redesign I did in 2007, since I know that DMA is very
>>>>> badly
>>>>> implemented on some chipsets. There are several reports of the video
>>>>> driver
>>>>> to corrupt the system memory and damaging the disk data when a PCI
>>>>> transfer
>>>>> to disk happens at the same time that a PCI2PCI data transfer happens
>>>>> (This
>>>>> basically affects overlay mode, where the hardware is programmed to
>>>>> transfer
>>>>> data from the video board to the video adapter board).
>>>>>
>>>>> The DMA bug is present on several VIA and SYS old chipsets. It happened
>>>>> again
>>>>> in some newer chips (2007?), and the fix were to add a quirk blocking
>>>>> overlay
>>>>> mode on the reported broken hardware. It seems that newer BIOSes for
>>>>> those
>>>>> newer hardware fixed this issue.
>>>>>
>>>>> That's said, I never got any report from anyone explicitly saying that
>>>>> they
>>>>> hit the MAGIC_CHECK() logic.
>>>>>
>>>>> I prefer to keep this logic, but maybe we can add a CONFIG option to
>>>>> disable it.
>>>>> Something like:
>>>>>
>>>>> #ifdef CONFIG_VIDEO_DMA_PARANOID_CHECK
>>>>> 	#define MAGIC_CHECK() ...
>>>>> #else
>>>>> 	#define MAGIC_CHECK()
>>>>> #endif
>>>> What on earth does this magic check have to do with possible DMA
>>>> overruns/memory corruption? This assumes that somehow exactly these
>>>> magic
>>>> fields are overwritten and that you didn't crash because of memory
>>>> corruption elsewhere much earlier.
>>> Yes, that's the assumption. As, in general, there are more than one
>>> videobuffer,
>>> and assuming that one buffer physical address is close to the other, if
>>> the data
>>> got miss-aligned at the DMA, it is likely that the magic number of the
>>> next buffer
>>> will be overwritten if something got bad. The real situation will depend
>>> on how
>>> fragmented is the memory.
>>
>> For the record: we are talking about the magic fields as found in
>> include/media/videobuf*.h. None of the magic field there are actually in
>> the video buffers. They are in administrative structures or in ops structs
>> which are unlikely to be close in memory to the actual buffers.
>
>Well, Pawel's email didn't mentioned that he is referring just to one type
>of magic check.

Thanks for the explanation. Although I don't really understand how any of
the magic numbers would help with DMA corruption, short of DMA operations
overwriting random memory areas (or just huge amounts of memory). If I understood
correctly, even the magics in dma-sg code are in structs videobuf_dmabuf and
videobuf_dma_sg_memory. Do dma operations touch those structures directly?


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



