Return-path: <linux-media-owner@vger.kernel.org>
Received: from out20-3.mail.aliyun.com ([115.124.20.3]:45849 "EHLO
        out20-3.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbdGCLAM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Jul 2017 07:00:12 -0400
Date: Mon, 3 Jul 2017 18:59:52 +0800
From: Yong <yong.deng@magewell.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: mchehab@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, wens@csie.org,
        hans.verkuil@cisco.com, peter.griffin@linaro.org,
        hugues.fruchet@st.com, krzk@kernel.org, bparrot@ti.com,
        arnd@arndb.de, jean-christophe.trotin@st.com,
        benjamin.gaignard@linaro.org, tiffany.lin@mediatek.com,
        kamil@wypas.org, kieran+renesas@ksquared.org.uk,
        andrew-ct.chen@mediatek.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RFC 1/2] media: V3s: Add support for Allwinner CSI.
Message-Id: <20170703185952.18a97e9b7b05cbe321cb1268@magewell.com>
In-Reply-To: <667c858b-2655-88c5-6bbc-9d70d06c1ff1@xs4all.nl>
References: <1498561654-14658-1-git-send-email-yong.deng@magewell.com>
        <1498561654-14658-2-git-send-email-yong.deng@magewell.com>
        <667c858b-2655-88c5-6bbc-9d70d06c1ff1@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for your review.

On Mon, 3 Jul 2017 12:18:55 +0200
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Yong Deng,
> 
> Thanks for contributing this driver!
> 
> First a high-level comment: you need to rebase this to the latest media_tree
> master branch (https://git.linuxtv.org/media_tree.git/) since v4l2-of.h has
> been replaced by v4l2-fwnode.h. So this driver will not apply as-is.
>
 
OK.

> Also missing is a patch adding a new entry to the MAINTAINERS file.
> 
> I have some more comments below:
> 
> On 06/27/2017 01:07 PM, Yong Deng wrote:
> > Allwinner V3s SoC have two CSI module. CSI0 is used for MIPI interface
> > and CSI1 is used for parallel interface. This is not documented in
> > datatsheet but by testing and guess.
> 
> datatsheet -> datasheet

OK.

> 
> > 
> > This patch implement a v4l2 framework driver for it.
> > 
> > Currently, the driver only support the parallel interface. MIPI-CSI2,
> > ISP's support are not included in this patch.
> > 
> > Signed-off-by: Yong Deng <yong.deng@magewell.com>
> > ---
> >   drivers/media/platform/Kconfig                   |   1 +
> >   drivers/media/platform/Makefile                  |   2 +
> >   drivers/media/platform/sunxi-csi/Kconfig         |   8 +
> >   drivers/media/platform/sunxi-csi/Makefile        |   3 +
> >   drivers/media/platform/sunxi-csi/sunxi_csi.c     | 535 +++++++++++++++
> >   drivers/media/platform/sunxi-csi/sunxi_csi.h     | 203 ++++++
> >   drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c | 827 +++++++++++++++++++++++
> >   drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h | 206 ++++++
> >   drivers/media/platform/sunxi-csi/sunxi_video.c   | 667 ++++++++++++++++++
> >   drivers/media/platform/sunxi-csi/sunxi_video.h   |  61 ++
> >   10 files changed, 2513 insertions(+)
> >   create mode 100644 drivers/media/platform/sunxi-csi/Kconfig
> >   create mode 100644 drivers/media/platform/sunxi-csi/Makefile
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi.c
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi.h
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.c
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_csi_v3s.h
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_video.c
> >   create mode 100644 drivers/media/platform/sunxi-csi/sunxi_video.h
> 
> <snip>
> 
> > diff --git a/drivers/media/platform/sunxi-csi/Kconfig b/drivers/media/platform/sunxi-csi/Kconfig
> > new file mode 100644
> > index 0000000..f26592a
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi-csi/Kconfig
> > @@ -0,0 +1,8 @@
> > +config VIDEO_SUNXI_CSI
> > +	tristate "Allwinner Camera Sensor Interface driver"
> > +	depends on VIDEO_V4L2 && COMMON_CLK && VIDEO_V4L2_SUBDEV_API && HAS_DMA
> > +	depends on ARCH_SUNXI
> 
> If possible change this to:
> 
> 	depends on ARCH_SUNXI || COMPILE_TEST

OK.

> 
> to allow this driver to be compiled on e.g. Intel for compile testing.
> 
> > +	select VIDEOBUF2_DMA_CONTIG
> > +	select REGMAP_MMIO
> > +	---help---
> > +	   Support for the Allwinner Camera Sensor Interface Controller.
> 
> This controller is the same for all Allwinner SoC models?

No.
I will change the Kconfig and Makefile.

> 
> <snip>
> 
> > diff --git a/drivers/media/platform/sunxi-csi/sunxi_video.c b/drivers/media/platform/sunxi-csi/sunxi_video.c
> > new file mode 100644
> > index 0000000..57d7563
> > --- /dev/null
> > +++ b/drivers/media/platform/sunxi-csi/sunxi_video.c
> > @@ -0,0 +1,667 @@
> > +/*
> > + * Copyright (c) 2017 Magewell Electronics Co., Ltd. (Nanjing).
> > + * All rights reserved.
> > + * Author: Yong Deng <yong.deng@magewell.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2 as
> > + * published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/of.h>
> > +
> > +#include <media/v4l2-device.h>
> > +#include <media/v4l2-ioctl.h>
> > +#include <media/v4l2-mc.h>
> > +#include <media/videobuf2-dma-contig.h>
> > +#include <media/videobuf2-v4l2.h>
> > +
> > +#include "sunxi_csi.h"
> > +#include "sunxi_video.h"
> > +
> > +struct sunxi_csi_buffer {
> > +	struct vb2_v4l2_buffer		vb;
> > +	struct list_head		list;
> > +
> > +	dma_addr_t			dma_addr;
> > +};
> > +
> > +static struct sunxi_csi_format *
> > +find_format_by_fourcc(struct sunxi_video *video, unsigned int fourcc)
> > +{
> > +	unsigned int num_formats = video->num_formats;
> > +	struct sunxi_csi_format *fmt;
> > +	unsigned int i;
> > +
> > +	for (i = 0; i < num_formats; i++) {
> > +		fmt = &video->formats[i];
> > +		if (fmt->fourcc == fourcc)
> > +			return fmt;
> > +	}
> > +
> > +	return NULL;
> > +}
> > +
> > +static struct v4l2_subdev *
> > +sunxi_video_remote_subdev(struct sunxi_video *video, u32 *pad)
> > +{
> > +	struct media_pad *remote;
> > +
> > +	remote = media_entity_remote_pad(&video->pad);
> > +
> > +	if (!remote || !is_media_entity_v4l2_subdev(remote->entity))
> > +		return NULL;
> > +
> > +	if (pad)
> > +		*pad = remote->index;
> > +
> > +	return media_entity_to_v4l2_subdev(remote->entity);
> > +}
> > +
> > +static int sunxi_video_queue_setup(struct vb2_queue *vq,
> > +				 unsigned int *nbuffers, unsigned int *nplanes,
> > +				 unsigned int sizes[],
> > +				 struct device *alloc_devs[])
> > +{
> > +	struct sunxi_video *video = vb2_get_drv_priv(vq);
> > +	unsigned int size = video->fmt.fmt.pix.sizeimage;
> > +
> > +	if (*nplanes)
> > +		return sizes[0] < size ? -EINVAL : 0;
> > +
> > +	*nplanes = 1;
> > +	sizes[0] = size;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_video_buffer_prepare(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> > +	struct sunxi_csi_buffer *buf =
> > +			container_of(vbuf, struct sunxi_csi_buffer, vb);
> > +	struct sunxi_video *video = vb2_get_drv_priv(vb->vb2_queue);
> > +	unsigned long size = video->fmt.fmt.pix.sizeimage;
> > +
> > +	if (vb2_plane_size(vb, 0) < size) {
> > +		v4l2_err(video->vdev.v4l2_dev, "buffer too small (%lu < %lu)\n",
> > +			 vb2_plane_size(vb, 0), size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	vb2_set_plane_payload(vb, 0, size);
> > +
> > +	buf->dma_addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> > +
> > +	vbuf->field = video->fmt.fmt.pix.field;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_pipeline_set_stream(struct sunxi_video *video, bool enable)
> > +{
> > +	struct media_entity *entity;
> > +	struct media_pad *pad;
> > +	struct v4l2_subdev *subdev;
> > +	int ret;
> > +
> > +	entity = &video->vdev.entity;
> > +	while (1) {
> > +		pad = &entity->pads[0];
> > +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> > +			break;
> > +
> > +		pad = media_entity_remote_pad(pad);
> > +		if (!pad || !is_media_entity_v4l2_subdev(pad->entity))
> > +			break;
> > +
> > +		entity = pad->entity;
> > +		subdev = media_entity_to_v4l2_subdev(entity);
> > +
> > +		ret = v4l2_subdev_call(subdev, video, s_stream, enable);
> > +		if (enable && ret < 0 && ret != -ENOIOCTLCMD)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_video_start_streaming(struct vb2_queue *vq, unsigned int count)
> > +{
> > +	struct sunxi_video *video = vb2_get_drv_priv(vq);
> > +	struct sunxi_csi_buffer *buf;
> > +	struct sunxi_csi_config config;
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	video->sequence = 0;
> > +
> > +	ret = media_pipeline_start(&video->vdev.entity, &video->vdev.pipe);
> > +	if (ret < 0)
> > +		goto err_start_pipeline;
> > +
> > +	ret = sunxi_pipeline_set_stream(video, true);
> > +	if (ret < 0)
> > +		goto err_start_stream;
> > +
> > +	config.pixelformat = video->fmt.fmt.pix.pixelformat;
> > +	config.code = video->current_fmt->mbus_code;
> > +	config.field = video->fmt.fmt.pix.field;
> > +	config.width = video->fmt.fmt.pix.width;
> > +	config.height = video->fmt.fmt.pix.height;
> > +
> > +	ret = sunxi_csi_update_config(video->csi, &config);
> > +	if (ret < 0)
> > +		goto err_update_config;
> > +
> > +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> > +	video->cur_frm = list_first_entry(&video->dma_queue,
> > +					  struct sunxi_csi_buffer, list);
> > +	list_del(&video->cur_frm->list);
> > +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> > +
> > +	ret = sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
> > +	if (ret < 0)
> > +		goto err_update_addr;
> > +
> > +	ret = sunxi_csi_set_stream(video->csi, true);
> > +	if (ret < 0)
> > +		goto err_csi_stream;
> > +
> > +	return 0;
> > +
> > +err_csi_stream:
> > +err_update_addr:
> > +err_update_config:
> > +	sunxi_pipeline_set_stream(video, false);
> > +err_start_stream:
> > +	media_pipeline_stop(&video->vdev.entity);
> > +err_start_pipeline:
> > +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> > +	list_for_each_entry(buf, &video->dma_queue, list)
> > +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_QUEUED);
> > +	INIT_LIST_HEAD(&video->dma_queue);
> > +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> > +
> > +	return ret;
> > +}
> > +
> > +static void sunxi_video_stop_streaming(struct vb2_queue *vq)
> > +{
> > +	struct sunxi_video *video = vb2_get_drv_priv(vq);
> > +	unsigned long flags;
> > +	struct sunxi_csi_buffer *buf;
> > +
> > +	sunxi_pipeline_set_stream(video, false);
> > +
> > +	sunxi_csi_set_stream(video->csi, false);
> > +
> > +	media_pipeline_stop(&video->vdev.entity);
> > +
> > +	/* Release all active buffers */
> > +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> > +	if (unlikely(video->cur_frm)) {
> > +		vb2_buffer_done(&video->cur_frm->vb.vb2_buf,
> > +				VB2_BUF_STATE_ERROR);
> > +		video->cur_frm = NULL;
> > +	}
> > +	list_for_each_entry(buf, &video->dma_queue, list)
> > +		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
> > +	INIT_LIST_HEAD(&video->dma_queue);
> > +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> > +}
> > +
> > +static void sunxi_video_buffer_queue(struct vb2_buffer *vb)
> > +{
> > +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> > +	struct sunxi_csi_buffer *buf =
> > +			container_of(vbuf, struct sunxi_csi_buffer, vb);
> > +	struct sunxi_video *video = vb2_get_drv_priv(vb->vb2_queue);
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&video->dma_queue_lock, flags);
> > +	if (!video->cur_frm && list_empty(&video->dma_queue) &&
> > +		vb2_is_streaming(vb->vb2_queue)) {
> > +		video->cur_frm = buf;
> > +		sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
> > +		sunxi_csi_set_stream(video->csi, 1);
> > +	} else
> > +		list_add_tail(&buf->list, &video->dma_queue);
> > +	spin_unlock_irqrestore(&video->dma_queue_lock, flags);
> > +}
> > +
> > +void sunxi_video_frame_done(struct sunxi_video *video)
> > +{
> > +	spin_lock(&video->dma_queue_lock);
> > +
> > +	if (video->cur_frm) {
> > +		struct vb2_v4l2_buffer *vbuf = &video->cur_frm->vb;
> > +		struct vb2_buffer *vb = &vbuf->vb2_buf;
> > +
> > +		vb->timestamp = ktime_get_ns();
> > +		vbuf->sequence = video->sequence++;
> > +		vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
> > +		video->cur_frm = NULL;
> > +	}
> > +
> > +	if (!list_empty(&video->dma_queue)
> > +	    && vb2_is_streaming(&video->vb2_vidq)) {
> > +		video->cur_frm = list_first_entry(&video->dma_queue,
> > +				struct sunxi_csi_buffer, list);
> > +		list_del(&video->cur_frm->list);
> > +		sunxi_csi_update_buf_addr(video->csi, video->cur_frm->dma_addr);
> > +	} else
> > +		sunxi_csi_set_stream(video->csi, 0);
> > +
> > +	spin_unlock(&video->dma_queue_lock);
> > +}
> > +
> > +static struct vb2_ops sunxi_csi_vb2_ops = {
> > +	.queue_setup		= sunxi_video_queue_setup,
> > +	.wait_prepare		= vb2_ops_wait_prepare,
> > +	.wait_finish		= vb2_ops_wait_finish,
> > +	.buf_prepare		= sunxi_video_buffer_prepare,
> > +	.start_streaming	= sunxi_video_start_streaming,
> > +	.stop_streaming		= sunxi_video_stop_streaming,
> > +	.buf_queue		= sunxi_video_buffer_queue,
> > +};
> > +
> > +static int vidioc_querycap(struct file *file, void *priv,
> > +				struct v4l2_capability *cap)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +
> > +	strlcpy(cap->driver, "sunxi-video", sizeof(cap->driver));
> > +	strlcpy(cap->card, video->vdev.name, sizeof(cap->card));
> > +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
> > +		 video->csi->dev->of_node->name);
> > +
> > +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> > +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> 
> Drop these two lines. You already set device_caps in the video_device struct,
> and the V4L2 core will fill in these two v4l2_capability fields based on that.

OK.

> 
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
> > +				   struct v4l2_fmtdesc *f)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +	u32 index = f->index;
> > +
> > +	if (index >= video->num_formats)
> > +		return -EINVAL;
> > +
> > +	f->pixelformat = video->formats[index].fourcc;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *fmt)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +
> > +	*fmt = video->fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_video_try_fmt(struct sunxi_video *video, struct v4l2_format *f,
> > +			       struct sunxi_csi_format **current_fmt)
> > +{
> > +	struct sunxi_csi_format *csi_fmt;
> > +	struct v4l2_pix_format *pixfmt = &f->fmt.pix;
> > +	struct v4l2_subdev_format format;
> > +	struct v4l2_subdev *subdev;
> > +	u32 pad;
> > +	int ret;
> > +
> > +	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> > +		return -EINVAL;
> 
> Drop this test. It's not needed.

OK.

> 
> > +
> > +	subdev = sunxi_video_remote_subdev(video, &pad);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	csi_fmt = find_format_by_fourcc(video, pixfmt->pixelformat);
> > +	if (csi_fmt == NULL)
> > +		return -EINVAL;
> > +
> > +	format.pad = pad;
> > +	format.which = V4L2_SUBDEV_FORMAT_TRY;
> > +	v4l2_fill_mbus_format(&format.format, pixfmt, csi_fmt->mbus_code);
> > +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &format);
> > +	if (ret)
> > +		return ret == -ENOIOCTLCMD ? -ENOTTY : ret;
> 
> Just do 'return ret'.

OK.

> 
> > +
> > +	v4l2_fill_pix_format(pixfmt, &format.format);
> > +
> > +	pixfmt->bytesperline = (pixfmt->width * csi_fmt->bpp) >> 3;
> > +	pixfmt->sizeimage = (pixfmt->width * csi_fmt->bpp * pixfmt->height) / 8;
> > +
> > +	if (current_fmt)
> > +		*current_fmt = csi_fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_video_set_fmt(struct sunxi_video *video, struct v4l2_format *f)
> > +{
> > +	struct v4l2_subdev_format format;
> > +	struct sunxi_csi_format *current_fmt;
> > +	struct v4l2_subdev *subdev;
> > +	u32 pad;
> > +	int ret;
> > +
> > +	subdev = sunxi_video_remote_subdev(video, &pad);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	ret = sunxi_video_try_fmt(video, f, &current_fmt);
> > +	if (ret)
> > +		return ret;
> > +
> > +	format.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	v4l2_fill_mbus_format(&format.format, &f->fmt.pix,
> > +			      current_fmt->mbus_code);
> > +	ret = v4l2_subdev_call(subdev, pad, set_fmt, NULL, &format);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	video->fmt = *f;
> > +	video->current_fmt = current_fmt;
> > +
> > +	return 0;
> > +}
> > +
> > +static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
> > +				struct v4l2_format *f)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +
> > +	if (vb2_is_streaming(&video->vb2_vidq))
> > +		return -EBUSY;
> > +
> > +	return sunxi_video_set_fmt(video, f);
> > +}
> > +
> > +static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
> > +				  struct v4l2_format *f)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +
> > +	return sunxi_video_try_fmt(video, f, NULL);
> > +}
> > +
> > +static const struct v4l2_ioctl_ops sunxi_video_ioctl_ops = {
> > +	.vidioc_querycap		= vidioc_querycap,
> > +	.vidioc_enum_fmt_vid_cap	= vidioc_enum_fmt_vid_cap,
> > +	.vidioc_g_fmt_vid_cap		= vidioc_g_fmt_vid_cap,
> > +	.vidioc_s_fmt_vid_cap		= vidioc_s_fmt_vid_cap,
> > +	.vidioc_try_fmt_vid_cap		= vidioc_try_fmt_vid_cap,
> > +
> > +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> > +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> > +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> > +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> > +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> > +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> > +	.vidioc_prepare_buf		= vb2_ioctl_prepare_buf,
> > +	.vidioc_streamon		= vb2_ioctl_streamon,
> > +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> > +};
> > +
> > +/* -----------------------------------------------------------------------------
> > + * V4L2 file operations
> > + */
> > +static int sunxi_video_open(struct file *file)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +	struct v4l2_format format;
> > +	int ret;
> > +
> > +	if (mutex_lock_interruptible(&video->lock))
> > +		return -ERESTARTSYS;
> > +
> > +	ret = v4l2_fh_open(file);
> > +	if (ret < 0)
> > +		goto unlock;
> > +
> > +	ret = v4l2_pipeline_pm_use(&video->vdev.entity, 1);
> > +	if (ret < 0)
> > +		goto fh_release;
> > +
> > +	if (!v4l2_fh_is_singular_file(file))
> > +		goto unlock;
> > +
> > +	ret = sunxi_csi_set_power(video->csi, true);
> > +	if (ret < 0)
> > +		goto fh_release;
> > +
> > +	/* setup default format */
> > +	if (video->num_formats > 0) {
> > +		format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +		format.fmt.pix.width = 1280;
> > +		format.fmt.pix.height = 720;
> > +		format.fmt.pix.pixelformat = video->formats[0].fourcc;
> > +		sunxi_video_set_fmt(video, &format);
> > +	}
> > +
> > +	mutex_unlock(&video->lock);
> > +	return 0;
> > +
> > +fh_release:
> > +	v4l2_fh_release(file);
> > +unlock:
> > +	mutex_unlock(&video->lock);
> > +	return ret;
> > +}
> > +
> > +static int sunxi_video_close(struct file *file)
> > +{
> > +	struct sunxi_video *video = video_drvdata(file);
> > +
> > +	mutex_lock(&video->lock);
> > +
> > +	_vb2_fop_release(file, NULL);
> > +
> > +	v4l2_pipeline_pm_use(&video->vdev.entity, 0);
> > +
> > +	if (v4l2_fh_is_singular_file(file))
> 
> This is the wrong order. You need to check this before _vb2_fop_release is called.
> 
> E.g.:
> 
> 	bool last_fh = v4l2_fh_is_singular_file(file);
> 
> 	_vb2_fop_release(file, NULL);
> 	...
> 	if (last_fh)
> 		sunxi_csi_set_power(video->csi, false);

OK.

> 
> > +		sunxi_csi_set_power(video->csi, false);
> > +
> > +	mutex_unlock(&video->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +static const struct v4l2_file_operations sunxi_video_fops = {
> > +	.owner		= THIS_MODULE,
> > +	.open		= sunxi_video_open,
> > +	.release	= sunxi_video_close,
> > +	.unlocked_ioctl	= video_ioctl2,
> > +	.read		= vb2_fop_read,
> 
> You haven't signalled read() support in the capabilities or in the vb2 io_modes, so
> either drop this from the video_fops, or add it to the device_caps and io_modes fields.

OK.

> 
> > +	.mmap		= vb2_fop_mmap,
> > +	.poll		= vb2_fop_poll
> > +};
> > +
> > +/* -----------------------------------------------------------------------------
> > + * Media Operations
> > + */
> > +static int sunxi_video_formats_init(struct sunxi_video *video)
> > +{
> > +	struct v4l2_subdev_mbus_code_enum mbus_code = { 0 };
> > +	struct sunxi_csi *csi = video->csi;
> > +	struct v4l2_subdev *subdev;
> > +	u32 pad;
> > +	const u32 *pixformats;
> > +	int pixformat_count = 0;
> > +	u32 subdev_codes[32]; /* subdev format codes, 32 should be enough */
> > +	int codes_count = 0;
> > +	int num_fmts = 0;
> > +	int i, j;
> > +
> > +	subdev = sunxi_video_remote_subdev(video, &pad);
> > +	if (subdev == NULL)
> > +		return -ENXIO;
> > +
> > +	/* Get supported pixformats of CSI */
> > +	pixformat_count = sunxi_csi_get_supported_pixformats(csi, &pixformats);
> > +	if (pixformat_count <= 0)
> > +		return -ENXIO;
> > +
> > +	/* Get subdev formats codes */
> > +	mbus_code.pad = pad;
> > +	mbus_code.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> > +	while (!v4l2_subdev_call(subdev, pad, enum_mbus_code, NULL,
> > +			&mbus_code)) {
> > +		subdev_codes[codes_count] = mbus_code.code;
> > +		codes_count++;
> > +		mbus_code.index++;
> > +	}
> > +
> > +	if (!codes_count)
> > +		return -ENXIO;
> > +
> > +	/* Get supported formats count */
> > +	for (i = 0; i < codes_count; i++) {
> > +		for (j = 0; j < pixformat_count; j++) {
> > +			if (!sunxi_csi_is_format_support(csi, pixformats[j],
> > +					mbus_code.code)) {
> > +				continue;
> > +			}
> > +			num_fmts++;
> > +		}
> > +	}
> > +
> > +	if (!num_fmts)
> > +		return -ENXIO;
> > +
> > +	video->num_formats = num_fmts;
> > +	video->formats = devm_kcalloc(video->csi->dev, num_fmts,
> > +			sizeof(struct sunxi_csi_format), GFP_KERNEL);
> > +	if (!video->formats) {
> > +		dev_err(video->csi->dev, "could not allocate memory\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Get supported formats */
> > +	num_fmts = 0;
> > +	for (i = 0; i < codes_count; i++) {
> > +		for (j = 0; j < pixformat_count; j++) {
> > +			if (!sunxi_csi_is_format_support(csi, pixformats[j],
> > +					mbus_code.code)) {
> > +				continue;
> > +			}
> > +
> > +			video->formats[num_fmts].fourcc = pixformats[j];
> > +			video->formats[num_fmts].mbus_code =
> > +					mbus_code.code;
> > +			video->formats[num_fmts].bpp =
> > +					v4l2_pixformat_get_bpp(pixformats[j]);
> > +			num_fmts++;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int sunxi_video_link_setup(struct media_entity *entity,
> > +				  const struct media_pad *local,
> > +				  const struct media_pad *remote, u32 flags)
> > +{
> > +	struct video_device *vdev = media_entity_to_video_device(entity);
> > +	struct sunxi_video *video = video_get_drvdata(vdev);
> > +
> > +	if (WARN_ON(video == NULL))
> > +		return 0;
> > +
> > +	return sunxi_video_formats_init(video);
> > +}
> > +
> > +static const struct media_entity_operations sunxi_video_media_ops = {
> > +	.link_setup = sunxi_video_link_setup,
> > +};
> > +
> > +int sunxi_video_init(struct sunxi_video *video, struct sunxi_csi *csi,
> > +		     const char *name)
> > +{
> > +	struct video_device *vdev = &video->vdev;
> > +	struct vb2_queue *vidq = &video->vb2_vidq;
> > +	int ret;
> > +
> > +	video->csi = csi;
> > +
> > +	/* Initialize the media entity... */
> > +	video->pad.flags = MEDIA_PAD_FL_SINK | MEDIA_PAD_FL_MUST_CONNECT;
> > +	vdev->entity.ops = &sunxi_video_media_ops;
> > +	ret = media_entity_pads_init(&vdev->entity, 1, &video->pad);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	mutex_init(&video->lock);
> > +
> > +	INIT_LIST_HEAD(&video->dma_queue);
> > +	spin_lock_init(&video->dma_queue_lock);
> > +
> > +	video->cur_frm = NULL;
> > +	video->sequence = 0;
> > +	video->num_formats = 0;
> > +
> > +	/* Initialize videobuf2 queue */
> > +	vidq->type			= V4L2_BUF_TYPE_VIDEO_CAPTURE;
> > +	vidq->io_modes			= VB2_MMAP | VB2_DMABUF;
> > +	vidq->drv_priv			= video;
> > +	vidq->buf_struct_size		= sizeof(struct sunxi_csi_buffer);
> > +	vidq->ops			= &sunxi_csi_vb2_ops;
> > +	vidq->mem_ops			= &vb2_dma_contig_memops;
> > +	vidq->timestamp_flags		= V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > +	vidq->lock			= &video->lock;
> > +	vidq->min_buffers_needed	= 1;
> > +	vidq->dev			= csi->dev;
> > +
> > +	ret = vb2_queue_init(vidq);
> > +	if (ret) {
> > +		v4l2_err(&csi->v4l2_dev, "vb2_queue_init failed: %d\n", ret);
> > +		goto error;
> > +	}
> > +
> > +	/* Register video device */
> > +	strlcpy(vdev->name, name, sizeof(vdev->name));
> > +	vdev->release		= video_device_release_empty;
> > +	vdev->fops		= &sunxi_video_fops;
> > +	vdev->ioctl_ops		= &sunxi_video_ioctl_ops;
> > +	vdev->vfl_type		= VFL_TYPE_GRABBER;
> > +	vdev->vfl_dir		= VFL_DIR_RX;
> > +	vdev->v4l2_dev		= &csi->v4l2_dev;
> > +	vdev->queue		= vidq;
> > +	vdev->lock		= &video->lock;
> > +	vdev->device_caps	= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE;
> > +	video_set_drvdata(vdev, video);
> > +
> > +	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
> > +	if (ret < 0) {
> > +		v4l2_err(&csi->v4l2_dev,
> > +			 "video_register_device failed: %d\n", ret);
> > +		goto error;
> > +	}
> > +
> > +	return 0;
> > +
> > +error:
> > +	sunxi_video_cleanup(video);
> > +	return ret;
> > +}
> > +
> > +void sunxi_video_cleanup(struct sunxi_video *video)
> > +{
> > +	if (video_is_registered(&video->vdev))
> > +		video_unregister_device(&video->vdev);
> > +
> > +	media_entity_cleanup(&video->vdev.entity);
> > +}
> 
> <snip>
> 
> Regards,
> 
> 	Hans

Yong
