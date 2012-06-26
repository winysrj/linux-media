Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31029 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab2FZJfl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 05:35:41 -0400
Received: from eusync3.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M67005DVXC9IE30@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:36:09 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6700MCEXBBZR50@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:35:38 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: 'Andy Walls' <awalls@md.metrocast.net>,
	'Guennadi Liakhovetski' <g.liakhovetski@gmx.de>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Scott Jiang' <scott.jiang.linux@gmail.com>,
	'Manjunatha Halli' <manjunatha_halli@ti.com>,
	'Manjunath Hadli' <manjunath.hadli@ti.com>,
	'Anatolij Gustschin' <agust@denx.de>,
	'Javier Martin' <javier.martin@vista-silicon.com>,
	'Sensoray Linux Development' <linux-dev@sensoray.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Sachin Kamat' <sachin.kamat@linaro.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	mitov@issp.bas.bg, 'Hans Verkuil' <hans.verkuil@cisco.com>
References: <1340537178-18768-1-git-send-email-hverkuil@xs4all.nl>
 <451838d4b2e404fdc4babf044ac6326dfc5790d7.1340536092.git.hans.verkuil@cisco.com>
In-reply-to: <451838d4b2e404fdc4babf044ac6326dfc5790d7.1340536092.git.hans.verkuil@cisco.com>
Subject: RE: [RFC PATCH 25/26] s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS
Date: Tue, 26 Jun 2012 11:35:33 +0200
Message-id: <000101cd537f$0af765b0$20e63110$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your patch. I have tested it on our hardware and MFC works.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

> -----Original Message-----
> From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> Sent: 24 June 2012 13:26
> To: linux-media@vger.kernel.org
> Cc: Andy Walls; Guennadi Liakhovetski; Mauro Carvalho Chehab; Scott Jiang;
> Manjunatha Halli; Manjunath Hadli; Anatolij Gustschin; Javier Martin;
> Sensoray Linux Development; Sylwester Nawrocki; Kamil Debski; Andrzej
> Pietrasiewicz; Sachin Kamat; Tomasz Stanislawski; mitov@issp.bas.bg; Hans
> Verkuil
> Subject: [RFC PATCH 25/26] s5p-mfc: remove V4L2_FL_LOCK_ALL_FOPS
> 
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add proper locking to the file operations, allowing for the removal
> of the V4L2_FL_LOCK_ALL_FOPS flag.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc.c |   19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc.c
> b/drivers/media/video/s5p-mfc/s5p_mfc.c
> index 9bb68e7..e3e616d 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc.c
> @@ -645,6 +645,8 @@ static int s5p_mfc_open(struct file *file)
>  	int ret = 0;
> 
>  	mfc_debug_enter();
> +	if (mutex_lock_interruptible(&dev->mfc_mutex))
> +		return -ERESTARTSYS;
>  	dev->num_inst++;	/* It is guarded by mfc_mutex in vfd */
>  	/* Allocate memory for context */
>  	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> @@ -765,6 +767,7 @@ static int s5p_mfc_open(struct file *file)
>  		goto err_queue_init;
>  	}
>  	init_waitqueue_head(&ctx->queue);
> +	mutex_unlock(&dev->mfc_mutex);
>  	mfc_debug_leave();
>  	return ret;
>  	/* Deinit when failure occured */
> @@ -790,6 +793,7 @@ err_no_ctx:
>  	kfree(ctx);
>  err_alloc:
>  	dev->num_inst--;
> +	mutex_unlock(&dev->mfc_mutex);
>  	mfc_debug_leave();
>  	return ret;
>  }
> @@ -802,6 +806,7 @@ static int s5p_mfc_release(struct file *file)
>  	unsigned long flags;
> 
>  	mfc_debug_enter();
> +	mutex_lock(&dev->mfc_mutex);
>  	s5p_mfc_clock_on();
>  	vb2_queue_release(&ctx->vq_src);
>  	vb2_queue_release(&ctx->vq_dst);
> @@ -855,6 +860,7 @@ static int s5p_mfc_release(struct file *file)
>  	v4l2_fh_exit(&ctx->fh);
>  	kfree(ctx);
>  	mfc_debug_leave();
> +	mutex_unlock(&dev->mfc_mutex);
>  	return 0;
>  }
> 
> @@ -869,6 +875,7 @@ static unsigned int s5p_mfc_poll(struct file *file,
>  	unsigned int rc = 0;
>  	unsigned long flags;
> 
> +	mutex_lock(&dev->mfc_mutex);
>  	src_q = &ctx->vq_src;
>  	dst_q = &ctx->vq_dst;
>  	/*
> @@ -902,6 +909,7 @@ static unsigned int s5p_mfc_poll(struct file *file,
>  		rc |= POLLIN | POLLRDNORM;
>  	spin_unlock_irqrestore(&dst_q->done_lock, flags);
>  end:
> +	mutex_unlock(&dev->mfc_mutex);
>  	return rc;
>  }
> 
> @@ -909,8 +917,12 @@ end:
>  static int s5p_mfc_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct s5p_mfc_ctx *ctx = fh_to_ctx(file->private_data);
> +	struct s5p_mfc_dev *dev = ctx->dev;
>  	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
>  	int ret;
> +
> +	if (mutex_lock_interruptible(&dev->mfc_mutex))
> +		return -ERESTARTSYS;
>  	if (offset < DST_QUEUE_OFF_BASE) {
>  		mfc_debug(2, "mmaping source\n");
>  		ret = vb2_mmap(&ctx->vq_src, vma);
> @@ -919,6 +931,7 @@ static int s5p_mfc_mmap(struct file *file, struct
> vm_area_struct *vma)
>  		vma->vm_pgoff -= (DST_QUEUE_OFF_BASE >> PAGE_SHIFT);
>  		ret = vb2_mmap(&ctx->vq_dst, vma);
>  	}
> +	mutex_unlock(&dev->mfc_mutex);
>  	return ret;
>  }
> 
> @@ -1034,10 +1047,6 @@ static int s5p_mfc_probe(struct platform_device
> *pdev)
>  	vfd->ioctl_ops	= get_dec_v4l2_ioctl_ops();
>  	vfd->release	= video_device_release,
>  	vfd->lock	= &dev->mfc_mutex;
> -	/* Locking in file operations other than ioctl should be done
> -	   by the driver, not the V4L2 core.
> -	   This driver needs auditing so that this flag can be removed. */
> -	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
>  	vfd->v4l2_dev	= &dev->v4l2_dev;
>  	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_DEC_NAME);
>  	dev->vfd_dec	= vfd;
> @@ -1062,8 +1071,6 @@ static int s5p_mfc_probe(struct platform_device
> *pdev)
>  	vfd->ioctl_ops	= get_enc_v4l2_ioctl_ops();
>  	vfd->release	= video_device_release,
>  	vfd->lock	= &dev->mfc_mutex;
> -	/* This should not be necessary */
> -	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
>  	vfd->v4l2_dev	= &dev->v4l2_dev;
>  	snprintf(vfd->name, sizeof(vfd->name), "%s", S5P_MFC_ENC_NAME);
>  	dev->vfd_enc	= vfd;
> --
> 1.7.10

