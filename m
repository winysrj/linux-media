Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:17036 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756201AbaICLc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 07:32:58 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBB00J9FPEWST90@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 07:32:56 -0400 (EDT)
Date: Wed, 03 Sep 2014 08:32:51 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, stoth@kernellabs.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 15/20] cx23885: convert to vb2
Message-id: <20140903083251.5c5f286c.m.chehab@samsung.com>
In-reply-to: <1408010045-24016-16-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
 <1408010045-24016-16-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 Aug 2014 11:54:00 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> As usual, this patch is very large due to the fact that half a vb2 conversion
> isn't possible. And since this affects 417, alsa, core, dvb, vbi and video the
> changes are all over.
> 
> What made this more difficult was the peculiar way the risc program was setup.
> The driver allowed for running out of buffers in which case the DMA would stop
> and restart when the next buffer was queued. There was also a complicated
> timeout system for when buffers weren't filled. This was replaced by a much
> simpler scheme where there is always one buffer around and the DMA will just
> cycle that buffer until a new buffer is queued. In that case the previous
> buffer will be chained to the new buffer. An interrupt is generated at the
> start of the new buffer telling the driver that the previous buffer can be
> passed on to userspace.
> 
> Much simpler and more robust. The old code seems to be copied from the
> cx88 driver. But it didn't fit the vb2 ops very well and replacing it with
> the new scheme made the code easier to understand. Not to mention that this
> patch removes 600 lines of code.

Great job!

Still, there are some issue. In special, the RISC changes should go
to a separate patch, as such changes have the potential of causing
some regressions. See below.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/pci/cx23885/Kconfig         |   4 +-
>  drivers/media/pci/cx23885/altera-ci.c     |   4 +-
>  drivers/media/pci/cx23885/cx23885-417.c   | 312 +++++-------
>  drivers/media/pci/cx23885/cx23885-alsa.c  |   4 +-
>  drivers/media/pci/cx23885/cx23885-core.c  | 309 ++++--------
>  drivers/media/pci/cx23885/cx23885-dvb.c   | 131 +++--
>  drivers/media/pci/cx23885/cx23885-vbi.c   | 275 +++++-----
>  drivers/media/pci/cx23885/cx23885-video.c | 810 ++++++++----------------------
>  drivers/media/pci/cx23885/cx23885.h       |  61 +--
>  9 files changed, 657 insertions(+), 1253 deletions(-)
> 
> diff --git a/drivers/media/pci/cx23885/Kconfig b/drivers/media/pci/cx23885/Kconfig
> index e12c006..38c3b7b 100644
> --- a/drivers/media/pci/cx23885/Kconfig
> +++ b/drivers/media/pci/cx23885/Kconfig
> @@ -7,8 +7,8 @@ config VIDEO_CX23885
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	depends on RC_CORE
> -	select VIDEOBUF_DVB
> -	select VIDEOBUF_DMA_SG
> +	select VIDEOBUF2_DVB
> +	select VIDEOBUF2_DMA_SG
>  	select VIDEO_CX25840
>  	select VIDEO_CX2341X
>  	select DVB_DIB7000P if MEDIA_SUBDRV_AUTOSELECT
> diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
> index 2926f7f..f57b333 100644
> --- a/drivers/media/pci/cx23885/altera-ci.c
> +++ b/drivers/media/pci/cx23885/altera-ci.c
> @@ -52,8 +52,8 @@
>   * |  DATA7|  DATA6|  DATA5|  DATA4|  DATA3|  DATA2|  DATA1|  DATA0|
>   * +-------+-------+-------+-------+-------+-------+-------+-------+
>   */
> -#include <media/videobuf-dma-sg.h>
> -#include <media/videobuf-dvb.h>
> +#include <dvb_demux.h>
> +#include <dvb_frontend.h>
>  #include "altera-ci.h"
>  #include "dvb_ca_en50221.h"
>  
> diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
> index 0948b44..a17238a 100644
> --- a/drivers/media/pci/cx23885/cx23885-417.c
> +++ b/drivers/media/pci/cx23885/cx23885-417.c
> @@ -1142,47 +1142,100 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
>  
>  /* ------------------------------------------------------------------ */
>  
> -static int bb_buf_setup(struct videobuf_queue *q,
> -	unsigned int *count, unsigned int *size)
> +static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +			   unsigned int *num_buffers, unsigned int *num_planes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	struct cx23885_fh *fh = q->priv_data;
> +	struct cx23885_dev *dev = q->drv_priv;
>  
> -	fh->q_dev->ts1.ts_packet_size  = mpeglinesize;
> -	fh->q_dev->ts1.ts_packet_count = mpeglines;
> +	dev->ts1.ts_packet_size  = mpeglinesize;
> +	dev->ts1.ts_packet_count = mpeglines;
> +	*num_planes = 1;
> +	sizes[0] = mpeglinesize * mpeglines;
> +	*num_buffers = mpegbufs;
> +	return 0;
> +}
>  
> -	*size = fh->q_dev->ts1.ts_packet_size * fh->q_dev->ts1.ts_packet_count;
> -	*count = mpegbufs;
> +static int buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf =
> +		container_of(vb, struct cx23885_buffer, vb);
>  
> -	return 0;
> +	return cx23885_buf_prepare(buf, &dev->ts1);
>  }
>  
> -static int bb_buf_prepare(struct videobuf_queue *q,
> -	struct videobuf_buffer *vb, enum v4l2_field field)
> +static void buffer_finish(struct vb2_buffer *vb)
>  {
> -	struct cx23885_fh *fh = q->priv_data;
> -	return cx23885_buf_prepare(q, &fh->q_dev->ts1,
> -		(struct cx23885_buffer *)vb,
> -		field);
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
> +
> +	cx23885_free_buffer(dev, buf);
> +
> +	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
>  }
>  
> -static void bb_buf_queue(struct videobuf_queue *q,
> -	struct videobuf_buffer *vb)
> +static void buffer_queue(struct vb2_buffer *vb)
>  {
> -	struct cx23885_fh *fh = q->priv_data;
> -	cx23885_buf_queue(&fh->q_dev->ts1, (struct cx23885_buffer *)vb);
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer   *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +
> +	cx23885_buf_queue(&dev->ts1, buf);
> +}
> +
> +static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct cx23885_dev *dev = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &dev->ts1.mpegq;
> +	unsigned long flags;
> +	int ret;
> +
> +	ret = cx23885_initialize_codec(dev, 1);
> +	if (ret == 0) {
> +		struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
> +
> +		cx23885_start_dma(&dev->ts1, dmaq, buf);
> +		return 0;
> +	}
> +	spin_lock_irqsave(&dev->slock, flags);
> +	while (!list_empty(&dmaq->active)) {
> +		struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
> +
> +		list_del(&buf->queue);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_QUEUED);
> +	}
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +	return ret;
>  }
>  
> -static void bb_buf_release(struct videobuf_queue *q,
> -	struct videobuf_buffer *vb)
> +static void cx23885_stop_streaming(struct vb2_queue *q)
>  {
> -	cx23885_free_buffer(q, (struct cx23885_buffer *)vb);
> +	struct cx23885_dev *dev = q->drv_priv;
> +
> +	/* stop mpeg capture */
> +	cx23885_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
> +			CX23885_END_NOW, CX23885_MPEG_CAPTURE,
> +			CX23885_RAW_BITS_NONE);
> +
> +	msleep(500);
> +	cx23885_417_check_encoder(dev);
> +	cx23885_cancel_buffers(&dev->ts1);
>  }
>  
> -static struct videobuf_queue_ops cx23885_qops = {
> -	.buf_setup    = bb_buf_setup,
> -	.buf_prepare  = bb_buf_prepare,
> -	.buf_queue    = bb_buf_queue,
> -	.buf_release  = bb_buf_release,
> +static struct vb2_ops cx23885_qops = {
> +	.queue_setup    = queue_setup,
> +	.buf_prepare  = buffer_prepare,
> +	.buf_finish = buffer_finish,
> +	.buf_queue    = buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = cx23885_start_streaming,
> +	.stop_streaming = cx23885_stop_streaming,
>  };
>  
>  /* ------------------------------------------------------------------ */
> @@ -1320,7 +1373,6 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *f)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh  *fh  = file->private_data;
>  
>  	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>  	f->fmt.pix.bytesperline = 0;
> @@ -1329,9 +1381,9 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	f->fmt.pix.colorspace   = 0;
>  	f->fmt.pix.width        = dev->ts1.width;
>  	f->fmt.pix.height       = dev->ts1.height;
> -	f->fmt.pix.field        = fh->mpegq.field;
> -	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d, f: %d\n",
> -		dev->ts1.width, dev->ts1.height, fh->mpegq.field);
> +	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;

Why? There are other supported formats, right?

> +	dprintk(1, "VIDIOC_G_FMT: w: %d, h: %d\n",
> +		dev->ts1.width, dev->ts1.height);
>  	return 0;
>  }
>  
> @@ -1339,15 +1391,15 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>  				struct v4l2_format *f)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh  *fh  = file->private_data;
>  
>  	f->fmt.pix.pixelformat  = V4L2_PIX_FMT_MPEG;
>  	f->fmt.pix.bytesperline = 0;
>  	f->fmt.pix.sizeimage    =
>  		dev->ts1.ts_packet_size * dev->ts1.ts_packet_count;
>  	f->fmt.pix.colorspace   = 0;
> -	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d, f: %d\n",
> -		dev->ts1.width, dev->ts1.height, fh->mpegq.field);
> +	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;

Why? There are other supported formats, right?

> +	dprintk(1, "VIDIOC_TRY_FMT: w: %d, h: %d\n",
> +		dev->ts1.width, dev->ts1.height);
>  	return 0;
>  }
>  
> @@ -1361,58 +1413,12 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	f->fmt.pix.sizeimage    =
>  		dev->ts1.ts_packet_size * dev->ts1.ts_packet_count;
>  	f->fmt.pix.colorspace   = 0;
> +	f->fmt.pix.field        = V4L2_FIELD_INTERLACED;
>  	dprintk(1, "VIDIOC_S_FMT: w: %d, h: %d, f: %d\n",
>  		f->fmt.pix.width, f->fmt.pix.height, f->fmt.pix.field);
>  	return 0;
>  }
>  
> -static int vidioc_reqbufs(struct file *file, void *priv,
> -				struct v4l2_requestbuffers *p)
> -{
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	return videobuf_reqbufs(&fh->mpegq, p);
> -}
> -
> -static int vidioc_querybuf(struct file *file, void *priv,
> -				struct v4l2_buffer *p)
> -{
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	return videobuf_querybuf(&fh->mpegq, p);
> -}
> -
> -static int vidioc_qbuf(struct file *file, void *priv,
> -				struct v4l2_buffer *p)
> -{
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	return videobuf_qbuf(&fh->mpegq, p);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *b)
> -{
> -	struct cx23885_fh  *fh  = priv;
> -
> -	return videobuf_dqbuf(&fh->mpegq, b, file->f_flags & O_NONBLOCK);
> -}
> -
> -
> -static int vidioc_streamon(struct file *file, void *priv,
> -				enum v4l2_buf_type i)
> -{
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	return videobuf_streamon(&fh->mpegq);
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	return videobuf_streamoff(&fh->mpegq);
> -}
> -
>  static int vidioc_log_status(struct file *file, void *priv)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> @@ -1424,120 +1430,14 @@ static int vidioc_log_status(struct file *file, void *priv)
>  	return 0;
>  }
>  
> -static int mpeg_open(struct file *file)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_fh *fh;
> -
> -	dprintk(2, "%s()\n", __func__);
> -
> -	/* allocate + initialize per filehandle data */
> -	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
> -	if (!fh)
> -		return -ENOMEM;
> -
> -	v4l2_fh_init(&fh->fh, vdev);
> -	file->private_data = fh;
> -	fh->q_dev      = dev;
> -
> -	videobuf_queue_sg_init(&fh->mpegq, &cx23885_qops,
> -			    &dev->pci->dev, &dev->ts1.slock,
> -			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -			    V4L2_FIELD_INTERLACED,
> -			    sizeof(struct cx23885_buffer),
> -			    fh, NULL);
> -	v4l2_fh_add(&fh->fh);
> -	return 0;
> -}
> -
> -static int mpeg_release(struct file *file)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh  *fh  = file->private_data;
> -
> -	dprintk(2, "%s()\n", __func__);
> -
> -	/* FIXME: Review this crap */
> -	/* Shut device down on last close */
> -	if (atomic_cmpxchg(&fh->v4l_reading, 1, 0) == 1) {
> -		if (atomic_dec_return(&dev->v4l_reader_count) == 0) {
> -			/* stop mpeg capture */
> -			cx23885_api_cmd(dev, CX2341X_ENC_STOP_CAPTURE, 3, 0,
> -				CX23885_END_NOW, CX23885_MPEG_CAPTURE,
> -				CX23885_RAW_BITS_NONE);
> -
> -			msleep(500);
> -			cx23885_417_check_encoder(dev);
> -
> -			cx23885_cancel_buffers(&dev->ts1);
> -		}
> -	}
> -
> -	if (fh->mpegq.streaming)
> -		videobuf_streamoff(&fh->mpegq);
> -	if (fh->mpegq.reading)
> -		videobuf_read_stop(&fh->mpegq);
> -
> -	videobuf_mmap_free(&fh->mpegq);
> -	v4l2_fh_del(&fh->fh);
> -	v4l2_fh_exit(&fh->fh);
> -	file->private_data = NULL;
> -	kfree(fh);
> -
> -	return 0;
> -}
> -
> -static ssize_t mpeg_read(struct file *file, char __user *data,
> -	size_t count, loff_t *ppos)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	dprintk(2, "%s()\n", __func__);
> -
> -	/* Deal w/ A/V decoder * and mpeg encoder sync issues. */
> -	/* Start mpeg encoder on first read. */
> -	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
> -		if (atomic_inc_return(&dev->v4l_reader_count) == 1) {
> -			if (cx23885_initialize_codec(dev, 1) < 0)
> -				return -EINVAL;
> -		}
> -	}
> -
> -	return videobuf_read_stream(&fh->mpegq, data, count, ppos, 0,
> -				    file->f_flags & O_NONBLOCK);
> -}
> -
> -static unsigned int mpeg_poll(struct file *file,
> -	struct poll_table_struct *wait)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	dprintk(2, "%s\n", __func__);
> -
> -	return videobuf_poll_stream(file, &fh->mpegq, wait);
> -}
> -
> -static int mpeg_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	dprintk(2, "%s()\n", __func__);
> -
> -	return videobuf_mmap_mapper(&fh->mpegq, vma);
> -}
> -
>  static struct v4l2_file_operations mpeg_fops = {
>  	.owner	       = THIS_MODULE,
> -	.open	       = mpeg_open,
> -	.release       = mpeg_release,
> -	.read	       = mpeg_read,
> -	.poll          = mpeg_poll,
> -	.mmap	       = mpeg_mmap,
> +	.open           = v4l2_fh_open,
> +	.release        = vb2_fop_release,
> +	.read           = vb2_fop_read,
> +	.poll		= vb2_fop_poll,
>  	.unlocked_ioctl = video_ioctl2,
> +	.mmap           = vb2_fop_mmap,
>  };
>  
>  static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
> @@ -1555,12 +1455,13 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
>  	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
>  	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
>  	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
> -	.vidioc_reqbufs		 = vidioc_reqbufs,
> -	.vidioc_querybuf	 = vidioc_querybuf,
> -	.vidioc_qbuf		 = vidioc_qbuf,
> -	.vidioc_dqbuf		 = vidioc_dqbuf,
> -	.vidioc_streamon	 = vidioc_streamon,
> -	.vidioc_streamoff	 = vidioc_streamoff,
> +	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
> +	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf      = vb2_ioctl_querybuf,
> +	.vidioc_qbuf          = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
> +	.vidioc_streamon      = vb2_ioctl_streamon,
> +	.vidioc_streamoff     = vb2_ioctl_streamoff,
>  	.vidioc_log_status	 = vidioc_log_status,
>  #ifdef CONFIG_VIDEO_ADV_DEBUG
>  	.vidioc_g_chip_info	 = cx23885_g_chip_info,
> @@ -1617,6 +1518,7 @@ int cx23885_417_register(struct cx23885_dev *dev)
>  	/* FIXME: Port1 hardcoded here */
>  	int err = -ENODEV;
>  	struct cx23885_tsport *tsport = &dev->ts1;
> +	struct vb2_queue *q;
>  
>  	dprintk(1, "%s()\n", __func__);
>  
> @@ -1644,8 +1546,24 @@ int cx23885_417_register(struct cx23885_dev *dev)
>  	/* Allocate and initialize V4L video device */
>  	dev->v4l_device = cx23885_video_dev_alloc(tsport,
>  		dev->pci, &cx23885_mpeg_template, "mpeg");
> +	q = &dev->vb2_mpegq;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +	q->gfp_flags = GFP_DMA32;
> +	q->min_buffers_needed = 2;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct cx23885_buffer);
> +	q->ops = &cx23885_qops;
> +	q->mem_ops = &vb2_dma_sg_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &dev->lock;
> +
> +	err = vb2_queue_init(q);
> +	if (err < 0)
> +		return err;
>  	video_set_drvdata(dev->v4l_device, dev);
>  	dev->v4l_device->lock = &dev->lock;
> +	dev->v4l_device->queue = q;
>  	err = video_register_device(dev->v4l_device,
>  		VFL_TYPE_GRABBER, -1);
>  	if (err < 0) {
> diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
> index 31dbf0c..cbbf9ad 100644
> --- a/drivers/media/pci/cx23885/cx23885-alsa.c
> +++ b/drivers/media/pci/cx23885/cx23885-alsa.c
> @@ -393,6 +393,7 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
>  		return -ENOMEM;
>  
>  	buf->bpl = chip->period_size;
> +	chip->buf = buf;
>  
>  	ret = cx23885_alsa_dma_init(chip,
>  			(PAGE_ALIGN(chip->dma_size) >> PAGE_SHIFT));
> @@ -413,8 +414,6 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
>  	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
>  	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
>  
> -	chip->buf = buf;
> -
>  	substream->runtime->dma_area = chip->buf->vaddr;
>  	substream->runtime->dma_bytes = chip->dma_size;
>  	substream->runtime->dma_addr = 0;
> @@ -423,6 +422,7 @@ static int snd_cx23885_hw_params(struct snd_pcm_substream *substream,
>  
>  error:
>  	kfree(buf);
> +	chip->buf = NULL;
>  	return ret;
>  }
>  
> diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
> index 075b28e..2599af1 100644
> --- a/drivers/media/pci/cx23885/cx23885-core.c
> +++ b/drivers/media/pci/cx23885/cx23885-core.c
> @@ -420,39 +420,23 @@ static int cx23885_risc_decode(u32 risc)
>  	return incr[risc >> 28] ? incr[risc >> 28] : 1;
>  }
>  
> -void cx23885_wakeup(struct cx23885_tsport *port,
> +static void cx23885_wakeup(struct cx23885_tsport *port,
>  			   struct cx23885_dmaqueue *q, u32 count)
>  {
>  	struct cx23885_dev *dev = port->dev;
>  	struct cx23885_buffer *buf;
> -	int bc;
>  
> -	for (bc = 0;; bc++) {
> -		if (list_empty(&q->active))
> -			break;
> -		buf = list_entry(q->active.next,
> -				 struct cx23885_buffer, vb.queue);
> -
> -		/* count comes from the hw and is is 16bit wide --
> -		 * this trick handles wrap-arounds correctly for
> -		 * up to 32767 buffers in flight... */
> -		if ((s16) (count - buf->count) < 0)
> -			break;
> -
> -		v4l2_get_timestamp(&buf->vb.ts);
> -		dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.i,
> -			count, buf->count);
> -		buf->vb.state = VIDEOBUF_DONE;
> -		list_del(&buf->vb.queue);
> -		wake_up(&buf->vb.done);
> -	}
>  	if (list_empty(&q->active))
> -		del_timer(&q->timeout);
> -	else
> -		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
> -	if (bc != 1)
> -		printk(KERN_WARNING "%s: %d buffers handled (should be 1)\n",
> -		       __func__, bc);
> +		return;
> +	buf = list_entry(q->active.next,
> +			 struct cx23885_buffer, queue);
> +
> +	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> +	buf->vb.v4l2_buf.sequence = q->count++;
> +	dprintk(1, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
> +		count, q->count);
> +	list_del(&buf->queue);
> +	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>  }
>  
>  int cx23885_sram_channel_setup(struct cx23885_dev *dev,
> @@ -482,8 +466,8 @@ int cx23885_sram_channel_setup(struct cx23885_dev *dev,
>  		lines = 6;
>  	BUG_ON(lines < 2);
>  
> -	cx_write(8 + 0, RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
> -	cx_write(8 + 4, 8);
> +	cx_write(8 + 0, RISC_JUMP | RISC_CNT_RESET);
> +	cx_write(8 + 4, 12);

The above doesn't sound as being a pure vb2 conversion, and might cause
regressions, as we're changing the channel setups. I would very much
prefer to have such changes on a separate changeset, as it makes easier
to do bisect if ever needed.

>  	cx_write(8 + 8, 0);
>  
>  	/* write CDT */
> @@ -699,10 +683,6 @@ static int get_resources(struct cx23885_dev *dev)
>  	return -EBUSY;
>  }
>  
> -static void cx23885_timeout(unsigned long data);
> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> -				u32 reg, u32 mask, u32 value);
> -
>  static int cx23885_init_tsport(struct cx23885_dev *dev,
>  	struct cx23885_tsport *port, int portno)
>  {
> @@ -719,11 +699,6 @@ static int cx23885_init_tsport(struct cx23885_dev *dev,
>  	port->nr = portno;
>  
>  	INIT_LIST_HEAD(&port->mpegq.active);
> -	INIT_LIST_HEAD(&port->mpegq.queued);
> -	port->mpegq.timeout.function = cx23885_timeout;
> -	port->mpegq.timeout.data = (unsigned long)port;
> -	init_timer(&port->mpegq.timeout);
> -
>  	mutex_init(&port->frontends.lock);
>  	INIT_LIST_HEAD(&port->frontends.felist);
>  	port->frontends.active_fe_id = 0;
> @@ -776,9 +751,6 @@ static int cx23885_init_tsport(struct cx23885_dev *dev,
>  		BUG();
>  	}
>  
> -	cx23885_risc_stopper(dev->pci, &port->mpegq.stopper,
> -		     port->reg_dma_ctl, port->dma_ctl_val, 0x00);
> -
>  	return 0;
>  }
>  
> @@ -1089,11 +1061,18 @@ static void cx23885_dev_unregister(struct cx23885_dev *dev)
>  static __le32 *cx23885_risc_field(__le32 *rp, struct scatterlist *sglist,
>  			       unsigned int offset, u32 sync_line,
>  			       unsigned int bpl, unsigned int padding,
> -			       unsigned int lines,  unsigned int lpi)
> +			       unsigned int lines,  unsigned int lpi, bool jump)
>  {
>  	struct scatterlist *sg;
>  	unsigned int line, todo, sol;
>  
> +
> +	if (jump) {
> +		*(rp++) = cpu_to_le32(RISC_JUMP);
> +		*(rp++) = cpu_to_le32(0);
> +		*(rp++) = cpu_to_le32(0); /* bits 63-32 */
> +	}
> +

Here it seem clear: you're now adding a code to support different
frame interlacing layouts, but the best is to have such changes on
a separate changeset, as this is one thing that we may have troubles
in the future.

The way I see is that we might start having a flood of complains about
regressions, and all of them will point to this single patch, making
really hard to identify what part of the change broke it.

So, let's split those risc changes on a pre (or post) patch, making
easier if someone needs to report an issue, for us to track what
patch broke it.

>  	/* sync instruction */
>  	if (sync_line != NO_SYNC_LINE)
>  		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
> @@ -1168,7 +1147,7 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	/* write and jump need and extra dword */
>  	instructions  = fields * (1 + ((bpl + padding) * lines)
>  		/ PAGE_SIZE + lines);
> -	instructions += 2;
> +	instructions += 5;
>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>  	if (rc < 0)
>  		return rc;
> @@ -1177,10 +1156,10 @@ int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	rp = risc->cpu;
>  	if (UNSET != top_offset)
>  		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
> -					bpl, padding, lines, 0);
> +					bpl, padding, lines, 0, true);
>  	if (UNSET != bottom_offset)
>  		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
> -					bpl, padding, lines, 0);
> +					bpl, padding, lines, 0, UNSET == top_offset);
>  
>  	/* save pointer to jmp instruction address */
>  	risc->jmp = rp;
> @@ -1204,7 +1183,7 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
>  	   than PAGE_SIZE */
>  	/* Jump and write need an extra dword */
>  	instructions  = 1 + (bpl * lines) / PAGE_SIZE + lines;
> -	instructions += 1;
> +	instructions += 4;
>  
>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>  	if (rc < 0)
> @@ -1213,7 +1192,7 @@ int cx23885_risc_databuffer(struct pci_dev *pci,
>  	/* write risc instructions */
>  	rp = risc->cpu;
>  	rp = cx23885_risc_field(rp, sglist, 0, NO_SYNC_LINE,
> -				bpl, 0, lines, lpi);
> +				bpl, 0, lines, lpi, lpi == 0);
>  
>  	/* save pointer to jmp instruction address */
>  	risc->jmp = rp;
> @@ -1243,7 +1222,7 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	/* write and jump need and extra dword */
>  	instructions  = fields * (1 + ((bpl + padding) * lines)
>  		/ PAGE_SIZE + lines);
> -	instructions += 2;
> +	instructions += 5;
>  	rc = btcx_riscmem_alloc(pci, risc, instructions*12);
>  	if (rc < 0)
>  		return rc;
> @@ -1253,12 +1232,12 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	/* Sync to line 6, so US CC line 21 will appear in line '12'
>  	 * in the userland vbi payload */
>  	if (UNSET != top_offset)
> -		rp = cx23885_risc_field(rp, sglist, top_offset, 6,
> -					bpl, padding, lines, 0);
> +		rp = cx23885_risc_field(rp, sglist, top_offset, 0,
> +					bpl, padding, lines, 0, true);
>  
>  	if (UNSET != bottom_offset)
> -		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x207,
> -					bpl, padding, lines, 0);
> +		rp = cx23885_risc_field(rp, sglist, bottom_offset, 0x200,
> +					bpl, padding, lines, 0, UNSET == top_offset);

Why to change the 4th argument of cx23885_risc_field() call?

>  
>  
>  
> @@ -1269,38 +1248,10 @@ int cx23885_risc_vbibuffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  }
>  
>  
> -int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> -				u32 reg, u32 mask, u32 value)

What happened with this function?

> +void cx23885_free_buffer(struct cx23885_dev *dev, struct cx23885_buffer *buf)
>  {
> -	__le32 *rp;
> -	int rc;
> -
> -	rc = btcx_riscmem_alloc(pci, risc, 4*16);
> -	if (rc < 0)
> -		return rc;
> -
> -	/* write risc instructions */
> -	rp = risc->cpu;
> -	*(rp++) = cpu_to_le32(RISC_WRITECR  | RISC_IRQ2);
> -	*(rp++) = cpu_to_le32(reg);
> -	*(rp++) = cpu_to_le32(value);
> -	*(rp++) = cpu_to_le32(mask);
> -	*(rp++) = cpu_to_le32(RISC_JUMP);
> -	*(rp++) = cpu_to_le32(risc->dma);
> -	*(rp++) = cpu_to_le32(0); /* bits 63-32 */
> -	return 0;
> -}
> -
> -void cx23885_free_buffer(struct videobuf_queue *q, struct cx23885_buffer *buf)
> -{
> -	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
> -
>  	BUG_ON(in_interrupt());
> -	videobuf_waiton(q, &buf->vb, 0, 0);
> -	videobuf_dma_unmap(q->dev, dma);
> -	videobuf_dma_free(dma);
> -	btcx_riscmem_free(to_pci_dev(q->dev), &buf->risc);
> -	buf->vb.state = VIDEOBUF_NEEDS_INIT;
> +	btcx_riscmem_free(dev->pci, &buf->risc);
>  }
>  
>  static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
> @@ -1355,7 +1306,7 @@ static void cx23885_tsport_reg_dump(struct cx23885_tsport *port)
>  		port->reg_ts_int_msk, cx_read(port->reg_ts_int_msk));
>  }
>  
> -static int cx23885_start_dma(struct cx23885_tsport *port,
> +int cx23885_start_dma(struct cx23885_tsport *port,
>  			     struct cx23885_dmaqueue *q,
>  			     struct cx23885_buffer   *buf)
>  {
> @@ -1363,7 +1314,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
>  	u32 reg;
>  
>  	dprintk(1, "%s() w: %d, h: %d, f: %d\n", __func__,
> -		buf->vb.width, buf->vb.height, buf->vb.field);
> +		dev->width, dev->height, dev->field);
>  
>  	/* Stop the fifo and risc engine for this port */
>  	cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
> @@ -1379,7 +1330,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
>  	}
>  
>  	/* write TS length to chip */
> -	cx_write(port->reg_lngth, buf->vb.width);
> +	cx_write(port->reg_lngth, port->ts_packet_size);
>  
>  	if ((!(cx23885_boards[dev->board].portb & CX23885_MPEG_DVB)) &&
>  		(!(cx23885_boards[dev->board].portc & CX23885_MPEG_DVB))) {
> @@ -1408,7 +1359,7 @@ static int cx23885_start_dma(struct cx23885_tsport *port,
>  	/* NOTE: this is 2 (reserved) for portb, does it matter? */
>  	/* reset counter to zero */
>  	cx_write(port->reg_gpcnt_ctl, 3);
> -	q->count = 1;
> +	q->count = 0;
>  
>  	/* Set VIDB pins to input */
>  	if (cx23885_boards[dev->board].portb == CX23885_MPEG_DVB) {
> @@ -1497,134 +1448,83 @@ static int cx23885_stop_dma(struct cx23885_tsport *port)
>  	return 0;
>  }
>  
> -int cx23885_restart_queue(struct cx23885_tsport *port,
> -				struct cx23885_dmaqueue *q)
> -{
> -	struct cx23885_dev *dev = port->dev;
> -	struct cx23885_buffer *buf;
> -
> -	dprintk(5, "%s()\n", __func__);
> -	if (list_empty(&q->active)) {
> -		struct cx23885_buffer *prev;
> -		prev = NULL;
> -
> -		dprintk(5, "%s() queue is empty\n", __func__);
> -
> -		for (;;) {
> -			if (list_empty(&q->queued))
> -				return 0;
> -			buf = list_entry(q->queued.next, struct cx23885_buffer,
> -					 vb.queue);
> -			if (NULL == prev) {
> -				list_move_tail(&buf->vb.queue, &q->active);
> -				cx23885_start_dma(port, q, buf);
> -				buf->vb.state = VIDEOBUF_ACTIVE;
> -				buf->count    = q->count++;
> -				mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
> -				dprintk(5, "[%p/%d] restart_queue - f/active\n",
> -					buf, buf->vb.i);
> -
> -			} else if (prev->vb.width  == buf->vb.width  &&
> -				   prev->vb.height == buf->vb.height &&
> -				   prev->fmt       == buf->fmt) {
> -				list_move_tail(&buf->vb.queue, &q->active);
> -				buf->vb.state = VIDEOBUF_ACTIVE;
> -				buf->count    = q->count++;
> -				prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> -				/* 64 bit bits 63-32 */
> -				prev->risc.jmp[2] = cpu_to_le32(0);
> -				dprintk(5, "[%p/%d] restart_queue - m/active\n",
> -					buf, buf->vb.i);
> -			} else {
> -				return 0;
> -			}
> -			prev = buf;
> -		}
> -		return 0;
> -	}
> -
> -	buf = list_entry(q->active.next, struct cx23885_buffer, vb.queue);
> -	dprintk(2, "restart_queue [%p/%d]: restart dma\n",
> -		buf, buf->vb.i);
> -	cx23885_start_dma(port, q, buf);
> -	list_for_each_entry(buf, &q->active, vb.queue)
> -		buf->count = q->count++;
> -	mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
> -	return 0;
> -}
> -
>  /* ------------------------------------------------------------------ */
>  
> -int cx23885_buf_prepare(struct videobuf_queue *q, struct cx23885_tsport *port,
> -			struct cx23885_buffer *buf, enum v4l2_field field)
> +int cx23885_buf_prepare(struct cx23885_buffer *buf, struct cx23885_tsport *port)
>  {
>  	struct cx23885_dev *dev = port->dev;
>  	int size = port->ts_packet_size * port->ts_packet_count;
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(&buf->vb, 0);
>  	int rc;
>  
>  	dprintk(1, "%s: %p\n", __func__, buf);
> -	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
> +	if (vb2_plane_size(&buf->vb, 0) < size)
>  		return -EINVAL;
> +	vb2_set_plane_payload(&buf->vb, 0, size);
>  
> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> -		buf->vb.width  = port->ts_packet_size;
> -		buf->vb.height = port->ts_packet_count;
> -		buf->vb.size   = size;
> -		buf->vb.field  = field /*V4L2_FIELD_TOP*/;
> -
> -		rc = videobuf_iolock(q, &buf->vb, NULL);
> -		if (0 != rc)
> -			goto fail;
> -		cx23885_risc_databuffer(dev->pci, &buf->risc,
> -					videobuf_to_dma(&buf->vb)->sglist,
> -					buf->vb.width, buf->vb.height, 0);
> -	}
> -	buf->vb.state = VIDEOBUF_PREPARED;
> -	return 0;
> +	rc = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
> +	if (!rc)
> +		return -EIO;
>  
> - fail:
> -	cx23885_free_buffer(q, buf);
> -	return rc;
> +	cx23885_risc_databuffer(dev->pci, &buf->risc,
> +				sgt->sgl,
> +				port->ts_packet_size, port->ts_packet_count, 0);
> +	return 0;
>  }
>  
> +/*
> + * The risc program for each buffer works as follows: it starts with a simple
> + * 'JUMP to addr + 12', which is effectively a NOP. Then the code to DMA the
> + * buffer follows and at the end we have a JUMP back to the start + 12 (skipping
> + * the initial JUMP).
> + *
> + * This is the risc program of the first buffer to be queued if the active list
> + * is empty and it just keeps DMAing this buffer without generating any
> + * interrupts.
> + *
> + * If a new buffer is added then the initial JUMP in the code for that buffer
> + * will generate an interrupt which signals that the previous buffer has been
> + * DMAed successfully and that it can be returned to userspace.
> + *
> + * It also sets the final jump of the previous buffer to the start of the new
> + * buffer, thus chaining the new buffer into the DMA chain. This is a single
> + * atomic u32 write, so there is no race condition.
> + *
> + * The end-result of all this that you only get an interrupt when a buffer
> + * is ready, so the control flow is very easy.
> + */
>  void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
>  {
>  	struct cx23885_buffer    *prev;
>  	struct cx23885_dev *dev = port->dev;
>  	struct cx23885_dmaqueue  *cx88q = &port->mpegq;
> +	unsigned long flags;
>  
> -	/* add jump to stopper */
> -	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
> -	buf->risc.jmp[1] = cpu_to_le32(cx88q->stopper.dma);
> +	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 12);
> +	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
> +	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 12);
>  	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
>  
> +	spin_lock_irqsave(&dev->slock, flags);
>  	if (list_empty(&cx88q->active)) {
> -		dprintk(1, "queue is empty - first active\n");
> -		list_add_tail(&buf->vb.queue, &cx88q->active);
> -		cx23885_start_dma(port, cx88q, buf);
> -		buf->vb.state = VIDEOBUF_ACTIVE;
> -		buf->count    = cx88q->count++;
> -		mod_timer(&cx88q->timeout, jiffies + BUFFER_TIMEOUT);
> +		list_add_tail(&buf->queue, &cx88q->active);
>  		dprintk(1, "[%p/%d] %s - first active\n",
> -			buf, buf->vb.i, __func__);
> +			buf, buf->vb.v4l2_buf.index, __func__);
>  	} else {
> -		dprintk(1, "queue is not empty - append to active\n");
> +		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
>  		prev = list_entry(cx88q->active.prev, struct cx23885_buffer,
> -				  vb.queue);
> -		list_add_tail(&buf->vb.queue, &cx88q->active);
> -		buf->vb.state = VIDEOBUF_ACTIVE;
> -		buf->count    = cx88q->count++;
> +				  queue);
> +		list_add_tail(&buf->queue, &cx88q->active);
>  		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> -		prev->risc.jmp[2] = cpu_to_le32(0); /* 64 bit bits 63-32 */
>  		dprintk(1, "[%p/%d] %s - append to active\n",
> -			 buf, buf->vb.i, __func__);
> +			 buf, buf->vb.v4l2_buf.index, __func__);
>  	}
> +	spin_unlock_irqrestore(&dev->slock, flags);
>  }
>  
>  /* ----------------------------------------------------------- */
>  
> -static void do_cancel_buffers(struct cx23885_tsport *port, char *reason,
> -			      int restart)
> +static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
>  {
>  	struct cx23885_dev *dev = port->dev;
>  	struct cx23885_dmaqueue *q = &port->mpegq;
> @@ -1634,16 +1534,11 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason,
>  	spin_lock_irqsave(&port->slock, flags);
>  	while (!list_empty(&q->active)) {
>  		buf = list_entry(q->active.next, struct cx23885_buffer,
> -				 vb.queue);
> -		list_del(&buf->vb.queue);
> -		buf->vb.state = VIDEOBUF_ERROR;
> -		wake_up(&buf->vb.done);
> +				 queue);
> +		list_del(&buf->queue);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>  		dprintk(1, "[%p/%d] %s - dma=0x%08lx\n",
> -			buf, buf->vb.i, reason, (unsigned long)buf->risc.dma);
> -	}
> -	if (restart) {
> -		dprintk(1, "restarting queue\n");
> -		cx23885_restart_queue(port, q);
> +			buf, buf->vb.v4l2_buf.index, reason, (unsigned long)buf->risc.dma);
>  	}
>  	spin_unlock_irqrestore(&port->slock, flags);
>  }
> @@ -1651,27 +1546,10 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason,
>  void cx23885_cancel_buffers(struct cx23885_tsport *port)
>  {
>  	struct cx23885_dev *dev = port->dev;
> -	struct cx23885_dmaqueue *q = &port->mpegq;
>  
>  	dprintk(1, "%s()\n", __func__);
> -	del_timer_sync(&q->timeout);
>  	cx23885_stop_dma(port);
> -	do_cancel_buffers(port, "cancel", 0);
> -}
> -
> -static void cx23885_timeout(unsigned long data)
> -{
> -	struct cx23885_tsport *port = (struct cx23885_tsport *)data;
> -	struct cx23885_dev *dev = port->dev;
> -
> -	dprintk(1, "%s()\n", __func__);
> -
> -	if (debug > 5)
> -		cx23885_sram_channel_dump(dev,
> -			&dev->sram_channels[port->sram_chno]);
> -
> -	cx23885_stop_dma(port);
> -	do_cancel_buffers(port, "timeout", 1);
> +	do_cancel_buffers(port, "cancel");
>  }
>  
>  int cx23885_irq_417(struct cx23885_dev *dev, u32 status)
> @@ -1721,11 +1599,6 @@ int cx23885_irq_417(struct cx23885_dev *dev, u32 status)
>  		spin_lock(&port->slock);
>  		cx23885_wakeup(port, &port->mpegq, count);
>  		spin_unlock(&port->slock);
> -	} else if (status & VID_B_MSK_RISCI2) {
> -		dprintk(7, "        VID_B_MSK_RISCI2\n");
> -		spin_lock(&port->slock);
> -		cx23885_restart_queue(port, &port->mpegq);
> -		spin_unlock(&port->slock);
>  	}
>  	if (status) {
>  		cx_write(port->reg_ts_int_stat, status);
> @@ -1777,14 +1650,6 @@ static int cx23885_irq_ts(struct cx23885_tsport *port, u32 status)
>  		cx23885_wakeup(port, &port->mpegq, count);
>  		spin_unlock(&port->slock);
>  
> -	} else if (status & VID_BC_MSK_RISCI2) {
> -
> -		dprintk(7, " (RISCI2            0x%08x)\n", VID_BC_MSK_RISCI2);
> -
> -		spin_lock(&port->slock);
> -		cx23885_restart_queue(port, &port->mpegq);
> -		spin_unlock(&port->slock);
> -
>  	}
>  	if (status) {
>  		cx_write(port->reg_ts_int_stat, status);
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index 968fecc..376b0a6 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -91,59 +91,95 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
>  
>  /* ------------------------------------------------------------------ */
>  
> -static int dvb_buf_setup(struct videobuf_queue *q,
> -			 unsigned int *count, unsigned int *size)
> +static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +			   unsigned int *num_buffers, unsigned int *num_planes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	struct cx23885_tsport *port = q->priv_data;
> +	struct cx23885_tsport *port = q->drv_priv;
>  
>  	port->ts_packet_size  = 188 * 4;
>  	port->ts_packet_count = 32;
> -
> -	*size  = port->ts_packet_size * port->ts_packet_count;
> -	*count = 32;
> +	*num_planes = 1;
> +	sizes[0] = port->ts_packet_size * port->ts_packet_count;
> +	*num_buffers = 32;
>  	return 0;
>  }
>  
> -static int dvb_buf_prepare(struct videobuf_queue *q,
> -			   struct videobuf_buffer *vb, enum v4l2_field field)
> +
> +static int buffer_prepare(struct vb2_buffer *vb)
>  {
> -	struct cx23885_tsport *port = q->priv_data;
> -	return cx23885_buf_prepare(q, port, (struct cx23885_buffer *)vb, field);
> +	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf =
> +		container_of(vb, struct cx23885_buffer, vb);
> +
> +	return cx23885_buf_prepare(buf, port);
>  }
>  
> -static void dvb_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
> +static void buffer_finish(struct vb2_buffer *vb)
>  {
> -	struct cx23885_tsport *port = q->priv_data;
> -	cx23885_buf_queue(port, (struct cx23885_buffer *)vb);
> +	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
> +	struct cx23885_dev *dev = port->dev;
> +	struct cx23885_buffer *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
> +
> +	cx23885_free_buffer(dev, buf);
> +
> +	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
>  }
>  
> -static void dvb_buf_release(struct videobuf_queue *q,
> -			    struct videobuf_buffer *vb)
> +static void buffer_queue(struct vb2_buffer *vb)
>  {
> -	cx23885_free_buffer(q, (struct cx23885_buffer *)vb);
> +	struct cx23885_tsport *port = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer   *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +
> +	cx23885_buf_queue(port, buf);
>  }
>  
>  static void cx23885_dvb_gate_ctrl(struct cx23885_tsport  *port, int open)
>  {
> -	struct videobuf_dvb_frontends *f;
> -	struct videobuf_dvb_frontend *fe;
> +	struct vb2_dvb_frontends *f;
> +	struct vb2_dvb_frontend *fe;
>  
>  	f = &port->frontends;
>  
>  	if (f->gate <= 1) /* undefined or fe0 */
> -		fe = videobuf_dvb_get_frontend(f, 1);
> +		fe = vb2_dvb_get_frontend(f, 1);
>  	else
> -		fe = videobuf_dvb_get_frontend(f, f->gate);
> +		fe = vb2_dvb_get_frontend(f, f->gate);
>  
>  	if (fe && fe->dvb.frontend && fe->dvb.frontend->ops.i2c_gate_ctrl)
>  		fe->dvb.frontend->ops.i2c_gate_ctrl(fe->dvb.frontend, open);
>  }
>  
> -static struct videobuf_queue_ops dvb_qops = {
> -	.buf_setup    = dvb_buf_setup,
> -	.buf_prepare  = dvb_buf_prepare,
> -	.buf_queue    = dvb_buf_queue,
> -	.buf_release  = dvb_buf_release,
> +static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct cx23885_tsport *port = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &port->mpegq;
> +	struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
> +
> +	cx23885_start_dma(port, dmaq, buf);
> +	return 0;
> +}
> +
> +static void cx23885_stop_streaming(struct vb2_queue *q)
> +{
> +	struct cx23885_tsport *port = q->drv_priv;
> +
> +	cx23885_cancel_buffers(port);
> +}
> +
> +static struct vb2_ops dvb_qops = {
> +	.queue_setup    = queue_setup,
> +	.buf_prepare  = buffer_prepare,
> +	.buf_finish = buffer_finish,
> +	.buf_queue    = buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = cx23885_start_streaming,
> +	.stop_streaming = cx23885_stop_streaming,
>  };
>  
>  static struct s5h1409_config hauppauge_generic_config = {
> @@ -863,16 +899,16 @@ static int dvb_register(struct cx23885_tsport *port)
>  	struct dib7000p_ops dib7000p_ops;
>  	struct cx23885_dev *dev = port->dev;
>  	struct cx23885_i2c *i2c_bus = NULL, *i2c_bus2 = NULL;
> -	struct videobuf_dvb_frontend *fe0, *fe1 = NULL;
> +	struct vb2_dvb_frontend *fe0, *fe1 = NULL;
>  	int mfe_shared = 0; /* bus not shared by default */
>  	int ret;
>  
>  	/* Get the first frontend */
> -	fe0 = videobuf_dvb_get_frontend(&port->frontends, 1);
> +	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
>  	if (!fe0)
>  		return -EINVAL;
>  
> -	/* init struct videobuf_dvb */
> +	/* init struct vb2_dvb */
>  	fe0->dvb.name = dev->name;
>  
>  	/* multi-frontend gate control is undefined or defaults to fe0 */
> @@ -1392,7 +1428,7 @@ static int dvb_register(struct cx23885_tsport *port)
>  			fe0->dvb.frontend->ops.tuner_ops.init(fe0->dvb.frontend);
>  		}
>  		/* MFE frontend 2 */
> -		fe1 = videobuf_dvb_get_frontend(&port->frontends, 2);
> +		fe1 = vb2_dvb_get_frontend(&port->frontends, 2);
>  		if (fe1 == NULL)
>  			goto frontend_detach;
>  		/* DVB-C init */
> @@ -1532,7 +1568,7 @@ static int dvb_register(struct cx23885_tsport *port)
>  		fe0->dvb.frontend->ops.analog_ops.standby(fe0->dvb.frontend);
>  
>  	/* register everything */
> -	ret = videobuf_dvb_register_bus(&port->frontends, THIS_MODULE, port,
> +	ret = vb2_dvb_register_bus(&port->frontends, THIS_MODULE, port,
>  					&dev->pci->dev, adapter_nr, mfe_shared);
>  	if (ret)
>  		goto frontend_detach;
> @@ -1581,14 +1617,14 @@ static int dvb_register(struct cx23885_tsport *port)
>  
>  frontend_detach:
>  	port->gate_ctrl = NULL;
> -	videobuf_dvb_dealloc_frontends(&port->frontends);
> +	vb2_dvb_dealloc_frontends(&port->frontends);
>  	return -EINVAL;
>  }
>  
>  int cx23885_dvb_register(struct cx23885_tsport *port)
>  {
>  
> -	struct videobuf_dvb_frontend *fe0;
> +	struct vb2_dvb_frontend *fe0;
>  	struct cx23885_dev *dev = port->dev;
>  	int err, i;
>  
> @@ -1605,13 +1641,15 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
>  		port->num_frontends);
>  
>  	for (i = 1; i <= port->num_frontends; i++) {
> -		if (videobuf_dvb_alloc_frontend(
> +		struct vb2_queue *q;
> +
> +		if (vb2_dvb_alloc_frontend(
>  			&port->frontends, i) == NULL) {
>  			printk(KERN_ERR "%s() failed to alloc\n", __func__);
>  			return -ENOMEM;
>  		}
>  
> -		fe0 = videobuf_dvb_get_frontend(&port->frontends, i);
> +		fe0 = vb2_dvb_get_frontend(&port->frontends, i);
>  		if (!fe0)
>  			err = -EINVAL;
>  
> @@ -1627,10 +1665,21 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
>  		/* dvb stuff */
>  		/* We have to init the queue for each frontend on a port. */
>  		printk(KERN_INFO "%s: cx23885 based dvb card\n", dev->name);
> -		videobuf_queue_sg_init(&fe0->dvb.dvbq, &dvb_qops,
> -			    &dev->pci->dev, &port->slock,
> -			    V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_TOP,
> -			    sizeof(struct cx23885_buffer), port, NULL);
> +		q = &fe0->dvb.dvbq;
> +		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +		q->gfp_flags = GFP_DMA32;
> +		q->min_buffers_needed = 2;
> +		q->drv_priv = port;
> +		q->buf_struct_size = sizeof(struct cx23885_buffer);
> +		q->ops = &dvb_qops;
> +		q->mem_ops = &vb2_dma_sg_memops;
> +		q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +		q->lock = &dev->lock;
> +
> +		err = vb2_queue_init(q);
> +		if (err < 0)
> +			return err;
>  	}
>  	err = dvb_register(port);
>  	if (err != 0)
> @@ -1642,7 +1691,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
>  
>  int cx23885_dvb_unregister(struct cx23885_tsport *port)
>  {
> -	struct videobuf_dvb_frontend *fe0;
> +	struct vb2_dvb_frontend *fe0;
>  
>  	/* FIXME: in an error condition where the we have
>  	 * an expected number of frontends (attach problem)
> @@ -1651,9 +1700,9 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
>  	 * This comment only applies to future boards IF they
>  	 * implement MFE support.
>  	 */
> -	fe0 = videobuf_dvb_get_frontend(&port->frontends, 1);
> +	fe0 = vb2_dvb_get_frontend(&port->frontends, 1);
>  	if (fe0 && fe0->dvb.frontend)
> -		videobuf_dvb_unregister_bus(&port->frontends);
> +		vb2_dvb_unregister_bus(&port->frontends);
>  
>  	switch (port->dev->board) {
>  	case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
> diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
> index 1cb67d3..358776e 100644
> --- a/drivers/media/pci/cx23885/cx23885-vbi.c
> +++ b/drivers/media/pci/cx23885/cx23885-vbi.c
> @@ -42,9 +42,8 @@ MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
>  /* ------------------------------------------------------------------ */
>  
>  #define VBI_LINE_LENGTH 1440
> -#define NTSC_VBI_START_LINE 10        /* line 10 - 21 */
> -#define NTSC_VBI_END_LINE   21
> -#define NTSC_VBI_LINES      (NTSC_VBI_END_LINE - NTSC_VBI_START_LINE + 1)
> +#define VBI_NTSC_LINE_COUNT 12
> +#define VBI_PAL_LINE_COUNT 18
>  
>  
>  int cx23885_vbi_fmt(struct file *file, void *priv,
> @@ -52,22 +51,23 @@ int cx23885_vbi_fmt(struct file *file, void *priv,
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
>  
> +	f->fmt.vbi.sampling_rate = 27000000;
> +	f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
> +	f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
> +	f->fmt.vbi.offset = 0;
> +	f->fmt.vbi.flags = 0;
>  	if (dev->tvnorm & V4L2_STD_525_60) {
>  		/* ntsc */
> -		f->fmt.vbi.samples_per_line = VBI_LINE_LENGTH;
> -		f->fmt.vbi.sampling_rate = 27000000;
> -		f->fmt.vbi.sample_format = V4L2_PIX_FMT_GREY;
> -		f->fmt.vbi.offset = 0;
> -		f->fmt.vbi.flags = 0;
>  		f->fmt.vbi.start[0] = 10;
> -		f->fmt.vbi.count[0] = 17;
> -		f->fmt.vbi.start[1] = 263 + 10 + 1;
> -		f->fmt.vbi.count[1] = 17;
> +		f->fmt.vbi.start[1] = 272;
> +		f->fmt.vbi.count[0] = VBI_NTSC_LINE_COUNT;
> +		f->fmt.vbi.count[1] = VBI_NTSC_LINE_COUNT;
>  	} else if (dev->tvnorm & V4L2_STD_625_50) {
>  		/* pal */
> -		f->fmt.vbi.sampling_rate = 35468950;
> -		f->fmt.vbi.start[0] = 7 - 1;
> -		f->fmt.vbi.start[1] = 319 - 1;
> +		f->fmt.vbi.start[0] = 6;
> +		f->fmt.vbi.start[1] = 318;
> +		f->fmt.vbi.count[0] = VBI_PAL_LINE_COUNT;
> +		f->fmt.vbi.count[1] = VBI_PAL_LINE_COUNT;
>  	}
>  
>  	return 0;
> @@ -93,15 +93,6 @@ int cx23885_vbi_irq(struct cx23885_dev *dev, u32 status)
>  		handled++;
>  	}
>  
> -	if (status & VID_BC_MSK_VBI_RISCI2) {
> -		dprintk(1, "%s() VID_BC_MSK_VBI_RISCI2\n", __func__);
> -		dprintk(2, "stopper vbi\n");
> -		spin_lock(&dev->slock);
> -		cx23885_restart_vbi_queue(dev, &dev->vbiq);
> -		spin_unlock(&dev->slock);
> -		handled++;
> -	}
> -
>  	return handled;
>  }
>  
> @@ -113,13 +104,13 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
>  
>  	/* setup fifo + format */
>  	cx23885_sram_channel_setup(dev, &dev->sram_channels[SRAM_CH02],
> -				buf->vb.width, buf->risc.dma);
> +				VBI_LINE_LENGTH, buf->risc.dma);
>  
>  	/* reset counter */
>  	cx_write(VID_A_GPCNT_CTL, 3);
>  	cx_write(VID_A_VBI_CTRL, 3);
>  	cx_write(VBI_A_GPCNT_CTL, 3);
> -	q->count = 1;
> +	q->count = 0;
>  
>  	/* enable irq */
>  	cx23885_irq_add_enable(dev, 0x01);
> @@ -132,163 +123,153 @@ static int cx23885_start_vbi_dma(struct cx23885_dev    *dev,
>  	return 0;
>  }
>  
> +/* ------------------------------------------------------------------ */
>  
> -int cx23885_restart_vbi_queue(struct cx23885_dev    *dev,
> -			     struct cx23885_dmaqueue *q)
> +static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +			   unsigned int *num_buffers, unsigned int *num_planes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	struct cx23885_buffer *buf;
> -	struct list_head *item;
> -
> -	if (list_empty(&q->active))
> -		return 0;
> -
> -	buf = list_entry(q->active.next, struct cx23885_buffer, vb.queue);
> -	dprintk(2, "restart_queue [%p/%d]: restart dma\n",
> -		buf, buf->vb.i);
> -	cx23885_start_vbi_dma(dev, q, buf);
> -	list_for_each(item, &q->active) {
> -		buf = list_entry(item, struct cx23885_buffer, vb.queue);
> -		buf->count = q->count++;
> -	}
> -	mod_timer(&q->timeout, jiffies + (BUFFER_TIMEOUT / 30));
> +	struct cx23885_dev *dev = q->drv_priv;
> +	unsigned lines = VBI_PAL_LINE_COUNT;
> +
> +	if (dev->tvnorm & V4L2_STD_525_60)
> +		lines = VBI_NTSC_LINE_COUNT;
> +	*num_planes = 1;
> +	sizes[0] = lines * VBI_LINE_LENGTH * 2;
>  	return 0;
>  }
>  
> -void cx23885_vbi_timeout(unsigned long data)
> +static int buffer_prepare(struct vb2_buffer *vb)
>  {
> -	struct cx23885_dev *dev = (struct cx23885_dev *)data;
> -	struct cx23885_dmaqueue *q = &dev->vbiq;
> -	struct cx23885_buffer *buf;
> -	unsigned long flags;
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
> +	unsigned lines = VBI_PAL_LINE_COUNT;
> +	int ret;
>  
> -	/* Stop the VBI engine */
> -	cx_clear(VID_A_DMA_CTL, 0x22);
> +	if (dev->tvnorm & V4L2_STD_525_60)
> +		lines = VBI_NTSC_LINE_COUNT;
>  
> -	spin_lock_irqsave(&dev->slock, flags);
> -	while (!list_empty(&q->active)) {
> -		buf = list_entry(q->active.next, struct cx23885_buffer,
> -			vb.queue);
> -		list_del(&buf->vb.queue);
> -		buf->vb.state = VIDEOBUF_ERROR;
> -		wake_up(&buf->vb.done);
> -		printk("%s/0: [%p/%d] timeout - dma=0x%08lx\n", dev->name,
> -		       buf, buf->vb.i, (unsigned long)buf->risc.dma);
> -	}
> -	cx23885_restart_vbi_queue(dev, q);
> -	spin_unlock_irqrestore(&dev->slock, flags);
> -}
> +	if (vb2_plane_size(vb, 0) < lines * VBI_LINE_LENGTH * 2)
> +		return -EINVAL;
> +	vb2_set_plane_payload(vb, 0, lines * VBI_LINE_LENGTH * 2);
>  
> -/* ------------------------------------------------------------------ */
> -#define VBI_LINE_LENGTH 1440
> -#define VBI_LINE_COUNT 17
> +	ret = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
> +	if (!ret)
> +		return -EIO;
>  
> -static int
> -vbi_setup(struct videobuf_queue *q, unsigned int *count, unsigned int *size)
> -{
> -	*size = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
> -	if (0 == *count)
> -		*count = vbibufs;
> -	if (*count < 2)
> -		*count = 2;
> -	if (*count > 32)
> -		*count = 32;
> +	cx23885_risc_vbibuffer(dev->pci, &buf->risc,
> +			 sgt->sgl,
> +			 0, VBI_LINE_LENGTH * lines,
> +			 VBI_LINE_LENGTH, 0,
> +			 lines);
>  	return 0;
>  }
>  
> -static int
> -vbi_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
> -	    enum v4l2_field field)
> +static void buffer_finish(struct vb2_buffer *vb)
>  {
> -	struct cx23885_fh *fh  = q->priv_data;
> -	struct cx23885_dev *dev = fh->q_dev;
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
>  	struct cx23885_buffer *buf = container_of(vb,
>  		struct cx23885_buffer, vb);
> -	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
> -	unsigned int size;
> -	int rc;
> -
> -	size = VBI_LINE_COUNT * VBI_LINE_LENGTH * 2;
> -	if (0 != buf->vb.baddr  &&  buf->vb.bsize < size)
> -		return -EINVAL;
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
>  
> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> -		buf->vb.width  = VBI_LINE_LENGTH;
> -		buf->vb.height = VBI_LINE_COUNT;
> -		buf->vb.size   = size;
> -		buf->vb.field  = V4L2_FIELD_SEQ_TB;
> -
> -		rc = videobuf_iolock(q, &buf->vb, NULL);
> -		if (0 != rc)
> -			goto fail;
> -		cx23885_risc_vbibuffer(dev->pci, &buf->risc,
> -				 dma->sglist,
> -				 0, buf->vb.width * buf->vb.height,
> -				 buf->vb.width, 0,
> -				 buf->vb.height);
> -	}
> -	buf->vb.state = VIDEOBUF_PREPARED;
> -	return 0;
> +	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
>  
> - fail:
> -	cx23885_free_buffer(q, buf);
> -	return rc;
> +	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
>  }
>  
> -static void
> -vbi_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
> +/*
> + * The risc program for each buffer works as follows: it starts with a simple
> + * 'JUMP to addr + 12', which is effectively a NOP. Then the code to DMA the
> + * buffer follows and at the end we have a JUMP back to the start + 12 (skipping
> + * the initial JUMP).
> + *
> + * This is the risc program of the first buffer to be queued if the active list
> + * is empty and it just keeps DMAing this buffer without generating any
> + * interrupts.
> + *
> + * If a new buffer is added then the initial JUMP in the code for that buffer
> + * will generate an interrupt which signals that the previous buffer has been
> + * DMAed successfully and that it can be returned to userspace.
> + *
> + * It also sets the final jump of the previous buffer to the start of the new
> + * buffer, thus chaining the new buffer into the DMA chain. This is a single
> + * atomic u32 write, so there is no race condition.
> + *
> + * The end-result of all this that you only get an interrupt when a buffer
> + * is ready, so the control flow is very easy.
> + */
> +static void buffer_queue(struct vb2_buffer *vb)
>  {
> -	struct cx23885_buffer   *buf =
> -		container_of(vb, struct cx23885_buffer, vb);
> -	struct cx23885_buffer   *prev;
> -	struct cx23885_fh       *fh   = vq->priv_data;
> -	struct cx23885_dev      *dev  = fh->q_dev;
> -	struct cx23885_dmaqueue *q    = &dev->vbiq;
> -
> -	/* add jump to stopper */
> -	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
> -	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf = container_of(vb, struct cx23885_buffer, vb);
> +	struct cx23885_buffer *prev;
> +	struct cx23885_dmaqueue *q = &dev->vbiq;
> +	unsigned long flags;
> +
> +	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 12);
> +	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
> +	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 12);
>  	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
>  
>  	if (list_empty(&q->active)) {
> -		list_add_tail(&buf->vb.queue, &q->active);
> -		cx23885_start_vbi_dma(dev, q, buf);
> -		buf->vb.state = VIDEOBUF_ACTIVE;
> -		buf->count    = q->count++;
> -		mod_timer(&q->timeout, jiffies + (BUFFER_TIMEOUT / 30));
> +		spin_lock_irqsave(&dev->slock, flags);
> +		list_add_tail(&buf->queue, &q->active);
> +		spin_unlock_irqrestore(&dev->slock, flags);
>  		dprintk(2, "[%p/%d] vbi_queue - first active\n",
> -			buf, buf->vb.i);
> +			buf, buf->vb.v4l2_buf.index);
>  
>  	} else {
> +		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
>  		prev = list_entry(q->active.prev, struct cx23885_buffer,
> -			vb.queue);
> -		list_add_tail(&buf->vb.queue, &q->active);
> -		buf->vb.state = VIDEOBUF_ACTIVE;
> -		buf->count    = q->count++;
> +			queue);
> +		spin_lock_irqsave(&dev->slock, flags);
> +		list_add_tail(&buf->queue, &q->active);
> +		spin_unlock_irqrestore(&dev->slock, flags);
>  		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> -		prev->risc.jmp[2] = cpu_to_le32(0); /* Bits 63-32 */
>  		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
> -			buf, buf->vb.i);
> +			buf, buf->vb.v4l2_buf.index);
>  	}
>  }
>  
> -static void vbi_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
> +static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
> -	struct cx23885_buffer *buf =
> -		container_of(vb, struct cx23885_buffer, vb);
> +	struct cx23885_dev *dev = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &dev->vbiq;
> +	struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
>  
> -	cx23885_free_buffer(q, buf);
> +	cx23885_start_vbi_dma(dev, dmaq, buf);
> +	return 0;
>  }
>  
> -struct videobuf_queue_ops cx23885_vbi_qops = {
> -	.buf_setup    = vbi_setup,
> -	.buf_prepare  = vbi_prepare,
> -	.buf_queue    = vbi_queue,
> -	.buf_release  = vbi_release,
> -};
> +static void cx23885_stop_streaming(struct vb2_queue *q)
> +{
> +	struct cx23885_dev *dev = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &dev->vbiq;
> +	unsigned long flags;
>  
> -/* ------------------------------------------------------------------ */
> -/*
> - * Local variables:
> - * c-basic-offset: 8
> - * End:
> - */
> +	cx_clear(VID_A_DMA_CTL, 0x22); /* FIFO and RISC enable */
> +	spin_lock_irqsave(&dev->slock, flags);
> +	while (!list_empty(&dmaq->active)) {
> +		struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
> +
> +		list_del(&buf->queue);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
> +	}
> +	spin_unlock_irqrestore(&dev->slock, flags);
> +}
> +
> +
> +struct vb2_ops cx23885_vbi_qops = {
> +	.queue_setup    = queue_setup,
> +	.buf_prepare  = buffer_prepare,
> +	.buf_finish = buffer_finish,
> +	.buf_queue    = buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = cx23885_start_streaming,
> +	.stop_streaming = cx23885_stop_streaming,
> +};
> diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
> index b374003..16fcdfc 100644
> --- a/drivers/media/pci/cx23885/cx23885-video.c
> +++ b/drivers/media/pci/cx23885/cx23885-video.c
> @@ -102,34 +102,18 @@ void cx23885_video_wakeup(struct cx23885_dev *dev,
>  	struct cx23885_dmaqueue *q, u32 count)
>  {
>  	struct cx23885_buffer *buf;
> -	int bc;
> -
> -	for (bc = 0;; bc++) {
> -		if (list_empty(&q->active))
> -			break;
> -		buf = list_entry(q->active.next,
> -				 struct cx23885_buffer, vb.queue);
> -
> -		/* count comes from the hw and is is 16bit wide --
> -		 * this trick handles wrap-arounds correctly for
> -		 * up to 32767 buffers in flight... */
> -		if ((s16) (count - buf->count) < 0)
> -			break;
> -
> -		v4l2_get_timestamp(&buf->vb.ts);
> -		dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.i,
> -			count, buf->count);
> -		buf->vb.state = VIDEOBUF_DONE;
> -		list_del(&buf->vb.queue);
> -		wake_up(&buf->vb.done);
> -	}
> +
>  	if (list_empty(&q->active))
> -		del_timer(&q->timeout);
> -	else
> -		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
> -	if (bc != 1)
> -		printk(KERN_ERR "%s: %d buffers handled (should be 1)\n",
> -			__func__, bc);
> +		return;
> +	buf = list_entry(q->active.next,
> +			struct cx23885_buffer, queue);
> +
> +	buf->vb.v4l2_buf.sequence = q->count++;
> +	v4l2_get_timestamp(&buf->vb.v4l2_buf.timestamp);
> +	dprintk(2, "[%p/%d] wakeup reg=%d buf=%d\n", buf, buf->vb.v4l2_buf.index,
> +			count, q->count);
> +	list_del(&buf->queue);
> +	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
>  }
>  
>  int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm)
> @@ -167,50 +151,6 @@ static struct video_device *cx23885_vdev_init(struct cx23885_dev *dev,
>  	return vfd;
>  }
>  
> -/* ------------------------------------------------------------------- */
> -/* resource management                                                 */
> -
> -static int res_get(struct cx23885_dev *dev, struct cx23885_fh *fh,
> -	unsigned int bit)
> -{
> -	dprintk(1, "%s()\n", __func__);
> -	if (fh->resources & bit)
> -		/* have it already allocated */
> -		return 1;
> -
> -	/* is it free? */
> -	if (dev->resources & bit) {
> -		/* no, someone else uses it */
> -		return 0;
> -	}
> -	/* it's free, grab it */
> -	fh->resources  |= bit;
> -	dev->resources |= bit;
> -	dprintk(1, "res: get %d\n", bit);
> -	return 1;
> -}
> -
> -static int res_check(struct cx23885_fh *fh, unsigned int bit)
> -{
> -	return fh->resources & bit;
> -}
> -
> -static int res_locked(struct cx23885_dev *dev, unsigned int bit)
> -{
> -	return dev->resources & bit;
> -}
> -
> -static void res_free(struct cx23885_dev *dev, struct cx23885_fh *fh,
> -	unsigned int bits)
> -{
> -	BUG_ON((fh->resources & bits) != bits);
> -	dprintk(1, "%s()\n", __func__);
> -
> -	fh->resources  &= ~bits;
> -	dev->resources &= ~bits;
> -	dprintk(1, "res: put %d\n", bits);
> -}
> -
>  int cx23885_flatiron_write(struct cx23885_dev *dev, u8 reg, u8 data)
>  {
>  	/* 8 bit registers, 8 bit values */
> @@ -360,7 +300,7 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
>  
>  	/* reset counter */
>  	cx_write(VID_A_GPCNT_CTL, 3);
> -	q->count = 1;
> +	q->count = 0;
>  
>  	/* enable irq */
>  	cx23885_irq_add_enable(dev, 0x01);
> @@ -373,444 +313,206 @@ static int cx23885_start_video_dma(struct cx23885_dev *dev,
>  	return 0;
>  }
>  
> -
> -static int cx23885_restart_video_queue(struct cx23885_dev *dev,
> -			       struct cx23885_dmaqueue *q)
> +static int queue_setup(struct vb2_queue *q, const struct v4l2_format *fmt,
> +			   unsigned int *num_buffers, unsigned int *num_planes,
> +			   unsigned int sizes[], void *alloc_ctxs[])
>  {
> -	struct cx23885_buffer *buf, *prev;
> -	struct list_head *item;
> -	dprintk(1, "%s()\n", __func__);
> -
> -	if (!list_empty(&q->active)) {
> -		buf = list_entry(q->active.next, struct cx23885_buffer,
> -			vb.queue);
> -		dprintk(2, "restart_queue [%p/%d]: restart dma\n",
> -			buf, buf->vb.i);
> -		cx23885_start_video_dma(dev, q, buf);
> -		list_for_each(item, &q->active) {
> -			buf = list_entry(item, struct cx23885_buffer,
> -				vb.queue);
> -			buf->count    = q->count++;
> -		}
> -		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
> -		return 0;
> -	}
> +	struct cx23885_dev *dev = q->drv_priv;
>  
> -	prev = NULL;
> -	for (;;) {
> -		if (list_empty(&q->queued))
> -			return 0;
> -		buf = list_entry(q->queued.next, struct cx23885_buffer,
> -			vb.queue);
> -		if (NULL == prev) {
> -			list_move_tail(&buf->vb.queue, &q->active);
> -			cx23885_start_video_dma(dev, q, buf);
> -			buf->vb.state = VIDEOBUF_ACTIVE;
> -			buf->count    = q->count++;
> -			mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
> -			dprintk(2, "[%p/%d] restart_queue - first active\n",
> -				buf, buf->vb.i);
> -
> -		} else if (prev->vb.width  == buf->vb.width  &&
> -			   prev->vb.height == buf->vb.height &&
> -			   prev->fmt       == buf->fmt) {
> -			list_move_tail(&buf->vb.queue, &q->active);
> -			buf->vb.state = VIDEOBUF_ACTIVE;
> -			buf->count    = q->count++;
> -			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> -			prev->risc.jmp[2] = cpu_to_le32(0); /* Bits 63 - 32 */
> -			dprintk(2, "[%p/%d] restart_queue - move to active\n",
> -				buf, buf->vb.i);
> -		} else {
> -			return 0;
> -		}
> -		prev = buf;
> -	}
> -}
> -
> -static int buffer_setup(struct videobuf_queue *q, unsigned int *count,
> -	unsigned int *size)
> -{
> -	struct cx23885_fh *fh = q->priv_data;
> -	struct cx23885_dev *dev = fh->q_dev;
> -
> -	*size = (dev->fmt->depth * dev->width * dev->height) >> 3;
> -	if (0 == *count)
> -		*count = 32;
> -	if (*size * *count > vid_limit * 1024 * 1024)
> -		*count = (vid_limit * 1024 * 1024) / *size;
> +	*num_planes = 1;
> +	sizes[0] = (dev->fmt->depth * dev->width * dev->height) >> 3;
>  	return 0;
>  }
>  
> -static int buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
> -	       enum v4l2_field field)
> +static int buffer_prepare(struct vb2_buffer *vb)
>  {
> -	struct cx23885_fh *fh  = q->priv_data;
> -	struct cx23885_dev *dev = fh->q_dev;
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
>  	struct cx23885_buffer *buf =
>  		container_of(vb, struct cx23885_buffer, vb);
> -	int rc, init_buffer = 0;
>  	u32 line0_offset, line1_offset;
> -	struct videobuf_dmabuf *dma = videobuf_to_dma(&buf->vb);
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
>  	int field_tff;
> +	int ret;
>  
> -	if (WARN_ON(NULL == dev->fmt))
> -		return -EINVAL;
> +	buf->bpl = (dev->width * dev->fmt->depth) >> 3;
>  
> -	if (dev->width  < 48 || dev->width  > norm_maxw(dev->tvnorm) ||
> -	    dev->height < 32 || dev->height > norm_maxh(dev->tvnorm))
> -		return -EINVAL;
> -	buf->vb.size = (dev->width * dev->height * dev->fmt->depth) >> 3;
> -	if (0 != buf->vb.baddr  &&  buf->vb.bsize < buf->vb.size)
> +	if (vb2_plane_size(vb, 0) < dev->height * buf->bpl)
>  		return -EINVAL;
> +	vb2_set_plane_payload(vb, 0, dev->height * buf->bpl);
>  
> -	if (buf->fmt       != dev->fmt    ||
> -	    buf->vb.width  != dev->width  ||
> -	    buf->vb.height != dev->height ||
> -	    buf->vb.field  != field) {
> -		buf->fmt       = dev->fmt;
> -		buf->vb.width  = dev->width;
> -		buf->vb.height = dev->height;
> -		buf->vb.field  = field;
> -		init_buffer = 1;
> -	}
> +	ret = dma_map_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
> +	if (!ret)
> +		return -EIO;
>  
> -	if (VIDEOBUF_NEEDS_INIT == buf->vb.state) {
> -		init_buffer = 1;
> -		rc = videobuf_iolock(q, &buf->vb, NULL);
> -		if (0 != rc)
> -			goto fail;
> -	}
> +	switch (dev->field) {
> +	case V4L2_FIELD_TOP:
> +		cx23885_risc_buffer(dev->pci, &buf->risc,
> +				sgt->sgl, 0, UNSET,
> +				buf->bpl, 0, dev->height);
> +		break;
> +	case V4L2_FIELD_BOTTOM:
> +		cx23885_risc_buffer(dev->pci, &buf->risc,
> +				sgt->sgl, UNSET, 0,
> +				buf->bpl, 0, dev->height);
> +		break;
> +	case V4L2_FIELD_INTERLACED:
> +		if (dev->tvnorm & V4L2_STD_NTSC)
> +			/* NTSC or  */
> +			field_tff = 1;
> +		else
> +			field_tff = 0;
> +
> +		if (cx23885_boards[dev->board].force_bff)
> +			/* PAL / SECAM OR 888 in NTSC MODE */
> +			field_tff = 0;
>  
> -	if (init_buffer) {
> -		buf->bpl = buf->vb.width * buf->fmt->depth >> 3;
> -		switch (buf->vb.field) {
> -		case V4L2_FIELD_TOP:
> -			cx23885_risc_buffer(dev->pci, &buf->risc,
> -					 dma->sglist, 0, UNSET,
> -					 buf->bpl, 0, buf->vb.height);
> -			break;
> -		case V4L2_FIELD_BOTTOM:
> -			cx23885_risc_buffer(dev->pci, &buf->risc,
> -					 dma->sglist, UNSET, 0,
> -					 buf->bpl, 0, buf->vb.height);
> -			break;
> -		case V4L2_FIELD_INTERLACED:
> -			if (dev->tvnorm & V4L2_STD_NTSC)
> -				/* NTSC or  */
> -				field_tff = 1;
> -			else
> -				field_tff = 0;
> -
> -			if (cx23885_boards[dev->board].force_bff)
> -				/* PAL / SECAM OR 888 in NTSC MODE */
> -				field_tff = 0;
> -
> -			if (field_tff) {
> -				/* cx25840 transmits NTSC bottom field first */
> -				dprintk(1, "%s() Creating TFF/NTSC risc\n",
> +		if (field_tff) {
> +			/* cx25840 transmits NTSC bottom field first */
> +			dprintk(1, "%s() Creating TFF/NTSC risc\n",
>  					__func__);
> -				line0_offset = buf->bpl;
> -				line1_offset = 0;
> -			} else {
> -				/* All other formats are top field first */
> -				dprintk(1, "%s() Creating BFF/PAL/SECAM risc\n",
> +			line0_offset = buf->bpl;
> +			line1_offset = 0;
> +		} else {
> +			/* All other formats are top field first */
> +			dprintk(1, "%s() Creating BFF/PAL/SECAM risc\n",
>  					__func__);
> -				line0_offset = 0;
> -				line1_offset = buf->bpl;
> -			}
> -			cx23885_risc_buffer(dev->pci, &buf->risc,
> -					dma->sglist, line0_offset,
> -					line1_offset,
> -					buf->bpl, buf->bpl,
> -					buf->vb.height >> 1);
> -			break;
> -		case V4L2_FIELD_SEQ_TB:
> -			cx23885_risc_buffer(dev->pci, &buf->risc,
> -					 dma->sglist,
> -					 0, buf->bpl * (buf->vb.height >> 1),
> -					 buf->bpl, 0,
> -					 buf->vb.height >> 1);
> -			break;
> -		case V4L2_FIELD_SEQ_BT:
> -			cx23885_risc_buffer(dev->pci, &buf->risc,
> -					 dma->sglist,
> -					 buf->bpl * (buf->vb.height >> 1), 0,
> -					 buf->bpl, 0,
> -					 buf->vb.height >> 1);
> -			break;
> -		default:
> -			BUG();
> +			line0_offset = 0;
> +			line1_offset = buf->bpl;
>  		}
> +		cx23885_risc_buffer(dev->pci, &buf->risc,
> +				sgt->sgl, line0_offset,
> +				line1_offset,
> +				buf->bpl, buf->bpl,
> +				dev->height >> 1);
> +		break;
> +	case V4L2_FIELD_SEQ_TB:
> +		cx23885_risc_buffer(dev->pci, &buf->risc,
> +				sgt->sgl,
> +				0, buf->bpl * (dev->height >> 1),
> +				buf->bpl, 0,
> +				dev->height >> 1);
> +		break;
> +	case V4L2_FIELD_SEQ_BT:
> +		cx23885_risc_buffer(dev->pci, &buf->risc,
> +				sgt->sgl,
> +				buf->bpl * (dev->height >> 1), 0,
> +				buf->bpl, 0,
> +				dev->height >> 1);
> +		break;
> +	default:
> +		BUG();
>  	}
> -	dprintk(2, "[%p/%d] buffer_prep - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
> -		buf, buf->vb.i,
> +	dprintk(2, "[%p/%d] buffer_init - %dx%d %dbpp \"%s\" - dma=0x%08lx\n",
> +		buf, buf->vb.v4l2_buf.index,
>  		dev->width, dev->height, dev->fmt->depth, dev->fmt->name,
>  		(unsigned long)buf->risc.dma);
> -
> -	buf->vb.state = VIDEOBUF_PREPARED;
>  	return 0;
> +}
>  
> - fail:
> -	cx23885_free_buffer(q, buf);
> -	return rc;
> +static void buffer_finish(struct vb2_buffer *vb)
> +{
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
> +	struct cx23885_buffer *buf = container_of(vb,
> +		struct cx23885_buffer, vb);
> +	struct sg_table *sgt = vb2_dma_sg_plane_desc(vb, 0);
> +
> +	cx23885_free_buffer(vb->vb2_queue->drv_priv, buf);
> +
> +	dma_unmap_sg(&dev->pci->dev, sgt->sgl, sgt->nents, DMA_FROM_DEVICE);
>  }
>  
> -static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
> +/*
> + * The risc program for each buffer works as follows: it starts with a simple
> + * 'JUMP to addr + 12', which is effectively a NOP. Then the code to DMA the
> + * buffer follows and at the end we have a JUMP back to the start + 12 (skipping
> + * the initial JUMP).
> + *
> + * This is the risc program of the first buffer to be queued if the active list
> + * is empty and it just keeps DMAing this buffer without generating any
> + * interrupts.
> + *
> + * If a new buffer is added then the initial JUMP in the code for that buffer
> + * will generate an interrupt which signals that the previous buffer has been
> + * DMAed successfully and that it can be returned to userspace.
> + *
> + * It also sets the final jump of the previous buffer to the start of the new
> + * buffer, thus chaining the new buffer into the DMA chain. This is a single
> + * atomic u32 write, so there is no race condition.
> + *
> + * The end-result of all this that you only get an interrupt when a buffer
> + * is ready, so the control flow is very easy.
> + */
> +static void buffer_queue(struct vb2_buffer *vb)
>  {
> +	struct cx23885_dev *dev = vb->vb2_queue->drv_priv;
>  	struct cx23885_buffer   *buf = container_of(vb,
>  		struct cx23885_buffer, vb);
>  	struct cx23885_buffer   *prev;
> -	struct cx23885_fh       *fh   = vq->priv_data;
> -	struct cx23885_dev      *dev  = fh->q_dev;
>  	struct cx23885_dmaqueue *q    = &dev->vidq;
> +	unsigned long flags;
>  
> -	/* add jump to stopper */
> -	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_IRQ1 | RISC_CNT_INC);
> -	buf->risc.jmp[1] = cpu_to_le32(q->stopper.dma);
> +	/* add jump to start */
> +	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 12);
> +	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
> +	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 12);
>  	buf->risc.jmp[2] = cpu_to_le32(0); /* bits 63-32 */
>  
> -	if (!list_empty(&q->queued)) {
> -		list_add_tail(&buf->vb.queue, &q->queued);
> -		buf->vb.state = VIDEOBUF_QUEUED;
> -		dprintk(2, "[%p/%d] buffer_queue - append to queued\n",
> -			buf, buf->vb.i);
> -
> -	} else if (list_empty(&q->active)) {
> -		list_add_tail(&buf->vb.queue, &q->active);
> -		cx23885_start_video_dma(dev, q, buf);
> -		buf->vb.state = VIDEOBUF_ACTIVE;
> -		buf->count    = q->count++;
> -		mod_timer(&q->timeout, jiffies+BUFFER_TIMEOUT);
> +	spin_lock_irqsave(&dev->slock, flags);
> +	if (list_empty(&q->active)) {
> +		list_add_tail(&buf->queue, &q->active);
>  		dprintk(2, "[%p/%d] buffer_queue - first active\n",
> -			buf, buf->vb.i);
> -
> +			buf, buf->vb.v4l2_buf.index);
>  	} else {
> +		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
>  		prev = list_entry(q->active.prev, struct cx23885_buffer,
> -			vb.queue);
> -		if (prev->vb.width  == buf->vb.width  &&
> -		    prev->vb.height == buf->vb.height &&
> -		    prev->fmt       == buf->fmt) {
> -			list_add_tail(&buf->vb.queue, &q->active);
> -			buf->vb.state = VIDEOBUF_ACTIVE;
> -			buf->count    = q->count++;
> -			prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> -			/* 64 bit bits 63-32 */
> -			prev->risc.jmp[2] = cpu_to_le32(0);
> -			dprintk(2, "[%p/%d] buffer_queue - append to active\n",
> -				buf, buf->vb.i);
> -
> -		} else {
> -			list_add_tail(&buf->vb.queue, &q->queued);
> -			buf->vb.state = VIDEOBUF_QUEUED;
> -			dprintk(2, "[%p/%d] buffer_queue - first queued\n",
> -				buf, buf->vb.i);
> -		}
> -	}
> -}
> -
> -static void buffer_release(struct videobuf_queue *q,
> -	struct videobuf_buffer *vb)
> -{
> -	struct cx23885_buffer *buf = container_of(vb,
> -		struct cx23885_buffer, vb);
> -
> -	cx23885_free_buffer(q, buf);
> -}
> -
> -static struct videobuf_queue_ops cx23885_video_qops = {
> -	.buf_setup    = buffer_setup,
> -	.buf_prepare  = buffer_prepare,
> -	.buf_queue    = buffer_queue,
> -	.buf_release  = buffer_release,
> -};
> -
> -static struct videobuf_queue *get_queue(struct file *file)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	switch (vdev->vfl_type) {
> -	case VFL_TYPE_GRABBER:
> -		return &fh->vidq;
> -	case VFL_TYPE_VBI:
> -		return &fh->vbiq;
> -	default:
> -		WARN_ON(1);
> -		return NULL;
> -	}
> -}
> -
> -static int get_resource(u32 type)
> -{
> -	switch (type) {
> -	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
> -		return RESOURCE_VIDEO;
> -	case V4L2_BUF_TYPE_VBI_CAPTURE:
> -		return RESOURCE_VBI;
> -	default:
> -		WARN_ON(1);
> -		return 0;
> +			queue);
> +		list_add_tail(&buf->queue, &q->active);
> +		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
> +		dprintk(2, "[%p/%d] buffer_queue - append to active\n",
> +				buf, buf->vb.v4l2_buf.index);
>  	}
> +	spin_unlock_irqrestore(&dev->slock, flags);
>  }
>  
> -static int video_open(struct file *file)
> +static int cx23885_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh;
> -
> -	dprintk(1, "open dev=%s\n",
> -		video_device_node_name(vdev));
> -
> -	/* allocate + initialize per filehandle data */
> -	fh = kzalloc(sizeof(*fh), GFP_KERNEL);
> -	if (NULL == fh)
> -		return -ENOMEM;
> -
> -	v4l2_fh_init(&fh->fh, vdev);
> -	file->private_data = &fh->fh;
> -	fh->q_dev      = dev;
> -
> -	videobuf_queue_sg_init(&fh->vidq, &cx23885_video_qops,
> -			    &dev->pci->dev, &dev->slock,
> -			    V4L2_BUF_TYPE_VIDEO_CAPTURE,
> -			    V4L2_FIELD_INTERLACED,
> -			    sizeof(struct cx23885_buffer),
> -			    fh, NULL);
> -
> -	videobuf_queue_sg_init(&fh->vbiq, &cx23885_vbi_qops,
> -		&dev->pci->dev, &dev->slock,
> -		V4L2_BUF_TYPE_VBI_CAPTURE,
> -		V4L2_FIELD_SEQ_TB,
> -		sizeof(struct cx23885_buffer),
> -		fh, NULL);
> -
> -	v4l2_fh_add(&fh->fh);
> -
> -	dprintk(1, "post videobuf_queue_init()\n");
> +	struct cx23885_dev *dev = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &dev->vidq;
> +	struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
>  
> +	cx23885_start_video_dma(dev, dmaq, buf);
>  	return 0;
>  }
>  
> -static ssize_t video_read(struct file *file, char __user *data,
> -	size_t count, loff_t *ppos)
> +static void cx23885_stop_streaming(struct vb2_queue *q)
>  {
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	switch (vdev->vfl_type) {
> -	case VFL_TYPE_GRABBER:
> -		if (res_locked(dev, RESOURCE_VIDEO))
> -			return -EBUSY;
> -		return videobuf_read_one(&fh->vidq, data, count, ppos,
> -					 file->f_flags & O_NONBLOCK);
> -	case VFL_TYPE_VBI:
> -		if (!res_get(dev, fh, RESOURCE_VBI))
> -			return -EBUSY;
> -		return videobuf_read_stream(&fh->vbiq, data, count, ppos, 1,
> -					    file->f_flags & O_NONBLOCK);
> -	default:
> -		return -EINVAL;
> -	}
> -}
> -
> -static unsigned int video_poll(struct file *file,
> -	struct poll_table_struct *wait)
> -{
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -	struct cx23885_buffer *buf;
> -	unsigned long req_events = poll_requested_events(wait);
> -	unsigned int rc = 0;
> -
> -	if (v4l2_event_pending(&fh->fh))
> -		rc = POLLPRI;
> -	else
> -		poll_wait(file, &fh->fh.wait, wait);
> -	if (!(req_events & (POLLIN | POLLRDNORM)))
> -		return rc;
> -
> -	if (vdev->vfl_type == VFL_TYPE_VBI) {
> -		if (!res_get(dev, fh, RESOURCE_VBI))
> -			return rc | POLLERR;
> -		return rc | videobuf_poll_stream(file, &fh->vbiq, wait);
> -	}
> -
> -	mutex_lock(&fh->vidq.vb_lock);
> -	if (res_check(fh, RESOURCE_VIDEO)) {
> -		/* streaming capture */
> -		if (list_empty(&fh->vidq.stream))
> -			goto done;
> -		buf = list_entry(fh->vidq.stream.next,
> -			struct cx23885_buffer, vb.stream);
> -	} else {
> -		/* read() capture */
> -		buf = (struct cx23885_buffer *)fh->vidq.read_buf;
> -		if (NULL == buf)
> -			goto done;
> -	}
> -	poll_wait(file, &buf->vb.done, wait);
> -	if (buf->vb.state == VIDEOBUF_DONE ||
> -	    buf->vb.state == VIDEOBUF_ERROR)
> -		rc |= POLLIN | POLLRDNORM;
> -done:
> -	mutex_unlock(&fh->vidq.vb_lock);
> -	return rc;
> -}
> -
> -static int video_release(struct file *file)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = file->private_data;
> -
> -	/* turn off overlay */
> -	if (res_check(fh, RESOURCE_OVERLAY)) {
> -		/* FIXME */
> -		res_free(dev, fh, RESOURCE_OVERLAY);
> -	}
> +	struct cx23885_dev *dev = q->drv_priv;
> +	struct cx23885_dmaqueue *dmaq = &dev->vidq;
> +	unsigned long flags;
>  
> -	/* stop video capture */
> -	if (res_check(fh, RESOURCE_VIDEO)) {
> -		videobuf_queue_cancel(&fh->vidq);
> -		res_free(dev, fh, RESOURCE_VIDEO);
> -	}
> -	if (fh->vidq.read_buf) {
> -		buffer_release(&fh->vidq, fh->vidq.read_buf);
> -		kfree(fh->vidq.read_buf);
> -	}
> +	cx_clear(VID_A_DMA_CTL, 0x11);
> +	spin_lock_irqsave(&dev->slock, flags);
> +	while (!list_empty(&dmaq->active)) {
> +		struct cx23885_buffer *buf = list_entry(dmaq->active.next,
> +			struct cx23885_buffer, queue);
>  
> -	/* stop vbi capture */
> -	if (res_check(fh, RESOURCE_VBI)) {
> -		if (fh->vbiq.streaming)
> -			videobuf_streamoff(&fh->vbiq);
> -		if (fh->vbiq.reading)
> -			videobuf_read_stop(&fh->vbiq);
> -		res_free(dev, fh, RESOURCE_VBI);
> +		list_del(&buf->queue);
> +		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>  	}
> -
> -	videobuf_mmap_free(&fh->vidq);
> -	videobuf_mmap_free(&fh->vbiq);
> -
> -	v4l2_fh_del(&fh->fh);
> -	v4l2_fh_exit(&fh->fh);
> -	file->private_data = NULL;
> -	kfree(fh);
> -
> -	/* We are not putting the tuner to sleep here on exit, because
> -	 * we want to use the mpeg encoder in another session to capture
> -	 * tuner video. Closing this will result in no video to the encoder.
> -	 */
> -
> -	return 0;
> +	spin_unlock_irqrestore(&dev->slock, flags);
>  }
>  
> -static int video_mmap(struct file *file, struct vm_area_struct *vma)
> -{
> -	return videobuf_mmap_mapper(get_queue(file), vma);
> -}
> +static struct vb2_ops cx23885_video_qops = {
> +	.queue_setup    = queue_setup,
> +	.buf_prepare  = buffer_prepare,
> +	.buf_finish = buffer_finish,
> +	.buf_queue    = buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = cx23885_start_streaming,
> +	.stop_streaming = cx23885_stop_streaming,
> +};
>  
>  /* ------------------------------------------------------------------ */
>  /* VIDEO IOCTLS                                                       */
> @@ -819,11 +521,10 @@ static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>  	struct v4l2_format *f)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh   = priv;
>  
>  	f->fmt.pix.width        = dev->width;
>  	f->fmt.pix.height       = dev->height;
> -	f->fmt.pix.field        = fh->vidq.field;
> +	f->fmt.pix.field        = dev->field;
>  	f->fmt.pix.pixelformat  = dev->fmt->fourcc;
>  	f->fmt.pix.bytesperline =
>  		(f->fmt.pix.width * dev->fmt->depth) >> 3;
> @@ -884,7 +585,6 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	struct v4l2_format *f)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> -	struct cx23885_fh *fh = priv;
>  	struct v4l2_mbus_framefmt mbus_fmt;
>  	int err;
>  
> @@ -896,9 +596,9 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
>  	dev->fmt        = format_by_fourcc(f->fmt.pix.pixelformat);
>  	dev->width      = f->fmt.pix.width;
>  	dev->height     = f->fmt.pix.height;
> -	fh->vidq.field = f->fmt.pix.field;
> +	dev->field	= f->fmt.pix.field;
>  	dprintk(2, "%s() width=%d height=%d field=%d\n", __func__,
> -		dev->width, dev->height, fh->vidq.field);
> +		dev->width, dev->height, dev->field);
>  	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
>  	call_all(dev, video, s_mbus_fmt, &mbus_fmt);
>  	v4l2_fill_pix_format(&f->fmt.pix, &mbus_fmt);
> @@ -940,82 +640,6 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
>  	return 0;
>  }
>  
> -static int vidioc_reqbufs(struct file *file, void *priv,
> -	struct v4l2_requestbuffers *p)
> -{
> -	return videobuf_reqbufs(get_queue(file), p);
> -}
> -
> -static int vidioc_querybuf(struct file *file, void *priv,
> -	struct v4l2_buffer *p)
> -{
> -	return videobuf_querybuf(get_queue(file), p);
> -}
> -
> -static int vidioc_qbuf(struct file *file, void *priv,
> -	struct v4l2_buffer *p)
> -{
> -	return videobuf_qbuf(get_queue(file), p);
> -}
> -
> -static int vidioc_dqbuf(struct file *file, void *priv,
> -	struct v4l2_buffer *p)
> -{
> -	return videobuf_dqbuf(get_queue(file), p,
> -				file->f_flags & O_NONBLOCK);
> -}
> -
> -static int vidioc_streamon(struct file *file, void *priv,
> -	enum v4l2_buf_type i)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_fh *fh = priv;
> -	dprintk(1, "%s()\n", __func__);
> -
> -	if (vdev->vfl_type == VFL_TYPE_VBI &&
> -	    i != V4L2_BUF_TYPE_VBI_CAPTURE)
> -		return -EINVAL;
> -	if (vdev->vfl_type == VFL_TYPE_GRABBER &&
> -	    i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	if (unlikely(!res_get(dev, fh, get_resource(i))))
> -		return -EBUSY;
> -
> -	/* Don't start VBI streaming unless vida streaming
> -	 * has already started.
> -	 */
> -	if ((i == V4L2_BUF_TYPE_VBI_CAPTURE) &&
> -		((cx_read(VID_A_DMA_CTL) & 0x11) == 0))
> -		return -EINVAL;
> -
> -	return videobuf_streamon(get_queue(file));
> -}
> -
> -static int vidioc_streamoff(struct file *file, void *priv, enum v4l2_buf_type i)
> -{
> -	struct cx23885_dev *dev = video_drvdata(file);
> -	struct video_device *vdev = video_devdata(file);
> -	struct cx23885_fh *fh = priv;
> -	int err, res;
> -	dprintk(1, "%s()\n", __func__);
> -
> -	if (vdev->vfl_type == VFL_TYPE_VBI &&
> -	    i != V4L2_BUF_TYPE_VBI_CAPTURE)
> -		return -EINVAL;
> -	if (vdev->vfl_type == VFL_TYPE_GRABBER &&
> -	    i != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> -		return -EINVAL;
> -
> -	res = get_resource(i);
> -	err = videobuf_streamoff(get_queue(file));
> -	if (err < 0)
> -		return err;
> -	res_free(dev, fh, res);
> -	return 0;
> -}
> -
>  static int vidioc_g_std(struct file *file, void *priv, v4l2_std_id *id)
>  {
>  	struct cx23885_dev *dev = video_drvdata(file);
> @@ -1292,7 +916,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
>  {
>  	struct v4l2_ctrl *mute;
>  	int old_mute_val = 1;
> -	struct videobuf_dvb_frontend *vfe;
> +	struct vb2_dvb_frontend *vfe;
>  	struct dvb_frontend *fe;
>  
>  	struct analog_parameters params = {
> @@ -1316,7 +940,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
>  	dprintk(1, "%s() frequency=%d tuner=%d std=0x%llx\n", __func__,
>  		params.frequency, f->tuner, params.std);
>  
> -	vfe = videobuf_dvb_get_frontend(&dev->ts2.frontends, 1);
> +	vfe = vb2_dvb_get_frontend(&dev->ts2.frontends, 1);
>  	if (!vfe) {
>  		return -EINVAL;
>  	}
> @@ -1372,28 +996,6 @@ static int vidioc_s_frequency(struct file *file, void *priv,
>  
>  /* ----------------------------------------------------------- */
>  
> -static void cx23885_vid_timeout(unsigned long data)
> -{
> -	struct cx23885_dev *dev = (struct cx23885_dev *)data;
> -	struct cx23885_dmaqueue *q = &dev->vidq;
> -	struct cx23885_buffer *buf;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&dev->slock, flags);
> -	while (!list_empty(&q->active)) {
> -		buf = list_entry(q->active.next,
> -			struct cx23885_buffer, vb.queue);
> -		list_del(&buf->vb.queue);
> -		buf->vb.state = VIDEOBUF_ERROR;
> -		wake_up(&buf->vb.done);
> -		printk(KERN_ERR "%s: [%p/%d] timeout - dma=0x%08lx\n",
> -			dev->name, buf, buf->vb.i,
> -			(unsigned long)buf->risc.dma);
> -	}
> -	cx23885_restart_video_queue(dev, q);
> -	spin_unlock_irqrestore(&dev->slock, flags);
> -}
> -
>  int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
>  {
>  	u32 mask, count;
> @@ -1438,13 +1040,6 @@ int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
>  		spin_unlock(&dev->slock);
>  		handled++;
>  	}
> -	if (status & VID_BC_MSK_RISCI2) {
> -		dprintk(2, "stopper video\n");
> -		spin_lock(&dev->slock);
> -		cx23885_restart_video_queue(dev, &dev->vidq);
> -		spin_unlock(&dev->slock);
> -		handled++;
> -	}
>  
>  	/* Allow the VBI framework to process it's payload */
>  	handled += cx23885_vbi_irq(dev, status);
> @@ -1457,12 +1052,12 @@ int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
>  
>  static const struct v4l2_file_operations video_fops = {
>  	.owner	       = THIS_MODULE,
> -	.open	       = video_open,
> -	.release       = video_release,
> -	.read	       = video_read,
> -	.poll          = video_poll,
> -	.mmap	       = video_mmap,
> +	.open           = v4l2_fh_open,
> +	.release        = vb2_fop_release,
> +	.read           = vb2_fop_read,
> +	.poll		= vb2_fop_poll,
>  	.unlocked_ioctl = video_ioctl2,
> +	.mmap           = vb2_fop_mmap,
>  };
>  
>  static const struct v4l2_ioctl_ops video_ioctl_ops = {
> @@ -1474,18 +1069,19 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
>  	.vidioc_g_fmt_vbi_cap     = cx23885_vbi_fmt,
>  	.vidioc_try_fmt_vbi_cap   = cx23885_vbi_fmt,
>  	.vidioc_s_fmt_vbi_cap     = cx23885_vbi_fmt,
> -	.vidioc_reqbufs       = vidioc_reqbufs,
> -	.vidioc_querybuf      = vidioc_querybuf,
> -	.vidioc_qbuf          = vidioc_qbuf,
> -	.vidioc_dqbuf         = vidioc_dqbuf,
> +	.vidioc_reqbufs       = vb2_ioctl_reqbufs,
> +	.vidioc_prepare_buf   = vb2_ioctl_prepare_buf,
> +	.vidioc_querybuf      = vb2_ioctl_querybuf,
> +	.vidioc_qbuf          = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf         = vb2_ioctl_dqbuf,
> +	.vidioc_streamon      = vb2_ioctl_streamon,
> +	.vidioc_streamoff     = vb2_ioctl_streamoff,
>  	.vidioc_s_std         = vidioc_s_std,
>  	.vidioc_g_std         = vidioc_g_std,
>  	.vidioc_enum_input    = vidioc_enum_input,
>  	.vidioc_g_input       = vidioc_g_input,
>  	.vidioc_s_input       = vidioc_s_input,
>  	.vidioc_log_status    = vidioc_log_status,
> -	.vidioc_streamon      = vidioc_streamon,
> -	.vidioc_streamoff     = vidioc_streamoff,
>  	.vidioc_g_tuner       = vidioc_g_tuner,
>  	.vidioc_s_tuner       = vidioc_s_tuner,
>  	.vidioc_g_frequency   = vidioc_g_frequency,
> @@ -1521,7 +1117,6 @@ void cx23885_video_unregister(struct cx23885_dev *dev)
>  		else
>  			video_device_release(dev->vbi_dev);
>  		dev->vbi_dev = NULL;
> -		btcx_riscmem_free(dev->pci, &dev->vbiq.stopper);
>  	}
>  	if (dev->video_dev) {
>  		if (video_is_registered(dev->video_dev))
> @@ -1529,8 +1124,6 @@ void cx23885_video_unregister(struct cx23885_dev *dev)
>  		else
>  			video_device_release(dev->video_dev);
>  		dev->video_dev = NULL;
> -
> -		btcx_riscmem_free(dev->pci, &dev->vidq.stopper);
>  	}
>  
>  	if (dev->audio_dev)
> @@ -1539,6 +1132,7 @@ void cx23885_video_unregister(struct cx23885_dev *dev)
>  
>  int cx23885_video_register(struct cx23885_dev *dev)
>  {
> +	struct vb2_queue *q;
>  	int err;
>  
>  	dprintk(1, "%s()\n", __func__);
> @@ -1555,21 +1149,9 @@ int cx23885_video_register(struct cx23885_dev *dev)
>  
>  	/* init video dma queues */
>  	INIT_LIST_HEAD(&dev->vidq.active);
> -	INIT_LIST_HEAD(&dev->vidq.queued);
> -	dev->vidq.timeout.function = cx23885_vid_timeout;
> -	dev->vidq.timeout.data = (unsigned long)dev;
> -	init_timer(&dev->vidq.timeout);
> -	cx23885_risc_stopper(dev->pci, &dev->vidq.stopper,
> -		VID_A_DMA_CTL, 0x11, 0x00);
>  
>  	/* init vbi dma queues */
>  	INIT_LIST_HEAD(&dev->vbiq.active);
> -	INIT_LIST_HEAD(&dev->vbiq.queued);
> -	dev->vbiq.timeout.function = cx23885_vbi_timeout;
> -	dev->vbiq.timeout.data = (unsigned long)dev;
> -	init_timer(&dev->vbiq.timeout);
> -	cx23885_risc_stopper(dev->pci, &dev->vbiq.stopper,
> -		VID_A_DMA_CTL, 0x22, 0x00);
>  
>  	cx23885_irq_add_enable(dev, 0x01);
>  
> @@ -1630,9 +1212,42 @@ int cx23885_video_register(struct cx23885_dev *dev)
>  	cx23885_audio_mux(dev, 0);
>  	mutex_unlock(&dev->lock);
>  
> +	q = &dev->vb2_vidq;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +	q->gfp_flags = GFP_DMA32;
> +	q->min_buffers_needed = 2;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct cx23885_buffer);
> +	q->ops = &cx23885_video_qops;
> +	q->mem_ops = &vb2_dma_sg_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &dev->lock;
> +
> +	err = vb2_queue_init(q);
> +	if (err < 0)
> +		goto fail_unreg;
> +
> +	q = &dev->vb2_vbiq;
> +	q->type = V4L2_BUF_TYPE_VBI_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
> +	q->gfp_flags = GFP_DMA32;
> +	q->min_buffers_needed = 2;
> +	q->drv_priv = dev;
> +	q->buf_struct_size = sizeof(struct cx23885_buffer);
> +	q->ops = &cx23885_vbi_qops;
> +	q->mem_ops = &vb2_dma_sg_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->lock = &dev->lock;
> +
> +	err = vb2_queue_init(q);
> +	if (err < 0)
> +		goto fail_unreg;
> +
>  	/* register Video device */
>  	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
>  		&cx23885_video_template, "video");
> +	dev->video_dev->queue = &dev->vb2_vidq;
>  	err = video_register_device(dev->video_dev, VFL_TYPE_GRABBER,
>  				    video_nr[dev->nr]);
>  	if (err < 0) {
> @@ -1646,6 +1261,7 @@ int cx23885_video_register(struct cx23885_dev *dev)
>  	/* register VBI device */
>  	dev->vbi_dev = cx23885_vdev_init(dev, dev->pci,
>  		&cx23885_vbi_template, "vbi");
> +	dev->vbi_dev->queue = &dev->vb2_vbiq;
>  	err = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
>  				    vbi_nr[dev->nr]);
>  	if (err < 0) {
> diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
> index 95f8c42..99a5fe0 100644
> --- a/drivers/media/pci/cx23885/cx23885.h
> +++ b/drivers/media/pci/cx23885/cx23885.h
> @@ -29,8 +29,8 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/tuner.h>
>  #include <media/tveeprom.h>
> -#include <media/videobuf-dma-sg.h>
> -#include <media/videobuf-dvb.h>
> +#include <media/videobuf2-dma-sg.h>
> +#include <media/videobuf2-dvb.h>
>  #include <media/rc-core.h>
>  
>  #include "btcx-risc.h"
> @@ -39,7 +39,7 @@
>  
>  #include <linux/mutex.h>
>  
> -#define CX23885_VERSION "0.0.3"
> +#define CX23885_VERSION "0.0.4"
>  
>  #define UNSET (-1U)
>  
> @@ -48,9 +48,6 @@
>  /* Max number of inputs by card */
>  #define MAX_CX23885_INPUT 8
>  #define INPUT(nr) (&cx23885_boards[dev->board].input[nr])
> -#define RESOURCE_OVERLAY       1
> -#define RESOURCE_VIDEO         2
> -#define RESOURCE_VBI           4
>  
>  #define BUFFER_TIMEOUT     (HZ)  /* 0.5 seconds */
>  
> @@ -140,20 +137,6 @@ struct cx23885_tvnorm {
>  	u32		cxoformat;
>  };
>  
> -struct cx23885_fh {
> -	struct v4l2_fh		   fh;
> -	u32                        resources;
> -	struct cx23885_dev         *q_dev;
> -
> -	/* vbi capture */
> -	struct videobuf_queue      vidq;
> -	struct videobuf_queue      vbiq;
> -
> -	/* MPEG Encoder specifics ONLY */
> -	struct videobuf_queue      mpegq;
> -	atomic_t                   v4l_reading;
> -};
> -
>  enum cx23885_itype {
>  	CX23885_VMUX_COMPOSITE1 = 1,
>  	CX23885_VMUX_COMPOSITE2,
> @@ -176,7 +159,8 @@ enum cx23885_src_sel_type {
>  /* buffer for one video frame */
>  struct cx23885_buffer {
>  	/* common v4l buffer stuff -- must be first */
> -	struct videobuf_buffer vb;
> +	struct vb2_buffer vb;
> +	struct list_head queue;
>  
>  	/* cx23885 specific */
>  	unsigned int           bpl;
> @@ -252,9 +236,6 @@ struct cx23885_i2c {
>  
>  struct cx23885_dmaqueue {
>  	struct list_head       active;
> -	struct list_head       queued;
> -	struct timer_list      timeout;
> -	struct btcx_riscmem    stopper;
>  	u32                    count;
>  };
>  
> @@ -264,7 +245,7 @@ struct cx23885_tsport {
>  	int                        nr;
>  	int                        sram_chno;
>  
> -	struct videobuf_dvb_frontends frontends;
> +	struct vb2_dvb_frontends   frontends;
>  
>  	/* dma queues */
>  	struct cx23885_dmaqueue    mpegq;
> @@ -393,7 +374,6 @@ struct cx23885_dev {
>  	} bridge;
>  
>  	/* Analog video */
> -	u32                        resources;
>  	unsigned int               input;
>  	unsigned int               audinput; /* Selectable audio input */
>  	u32                        tvaudio;
> @@ -424,16 +404,20 @@ struct cx23885_dev {
>  	/* video capture */
>  	struct cx23885_fmt         *fmt;
>  	unsigned int               width, height;
> +	unsigned		   field;
>  
>  	struct cx23885_dmaqueue    vidq;
> +	struct vb2_queue           vb2_vidq;
>  	struct cx23885_dmaqueue    vbiq;
> +	struct vb2_queue           vb2_vbiq;
> +
>  	spinlock_t                 slock;
>  
>  	/* MPEG Encoder ONLY settings */
>  	u32                        cx23417_mailbox;
>  	struct cx2341x_handler     cxhdl;
>  	struct video_device        *v4l_device;
> -	atomic_t                   v4l_reader_count;
> +	struct vb2_queue           vb2_mpegq;
>  	struct cx23885_tvnorm      encodernorm;
>  
>  	/* Analog raw audio */
> @@ -509,9 +493,6 @@ extern int cx23885_sram_channel_setup(struct cx23885_dev *dev,
>  extern void cx23885_sram_channel_dump(struct cx23885_dev *dev,
>  	struct sram_channel *ch);
>  
> -extern int cx23885_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
> -	u32 reg, u32 mask, u32 value);
> -
>  extern int cx23885_risc_buffer(struct pci_dev *pci, struct btcx_riscmem *risc,
>  	struct scatterlist *sglist,
>  	unsigned int top_offset, unsigned int bottom_offset,
> @@ -522,13 +503,11 @@ extern int cx23885_risc_vbibuffer(struct pci_dev *pci,
>  	unsigned int top_offset, unsigned int bottom_offset,
>  	unsigned int bpl, unsigned int padding, unsigned int lines);
>  
> +int cx23885_start_dma(struct cx23885_tsport *port,
> +			     struct cx23885_dmaqueue *q,
> +			     struct cx23885_buffer   *buf);
>  void cx23885_cancel_buffers(struct cx23885_tsport *port);
>  
> -extern int cx23885_restart_queue(struct cx23885_tsport *port,
> -				struct cx23885_dmaqueue *q);
> -
> -extern void cx23885_wakeup(struct cx23885_tsport *port,
> -			   struct cx23885_dmaqueue *q, u32 count);
>  
>  extern void cx23885_gpio_set(struct cx23885_dev *dev, u32 mask);
>  extern void cx23885_gpio_clear(struct cx23885_dev *dev, u32 mask);
> @@ -562,13 +541,11 @@ extern void cx23885_card_setup_pre_i2c(struct cx23885_dev *dev);
>  extern int cx23885_dvb_register(struct cx23885_tsport *port);
>  extern int cx23885_dvb_unregister(struct cx23885_tsport *port);
>  
> -extern int cx23885_buf_prepare(struct videobuf_queue *q,
> -			       struct cx23885_tsport *port,
> -			       struct cx23885_buffer *buf,
> -			       enum v4l2_field field);
> +extern int cx23885_buf_prepare(struct cx23885_buffer *buf,
> +			       struct cx23885_tsport *port);
>  extern void cx23885_buf_queue(struct cx23885_tsport *port,
>  			      struct cx23885_buffer *buf);
> -extern void cx23885_free_buffer(struct videobuf_queue *q,
> +extern void cx23885_free_buffer(struct cx23885_dev *dev,
>  				struct cx23885_buffer *buf);
>  
>  /* ----------------------------------------------------------- */
> @@ -590,9 +567,7 @@ int cx23885_set_tvnorm(struct cx23885_dev *dev, v4l2_std_id norm);
>  extern int cx23885_vbi_fmt(struct file *file, void *priv,
>  	struct v4l2_format *f);
>  extern void cx23885_vbi_timeout(unsigned long data);
> -extern struct videobuf_queue_ops cx23885_vbi_qops;
> -extern int cx23885_restart_vbi_queue(struct cx23885_dev *dev,
> -	struct cx23885_dmaqueue *q);
> +extern struct vb2_ops cx23885_vbi_qops;
>  extern int cx23885_vbi_irq(struct cx23885_dev *dev, u32 status);
>  
>  /* cx23885-i2c.c                                                */
