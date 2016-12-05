Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:43249 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751064AbcLENpC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Dec 2016 08:45:02 -0500
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Todor Tomov <todor.tomov@linaro.org>, mchehab@kernel.org,
        laurent.pinchart+renesas@ideasonboard.com, hans.verkuil@cisco.com,
        javier@osg.samsung.com, s.nawrocki@samsung.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
Cc: bjorn.andersson@linaro.org, srinivas.kandagatla@linaro.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9b1cffbc-62a9-c699-5813-189d5f160343@xs4all.nl>
Date: Mon, 5 Dec 2016 14:44:55 +0100
MIME-Version: 1.0
In-Reply-To: <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

A few comments below:

On 11/25/2016 03:57 PM, Todor Tomov wrote:
> These files handle the video device nodes of the camss driver.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
> ---
>  drivers/media/platform/qcom/camss-8x16/video.c | 597 +++++++++++++++++++++++++
>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>  2 files changed, 664 insertions(+)
>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
> 
> diff --git a/drivers/media/platform/qcom/camss-8x16/video.c b/drivers/media/platform/qcom/camss-8x16/video.c
> new file mode 100644
> index 0000000..0bf8ea9
> --- /dev/null
> +++ b/drivers/media/platform/qcom/camss-8x16/video.c
> @@ -0,0 +1,597 @@

<snip>

> +static int video_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct camss_video *video = vb2_get_drv_priv(q);
> +	struct video_device *vdev = video->vdev;
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	ret = media_entity_pipeline_start(&vdev->entity, &video->pipe);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = video_check_format(video);
> +	if (ret < 0)
> +		goto error;
> +
> +	entity = &vdev->entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
> +		if (ret < 0 && ret != -ENOIOCTLCMD)
> +			goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	media_entity_pipeline_stop(&vdev->entity);
> +

On error all queued buffers must be returned with state VB2_STATE_QUEUED.

Basically the same as 'camss_video_call(video, flush_buffers);', just with
a different state.

> +	return ret;
> +}

<snip>

> +static int video_querycap(struct file *file, void *fh,
> +			  struct v4l2_capability *cap)
> +{
> +	strlcpy(cap->driver, "qcom-camss", sizeof(cap->driver));
> +	strlcpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
> +	strlcpy(cap->bus_info, "platform:qcom-camss", sizeof(cap->bus_info));
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +							V4L2_CAP_DEVICE_CAPS;
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;

Don't set capabilities and device_caps here. Instead fill in the struct video_device
device_caps field and the v4l2 core will take care of cap->capabilities and
cap->device_caps.

> +
> +	return 0;
> +}
> +
> +static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +	struct v4l2_format format;
> +	int ret;
> +
> +	if (f->type != video->type)
> +		return -EINVAL;
> +
> +	if (f->index)
> +		return -EINVAL;
> +
> +	ret = video_get_subdev_format(video, &format);
> +	if (ret < 0)
> +		return ret;
> +
> +	f->pixelformat = format.fmt.pix.pixelformat;
> +
> +	return 0;
> +}
> +
> +static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +
> +	if (f->type != video->type)
> +		return -EINVAL;
> +
> +	*f = video->active_fmt;
> +
> +	return 0;
> +}
> +
> +static int video_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +	int ret;
> +
> +	if (f->type != video->type)
> +		return -EINVAL;
> +
> +	ret = video_get_subdev_format(video, f);
> +	if (ret < 0)
> +		return ret;
> +
> +	video->active_fmt = *f;
> +
> +	return 0;
> +}
> +
> +static int video_try_fmt(struct file *file, void *fh, struct v4l2_format *f)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +
> +	if (f->type != video->type)
> +		return -EINVAL;
> +
> +	return video_get_subdev_format(video, f);
> +}
> +
> +static int video_enum_input(struct file *file, void *fh,
> +			    struct v4l2_input *input)
> +{
> +	if (input->index > 0)
> +		return -EINVAL;
> +
> +	strlcpy(input->name, "camera", sizeof(input->name));
> +	input->type = V4L2_INPUT_TYPE_CAMERA;
> +
> +	return 0;
> +}
> +
> +static int video_g_input(struct file *file, void *fh, unsigned int *input)
> +{
> +	*input = 0;
> +
> +	return 0;
> +}
> +
> +static int video_s_input(struct file *file, void *fh, unsigned int input)
> +{
> +	return input == 0 ? 0 : -EINVAL;
> +}
> +
> +static const struct v4l2_ioctl_ops msm_vid_ioctl_ops = {
> +	.vidioc_querycap          = video_querycap,
> +	.vidioc_enum_fmt_vid_cap  = video_enum_fmt,
> +	.vidioc_g_fmt_vid_cap     = video_g_fmt,
> +	.vidioc_s_fmt_vid_cap     = video_s_fmt,
> +	.vidioc_try_fmt_vid_cap   = video_try_fmt,
> +	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
> +	.vidioc_querybuf          = vb2_ioctl_querybuf,
> +	.vidioc_qbuf              = vb2_ioctl_qbuf,
> +	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
> +	.vidioc_streamon          = vb2_ioctl_streamon,
> +	.vidioc_streamoff         = vb2_ioctl_streamoff,
> +	.vidioc_enum_input        = video_enum_input,
> +	.vidioc_g_input           = video_g_input,
> +	.vidioc_s_input           = video_s_input,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +
> +/*
> + * video_init_format - Helper function to initialize format
> + *
> + * Initialize all pad formats with default values.
> + */
> +static int video_init_format(struct file *file, void *fh)
> +{
> +	struct v4l2_format format;
> +
> +	memset(&format, 0, sizeof(format));
> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +
> +	return video_s_fmt(file, fh, &format);
> +}
> +
> +static int video_open(struct file *file)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct camss_video *video = video_drvdata(file);
> +	struct camss_video_fh *handle;
> +	int ret;
> +
> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
> +	if (handle == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(&handle->vfh, video->vdev);
> +	v4l2_fh_add(&handle->vfh);
> +
> +	handle->video = video;
> +	file->private_data = &handle->vfh;
> +
> +	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
> +	if (ret < 0) {
> +		dev_err(video->camss->dev, "Failed to power up pipeline\n");
> +		goto error_pm_use;
> +	}
> +
> +	ret = video_init_format(file, &handle->vfh);
> +	if (ret < 0) {
> +		dev_err(video->camss->dev, "Failed to init format\n");
> +		goto error_init_format;
> +	}
> +
> +	return 0;
> +
> +error_init_format:
> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
> +
> +error_pm_use:
> +	v4l2_fh_del(&handle->vfh);

You're missing a call to v4l2_fh_exit().

> +	kfree(handle);

But I would recommend replacing v4l2_fh_del, v4l2_fh_exit and kfree by a single
call to v4l2_fh_release().

> +
> +	return ret;
> +}
> +
> +static int video_release(struct file *file)
> +{
> +	struct video_device *vdev = video_devdata(file);
> +	struct camss_video *video = video_drvdata(file);
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct camss_video_fh *handle = container_of(vfh, struct camss_video_fh,
> +						     vfh);
> +
> +	vb2_ioctl_streamoff(file, vfh, video->type);

Don't call this function, instead call vb2_fop_release().

> +
> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
> +
> +	v4l2_fh_del(vfh);
> +	kfree(handle);

These two lines can be dropped as well when you use vb2_fop_release.

> +	file->private_data = NULL;
> +
> +	return 0;
> +}
> +
> +static unsigned int video_poll(struct file *file,
> +				   struct poll_table_struct *wait)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +
> +	return vb2_poll(&video->vb2_q, file, wait);
> +}
> +
> +static int video_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct camss_video *video = video_drvdata(file);
> +
> +	return vb2_mmap(&video->vb2_q, vma);
> +}
> +
> +static const struct v4l2_file_operations msm_vid_fops = {
> +	.owner          = THIS_MODULE,
> +	.unlocked_ioctl = video_ioctl2,
> +	.open           = video_open,
> +	.release        = video_release,
> +	.poll           = video_poll,
> +	.mmap		= video_mmap,

You should be able to use vb2_fop_poll/mmap here instead of rolling your own.
I recommend adding vb2_fop_read as well.

> +};
> +
> +/* -----------------------------------------------------------------------------
> + * CAMSS video core
> + */
> +
> +int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
> +		       const char *name)
> +{
> +	struct media_pad *pad = &video->pad;
> +	struct video_device *vdev;
> +	struct vb2_queue *q;
> +	int ret;
> +
> +	vdev = video_device_alloc();
> +	if (vdev == NULL) {
> +		dev_err(v4l2_dev->dev, "Failed to allocate video device\n");
> +		return -ENOMEM;
> +	}
> +
> +	video->vdev = vdev;
> +
> +	q = &video->vb2_q;
> +	q->drv_priv = video;
> +	q->mem_ops = &vb2_dma_contig_memops;
> +	q->ops = &msm_video_vb2_q_ops;
> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	q->io_modes = VB2_MMAP;

Add modes VB2_DMABUF and VB2_READ. These are for free, so why not? Especially DMABUF
is of course very desirable to have.

> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> +	q->buf_struct_size = sizeof(struct camss_buffer);
> +	q->dev = video->camss->dev;
> +	ret = vb2_queue_init(q);
> +	if (ret < 0) {
> +		dev_err(v4l2_dev->dev, "Failed to init vb2 queue\n");
> +		return ret;
> +	}
> +
> +	pad->flags = MEDIA_PAD_FL_SINK;
> +	ret = media_entity_pads_init(&vdev->entity, 1, pad);
> +	if (ret < 0) {
> +		dev_err(v4l2_dev->dev, "Failed to init video entity\n");
> +		goto error_media_init;
> +	}
> +
> +	vdev->fops = &msm_vid_fops;
> +	vdev->ioctl_ops = &msm_vid_ioctl_ops;
> +	vdev->release = video_device_release;
> +	vdev->v4l2_dev = v4l2_dev;
> +	vdev->vfl_dir = VFL_DIR_RX;
> +	vdev->queue = &video->vb2_q;

As mentioned in querycap: set vdev->device_caps here.

> +	strlcpy(vdev->name, name, sizeof(vdev->name));
> +
> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(v4l2_dev->dev, "Failed to register video device\n");
> +		goto error_video_register;
> +	}
> +
> +	video_set_drvdata(vdev, video);
> +
> +	return 0;
> +
> +error_video_register:
> +	media_entity_cleanup(&vdev->entity);
> +error_media_init:
> +	vb2_queue_release(&video->vb2_q);
> +
> +	return ret;
> +}
> +
> +void msm_video_unregister(struct camss_video *video)
> +{
> +	video_unregister_device(video->vdev);
> +	media_entity_cleanup(&video->vdev->entity);
> +	vb2_queue_release(&video->vb2_q);
> +}
> diff --git a/drivers/media/platform/qcom/camss-8x16/video.h b/drivers/media/platform/qcom/camss-8x16/video.h
> new file mode 100644
> index 0000000..5ab5929d
> --- /dev/null
> +++ b/drivers/media/platform/qcom/camss-8x16/video.h
> @@ -0,0 +1,67 @@
> +/*
> + * video.h
> + *
> + * Qualcomm MSM Camera Subsystem - V4L2 device node
> + *
> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
> + * Copyright (C) 2015-2016 Linaro Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +#ifndef QC_MSM_CAMSS_VIDEO_H
> +#define QC_MSM_CAMSS_VIDEO_H
> +
> +#include <linux/videodev2.h>
> +#include <media/media-entity.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-mediabus.h>
> +#include <media/videobuf2-v4l2.h>
> +
> +#define camss_video_call(f, op, args...)			\
> +	(!(f) ? -ENODEV : (((f)->ops && (f)->ops->op) ? \
> +			    (f)->ops->op((f), ##args) : -ENOIOCTLCMD))
> +
> +struct camss_buffer {
> +	struct vb2_v4l2_buffer vb;
> +	dma_addr_t addr;
> +	struct list_head queue;
> +};
> +
> +struct camss_video;
> +
> +struct camss_video_ops {
> +	int (*queue_buffer)(struct camss_video *vid, struct camss_buffer *buf);
> +	int (*flush_buffers)(struct camss_video *vid);
> +};
> +
> +struct camss_video {
> +	struct camss *camss;
> +	struct vb2_queue vb2_q;
> +	struct video_device *vdev;
> +	struct media_pad pad;
> +	struct v4l2_format active_fmt;
> +	enum v4l2_buf_type type;
> +	struct media_pipeline pipe;
> +	struct camss_video_ops *ops;
> +};
> +
> +struct camss_video_fh {
> +	struct v4l2_fh vfh;
> +	struct camss_video *video;
> +};
> +
> +int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
> +		       const char *name);
> +
> +void msm_video_unregister(struct camss_video *video);
> +
> +#endif /* QC_MSM_CAMSS_VIDEO_H */
> 

Regards,

	Hans
