Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:40982 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2FZJfn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 05:35:43 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M67009P2XCI1H30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:36:18 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync3.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0M6700MCEXBBZR50@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 26 Jun 2012 10:35:42 +0100 (BST)
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
 <0c5af6204bf82f2a7acd17376f61bac13cfc2547.1340536092.git.hans.verkuil@cisco.com>
In-reply-to: <0c5af6204bf82f2a7acd17376f61bac13cfc2547.1340536092.git.hans.verkuil@cisco.com>
Subject: RE: [RFC PATCH 21/26] s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
Date: Tue, 26 Jun 2012 11:35:37 +0200
Message-id: <000201cd537f$0d03fe90$270bfbb0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for your patch. I have tested it on our hardware and G2D works.

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
> Subject: [RFC PATCH 21/26] s5p-g2d: remove V4L2_FL_LOCK_ALL_FOPS
> 
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add proper locking to the file operations, allowing for the removal
> of the V4L2_FL_LOCK_ALL_FOPS flag.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-g2d/g2d.c |   27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-g2d/g2d.c b/drivers/media/video/s5p-
> g2d/g2d.c
> index 7c98ee7..d8cf1db 100644
> --- a/drivers/media/video/s5p-g2d/g2d.c
> +++ b/drivers/media/video/s5p-g2d/g2d.c
> @@ -248,9 +248,14 @@ static int g2d_open(struct file *file)
>  	ctx->in		= def_frame;
>  	ctx->out	= def_frame;
> 
> +	if (mutex_lock_interruptible(&dev->mutex)) {
> +		kfree(ctx);
> +		return -ERESTARTSYS;
> +	}
>  	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx, &queue_init);
>  	if (IS_ERR(ctx->m2m_ctx)) {
>  		ret = PTR_ERR(ctx->m2m_ctx);
> +		mutex_unlock(&dev->mutex);
>  		kfree(ctx);
>  		return ret;
>  	}
> @@ -264,6 +269,7 @@ static int g2d_open(struct file *file)
>  	v4l2_ctrl_handler_setup(&ctx->ctrl_handler);
> 
>  	ctx->fh.ctrl_handler = &ctx->ctrl_handler;
> +	mutex_unlock(&dev->mutex);
> 
>  	v4l2_info(&dev->v4l2_dev, "instance opened\n");
>  	return 0;
> @@ -401,13 +407,26 @@ static int vidioc_s_fmt(struct file *file, void
> *prv, struct v4l2_format *f)
>  static unsigned int g2d_poll(struct file *file, struct poll_table_struct
> *wait)
>  {
>  	struct g2d_ctx *ctx = fh2ctx(file->private_data);
> -	return v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	struct g2d_dev *dev = ctx->dev;
> +	unsigned int res;
> +
> +	mutex_lock(&dev->mutex);
> +	res = v4l2_m2m_poll(file, ctx->m2m_ctx, wait);
> +	mutex_unlock(&dev->mutex);
> +	return res;
>  }
> 
>  static int g2d_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct g2d_ctx *ctx = fh2ctx(file->private_data);
> -	return v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +	struct g2d_dev *dev = ctx->dev;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&dev->mutex))
> +		return -ERESTARTSYS;
> +	ret = v4l2_m2m_mmap(file, ctx->m2m_ctx, vma);
> +	mutex_unlock(&dev->mutex);
> +	return ret;
>  }
> 
>  static int vidioc_reqbufs(struct file *file, void *priv,
> @@ -748,10 +767,6 @@ static int g2d_probe(struct platform_device *pdev)
>  		goto unreg_v4l2_dev;
>  	}
>  	*vfd = g2d_videodev;
> -	/* Locking in file operations other than ioctl should be done
> -	   by the driver, not the V4L2 core.
> -	   This driver needs auditing so that this flag can be removed. */
> -	set_bit(V4L2_FL_LOCK_ALL_FOPS, &vfd->flags);
>  	vfd->lock = &dev->mutex;
>  	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
>  	if (ret) {
> --
> 1.7.10

