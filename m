Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52819 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924Ab2LROmL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Dec 2012 09:42:11 -0500
Message-id: <50D080B6.1020109@samsung.com>
Date: Tue, 18 Dec 2012 15:41:58 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Federico Vaga <federico.vaga@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	'Mauro Carvalho Chehab' <mchehab@infradead.org>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>,
	'Giancarlo Asnaghi' <giancarlo.asnaghi@st.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	'Jonathan Corbet' <corbet@lwn.net>,
	sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 2/4] videobuf2-dma-streaming: new videobuf2 memory
 allocator
References: <1348484332-8106-1-git-send-email-federico.vaga@gmail.com>
 <1685240.Ttn3DTWMJc@harkonnen> <50BF5950.2040805@redhat.com>
 <1535483.0HokefWAdm@harkonnen>
In-reply-to: <1535483.0HokefWAdm@harkonnen>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm sorry for the delay, I've been terribly busy recently.

On 12/11/2012 2:54 PM, Federico Vaga wrote:

>> > This allocator is needed because some device (like STA2X11 VIP) cannot
>> > work
>> > with DMA sg or DMA coherent. Some other device (like the one used by
>> > Jonathan when he proposes vb2-dma-nc allocator) can obtain much better
>> > performance with DMA streaming than coherent.
>>
>> Ok, please add such explanations at the patch's descriptions, as it is
>> important not only for me, but to others that may need to use it..
>
> OK
>
>> >> 	2) why vb2-dma-config can't be patched to use dma_map_single
>> >>
>> >> (eventually using a different vb2_io_modes bit?);
>> >
>> > I did not modify vb2-dma-contig because I was thinking that each DMA
>> > memory allocator should reflect a DMA API.
>>
>> The basic reason for having more than one VB low-level handling (vb2 was
>> inspired on this concept) is that some DMA APIs are very different than
>> the other ones (see vmalloc x DMA S/G for example).
>>
>> I didn't make a diff between videobuf2-dma-streaming and
>> videobuf2-dma-contig, so I can't tell if it makes sense to merge them or
>> not, but the above argument seems too weak. I was expecting for a technical
>> reason why it wouldn't make sense for merging them.
>
> I cannot work on this now. But I think that I can do an integration like the
> one that I pushed some month ago (a8f3c203e19b702fa5e8e83a9b6fb3c5a6d1cce4).
> Wind River made that changes to videobuf-contig and I tested, fixed and
> pushed.
>
>> >> 	3) what are the usecases for it.
>> >>
>> >> Could you please detail it? Without that, one that would be needing to
>> >> write a driver will have serious doubts about what would be the right
>> >> driver for its usage. Also, please document it at the driver itself.
>
> I don't have a full understand of the board so I don't know exactly why
> dma_alloc_coherent does not work. I focused my development on previous work by
> Wind River. I asked to Wind River (which did all the work on this board) for
> the technical explanation about why coherent doesn't work, but they do not
> know. That's why I made the new allocator: coherent doesn't work and HW
> doesn't support SG.

Ok, now I see the whole image. I was convinced that this so called 
streaming allocator is required for performance reasons, not because of 
the broken platform support for coherent calls.

My ultimate goal is to have support for both non-cached (coherent) and 
cached (non-coherent) buffers in the dma mapping subsystem on top of the 
common API. Then both types of buffers will be easily supported by 
dma-contig vb2 allocator. Currently support for streaming-style buffers 
requires completely different dma mapping calls, although from the 
device driver point of view the buffers behaves similarly, so 
implementing them as a separate allocator seems to be the best idea.

I can take a look at the dma coherent issues with that board, but I will 
need some help as I don't have this hardware.

>> I'm not a DMA performance expert. As such, from that comment, it sounded to
>> me that replacing dma-config/dma-sg by dma streaming will always give
>> "performance optimizations the hardware allow".
>
> me too, I'm not a DMA performance expert. I'm just an user of the DMA API. On
> my hardware simply it works only with that interface, it is not a performance
> problem.
>
>> On a separate but related issue, while doing DMABUF tests with an Exynos4
>> hardware, using a s5p sensor, sending data to s5p-tv, I noticed a CPU
>> consumption of about 42%, which seems too high. Could it be related to
>> not using the DMA streaming API?

This might be related to the excessive cpu cache flushing on dma buf 
buffers as there were some misunderstanding who is responsible of that 
(I saw some strange code in drm, but it has been changed a few times). I 
will add this issue to my todo list.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

