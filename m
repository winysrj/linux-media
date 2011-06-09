Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.171]:53919 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1FIMHZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jun 2011 08:07:25 -0400
Date: Thu, 9 Jun 2011 14:07:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 3.0] soc_camera: OMAP1: stop falling back to dma-sg on
 single -ENOMEM
In-Reply-To: <201106091310.31674.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1106091345520.21107@axis700.grange>
References: <201106091310.31674.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Janusz

On Thu, 9 Jun 2011, Janusz Krzysztofik wrote:

> Since commit 6d3163ce86dd386b4f7bda80241d7fea2bc0bb1d, "mm: check if any 
> page in a pageblock is reserved before marking it MIGRATE_RESERVE", the 
> OMAP1 camera driver behaviour while in videobuf-dma-contig mode can be 
> observed as much more stable than before. Once all application programs 
> are started up and nothing unexpected happens in the system, consecutive 
> device open()s tend to succeed with almost 100% reliability.
> 
> While the result is still not perfect, still prone to occasional -ENOMEM 
> failures, I think there is no longer a need to fall back to more 
> reliable but less effective, more resource hungry videobuf-dma-sg mode 
> if a single open() fails, as long as users are still able to switch 
> DMA modes from user space over the driver provided sysfs interface, 
> should videobuf-dma-contig mode still happen to keep failing for them.
> 
> Tested on Amstrad Delta.
> 
> Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> ---
> Hi,
> While this patch is not a classic fix, not correcting anything that 
> could be considered as a bug or regression, it is a simple consequence 
> of unexpected but very welcome enhancement introduced during this merge 
> window, so I hope it can be accepted in the rc cycle for that reason. 
> Moreover, it provides no new, but simplifies existing code by removing 
> no longer needed bits.

Thanks for the patch.

Hm... First of all, I'm not sure I'd try to push this after the -rc2. 
Secondly, I'm having a hard time seeing this as an improvement at all... 
Your driver is capable to work in two modes: contiguous and sg, right? 
Fortunately also, you are able to automatically switch to the less 
efficient, but easier to obtain mode at open() time - I see this as an 
advantage. You say, after the quoted commit the contig DMA "almost" never 
fails. I believe, it almost never fails in your configuration. But if you 
put your system under a higher memory pressure, it still will fail 
repeatedly, right? And I'm not sure, it is always intuitive to the user, 
that they have to retry starting an application, after it fails with 
-ENOMEM. If you really want to be able to prohibit falling back to SG, 
maybe you can add one more module parameter to enforce dma-contig? Is the 
reason, why you want to do this, because for your situation you'd prefer 
open() to fail rather to switch to SG?

Thanks
Guennadi

> 
> Thanks,
> Janusz
> 
>  drivers/media/video/omap1_camera.c |   37 +------------------------------------
>  1 file changed, 1 insertion(+), 36 deletions(-)
> 
> --- git/drivers/media/video/omap1_camera.c.orig	2011-06-06 18:07:54.000000000 +0200
> +++ git/drivers/media/video/omap1_camera.c	2011-06-09 12:04:09.000000000 +0200
> @@ -172,9 +172,6 @@ struct omap1_cam_dev {
>  	struct omap1_cam_buf		*ready;
>  
>  	enum omap1_cam_vb_mode		vb_mode;
> -	int				(*mmap_mapper)(struct videobuf_queue *q,
> -						struct videobuf_buffer *buf,
> -						struct vm_area_struct *vma);
>  
>  	u32				reg_cache[0];
>  };
> @@ -1352,28 +1349,6 @@ static int omap1_cam_try_fmt(struct soc_
>  
>  static bool sg_mode;
>  
> -/*
> - * Local mmap_mapper wrapper,
> - * used for detecting videobuf-dma-contig buffer allocation failures
> - * and switching to videobuf-dma-sg automatically for future attempts.
> - */
> -static int omap1_cam_mmap_mapper(struct videobuf_queue *q,
> -				  struct videobuf_buffer *buf,
> -				  struct vm_area_struct *vma)
> -{
> -	struct soc_camera_device *icd = q->priv_data;
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> -	struct omap1_cam_dev *pcdev = ici->priv;
> -	int ret;
> -
> -	ret = pcdev->mmap_mapper(q, buf, vma);
> -
> -	if (ret == -ENOMEM)
> -		sg_mode = true;
> -
> -	return ret;
> -}
> -
>  static void omap1_cam_init_videobuf(struct videobuf_queue *q,
>  				     struct soc_camera_device *icd)
>  {
> @@ -1391,18 +1366,8 @@ static void omap1_cam_init_videobuf(stru
>  				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
>  				sizeof(struct omap1_cam_buf), icd, &icd->video_lock);
>  
> -	/* use videobuf mode (auto)selected with the module parameter */
> +	/* use videobuf mode selected with the module parameter */
>  	pcdev->vb_mode = sg_mode ? OMAP1_CAM_DMA_SG : OMAP1_CAM_DMA_CONTIG;
> -
> -	/*
> -	 * Ensure we substitute the videobuf-dma-contig version of the
> -	 * mmap_mapper() callback with our own wrapper, used for switching
> -	 * automatically to videobuf-dma-sg on buffer allocation failure.
> -	 */
> -	if (!sg_mode && q->int_ops->mmap_mapper != omap1_cam_mmap_mapper) {
> -		pcdev->mmap_mapper = q->int_ops->mmap_mapper;
> -		q->int_ops->mmap_mapper = omap1_cam_mmap_mapper;
> -	}
>  }
>  
>  static int omap1_cam_reqbufs(struct soc_camera_device *icd,
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
