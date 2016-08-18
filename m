Return-path: <linux-media-owner@vger.kernel.org>
Received: from exsmtp03.microchip.com ([198.175.253.49]:24544 "EHLO
	email.microchip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750720AbcHRFye (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2016 01:54:34 -0400
Subject: Re: [RFC PATCH 6/7] atmel-isi: remove dependency of the soc-camera
 framework
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>
References: <1471415383-38531-1-git-send-email-hverkuil@xs4all.nl>
 <1471415383-38531-7-git-send-email-hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>
From: "Wu, Songjun" <Songjun.Wu@microchip.com>
Message-ID: <3b1f31fd-c6c9-2d8d-008a-4491e2132160@microchip.com>
Date: Thu, 18 Aug 2016 13:53:31 +0800
MIME-Version: 1.0
In-Reply-To: <1471415383-38531-7-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On 8/17/2016 14:29, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> This patch converts the atmel-isi driver from a soc-camera driver to a driver
> that is stand-alone.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/soc_camera/Kconfig     |    3 +-
>  drivers/media/platform/soc_camera/atmel-isi.c | 1216 +++++++++++++++----------
>  2 files changed, 721 insertions(+), 498 deletions(-)
>
> diff --git a/drivers/media/platform/soc_camera/Kconfig b/drivers/media/platform/soc_camera/Kconfig
> index 39f6641..f74e358 100644
> --- a/drivers/media/platform/soc_camera/Kconfig
> +++ b/drivers/media/platform/soc_camera/Kconfig
> @@ -54,9 +54,8 @@ config VIDEO_SH_MOBILE_CEU
>
>  config VIDEO_ATMEL_ISI
>  	tristate "ATMEL Image Sensor Interface (ISI) support"
> -	depends on VIDEO_DEV && SOC_CAMERA
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF && HAS_DMA
>  	depends on ARCH_AT91 || COMPILE_TEST
> -	depends on HAS_DMA
>  	select VIDEOBUF2_DMA_CONTIG
>  	---help---
>  	  This module makes the ATMEL Image Sensor Interface available
> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index 30211f6..9947acb 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c
> @@ -22,18 +22,22 @@

<snip>

>
> @@ -305,26 +292,21 @@ static int queue_setup(struct vb2_queue *vq,
>  				unsigned int *nbuffers, unsigned int *nplanes,
>  				unsigned int sizes[], struct device *alloc_devs[])
>  {
> -	struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
> -	struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
> -	struct atmel_isi *isi = ici->priv;
> +	struct atmel_isi *isi = vq->drv_priv;
It's better to use vb2_get_drv_priv.
struct atmel_isi *isi = vb2_get_drv_priv(vq);

>  	unsigned long size;
>
> -	size = icd->sizeimage;
> +	size = isi->fmt.fmt.pix.sizeimage;
>
> -	if (!*nbuffers || *nbuffers > MAX_BUFFER_NUM)
> -		*nbuffers = MAX_BUFFER_NUM;
> -
> -	if (size * *nbuffers > VID_LIMIT_BYTES)
> -		*nbuffers = VID_LIMIT_BYTES / size;
> +	/* Make sure the image size is large enough. */
> +	if (*nplanes)
> +		return sizes[0] < size ? -EINVAL : 0;
>
>  	*nplanes = 1;
>  	sizes[0] = size;
>
> -	isi->sequence = 0;
>  	isi->active = NULL;
>
> -	dev_dbg(icd->parent, "%s, count=%d, size=%ld\n", __func__,
> +	dev_dbg(isi->dev, "%s, count=%d, size=%ld\n", __func__,
>  		*nbuffers, size);
>
>  	return 0;

<snip>

>
> +static int isi_open(struct file *file)
> +{
> +	struct atmel_isi *isi = video_drvdata(file);
> +	struct v4l2_subdev *sd = isi->entity.subdev;
> +	int ret;
> +
> +	if (mutex_lock_interruptible(&isi->lock))
> +		return -ERESTARTSYS;
> +
> +	ret = v4l2_fh_open(file);
> +	if (ret < 0)
> +		goto unlock;
> +
> +	if (!v4l2_fh_is_singular_file(file))
> +		goto unlock;
> +
> +	ret = v4l2_subdev_call(sd, core, s_power, 1);
> +	if (ret < 0 && ret != -ENOIOCTLCMD)
> +		goto unlock;
v4l2_fh_release should be called on error;

> +
> +	ret = isi_set_fmt(isi, &isi->fmt);
> +	if (ret)
> +		v4l2_subdev_call(sd, core, s_power, 0);
> +unlock:
> +	mutex_unlock(&isi->lock);
> +	return ret;
> +}
> +

<snip>

> +
> +static int isi_graph_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct atmel_isi *isi = notifier_to_isi(notifier);
> +	int ret;
> +
> +	ret = v4l2_device_register_subdev_nodes(&isi->v4l2_dev);
> +	if (ret < 0) {
> +		dev_err(isi->dev, "Failed to register subdev nodes\n");
> +		return ret;
> +	}
> +
> +	isi->vdev->ctrl_handler	= isi->entity.subdev->ctrl_handler;
> +	isi->entity.config = v4l2_subdev_alloc_pad_config(isi->entity.subdev);
isi->entity.config maybe assigned to 'NULL'. It's better to add code to 
judge its value.

> +	ret = isi_formats_init(isi);
> +	if (ret) {
> +		dev_err(isi->dev, "No supported mediabus format found\n");
> +		return ret;
> +	}
> +	isi_camera_set_bus_param(isi);
> +
> +	ret = isi_set_default_fmt(isi);
> +	if (ret) {
> +		dev_err(isi->dev, "Could not set default format\n");
> +		return ret;
> +	}
> +
> +	ret = video_register_device(isi->vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(isi->dev, "Failed to register video device\n");
> +		return ret;
> +	}
> +
> +	dev_info(isi->dev, "Device registered as %s\n",
> +		 video_device_node_name(isi->vdev));
> +	return 0;
> +}
> +

<snip>

> +
>  static int atmel_isi_probe(struct platform_device *pdev)
>  {
>  	int irq;
>  	struct atmel_isi *isi;
> +	struct vb2_queue *q;
>  	struct resource *regs;
>  	int ret, i;
> -	struct soc_camera_host *soc_host;
>
>  	isi = devm_kzalloc(&pdev->dev, sizeof(struct atmel_isi), GFP_KERNEL);
>  	if (!isi) {
> @@ -1044,20 +1216,65 @@ static int atmel_isi_probe(struct platform_device *pdev)
>  		return ret;
>
>  	isi->active = NULL;
> -	spin_lock_init(&isi->lock);
> +	isi->dev = &pdev->dev;
> +	mutex_init(&isi->lock);
> +	spin_lock_init(&isi->irqlock);
>  	INIT_LIST_HEAD(&isi->video_buffer_list);
>  	INIT_LIST_HEAD(&isi->dma_desc_head);
>
> +	q = &isi->queue;
> +
> +	/* Initialize the top-level structure */
> +	ret = v4l2_device_register(&pdev->dev, &isi->v4l2_dev);
> +	if (ret)
> +		return ret;
> +
> +	isi->vdev = video_device_alloc();
> +	if (isi->vdev == NULL) {
> +		ret = -ENOMEM;
> +		goto err_vdev_alloc;
> +	}
If video device is unregistered, the ISI driver must be reloaded when 
registering a new video device.
So '*vdev' can be replaced by 'vdev', or move the code above to 
isi_graph_notify_complete.

> +
> +	/* video node */
> +	isi->vdev->fops = &isi_fops;
> +	isi->vdev->v4l2_dev = &isi->v4l2_dev;
> +	isi->vdev->queue = &isi->queue;
> +	strlcpy(isi->vdev->name, KBUILD_MODNAME, sizeof(isi->vdev->name));
> +	isi->vdev->release = video_device_release;
> +	isi->vdev->ioctl_ops = &isi_ioctl_ops;
> +	isi->vdev->lock = &isi->lock;
> +	isi->vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +		V4L2_CAP_READWRITE;
> +	video_set_drvdata(isi->vdev, isi);
> +
> +	/* buffer queue */
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_READ | VB2_DMABUF;
> +	q->lock = &isi->lock;
> +	q->drv_priv = isi;
> +	q->buf_struct_size = sizeof(struct frame_buffer);
> +	q->ops = &isi_video_qops;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
> +	q->dev = &pdev->dev;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to initialize VB2 queue\n");
> +		goto err_vb2_queue;
> +	}

Regards,
	Songjun Wu


