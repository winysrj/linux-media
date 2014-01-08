Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:13935 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaAHOHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Jan 2014 09:07:49 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ3000PB5WXZE20@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Jan 2014 14:07:45 +0000 (GMT)
Message-id: <52CD5BB2.2080305@samsung.com>
Date: Wed, 08 Jan 2014 15:07:46 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Pawel Osciak <pawel@osciak.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-media <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v4 2/2] videobuf2-dma-sg: Replace vb2_dma_sg_desc with
 sg_table
References: <1375453200-28459-1-git-send-email-ricardo.ribalda@gmail.com>
 <1375453200-28459-3-git-send-email-ricardo.ribalda@gmail.com>
 <52C6CEC6.8020602@xs4all.nl>
 <CAPybu_1ABrgBGYNicL37cBE_A2-eYq4=7Cwa-nfEJWndVqq2EQ@mail.gmail.com>
 <52C6D90D.9010906@xs4all.nl>
 <CAPybu_2NAyE+Os9NJSSRY0n1+6ObWYpfH1m9Nj0c+B-xj+KVYg@mail.gmail.com>
In-reply-to: <CAPybu_2NAyE+Os9NJSSRY0n1+6ObWYpfH1m9Nj0c+B-xj+KVYg@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello All,

On 2014-01-03 16:51, Ricardo Ribalda Delgado wrote:
> Hello Hans
>
> What if we move the dma_map_sg and dma_unmap_sg to the vb2 interface,
> and there do something like:
>
> n_sg= dma_map_sg()
> if (n_sg=-ENOMEM){
>     split_table() //Breaks down the sg_table into monopages sg
>     n_sg= dma_map_sg()
> }
> if (n_sg=-ENOMEM)
>    return -ENOMEM

dma_map_sg/dma_unmap_sg should be moved to vb2-dma-sg memory allocator. 
The best place for calling them is buf_prepare() and buf_finish() 
callbacks. I think that I've already pointed this some time ago, but 
unfortunately I didn't find enough time to convert existing code.

For solving the problem described by Hans, I think that vb2-dma-sg 
memory allocator should check dma mask of the client device and add 
appropriate GFP_DMA or GFP_DMA32 flags to alloc_pages(). This should fix 
the issues with failed dma_map_sg due to lack of bouncing buffers.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

