Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62147 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1JTN0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Oct 2011 09:26:43 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LTD00H069CHHK60@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Oct 2011 14:26:41 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LTD003YM9CG76@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 20 Oct 2011 14:26:41 +0100 (BST)
Date: Thu, 20 Oct 2011 15:26:40 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH] media: vb2: set buffer length correctly for all buffer
 types
In-reply-to: <1318596869-30027-1-git-send-email-m.szyprowski@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org
Cc: 'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Message-id: <024601cc8f2b$e6ce30a0$b46a91e0$%szyprowski@samsung.com>
Content-language: pl
References: <1318596869-30027-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, October 14, 2011 2:54 PM Marek Szyprowski wrote:

> v4l2_planes[plane].length field was not initialized for userptr buffers.
> This patch fixes this issue.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> ---
>  drivers/media/video/videobuf2-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf2-core.c b/drivers/media/video/videobuf2-core.c
> index d8affb8..5656fdf 100644
> --- a/drivers/media/video/videobuf2-core.c
> +++ b/drivers/media/video/videobuf2-core.c
> @@ -58,7 +58,6 @@ static int __vb2_buf_mem_alloc(struct vb2_buffer *vb)
> 
>  		/* Associate allocator private data with this plane */
>  		vb->planes[plane].mem_priv = mem_priv;
> -		vb->v4l2_planes[plane].length = q->plane_sizes[plane];

After some more testing I've found that removing this assignment causes 
regression for drivers that use buf_init callback. I will resend this patch 
without removal of the above line.

>  	}
> 
>  	return 0;
> @@ -121,6 +120,7 @@ static void __setup_offsets(struct vb2_queue *q)
>  			continue;
> 
>  		for (plane = 0; plane < vb->num_planes; ++plane) {
> +			vb->v4l2_planes[plane].length = q->plane_sizes[plane];
>  			vb->v4l2_planes[plane].m.mem_offset = off;
> 
>  			dprintk(3, "Buffer %d, plane %d offset 0x%08lx\n",
> --

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

