Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0BVRmP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 12:42:15 -0500
Message-ID: <4B82C1EB.4000906@redhat.com>
Date: Mon, 22 Feb 2010 14:42:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Pawel Osciak <p.osciak@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, m-karicheri2@ti.com
Subject: Re: [PATCH v1 1/4] v4l: add missing checks for kzalloc returning
 NULL.
References: <1266855010-2198-1-git-send-email-p.osciak@samsung.com> <1266855010-2198-2-git-send-email-p.osciak@samsung.com>
In-Reply-To: <1266855010-2198-2-git-send-email-p.osciak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Pawel Osciak wrote:
> Signed-off-by: Pawel Osciak <p.osciak@samsung.com>

This one is not dependent on the RFC, and fixes a bug, so I'm applying it.

Thanks for catching it!

Cheers,
Mauro.

> ---
>  drivers/media/video/videobuf-dma-sg.c  |    2 ++
>  drivers/media/video/videobuf-vmalloc.c |    2 ++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index fa78555..fcd045e 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -418,6 +418,8 @@ static void *__videobuf_alloc(size_t size)
>  	struct videobuf_buffer *vb;
>  
>  	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
> +	if (!vb)
> +		return vb;
>  
>  	mem = vb->priv = ((char *)vb)+size;
>  	mem->magic=MAGIC_SG_MEM;
> diff --git a/drivers/media/video/videobuf-vmalloc.c b/drivers/media/video/videobuf-vmalloc.c
> index d6e6a28..136e093 100644
> --- a/drivers/media/video/videobuf-vmalloc.c
> +++ b/drivers/media/video/videobuf-vmalloc.c
> @@ -138,6 +138,8 @@ static void *__videobuf_alloc(size_t size)
>  	struct videobuf_buffer *vb;
>  
>  	vb = kzalloc(size+sizeof(*mem),GFP_KERNEL);
> +	if (!vb)
> +		return vb;
>  
>  	mem = vb->priv = ((char *)vb)+size;
>  	mem->magic=MAGIC_VMAL_MEM;


-- 

Cheers,
Mauro
