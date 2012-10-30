Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64041 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2J3Gnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 02:43:51 -0400
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MCP006NO1DMG500@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Oct 2012 06:44:10 +0000 (GMT)
Received: from [127.0.0.1] ([106.116.48.193])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MCP00F8J1CV9M20@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Tue, 30 Oct 2012 06:43:49 +0000 (GMT)
Message-id: <508F7720.5080606@samsung.com>
Date: Tue, 30 Oct 2012 07:43:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Pawel Osciak <pawel@osciak.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, kyungmin.park@samsung.com,
	laurent.pinchart@ideasonboard.com, sumit.semwal@ti.com,
	daeinki@gmail.com, daniel.vetter@ffwll.ch, robdclark@gmail.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	zhangfei.gao@gmail.com, s.nawrocki@samsung.com,
	k.debski@samsung.com
Subject: Re: [PATCHv10 08/26] v4l: vb2-dma-contig: add support for scatterlist
 in userptr mode
References: <1349880405-26049-1-git-send-email-t.stanislaws@samsung.com>
 <1349880405-26049-9-git-send-email-t.stanislaws@samsung.com>
 <CAMm-=zB9-WJ5b6Xku1UwvG4UZOGQ_V6pKFT4C_Xf0kF-O+VDdw@mail.gmail.com>
In-reply-to: <CAMm-=zB9-WJ5b6Xku1UwvG4UZOGQ_V6pKFT4C_Xf0kF-O+VDdw@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-2; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 10/26/2012 6:24 PM, Pawel Osciak wrote:
> Hi Tomasz,
>
> On Wed, Oct 10, 2012 at 7:46 AM, Tomasz Stanislawski
> <t.stanislaws@samsung.com> wrote:
>> This patch introduces usage of dma_map_sg to map memory behind
>> a userspace pointer to a device as dma-contiguous mapping.
>>
>
> Perhaps I'm missing something, but I don't understand the purpose of
> this patch. If the device can do DMA SG, why use videobuf2-dma-contig
> and not videobuf2-dma-sg?

This patch is for devices which doesn't do DMA SG, but might be behind 
IOMMU. In such case one can call dma_map_sg() with scatterlist of 
individual pages gathered from user pointer (anonymous memory of the 
process) which in turn will be mapped into contiguous dma adress space 
(dma_map_sg() returns only one chunk in such case). This is not very 
intuitive, but it was best way to fit such case into existing 
dma-mapping design.

> What would be the difference design-wise
> between them if this patch is merged?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

