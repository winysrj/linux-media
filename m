Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:33110 "EHLO
        mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdASKuc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Jan 2017 05:50:32 -0500
Received: by mail-lf0-f51.google.com with SMTP id k86so33040148lfi.0
        for <linux-media@vger.kernel.org>; Thu, 19 Jan 2017 02:50:15 -0800 (PST)
From: Todor Tomov <todor.tomov@linaro.org>
Subject: Re: [PATCH 08/10] media: camss: Add files which handle the video
 device nodes
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1480085841-28276-1-git-send-email-todor.tomov@linaro.org>
 <1480085841-28276-7-git-send-email-todor.tomov@linaro.org>
 <3060297.EOJqEVJIo3@avalon>
Cc: mchehab@kernel.org, laurent.pinchart+renesas@ideasonboard.com,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        s.nawrocki@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, bjorn.andersson@linaro.org,
        srinivas.kandagatla@linaro.org
Message-ID: <58809839.8050301@linaro.org>
Date: Thu, 19 Jan 2017 12:43:05 +0200
MIME-Version: 1.0
In-Reply-To: <3060297.EOJqEVJIo3@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for the detailed review.

On 12/05/2016 05:22 PM, Laurent Pinchart wrote:
> Hi Todor,
> 
> Thank you for the patch.
> 
> On Friday 25 Nov 2016 16:57:20 Todor Tomov wrote:
>> These files handle the video device nodes of the camss driver.
> 
> camss is a quite generic, I'm a bit concerned about claiming that acronym in 
> the global kernel namespace. Would it be too long if we prefixed symbols with 
> msm_camss instead ?

Ok. Are you concerned about camss_enable_clocks() and camss_disable_clocks() or
you have something else in mind too?

> 
>> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/camss-8x16/video.c | 597 ++++++++++++++++++++++
>>  drivers/media/platform/qcom/camss-8x16/video.h |  67 +++
>>  2 files changed, 664 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.c
>>  create mode 100644 drivers/media/platform/qcom/camss-8x16/video.h
>>
>> diff --git a/drivers/media/platform/qcom/camss-8x16/video.c
>> b/drivers/media/platform/qcom/camss-8x16/video.c new file mode 100644
>> index 0000000..0bf8ea9
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/video.c
>> @@ -0,0 +1,597 @@
>> +/*
>> + * video.c
>> + *
>> + * Qualcomm MSM Camera Subsystem - V4L2 device node
>> + *
>> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-ioctl.h>
>> +#include <media/v4l2-mc.h>
>> +#include <media/videobuf-core.h>
>> +#include <media/videobuf2-dma-contig.h>
>> +
>> +#include "video.h"
>> +#include "camss.h"
>> +
>> +/*
>> + * struct format_info - ISP media bus format information
>> + * @code: V4L2 media bus format code
>> + * @pixelformat: V4L2 pixel format FCC identifier
>> + * @bpp: Bits per pixel when stored in memory
>> + */
>> +static const struct format_info {
>> +	u32 code;
>> +	u32 pixelformat;
>> +	unsigned int bpp;
>> +} formats[] = {
>> +	{ MEDIA_BUS_FMT_UYVY8_2X8, V4L2_PIX_FMT_UYVY, 16 },
>> +	{ MEDIA_BUS_FMT_VYUY8_2X8, V4L2_PIX_FMT_VYUY, 16 },
>> +	{ MEDIA_BUS_FMT_YUYV8_2X8, V4L2_PIX_FMT_YUYV, 16 },
>> +	{ MEDIA_BUS_FMT_YVYU8_2X8, V4L2_PIX_FMT_YVYU, 16 },
>> +	{ MEDIA_BUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8, 8 },
>> +	{ MEDIA_BUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8, 8 },
>> +	{ MEDIA_BUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8, 8 },
>> +	{ MEDIA_BUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SRGGB8, 8 },
>> +	{ MEDIA_BUS_FMT_SBGGR10_1X10, V4L2_PIX_FMT_SBGGR10P, 10 },
>> +	{ MEDIA_BUS_FMT_SGBRG10_1X10, V4L2_PIX_FMT_SGBRG10P, 10 },
>> +	{ MEDIA_BUS_FMT_SGRBG10_1X10, V4L2_PIX_FMT_SGRBG10P, 10 },
>> +	{ MEDIA_BUS_FMT_SRGGB10_1X10, V4L2_PIX_FMT_SRGGB10P, 10 },
>> +	{ MEDIA_BUS_FMT_SBGGR12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 },
>> +	{ MEDIA_BUS_FMT_SGBRG12_1X12, V4L2_PIX_FMT_SGBRG12P, 12 },
>> +	{ MEDIA_BUS_FMT_SGRBG12_1X12, V4L2_PIX_FMT_SGRBG12P, 12 },
>> +	{ MEDIA_BUS_FMT_SRGGB12_1X12, V4L2_PIX_FMT_SRGGB12P, 12 }
>> +};
>> +
>> +/*
>> ---------------------------------------------------------------------------
>> -- + * Helper functions
>> + */
>> +
>> +/*
>> + * video_mbus_to_pix - Convert v4l2_mbus_framefmt to v4l2_pix_format
>> + * @mbus: v4l2_mbus_framefmt format (input)
>> + * @pix: v4l2_pix_format format (output)
>> + *
>> + * Fill the output pix structure with information from the input mbus
>> format.
>> + *
>> + * Return 0 on success or a negative error code otherwise
>> + */
>> +static unsigned int video_mbus_to_pix(const struct v4l2_mbus_framefmt
>> *mbus,
>> +				      struct v4l2_pix_format *pix)
>> +{
>> +	unsigned int i;
>> +
>> +	memset(pix, 0, sizeof(*pix));
>> +	pix->width = mbus->width;
>> +	pix->height = mbus->height;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(formats); ++i) {
>> +		if (formats[i].code == mbus->code)
>> +			break;
>> +	}
>> +
>> +	if (WARN_ON(i == ARRAY_SIZE(formats)))
>> +		return -EINVAL;
>> +
>> +	pix->pixelformat = formats[i].pixelformat;
>> +	pix->bytesperline = pix->width * formats[i].bpp / 8;
>> +	pix->bytesperline = ALIGN(pix->bytesperline, 8);
> 
> Does the hardware support padding at the end of lines ? If so it would be 
> useful to use the maximum of the computed and requested by userspace values 
> (up to the maximum size of the padding supported by the hardware).
> 
>> +	pix->sizeimage = pix->bytesperline * pix->height;
> 
> Similarly, should we support padding at the end of the image ?

Yes, the hardware supports horizontal and vertical padding. More advanced
configuration is needed for this however. I'd prefer to keep the driver
simple for now. Features like this I can add later.

> 
>> +	pix->colorspace = mbus->colorspace;
>> +	pix->field = mbus->field;
>> +
>> +	return 0;
>> +}
>> +
>> +static struct v4l2_subdev *video_remote_subdev(struct camss_video *video,
>> +					       u32 *pad)
>> +{
>> +	struct media_pad *remote;
>> +
>> +	remote = media_entity_remote_pad(&video->pad);
>> +
>> +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
>> +		return NULL;
>> +
>> +	if (pad)
>> +		*pad = remote->index;
>> +
>> +	return media_entity_to_v4l2_subdev(remote->entity);
>> +}
>> +
>> +static int video_get_subdev_format(struct camss_video *video,
>> +				   struct v4l2_format *format)
>> +{
>> +	struct v4l2_subdev_format fmt;
>> +	struct v4l2_subdev *subdev;
>> +	u32 pad;
>> +	int ret;
>> +
>> +	subdev = video_remote_subdev(video, &pad);
>> +	if (subdev == NULL)
>> +		return -EINVAL;
>> +
>> +	fmt.pad = pad;
>> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
>> +
>> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
>> +	if (ret)
>> +		return ret;
>> +
>> +	format->type = video->type;
>> +	return video_mbus_to_pix(&fmt.format, &format->fmt.pix);
>> +}
>> +
>> +/* ------------------------------------------------------------------------
>> + * Video queue operations
>> + */
>> +
>> +static int video_queue_setup(struct vb2_queue *q,
>> +	unsigned int *num_buffers, unsigned int *num_planes,
>> +	unsigned int sizes[], struct device *alloc_devs[])
>> +{
>> +	struct camss_video *video = vb2_get_drv_priv(q);
>> +
>> +	if (*num_planes) {
>> +		if (*num_planes != 1)
>> +			return -EINVAL;
>> +
>> +		if (sizes[0] < video->active_fmt.fmt.pix.sizeimage)
>> +			return -EINVAL;
>> +
>> +		return 0;
>> +	}
>> +
>> +	*num_planes = 1;
>> +
>> +	sizes[0] = video->active_fmt.fmt.pix.sizeimage;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct camss_video *video = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct camss_buffer *buffer = container_of(vbuf, struct camss_buffer,
>> +						   vb);
> 
> You can define a static inline function to wrap this container_of() as it's 
> used in multiple places in this file.

I can see it on two places only so it might be too early for an inline function.
If more occurrences are added I'll add a function.

> 
>> +
>> +	vb2_set_plane_payload(vb, 0, video->active_fmt.fmt.pix.sizeimage);
>> +	if (vb2_get_plane_payload(vb, 0) > vb2_plane_size(vb, 0))
> 
> Wouldn't it be more efficient to compare video->active_fmt.fmt.pix.sizeimage 
> instead of vb2_get_plane_payload(vb, 0) ? The two should be identical as 
> you've just called vb2_set_plane_payload(). I would also move the 
> vb2_set_plane_payload() call after the error check.

Yes, I'll do these.

> 
>> +		return -EINVAL;
>> +
>> +	vbuf->field = V4L2_FIELD_NONE;
>> +
>> +	buffer->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
>> +
>> +	return 0;
>> +}
>> +
>> +static void video_buf_queue(struct vb2_buffer *vb)
>> +{
>> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>> +	struct camss_video *video = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct camss_buffer *buffer = container_of(vbuf, struct camss_buffer,
>> +						   vb);
>> +
>> +	camss_video_call(video, queue_buffer, buffer);
> 
> Should I assume that this abstraction means you'll add support for more than 
> the RDI in the future ? ;-)

There might be more but it is not connected with this abstraction :)

> 
> I'd remove the camss_video_call() macro and use
> 
> 	video->ops->queue_buffer(video, buffer);
> 
> directly as it's easier to follow, and we don't need to test video->ops && 
> video->ops->op as all operations should always be provided.

Ok.

> 
>> +}
>> +
>> +
> 
> A single blank line is enough.

Yes.

> 
>> +static int video_check_format(struct camss_video *video)
>> +{
>> +	struct v4l2_pix_format *pix = &video->active_fmt.fmt.pix;
>> +	struct v4l2_format format;
>> +	int ret;
>> +
>> +	ret = video_get_subdev_format(video, &format);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	if (pix->pixelformat != format.fmt.pix.pixelformat ||
>> +	    pix->height != format.fmt.pix.height ||
>> +	    pix->width != format.fmt.pix.width ||
>> +	    pix->bytesperline != format.fmt.pix.bytesperline ||
>> +	    pix->sizeimage != format.fmt.pix.sizeimage ||
>> +	    pix->field != format.fmt.pix.field)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +	struct camss_video *video = vb2_get_drv_priv(q);
>> +	struct video_device *vdev = video->vdev;
>> +	struct media_entity *entity;
>> +	struct media_pad *pad;
>> +	struct v4l2_subdev *subdev;
>> +	int ret;
>> +
>> +	ret = media_entity_pipeline_start(&vdev->entity, &video->pipe);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = video_check_format(video);
>> +	if (ret < 0)
>> +		goto error;
>> +
>> +	entity = &vdev->entity;
>> +	while (1) {
>> +		pad = &entity->pads[0];
>> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
>> +			break;
>> +
>> +		pad = media_entity_remote_pad(pad);
>> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
>> +			break;
>> +
>> +		entity = pad->entity;
>> +		subdev = media_entity_to_v4l2_subdev(entity);
>> +
>> +		ret = v4l2_subdev_call(subdev, video, s_stream, 1);
>> +		if (ret < 0 && ret != -ENOIOCTLCMD)
>> +			goto error;
>> +	}
>> +
>> +	return 0;
>> +
>> +error:
>> +	media_entity_pipeline_stop(&vdev->entity);
>> +
>> +	return ret;
>> +}
>> +
>> +static void video_stop_streaming(struct vb2_queue *q)
>> +{
>> +	struct camss_video *video = vb2_get_drv_priv(q);
>> +	struct video_device *vdev = video->vdev;
>> +	struct media_entity *entity;
>> +	struct media_pad *pad;
>> +	struct v4l2_subdev *subdev;
>> +	struct v4l2_subdev *subdev_vfe;
>> +
>> +	entity = &vdev->entity;
>> +	while (1) {
>> +		pad = &entity->pads[0];
>> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
>> +			break;
>> +
>> +		pad = media_entity_remote_pad(pad);
>> +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
>> +			break;
>> +
>> +		entity = pad->entity;
>> +		subdev = media_entity_to_v4l2_subdev(entity);
>> +
>> +		if (strstr(subdev->name, "vfe")) {
>> +			subdev_vfe = subdev;
>> +		} else if (strstr(subdev->name, "ispif")) {
>> +			v4l2_subdev_call(subdev, video, s_stream, 0);
>> +			v4l2_subdev_call(subdev_vfe, video, s_stream, 0);
>> +		} else {
>> +			v4l2_subdev_call(subdev, video, s_stream, 0);
>> +		}
>> +	}
>> +
>> +	media_entity_pipeline_stop(&vdev->entity);
>> +
>> +	camss_video_call(video, flush_buffers);
>> +}
>> +
>> +static struct vb2_ops msm_video_vb2_q_ops = {
> 
> You can make this static const.

Ok.

> 
>> +	.queue_setup     = video_queue_setup,
>> +	.buf_prepare     = video_buf_prepare,
>> +	.buf_queue       = video_buf_queue,
>> +	.start_streaming = video_start_streaming,
>> +	.stop_streaming  = video_stop_streaming,
>> +};
>> +
>> +/* ------------------------------------------------------------------------
>> + * V4L2 ioctls
>> + */
>> +
>> +static int video_querycap(struct file *file, void *fh,
>> +			  struct v4l2_capability *cap)
>> +{
>> +	strlcpy(cap->driver, "qcom-camss", sizeof(cap->driver));
>> +	strlcpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
>> +	strlcpy(cap->bus_info, "platform:qcom-camss", sizeof(cap->bus_info));
> 
> 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> 		 dev_name(...));
> 
> would be better.

Ok.

> 
>> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
>> +							V4L2_CAP_DEVICE_CAPS;
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_enum_fmt(struct file *file, void *fh, struct v4l2_fmtdesc
>> *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct v4l2_format format;
>> +	int ret;
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	if (f->index)
>> +		return -EINVAL;
>> +
>> +	ret = video_get_subdev_format(video, &format);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	f->pixelformat = format.fmt.pix.pixelformat;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	*f = video->active_fmt;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_s_fmt(struct file *file, void *fh, struct v4l2_format *f)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +	int ret;
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	ret = video_get_subdev_format(video, f);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	video->active_fmt = *f;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_try_fmt(struct file *file, void *fh, struct v4l2_format
>> *f) +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	if (f->type != video->type)
>> +		return -EINVAL;
>> +
>> +	return video_get_subdev_format(video, f);
>> +}
>> +
>> +static int video_enum_input(struct file *file, void *fh,
>> +			    struct v4l2_input *input)
>> +{
>> +	if (input->index > 0)
>> +		return -EINVAL;
>> +
>> +	strlcpy(input->name, "camera", sizeof(input->name));
>> +	input->type = V4L2_INPUT_TYPE_CAMERA;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_g_input(struct file *file, void *fh, unsigned int *input)
>> +{
>> +	*input = 0;
>> +
>> +	return 0;
>> +}
>> +
>> +static int video_s_input(struct file *file, void *fh, unsigned int input)
>> +{
>> +	return input == 0 ? 0 : -EINVAL;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops msm_vid_ioctl_ops = {
>> +	.vidioc_querycap          = video_querycap,
>> +	.vidioc_enum_fmt_vid_cap  = video_enum_fmt,
>> +	.vidioc_g_fmt_vid_cap     = video_g_fmt,
>> +	.vidioc_s_fmt_vid_cap     = video_s_fmt,
>> +	.vidioc_try_fmt_vid_cap   = video_try_fmt,
>> +	.vidioc_reqbufs           = vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf          = vb2_ioctl_querybuf,
>> +	.vidioc_qbuf              = vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf             = vb2_ioctl_dqbuf,
>> +	.vidioc_create_bufs       = vb2_ioctl_create_bufs,
>> +	.vidioc_streamon          = vb2_ioctl_streamon,
>> +	.vidioc_streamoff         = vb2_ioctl_streamoff,
>> +	.vidioc_enum_input        = video_enum_input,
>> +	.vidioc_g_input           = video_g_input,
>> +	.vidioc_s_input           = video_s_input,
>> +};
>> +
>> +/* ------------------------------------------------------------------------
>> + * V4L2 file operations
>> + */
>> +
>> +/*
>> + * video_init_format - Helper function to initialize format
>> + *
>> + * Initialize all pad formats with default values.
>> + */
>> +static int video_init_format(struct file *file, void *fh)
>> +{
>> +	struct v4l2_format format;
>> +
>> +	memset(&format, 0, sizeof(format));
>> +	format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +
>> +	return video_s_fmt(file, fh, &format);
> 
> This will set the active format every time you open the device node, I don't 
> think that's what you want.

Well, actually this is what I wanted. I wanted to keep in sync the pixel format
on the video node and the media bus format on the subdev node (i.e. the pixel
format will be always correct for the current media bus format). For the current
version there is a direct correspondence between the pixel format and the media
format so this will work I think. For the future there might be multiple pixel
formats for one media bus format and a second open of the video node could reset
the pixel format to unwanted value so this will need a change. I'm wondering about
(and still not able to find) a good moment/event when to perform the initialization
of the format on the video node. As it gets the current format from the subdev
node, the moment of the registration will be too early as the media link is still
not created. But after that I couldn't find a suitable callback/event where to do
it. If you can share any idea about this, please do :)

> 
>> +}
>> +
>> +static int video_open(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct camss_video_fh *handle;
>> +	int ret;
>> +
>> +	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
>> +	if (handle == NULL)
>> +		return -ENOMEM;
>> +
>> +	v4l2_fh_init(&handle->vfh, video->vdev);
>> +	v4l2_fh_add(&handle->vfh);
>> +
>> +	handle->video = video;
>> +	file->private_data = &handle->vfh;
>> +
>> +	ret = v4l2_pipeline_pm_use(&vdev->entity, 1);
>> +	if (ret < 0) {
>> +		dev_err(video->camss->dev, "Failed to power up pipeline\n");
>> +		goto error_pm_use;
>> +	}
>> +
>> +	ret = video_init_format(file, &handle->vfh);
>> +	if (ret < 0) {
>> +		dev_err(video->camss->dev, "Failed to init format\n");
>> +		goto error_init_format;
>> +	}
>> +
>> +	return 0;
>> +
>> +error_init_format:
>> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
>> +
>> +error_pm_use:
>> +	v4l2_fh_del(&handle->vfh);
>> +	kfree(handle);
>> +
>> +	return ret;
>> +}
>> +
>> +static int video_release(struct file *file)
>> +{
>> +	struct video_device *vdev = video_devdata(file);
>> +	struct camss_video *video = video_drvdata(file);
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct camss_video_fh *handle = container_of(vfh, struct 
> camss_video_fh,
>> +						     vfh);
>> +
>> +	vb2_ioctl_streamoff(file, vfh, video->type);
>> +
>> +	v4l2_pipeline_pm_use(&vdev->entity, 0);
>> +
>> +	v4l2_fh_del(vfh);
>> +	kfree(handle);
>> +	file->private_data = NULL;
>> +
>> +	return 0;
>> +}
>> +
>> +static unsigned int video_poll(struct file *file,
>> +				   struct poll_table_struct *wait)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	return vb2_poll(&video->vb2_q, file, wait);
>> +}
>> +
>> +static int video_mmap(struct file *file, struct vm_area_struct *vma)
>> +{
>> +	struct camss_video *video = video_drvdata(file);
>> +
>> +	return vb2_mmap(&video->vb2_q, vma);
>> +}
>> +
>> +static const struct v4l2_file_operations msm_vid_fops = {
>> +	.owner          = THIS_MODULE,
>> +	.unlocked_ioctl = video_ioctl2,
>> +	.open           = video_open,
>> +	.release        = video_release,
>> +	.poll           = video_poll,
>> +	.mmap		= video_mmap,
>> +};
>> +
>> +/* ------------------------------------------------------------------------
>> + * CAMSS video core
>> + */
>> +
>> +int msm_video_register(struct camss_video *video, struct v4l2_device
>> *v4l2_dev,
>> +		       const char *name)
>> +{
>> +	struct media_pad *pad = &video->pad;
>> +	struct video_device *vdev;
>> +	struct vb2_queue *q;
>> +	int ret;
>> +
>> +	vdev = video_device_alloc();
>> +	if (vdev == NULL) {
>> +		dev_err(v4l2_dev->dev, "Failed to allocate video device\n");
>> +		return -ENOMEM;
>> +	}
>> +
>> +	video->vdev = vdev;
>> +
>> +	q = &video->vb2_q;
>> +	q->drv_priv = video;
>> +	q->mem_ops = &vb2_dma_contig_memops;
>> +	q->ops = &msm_video_vb2_q_ops;
>> +	q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	q->io_modes = VB2_MMAP;
>> +	q->timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
>> +	q->buf_struct_size = sizeof(struct camss_buffer);
>> +	q->dev = video->camss->dev;
>> +	ret = vb2_queue_init(q);
>> +	if (ret < 0) {
>> +		dev_err(v4l2_dev->dev, "Failed to init vb2 queue\n");
>> +		return ret;
>> +	}
>> +
>> +	pad->flags = MEDIA_PAD_FL_SINK;
>> +	ret = media_entity_pads_init(&vdev->entity, 1, pad);
>> +	if (ret < 0) {
>> +		dev_err(v4l2_dev->dev, "Failed to init video entity\n");
>> +		goto error_media_init;
>> +	}
>> +
>> +	vdev->fops = &msm_vid_fops;
>> +	vdev->ioctl_ops = &msm_vid_ioctl_ops;
>> +	vdev->release = video_device_release;
> 
> This will result in a race condition between device unbind and userspace 
> access to the video node. You should instead refcount the top-level camss data 
> structure, and provide a custom release function here that decrements the 
> refcount. If you do that you can embed your struct video_device in struct 
> camss_video instead of allocating it dynamically. The media_entity_cleanup() 
> call will have to move from msm_video_unregister() to the release operation 
> for your top-level structure.
> 
> To test this race condition, perform the following steps:
> 
> - Configure the pipeline
> - Open the video device node, configure it and start streaming
> - Unbind the device through the sysfs unbind attribute of the driver
> - Stop streaming
> 
> You'll likely get an oops with you current version.
> 
> There are unfortunately very few drivers implementing this correctly 
> (including drivers I wrote :-/). A good (even if slightly complex) example is 
> uvcvideo.

Yes, I have tested with these steps and I have an oops - the camss data struct
is freed on unbind and on stop streaming it is used again.

I have tried to implement it the way you suggested and also refering to the
uvcvideo driver. I'm reference-counting the camss structure and freeing it last
(in the example above - on stop streaming) - this is ok.

However I have to find a way to trigger vb2_ops->stop_streaming on unbind to
stop the hardware and return the vb2 buffers. For this I have added
if (vb2_is_streaming())
	vb2_queue_release()

triggered from platform_driver->remove()

This seems ok to me, what do you think? (Or you can review the code after
I send the new version if it will make more sense)

> 
>> +	vdev->v4l2_dev = v4l2_dev;
>> +	vdev->vfl_dir = VFL_DIR_RX;
>> +	vdev->queue = &video->vb2_q;
>> +	strlcpy(vdev->name, name, sizeof(vdev->name));
>> +
>> +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
>> +	if (ret < 0) {
>> +		dev_err(v4l2_dev->dev, "Failed to register video device\n");
>> +		goto error_video_register;
>> +	}
>> +
>> +	video_set_drvdata(vdev, video);
>> +
>> +	return 0;
>> +
>> +error_video_register:
>> +	media_entity_cleanup(&vdev->entity);
>> +error_media_init:
>> +	vb2_queue_release(&video->vb2_q);
>> +
>> +	return ret;
>> +}
>> +
>> +void msm_video_unregister(struct camss_video *video)
>> +{
>> +	video_unregister_device(video->vdev);
>> +	media_entity_cleanup(&video->vdev->entity);
>> +	vb2_queue_release(&video->vb2_q);
> 
> If you use vb2_fop_release() as Hans proposed you can remove the 
> vb2_queue_release() call here.

Ok.

> 
>> +}
>> diff --git a/drivers/media/platform/qcom/camss-8x16/video.h
>> b/drivers/media/platform/qcom/camss-8x16/video.h new file mode 100644
>> index 0000000..5ab5929d
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/camss-8x16/video.h
>> @@ -0,0 +1,67 @@
>> +/*
>> + * video.h
>> + *
>> + * Qualcomm MSM Camera Subsystem - V4L2 device node
>> + *
>> + * Copyright (c) 2013-2015, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2015-2016 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +#ifndef QC_MSM_CAMSS_VIDEO_H
>> +#define QC_MSM_CAMSS_VIDEO_H
>> +
>> +#include <linux/videodev2.h>
>> +#include <media/media-entity.h>
>> +#include <media/v4l2-dev.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-fh.h>
>> +#include <media/v4l2-mediabus.h>
>> +#include <media/videobuf2-v4l2.h>
>> +
>> +#define camss_video_call(f, op, args...)			\
>> +	(!(f) ? -ENODEV : (((f)->ops && (f)->ops->op) ? \
>> +			    (f)->ops->op((f), ##args) : -ENOIOCTLCMD))
>> +
>> +struct camss_buffer {
>> +	struct vb2_v4l2_buffer vb;
>> +	dma_addr_t addr;
>> +	struct list_head queue;
>> +};
>> +
>> +struct camss_video;
>> +
>> +struct camss_video_ops {
>> +	int (*queue_buffer)(struct camss_video *vid, struct camss_buffer 
> *buf);
>> +	int (*flush_buffers)(struct camss_video *vid);
>> +};
>> +
>> +struct camss_video {
>> +	struct camss *camss;
>> +	struct vb2_queue vb2_q;
>> +	struct video_device *vdev;
>> +	struct media_pad pad;
>> +	struct v4l2_format active_fmt;
>> +	enum v4l2_buf_type type;
>> +	struct media_pipeline pipe;
>> +	struct camss_video_ops *ops;
> 
> You can make this const.

Ok.

> 
>> +};
>> +
>> +struct camss_video_fh {
>> +	struct v4l2_fh vfh;
>> +	struct camss_video *video;
>> +};
> 
> If there's nothing else to be stored here you don't need a custom struct 
> camss_video_fh. You can use struct v4l2_fh and retrieve the camss_video 
> instance with a container_of on vfh->vdev (provided you embed the video_device 
> instance in struct camss_video as I proposed above).

Ok.

> 
>> +
>> +int msm_video_register(struct camss_video *video, struct v4l2_device
>> *v4l2_dev,
>> +		       const char *name);
>> +
>> +void msm_video_unregister(struct camss_video *video);
>> +
>> +#endif /* QC_MSM_CAMSS_VIDEO_H */
> 

-- 
Best regards,
Todor Tomov
