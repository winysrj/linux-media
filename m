Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2K0LEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Nov 2012 06:04:07 -0500
Date: Tue, 27 Nov 2012 12:03:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 05/15] [media] marvell-ccic: refine mcam_set_contig_buffer
 function
In-Reply-To: <1353677611-24107-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1211271201180.22273@axis700.grange>
References: <1353677611-24107-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 23 Nov 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch refines mcam_set_contig_buffer() in mcam core
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>

Looks good in general, just will have to be tested on currently supported 
platforms, because it changes the order, in which registers are written. 
So, if this patch is not too important for you, maybe it would be better 
to drop it, it doesn't seem to improve any functionality?

If it is decided to use this, you can add my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c |   21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index 760e8ea..67d4f2f 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c
> @@ -481,22 +481,21 @@ static void mcam_set_contig_buffer(struct mcam_camera *cam, int frame)
>  	 */
>  	if (list_empty(&cam->buffers)) {
>  		buf = cam->vb_bufs[frame ^ 0x1];
> -		cam->vb_bufs[frame] = buf;
> -		mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
> -				vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
>  		set_bit(CF_SINGLE_BUFFER, &cam->flags);
>  		cam->frame_state.singles++;
> -		return;
> +	} else {
> +		/*
> +		 * OK, we have a buffer we can use.
> +		 */
> +		buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer,
> +					queue);
> +		list_del_init(&buf->queue);
> +		clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>  	}
> -	/*
> -	 * OK, we have a buffer we can use.
> -	 */
> -	buf = list_first_entry(&cam->buffers, struct mcam_vb_buffer, queue);
> -	list_del_init(&buf->queue);
> +
> +	cam->vb_bufs[frame] = buf;
>  	mcam_reg_write(cam, frame == 0 ? REG_Y0BAR : REG_Y1BAR,
>  			vb2_dma_contig_plane_dma_addr(&buf->vb_buf, 0));
> -	cam->vb_bufs[frame] = buf;
> -	clear_bit(CF_SINGLE_BUFFER, &cam->flags);
>  }
>  
>  /*
> -- 
> 1.7.9.5
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
