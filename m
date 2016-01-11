Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34022 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609AbcAKLJM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 06:09:12 -0500
Received: by mail-ig0-f178.google.com with SMTP id ik10so119903437igb.1
        for <linux-media@vger.kernel.org>; Mon, 11 Jan 2016 03:09:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <569384A8.1000302@xs4all.nl>
References: <CAJ2oMh+0-2nmbWxeEHV-V6hkXFYXm-2L5mzHT3+v0WSUMpRd1g@mail.gmail.com>
	<569384A8.1000302@xs4all.nl>
Date: Mon, 11 Jan 2016 13:09:11 +0200
Message-ID: <CAJ2oMhLJMm3i0wfNva1jFd0RXPLkz67AW=oaHZ0jdbZZ+sn8dA@mail.gmail.com>
Subject: Re: PCIe sg dma device used as dma-contig
From: Ran Shalit <ranshalit@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 12:32 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/27/2015 04:31 PM, Ran Shalit wrote:
>> Hello,
>>
>> The following question is not totally in the scope of v4l2, but more
>> about your advise concering dma alternatives for non-expreciened v4l2
>> device writer.
>> We intend to use the fpga for concurrent 3xHD and 3xSD.
>>
>> We have some dillema regadring the fpga to choose from:
>> ALTERA fpga which use contiguous dma memory, or Xilinx fpga which is
>> using scatter-gather architecture.
>>
>> With xilinx, it seems that the sg architecture can also be used as
>> contiguous according to the following:
>> "... While these descriptors are not required to be contiguous, they
>> should be contained within an 8 megabyte region which corresponds to
>> the width of the AXI_PCIe_SG port"
>
> I think they are talking about the memory containing the descriptors
> themselves. I.e. the scatter-gather list should be in contiguous memory
> that is no more than 8 megabytes long.
>
> This is normally not a problem.
>
> I don't think they are talking about the DMA itself, that should be
> pretty much unlimited.

Hi,
I've made simple kernel testing on my x86_64 platform, with using
    dma_alloc_coherent(NULL, (1024*1024*4), &dma_addr, GFP_KERNEL);
I can allocate easily 6 contiguous 4MB with the above.
As you said, there is probably no problem with 4MB  for video capture,
(16 bit representation of 1920x1080 gives: 1920x1080x2 <4MB),
I probably don't need to use CMA too.

Thank you,
Ran




>
> Regards,
>
>         Hans
>
>> it seems according to the above description that sg-list can be used
>> as single contiguous descriptor (with dma-cotig), though the 8MBytes
>> seems like a problematic constrain. This constrain make it difficult
>> to be used with dma-contig solution in v4l2.
>>
>> Our current direction is try to imeplement it as simple as possible.
>> Therefore we prefer the dma contiguous solution (I think that together
>> with CMA and a strong cpu like 64-bit i7 it can handle contigious
>> memory for 3xHD and 3xSD allocation).
>>
>> Any feedback is appreciated,
>> Ran
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
