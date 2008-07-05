Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m654JZxX022376
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 00:19:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m654JJir018204
	for <video4linux-list@redhat.com>; Sat, 5 Jul 2008 00:19:20 -0400
Date: Sat, 5 Jul 2008 06:19:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <20080705025345.27137.74420.sendpatchset@rx1.opensource.se>
Message-ID: <Pine.LNX.4.64.0807050602370.705@axis700.grange>
References: <20080705025335.27137.98068.sendpatchset@rx1.opensource.se>
	<20080705025345.27137.74420.sendpatchset@rx1.opensource.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, paulius.zaleckas@teltonika.lt,
	linux-sh@vger.kernel.org, Mauro Carvalho Chehab <mchehab@infradead.org>,
	lethal@linux-sh.org, akpm@linux-foundation.org
Subject: Re: [PATCH 01/04] soc_camera: Move spinlocks
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

On Sat, 5 Jul 2008, Magnus Damm wrote:

> This patch moves the spinlock handling from soc_camera.c to the actual
> camera host driver. The spinlock alloc/free callbacks are replaced with
> code in init_videobuf().

Does this mean, that you have found a possibility to port your 
spinlock-removal patch on the top of the "make videobuf independent" patch 
without any loss of functionality? This looks good on a first glance. I am 
on a holiday now (:-)), so, I unfortunately cannot review your patches 
ATM. I'll try to do this in a week, hope, this still will be in time for 
the 2.6.27 merge window.

Thanks
Guennadi

> 
> Signed-off-by: Magnus Damm <damm@igel.co.jp>
> ---
> 
>  drivers/media/video/pxa_camera.c |   17 ++++------------
>  drivers/media/video/soc_camera.c |   39 --------------------------------------
>  include/media/soc_camera.h       |    5 ----
>  3 files changed, 7 insertions(+), 54 deletions(-)
> 
> --- 0002/drivers/media/video/pxa_camera.c
> +++ work/drivers/media/video/pxa_camera.c	2008-07-04 17:24:53.000000000 +0900
> @@ -583,12 +583,15 @@ static struct videobuf_queue_ops pxa_vid
>  	.buf_release    = pxa_videobuf_release,
>  };
>  
> -static void pxa_camera_init_videobuf(struct videobuf_queue *q, spinlock_t *lock,
> +static void pxa_camera_init_videobuf(struct videobuf_queue *q,
>  			      struct soc_camera_device *icd)
>  {
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
> +	struct pxa_camera_dev *pcdev = ici->priv;
> +
>  	/* We must pass NULL as dev pointer, then all pci_* dma operations
>  	 * transform to normal dma_* ones. */
> -	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, lock,
> +	videobuf_queue_sg_init(q, &pxa_videobuf_ops, NULL, &pcdev->lock,
>  				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
>  				sizeof(struct pxa_buffer), icd);
>  }
> @@ -994,15 +997,6 @@ static int pxa_camera_querycap(struct so
>  	return 0;
>  }
>  
> -static spinlock_t *pxa_camera_spinlock_alloc(struct soc_camera_file *icf)
> -{
> -	struct soc_camera_host *ici =
> -		to_soc_camera_host(icf->icd->dev.parent);
> -	struct pxa_camera_dev *pcdev = ici->priv;
> -
> -	return &pcdev->lock;
> -}
> -
>  static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
>  	.owner		= THIS_MODULE,
>  	.add		= pxa_camera_add_device,
> @@ -1015,7 +1009,6 @@ static struct soc_camera_host_ops pxa_so
>  	.querycap	= pxa_camera_querycap,
>  	.try_bus_param	= pxa_camera_try_bus_param,
>  	.set_bus_param	= pxa_camera_set_bus_param,
> -	.spinlock_alloc	= pxa_camera_spinlock_alloc,
>  };
>  
>  /* Should be allocated dynamically too, but we have only one. */
> --- 0002/drivers/media/video/soc_camera.c
> +++ work/drivers/media/video/soc_camera.c	2008-07-04 17:24:53.000000000 +0900
> @@ -183,7 +183,6 @@ static int soc_camera_open(struct inode 
>  	struct soc_camera_device *icd;
>  	struct soc_camera_host *ici;
>  	struct soc_camera_file *icf;
> -	spinlock_t *lock;
>  	int ret;
>  
>  	icf = vmalloc(sizeof(*icf));
> @@ -210,13 +209,6 @@ static int soc_camera_open(struct inode 
>  	}
>  
>  	icf->icd = icd;
> -
> -	icf->lock = ici->ops->spinlock_alloc(icf);
> -	if (!icf->lock) {
> -		ret = -ENOMEM;
> -		goto esla;
> -	}
> -
>  	icd->use_count++;
>  
>  	/* Now we really have to activate the camera */
> @@ -234,17 +226,12 @@ static int soc_camera_open(struct inode 
>  	file->private_data = icf;
>  	dev_dbg(&icd->dev, "camera device open\n");
>  
> -	ici->ops->init_videobuf(&icf->vb_vidq, icf->lock, icd);
> +	ici->ops->init_videobuf(&icf->vb_vidq, icd);
>  
>  	return 0;
>  
>  	/* All errors are entered with the video_lock held */
>  eiciadd:
> -	lock = icf->lock;
> -	icf->lock = NULL;
> -	if (ici->ops->spinlock_free)
> -		ici->ops->spinlock_free(lock);
> -esla:
>  	module_put(ici->ops->owner);
>  emgi:
>  	module_put(icd->ops->owner);
> @@ -260,15 +247,11 @@ static int soc_camera_close(struct inode
>  	struct soc_camera_device *icd = icf->icd;
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->dev.parent);
>  	struct video_device *vdev = icd->vdev;
> -	spinlock_t *lock = icf->lock;
>  
>  	mutex_lock(&video_lock);
>  	icd->use_count--;
>  	if (!icd->use_count)
>  		ici->ops->remove(icd);
> -	icf->lock = NULL;
> -	if (ici->ops->spinlock_free)
> -		ici->ops->spinlock_free(lock);
>  	module_put(icd->ops->owner);
>  	module_put(ici->ops->owner);
>  	mutex_unlock(&video_lock);
> @@ -764,21 +747,6 @@ static void dummy_release(struct device 
>  {
>  }
>  
> -static spinlock_t *spinlock_alloc(struct soc_camera_file *icf)
> -{
> -	spinlock_t *lock = kmalloc(sizeof(spinlock_t), GFP_KERNEL);
> -
> -	if (lock)
> -		spin_lock_init(lock);
> -
> -	return lock;
> -}
> -
> -static void spinlock_free(spinlock_t *lock)
> -{
> -	kfree(lock);
> -}
> -
>  int soc_camera_host_register(struct soc_camera_host *ici)
>  {
>  	int ret;
> @@ -808,11 +776,6 @@ int soc_camera_host_register(struct soc_
>  	if (ret)
>  		goto edevr;
>  
> -	if (!ici->ops->spinlock_alloc) {
> -		ici->ops->spinlock_alloc = spinlock_alloc;
> -		ici->ops->spinlock_free = spinlock_free;
> -	}
> -
>  	scan_add_host(ici);
>  
>  	return 0;
> --- 0002/include/media/soc_camera.h
> +++ work/include/media/soc_camera.h	2008-07-04 18:06:00.000000000 +0900
> @@ -48,7 +48,6 @@ struct soc_camera_device {
>  struct soc_camera_file {
>  	struct soc_camera_device *icd;
>  	struct videobuf_queue vb_vidq;
> -	spinlock_t *lock;
>  };
>  
>  struct soc_camera_host {
> @@ -67,15 +66,13 @@ struct soc_camera_host_ops {
>  	int (*set_fmt_cap)(struct soc_camera_device *, __u32,
>  			   struct v4l2_rect *);
>  	int (*try_fmt_cap)(struct soc_camera_device *, struct v4l2_format *);
> -	void (*init_videobuf)(struct videobuf_queue*, spinlock_t *,
> +	void (*init_videobuf)(struct videobuf_queue *,
>  			      struct soc_camera_device *);
>  	int (*reqbufs)(struct soc_camera_file *, struct v4l2_requestbuffers *);
>  	int (*querycap)(struct soc_camera_host *, struct v4l2_capability *);
>  	int (*try_bus_param)(struct soc_camera_device *, __u32);
>  	int (*set_bus_param)(struct soc_camera_device *, __u32);
>  	unsigned int (*poll)(struct file *, poll_table *);
> -	spinlock_t* (*spinlock_alloc)(struct soc_camera_file *);
> -	void (*spinlock_free)(spinlock_t *);
>  };
>  
>  struct soc_camera_link {
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
