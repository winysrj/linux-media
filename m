Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:23066 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964856Ab1GOGSs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 02:18:48 -0400
Received: from spt2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LOD00LFH2VBI2@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jul 2011 07:18:47 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LOD008V12VAJ6@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 15 Jul 2011 07:18:46 +0100 (BST)
Date: Fri, 15 Jul 2011 08:18:03 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] videobuf2: Do not unconditionally map S/G buffers into
 kernel space
In-reply-to: <20110714151044.44cb89ee@bike.lwn.net>
To: 'Jonathan Corbet' <corbet@lwn.net>, linux-media@vger.kernel.org,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Message-id: <000201cc42b6$f3ef9e70$dbcedb50$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-language: pl
Content-transfer-encoding: 7BIT
References: <20110714151044.44cb89ee@bike.lwn.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Thursday, July 14, 2011 11:11 PM Jonathan Corbet wrote:

> The one in-tree videobuf2-dma-sg driver (mmp-camera) has no need for a
> kernel-space mapping of the buffers; one suspects that most other drivers
> would not either.  The videobuf2-dma-sg module does the right thing if
> buf->vaddr == NULL - it maps the buffer on demand if somebody needs it.  So
> let's not map the buffer at allocation time; that will save a little CPU
> time and a lot of address space in the vmalloc range.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>  drivers/media/video/videobuf2-dma-sg.c |    6 ------
>  1 files changed, 0 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-dma-sg.c
> b/drivers/media/video/videobuf2-dma-sg.c
> index b2d9485..0e8edc1 100644
> --- a/drivers/media/video/videobuf2-dma-sg.c
> +++ b/drivers/media/video/videobuf2-dma-sg.c
> @@ -77,12 +77,6 @@ static void *vb2_dma_sg_alloc(void *alloc_ctx, unsigned
> long size)
> 
>  	printk(KERN_DEBUG "%s: Allocated buffer of %d pages\n",
>  		__func__, buf->sg_desc.num_pages);
> -
> -	if (!buf->vaddr)
> -		buf->vaddr = vm_map_ram(buf->pages,
> -					buf->sg_desc.num_pages,
> -					-1,
> -					PAGE_KERNEL);
>  	return buf;
> 
>  fail_pages_alloc:
> --
> 1.7.6

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


