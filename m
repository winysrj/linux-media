Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1945 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab0KQHNx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 02:13:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: achew@nvidia.com
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
Date: Wed, 17 Nov 2010 08:13:43 +0100
Cc: zhangtianfei@leadcoretech.com, pawel@osciak.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1289939083-27209-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1289939083-27209-1-git-send-email-achew@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011170813.43236.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, November 16, 2010 21:24:43 achew@nvidia.com wrote:
> From: Andrew Chew <achew@nvidia.com>
> 
> There are two struct list_head's in struct videobuf_buffer.
> Prior to this fix, all we did for initialization of struct videobuf_buffer
> was to zero out its memory.  This does not properly initialize this struct's
> two list_head members.
> 
> This patch immediately calls INIT_LIST_HEAD on both lists after the kzalloc,
> so that the two lists are initialized properly.

Rather than doing this for all videobuf variants I would suggest that you
do this in videobuf-core.c, videobuf_alloc_vb().

Regards,

	Hans

> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
> I thought I'd submit a patch for this anyway.  Without this, the existing
> camera host drivers will spew an ugly warning on every videobuf allocation,
> which gets annoying really fast.
> 
>  drivers/media/video/videobuf-dma-contig.c |    2 ++
>  drivers/media/video/videobuf-dma-sg.c     |    2 ++
>  drivers/media/video/videobuf-vmalloc.c    |    2 ++
>  3 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..f7e0f86 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -193,6 +193,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
>  	if (vb) {
>  		mem = vb->priv = ((char *)vb) + size;
>  		mem->magic = MAGIC_DC_MEM;
> +		INIT_LIST_HEAD(&vb->stream);
> +		INIT_LIST_HEAD(&vb->queue);
>  	}
>  
>  	return vb;
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index 20f227e..5af3217 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -430,6 +430,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
>  
>  	mem = vb->priv = ((char *)vb) + size;
>  	mem->magic = MAGIC_SG_MEM;
> +	INIT_LIST_HEAD(&vb->stream);
> +	INIT_LIST_HEAD(&vb->queue);
>  
>  	videobuf_dma_init(&mem->dma);
>  
> diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
> index df14258..8babedd 100644
> --- a/drivers/media/video/videobuf-vmalloc.c
> +++ b/drivers/media/video/videobuf-vmalloc.c
> @@ -146,6 +146,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
>  
>  	mem = vb->priv = ((char *)vb) + size;
>  	mem->magic = MAGIC_VMAL_MEM;
> +	INIT_LIST_HEAD(&vb->stream);
> +	INIT_LIST_HEAD(&vb->queue);
>  
>  	dprintk(1, "%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
>  		__func__, vb, (long)sizeof(*vb), (long)size - sizeof(*vb),
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
