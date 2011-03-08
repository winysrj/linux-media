Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:65267 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab1CHHSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Mar 2011 02:18:05 -0500
Date: Tue, 8 Mar 2011 08:17:56 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergio Aguirre <saaguirre@ti.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, pawel@osciak.com
Subject: Re: [PATCH] V4L: soc-camera: Add support for custom host mmap
In-Reply-To: <1299545691-917-1-git-send-email-saaguirre@ti.com>
Message-ID: <Pine.LNX.4.64.1103080809120.3903@axis700.grange>
References: <1299545691-917-1-git-send-email-saaguirre@ti.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sergio

On Mon, 7 Mar 2011, Sergio Aguirre wrote:

> This helps redirect mmap calls to custom memory managers which
> already have preallocated space to use by the device.
> 
> Otherwise, device might not support the allocation attempted
> generically by videobuf.
> 
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> ---
>  drivers/media/video/soc_camera.c |    7 ++++++-
>  include/media/soc_camera.h       |    2 ++
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 59dc71d..d361ba0 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -512,6 +512,7 @@ static ssize_t soc_camera_read(struct file *file, char __user *buf,
>  static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct soc_camera_device *icd = file->private_data;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);

This doesn't seem to be needed

>  	int err;
>  
>  	dev_dbg(&icd->dev, "mmap called, vma=0x%08lx\n", (unsigned long)vma);
> @@ -519,7 +520,11 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (icd->streamer != file)
>  		return -EBUSY;
>  
> -	err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
> +	/* Check for an interface custom mmaper */

mmapper - double 'p'

> +	if (ici->ops->mmap)
> +		err = ici->ops->mmap(&icd->vb_vidq, icd, vma);
> +	else
> +		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);

You're patching an old version of soc-camera. Please use a current one 
with support for videobuf2. Further, wouldn't it be possible for you to 
just replace the videobuf mmap_mapper() (videobuf2 q->mem_ops->mmap()) 
method? I am not sure how possible this is, maybe one of videobuf2 experts 
could help us? BTW, you really should be using the videobuf2 API.

>  
>  	dev_dbg(&icd->dev, "vma start=0x%08lx, size=%ld, ret=%d\n",
>  		(unsigned long)vma->vm_start,
> diff --git a/include/media/soc_camera.h b/include/media/soc_camera.h
> index de81370..11350c2 100644
> --- a/include/media/soc_camera.h
> +++ b/include/media/soc_camera.h
> @@ -87,6 +87,8 @@ struct soc_camera_host_ops {
>  	int (*set_ctrl)(struct soc_camera_device *, struct v4l2_control *);
>  	int (*get_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
>  	int (*set_parm)(struct soc_camera_device *, struct v4l2_streamparm *);
> +	int (*mmap)(struct videobuf_queue *, struct soc_camera_device *,
> +		     struct vm_area_struct *);
>  	unsigned int (*poll)(struct file *, poll_table *);
>  	const struct v4l2_queryctrl *controls;
>  	int num_controls;
> -- 
> 1.7.1
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
