Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42550 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751802AbdAYNEX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jan 2017 08:04:23 -0500
Date: Wed, 25 Jan 2017 15:03:46 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Helen Koike <helen.koike@collabora.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        laurent.pinchart@ideasonboard.com, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture
 and sensor
Message-ID: <20170125130345.GD7139@valkosipuli.retiisi.org.uk>
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
 <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

My apologies for the long review time!

Please see my comments below.

On Sun, Sep 04, 2016 at 05:02:18PM -0300, Helen Koike wrote:
> From: Helen Fornazier <helen.fornazier@gmail.com>
> 
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
> 
> Signed-off-by: Helen Koike <helen.koike@collabora.com>
> 
> ---
> 
> Patch based in media/master tree, and available here:
> https://github.com/helen-fornazier/opw-staging/tree/vimc/devel/vpu
> 
> Changes since v5:
> - Fix message "Entity type for entity Sensor A was not initialized!"
>   by initializing the sensor entity.function after the calling
>   v4l2_subded_init
> - populate device_caps in vimc_cap_create instead of in
>   vimc_cap_querycap
> - Fix typo in vimc-core.c s/de/the
> 
> Changes since v4:
> - coding style fixes
> - remove BUG_ON
> - change copyright to 2016
> - depens on VIDEO_V4L2_SUBDEV_API instead of select
> - remove assignement of V4L2_CAP_DEVICE_CAPS
> - s/vimc_cap_g_fmt_vid_cap/vimc_cap_fmt_vid_cap
> - fix vimc_cap_queue_setup declaration type
> - remove wrong buffer size check and add it in vimc_cap_buffer_prepare
> - vimc_cap_create: remove unecessary check if v4l2_dev or v4l2_dev->dev is null
> - vimc_cap_create: only allow a single pad
> - vimc_sen_create: only allow source pads, remove unecessary source pads
> checks in vimc_thread_sen
> 
> Changes since v3: fix rmmod crash and built-in compile
> - Re-order unregister calls in vimc_device_unregister function (remove
> rmmod issue)
> - Call media_device_unregister_entity in vimc_raw_destroy
> - Add depends on VIDEO_DEV && VIDEO_V4L2 and select VIDEOBUF2_VMALLOC
> - Check *nplanes in queue_setup (this remove v4l2-compliance fail)
> - Include <linux/kthread.h> in vimc-sensor.c
> - Move include of <linux/slab.h> from vimc-core.c to vimc-core.h
> - Generate 60 frames per sec instead of 1 in the sensor
> 
> Changes since v2: update with current media master tree
> - Add struct media_pipeline in vimc_cap_device
> - Use vb2_v4l2_buffer instead of vb2_buffer
> - Typos
> - Remove usage of entity->type and use entity->function instead
> - Remove fmt argument from queue setup
> - Use ktime_get_ns instead of v4l2_get_timestamp
> - Iterate over link's list using list_for_each_entry
> - Use media_device_{init, cleanup}
> - Use entity->use_count to keep track of entities instead of the old
> entity->id
> - Replace media_entity_init by media_entity_pads_init
> ---
>  drivers/media/platform/Kconfig             |   2 +
>  drivers/media/platform/Makefile            |   1 +
>  drivers/media/platform/vimc/Kconfig        |   7 +
>  drivers/media/platform/vimc/Makefile       |   3 +
>  drivers/media/platform/vimc/vimc-capture.c | 553 ++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-capture.h |  28 ++
>  drivers/media/platform/vimc/vimc-core.c    | 600 +++++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h    |  57 +++
>  drivers/media/platform/vimc/vimc-sensor.c  | 279 ++++++++++++++
>  drivers/media/platform/vimc/vimc-sensor.h  |  28 ++
>  10 files changed, 1558 insertions(+)
>  create mode 100644 drivers/media/platform/vimc/Kconfig
>  create mode 100644 drivers/media/platform/vimc/Makefile
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.c
>  create mode 100644 drivers/media/platform/vimc/vimc-capture.h
>  create mode 100644 drivers/media/platform/vimc/vimc-core.c
>  create mode 100644 drivers/media/platform/vimc/vimc-core.h
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.c
>  create mode 100644 drivers/media/platform/vimc/vimc-sensor.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index 46f14dd..4a0577f 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -329,6 +329,8 @@ menuconfig V4L_TEST_DRIVERS
>  
>  if V4L_TEST_DRIVERS
>  
> +source "drivers/media/platform/vimc/Kconfig"
> +
>  source "drivers/media/platform/vivid/Kconfig"
>  
>  config VIDEO_VIM2M
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 536d1d8..dd4f658 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -12,6 +12,7 @@ obj-$(CONFIG_VIDEO_OMAP3)	+= omap3isp/
>  
>  obj-$(CONFIG_VIDEO_VIU) += fsl-viu.o
>  
> +obj-$(CONFIG_VIDEO_VIMC)		+= vimc/
>  obj-$(CONFIG_VIDEO_VIVID)		+= vivid/
>  obj-$(CONFIG_VIDEO_VIM2M)		+= vim2m.o
>  
> diff --git a/drivers/media/platform/vimc/Kconfig b/drivers/media/platform/vimc/Kconfig
> new file mode 100644
> index 0000000..b48819c
> --- /dev/null
> +++ b/drivers/media/platform/vimc/Kconfig
> @@ -0,0 +1,7 @@
> +config VIDEO_VIMC
> +	tristate "Virtual Media Controller Driver (VIMC)"
> +	depends on VIDEO_DEV && VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API
> +	select VIDEOBUF2_VMALLOC
> +	default n
> +	---help---
> +	  Skeleton driver for Virtual Media Controller

A bit more verbose description would be nice.

> diff --git a/drivers/media/platform/vimc/Makefile b/drivers/media/platform/vimc/Makefile
> new file mode 100644
> index 0000000..c45195e
> --- /dev/null
> +++ b/drivers/media/platform/vimc/Makefile
> @@ -0,0 +1,3 @@
> +vimc-objs := vimc-core.o vimc-capture.o vimc-sensor.o
> +
> +obj-$(CONFIG_VIDEO_VIMC) += vimc.o
> diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
> new file mode 100644
> index 0000000..b7636cf
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -0,0 +1,553 @@
> +/*
> + * vimc-capture.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>

2017 might be used now.

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
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-vmalloc.h>
> +#include <media/v4l2-ioctl.h>

Numbers come before letters.

> +
> +#include "vimc-capture.h"
> +
> +struct vimc_cap_device {
> +	struct vimc_ent_device ved;
> +	struct video_device vdev;
> +	struct v4l2_device *v4l2_dev;

struct video_device also has a pointer to v4l2_dev. I wonder if that could
be used.

> +	struct device *dev;
> +	struct v4l2_pix_format format;
> +	struct vb2_queue queue;
> +	struct list_head buf_list;
> +	/*
> +	 * NOTE: in a real driver, a spin lock must be used to access the
> +	 * queue because the frames are generated from a hardware interruption
> +	 * and the isr is not allowed to sleep.
> +	 * Even if it is not necessary a spinlock in the vimc driver, we
> +	 * use it here as a code reference
> +	 */
> +	spinlock_t qlock;
> +	struct mutex lock;
> +	u32 sequence;
> +	struct media_pipeline pipe;
> +};
> +
> +struct vimc_cap_buffer {
> +	/*
> +	 * vb2_buffer must be the first element

vb2 or struct vb2_v4l2_buffer ?

> +	 * the videobuf2 framework will allocate this struct based on
> +	 * buf_struct_size and use the first sizeof(struct vb2_buffer) bytes of
> +	 * memory as a vb2_buffer
> +	 */
> +	struct vb2_v4l2_buffer vb2;
> +	struct list_head list;
> +};
> +
> +static int vimc_cap_querycap(struct file *file, void *priv,
> +			     struct v4l2_capability *cap)
> +{
> +	struct vimc_cap_device *vcap = video_drvdata(file);
> +
> +	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
> +	strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info),
> +		 "platform:%s", vcap->v4l2_dev->name);
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_enum_input(struct file *file, void *priv,
> +			       struct v4l2_input *i)
> +{
> +	/* We only have one input */
> +	if (i->index > 0)
> +		return -EINVAL;
> +
> +	i->type = V4L2_INPUT_TYPE_CAMERA;
> +	strlcpy(i->name, "VIMC capture", sizeof(i->name));

Isn't this (*INPUT IOCTLs) something that should be handled in a sub-device
driver, such as a TV tuner?

> +
> +	return 0;
> +}
> +
> +static int vimc_cap_g_input(struct file *file, void *priv, unsigned int *i)
> +{
> +	/* We only have one input */
> +	*i = 0;
> +	return 0;
> +}
> +
> +static int vimc_cap_s_input(struct file *file, void *priv, unsigned int i)
> +{
> +	/* We only have one input */
> +	return i ? -EINVAL : 0;
> +}
> +
> +static int vimc_cap_fmt_vid_cap(struct file *file, void *priv,
> +				  struct v4l2_format *f)
> +{
> +	struct vimc_cap_device *vcap = video_drvdata(file);
> +
> +	f->fmt.pix = vcap->format;
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_enum_fmt_vid_cap(struct file *file, void *priv,
> +				     struct v4l2_fmtdesc *f)
> +{
> +	struct vimc_cap_device *vcap = video_drvdata(file);
> +
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	/* We only support one format for now */
> +	f->pixelformat = vcap->format.pixelformat;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_file_operations vimc_cap_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.read           = vb2_fop_read,
> +	.poll		= vb2_fop_poll,
> +	.unlocked_ioctl = video_ioctl2,
> +	.mmap           = vb2_fop_mmap,
> +};
> +
> +static const struct v4l2_ioctl_ops vimc_cap_ioctl_ops = {
> +	.vidioc_querycap = vimc_cap_querycap,
> +
> +	.vidioc_enum_input = vimc_cap_enum_input,
> +	.vidioc_g_input = vimc_cap_g_input,
> +	.vidioc_s_input = vimc_cap_s_input,
> +
> +	.vidioc_g_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = vimc_cap_fmt_vid_cap,
> +	.vidioc_enum_fmt_vid_cap = vimc_cap_enum_fmt_vid_cap,
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
> +static void vimc_cap_return_all_buffers(struct vimc_cap_device *vcap,
> +					enum vb2_buffer_state state)
> +{
> +	struct vimc_cap_buffer *vbuf, *node;
> +
> +	spin_lock(&vcap->qlock);
> +
> +	list_for_each_entry_safe(vbuf, node, &vcap->buf_list, list) {
> +		vb2_buffer_done(&vbuf->vb2.vb2_buf, state);
> +		list_del(&vbuf->list);
> +	}
> +
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vimc_cap_pipeline_s_stream(struct vimc_cap_device *vcap, int enable)
> +{
> +	int ret;
> +	struct media_pad *pad;
> +	struct media_entity *entity;
> +	struct v4l2_subdev *sd;
> +
> +	/* Start the stream in the subdevice direct connected */
> +	entity = &vcap->vdev.entity;
> +	pad = media_entity_remote_pad(&entity->pads[0]);

You could use vcap->vdev.entity.pads here, without assigning to entity. Then
entity would only be used to refer to the remove entity at the other end of
the link. Up to you.

> +
> +	/* If we are not connected to any subdev node, it means there is nothing

/*
 * Multi line
 * comment.
 */

> +	 * to activate on the pipe (e.g. we can be connected with an input
> +	 * device or we are not connected at all)
> +	 */
> +	if (pad == NULL || !is_media_entity_v4l2_subdev(pad->entity))
> +		return 0;
> +
> +	entity = pad->entity;
> +	sd = media_entity_to_v4l2_subdev(entity);

And if you used pad->entity here, you could remove the entity variable
altogether.

> +
> +	ret = v4l2_subdev_call(sd, video, s_stream, enable);
> +	if (ret && ret != -ENOIOCTLCMD)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int vimc_cap_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +	struct media_entity *entity;
> +	int ret;
> +
> +	vcap->sequence = 0;
> +
> +	/* Start the media pipeline */
> +	entity = &vcap->vdev.entity;
> +	ret = media_entity_pipeline_start(entity, &vcap->pipe);
> +	if (ret) {
> +		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
> +		return ret;
> +	}
> +
> +	/* Enable streaming from the pipe */
> +	ret = vimc_cap_pipeline_s_stream(vcap, 1);
> +	if (ret) {
> +		vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_QUEUED);
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
> +static void vimc_cap_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	/* Disable streaming from the pipe */
> +	vimc_cap_pipeline_s_stream(vcap, 0);
> +
> +	/* Stop the media pipeline */
> +	media_entity_pipeline_stop(&vcap->vdev.entity);
> +
> +	/* Release all active buffers */
> +	vimc_cap_return_all_buffers(vcap, VB2_BUF_STATE_ERROR);
> +}
> +
> +static void vimc_cap_buf_queue(struct vb2_buffer *vb2_buf)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb2_buf->vb2_queue);
> +	struct vimc_cap_buffer *buf = container_of(vb2_buf,
> +						   struct vimc_cap_buffer,
> +						   vb2.vb2_buf);
> +
> +	spin_lock(&vcap->qlock);
> +	list_add_tail(&buf->list, &vcap->buf_list);
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vimc_cap_queue_setup(struct vb2_queue *vq, unsigned int *nbuffers,
> +				unsigned int *nplanes, unsigned int sizes[],
> +				struct device *alloc_devs[])
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	if (*nplanes)
> +		return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;

Why? The user could later reconfigure the device to use with a buffer of
this size. This might not be a concern for vimc, but the code from example
drivers tends to get copied around.

> +	/* We don't support multiplanes for now */
> +	*nplanes = 1;
> +	sizes[0] = vcap->format.sizeimage;
> +
> +	return 0;
> +}
> +
> +/*
> + * Prepare the buffer for queueing to the DMA engine: check and set the
> + * payload size.
> + */
> +static int vimc_cap_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vb->vb2_queue);
> +	unsigned long size = vcap->format.sizeimage;
> +
> +	if (vb2_plane_size(vb, 0) < size) {
> +		dev_err(vcap->dev, "buffer too small (%lu < %lu)\n",
> +			vb2_plane_size(vb, 0), size);
> +		return -EINVAL;
> +	}
> +
> +	vb2_set_plane_payload(vb, 0, size);

Newline here?

> +	return 0;
> +}
> +
> +static const struct vb2_ops vimc_cap_qops = {
> +	.start_streaming	= vimc_cap_start_streaming,
> +	.stop_streaming		= vimc_cap_stop_streaming,
> +	.buf_queue		= vimc_cap_buf_queue,
> +	.queue_setup		= vimc_cap_queue_setup,
> +	.buf_prepare		= vimc_cap_buffer_prepare,
> +	/*
> +	 * Since q->lock is set we can use the standard
> +	 * vb2_ops_wait_prepare/finish helper functions.
> +	 */
> +	.wait_prepare		= vb2_ops_wait_prepare,
> +	.wait_finish		= vb2_ops_wait_finish,
> +};
> +

> +/* NOTE: this function is a copy of v4l2_subdev_link_validate_get_format

/*
 * ...

> + * maybe the v4l2 function should be public
> + */
> +static int vimc_cap_v4l2_subdev_link_validate_get_format(struct media_pad *pad,
> +						struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	fmt->pad = pad->index;

A newline here would be nice.

> +	return v4l2_subdev_call(sd, pad, get_fmt, NULL, fmt);
> +}
> +
> +static int vimc_cap_link_validate(struct media_link *link)
> +{
> +	struct v4l2_subdev_format source_fmt;
> +	struct v4l2_pix_format *sink_fmt;
> +	struct vimc_cap_device *vcap;
> +	const struct vimc_pix_map *vpix;
> +	int ret;
> +
> +	/* Retrieve the video capture device */
> +	vcap = container_of(link->sink->entity,
> +			    struct vimc_cap_device, vdev.entity);

You could assign in variable declaration.

> +
> +	/* If the connected node is not a subdevice type

Ditto.

> +	 * then it's a raw node from vimc-core, ignore the link for now

What's a raw node in this case?

> +	 * TODO: remove this when there are no more raw nodes in the
> +	 * core and return error instead
> +	 */
> +	if (!is_media_entity_v4l2_subdev(link->source->entity))
> +		return 0;
> +
> +	/* Get the the format of the video device */
> +	sink_fmt = &vcap->format;

Same for sink_fmt, you could assign it in variable declaration.

> +
> +	/* Get the the format of the subdev */
> +	ret = vimc_cap_v4l2_subdev_link_validate_get_format(link->source,
> +							    &source_fmt);
> +	if (ret)
> +		return ret;
> +
> +	dev_dbg(vcap->dev,
> +		"cap: %s: link validate formats src:%dx%d %d sink:%dx%d %d\n",
> +		vcap->vdev.name,
> +		source_fmt.format.width, source_fmt.format.height,
> +		source_fmt.format.code,
> +		sink_fmt->width, sink_fmt->height,
> +		sink_fmt->pixelformat);
> +
> +	/* Validate the format */
> +
> +	vpix = vimc_pix_map_by_pixelformat(sink_fmt->pixelformat);
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
> +static const struct media_entity_operations vimc_cap_mops = {
> +	.link_validate		= vimc_cap_link_validate,
> +};
> +
> +static void vimc_cap_destroy(struct vimc_ent_device *ved)
> +{
> +	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
> +						    ved);
> +
> +	vb2_queue_release(&vcap->queue);
> +	media_entity_cleanup(ved->ent);
> +	video_unregister_device(&vcap->vdev);
> +	vimc_pads_cleanup(vcap->ved.pads);
> +	kfree(vcap);
> +}
> +
> +static void vimc_cap_process_frame(struct vimc_ent_device *ved,
> +				   struct media_pad *sink, const void *frame)
> +{
> +	struct vimc_cap_device *vcap = container_of(ved, struct vimc_cap_device,
> +						    ved);
> +	struct vimc_cap_buffer *vimc_buf;
> +	void *vbuf;
> +
> +	/* If the stream in this node is not active, just return */
> +	mutex_lock(&vcap->lock);
> +	if (!vb2_is_busy(&vcap->queue)) {
> +		mutex_unlock(&vcap->lock);
> +		return;
> +	}
> +	mutex_unlock(&vcap->lock);
> +
> +	spin_lock(&vcap->qlock);
> +
> +	/* Get the first entry of the list */
> +	vimc_buf = list_first_entry_or_null(&vcap->buf_list,
> +					    typeof(*vimc_buf), list);
> +	if (!vimc_buf) {
> +		spin_unlock(&vcap->qlock);
> +		return;
> +	}
> +
> +	/* Remove this entry from the list */
> +	list_del(&vimc_buf->list);
> +
> +	spin_unlock(&vcap->qlock);
> +
> +	/* Fill the buffer */
> +	vimc_buf->vb2.vb2_buf.timestamp = ktime_get_ns();
> +	vimc_buf->vb2.sequence = vcap->sequence++;
> +	vimc_buf->vb2.field = vcap->format.field;
> +
> +	vbuf = vb2_plane_vaddr(&vimc_buf->vb2.vb2_buf, 0);
> +
> +	memcpy(vbuf, frame, vcap->format.sizeimage);
> +
> +	/* Set it as ready */
> +	vb2_set_plane_payload(&vimc_buf->vb2.vb2_buf, 0,
> +			      vcap->format.sizeimage);
> +	vb2_buffer_done(&vimc_buf->vb2.vb2_buf, VB2_BUF_STATE_DONE);
> +}
> +
> +struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	int ret;

It'd be nice to declare temporary variables, return values and such last.

> +	struct vb2_queue *q;
> +	struct video_device *vdev;
> +	struct vimc_cap_device *vcap;
> +	const struct vimc_pix_map *vpix;
> +
> +	/* Check entity configuration params

/*
 *

> +	 * NOTE: we only support a single sink pad
> +	 */
> +	if (!name || num_pads != 1 || !pads_flag ||
> +	    !(pads_flag[0] & MEDIA_PAD_FL_SINK))
> +		return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vimc_cap_device struct */
> +	vcap = kzalloc(sizeof(*vcap), GFP_KERNEL);
> +	if (!vcap)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vimc_cap_device struct with v4l2 and dev parent */
> +	vcap->v4l2_dev = v4l2_dev;
> +	vcap->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vcap->ved.pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vcap->ved.pads)) {
> +		ret = PTR_ERR(vcap->ved.pads);
> +		goto err_free_vcap;
> +	}
> +
> +	/* Initialize the media entity */
> +	vcap->vdev.entity.name = name;
> +	vcap->vdev.entity.function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(&vcap->vdev.entity,
> +				     num_pads, vcap->ved.pads);
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
> +	q->buf_struct_size = sizeof(struct vimc_cap_buffer);
> +	q->ops = &vimc_cap_qops;
> +	q->mem_ops = &vb2_vmalloc_memops;
> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->min_buffers_needed = 2;
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
> +	/* Set the frame format (this is hardcoded for now) */
> +	vcap->format.width = 640;
> +	vcap->format.height = 480;
> +	vcap->format.pixelformat = V4L2_PIX_FMT_RGB24;
> +	vcap->format.field = V4L2_FIELD_NONE;
> +	vcap->format.colorspace = V4L2_COLORSPACE_SRGB;
> +
> +	vpix = vimc_pix_map_by_pixelformat(vcap->format.pixelformat);
> +
> +	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
> +	vcap->format.sizeimage = vcap->format.bytesperline *
> +				 vcap->format.height;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vcap->ved.destroy = vimc_cap_destroy;
> +	vcap->ved.ent = &vcap->vdev.entity;
> +	vcap->ved.process_frame = vimc_cap_process_frame;
> +
> +	/* Initialize the video_device struct */
> +	vdev = &vcap->vdev;
> +	vdev->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	vdev->entity.ops = &vimc_cap_mops;
> +	vdev->release = video_device_release_empty;
> +	vdev->fops = &vimc_cap_fops;
> +	vdev->ioctl_ops = &vimc_cap_ioctl_ops;
> +	vdev->lock = &vcap->lock;
> +	vdev->queue = q;
> +	vdev->v4l2_dev = vcap->v4l2_dev;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +	video_set_drvdata(vdev, vcap);
> +
> +	/* Register the video_device with the v4l2 and the media framework */
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret) {
> +		dev_err(vcap->dev,
> +			"video register failed (err=%d)\n", ret);
> +		goto err_release_queue;
> +	}
> +
> +	return &vcap->ved;
> +
> +err_release_queue:
> +	vb2_queue_release(q);
> +err_clean_m_ent:
> +	media_entity_cleanup(&vcap->vdev.entity);
> +err_clean_pads:
> +	vimc_pads_cleanup(vcap->ved.pads);
> +err_free_vcap:
> +	kfree(vcap);
> +
> +	return ERR_PTR(ret);
> +}
> diff --git a/drivers/media/platform/vimc/vimc-capture.h b/drivers/media/platform/vimc/vimc-capture.h
> new file mode 100644
> index 0000000..bcf9fc37
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-capture.h
> @@ -0,0 +1,28 @@
> +/*
> + * vimc-capture.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>
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
> +#ifndef _VIMC_CAPTURE_H_
> +#define _VIMC_CAPTURE_H_
> +
> +#include "vimc-core.h"
> +
> +struct vimc_ent_device *vimc_cap_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag);
> +
> +#endif
> diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
> new file mode 100644
> index 0000000..0a2b91b
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-core.c
> @@ -0,0 +1,600 @@
> +/*
> + * vimc-core.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>
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
> +#include <media/media-device.h>
> +#include <media/v4l2-device.h>
> +
> +#include "vimc-capture.h"
> +#include "vimc-core.h"
> +#include "vimc-sensor.h"
> +
> +#define VIMC_PDEV_NAME "vimc"
> +#define VIMC_MDEV_MODEL_NAME "VIMC MDEV"
> +
> +#define VIMC_ENT_LINK(src, srcpad, sink, sinkpad, link_flags) {	\
> +	.src_ent = src,						\
> +	.src_pad = srcpad,					\
> +	.sink_ent = sink,					\
> +	.sink_pad = sinkpad,					\
> +	.flags = link_flags,					\
> +}
> +
> +#define VIMC_PIX_MAP(_code, _bpp, _pixelformat) {	\
> +	.code = _code,					\
> +	.pixelformat = _pixelformat,			\
> +	.bpp = _bpp,					\
> +}
> +
> +struct vimc_device {
> +	/* The pipeline configuration

/*
 *

> +	 * (filled before calling vimc_device_register)
> +	 */
> +	const struct vimc_pipeline_config *pipe_cfg;
> +
> +	/* The Associated media_device parent */
> +	struct media_device mdev;
> +
> +	/* Internal v4l2 parent device*/
> +	struct v4l2_device v4l2_dev;
> +
> +	/* Internal topology */
> +	struct vimc_ent_device **ved;
> +};
> +
> +/**
> + * enum vimc_ent_node - Select the functionality of a node in the topology
> + * @VIMC_ENT_NODE_SENSOR:	A node of type SENSOR simulates a camera sensor
> + *				generating internal images in bayer format and
> + *				propagating those images through the pipeline
> + * @VIMC_ENT_NODE_CAPTURE:	A node of type CAPTURE is a v4l2 video_device
> + *				that exposes the received image from the
> + *				pipeline to the user space
> + * @VIMC_ENT_NODE_INPUT:	A node of type INPUT is a v4l2 video_device that
> + *				receives images from the user space and
> + *				propagates them through the pipeline
> + * @VIMC_ENT_NODE_DEBAYER:	A node type DEBAYER expects to receive a frame
> + *				in bayer format converts it to RGB
> + * @VIMC_ENT_NODE_SCALER:	A node of type SCALER scales the received image
> + *				by a given multiplier
> + *
> + * This enum is used in the entity configuration struct to allow the definition
> + * of a custom topology specifying the role of each node on it.
> + */
> +enum vimc_ent_node {
> +	VIMC_ENT_NODE_SENSOR,
> +	VIMC_ENT_NODE_CAPTURE,
> +	VIMC_ENT_NODE_INPUT,
> +	VIMC_ENT_NODE_DEBAYER,
> +	VIMC_ENT_NODE_SCALER,
> +};
> +
> +/* Structure which describes individual configuration for each entity */
> +struct vimc_ent_config {
> +	const char *name;
> +	size_t pads_qty;
> +	const unsigned long *pads_flag;
> +	enum vimc_ent_node node;
> +};
> +
> +/* Structure which describes links between entities */
> +struct vimc_ent_link {
> +	unsigned int src_ent;
> +	u16 src_pad;
> +	unsigned int sink_ent;
> +	u16 sink_pad;
> +	u32 flags;
> +};
> +
> +/* Structure which describes the whole topology */
> +struct vimc_pipeline_config {
> +	const struct vimc_ent_config *ents;
> +	size_t num_ents;
> +	const struct vimc_ent_link *links;
> +	size_t num_links;
> +};
> +
> +/* --------------------------------------------------------------------------
> + * Topology Configuration
> + */
> +
> +static const struct vimc_ent_config ent_config[] = {
> +	{
> +		.name = "Sensor A",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Sensor B",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SENSOR,
> +	},
> +	{
> +		.name = "Debayer A",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Debayer B",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_DEBAYER,
> +	},
> +	{
> +		.name = "Raw Capture 0",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "Raw Capture 1",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +	{
> +		.name = "RGB/YUV Input",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_INPUT,
> +	},
> +	{
> +		.name = "Scaler",
> +		.pads_qty = 2,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK,
> +						     MEDIA_PAD_FL_SOURCE},
> +		.node = VIMC_ENT_NODE_SCALER,
> +	},
> +	{
> +		.name = "RGB/YUV Capture",
> +		.pads_qty = 1,
> +		.pads_flag = (const unsigned long[]){MEDIA_PAD_FL_SINK},
> +		.node = VIMC_ENT_NODE_CAPTURE,
> +	},
> +};
> +
> +static const struct vimc_ent_link ent_links[] = {
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Debayer A */
> +	VIMC_ENT_LINK(0, 0, 2, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor A (Pad 0)->(Pad 0) Raw Capture 0 */
> +	VIMC_ENT_LINK(0, 0, 4, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Debayer B */
> +	VIMC_ENT_LINK(1, 0, 3, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Sensor B (Pad 0)->(Pad 0) Raw Capture 1 */
> +	VIMC_ENT_LINK(1, 0, 5, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +	/* Link: Debayer A (Pad 1)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(2, 1, 7, 0, MEDIA_LNK_FL_ENABLED),
> +	/* Link: Debayer B (Pad 1)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(3, 1, 7, 0, 0),
> +	/* Link: RGB/YUV Input (Pad 0)->(Pad 0) Scaler */
> +	VIMC_ENT_LINK(6, 0, 7, 0, 0),
> +	/* Link: Scaler (Pad 1)->(Pad 0) RGB/YUV Capture */
> +	VIMC_ENT_LINK(7, 1, 8, 0, MEDIA_LNK_FL_ENABLED | MEDIA_LNK_FL_IMMUTABLE),
> +};
> +
> +static const struct vimc_pipeline_config pipe_cfg = {
> +	.ents		= ent_config,
> +	.num_ents	= ARRAY_SIZE(ent_config),
> +	.links		= ent_links,
> +	.num_links	= ARRAY_SIZE(ent_links)
> +};
> +
> +/* -------------------------------------------------------------------------- */
> +
> +static void vimc_dev_release(struct device *dev)
> +{}
> +
> +static struct platform_device vimc_pdev = {
> +	.name		= VIMC_PDEV_NAME,
> +	.dev.release	= vimc_dev_release,
> +};
> +
> +const struct vimc_pix_map vimc_pix_map_list[] = {
> +	/* TODO: add all missing formats */
> +
> +	/* RGB formats */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_BGR888_1X24, 3, V4L2_PIX_FMT_BGR24),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_RGB888_1X24, 3, V4L2_PIX_FMT_RGB24),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_ARGB8888_1X32, 4, V4L2_PIX_FMT_ARGB32),
> +
> +	/* Bayer formats */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR8_1X8, 1, V4L2_PIX_FMT_SBGGR8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG8_1X8, 1, V4L2_PIX_FMT_SGBRG8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG8_1X8, 1, V4L2_PIX_FMT_SGRBG8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB8_1X8, 1, V4L2_PIX_FMT_SRGGB8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_1X10, 2, V4L2_PIX_FMT_SBGGR10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_1X10, 2, V4L2_PIX_FMT_SGBRG10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_1X10, 2, V4L2_PIX_FMT_SGRBG10),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_1X10, 2, V4L2_PIX_FMT_SRGGB10),
> +	/* 10bit raw bayer a-law compressed to 8 bits */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_ALAW8_1X8, 1, V4L2_PIX_FMT_SBGGR10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGBRG10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_ALAW8_1X8, 1, V4L2_PIX_FMT_SGRBG10ALAW8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_ALAW8_1X8, 1, V4L2_PIX_FMT_SRGGB10ALAW8),
> +	/* 10bit raw bayer DPCM compressed to 8 bits */
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR10_DPCM8_1X8, 1, V4L2_PIX_FMT_SBGGR10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGBRG10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG10_DPCM8_1X8, 1, V4L2_PIX_FMT_SGRBG10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB10_DPCM8_1X8, 1, V4L2_PIX_FMT_SRGGB10DPCM8),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SBGGR12_1X12, 2, V4L2_PIX_FMT_SBGGR12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGBRG12_1X12, 2, V4L2_PIX_FMT_SGBRG12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SGRBG12_1X12, 2, V4L2_PIX_FMT_SGRBG12),
> +	VIMC_PIX_MAP(MEDIA_BUS_FMT_SRGGB12_1X12, 2, V4L2_PIX_FMT_SRGGB12),
> +
> +	/* End */
> +	{0, 0, 0}
> +};
> +
> +const struct vimc_pix_map *vimc_pix_map_by_code(u32 code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vimc_pix_map_list[i].bpp; i++) {
> +		if (vimc_pix_map_list[i].code == code)
> +			return &vimc_pix_map_list[i];
> +	}
> +	return NULL;
> +}
> +
> +const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; vimc_pix_map_list[i].bpp; i++) {
> +		if (vimc_pix_map_list[i].pixelformat == pixelformat)
> +			return &vimc_pix_map_list[i];
> +	}
> +	return NULL;
> +}
> +
> +int vimc_propagate_frame(struct device *dev,
> +			 struct media_pad *src, const void *frame)
> +{
> +	struct media_link *link;
> +	struct vimc_device *vimc = dev_get_drvdata(dev);
> +
> +	if (!(src->flags & MEDIA_PAD_FL_SOURCE))
> +		return -EINVAL;
> +
> +	/* Send this frame to all sink pads that are direct linked */
> +	list_for_each_entry(link, &src->entity->links, list) {
> +		if (link->source == src &&
> +		    (link->flags & MEDIA_LNK_FL_ENABLED)) {
> +			struct vimc_ent_device *ved;
> +
> +			ved = vimc->ved[link->sink->entity->use_count];
> +			if (ved && ved->process_frame)
> +				ved->process_frame(ved, link->sink, frame);
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void vimc_device_unregister(struct vimc_device *vimc)
> +{
> +	unsigned int i;
> +
> +	/* Cleanup (only initialized) entities */
> +	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
> +		if (vimc->ved[i] && vimc->ved[i]->destroy)
> +			vimc->ved[i]->destroy(vimc->ved[i]);
> +
> +		vimc->ved[i] = NULL;
> +	}
> +	v4l2_device_unregister(&vimc->v4l2_dev);
> +
> +	media_device_unregister(&vimc->mdev);
> +	media_device_cleanup(&vimc->mdev);
> +}
> +
> +/* Helper function to allocate and initialize pads */
> +struct media_pad *vimc_pads_init(u16 num_pads, const unsigned long *pads_flag)
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
> + * entities specific code are implemented
> + */
> +static void vimc_raw_destroy(struct vimc_ent_device *ved)
> +{
> +	media_device_unregister_entity(ved->ent);
> +
> +	media_entity_cleanup(ved->ent);
> +
> +	vimc_pads_cleanup(ved->pads);
> +
> +	kfree(ved->ent);
> +
> +	kfree(ved);
> +}
> +
> +/* TODO: remove this function when all the
> + * entities specific code are implemented
> + */
> +static struct vimc_ent_device *vimc_raw_create(struct v4l2_device *v4l2_dev,
> +					       const char *const name,
> +					       u16 num_pads,
> +					       const unsigned long *pads_flag)
> +{
> +	int ret;
> +	struct vimc_ent_device *ved;
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
> +	ved->pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(ved->pads)) {
> +		ret = PTR_ERR(ved->pads);
> +		goto err_free_ent;
> +	}
> +
> +	/* Initialize the media entity */
> +	ved->ent->name = name;
> +	ved->ent->function = MEDIA_ENT_F_IO_V4L;
> +	ret = media_entity_pads_init(ved->ent, num_pads, ved->pads);
> +	if (ret)
> +		goto err_cleanup_pads;
> +
> +	/* Register the media entity */
> +	ret = media_device_register_entity(v4l2_dev->mdev, ved->ent);
> +	if (ret)
> +		goto err_cleanup_entity;
> +
> +	/* Fill out the destroy function and return */
> +	ved->destroy = vimc_raw_destroy;
> +	return ved;
> +
> +err_cleanup_entity:
> +	media_entity_cleanup(ved->ent);
> +err_cleanup_pads:
> +	vimc_pads_cleanup(ved->pads);
> +err_free_ent:
> +	kfree(ved->ent);
> +err_free_ved:
> +	kfree(ved);
> +
> +	return ERR_PTR(ret);
> +}
> +
> +static int vimc_device_register(struct vimc_device *vimc)
> +{
> +	unsigned int i;
> +	int ret = 0;
> +
> +	/* Allocate memory for the vimc_ent_devices pointers */
> +	vimc->ved = devm_kcalloc(vimc->mdev.dev, vimc->pipe_cfg->num_ents,
> +				 sizeof(*vimc->ved), GFP_KERNEL);
> +	if (!vimc->ved)
> +		return -ENOMEM;
> +
> +	/* Register the media device */
> +	ret = media_device_register(&vimc->mdev);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"media device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the media device within the v4l2_device */
> +	vimc->v4l2_dev.mdev = &vimc->mdev;
> +
> +	/* Register the v4l2 struct */
> +	ret = v4l2_device_register(vimc->mdev.dev, &vimc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"v4l2 device register failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Initialize entities */
> +	for (i = 0; i < vimc->pipe_cfg->num_ents; i++) {
> +		struct vimc_ent_device *(*create_func)(struct v4l2_device *,
> +						       const char *const,
> +						       u16,
> +						       const unsigned long *);
> +
> +		/* Register the specific node */
> +		switch (vimc->pipe_cfg->ents[i].node) {
> +		case VIMC_ENT_NODE_SENSOR:
> +			create_func = vimc_sen_create;
> +			break;
> +
> +		case VIMC_ENT_NODE_CAPTURE:
> +			create_func = vimc_cap_create;
> +			break;
> +
> +		/* TODO: Instantiate the specific topology node */
> +		case VIMC_ENT_NODE_INPUT:
> +		case VIMC_ENT_NODE_DEBAYER:
> +		case VIMC_ENT_NODE_SCALER:
> +		default:
> +			/* TODO: remove this when all the entities specific
> +			 * code are implemented
> +			 */
> +			create_func = vimc_raw_create;
> +			break;
> +		}
> +
> +		vimc->ved[i] = create_func(&vimc->v4l2_dev,
> +					   vimc->pipe_cfg->ents[i].name,
> +					   vimc->pipe_cfg->ents[i].pads_qty,
> +					   vimc->pipe_cfg->ents[i].pads_flag);
> +		if (IS_ERR(vimc->ved[i])) {
> +			ret = PTR_ERR(vimc->ved[i]);
> +			vimc->ved[i] = NULL;
> +			goto err;
> +		}
> +
> +		/* Set use_count to keep track of the ved structure */
> +		vimc->ved[i]->ent->use_count = i;
> +	}
> +
> +	/* Initialize the links between entities */
> +	for (i = 0; i < vimc->pipe_cfg->num_links; i++) {
> +		const struct vimc_ent_link *link = &vimc->pipe_cfg->links[i];
> +
> +		ret = media_create_pad_link(vimc->ved[link->src_ent]->ent,
> +					    link->src_pad,
> +					    vimc->ved[link->sink_ent]->ent,
> +					    link->sink_pad,
> +					    link->flags);
> +		if (ret)
> +			goto err;
> +	}
> +
> +	/* Expose all subdev's nodes*/
> +	ret = v4l2_device_register_subdev_nodes(&vimc->v4l2_dev);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"vimc subdev nodes registration failed (err=%d)\n",
> +			ret);
> +		goto err;
> +	}
> +
> +	return 0;
> +
> +err:
> +	/* Destroy the so far created topology */
> +	vimc_device_unregister(vimc);
> +
> +	return ret;
> +}
> +
> +static int vimc_probe(struct platform_device *pdev)
> +{
> +	struct vimc_device *vimc;
> +	int ret;
> +
> +	/* Prepare the vimc topology structure */
> +
> +	/* Allocate memory for the vimc structure */
> +	vimc = devm_kzalloc(&pdev->dev, sizeof(*vimc), GFP_KERNEL);
> +	if (!vimc)
> +		return -ENOMEM;
> +
> +	/* Set the pipeline configuration struct */
> +	vimc->pipe_cfg = &pipe_cfg;
> +
> +	/* Initialize media device */
> +	strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
> +		sizeof(vimc->mdev.model));
> +	vimc->mdev.dev = &pdev->dev;
> +	media_device_init(&vimc->mdev);
> +
> +	/* Create vimc topology */
> +	ret = vimc_device_register(vimc);
> +	if (ret) {
> +		dev_err(vimc->mdev.dev,
> +			"vimc device registration failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	/* Link the topology object with the platform device object */
> +	platform_set_drvdata(pdev, vimc);
> +
> +	return 0;
> +}
> +
> +static int vimc_remove(struct platform_device *pdev)
> +{
> +	struct vimc_device *vimc;
> +
> +	/* Get the topology object linked with the platform device object */
> +	vimc = platform_get_drvdata(pdev);

You should assign in variable declaration.

> +
> +	/* Destroy all the topology */
> +	vimc_device_unregister(vimc);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver vimc_pdrv = {
> +	.probe		= vimc_probe,
> +	.remove		= vimc_remove,
> +	.driver		= {
> +		.name	= VIMC_PDEV_NAME,
> +	},
> +};
> +
> +static int __init vimc_init(void)
> +{
> +	int ret;
> +
> +	ret = platform_device_register(&vimc_pdev);

You could declare vimc_pdev closer to this.

> +	if (ret) {
> +		dev_err(&vimc_pdev.dev,
> +			"platform device registration failed (err=%d)\n", ret);
> +		return ret;
> +	}
> +
> +	ret = platform_driver_register(&vimc_pdrv);
> +	if (ret) {
> +		dev_err(&vimc_pdev.dev,
> +			"platform driver registration failed (err=%d)\n", ret);
> +
> +		platform_device_unregister(&vimc_pdev);
> +	}
> +
> +	return ret;
> +}
> +
> +static void __exit vimc_exit(void)
> +{
> +	platform_driver_unregister(&vimc_pdrv);
> +
> +	platform_device_unregister(&vimc_pdev);
> +}
> +
> +module_init(vimc_init);
> +module_exit(vimc_exit);
> +
> +MODULE_DESCRIPTION("Virtual Media Controller Driver (VIMC)");
> +MODULE_AUTHOR("Helen Fornazier <helen.fornazier@gmail.com>");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/platform/vimc/vimc-core.h b/drivers/media/platform/vimc/vimc-core.h
> new file mode 100644
> index 0000000..bd7abff
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-core.h
> @@ -0,0 +1,57 @@
> +/*
> + * vimc-core.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>
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
> +#ifndef _VIMC_CORE_H_
> +#define _VIMC_CORE_H_
> +
> +#include <linux/slab.h>
> +#include <media/v4l2-device.h>
> +
> +/* Struct which matches the MEDIA_BUS_FMT_ codes with the corresponding

/*

> + * V4L2_PIX_FMT_ fourcc pixelformat and its bytes per pixel (bpp)
> + */
> +struct vimc_pix_map {
> +	unsigned int code;
> +	unsigned int bpp;
> +	u32 pixelformat;
> +};
> +extern const struct vimc_pix_map vimc_pix_map_list[];
> +
> +struct vimc_ent_device {
> +	struct media_entity *ent;
> +	struct media_pad *pads;
> +	void (*destroy)(struct vimc_ent_device *);
> +	void (*process_frame)(struct vimc_ent_device *ved,
> +			      struct media_pad *sink, const void *frame);
> +};
> +
> +int vimc_propagate_frame(struct device *dev,
> +			 struct media_pad *src, const void *frame);
> +
> +/* Helper functions to allocate/initialize pads and free them */
> +struct media_pad *vimc_pads_init(u16 num_pads,
> +				 const unsigned long *pads_flag);
> +static inline void vimc_pads_cleanup(struct media_pad *pads)
> +{
> +	kfree(pads);
> +}
> +
> +const struct vimc_pix_map *vimc_pix_map_by_code(u32 code);
> +
> +const struct vimc_pix_map *vimc_pix_map_by_pixelformat(u32 pixelformat);
> +
> +#endif
> diff --git a/drivers/media/platform/vimc/vimc-sensor.c b/drivers/media/platform/vimc/vimc-sensor.c
> new file mode 100644
> index 0000000..174e5dc
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-sensor.c
> @@ -0,0 +1,279 @@
> +/*
> + * vimc-sensor.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>
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
> +#include <linux/kthread.h>
> +#include <linux/vmalloc.h>
> +#include <linux/v4l2-mediabus.h>
> +#include <media/v4l2-subdev.h>

Alphabetic order, please.

> +
> +#include "vimc-sensor.h"
> +
> +struct vimc_sen_device {
> +	struct vimc_ent_device ved;
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
> +static int vimc_sen_enum_mbus_code(struct v4l2_subdev *sd,
> +				   struct v4l2_subdev_pad_config *cfg,
> +				   struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	/* Check if it is a valid pad */
> +	if (code->pad >= vsen->sd.entity.num_pads)
> +		return -EINVAL;

The check is already performed in v4l2-subdev.c.

> +
> +	code->code = vsen->mbus_format.code;
> +
> +	return 0;
> +}
> +
> +static int vimc_sen_enum_frame_size(struct v4l2_subdev *sd,
> +				    struct v4l2_subdev_pad_config *cfg,
> +				    struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	/* Check if it is a valid pad */
> +	if (fse->pad >= vsen->sd.entity.num_pads)
> +		return -EINVAL;

Same here.

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
> +static int vimc_sen_get_fmt(struct v4l2_subdev *sd,
> +			    struct v4l2_subdev_pad_config *cfg,
> +			    struct v4l2_subdev_format *format)
> +{
> +	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	format->format = vsen->mbus_format;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_subdev_pad_ops vimc_sen_pad_ops = {
> +	.enum_mbus_code		= vimc_sen_enum_mbus_code,
> +	.enum_frame_size	= vimc_sen_enum_frame_size,
> +	.get_fmt		= vimc_sen_get_fmt,
> +	/* TODO: Add support to other formats */
> +	.set_fmt		= vimc_sen_get_fmt,
> +};
> +
> +/* media operations */
> +static const struct media_entity_operations vimc_sen_mops = {
> +	.link_validate = v4l2_subdev_link_validate,
> +};
> +
> +static int vimc_thread_sen(void *data)
> +{
> +	unsigned int i;
> +	struct vimc_sen_device *vsen = data;
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
> +			vimc_propagate_frame(vsen->dev,
> +					     &vsen->sd.entity.pads[i],
> +					     vsen->frame);
> +
> +		/* 60 frames per second */
> +		schedule_timeout_interruptible(HZ/60);
> +	}
> +
> +	return 0;
> +}
> +
> +static int vimc_sen_s_stream(struct v4l2_subdev *sd, int enable)
> +{
> +	int ret;
> +	struct vimc_sen_device *vsen = v4l2_get_subdevdata(sd);
> +
> +	if (enable) {
> +		const struct vimc_pix_map *vpix;
> +
> +		if (vsen->kthread_sen)
> +			return -EINVAL;
> +
> +		/* Calculate the frame size */
> +		vpix = vimc_pix_map_by_code(vsen->mbus_format.code);
> +		vsen->frame_size = vsen->mbus_format.width * vpix->bpp *
> +				   vsen->mbus_format.height;
> +
> +		/* Allocate the frame buffer. Use vmalloc to be able to

/*
 *

> +		 * allocate a large amount of memory
> +		 */
> +		vsen->frame = vmalloc(vsen->frame_size);
> +		if (!vsen->frame)
> +			return -ENOMEM;
> +
> +		/* Initialize the image generator thread */
> +		vsen->kthread_sen = kthread_run(vimc_thread_sen, vsen,
> +						"%s-sen", vsen->v4l2_dev->name);

We have no other kthreads, just the video device name should be enough.

> +		if (IS_ERR(vsen->kthread_sen)) {
> +			v4l2_err(vsen->v4l2_dev, "kernel_thread() failed\n");

How about dev_err() instead? You use dev_*() macros elsewhere for printing.

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
> +struct v4l2_subdev_video_ops vimc_sen_video_ops = {
> +	.s_stream = vimc_sen_s_stream,
> +};
> +
> +static const struct v4l2_subdev_ops vimc_sen_ops = {
> +	.pad = &vimc_sen_pad_ops,
> +	.video = &vimc_sen_video_ops,
> +};
> +
> +static void vimc_sen_destroy(struct vimc_ent_device *ved)
> +{
> +	struct vimc_sen_device *vsen = container_of(ved,
> +						struct vimc_sen_device, ved);
> +
> +	media_entity_cleanup(ved->ent);
> +	v4l2_device_unregister_subdev(&vsen->sd);

I'd say media_entity_cleanup() would belong here but it's an empty function
nowadays...

> +	kfree(vsen);
> +}
> +
> +struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag)
> +{
> +	int ret;
> +	unsigned int i;
> +	struct vimc_sen_device *vsen;

vsen first?

> +
> +	if (!name || (num_pads && !pads_flag))
> +		return ERR_PTR(-EINVAL);
> +	/* check if all pads are sources */
> +	for (i = 0; i < num_pads; i++)
> +		if (!(pads_flag[i] & MEDIA_PAD_FL_SOURCE))
> +			return ERR_PTR(-EINVAL);
> +
> +	/* Allocate the vsen struct */
> +	vsen = kzalloc(sizeof(*vsen), GFP_KERNEL);
> +	if (!vsen)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/* Link the vimc_sen_device struct with the v4l2 parent */
> +	vsen->v4l2_dev = v4l2_dev;
> +	/* Link the vimc_sen_device struct with the dev parent */
> +	vsen->dev = v4l2_dev->dev;
> +
> +	/* Allocate the pads */
> +	vsen->ved.pads = vimc_pads_init(num_pads, pads_flag);
> +	if (IS_ERR(vsen->ved.pads)) {
> +		ret = PTR_ERR(vsen->ved.pads);
> +		goto err_free_vsen;
> +	}
> +
> +	/* Initialize the media entity */
> +	vsen->sd.entity.name = name;
> +	ret = media_entity_pads_init(&vsen->sd.entity,
> +				     num_pads, vsen->ved.pads);
> +	if (ret)
> +		goto err_clean_pads;
> +
> +	/* Set the active frame format (this is hardcoded for now) */
> +	vsen->mbus_format.width = 640;
> +	vsen->mbus_format.height = 480;
> +	vsen->mbus_format.code = MEDIA_BUS_FMT_RGB888_1X24;
> +	vsen->mbus_format.field = V4L2_FIELD_NONE;
> +	vsen->mbus_format.colorspace = V4L2_COLORSPACE_SRGB;
> +	vsen->mbus_format.quantization = V4L2_QUANTIZATION_FULL_RANGE;
> +	vsen->mbus_format.xfer_func = V4L2_XFER_FUNC_SRGB;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vsen->ved.destroy = vimc_sen_destroy;
> +	vsen->ved.ent = &vsen->sd.entity;
> +
> +	/* Initialize the subdev */
> +	v4l2_subdev_init(&vsen->sd, &vimc_sen_ops);
> +	vsen->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
> +	vsen->sd.entity.ops = &vimc_sen_mops;
> +	vsen->sd.owner = THIS_MODULE;
> +	strlcpy(vsen->sd.name, name, sizeof(vsen->sd.name));
> +	v4l2_set_subdevdata(&vsen->sd, vsen);
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
> +	return &vsen->ved;
> +
> +err_clean_m_ent:
> +	media_entity_cleanup(&vsen->sd.entity);
> +err_clean_pads:
> +	vimc_pads_cleanup(vsen->ved.pads);
> +err_free_vsen:
> +	kfree(vsen);
> +
> +	return ERR_PTR(ret);
> +}
> diff --git a/drivers/media/platform/vimc/vimc-sensor.h b/drivers/media/platform/vimc/vimc-sensor.h
> new file mode 100644
> index 0000000..ffeaf6c
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-sensor.h
> @@ -0,0 +1,28 @@
> +/*
> + * vimc-sensor.h Virtual Media Controller Driver
> + *
> + * Copyright (C) 2016 Helen Koike F. <helen.fornazier@gmail.com>
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
> +#ifndef _VIMC_SENSOR_H_
> +#define _VIMC_SENSOR_H_
> +
> +#include "vimc-core.h"
> +
> +struct vimc_ent_device *vimc_sen_create(struct v4l2_device *v4l2_dev,
> +					const char *const name,
> +					u16 num_pads,
> +					const unsigned long *pads_flag);
> +
> +#endif

Looks very nice in general! I'll try this out soon.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
