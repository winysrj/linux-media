Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36752 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0CQGwU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 02:52:20 -0400
Received: from eu_spt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0KZE00KCOZ36P6@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 06:52:18 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0KZE005JGZ32IU@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 17 Mar 2010 06:52:18 +0000 (GMT)
Date: Wed, 17 Mar 2010 07:50:27 +0100
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: Magic in videobuf
In-reply-to: <37db8fe3121673cfbdce84e1de5ee844.squirrel@webmail.xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Andy Walls' <awalls@radix.net>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com
Message-id: <000d01cac59e$20c1b1f0$624515d0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <E4D3F24EA6C9E54F817833EAE0D912AC09C7FCA3BF@bssrvexch01.BS.local>
 <4B9E1931.8060006@redhat.com>
 <b320a5b9ff16d1df8ecc6272a7fe2c14.squirrel@webmail.xs4all.nl>
 <4B9E5EF1.2000600@redhat.com>
 <e1551c2096f8616e8b01344b1af51a51.squirrel@webmail.xs4all.nl>
 <4B9E6DC4.5010301@redhat.com> <1268695849.3081.16.camel@palomino.walls.org>
 <000e01cac4f1$50b1ea40$f215bec0$%osciak@samsung.com>
 <37db8fe3121673cfbdce84e1de5ee844.squirrel@webmail.xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Hans Verkuil wrote:
>>>Andy Walls wrote:
>>>On Mon, 2010-03-15 at 14:26 -0300, Mauro Carvalho Chehab wrote:
>>>> Hans Verkuil wrote:
>>>> >> Hans Verkuil wrote:
>>>> >>>> Pawel Osciak wrote:
>>>
>>>> >>>>> is anyone aware of any other uses for MAGIC_CHECK()s in videobuf
>>>> code
>>>> >>>>> besides driver debugging? I intend to remove them, as we weren't
>>>> able
>>>> >>>>> to find any particular use for them when we were discussing this
>>>> at
>>>> >>>>> the memory handling meeting in Norway...
>>>> >>>> It is a sort of paranoid check to avoid the risk of mass memory
>>>> >>>> corruption
>>>> >>>> if something goes deadly wrong with the video buffers.
>>>> >>>>
>>>
>>>> >>> What on earth does this magic check have to do with possible DMA
>>>> >>> overruns/memory corruption? This assumes that somehow exactly these
>>>> >>> magic
>>>> >>> fields are overwritten and that you didn't crash because of memory
>>>> >>> corruption elsewhere much earlier.
>>>
>>>>  All it does is oops anyway, so it really doesn't 'avoid' a crash
>>>> >>> (as if you could in such scenarios). And most likely the damage has
>>>> been
>>>> >>> done already in that case.
>>>> >> It won't avoid the damage, but the error message could potentially
>>>> help
>>>> >> to track the issue. It will also likely limit the damage.
>>>> >>
>>>> >>> Please let us get rid of this. It makes no sense whatsoever.
>>>> >> I don't have a strong opinion about this subject, but if this code
>>>> might
>>>> >> help
>>>> >> to avoid propagating the damage and to track the issue, I don't see
>>>> why we
>>>> >> need to remove it, especially since it is easy to disable the entire
>>>> logic
>>>> >> by just adding a few #if's to remove this code on environments where
>>>> no
>>>> >> problem is expected.
>>>> >
>>>> > It is highly unlikely that this code ever prevented these issues.
>>>> > Especially given the places where the check is done. I think this is
>>>> just
>>>> > debug code that has been dragged along for all these years without
>>>> anyone
>>>> > bothering to remove it.
>>>
>>>> I remember I had to re-format one disk, during that time, due to a
>>>> videobuf issue.
>>>> So, those checks help people that are touching at the videobuf code,
>>>> reducing the
>>>> chances of damaging their disk partitions when trying to implement
>>>> overlay mode and
>>>> userptr on the videobuf implementations that misses those features, or
>>>> when
>>>> working on a different mmap() logic at the driver.
>>>
>>>
>>>In a previous job, working on a particularly large application, I had
>>>occasional corruption in a shared memory segment that was shared by many
>>>writer processes and 2 readers.  A simple checksum on the data header
>>>(and contents if appropriate) was enough to detect corrpution and avoid
>>>dereferencing a corrupted pointer to the next data element (when walking
>>>a data area filled with Key-Length-Value encoded data).
>>>
>>>This "forward error detection" was inelegant to me - kind of like
>>>putting armor on one's car instead of learning to drive properly.  I
>>>only resorted to using the checksum because there was almost no way to
>>>find which process was corrupting shared memory in a reasonable amount
>>>of time.  It allowed me to change a "show stopper" bug into an annoying
>>>data presentation bug, so the product could be released to a production
>>>environment.
>>>
>>>In a development environment, it would be much better to disable such
>>>defensive coding and let the kernel Oops.  You'll never find the
>>>problems if you keep hiding them from yourself.
>>
>> So, to sum up (I hope I understood you guys correctly):
>>
>> we are not seeing any particular reason (besides debugging) for having
>> the checks in videobuf-core. Checks in memory-specific handling may have
>> some
>> uses, although I am not sure how much. I am not an expert on sg drivers,
>> but as
>> the magics are in the kernel control structures, they are not really a
>> subject
>> to corruption. What may get corrupted is video data or sg lists, but the
>> magics
>> are in a separate memory areas anyway. So videobuf-core magics should be
>> removed
>> and we are leaning towards removing memory-type magics as well?
>
>That is my opinion, yes. However, there is one case where this is actually
>useful. Take for example the function videobuf_to_dma in
>videobuf-dma-sg.c. This is called by drivers and it makes sense that that
>function should double-check that the videobuf_buffer is associated with
>the dma_sg memtype.
>
>But calling this 'magic' is a poor choice of name. There is nothing magic
>about it, in this case it is just an identifier of the memtype. And there
>may be better ways to do this check anyway.
>
>I have not done any analysis, but might be enough to check whether the
>int_ops field of videobuf_queue equals the sg_ops pointer. If so, then the
>whole magic handling can go away in this case.


Well... I see this discussion is dragging on a bit.
I will not be touching magics for now then, at least not until we arrive at
a consensus sometime in the future.


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



