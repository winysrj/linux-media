Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:39507 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758556AbcAKKcN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 05:32:13 -0500
Subject: Re: PCIe sg dma device used as dma-contig
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMh+0-2nmbWxeEHV-V6hkXFYXm-2L5mzHT3+v0WSUMpRd1g@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <569384A8.1000302@xs4all.nl>
Date: Mon, 11 Jan 2016 11:32:08 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh+0-2nmbWxeEHV-V6hkXFYXm-2L5mzHT3+v0WSUMpRd1g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/27/2015 04:31 PM, Ran Shalit wrote:
> Hello,
> 
> The following question is not totally in the scope of v4l2, but more
> about your advise concering dma alternatives for non-expreciened v4l2
> device writer.
> We intend to use the fpga for concurrent 3xHD and 3xSD.
> 
> We have some dillema regadring the fpga to choose from:
> ALTERA fpga which use contiguous dma memory, or Xilinx fpga which is
> using scatter-gather architecture.
> 
> With xilinx, it seems that the sg architecture can also be used as
> contiguous according to the following:
> "... While these descriptors are not required to be contiguous, they
> should be contained within an 8 megabyte region which corresponds to
> the width of the AXI_PCIe_SG port"

I think they are talking about the memory containing the descriptors
themselves. I.e. the scatter-gather list should be in contiguous memory
that is no more than 8 megabytes long.

This is normally not a problem.

I don't think they are talking about the DMA itself, that should be
pretty much unlimited.

Regards,

	Hans

> it seems according to the above description that sg-list can be used
> as single contiguous descriptor (with dma-cotig), though the 8MBytes
> seems like a problematic constrain. This constrain make it difficult
> to be used with dma-contig solution in v4l2.
> 
> Our current direction is try to imeplement it as simple as possible.
> Therefore we prefer the dma contiguous solution (I think that together
> with CMA and a strong cpu like 64-bit i7 it can handle contigious
> memory for 3xHD and 3xSD allocation).
> 
> Any feedback is appreciated,
> Ran
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

