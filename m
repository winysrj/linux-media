Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0BIQOfs005803
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 13:26:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n0BIQ7g0011696
	for <video4linux-list@redhat.com>; Sun, 11 Jan 2009 13:26:07 -0500
Date: Sun, 11 Jan 2009 19:26:14 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20081210045432.3810.42700.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0901111924320.16531@axis700.grange>
References: <20081210045432.3810.42700.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] videobuf-dma-contig: fix USERPTR free handling
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 10 Dec 2008, Magnus Damm wrote:

> From: Magnus Damm <damm@igel.co.jp>
> 
> This patch fixes a free-without-alloc bug for V4L2_MEMORY_USERPTR
> video buffers.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

Mauro, what about this patch? Is it correct? If so, it shall be applied I 
presume, as in that case it is a bug-fix.

Thanks
Guennadi

> ---
> 
>  drivers/media/video/videobuf-dma-contig.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 0001/drivers/media/video/videobuf-dma-contig.c
> +++ work/drivers/media/video/videobuf-dma-contig.c	2008-12-07 22:34:47.000000000 +0900
> @@ -400,7 +400,7 @@ void videobuf_dma_contig_free(struct vid
>  	   So, it should free memory only if the memory were allocated for
>  	   read() operation.
>  	 */
> -	if ((buf->memory != V4L2_MEMORY_USERPTR) || !buf->baddr)
> +	if ((buf->memory != V4L2_MEMORY_USERPTR) || buf->baddr)
>  		return;
>  
>  	if (!mem)
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
