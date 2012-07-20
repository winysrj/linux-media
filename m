Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2GTJWP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jul 2012 05:22:15 -0400
Date: Fri, 20 Jul 2012 11:21:37 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, Andy Walls <awalls@md.metrocast.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Manjunatha Halli <manjunatha_halli@ti.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>,
	Anatolij Gustschin <agust@denx.de>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Sensoray Linux Development <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sachin Kamat <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 19/26] soc_camera: remove V4L2_FL_LOCK_ALL_FOPS
In-Reply-To: <b3df6c99d6a97ac7a9f2a1d52f3c0ee95f73be3b.1340536092.git.hans.verkuil@cisco.com>
Message-ID: <Pine.LNX.4.64.1207201118560.27906@axis700.grange>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
 <b3df6c99d6a97ac7a9f2a1d52f3c0ee95f73be3b.1340536092.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

Thanks for the patch. I guess, you'll want to pull it via your queue. Let 
me know if for some reason you'd prefer me to take it.

On Sun, 24 Jun 2012, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add proper locking to the file operations, allowing for the removal
> of the V4L2_FL_LOCK_ALL_FOPS flag.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> ---
>  drivers/media/video/soc_camera.c |   31 ++++++++++++++++++++-----------
>  1 file changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/media/video/soc_camera.c b/drivers/media/video/soc_camera.c
> index 0421bf9..368b6fc 100644
> --- a/drivers/media/video/soc_camera.c
> +++ b/drivers/media/video/soc_camera.c
> @@ -507,9 +507,12 @@ static int soc_camera_open(struct file *file)
>  
>  	ici = to_soc_camera_host(icd->parent);
>  
> +	if (mutex_lock_interruptible(&icd->video_lock))
> +		return -ERESTARTSYS;
>  	if (!try_module_get(ici->ops->owner)) {
>  		dev_err(icd->pdev, "Couldn't lock capture bus driver.\n");
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto emodule;
>  	}
>  
>  	icd->use_count++;
> @@ -570,6 +573,7 @@ static int soc_camera_open(struct file *file)
>  		}
>  		v4l2_ctrl_handler_setup(&icd->ctrl_handler);
>  	}
> +	mutex_unlock(&icd->video_lock);
>  
>  	file->private_data = icd;
>  	dev_dbg(icd->pdev, "camera device open\n");
> @@ -590,6 +594,8 @@ epower:
>  eiciadd:
>  	icd->use_count--;
>  	module_put(ici->ops->owner);
> +emodule:
> +	mutex_unlock(&icd->video_lock);
>  
>  	return ret;
>  }
> @@ -599,6 +605,7 @@ static int soc_camera_close(struct file *file)
>  	struct soc_camera_device *icd = file->private_data;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  
> +	mutex_lock(&icd->video_lock);
>  	icd->use_count--;
>  	if (!icd->use_count) {
>  		struct soc_camera_link *icl = to_soc_camera_link(icd);
> @@ -615,6 +622,7 @@ static int soc_camera_close(struct file *file)
>  
>  	if (icd->streamer == file)
>  		icd->streamer = NULL;
> +	mutex_unlock(&icd->video_lock);
>  
>  	module_put(ici->ops->owner);
>  
> @@ -645,10 +653,13 @@ static int soc_camera_mmap(struct file *file, struct vm_area_struct *vma)
>  	if (icd->streamer != file)
>  		return -EBUSY;
>  
> +	if (mutex_lock_interruptible(&icd->video_lock))
> +		return -ERESTARTSYS;
>  	if (ici->ops->init_videobuf)
>  		err = videobuf_mmap_mapper(&icd->vb_vidq, vma);
>  	else
>  		err = vb2_mmap(&icd->vb2_vidq, vma);
> +	mutex_unlock(&icd->video_lock);
>  
>  	dev_dbg(icd->pdev, "vma start=0x%08lx, size=%ld, ret=%d\n",
>  		(unsigned long)vma->vm_start,
> @@ -662,16 +673,18 @@ static unsigned int soc_camera_poll(struct file *file, poll_table *pt)
>  {
>  	struct soc_camera_device *icd = file->private_data;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	unsigned res = POLLERR;
>  
>  	if (icd->streamer != file)
> -		return -EBUSY;
> -
> -	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream)) {
> -		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
>  		return POLLERR;
> -	}
>  
> -	return ici->ops->poll(file, pt);
> +	mutex_lock(&icd->video_lock);
> +	if (ici->ops->init_videobuf && list_empty(&icd->vb_vidq.stream))
> +		dev_err(icd->pdev, "Trying to poll with no queued buffers!\n");
> +	else
> +		res = ici->ops->poll(file, pt);
> +	mutex_unlock(&icd->video_lock);
> +	return res;
>  }
>  
>  void soc_camera_lock(struct vb2_queue *vq)
> @@ -1432,10 +1445,6 @@ static int video_dev_create(struct soc_camera_device *icd)
>  	vdev->tvnorms		= V4L2_STD_UNKNOWN;
>  	vdev->ctrl_handler	= &icd->ctrl_handler;
>  	vdev->lock		= &icd->video_lock;
> -	/* Locking in file operations other than ioctl should be done
> -	   by the driver, not the V4L2 core.
> -	   This driver needs auditing so that this flag can be removed. */
> -	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vdev->flags);
>  
>  	icd->vdev = vdev;
>  
> -- 
> 1.7.10
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
