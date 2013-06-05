Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:60696 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab3FEJ7B (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Jun 2013 05:59:01 -0400
Date: Wed, 5 Jun 2013 11:58:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Wenbing Wang <wangwb@marvell.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] soc_camera: error dev remove and v4l2 call
In-Reply-To: <1370425034-3648-1-git-send-email-wangwb@marvell.com>
Message-ID: <Pine.LNX.4.64.1306051152540.19739@axis700.grange>
References: <1370425034-3648-1-git-send-email-wangwb@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

On Wed, 5 Jun 2013, Wenbing Wang wrote:

> From: Wenbing Wang <wangwb@marvell.com>
> 
> in soc_camera_close(), if ici->ops->remove() removes device firstly,
> and then call __soc_camera_power_off(), it has logic error. Since
> if remove device, it should disable subdev clk. but in __soc_camera_
> power_off(), it will callback v4l2 s_power function which will
> read/write subdev registers to control power by i2c. and then
> i2c read/write will fail because of clk disable.
> So suggest to re-sequence two functions call.

Thanks for the patch. I agree, that the clock should be switched off after 
powering off the client. And this is also how it's done in the latest 
version of my v4l2-clk / v4l2-async patches: there in 
soc_camera_power_off() first power-off is performed and only then 
v4l2_clk_disable() is called to detach the client from the host and stop 
the master clock. So, if you need this fix for 3.10, we could push it 
upstream. Otherwise hopefully we'll manage to get v4l2-clk and -async in 
3.11 and thus have this fixed there. Then this patch won't be needed.

Thanks
Guennadi

> Change-Id: Iee7a6d4fc7c7c1addb5d342621eb8dcd00fa2745
> Signed-off-by: Wenbing Wang <wangwb@marvell.com>
> ---
>  drivers/media/platform/soc_camera/soc_camera.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
> index eea832c..3a4efbd 100644
> --- a/drivers/media/platform/soc_camera/soc_camera.c
> +++ b/drivers/media/platform/soc_camera/soc_camera.c
> @@ -643,9 +643,9 @@ static int soc_camera_close(struct file *file)
>  
>  		if (ici->ops->init_videobuf2)
>  			vb2_queue_release(&icd->vb2_vidq);
> -		ici->ops->remove(icd);
> -
>  		__soc_camera_power_off(icd);
> +
> +		ici->ops->remove(icd);
>  	}
>  
>  	if (icd->streamer == file)
> -- 
> 1.7.5.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
