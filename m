Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:19450 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3CHMO4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Mar 2013 07:14:56 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MJC001NUCOTE370@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Mar 2013 12:14:54 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.147.30])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MJC008A1COTEW70@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 08 Mar 2013 12:14:54 +0000 (GMT)
Message-id: <5139D63D.4040205@samsung.com>
Date: Fri, 08 Mar 2013 13:14:53 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Federico Vaga <federico.vaga@gmail.com>
Subject: Re: [REVIEW PATCH 0/2] Add gfp_flags + silence vb2-dma-sg
References: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1362734517-9420-1-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 3/8/2013 10:21 AM, Hans Verkuil wrote:
> This patch series makes two modifications to videobuf2: the first adds the
> gfp_flags field allowing us to easily convert drivers that need GFP_DMA or
> __GFP_DMA32 to vb2. The stops the vb2-dma-sg module from logging every time
> buffers are allocating or released. Instead add a debug option.
>
> Marek, I understood from our earlier discussion that you are OK with doing
> it this way for now. If you can Ack this, then that would be great as that
> allows me to make a pull request for my solo driver changes.

I'm fine now. I hope I will manage to find some free time to finish dma-sg
allocator code cleanup, but this will definitely not happen till the next
merge window.

> One question: I'm OR-ing gfp_flags for dma-contig and dma-sg, but also in
> vmalloc. I'm not sure about the last one. I did it for consistency, but it
> is pretty useless, so if you think it is better to drop the vmalloc change,
> then that's no problem. Your call.

Let's leave it as is for better consistency.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


