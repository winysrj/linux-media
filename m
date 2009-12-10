Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59150 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751417AbZLJMo4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 07:44:56 -0500
Date: Thu, 10 Dec 2009 13:45:17 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, m-karicheri2@ti.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] sh_mobile_ceu_camera: Add physical address alignment
 checks
In-Reply-To: <20091209130712.32292.81708.sendpatchset@rxone.opensource.se>
Message-ID: <Pine.LNX.4.64.0912101340080.4487@axis700.grange>
References: <20091209130712.32292.81708.sendpatchset@rxone.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, 9 Dec 2009, Magnus Damm wrote:

> From: Magnus Damm <damm@opensource.se>
> 
> Make sure physical addresses are 32-bit aligned in the
> SuperH Mobile CEU driver. The lowest two bits of the
> address registers are fixed to zero so frame buffers
> have to bit 32-bit aligned. The V4L2 mmap() case is
> using dma_alloc_coherent() for this driver which will
> return aligned addresses, but in the USERPTR case we
> must make sure that the user space pointer is valid.
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---
> 
>  drivers/media/video/sh_mobile_ceu_camera.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> --- 0001/drivers/media/video/sh_mobile_ceu_camera.c
> +++ work/drivers/media/video/sh_mobile_ceu_camera.c	2009-12-09 17:16:47.000000000 +0900
> @@ -278,9 +278,14 @@ static int sh_mobile_ceu_capture(struct 
>  
>  	phys_addr_top = videobuf_to_dma_contig(pcdev->active);
>  	ceu_write(pcdev, CDAYR, phys_addr_top);
> +	if (phys_addr_top & 3)
> +		return -EINVAL;
> +

I'm afraid, no. This is too late to check buffer alignment in 
sh_mobile_ceu_capture(), which is called from qbuf and from the ISR to 
queue the next buffer. Besides, as comment for this function explains, its 
return code doesn't reflect success or failure to queue the new buffer, 
but the status of the previous one. These tests have to be done in 
sh_mobile_ceu_videobuf_prepare() and in .set_fmt(), where the geometry is 
set.

Thanks
Guennadi

>  	if (pcdev->is_interlaced) {
>  		phys_addr_bottom = phys_addr_top + icd->user_width;
>  		ceu_write(pcdev, CDBYR, phys_addr_bottom);
> +		if (phys_addr_bottom & 3)
> +			return -EINVAL;
>  	}
>  
>  	switch (icd->current_fmt->fourcc) {
> @@ -288,13 +293,16 @@ static int sh_mobile_ceu_capture(struct 
>  	case V4L2_PIX_FMT_NV21:
>  	case V4L2_PIX_FMT_NV16:
>  	case V4L2_PIX_FMT_NV61:
> -		phys_addr_top += icd->user_width *
> -			icd->user_height;
> +		phys_addr_top += icd->user_width * icd->user_height;
>  		ceu_write(pcdev, CDACR, phys_addr_top);
> +		if (phys_addr_top & 3)
> +			return -EINVAL;
> +
>  		if (pcdev->is_interlaced) {
> -			phys_addr_bottom = phys_addr_top +
> -				icd->user_width;
> +			phys_addr_bottom = phys_addr_top + icd->user_width;
>  			ceu_write(pcdev, CDBCR, phys_addr_bottom);
> +			if (phys_addr_bottom & 3)
> +				return -EINVAL;
>  		}
>  	}
>  
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
