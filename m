Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36899 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976AbZFPQiz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 12:38:55 -0400
Date: Tue, 16 Jun 2009 13:38:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: "Figo.zhang" <figo1802@gmail.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] videobuf-dma-sg.c : not need memset()
Message-ID: <20090616133853.64f5086a@pedra.chehab.org>
In-Reply-To: <1243995225.3459.15.camel@myhost>
References: <1243995225.3459.15.camel@myhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fingo,

Em Wed, 03 Jun 2009 10:13:44 +0800
"Figo.zhang" <figo1802@gmail.com> escreveu:

> mem have malloc zero memory by kzalloc(), so it have not need to 
> memset().
>  
> Signed-off-by: Figo.zhang <figo1802@gmail.com>
> --- 
>  drivers/media/video/videobuf-dma-sg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
> index da1790e..add2f34 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -420,7 +420,7 @@ static void *__videobuf_alloc(size_t size)
>  	mem = vb->priv = ((char *)vb)+size;
>  	mem->magic=MAGIC_SG_MEM;
>  
> -	videobuf_dma_init(&mem->dma);
> +	mem->dma.magic = MAGIC_DMABUF;

Technically, this patch is correct. However, I'm afraid that a future change at
videobuf_dma_init could cause a breakage. IMO, if we do such change, the better
would be to split videobuf_dma_init into two functions or to add a comment at
the code warning that this should match the init done at videobuf_dma_init.

>  
>  	dprintk(1,"%s: allocated at %p(%ld+%ld) & %p(%ld)\n",
>  		__func__,vb,(long)sizeof(*vb),(long)size-sizeof(*vb),
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
