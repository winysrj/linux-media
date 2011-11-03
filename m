Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38643 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1KCNc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Nov 2011 09:32:28 -0400
Message-ID: <4EB297E6.6060608@infradead.org>
Date: Thu, 03 Nov 2011 11:32:22 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PULL] soc-camera, v4l for 3.2
References: <Pine.LNX.4.64.1109291714560.1082@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109291714560.1082@axis700.grange>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-09-2011 12:25, Guennadi Liakhovetski escreveu:
> Hi Mauro
> 
> I'm finally ready to push my soc-camera and generic v4l collection for 
> 3.2. The absolute highlight is, of course, the addition of the two new 
> IOCTLs, which, I think, are now in a good shape to go. A huge pile of 
> soc-camera patches, largely releasing subdevice drivers into the wild for 
> all subdevice API compatible bridge drivers, the addition of the control 
> framework to soc-camera - thanks to Hans Verkuil. A few patches outside of 
> the V4L / media area are supplied with respective acks. I think, this is 
> going to be my largest push so far.
> 
> The following changes since commit 446b792c6bd87de4565ba200b75a708b4c575a06:
> 
>   [media] media: DocBook: Fix trivial typo in Sub-device Interface (2011-09-27 09:14:58 -0300)
> 
> are available in the git repository at:
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.2
> 
> Bastian Hecht (1):
>       media: ov5642: Add support for arbitrary resolution
> 
> Guennadi Liakhovetski (86):
>       V4L: mt9p031 and mt9t001 drivers depend on VIDEO_V4L2_SUBDEV_API
>       V4L: sh_mobile_ceu_camera: output image sizes must be a multiple of 4
>       V4L: sh_mobile_ceu_camera: don't try to improve client scaling, if perfect
>       V4L: sh_mobile_ceu_camera: fix field addresses in interleaved mode
>       V4L: sh_mobile_ceu_camera: remove duplicated code
>       V4L: imx074: support the new mbus-config subdev ops
>       V4L: soc-camera: add helper functions for new bus configuration type
>       V4L: mt9m001: support the new mbus-config subdev ops
>       V4L: mt9m111: support the new mbus-config subdev ops
>       V4L: mt9t031: support the new mbus-config subdev ops
>       V4L: mt9t112: support the new mbus-config subdev ops
>       V4L: mt9v022: support the new mbus-config subdev ops
>       V4L: ov2640: support the new mbus-config subdev ops
>       V4L: ov5642: support the new mbus-config subdev ops
>       V4L: ov6650: support the new mbus-config subdev ops
>       V4L: ov772x: rename macros to not pollute the global namespace
>       V4L: ov772x: support the new mbus-config subdev ops
>       V4L: ov9640: support the new mbus-config subdev ops
>       V4L: ov9740: support the new mbus-config subdev ops
>       V4L: rj54n1cb0c: support the new mbus-config subdev ops
>       ARM: ap4evb: switch imx074 configuration to default number of lanes
>       V4L: sh_mobile_csi2: verify client compatibility
>       V4L: sh_mobile_csi2: support the new mbus-config subdev ops
>       V4L: tw9910: remove a not really implemented cropping support
>       V4L: tw9910: support the new mbus-config subdev ops
>       V4L: soc_camera_platform: support the new mbus-config subdev ops
>       V4L: soc-camera: compatible bus-width flags
>       ARM: mach-shmobile: convert mackerel to mediabus flags
>       sh: convert ap325rxa to mediabus flags
>       ARM: PXA: use gpio_set_value_cansleep() on pcm990
>       V4L: atmel-isi: convert to the new mbus-config subdev operations
>       V4L: mx1_camera: convert to the new mbus-config subdev operations
>       V4L: mx2_camera: convert to the new mbus-config subdev operations
>       V4L: ov2640: remove undefined struct
>       V4L: mx3_camera: convert to the new mbus-config subdev operations
>       V4L: mt9m001, mt9v022: add a clarifying comment
>       V4L: omap1_camera: convert to the new mbus-config subdev operations
>       V4L: pxa_camera: convert to the new mbus-config subdev operations
>       V4L: sh_mobile_ceu_camera: convert to the new mbus-config subdev operations
>       V4L: soc-camera: camera client operations no longer compulsory
>       V4L: mt9m001: remove superfluous soc-camera client operations
>       V4L: mt9m111: remove superfluous soc-camera client operations
>       V4L: imx074: remove superfluous soc-camera client operations
>       V4L: mt9t031: remove superfluous soc-camera client operations
>       V4L: mt9t112: remove superfluous soc-camera client operations
>       V4L: mt9v022: remove superfluous soc-camera client operations
>       V4L: ov2640: remove superfluous soc-camera client operations
>       V4L: ov5642: remove superfluous soc-camera client operations
>       V4L: ov6650: remove superfluous soc-camera client operations
>       sh: ap3rxa: remove redundant soc-camera platform data fields
>       sh: migor: remove unused ov772x buswidth flag
>       V4L: ov772x: remove superfluous soc-camera client operations
>       V4L: ov9640: remove superfluous soc-camera client operations
>       V4L: ov9740: remove superfluous soc-camera client operations
>       V4L: rj54n1cb0c: remove superfluous soc-camera client operations
>       V4L: sh_mobile_csi2: remove superfluous soc-camera client operations
>       ARM: mach-shmobile: mackerel doesn't need legacy SOCAM_* flags anymore
>       V4L: soc_camera_platform: remove superfluous soc-camera client operations
>       V4L: tw9910: remove superfluous soc-camera client operations
>       V4L: soc-camera: remove soc-camera client bus-param operations and supporting code
>       V4L: mt9t112: fix broken cropping and scaling
>       V4L: sh-mobile-ceu-camera: fix mixed CSI2 & parallel camera case
>       V4L: omap1-camera: fix Oops with NULL platform data
>       V4L: add a new videobuf2 buffer state VB2_BUF_STATE_PREPARED
>       V4L: add two new ioctl()s for multi-size videobuffer management
>       V4L: videobuf2: update buffer state on VIDIOC_QBUF
>       V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
>       V4L: vb2: prepare to support multi-size buffers
>       V4L: vb2: add support for buffers of different sizes on a single queue
>       V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
>       dmaengine: ipu-idmac: add support for the DMA_PAUSE control
>       V4L: mx3-camera: prepare to support multi-size buffers

> patches/0070-V4L-sh-mobile-ceu-camera-prepare-to-support-multi-si.patch
> From bbc1c627edaffd40b76de841fa09c03ad5453bb4 Mon Sep 17 00:00:00 2001
> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Date: Wed, 31 Aug 2011 12:00:02 +0200
> Subject: V4L: sh-mobile-ceu-camera: prepare to support multi-size buffers
> Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> 
> Prepare the sh_mobile_ceu_camera friver to support the new
> VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s. The .queue_setup()
> vb2 operation must be able to handle buffer sizes, provided by the
> caller, and the .buf_prepare() operation must not use the currently
> configured frame format for its operation.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/video/sh_mobile_ceu_camera.c |  122 ++++++++++++++++++----------
>  1 files changed, 79 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/media/video/sh_mobile_ceu_camera.c b/drivers/media/video/sh_mobile_ceu_camera.c
> index 0cb1968..3be8915 100644
> --- a/drivers/media/video/sh_mobile_ceu_camera.c
> +++ b/drivers/media/video/sh_mobile_ceu_camera.c
> @@ -90,7 +90,6 @@
>  struct sh_mobile_ceu_buffer {
>  	struct vb2_buffer vb; /* v4l buffer must be first */
>  	struct list_head queue;
> -	enum v4l2_mbus_pixelcode code;
>  };
>  
>  struct sh_mobile_ceu_dev {
> @@ -100,7 +99,8 @@ struct sh_mobile_ceu_dev {
>  
>  	unsigned int irq;
>  	void __iomem *base;
> -	unsigned long video_limit;
> +	size_t video_limit;
> +	size_t buf_total;
>  
>  	spinlock_t lock;		/* Protects video buffer lists */
>  	struct list_head capture;
> @@ -192,6 +192,12 @@ static int sh_mobile_ceu_soft_reset(struct sh_mobile_ceu_dev *pcdev)
>  /*
>   *  Videobuf operations
>   */
> +
> +/*
> + * .queue_setup() is called to check, whether the driver can accept the
> + *		  requested number of buffers and to fill in plane sizes
> + *		  for the current frame format if required
> + */
>  static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
>  			const struct v4l2_format *fmt,
>  			unsigned int *count, unsigned int *num_planes,
> @@ -200,26 +206,45 @@ static int sh_mobile_ceu_videobuf_setup(struct vb2_queue *vq,
>  	struct soc_camera_device *icd = container_of(vq, struct soc_camera_device, vb2_vidq);
>  	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>  	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> -	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> -						icd->current_fmt->host_fmt);
> +	int bytes_per_line;
> +	unsigned int height;
>  
> +	if (fmt) {
> +		const struct soc_camera_format_xlate *xlate = soc_camera_xlate_by_fourcc(icd,
> +								fmt->fmt.pix.pixelformat);
> +		bytes_per_line = soc_mbus_bytes_per_line(fmt->fmt.pix.width,
> +							 xlate->host_fmt);

This doesn't sound right, as xlate could be NULL.

> +		height = fmt->fmt.pix.height;
> +	} else {
> +		/* Called from VIDIOC_REQBUFS or in compatibility mode */
> +		bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
> +						icd->current_fmt->host_fmt);
> +		height = icd->user_height;
> +	}
>  	if (bytes_per_line < 0)
>  		return bytes_per_line;
>  
> -	*num_planes = 1;
> +	sizes[0] = bytes_per_line * height;
>  
> -	pcdev->sequence = 0;
> -	sizes[0] = bytes_per_line * icd->user_height;
>  	alloc_ctxs[0] = pcdev->alloc_ctx;
>  
> +	if (!vq->num_buffers)
> +		pcdev->sequence = 0;
> +
>  	if (!*count)
>  		*count = 2;
>  
> -	if (pcdev->video_limit) {
> -		if (PAGE_ALIGN(sizes[0]) * *count > pcdev->video_limit)
> -			*count = pcdev->video_limit / PAGE_ALIGN(sizes[0]);
> +	/* If *num_planes != 0, we have already verified *count. */
> +	if (pcdev->video_limit && !*num_planes) {
> +		size_t size = PAGE_ALIGN(sizes[0]) * *count;

This looks ugly. Better to write it as:
	size_t size = PAGE_ALIGN(sizes[0]) * (*count);


> +
> +		if (size + pcdev->buf_total > pcdev->video_limit)
> +			*count = (pcdev->video_limit - pcdev->buf_total) /
> +				PAGE_ALIGN(sizes[0]);
>  	}
>  
> +	*num_planes = 1;
> +
>  	dev_dbg(icd->parent, "count=%d, size=%u\n", *count, sizes[0]);
>  
>  	return 0;
> @@ -331,23 +356,40 @@ static int sh_mobile_ceu_capture(struct sh_mobile_ceu_dev *pcdev)
>  
>  static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
>  {
> +	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
> +
> +	/* Added list head initialization on alloc */
> +	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
> +
> +	return 0;
> +}
> +
> +static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
> +{
>  	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
> -	struct sh_mobile_ceu_buffer *buf;
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> +	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
> +	unsigned long size;
>  	int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>  						icd->current_fmt->host_fmt);
> -	unsigned long size;
>  
>  	if (bytes_per_line < 0)
> -		return bytes_per_line;
> +		goto error;
> +
> +	size = icd->user_height * bytes_per_line;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(icd->parent, "Buffer #%d too small (%lu < %lu)\n",
> +			vb->v4l2_buf.index, vb2_plane_size(vb, 0), size);
> +		goto error;
> +	}
>  
> -	buf = to_ceu_vb(vb);
> +	vb2_set_plane_payload(vb, 0, size);
>  
>  	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
>  		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
>  
> -	/* Added list head initialization on alloc */
> -	WARN(!list_empty(&buf->queue), "Buffer %p on queue!\n", vb);
> -
>  #ifdef DEBUG
>  	/*
>  	 * This can be useful if you want to see if we actually fill
> @@ -357,31 +399,6 @@ static int sh_mobile_ceu_videobuf_prepare(struct vb2_buffer *vb)
>  		memset(vb2_plane_vaddr(vb, 0), 0xaa, vb2_get_plane_payload(vb, 0));
>  #endif
>  
> -	BUG_ON(NULL == icd->current_fmt);
> -
> -	size = icd->user_height * bytes_per_line;
> -
> -	if (vb2_plane_size(vb, 0) < size) {
> -		dev_err(icd->parent, "Buffer too small (%lu < %lu)\n",
> -			vb2_plane_size(vb, 0), size);
> -		return -ENOBUFS;
> -	}
> -
> -	vb2_set_plane_payload(vb, 0, size);
> -
> -	return 0;
> -}
> -
> -static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
> -{
> -	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> -	struct sh_mobile_ceu_buffer *buf = to_ceu_vb(vb);
> -
> -	dev_dbg(icd->parent, "%s (vb=0x%p) 0x%p %lu\n", __func__,
> -		vb, vb2_plane_vaddr(vb, 0), vb2_get_plane_payload(vb, 0));
> -
>  	spin_lock_irq(&pcdev->lock);
>  	list_add_tail(&buf->queue, &pcdev->capture);
>  
> @@ -395,6 +412,11 @@ static void sh_mobile_ceu_videobuf_queue(struct vb2_buffer *vb)
>  		sh_mobile_ceu_capture(pcdev);
>  	}
>  	spin_unlock_irq(&pcdev->lock);
> +
> +	return;
> +
> +error:
> +	vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>  }
>  
>  static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
> @@ -419,11 +441,23 @@ static void sh_mobile_ceu_videobuf_release(struct vb2_buffer *vb)
>  	if (buf->queue.next)
>  		list_del_init(&buf->queue);
>  
> +	pcdev->buf_total -= PAGE_ALIGN(vb2_plane_size(vb, 0));
> +	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
> +		pcdev->buf_total);
> +
>  	spin_unlock_irq(&pcdev->lock);
>  }
>  
>  static int sh_mobile_ceu_videobuf_init(struct vb2_buffer *vb)
>  {
> +	struct soc_camera_device *icd = container_of(vb->vb2_queue, struct soc_camera_device, vb2_vidq);
> +	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> +	struct sh_mobile_ceu_dev *pcdev = ici->priv;
> +
> +	pcdev->buf_total += PAGE_ALIGN(vb2_plane_size(vb, 0));
> +	dev_dbg(icd->parent, "%s() %zu bytes buffers\n", __func__,
> +		pcdev->buf_total);
> +
>  	/* This is for locking debugging only */
>  	INIT_LIST_HEAD(&to_ceu_vb(vb)->queue);
>  	return 0;
> @@ -525,6 +559,8 @@ static int sh_mobile_ceu_add_device(struct soc_camera_device *icd)
>  
>  	pm_runtime_get_sync(ici->v4l2_dev.dev);
>  
> +	pcdev->buf_total = 0;
> +
>  	ret = sh_mobile_ceu_soft_reset(pcdev);
>  
>  	csi2_sd = find_csi2(pcdev);
> @@ -1674,7 +1710,7 @@ static int sh_mobile_ceu_set_fmt(struct soc_camera_device *icd,
>  		image_mode = false;
>  	}
>  
> -	dev_info(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
> +	dev_geo(dev, "S_FMT(pix=0x%x, fld 0x%x, code 0x%x, %ux%u)\n", pixfmt, mf.field, mf.code,
>  		pix->width, pix->height);
>  
>  	dev_geo(dev, "4: request camera output %ux%u\n", mf.width, mf.height);
> -- 
> 1.7.6.4
> 
