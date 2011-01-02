Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.17.10]:56915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1ABULV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Jan 2011 15:11:21 -0500
Date: Sun, 2 Jan 2011 21:11:18 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: "Figo.zhang" <figo1802@gmail.com>
cc: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, AChew@nvidia.com
Subject: Re: [PATCH]v4l: list entries no need to check
In-Reply-To: <1289996048.2730.2.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.1101022109500.858@axis700.grange>
References: <1289996048.2730.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, 17 Nov 2010, Figo.zhang wrote:

> 
> list entries are not need to be inited, so it no need
> for checking. 
> 
> Reported-by: Andrew Chew <AChew@nvidia.com>
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> ---
>  drivers/media/video/mx1_camera.c           |    3 ---
>  drivers/media/video/pxa_camera.c           |    3 ---
>  drivers/media/video/sh_mobile_ceu_camera.c |    3 ---
>  3 files changed, 0 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index 5c17f9e..cb2dd24 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -182,9 +182,6 @@ static int mx1_videobuf_prepare(struct videobuf_queue *vq,
>  	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>  		vb, vb->baddr, vb->bsize);
>  
> -	/* Added list head initialization on alloc */
> -	WARN_ON(!list_empty(&vb->queue));
> -
>  	BUG_ON(NULL == icd->current_fmt);
>  
>  	/*

NAK. See comment in mx1_camera_reqbufs() above the call to 
INIT_LIST_HEAD(). If we decide to remove that debugging, we'd have to 
remove list initialisations there and in all list_del_init() calls.

Thanks
Guennadi

> diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa_camera.c
> index 9de7d59..421de10 100644
> --- a/drivers/media/video/pxa_camera.c
> +++ b/drivers/media/video/pxa_camera.c
> @@ -444,9 +444,6 @@ static int pxa_videobuf_prepare(struct videobuf_queue *vq,
>  	dev_dbg(dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
>  		vb, vb->baddr, vb->bsize);
>  
> -	/* Added list head initialization on alloc */
> -	WARN_ON(!list_empty(&vb->queue));
> -
>  #ifdef DEBUG
>  	/*
>  	 * This can be useful if you want to see if we actually fill
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 2b24bd0..b2bef3f 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -354,9 +354,6 @@ static int sh_mobile_ceu_videobuf_prepare(struct videobuf_queue *vq,
>  	dev_dbg(icd->dev.parent, "%s (vb=0x%p) 0x%08lx %zd\n", __func__,
>  		vb, vb->baddr, vb->bsize);
>  
> -	/* Added list head initialization on alloc */
> -	WARN_ON(!list_empty(&vb->queue));
> -
>  #ifdef DEBUG
>  	/*
>  	 * This can be useful if you want to see if we actually fill
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
