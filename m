Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:45639 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbcGAMlB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 08:41:01 -0400
Subject: Re: [PATCH v4] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.co.uk>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	jgebben@codeaurora.org, mchehab@osg.samsung.com
References: <1464706979-32340-1-git-send-email-helen.koike@collabora.co.uk>
Cc: Helen Fornazier <helen.fornazier@gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5aae6086-6ba3-c278-ec48-043b17b4aa33@xs4all.nl>
Date: Fri, 1 Jul 2016 14:39:25 +0200
MIME-Version: 1.0
In-Reply-To: <1464706979-32340-1-git-send-email-helen.koike@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

Better late than never, but I finally have time for a review, mostly with a eye for V4L2 issues.

Please note the 'kbuild test robot' mails you received: those issues should be resolved
in v5. It looks like it misses the media controller dependency in the Kconfig.

On 05/31/2016 05:02 PM, Helen Koike wrote:
> From: Helen Fornazier <helen.fornazier@gmail.com>
> 
> First version of the Virtual Media Controller.
> Add a simple version of the core of the driver, the capture and
> sensor nodes in the topology, generating a grey image in a hardcoded
> format.
> 
> Signed-off-by: Helen Fornazier <helen.fornazier@gmail.com>
> 
> ---
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
> 
>  drivers/media/platform/Kconfig             |   2 +
>  drivers/media/platform/Makefile            |   1 +
>  drivers/media/platform/vimc/Kconfig        |   8 +
>  drivers/media/platform/vimc/Makefile       |   3 +
>  drivers/media/platform/vimc/vimc-capture.c | 536 ++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-capture.h |  28 ++
>  drivers/media/platform/vimc/vimc-core.c    | 595 +++++++++++++++++++++++++++++
>  drivers/media/platform/vimc/vimc-core.h    |  56 +++
>  drivers/media/platform/vimc/vimc-sensor.c  | 278 ++++++++++++++
>  drivers/media/platform/vimc/vimc-sensor.h  |  28 ++
>  10 files changed, 1535 insertions(+)
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
> index 84e041c..9e10d49 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -284,6 +284,8 @@ menuconfig V4L_TEST_DRIVERS
>  
>  if V4L_TEST_DRIVERS
>  
> +source "drivers/media/platform/vimc/Kconfig"
> +
>  source "drivers/media/platform/vivid/Kconfig"
>  
>  config VIDEO_VIM2M
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index bbb7bd1..e4508fe 100644
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
> index 0000000..c99666a
> --- /dev/null
> +++ b/drivers/media/platform/vimc/Kconfig
> @@ -0,0 +1,8 @@
> +config VIDEO_VIMC
> +	tristate "Virtual Media Controller Driver (VIMC)"
> +	depends on VIDEO_DEV && VIDEO_V4L2
> +	select VIDEO_V4L2_SUBDEV_API

This should be depends on.

> +	select VIDEOBUF2_VMALLOC
> +	default n
> +	---help---
> +	  Skeleton driver for Virtual Media Controller
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
> index 0000000..82de8b89
> --- /dev/null
> +++ b/drivers/media/platform/vimc/vimc-capture.c
> @@ -0,0 +1,536 @@
> +/*
> + * vimc-capture.c Virtual Media Controller Driver
> + *
> + * Copyright (C) 2015 Helen Fornazier <helen.fornazier@gmail.com>

Copyright year can be updated to 2016.

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
> +
> +#include "vimc-capture.h"
> +
> +struct vimc_cap_device {
> +	struct vimc_ent_device ved;
> +	struct video_device vdev;
> +	struct v4l2_device *v4l2_dev;
> +	struct device *dev;
> +	struct v4l2_pix_format format;
> +	struct vb2_queue queue;
> +	struct list_head buf_list;
> +	/* NOTE: in a real driver, a spin lock must be used to access the
> +	 * queue because the frames are generated from a hardware interruption
> +	 * and the isr is not allowed to sleep.
> +	 * Even if it is not necessary a spinlock in the vimc driver, we
> +	 * use it here as a code reference */

I suspect checkpatch will warn about the comment format. Did you run checkpatch?

> +	spinlock_t qlock;
> +	struct mutex lock;
> +	u32 sequence;
> +	struct media_pipeline pipe;
> +};
> +
> +struct vimc_cap_buffer {
> +	/*
> +	 * vb2_buffer must be the first element
> +	 * the videobf2 framework will allocate this struct based on

s/videobf2/videobuf2/

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
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

This line can be dropped, the v4l2 core will fill this in (a recent change).

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
> +static int vimc_cap_g_fmt_vid_cap(struct file *file, void *priv,
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
> +	.vidioc_g_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
> +	.vidioc_s_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,
> +	.vidioc_try_fmt_vid_cap = vimc_cap_g_fmt_vid_cap,

Rename vimc_cap_g_fmt_vid_cap to vimc_cap_fmt_vid_cap to make it clear it is used by all three ioctls.

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
> +
> +	/* If we are not connected to any subdev node, it means there is nothing
> +	 * to activate on the pipe (e.g. we can be connected with an input
> +	 * device or we are not connected at all)
> +	 */
> +	if (pad == NULL || !is_media_entity_v4l2_subdev(pad->entity))
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
> +					struct vimc_cap_buffer, vb2.vb2_buf);
> +
> +	/* If the buffer doesn't have enough size, mark it as error */
> +	if (vb2_buf->planes[0].length < vcap->format.sizeimage) {
> +		vb2_buffer_done(vb2_buf, VB2_BUF_STATE_ERROR);
> +		return;
> +	}

That's wrong. This check should happen in the vb2_ops buf_prepare callback.
See how other drivers do that.

> +
> +	spin_lock(&vcap->qlock);
> +
> +	list_add_tail(&buf->list, &vcap->buf_list);
> +
> +	spin_unlock(&vcap->qlock);
> +}
> +
> +static int vimc_cap_queue_setup(struct vb2_queue *vq,
> +				unsigned int *nbuffers, unsigned int *nplanes,
> +				unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct vimc_cap_device *vcap = vb2_get_drv_priv(vq);
> +
> +	if (*nplanes)
> +		return sizes[0] < vcap->format.sizeimage ? -EINVAL : 0;
> +	/* We don't support multiplanes for now */
> +	*nplanes = 1;
> +	sizes[0] = vcap->format.sizeimage;
> +
> +	return 0;
> +}
> +
> +static const struct vb2_ops vimc_cap_qops = {
> +	.start_streaming	= vimc_cap_start_streaming,
> +	.stop_streaming		= vimc_cap_stop_streaming,
> +	.buf_queue		= vimc_cap_buf_queue,
> +	.queue_setup		= vimc_cap_queue_setup,
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
> +static int vimc_cap_v4l2_subdev_link_validate_get_format(struct media_pad *pad,
> +						struct v4l2_subdev_format *fmt)
> +{
> +	struct v4l2_subdev *sd = media_entity_to_v4l2_subdev(pad->entity);
> +
> +	fmt->which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	fmt->pad = pad->index;
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
> +
> +	/* If the connected node is not a subdevice type
> +	 * then it's a raw node from vimc-core, ignore the link for now
> +	 * TODO: remove this when there are no more raw nodes in the
> +	 * core and return error instead */
> +	if (!is_media_entity_v4l2_subdev(link->source->entity))
> +		return 0;
> +
> +	/* Get the the format of the video device */
> +	sink_fmt = &vcap->format;
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
> +	struct vb2_queue *q;
> +	struct video_device *vdev;
> +	struct vimc_cap_device *vcap;
> +	const struct vimc_pix_map *vpix;
> +
> +	if (!v4l2_dev || !v4l2_dev->dev || !name || (num_pads && !pads_flag))
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

Please add VB2_READ and VB2_USERPTR as well since all are supported.

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
> +	/* This should never be NULL, as we won't allow any format
> +	 * other then the ones in the vimc_pix_map_list table */
> +	BUG_ON(!vpix);
> +
> +	vcap->format.bytesperline = vcap->format.width * vpix->bpp;
> +	vcap->format.sizeimage = vcap->format.bytesperline * vcap->format.height;
> +
> +	/* Fill the vimc_ent_device struct */
> +	vcap->ved.destroy = vimc_cap_destroy;
> +	vcap->ved.ent = &vcap->vdev.entity;
> +	vcap->ved.process_frame = vimc_cap_process_frame;
> +
> +	/* Initialize the video_device struct */
> +	vdev = &vcap->vdev;
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

Regards,

	Hans
