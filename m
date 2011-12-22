Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:54106 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1LVXRt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Dec 2011 18:17:49 -0500
Date: Fri, 23 Dec 2011 00:17:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	lethal@linux-sh.org, hans.verkuil@cisco.com, s.hauer@pengutronix.de
Subject: Re: [PATCH v2] media i.MX27 camera: Fix field_count handling.
In-Reply-To: <1324566720-14073-1-git-send-email-javier.martin@vista-silicon.com>
Message-ID: <Pine.LNX.4.64.1112221652110.13700@axis700.grange>
References: <1324566720-14073-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 22 Dec 2011, Javier Martin wrote:

> To properly detect frame loss the driver must keep
> track of a frame_count.
> 
> Furthermore, field_count use was erroneous because
> in progressive format this must be incremented twice.

Hm, sorry, why this? I just looked at vivi.c - the version before 
videobuf2 conversion - and it seems to only increment the count by one.

> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
> ---
>  drivers/media/video/mx2_camera.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ea1f4dc..ca76dd2 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -255,6 +255,7 @@ struct mx2_camera_dev {
>  	dma_addr_t		discard_buffer_dma;
>  	size_t			discard_size;
>  	struct mx2_fmt_cfg	*emma_prp;
> +	u32			frame_count;

The rule I usually follow, when choosing variable type is the following: 
does it really have to be fixed bit-width? The positive reply is pretty 
rare, it comes mostly if (a) the variable is used to store values read 
from or written to some (fixed-width) hardware registers, or (b) the 
variable belongs to a fixed ABI, that has to be the same on different 
(32-bit, 64-bit) systems, like (arguably) ioctl()s, data, transferred over 
the network or stored on a medium (filesystems,...). This doesn't seem to 
be the case here, so, I would just use an (unsigned) int.

Thanks
Guennadi

>  };
>  
>  /* buffer for one video frame */
> @@ -368,6 +369,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>  	writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
>  
>  	pcdev->icd = icd;
> +	pcdev->frame_count = 0;
>  
>  	dev_info(icd->parent, "Camera driver attached to camera %d\n",
>  		 icd->devnum);
> @@ -1211,7 +1213,8 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>  		list_del(&vb->queue);
>  		vb->state = state;
>  		do_gettimeofday(&vb->ts);
> -		vb->field_count++;
> +		vb->field_count = pcdev->frame_count * 2;
> +		pcdev->frame_count++;
>  
>  		wake_up(&vb->done);
>  	}
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
