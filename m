Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m61K2OO9031519
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 16:02:24 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m61K2Agv030605
	for <video4linux-list@redhat.com>; Tue, 1 Jul 2008 16:02:11 -0400
Date: Tue, 1 Jul 2008 22:02:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20080701124657.30446.28078.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0807012158510.4203@axis700.grange>
References: <20080701124638.30446.81449.sendpatchset@rx1.opensource.se>
	<20080701124657.30446.28078.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-sh@vger.kernel.org, video4linux-list@redhat.com, lethal@linux-sh.org,
	akpm@linux-foundation.org, mchehab@infradead.org
Subject: Re: [PATCH 02/07] soc_camera: Let the host select videobuf_queue
 type
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

On Tue, 1 Jul 2008, Magnus Damm wrote:

> This patch makes it possible for hosts (soc_camera drivers for the soc)
> to select a different videobuf queue than VIDEOBUF_DMA_SG. This is needed
> by the SuperH Mobile CEU hardware which requires physically contiguous
> buffers. While at it, rename the spinlock callbacks to file callbacks.
> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>

I'm afraid, this patch conflicts with an earlier one by Paulius Zaleckas:
http://marc.info/?l=linux-video&m=121438688924771&w=2, which I've already 
acked, and which, I think, makes videobuf handling more generic than 
yours. Could you please have a look if you can use it, if yes - rebase 
your patch-set on it (I think, some other your patches will have to be 
changed then too). If there's anything that you cannot use there, we'll 
have to see how we can satisfy all the requirements.

Thanks
Guennadi

> ---
> 
>  drivers/media/video/Kconfig      |    4 ++--
>  drivers/media/video/pxa_camera.c |   15 ++++++++++++---
>  drivers/media/video/soc_camera.c |   27 +++++++--------------------
>  include/media/soc_camera.h       |    6 +++---
>  4 files changed, 24 insertions(+), 28 deletions(-)
> 
> --- 0001/drivers/media/video/Kconfig
> +++ work/drivers/media/video/Kconfig	2008-07-01 13:05:48.000000000 +0900
> @@ -901,8 +901,7 @@ endif # V4L_USB_DRIVERS
>  
>  config SOC_CAMERA
>  	tristate "SoC camera support"
> -	depends on VIDEO_V4L2 && HAS_DMA
> -	select VIDEOBUF_DMA_SG
> +	depends on VIDEO_V4L2
>  	help
>  	  SoC Camera is a common API to several cameras, not connecting
>  	  over a bus like PCI or USB. For example some i2c camera connected
> @@ -941,6 +940,7 @@ config VIDEO_PXA27x
>  	tristate "PXA27x Quick Capture Interface driver"
>  	depends on VIDEO_DEV && PXA27x
>  	select SOC_CAMERA
> +	select VIDEOBUF_DMA_SG
>  	---help---
>  	  This is a v4l2 driver for the PXA27x Quick Capture Interface
>  
> --- 0001/drivers/media/video/pxa_camera.c
> +++ work/drivers/media/video/pxa_camera.c	2008-07-01 13:03:56.000000000 +0900
> @@ -31,6 +31,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
>  #include <media/soc_camera.h>
> +#include <media/videobuf-dma-sg.h>
>  
>  #include <linux/videodev2.h>
>  
> @@ -983,13 +984,21 @@ static int pxa_camera_querycap(struct so
>  	return 0;
>  }
>  
> -static spinlock_t *pxa_camera_spinlock_alloc(struct soc_camera_file *icf)
> +static int pxa_camera_file_alloc(struct soc_camera_file *icf)
>  {
>  	struct soc_camera_host *ici =
>  		to_soc_camera_host(icf->icd->dev.parent);
>  	struct pxa_camera_dev *pcdev = ici->priv;
>  
> -	return &pcdev->lock;
> +	icf->lock = &pcdev->lock;
> +
> +	/* We must pass NULL as dev pointer, then all pci_* dma operations
> +	 * transform to normal dma_* ones. */
> +	videobuf_queue_sg_init(&icf->vb_vidq, &pxa_videobuf_ops,
> +			       NULL, icf->lock,
> +			       V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> +			       sizeof(struct pxa_buffer), icf->icd);
> +	return 0;
>  }
>  
>  static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
> @@ -1003,7 +1012,7 @@ static struct soc_camera_host_ops pxa_so
>  	.querycap	= pxa_camera_querycap,
>  	.try_bus_param	= pxa_camera_try_bus_param,
>  	.set_bus_param	= pxa_camera_set_bus_param,
> -	.spinlock_alloc	= pxa_camera_spinlock_alloc,
> +	.file_alloc	= pxa_camera_file_alloc,
>  };
>  
>  /* Should be allocated dynamically too, but we have only one. */
> --- 0005/drivers/media/video/soc_camera.c
> +++ work/drivers/media/video/soc_camera.c	2008-07-01 13:03:56.000000000 +0900
> @@ -182,7 +182,6 @@ static int soc_camera_open(struct inode 
>  	struct soc_camera_device *icd;
>  	struct soc_camera_host *ici;
>  	struct soc_camera_file *icf;
> -	spinlock_t *lock;
>  	int ret;
>  
>  	icf = vmalloc(sizeof(*icf));
> @@ -210,11 +209,9 @@ static int soc_camera_open(struct inode 
>  
>  	icf->icd = icd;
>  
> -	icf->lock = ici->ops->spinlock_alloc(icf);
> -	if (!icf->lock) {
> -		ret = -ENOMEM;
> +	ret = ici->ops->file_alloc(icf);
> +	if (ret)
>  		goto esla;
> -	}
>  
>  	icd->use_count++;
>  
> @@ -232,21 +229,13 @@ static int soc_camera_open(struct inode 
>  
>  	file->private_data = icf;
>  	dev_dbg(&icd->dev, "camera device open\n");
> -
> -	/* We must pass NULL as dev pointer, then all pci_* dma operations
> -	 * transform to normal dma_* ones. */
> -	videobuf_queue_sg_init(&icf->vb_vidq, ici->vbq_ops, NULL, icf->lock,
> -				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
> -				ici->msize, icd);
> -
>  	return 0;
>  
>  	/* All errors are entered with the video_lock held */
>  eiciadd:
> -	lock = icf->lock;
> +	if (ici->ops->file_free)
> +		ici->ops->file_free(icf);
>  	icf->lock = NULL;
> -	if (ici->ops->spinlock_free)
> -		ici->ops->spinlock_free(lock);
>  esla:
>  	module_put(ici->ops->owner);
>  emgi:
> @@ -263,15 +252,14 @@ static int soc_camera_close(struct inode
>  	struct soc_camera_device *icd = icf->icd;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>  	struct video_device *vdev = icd->vdev;
> -	spinlock_t *lock = icf->lock;
>  
>  	mutex_lock(&video_lock);
>  	icd->use_count--;
>  	if (!icd->use_count)
>  		ici->ops->remove(icd);
> +	if (ici->ops->file_free)
> +		ici->ops->file_free(icf);
>  	icf->lock = NULL;
> -	if (ici->ops->spinlock_free)
> -		ici->ops->spinlock_free(lock);
>  	module_put(icd->ops->owner);
>  	module_put(ici->ops->owner);
>  	mutex_unlock(&video_lock);
> @@ -772,8 +760,7 @@ int soc_camera_host_register(struct soc_
>  	int ret;
>  	struct soc_camera_host *ix;
>  
> -	if (!ici->vbq_ops || !ici->ops->add || !ici->ops->remove
> -	    || !ici->ops->spinlock_alloc)
> +	if (!ici->ops->add || !ici->ops->remove || !ici->ops->file_alloc)
>  		return -EINVAL;
>  
>  	/* Number might be equal to the platform device ID */
> --- 0001/include/media/soc_camera.h
> +++ work/include/media/soc_camera.h	2008-07-01 13:03:56.000000000 +0900
> @@ -13,7 +13,7 @@
>  #define SOC_CAMERA_H
>  
>  #include <linux/videodev2.h>
> -#include <media/videobuf-dma-sg.h>
> +#include <media/videobuf-core.h>
>  
>  struct soc_camera_device {
>  	struct list_head list;
> @@ -74,8 +74,8 @@ struct soc_camera_host_ops {
>  	int (*try_bus_param)(struct soc_camera_device *, __u32);
>  	int (*set_bus_param)(struct soc_camera_device *, __u32);
>  	unsigned int (*poll)(struct file *, poll_table *);
> -	spinlock_t* (*spinlock_alloc)(struct soc_camera_file *);
> -	void (*spinlock_free)(spinlock_t *);
> +	int (*file_alloc)(struct soc_camera_file *);
> +	void (*file_free)(struct soc_camera_file *);
>  };
>  
>  struct soc_camera_link {
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
