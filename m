Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1GASnu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2011 14:43:50 -0400
Message-ID: <4E0E153F.5000303@redhat.com>
Date: Fri, 01 Jul 2011 15:43:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: hvaibhav@ti.com
CC: linux-media@vger.kernel.org, Amber Jain <amber@ti.com>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL for v3.0] OMAP_VOUT bug fixes and code cleanup
References: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
In-Reply-To: <1308771169-10741-1-git-send-email-hvaibhav@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 22-06-2011 16:32, hvaibhav@ti.com escreveu:
> The following changes since commit af0d6a0a3a30946f7df69c764791f1b0643f7cd6:
>   Linus Torvalds (1):
>         Merge branch 'x86-urgent-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git for-linux-media
> 
> Amber Jain (2):
>       V4L2: omap_vout: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
>       OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP

> From: Amber Jain <amber@ti.com>
> Date: Tue May 31 11:45:36 2011 -0300
> 
> OMAP2: V4L2: Remove GFP_DMA allocation as ZONE_DMA is not configured on OMAP
>     
> Remove GFP_DMA from the __get_free_pages() call from omap24xxcam as ZONE_DMA
> is not configured on OMAP. Earlier the page allocator used to return a page
> from ZONE_NORMAL even when GFP_DMA is passed and CONFIG_ZONE_DMA is disabled.
> As a result of commit a197b59ae6e8bee56fcef37ea2482dc08414e2ac, page allocator
> returns null in such a scenario with a warning emitted to kernel log.
>    
> Signed-off-by: Amber Jain <amber@ti.com>
> Acked-by: Sakari Ailus <sakari.ailus@iki.fi>
> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
> 
> diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
> index f6626e8..d92d4c6 100644
> --- a/drivers/media/video/omap24xxcam.c
> +++ b/drivers/media/video/omap24xxcam.c
> @@ -309,11 +309,11 @@ static int omap24xxcam_vbq_alloc_mmap_buffer(struct videobuf_buffer *vb)
>  			order--;
>  
>  		/* try to allocate as many contiguous pages as possible */
> -		page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +		page = alloc_pages(GFP_KERNEL, order);
>  		/* if allocation fails, try to allocate smaller amount */
>  		while (page == NULL) {
>  			order--;
> -			page = alloc_pages(GFP_KERNEL | GFP_DMA, order);
> +			page = alloc_pages(GFP_KERNEL, order);
>  			if (page == NULL && !order) {
>  				err = -ENOMEM;
>  				goto out;

Hmm... the proper fix wouldn't be to define ZONE_DMA at OMAP?

Thanks,
Mauro
