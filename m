Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3404 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965385Ab0COQkm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 12:40:42 -0400
Message-ID: <e1551c2096f8616e8b01344b1af51a51.squirrel@webmail.xs4all.nl>
In-Reply-To: <4B9E5EF1.2000600@redhat.com>
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
    <4B9E1931.8060006@redhat.com>
    <b320a5b9ff16d1df8ecc6272a7fe2c14.squirrel@webmail.xs4all.nl>
    <4B9E5EF1.2000600@redhat.com>
Date: Mon, 15 Mar 2010 17:40:21 +0100
Subject: Re: Magic in videobuf
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: "Pawel Osciak" <p.osciak@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Marek Szyprowski" <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Hans Verkuil wrote:
>>> Hi Pawel,
>>>
>>> Pawel Osciak wrote:
>>>> Hello,
>>>>
>>>> is anyone aware of any other uses for MAGIC_CHECK()s in videobuf code
>>>> besides driver debugging? I intend to remove them, as we weren't able
>>>> to find any particular use for them when we were discussing this at
>>>> the memory handling meeting in Norway...
>>> It is a sort of paranoid check to avoid the risk of mass memory
>>> corruption
>>> if something goes deadly wrong with the video buffers.
>>>
>>> The original videobuf, written back in 2001/2002 had this code, and
>>> I've
>>> kept it on the redesign I did in 2007, since I know that DMA is very
>>> badly
>>> implemented on some chipsets. There are several reports of the video
>>> driver
>>> to corrupt the system memory and damaging the disk data when a PCI
>>> transfer
>>> to disk happens at the same time that a PCI2PCI data transfer happens
>>> (This
>>> basically affects overlay mode, where the hardware is programmed to
>>> transfer
>>> data from the video board to the video adapter board).
>>>
>>> The DMA bug is present on several VIA and SYS old chipsets. It happened
>>> again
>>> in some newer chips (2007?), and the fix were to add a quirk blocking
>>> overlay
>>> mode on the reported broken hardware. It seems that newer BIOSes for
>>> those
>>> newer hardware fixed this issue.
>>>
>>> That's said, I never got any report from anyone explicitly saying that
>>> they
>>> hit the MAGIC_CHECK() logic.
>>>
>>> I prefer to keep this logic, but maybe we can add a CONFIG option to
>>> disable it.
>>> Something like:
>>>
>>> #ifdef CONFIG_VIDEO_DMA_PARANOID_CHECK
>>> 	#define MAGIC_CHECK() ...
>>> #else
>>> 	#define MAGIC_CHECK()
>>> #endif
>>
>> What on earth does this magic check have to do with possible DMA
>> overruns/memory corruption? This assumes that somehow exactly these
>> magic
>> fields are overwritten and that you didn't crash because of memory
>> corruption elsewhere much earlier.
>
> Yes, that's the assumption. As, in general, there are more than one
> videobuffer,
> and assuming that one buffer physical address is close to the other, if
> the data
> got miss-aligned at the DMA, it is likely that the magic number of the
> next buffer
> will be overwritten if something got bad. The real situation will depend
> on how
> fragmented is the memory.

For the record: we are talking about the magic fields as found in
include/media/videobuf*.h. None of the magic field there are actually in
the video buffers. They are in administrative structures or in ops structs
which are unlikely to be close in memory to the actual buffers.

Magic values that are actually put in the buffers themselves might serve
some purpose.

>
>> It pollutes the code
>
> There are only 18 occurences of MAGIC* at a given videobuf driver:
> 	$ grep MAGIC ~v4l/master_hg/v4l/videobuf-dma-sg.c |wc -l
> 	18
>
> So, I don't think it is too much pollution.

It is, because it is absolute not clear what its purpose is, and in this
case  even when I know the purpose it still makes no sense. Code like that
confuses people and does more harm than good.

>
>> for no good
>> reason. All it does is oops anyway, so it really doesn't 'avoid' a crash
>> (as if you could in such scenarios). And most likely the damage has been
>> done already in that case.
>
> It won't avoid the damage, but the error message could potentially help
> to track the issue. It will also likely limit the damage.
>
>> Please let us get rid of this. It makes no sense whatsoever.
>
> I don't have a strong opinion about this subject, but if this code might
> help
> to avoid propagating the damage and to track the issue, I don't see why we
> need to remove it, especially since it is easy to disable the entire logic
> by just adding a few #if's to remove this code on environments where no
> problem is expected.

It is highly unlikely that this code ever prevented these issues.
Especially given the places where the check is done. I think this is just
debug code that has been dragged along for all these years without anyone
bothering to remove it.

Regards,

         Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

