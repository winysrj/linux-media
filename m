Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:52679 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753308AbbGXNgh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jul 2015 09:36:37 -0400
Message-ID: <55B23F1C.1060507@xs4all.nl>
Date: Fri, 24 Jul 2015 15:35:24 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Helen Fornazier <helen.fornazier@gmail.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] [media] vmc: Virtual Media Controller core, capture and
 sensor
References: <7c3e9d96feb04697ccf4ea24d51c4db1a33a4729.1437230226.git.helen.fornazier@gmail.com>
In-Reply-To: <7c3e9d96feb04697ccf4ea24d51c4db1a33a4729.1437230226.git.helen.fornazier@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Thank you for creating this driver! Much appreciated!

I do have some comments, see my notes below...

On 07/18/2015 04:42 PM, Helen Fornazier wrote:
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> ---
> 
> The Virtual Media Controller is meant to provide a test tool which simulates a configurable video pipeline exposing
> the configuration of its individual nodes (such as sensors, debayers, scalers, inputs, outputs) throught the subdevice API.
> 
> This first version generates a grey image with a fixed format within a thread in the sensor, but it will be integrated with
> the Test Pattern Generator from the Vivid driver in the future.
> 
> For more information: http://kernelnewbies.org/LaurentPinchart
> 
> The patch is based on 'media/master' branch and available at
>         https://github.com/helen-fornazier/opw-staging vmc/review/video-pipe
> 
>  drivers/media/Kconfig           |   1 +
>  drivers/media/Makefile          |   2 +-
>  drivers/media/vmc/Kconfig       |   6 +
>  drivers/media/vmc/Makefile      |   4 +
>  drivers/media/vmc/vmc-capture.c | 528 +++++++++++++++++++++++++++++++++++
>  drivers/media/vmc/vmc-capture.h |  50 ++++
>  drivers/media/vmc/vmc-core.c    | 595 ++++++++++++++++++++++++++++++++++++++++
>  drivers/media/vmc/vmc-core.h    |  55 ++++
>  drivers/media/vmc/vmc-sensor.c  | 275 +++++++++++++++++++
>  drivers/media/vmc/vmc-sensor.h  |  40 +++
>  10 files changed, 1555 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/media/vmc/Kconfig

As was mentioned before, this virtual driver should go into the platform
directory.

I would also prefer that is was renamed to vimc to be consistent with the vim2m and
vivid drivers (all with 'vi' prefixes).

>  create mode 100644 drivers/media/vmc/Makefile
>  create mode 100644 drivers/media/vmc/vmc-capture.c
>  create mode 100644 drivers/media/vmc/vmc-capture.h
>  create mode 100644 drivers/media/vmc/vmc-core.c
>  create mode 100644 drivers/media/vmc/vmc-core.h
>  create mode 100644 drivers/media/vmc/vmc-sensor.c
>  create mode 100644 drivers/media/vmc/vmc-sensor.h
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 3ef3d6c..6804a32 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -216,5 +216,6 @@ config MEDIA_ATTACH
>  source "drivers/media/i2c/Kconfig"
>  source "drivers/media/tuners/Kconfig"
>  source "drivers/media/dvb-frontends/Kconfig"
> +source "drivers/media/vmc/Kconfig"
>  
>  endif # MEDIA_SUPPORT
> diff --git a/drivers/media/Makefile b/drivers/media/Makefile
> index e608bbc..471ea93 100644
> --- a/drivers/media/Makefile
> +++ b/drivers/media/Makefile
> @@ -28,6 +28,6 @@ obj-y += rc/
>  # Finally, merge the drivers that require the core
>  #
>  
> -obj-y += common/ platform/ pci/ usb/ mmc/ firewire/
> +obj-y += common/ platform/ pci/ usb/ mmc/ firewire/ vmc/
>  obj-$(CONFIG_VIDEO_DEV) += radio/
>  
> diff --git a/drivers/media/vmc/Kconfig b/drivers/media/vmc/Kconfig
> new file mode 100644
> index 0000000..72aba9a
> --- /dev/null
> +++ b/drivers/media/vmc/Kconfig
> @@ -0,0 +1,6 @@
> +config VMC
> +	tristate "Virtual Media Controller Driver (VMC)"
> +	depends on VIDEO_V4L2_SUBDEV_API
> +	default n
> +	---help---
> +	  Skeleton driver for Virtual Media Controller
> diff --git a/drivers/media/vmc/Makefile b/drivers/media/vmc/Makefile
> new file mode 100644
> index 0000000..6eb773c
> --- /dev/null
> +++ b/drivers/media/vmc/Makefile
> @@ -0,0 +1,4 @@
> +vmc-objs := vmc-core.o vmc-capture.o vmc-sensor.o
> +
> +
> +obj-$(CONFIG_VMC) += vmc.o
> diff --git a/drivers/media/vmc/vmc-capture.c b/drivers/media/vmc/vmc-capture.c
> new file mode 100644
> index 0000000..9367973
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-capture.c
> @@ -0,0 +1,528 @@
> +/*
> + * vmc-capture.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <media/videobuf2-vmalloc.h>
> +#include <media/v4l2-ioctl.h>
> +
> +#include "vmc-capture.h"
> +
> +struct vmc_cap_buffer {
> +	/*
> +	 * vb2_buffer must be the first element
> +	 * the videobf2 framework will allocate this struct based on
> +	 * buf_struct_size and use the first sizeof(struct vb2_buffer) bytes of
> +	 * memory as a vb2_buffer
> +	 */
> +	struct vb2_buffer vb2;
> +	struct list_head list;
> +};
> +
> +static int vmc_cap_querycap(struct file *file, void *priv,
> +			    struct v4l2_capability *cap)
> +{
> +	struct vmc_cap_device *vcap = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +			"platform:%s", vcap->v4l2_dev->name);
> +
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	return 0;
> +}
> +
> +static int vmc_cap_enum_input(struct file *file, void *priv,
> +			      struct v4l2_input *i)
> +{
> +	/* We just have one input */
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "VMC capture", sizeof(i->name));
> +
> +	return 0;
> +}
> +
> +static int vmc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	/* We just have one input */
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int vmc_cap_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	/* We just have one input */
> +	if (i > 0)
> +		return -EINVAL;
> +
> +	return 0;

I'd just do this in a one-liner: return i ? -EINVAL : 0;

> +}
> +
> +static int vmc_cap_g_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_format *f)
> +{
> +	struct vmc_cap_device *vcap = video_drvdata(file);
> +
> +	f->fmt.pix = vcap->format;
> +
> +	return 0;
> +}
> +
> +static int vmc_cap_s_fmt_vid_cap(struct file *file, void *priv,
> +				 struct v4l2_format *f)
> +{
> +	/* We just support one format for now */
> +	return vmc_cap_g_fmt_vid_cap(file, priv, f);
> +}
> +
> +static int vmc_cap_try_fmt_vid_cap(struct file *file, void *priv,
> +				   struct v4l2_format *f)
> +{
> +	/* We just support one format for now */
> +	return vmc_cap_g_fmt_vid_cap(file, priv, f);
> +}

No need to make s/try_fmt functions, instead point the callbacks for both
to the vmc_cap_g_fmt_vid_cap function.

> +
> +static int vmc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
> +				    struct v4l2_fmtdesc *f)
> +{
> +	struct vmc_cap_device *vcap = video_drvdata(file);
> +
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	/* We just support one format for now */
> +	f->pixelformat = vcap->format.pixelformat;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations vmc_cap_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.read           = vb2_fop_read,
> +	.poll		= vb2_fop_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap           = vb2_fop_mmap,
> +};
> +
> +static const struct v4l2_ioctl_ops vmc_cap_ioctl_ops = {
> +	.vidioc_querycap = vmc_cap_querycap,
> +
> +	.vidioc_enum_input = vmc_cap_enum_input,
> +	.vidioc_g_input = vmc_cap_g_input,
> +	.vidioc_s_input = vmc_cap_s_input,
> +
> +	.vidioc_g_fmt_vid_cap = vmc_cap_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = vmc_cap_s_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = vmc_cap_try_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = vmc_cap_enum_fmt_vid_cap,
> +
> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
> +	.vidioc_querybuf = vb2_ioctl_querybuf,
> +	.vidioc_qbuf = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
> +	.vidioc_expbuf = vb2_ioctl_expbuf,
> +	.vidioc_streamon = vb2_ioctl_streamon,
> +	.vidioc_streamoff = vb2_ioctl_streamoff,
> +};
> +
> +static void vmc_cap_return_all_buffers(struct vmc_cap_device *vcap,
> +				       enum vb2_buffer_state state)
> +{
> +	struct vmc_cap_buffer *vbuf, *node;
> +
> +	spin_lock(&vcap->qlock);
> +
> +	list_for_each_entry_safe(vbuf, node, &vcap->buf_list, list) {
> +		vb2_buffer_done(&vbuf->vb2, state);
> +		list_del(&vbuf->list);
> +	}
> +
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vmc_cap_pipeline_s_stream(struct vmc_cap_device *vcap, int enable)
> +{
> +	int ret;
> +	struct media_pad *pad;
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +
> +	/* Start the stream in the subdevice direct connected */
> +	entity = &vcap->vdev.entity;
> +	pad = media_entity_remote_pad(&entity->pads[0]);
> +
> +	/* If we are not connected to any subdev node, it means there is nothing
> +	 * to activate on the pipe (e.g. we can be connected with an input
> +	 * device or we are not connected at all)*/
> +	if (pad == NULL ||
> +	    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return 0;
> +
> +	entity = pad->entity;
> +	sd = media_entity_to_v4l2_subdev(entity);
> +
> +	ret = v4l2_subdev_call(sd, video, s_stream, enable);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int vmc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	int ret;
> +	struct media_entity *entity;
> +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vq);

I would reorder this to:

	struct vmc_cap_device *vcap = vb2_get_drv_priv(vq);
	struct media_entity *entity;
	int ret;

The code flow looks nicer due to the reducing line length. Sounds stupid but
if you look at other sources you'll see that this is often how it is done
(unless there are reasons why you need a specific order, of course).

> +
> +	vcap->sequence = 0;
> +
> +	/* Start the media pipeline */
> +	entity = &vcap->vdev.entity;
> +	ret = media_entity_pipeline_start(entity, NULL);
> +	if (ret) {
> +		vmc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	/* Enable streaming from the pipe */
> +	ret = vmc_cap_pipeline_s_stream(vcap, 1);
> +	if (ret) {
> +		vmc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Stop the stream engine. Any remaining buffers in the stream queue are
> + * dequeued and passed on to the vb2 framework marked as STATE_ERROR.
> + */
> +static void vmc_cap_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	/* Disable streaming from the pipe */
> +	vmc_cap_pipeline_s_stream(vcap, 0);
> +
> +	/* Stop the media pipeline */
> +	media_entity_pipeline_stop(&vcap->vdev.entity);
> +
> +	/* Release all active buffers */
> +	vmc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
> +}
> +
> +static void vmc_cap_buf_queue(struct vb2_buffer *vb2)
> +{
> +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vb2->vb2_queue);
> +	struct vmc_cap_buffer *buf = container_of(vb2,
> +						  struct vmc_cap_buffer, vb2);
> +
> +	/* If the buffer doesn't have enough size, mark it as error */
> +	if (vb2->v4l2_planes[0].length < vcap->format.sizeimage) {
> +		vb2_buffer_done(vb2, VB2_BUF_STATE_ERROR);
> +		return;
> +	}

No need for this check, this will never happen.

> +
> +	spin_lock(&vcap->qlock);
> +
> +	list_add_tail(&buf->list, &vcap->buf_list);
> +
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vmc_cap_queue_setup(struct vb2_queue *vq,
> +			       const struct v4l2_format *fmt,
> +			       unsigned int *nbuffers, unsigned int *nplanes,
> +			       unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct vmc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	/*We don't support multiplanes for now */
> +	*nplanes = 1;
> +
> +	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : vcap->format.sizeimage;

If fmt != NULL then you need to check if fmt->fmt.pix.sizeimage >= 
vcap->format.sizeimage and return -EINVAL if that is not the case.

> +
> +	return 0;
> +}
> +
> +static const struct vb2_ops vmc_cap_qops = {
> +	.start_streaming	= vmc_cap_start_streaming,
> +	.stop_streaming		= vmc_cap_stop_streaming,
> +	.buf_queue		= vmc_cap_buf_queue,
> +	.queue_setup		= vmc_cap_queue_setup,
> +	/*
> +	 * Since q->lock is set we can use the standard
> +	 * vb2_ops_wait_prepare/finish helper functions.
> +	 */
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +
> +/* NOTE: this function is a copy of v4l2_subdev_link_validate_get_format
> + * maybe the v4l2 function should be public */
> +static int vmc_cap_v4l2_subdev_link_validate_get_format(struct media_pad *pad,
> +						struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	fmt->pad = pad->index;
> +	return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
> +}
> +
> +static int vmc_cap_link_validate(struct media_link *link)
> +{
> +	struct v4l2_subdev_format source_fmt;
> +	struct v4l2_pix_format *sink_fmt;
> +	struct vmc_cap_device *vcap;
> +	const struct vmc_pix_fmt_map *vpix;
> +	int ret;
> +
> +	/* Retrieve the video capture device */
> +	vcap = container_of(link->sink->entity,
> +			    struct vmc_cap_device, vdev.entity);
> +
> +	/* If the connected node is not a subdevice type
> +	 * then its a raw node from vmc-core, ignore the link for now

typo: its -> it's

> +	 * TODO: remove this when there are no more raw nodes in the
> +	 * core and return error instead */
> +	if (link->source->entity->type != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return 0;
> +
> +	/* Get the the format of the video device */
> +	sink_fmt = &vcap->format;
> +
> +	/* Get the the format of the subdev */
> +	ret = vmc_cap_v4l2_subdev_link_validate_get_format(link->source,
> +							   &source_fmt);
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(vcap->dev,
> +		"cap link validate formats src:%dx%d %d sink:%dx%d %d\n",
> +		source_fmt.format.width, source_fmt.format.height,
> +		source_fmt.format.code,
> +		sink_fmt->width, sink_fmt->height,
> +		sink_fmt->pixelformat);
> +
> +	/* Validate the format */
> +
> +	vpix = vmc_pix_fmt_map_by_pixelformat(sink_fmt->pixelformat);
> +	if (!vpix)
> +		return -EINVAL;
> +
> +	/* The width, height and code must match. */
> +	if (source_fmt.format.width != sink_fmt->width
> +	    || source_fmt.format.height != sink_fmt->height
> +	    || vpix->code != source_fmt.format.code)
> +		return -EINVAL;
> +
> +	/* The field order must match, or the sink field order must be NONE
> +	 * to support interlaced hardware connected to bridges that support
> +	 * progressive formats only.
> +	 */
> +	if (source_fmt.format.field != sink_fmt->field &&
> +	    sink_fmt->field != V4L2_FIELD_NONE)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static const struct media_entity_operations vmc_cap_mops = {
> +	.link_validate		= vmc_cap_link_validate,
> +};
> +
> +void vmc_cap_destroy(struct vmc_ent_device *ved)
> +{
> +	struct vmc_cap_device *vcap = container_of(ved,
> +						   struct vmc_cap_device, ved);
> +
> +	vb2_queue_release(&vcap->queue);
> +	media_entity_cleanup(ved->ent);
> +	video_unregister_device(&vcap->vdev);
> +	vmc_pads_cleanup(vcap->ved.pads);
> +	kfree(vcap);
> +}
> +
> +static void vmc_cap_process_frame(struct vmc_ent_device *ved,
> +				  struct media_pad *sink, const void *frame)
> +{
> +	struct vmc_cap_device *vcap = container_of(ved,
> +						   struct vmc_cap_device, ved);
> +	struct vmc_cap_buffer *vmc_buf;
> +	void *vbuf;
> +
> +	spin_lock(&vcap->qlock);
> +
> +	/* Get the first entry of the list */
> +	vmc_buf = list_first_entry_or_null(&vcap->buf_list,
> +					   typeof(*vmc_buf), list);
> +	if (!vmc_buf) {
> +		spin_unlock(&vcap->qlock);
> +		return;
> +	}
> +
> +	/* Remove this entry form the list */
> +	list_del(&vmc_buf->list);
> +
> +	spin_unlock(&vcap->qlock);
> +
> +	/* Fill the buffer */
> +	v4l2_get_timestamp(&vmc_buf->vb2.v4l2_buf.timestamp);
> +	vmc_buf->vb2.v4l2_buf.sequence = vcap->sequence++;
> +	vmc_buf->vb2.v4l2_buf.field = vcap->format.field;
> +
> +	vbuf = vb2_plane_vaddr(&vmc_buf->vb2, 0);
> +
> +	memcpy(vbuf, frame, vcap->format.sizeimage);
> +
> +	/* Set it as ready */
> +	vb2_set_plane_payload(&vmc_buf->vb2, 0, vcap->format.sizeimage);
> +	vb2_buffer_done(&vmc_buf->vb2, VB2_BUF_STATE_DONE);
> +}
> +
> +struct vmc_ent_device *vmc_cap_create(struct v4l2_device *v4l2_dev,
> +				      const char *const name,
> +				      u16 num_pads,
> +				      const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vb2_queue *q;
> +	struct video_device *vdev;
> +	struct vmc_cap_device *vcap;
> +	const struct vmc_pix_fmt_map *vpix;
> +
> +	if (!v4l2_dev || !v4l2_dev->dev || !name || (num_pads && !pads_flag))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vmc_cap_device struct */
> +	vcap = kzalloc(sizeof(*vcap), GFP_KERNEL);
> +	if (!vcap)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vmc_cap_device struct with the v4l2 parent */
> +	vcap->v4l2_dev = v4l2_dev;
> +	/* Link the vmc_cap_device struct with the dev parent */
> +	vcap->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vcap->ved.pads = vmc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vcap->ved.pads)) {
> +		ret = PTR_ERR(vcap->ved.pads);
> +		goto err_free_vcap;
> +	}
> +
> +	/* Initialize the media entity */
> +	vcap->vdev.entity.name = name;
> +	vcap->vdev.entity.type = MEDIA_ENT_T_DEVNODE;
> +	ret = media_entity_init(&vcap->vdev.entity, num_pads,
> +				vcap->ved.pads, num_pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Initialize the lock */
> +	mutex_init(&vcap->lock);
> +
> +	/* Initialize the vb2 queue */
> +	q = &vcap->queue;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP | VB2_DMABUF;
> +	q->drv_priv = vcap;
> +	q->buf_struct_size = sizeof(struct vmc_cap_buffer);
> +	q->ops = &vmc_cap_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
> +	/*
> +	 * Set the queue lock (TODO: add a separated lock from the video_device)
> +	 * so we can use the defaults vb2 wait_prepare and wait_finish ops
> +	 */

Is this an obsolete comment since the vb2 wait_prepare and wait_finish ops are
used in this driver?

> +	q->lock = &vcap->lock;
> +
> +	ret = vb2_queue_init(q);
> +	if (ret) {
> +		dev_err(vcap->dev,
> +			"vb2 queue init failed (err=%d)\n", ret);
> +		goto err_clean_m_ent;
> +	}
> +
> +	/* Initialize buffer list and its lock */
> +	INIT_LIST_HEAD(&vcap->buf_list);
> +	spin_lock_init(&vcap->qlock);
> +
> +	/* Initialize the video_device struct */
> +	vdev = &vcap->vdev;
> +	vdev->entity.ops = &vmc_cap_mops;
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &vmc_cap_fops;
> +	vdev->ioctl_ops = &vmc_cap_ioctl_ops;
> +	vdev->lock = &vcap->lock;
> +	vdev->queue = q;
> +	vdev->v4l2_dev = vcap->v4l2_dev;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +	video_set_drvdata(vdev, vcap);
> +
> +	/* Register the video_device with the v4l2 and the media framework */
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);

This should be the very last thing in this function: once the device node is
created it should be ready for use. So doing more configuration after this
call is a bad idea.

> +	if (ret) {
> +		dev_err(vcap->dev,
> +			"video register failed (err=%d)\n", ret);
> +		goto err_release_queue;
> +	}
> +
> +	/* Set the frame format (this is hardcoded for now) */
> +	vcap->format.width = 640;
> +	vcap->format.height = 480;
> +	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
> +	vcap->format.field = V4L2_FIELD_INTERLACED;
> +	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	vpix = vmc_pix_fmt_map_by_pixelformat(vcap->format.pixelformat);
> +	/* This should never be NULL, as we won't allow any format
> +	 * other then the ones in the vmc_pix_fmt_map_list table */
> +	BUG_ON(!vpix);
> +
> +	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
> +	vcap->format.sizeimage = vcap->format.bytesperline * vcap->format.height;
> +
> +	/* Fill the vmc_ent_device struct */
> +	vcap->ved.destroy = vmc_cap_destroy;
> +	vcap->ved.ent = &vcap->vdev.entity;
> +	vcap->ved.process_frame = vmc_cap_process_frame;
> +
> +	return &vcap->ved;
> +
> +err_release_queue:
> +	vb2_queue_release(q);
> +err_clean_m_ent:
> +	media_entity_cleanup(&vcap->vdev.entity);
> +err_clean_pads:
> +	vmc_pads_cleanup(vcap->ved.pads);
> +err_free_vcap:
> +	kfree(vcap);
> +
> +	return ERR_PTR(ret);
> +}
> diff --git a/drivers/media/vmc/vmc-capture.h b/drivers/media/vmc/vmc-capture.h
> new file mode 100644
> index 0000000..2d2c3e6
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-capture.h
> @@ -0,0 +1,50 @@
> +/*
> + * vmc-capture.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _VMC_CAPTURE_H_
> +#define _VMC_CAPTURE_H_
> +
> +#include <media/videobuf2-core.h>
> +
> +#include "vmc-core.h"
> +
> +struct vmc_cap_device {
> +	struct vmc_ent_device ved;
> +	struct video_device vdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct device *dev;
> +	struct v4l2_pix_format format;
> +	struct vb2_queue queue;
> +	struct list_head buf_list;
> +	/* NOTE: in a real driver, a spin lock must be used to access the
> +	 * queue because the frames are generated from a hardware interruption
> +	 * and the irs is not allowed to sleep.

irs -> isr

> +	 * Even if it is not necessary a spinlock in the vmc driver we
> +	 * use it here as a code reference */
> +	spinlock_t qlock;
> +	struct mutex lock;
> +	u32 sequence;
> +};
> +
> +struct vmc_ent_device *vmc_cap_create(struct v4l2_device *v4l2_dev,
> +				      const char *const name,
> +				      u16 num_pads,
> +				      const unsigned long *pads_flag);
> +
> +void vmc_cap_destroy(struct vmc_ent_device *ved);
> +
> +#endif
> diff --git a/drivers/media/vmc/vmc-core.c b/drivers/media/vmc/vmc-core.c
> new file mode 100644
> index 0000000..778fd3b3
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-core.c
> @@ -0,0 +1,595 @@
> +/*
> + * vmc-core.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <media/media-device.h>
> +#include <media/v4l2-device.h>
> +
> +#include "vmc-capture.h"
> +#include "vmc-core.h"
> +#include "vmc-sensor.h"
> +
> +#define VMC_PDEV_NAME "vmc"
> +#define VMC_MDEV_MODEL_NAME "VMC MDEV"
> +
> +#define VMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) { \
> +	.src_ent = src, \
> +	.src_pad = srcpad, \
> +	.sink_ent = sink, \
> +	.sink_pad = sinkpad, \
> +	.flags = link_flags, \
> +}
> +
> +#define VMC_PIX_MAP(_code, _bpp, _pixelformat) {\
> +	.code = _code,				\
> +	.pixelformat = _pixelformat,		\
> +	.bpp = _bpp,				\
> +}
> +
> +struct vmc_device {
> +	/* The pipeline configuration
> +	 * (filled before calling vmc_device_register) */
> +	const struct vmc_pipeline_config *pipe_cfg;
> +
> +	/* The Associated media_device parent */
> +	struct media_device mdev;
> +
> +	/* Internal v4l2 parent device*/
> +	struct v4l2_device v4l2_dev;
> +
> +	/* Internal topology */
> +	struct vmc_ent_device **ved;
> +};
> +
> +/**
> + * enum vmc_ent_node - Select the functionality of a node in the topology
> + * @VMC_ENT_NODE_SENSOR:	A node of type SENSOR simulates a camera sensor
> + *				generating internal images in bayer format and
> + *				propagating those images through the pipeline
> + * @VMC_ENT_NODE_CAPTURE:	A node of type CAPTURE is a v4l2 video_device
> + *				that exposes the received image from the
> + *				pipeline to the user space
> + * @VMC_ENT_NODE_INPUT:		A node of type INPUT is a v4l2 video_device that
> + *				receives images from the user space and
> + *				propagates them through the pipeline
> + * @VMC_ENT_NODE_DEBAYER:	A node type DEBAYER expects to receive a frame
> + *				in bayer format converts it to RGB
> + * @VMC_ENT_NODE_SCALER:	A node of type SCALER scales the received image
> + *				by a given multiplier
> + *
> + * This enum is used in the entity configuration struct to allow the definition
> + * of a custom topology specifying the role of each node on it.
> + */
> +enum vmc_ent_node {
> +	VMC_ENT_NODE_SENSOR,
> +	VMC_ENT_NODE_CAPTURE,
> +	VMC_ENT_NODE_INPUT,
> +	VMC_ENT_NODE_DEBAYER,
> +	VMC_ENT_NODE_SCALER,
> +};
> +
> +/* Structure which describes individual configuration for each entity */
> +struct vmc_ent_config {
> +	const char *name;
> +	size_t pads_qty;
> +	const unsigned long *pads_flag;
> +	enum vmc_ent_node node;
> +};
> +
> +/* Structure which describes links between entities */
> +struct vmc_ent_link {
> +	unsigned int src_ent;
> +	u16 src_pad;
> +	unsigned int sink_ent;
> +	u16 sink_pad;
> +	u32 flags;
> +};
> +
> +/* Structure which describes the whole topology */
> +struct vmc_pipeline_config {
> +	const struct vmc_ent_config *ents;
> +	size_t num_ents;
> +	const struct vmc_ent_link *links;
> +	size_t num_links;
> +};
> +
> +/* --------------------------------------------------------------------------
> + * Topology Configuration
> + */
> +
> +static const struct vmc_ent_config ent_config[] = {
> +	{
> +		.name = "Sensor A",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Sensor B",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Debayer A",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Debayer B",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Raw Capture 0",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "Raw Capture 1",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "RGB/YUV Input",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_INPUT,
> +	},
> +	{
> +		.name = "Scaler",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VMC_ENT_NODE_SCALER,
> +	},
> +	{
> +		.name = "RGB/YUV Capture",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VMC_ENT_NODE_CAPTURE,
> +	},
> +};
> +
> +static const struct vmc_ent_link ent_links[] = {
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Debayer A */
> +	VMC_ENT_LINK(0, 0, 2, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Raw Capture 0 */
> +	VMC_ENT_LINK(0, 0, 4, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Debayer B */
> +	VMC_ENT_LINK(1, 0, 3, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Raw Capture 1 */
> +	VMC_ENT_LINK(1, 0, 5, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Debayer A (Pad 1)->(Pad 0) Scaler */
> +	VMC_ENT_LINK(2, 1, 7, 0, MEDIA_LNK_FL_ENABLED),
> +	/* Link: Debayer B (Pad 1)->(Pad 0) Scaler */
> +	VMC_ENT_LINK(3, 1, 7, 0, 0),
> +	/* Link: RGB/YUV Input (Pad 0)->(Pad 0) Scaler */
> +	VMC_ENT_LINK(6, 0, 7, 0, 0),
> +	/* Link: Scaler (Pad 1)->(Pad 0) RGB/YUV Capture */
> +	VMC_ENT_LINK(7, 1, 8, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +};
> +
> +static const struct vmc_pipeline_config pipe_cfg = {
> +	.ents		= ent_config,
> +	.num_ents	= ARRAY_SIZE(ent_config),
> +	.links		= ent_links,
> +	.num_links	= ARRAY_SIZE(ent_links)
> +};
> +
> +/* -------------------------------------------------------------------------- */
> +
> +static void vmc_dev_release(struct device *dev)
> +{}
> +
> +static struct platform_device vmc_pdev = {
> +	.name		= VMC_PDEV_NAME,
> +	.dev.release	= vmc_dev_release,
> +};
> +
> +const struct vmc_pix_fmt_map vmc_pix_fmt_map_list[] = {
> +	/* TODO: add all missing formats */
> +
> +	/* RGB formats */
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_BGR888_1X24, 3, V4L2_PIX_FMT_BGR24),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_RGB888_1X24, 3, V4L2_PIX_FMT_RGB24),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_ARGB8888_1X32, 4, V4L2_PIX_FMT_ARGB32),
> +
> +	/* Bayer formats */
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR8_1X8, 1, V4L2_PIX_FMT_SBGGR8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG8_1X8, 1, V4L2_PIX_FMT_SGBRG8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG8_1X8, 1, V4L2_PIX_FMT_SGRBG8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB8_1X8, 1, V4L2_PIX_FMT_SRGGB8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_1X10, 2, V4L2_PIX_FMT_SBGGR10),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_1X10, 2, V4L2_PIX_FMT_SGBRG10),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_1X10, 2, V4L2_PIX_FMT_SGRBG10),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_1X10, 2, V4L2_PIX_FMT_SRGGB10),
> +	/* 10bit raw bayer a-law compressed to 8 bits */
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8, 1, V4L2_PIX_FMT_SBGGR10ALAW8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGBRG10ALAW8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGRBG10ALAW8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8, 1, V4L2_PIX_FMT_SRGGB10ALAW8),
> +	/* 10bit raw bayer DPCM compressed to 8 bits */
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 1, V4L2_PIX_FMT_SBGGR10DPCM8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGBRG10DPCM8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGRBG10DPCM8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 1, V4L2_PIX_FMT_SRGGB10DPCM8),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR12_1X12, 2, V4L2_PIX_FMT_SBGGR12),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG12_1X12, 2, V4L2_PIX_FMT_SGBRG12),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG12_1X12, 2, V4L2_PIX_FMT_SGRBG12),
> +	VMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB12_1X12, 2, V4L2_PIX_FMT_SRGGB12),
> +
> +	/* End */
> +	{0, 0, 0}
> +};
> +
> +const struct vmc_pix_fmt_map *vmc_pix_fmt_map_by_code(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vmc_pix_fmt_map_list[i].bpp; i++) {
> +		if (vmc_pix_fmt_map_list[i].code == code)
> +			return &vmc_pix_fmt_map_list[i];
> +	}
> +	return NULL;
> +}
> +
> +const struct vmc_pix_fmt_map *vmc_pix_fmt_map_by_pixelformat(u32 pixelformat)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vmc_pix_fmt_map_list[i].bpp; i++) {
> +		if (vmc_pix_fmt_map_list[i].pixelformat == pixelformat)
> +			return &vmc_pix_fmt_map_list[i];
> +	}
> +	return NULL;
> +}
> +
> +int vmc_propagate_frame(struct device *dev,
> +			struct media_pad *src, const void *frame)
> +{
> +	unsigned int i;
> +	struct media_link *link;
> +	struct vmc_device *vmc = dev_get_drvdata(dev);
> +
> +	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
> +		return -EINVAL;
> +
> +	/* Send this frame to all sink pads that are direct linked */
> +	for (i = 0; i < src->entity->num_links; i++) {
> +		link = &src->entity->links[i];
> +
> +		if (link->source == src &&
> +		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
> +			struct vmc_ent_device *ved;
> +
> +			ved = vmc->ved[link->sink->entity->id - 1];
> +			if (ved && ved->process_frame)
> +				ved->process_frame(ved, link->sink, frame);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vmc_device_unregister(struct vmc_device *vmc)
> +{
> +	unsigned int i;
> +
> +	v4l2_device_unregister(&vmc->v4l2_dev);
> +
> +	media_device_unregister(&vmc->mdev);
> +
> +	/* Cleanup (only initialized) entities */
> +	for (i = 0; i < vmc->pipe_cfg->num_ents; i++) {
> +		if (vmc->ved[i] && vmc->ved[i]->destroy)
> +			vmc->ved[i]->destroy(vmc->ved[i]);
> +
> +		vmc->ved[i] = NULL;
> +	}
> +}
> +
> +/* Helper function to allocate and initialize pads */
> +struct media_pad *vmc_pads_init(u16 num_pads, const unsigned long *pads_flag)
> +{
> +	unsigned int i;
> +	struct media_pad *pads;
> +
> +	/* Allocate memory for the pads */
> +	pads = kcalloc(num_pads, sizeof(*pads), GFP_KERNEL);
> +	if (!pads)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Initialize the pads */
> +	for (i = 0; i < num_pads; i++) {
> +		pads[i].index = i;
> +		pads[i].flags = pads_flag[i];
> +	}
> +
> +	return pads;
> +}
> +
> +/* TODO: remove this function when all the
> + * entities specific code are implemented */
> +static void vmc_raw_destroy(struct vmc_ent_device *ved)
> +{
> +	media_entity_cleanup(ved->ent);
> +
> +	vmc_pads_cleanup(ved->pads);
> +
> +	kfree(ved->ent);
> +
> +	kfree(ved);
> +}
> +
> +/* TODO: remove this function when all the
> + * entities specific code are implemented */
> +static struct vmc_ent_device *vmc_raw_create(struct v4l2_device *v4l2_dev,
> +					     const char *const name,
> +					     u16 num_pads,
> +					     const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vmc_ent_device *ved;
> +
> +	/* Allocate the main ved struct */
> +	ved = kzalloc(sizeof(*ved), GFP_KERNEL);
> +	if (!ved)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Allocate the media entity */
> +	ved->ent = kzalloc(sizeof(*ved->ent), GFP_KERNEL);
> +	if (!ved->ent) {
> +		ret = -ENOMEM;
> +		goto err_free_ved;
> +	}
> +
> +	/* Allocate the pads */
> +	ved->pads = vmc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(ved->pads)) {
> +		ret = PTR_ERR(ved->pads);
> +		goto err_free_ent;
> +	}
> +
> +	/* Initialize the media entity */
> +	ved->ent->name = name;
> +	ved->ent->type = MEDIA_ENT_T_DEVNODE;
> +	ret = media_entity_init(ved->ent, num_pads, ved->pads, num_pads);
> +	if (ret)
> +		goto err_cleanup_pads;
> +
> +	/* Register the media entity */
> +	ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
> +	if (ret)
> +		goto err_cleanup_entity;
> +
> +	/* Fill out the destroy function and return */
> +	ved->destroy = vmc_raw_destroy;
> +	return ved;
> +
> +err_cleanup_entity:
> +	media_entity_cleanup(ved->ent);
> +err_cleanup_pads:
> +	vmc_pads_cleanup(ved->pads);
> +err_free_ent:
> +	kfree(ved->ent);
> +err_free_ved:
> +	kfree(ved);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static int vmc_device_register(struct vmc_device *vmc)
> +{
> +	unsigned int i;
> +	int ret = 0;
> +
> +	/* Allocate memory for the vmc_ent_devices pointers */
> +	vmc->ved = devm_kcalloc(vmc->mdev.dev, vmc->pipe_cfg->num_ents,
> +				sizeof(*vmc->ved), GFP_KERNEL);
> +	if (!vmc->ved)
> +		return -ENOMEM;
> +
> +	/* Register the media device */
> +	ret = media_device_register(&vmc->mdev);
> +	if (ret) {
> +		dev_err(vmc->mdev.dev,
> +			"media device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the media device within the v4l2_device */
> +	vmc->v4l2_dev.mdev = &vmc->mdev;
> +
> +	/* Register the v4l2 struct */
> +	ret = v4l2_device_register(vmc->mdev.dev, &vmc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vmc->mdev.dev,
> +			"v4l2 device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Fill pads/entities structures and initialize entity */
> +	for (i = 0; i < vmc->pipe_cfg->num_ents; i++) {
> +		struct vmc_ent_device *(*create_func)(struct v4l2_device *,
> +						      const char *const,
> +						      u16,
> +						      const unsigned long *);
> +
> +		/* Register the specific node */
> +		switch (vmc->pipe_cfg->ents[i].node) {
> +		case VMC_ENT_NODE_SENSOR:
> +			create_func = vmc_sen_create;
> +			break;
> +
> +		case VMC_ENT_NODE_CAPTURE:
> +			create_func = vmc_cap_create;
> +			break;
> +
> +		/* TODO: Instantiate the specific topology node */
> +		case VMC_ENT_NODE_INPUT:
> +		case VMC_ENT_NODE_DEBAYER:
> +		case VMC_ENT_NODE_SCALER:
> +		default:
> +			/* TODO: remove this when all the entities specific
> +			 * code are implemented */
> +			create_func = vmc_raw_create;
> +			break;
> +		}
> +
> +		vmc->ved[i] = create_func(&vmc->v4l2_dev,
> +					  vmc->pipe_cfg->ents[i].name,
> +					  vmc->pipe_cfg->ents[i].pads_qty,
> +					  vmc->pipe_cfg->ents[i].pads_flag);
> +		if (IS_ERR(vmc->ved[i])) {
> +			ret = PTR_ERR(vmc->ved[i]);
> +			vmc->ved[i] = NULL;
> +			goto err;
> +		}
> +	}
> +
> +	/* Initialize the links between entities */
> +	for (i = 0; i < vmc->pipe_cfg->num_links; i++) {
> +		const struct vmc_ent_link *link = &vmc->pipe_cfg->links[i];
> +
> +		ret = media_entity_create_link(vmc->ved[link->src_ent]->ent,
> +					       link->src_pad,
> +					       vmc->ved[link->sink_ent]->ent,
> +					       link->sink_pad,
> +					       link->flags);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* Expose all subdev's nodes*/
> +	ret = v4l2_device_register_subdev_nodes(&vmc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vmc->mdev.dev,
> +			"vmc subdev nodes registration failed (err=%d)\n", ret);
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	/* Destroy de so far created topology */
> +	vmc_device_unregister(vmc);
> +
> +	return ret;
> +}
> +
> +static int vmc_probe(struct platform_device *pdev)
> +{
> +	struct vmc_device *vmc;
> +	int ret;
> +
> +	/* Prepare the vmc topology structure */
> +
> +	/* Allocate memory for the vmc structure */
> +	vmc = devm_kzalloc(&pdev->dev, sizeof(*vmc), GFP_KERNEL);
> +	if (!vmc)
> +		return -ENOMEM;
> +
> +	/* Set the pipeline configuration struct */
> +	vmc->pipe_cfg = &pipe_cfg;
> +
> +	/* Set the mdev model name */
> +	strlcpy(vmc->mdev.model, VMC_MDEV_MODEL_NAME,
> +		sizeof(vmc->mdev.model));
> +
> +	/* Link dev with the media device. */
> +	vmc->mdev.dev = &pdev->dev;
> +
> +	/* Create vmc topology */
> +	ret = vmc_device_register(vmc);
> +	if (ret) {
> +		dev_err(vmc->mdev.dev,
> +			"vmc device registration failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the topology object with the platform device object */
> +	platform_set_drvdata(pdev, vmc);
> +
> +	return 0;
> +}
> +
> +static int vmc_remove(struct platform_device *pdev)
> +{
> +	struct vmc_device *vmc;
> +
> +	/* Get the topology object linked with the platform device object */
> +	vmc = platform_get_drvdata(pdev);
> +
> +	/* Destroy all the topology */
> +	vmc_device_unregister(vmc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver vmc_pdrv = {
> +	.probe		= vmc_probe,
> +	.remove		= vmc_remove,
> +	.driver		= {
> +		.name	= VMC_PDEV_NAME,
> +	},
> +};
> +
> +static int __init vmc_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_device_register(&vmc_pdev);
> +	if (ret) {
> +		dev_err(&vmc_pdev.dev,
> +			"platform device registration failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = platform_driver_register(&vmc_pdrv);
> +	if (ret) {
> +		dev_err(&vmc_pdev.dev,
> +			"platform driver registration failed (err=%d)\n", ret);
> +
> +		platform_device_unregister(&vmc_pdev);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit vmc_exit(void)
> +{
> +	platform_driver_unregister(&vmc_pdrv);
> +
> +	platform_device_unregister(&vmc_pdev);
> +}
> +
> +module_init(vmc_init);
> +module_exit(vmc_exit);
> +
> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VMC)");
> +MODULE_AUTHOR("Helen Fornazier <helen.fornazier@gmail.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/vmc/vmc-core.h b/drivers/media/vmc/vmc-core.h
> new file mode 100644
> index 0000000..b987996
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-core.h
> @@ -0,0 +1,55 @@
> +/*
> + * vmc-core.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _VMC_CORE_H_
> +#define _VMC_CORE_H_
> +
> +#include <media/v4l2-device.h>
> +
> +/* Struct which matches the MEDIA_BUS_FMT_ codes with the corresponding
> + * V4L2_PIX_FMT_ fourcc pixelformat and its bytes per pixel (bpp) */
> +struct vmc_pix_fmt_map {
> +	unsigned int code;
> +	unsigned int bpp;
> +	u32 pixelformat;
> +};
> +extern const struct vmc_pix_fmt_map vmc_pix_fmt_map_list[];
> +
> +struct vmc_ent_device {
> +	struct media_entity *ent;
> +	struct media_pad *pads;
> +	void (*destroy)(struct vmc_ent_device *);
> +	void (*process_frame)(struct vmc_ent_device *ved,
> +			      struct media_pad *sink, const void *frame);
> +};
> +
> +int vmc_propagate_frame(struct device *dev,
> +			struct media_pad *src, const void *frame);
> +
> +/* Helper functions to allocate/initialize pads and free them */
> +struct media_pad *vmc_pads_init(u16 num_pads,
> +				const unsigned long *pads_flag);
> +static inline void vmc_pads_cleanup(struct media_pad *pads)
> +{
> +	kfree(pads);
> +}
> +
> +const struct vmc_pix_fmt_map *vmc_pix_fmt_map_by_code(u32 code);
> +
> +const struct vmc_pix_fmt_map *vmc_pix_fmt_map_by_pixelformat(u32 pixelformat);
> +
> +#endif
> diff --git a/drivers/media/vmc/vmc-sensor.c b/drivers/media/vmc/vmc-sensor.c
> new file mode 100644
> index 0000000..655386c
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-sensor.c
> @@ -0,0 +1,275 @@
> +/*
> + * vmc-sensor.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/freezer.h>
> +#include <linux/vmalloc.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>
> +
> +#include "vmc-core.h"
> +#include "vmc-sensor.h"
> +
> +static int vmc_sen_enum_mbus_code(struct v4l2_subdev *sd,
> +				  struct v4l2_subdev_pad_config *cfg,
> +				  struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct vmc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	/* Check if it is a valid pad */
> +	if (code->pad >= vsen->sd.entity.num_pads)
> +		return -EINVAL;
> +
> +	code->code = vsen->mbus_format.code;
> +
> +	return 0;
> +}
> +
> +static int vmc_sen_enum_frame_size(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct vmc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	/* Check if it is a valid pad */
> +	if (fse->pad >= vsen->sd.entity.num_pads ||
> +	    !(vsen->sd.entity.pads[fse->pad].flags & MEDIA_PAD_FL_SOURCE))
> +		return -EINVAL;
> +
> +	/* TODO: Add support to other formats */
> +	if (fse->index)
> +		return -EINVAL;
> +
> +	/* TODO: Add support for other codes */
> +	if (fse->code != vsen->mbus_format.code)
> +		return -EINVAL;
> +
> +	fse->min_width = vsen->mbus_format.width;
> +	fse->max_width = vsen->mbus_format.width;
> +	fse->min_height = vsen->mbus_format.height;
> +	fse->max_height = vsen->mbus_format.height;
> +
> +	return 0;
> +}
> +
> +static int vmc_sen_get_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	struct vmc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	format->format = vsen->mbus_format;
> +
> +	return 0;
> +}
> +
> +static int vmc_sen_set_fmt(struct v4l2_subdev *sd,
> +			   struct v4l2_subdev_pad_config *cfg,
> +			   struct v4l2_subdev_format *format)
> +{
> +	/* TODO: Add support to other formats and try format feature */
> +	return vmc_sen_get_fmt(sd, cfg, format);
> +}
> +
> +static const struct v4l2_subdev_pad_ops vmc_sd_pad_ops = {
> +	.enum_mbus_code		= vmc_sen_enum_mbus_code,
> +	.enum_frame_size	= vmc_sen_enum_frame_size,
> +	.get_fmt		= vmc_sen_get_fmt,
> +	.set_fmt		= vmc_sen_set_fmt,
> +};
> +
> +/* media operations */
> +static const struct media_entity_operations vmc_sen_mops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static int vmc_thread_sen(void *data)
> +{
> +	unsigned int i;
> +	struct vmc_sen_device *vsen = data;
> +
> +	set_freezable();
> +
> +	for (;;) {
> +		try_to_freeze();
> +		if (kthread_should_stop())
> +			break;
> +
> +		memset(vsen->frame, 100, vsen->frame_size);
> +
> +		/* Send the frame to all source pads */
> +		for (i = 0; i < vsen->sd.entity.num_pads; i++)
> +			if (vsen->sd.entity.pads[i].flags & MEDIA_PAD_FL_SOURCE)
> +				vmc_propagate_frame(vsen->dev,
> +						    &vsen->sd.entity.pads[i],
> +						    vsen->frame);
> +
> +		/* Wait one second */
> +		schedule_timeout_interruptible(HZ);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vmc_sen_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	int ret;
> +	struct vmc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	if (enable) {
> +		const struct vmc_pix_fmt_map *vpix;
> +
> +		if (vsen->kthread_sen)
> +			return -EINVAL;
> +
> +		/* Calculate the frame size */
> +		vpix = vmc_pix_fmt_map_by_code(vsen->mbus_format.code);
> +		/* This should never be NULL, as we won't allow any format
> +		 * other then the ones in the vmc_pix_fmt_map_list table */
> +		BUG_ON(!vpix);
> +		vsen->frame_size = vsen->mbus_format.width * vpix->bpp *
> +				   vsen->mbus_format.height;
> +
> +		/* Allocate the frame buffer. Use vmalloc to be able to
> +		 * allocate a large amount of memory*/
> +		vsen->frame = vmalloc(vsen->frame_size);
> +		if (!vsen->frame)
> +			return -ENOMEM;
> +
> +		/* Initialize the image generator thread */
> +		vsen->kthread_sen = kthread_run(vmc_thread_sen, vsen,
> +						"%s-sen", vsen->v4l2_dev->name);
> +		if (IS_ERR(vsen->kthread_sen)) {
> +			v4l2_err(vsen->v4l2_dev, "kernel_thread() failed\n");
> +			vfree(vsen->frame);
> +			vsen->frame = NULL;
> +			return PTR_ERR(vsen->kthread_sen);
> +		}
> +	} else {
> +		if (!vsen->kthread_sen)
> +			return -EINVAL;
> +
> +		/* Stop image generator */
> +		ret = kthread_stop(vsen->kthread_sen);
> +		vsen->kthread_sen = NULL;
> +
> +		vfree(vsen->frame);
> +		vsen->frame = NULL;
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +struct v4l2_subdev_video_ops vmc_sd_video_ops = {
> +	.s_stream = vmc_sen_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops vmc_sd_ops = {
> +	.pad = &vmc_sd_pad_ops,
> +	.video = &vmc_sd_video_ops,
> +};
> +
> +void vmc_sen_destroy(struct vmc_ent_device *ved)
> +{
> +	struct vmc_sen_device *vsen = container_of(ved,
> +						   struct vmc_sen_device, ved);
> +
> +	media_entity_cleanup(ved->ent);
> +	v4l2_device_unregister_subdev(&vsen->sd);
> +	kfree(vsen);
> +}
> +
> +struct vmc_ent_device *vmc_sen_create(struct v4l2_device *v4l2_dev,
> +				      const char *const name,
> +				      u16 num_pads,
> +				      const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vmc_sen_device *vsen;
> +
> +	if (!v4l2_dev || !v4l2_dev->dev || !name || (num_pads && !pads_flag))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vsen struct */
> +	vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
> +	if (!vsen)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vmc_sen_device struct with the v4l2 parent */
> +	vsen->v4l2_dev = v4l2_dev;
> +	/* Link the vmc_sen_device struct with the dev parent */
> +	vsen->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vsen->ved.pads = vmc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vsen->ved.pads)) {
> +		ret = PTR_ERR(vsen->ved.pads);
> +		goto err_free_vsen;
> +	}
> +
> +	/* Initialize the media entity */
> +	vsen->sd.entity.name = name;
> +	vsen->sd.entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	ret = media_entity_init(&vsen->sd.entity, num_pads,
> +				vsen->ved.pads, num_pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Initialize the subdev */
> +	v4l2_subdev_init(&vsen->sd, &vmc_sd_ops);
> +	vsen->sd.entity.ops = &vmc_sen_mops;
> +	vsen->sd.owner = THIS_MODULE;
> +	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
> +
> +	/* Expose this subdev to user space */
> +	vsen->sd.flags = V4L2_SUBDEV_FL_HAS_DEVNODE;
> +
> +	/* Register the subdev with the v4l2 and the media framework */
> +	ret = v4l2_device_register_subdev(vsen->v4l2_dev, &vsen->sd);
> +	if (ret) {
> +		dev_err(vsen->dev,
> +			"subdev register failed (err=%d)\n", ret);
> +		goto err_clean_m_ent;
> +	}
> +
> +	/* Link the sd with the vmc_sen_device struct */
> +	v4l2_set_subdevdata(&vsen->sd, vsen);
> +
> +	/* Set the active frame format (this is hardcoded for now) */
> +	vsen->mbus_format.width = 640;
> +	vsen->mbus_format.height = 480;
> +	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
> +	vsen->mbus_format.field = V4L2_FIELD_INTERLACED;

This should be FIELD_NONE for a sensor.

> +	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
> +	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
> +
> +	/* Fill the vmc_ent_device struct */
> +	vsen->ved.destroy = vmc_sen_destroy;
> +	vsen->ved.ent = &vsen->sd.entity;
> +
> +	return &vsen->ved;
> +
> +err_clean_m_ent:
> +	media_entity_cleanup(&vsen->sd.entity);
> +err_clean_pads:
> +	vmc_pads_cleanup(vsen->ved.pads);
> +err_free_vsen:
> +	kfree(vsen);
> +
> +	return ERR_PTR(ret);
> +}
> diff --git a/drivers/media/vmc/vmc-sensor.h b/drivers/media/vmc/vmc-sensor.h
> new file mode 100644
> index 0000000..64f7a36
> --- /dev/null
> +++ b/drivers/media/vmc/vmc-sensor.h
> @@ -0,0 +1,40 @@
> +/*
> + * vmc-sensor.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef _VMC_SENSOR_H_
> +#define _VMC_SENSOR_H_
> +
> +struct vmc_sen_device {
> +	struct vmc_ent_device ved;
> +	struct v4l2_subdev sd;
> +	struct v4l2_device *v4l2_dev;
> +	struct device *dev;
> +	struct task_struct *kthread_sen;
> +	u8 *frame;
> +	/* The active format */
> +	struct v4l2_mbus_framefmt mbus_format;
> +	int frame_size;
> +};
> +
> +struct vmc_ent_device *vmc_sen_create(struct v4l2_device *v4l2_dev,
> +				      const char *const name,
> +				      u16 num_pads,
> +				      const unsigned long *pads_flag);
> +
> +void vmc_sen_destroy(struct vmc_ent_device *ved);
> +
> +#endif
> 

I didn't review the MC-specific parts in-depth. I assume that Laurent did that
already, and in addition there will be upcoming changes in the MC API based on
the workshop results next week.

In general I have the feeling that the amount of code needed to handle and
setup entities, links, etc. is too large. That's not your problem, that's
something we as V4L2 core developers need to address. I've seen this in other
drivers as well. I suspect we need more helper functions in the core code.

I may be wrong, though. And in any case, any in-depth analysis of this will
also have to wait until the workshop results are in.

Anyway, thank you for working on this. I didn't see much wrong here, and the
few issues I noticed should be easy to fix.

Regards,

	Hans
