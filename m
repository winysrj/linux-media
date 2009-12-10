Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55532 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752809AbZLJNG3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 08:06:29 -0500
Date: Thu, 10 Dec 2009 14:06:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, m-karicheri2@ti.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] sh_mobile_ceu_camera: Remove frame size page alignment
In-Reply-To: <20091209131624.8044.18187.sendpatchset@rxone.opensource.se>
Message-ID: <Pine.LNX.4.64.0912101359060.4487@axis700.grange>
References: <20091209131624.8044.18187.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 9 Dec 2009, Magnus Damm wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> This patch updates the SuperH Mobile CEU driver to
> not page align the frame size. Useful in the case of
> USERPTR with non-page aligned frame sizes and offsets.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> --- 0010/drivers/media/video/sh_mobile_ceu_camera.c
> +++ work/drivers/media/video/sh_mobile_ceu_camera.c	2009-12-09 17:54:37.000000000 +0900
> @@ -199,14 +199,13 @@ static int sh_mobile_ceu_videobuf_setup(
>  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
>  	int bytes_per_pixel = (icd->current_fmt->depth + 7) >> 3;
>  
> -	*size = PAGE_ALIGN(icd->user_width * icd->user_height *
> -			   bytes_per_pixel);
> +	*size = icd->user_width * icd->user_height * bytes_per_pixel;
>  
>  	if (0 == *count)
>  		*count = 2;
>  
>  	if (pcdev->video_limit) {
> -		while (*size * *count > pcdev->video_limit)
> +		while (PAGE_ALIGN(*size) * *count > pcdev->video_limit)
>  			(*count)--;
>  	}

Please, correct me if I'm wrong. Currently most (all?) sh platforms, using 
this driver, and wishing to use V4L2_MEMORY_MMAP, reserve contiguous 
memory in their platform code. In this case pcdev->video_limit is set to 
the size of that area. videobuf-dma-contig.c::__videobuf_mmap_mapper() 
will anyway allocate page-aligned buffers for V4L2_MEMORY_MMAP, so, even 
for the case of a platform, not reserving RAM at boot-time, it should 
work. Similarly it should work for the V4L2_MEMORY_USERPTR case. So, looks 
ok to me, queued, thanks.

Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
