Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:45485 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756262AbbCCL2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Mar 2015 06:28:51 -0500
Message-ID: <54F59AD8.6080903@xs4all.nl>
Date: Tue, 03 Mar 2015 12:28:24 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 6/8] v4l: xilinx: Add Xilinx Video IP core
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com> <1425260925-12064-7-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425260925-12064-7-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thanks for this patch. I do have a few comments, see below. Note that I am
OK with the new DT format description.

On 03/02/2015 02:48 AM, Laurent Pinchart wrote:
> Xilinx platforms have no hardwired video capture or video processing
> interface. Users create capture and memory to memory processing
> pipelines in the FPGA fabric to suit their particular needs, by
> instantiating video IP cores from a large library.
> 
> The Xilinx Video IP core is a framework that models a video pipeline
> described in the device tree and expose the pipeline to userspace
> through the media controller and V4L2 APIs.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radheys@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> 
> ---

<snip>

> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> new file mode 100644
> index 0000000..afed6c3
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -0,0 +1,753 @@
> +/*
> + * Xilinx Video DMA
> + *
> + * Copyright (C) 2013-2014 Ideas on Board
> + * Copyright (C) 2013-2014 Xilinx, Inc.
> + *
> + * Contacts: Hyun Kwon <hyun.kwon@xilinx.com>
> + *           Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/amba/xilinx_dma.h>
> +#include <linux/lcm.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include "xilinx-dma.h"
> +#include "xilinx-vip.h"
> +#include "xilinx-vipp.h"
> +
> +#define XVIP_DMA_DEF_FORMAT		V4L2_PIX_FMT_YUYV
> +#define XVIP_DMA_DEF_WIDTH		1920
> +#define XVIP_DMA_DEF_HEIGHT		1080
> +
> +/* Minimum and maximum widths are expressed in bytes */
> +#define XVIP_DMA_MIN_WIDTH		1U
> +#define XVIP_DMA_MAX_WIDTH		65535U
> +#define XVIP_DMA_MIN_HEIGHT		1U
> +#define XVIP_DMA_MAX_HEIGHT		8191U
> +
> +/* -----------------------------------------------------------------------------
> + * Helper functions
> + */
> +
> +static struct v4l2_subdev *
> +xvip_dma_remote_subdev(struct media_pad *local, u32 *pad)
> +{
> +	struct media_pad *remote;
> +
> +	remote = media_entity_remote_pad(local);
> +	if (remote == NULL ||
> +	    media_entity_type(remote->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +		return NULL;
> +
> +	if (pad)
> +		*pad = remote->index;
> +
> +	return media_entity_to_v4l2_subdev(remote->entity);
> +}
> +
> +static int xvip_dma_verify_format(struct xvip_dma *dma)
> +{
> +	struct v4l2_subdev_format fmt;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	subdev = xvip_dma_remote_subdev(&dma->pad, &fmt.pad);
> +	if (subdev == NULL)
> +		return -EPIPE;
> +
> +	fmt.which = V4L2_SUBDEV_FORMAT_ACTIVE;
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> +	if (ret < 0)
> +		return ret == -ENOIOCTLCMD ? -EINVAL : ret;
> +
> +	if (dma->fmtinfo->code != fmt.format.code ||
> +	    dma->format.height != fmt.format.height ||
> +	    dma->format.width != fmt.format.width ||
> +	    dma->format.colorspace != fmt.format.colorspace)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Pipeline Stream Management
> + */
> +
> +/**
> + * xvip_pipeline_start_stop - Start ot stop streaming on a pipeline
> + * @pipe: The pipeline
> + * @start: Start (when true) or stop (when false) the pipeline
> + *
> + * Walk the entities chain starting at the pipeline output video node and start
> + * or stop all of them.
> + *
> + * Return: 0 if successful, or the return value of the failed video::s_stream
> + * operation otherwise.
> + */
> +static int xvip_pipeline_start_stop(struct xvip_pipeline *pipe, bool start)
> +{
> +	struct xvip_dma *dma = pipe->output;
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret;
> +
> +	entity = &dma->video.entity;
> +	while (1) {
> +		pad = &entity->pads[0];
> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
> +			break;
> +
> +		pad = media_entity_remote_pad(pad);
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +
> +		ret = v4l2_subdev_call(subdev, video, s_stream, start);
> +		if (start && ret < 0 && ret != -ENOIOCTLCMD)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * xvip_pipeline_set_stream - Enable/disable streaming on a pipeline
> + * @pipe: The pipeline
> + * @on: Turn the stream on when true or off when false
> + *
> + * The pipeline is shared between all DMA engines connect at its input and
> + * output. While the stream state of DMA engines can be controlled
> + * independently, pipelines have a shared stream state that enable or disable
> + * all entities in the pipeline. For this reason the pipeline uses a streaming
> + * counter that tracks the number of DMA engines that have requested the stream
> + * to be enabled.
> + *
> + * When called with the @on argument set to true, this function will increment
> + * the pipeline streaming count. If the streaming count reaches the number of
> + * DMA engines in the pipeline it will enable all entities that belong to the
> + * pipeline.
> + *
> + * Similarly, when called with the @on argument set to false, this function will
> + * decrement the pipeline streaming count and disable all entities in the
> + * pipeline when the streaming count reaches zero.
> + *
> + * Return: 0 if successful, or the return value of the failed video::s_stream
> + * operation otherwise. Stopping the pipeline never fails. The pipeline state is
> + * not updated when the operation fails.
> + */
> +static int xvip_pipeline_set_stream(struct xvip_pipeline *pipe, bool on)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&pipe->lock);
> +
> +	if (on) {
> +		if (pipe->stream_count == pipe->num_dmas - 1) {
> +			ret = xvip_pipeline_start_stop(pipe, true);
> +			if (ret < 0)
> +				goto done;
> +		}
> +		pipe->stream_count++;
> +	} else {
> +		if (--pipe->stream_count == 0)
> +			xvip_pipeline_start_stop(pipe, false);
> +	}
> +
> +done:
> +	mutex_unlock(&pipe->lock);
> +	return ret;
> +}
> +
> +static int xvip_pipeline_validate(struct xvip_pipeline *pipe,
> +				  struct xvip_dma *start)
> +{
> +	struct media_entity_graph graph;
> +	struct media_entity *entity = &start->video.entity;
> +	struct media_device *mdev = entity->parent;
> +	unsigned int num_inputs = 0;
> +	unsigned int num_outputs = 0;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +
> +	/* Walk the graph to locate the video nodes. */
> +	media_entity_graph_walk_start(&graph, entity);
> +
> +	while ((entity = media_entity_graph_walk_next(&graph))) {
> +		struct xvip_dma *dma;
> +
> +		if (entity->type != MEDIA_ENT_T_DEVNODE_V4L)
> +			continue;
> +
> +		dma = to_xvip_dma(media_entity_to_video_device(entity));
> +
> +		if (dma->pad.flags & MEDIA_PAD_FL_SINK) {
> +			pipe->output = dma;
> +			num_outputs++;
> +		} else {
> +			num_inputs++;
> +		}
> +	}
> +
> +	mutex_unlock(&mdev->graph_mutex);
> +
> +	/* We need exactly one output and zero or one input. */
> +	if (num_outputs != 1 || num_inputs > 1)
> +		return -EPIPE;
> +
> +	pipe->num_dmas = num_inputs + num_outputs;
> +
> +	return 0;
> +}
> +
> +static void __xvip_pipeline_cleanup(struct xvip_pipeline *pipe)
> +{
> +	pipe->num_dmas = 0;
> +	pipe->output = NULL;
> +}
> +
> +/**
> + * xvip_pipeline_cleanup - Cleanup the pipeline after streaming
> + * @pipe: the pipeline
> + *
> + * Decrease the pipeline use count and clean it up if we were the last user.
> + */
> +static void xvip_pipeline_cleanup(struct xvip_pipeline *pipe)
> +{
> +	mutex_lock(&pipe->lock);
> +
> +	/* If we're the last user clean up the pipeline. */
> +	if (--pipe->use_count == 0)
> +		__xvip_pipeline_cleanup(pipe);
> +
> +	mutex_unlock(&pipe->lock);
> +}
> +
> +/**
> + * xvip_pipeline_prepare - Prepare the pipeline for streaming
> + * @pipe: the pipeline
> + * @dma: DMA engine at one end of the pipeline
> + *
> + * Validate the pipeline if no user exists yet, otherwise just increase the use
> + * count.
> + *
> + * Return: 0 if successful or -EPIPE if the pipeline is not valid.
> + */
> +static int xvip_pipeline_prepare(struct xvip_pipeline *pipe,
> +				 struct xvip_dma *dma)
> +{
> +	int ret;
> +
> +	mutex_lock(&pipe->lock);
> +
> +	/* If we're the first user validate and initialize the pipeline. */
> +	if (pipe->use_count == 0) {
> +		ret = xvip_pipeline_validate(pipe, dma);
> +		if (ret < 0) {
> +			__xvip_pipeline_cleanup(pipe);
> +			goto done;
> +		}
> +	}
> +
> +	pipe->use_count++;
> +	ret = 0;
> +
> +done:
> +	mutex_unlock(&pipe->lock);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 queue operations
> + */
> +
> +/**
> + * struct xvip_dma_buffer - Video DMA buffer
> + * @buf: vb2 buffer base object
> + * @queue: buffer list entry in the DMA engine queued buffers list
> + * @dma: DMA channel that uses the buffer
> + */
> +struct xvip_dma_buffer {
> +	struct vb2_buffer buf;
> +	struct list_head queue;
> +	struct xvip_dma *dma;
> +};
> +
> +#define to_xvip_dma_buffer(vb)	container_of(vb, struct xvip_dma_buffer, buf)
> +
> +static void xvip_dma_complete(void *param)
> +{
> +	struct xvip_dma_buffer *buf = param;
> +	struct xvip_dma *dma = buf->dma;
> +
> +	spin_lock(&dma->queued_lock);
> +	list_del(&buf->queue);
> +	spin_unlock(&dma->queued_lock);
> +
> +	buf->buf.v4l2_buf.sequence = dma->sequence++;

buf->buf.v4l2_buf.field isn't set. I think you only support progressive
formats at the moment, so this should be set to V4L2_FIELD_NONE.

> +	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
> +	vb2_set_plane_payload(&buf->buf, 0, dma->format.sizeimage);
> +	vb2_buffer_done(&buf->buf, VB2_BUF_STATE_DONE);
> +}
> +
> +static int
> +xvip_dma_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> +		     unsigned int *nbuffers, unsigned int *nplanes,
> +		     unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +
> +	*nplanes = 1;
> +
> +	sizes[0] = dma->format.sizeimage;

I would suggest that you add support for vb2_ioctl_create_bufs by changing this
code to:

	if (fmt && fmt->fmt.pix.sizeimage < dma->format.sizeimage)
                return -EINVAL;
	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : dma->format.sizeimage;

> +	alloc_ctxs[0] = dma->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static int xvip_dma_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
> +	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vb);
> +
> +	buf->dma = dma;
> +
> +	return 0;
> +}
> +
> +static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
> +	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vb);
> +	struct dma_async_tx_descriptor *desc;
> +	dma_addr_t addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	u32 flags;
> +
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
> +		dma->xt.dir = DMA_DEV_TO_MEM;
> +		dma->xt.src_sgl = false;
> +		dma->xt.dst_sgl = true;
> +		dma->xt.dst_start = addr;
> +	} else {
> +		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
> +		dma->xt.dir = DMA_MEM_TO_DEV;
> +		dma->xt.src_sgl = true;
> +		dma->xt.dst_sgl = false;
> +		dma->xt.src_start = addr;
> +	}
> +
> +	dma->xt.frame_size = 1;
> +	dma->sgl[0].size = dma->format.width * dma->fmtinfo->bpp;
> +	dma->sgl[0].icg = dma->format.bytesperline - dma->sgl[0].size;
> +	dma->xt.numf = dma->format.height;
> +
> +	desc = dmaengine_prep_interleaved_dma(dma->dma, &dma->xt, flags);
> +	if (!desc) {
> +		dev_err(dma->xdev->dev, "Failed to prepare DMA transfer\n");
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
> +		return;
> +	}
> +	desc->callback = xvip_dma_complete;
> +	desc->callback_param = buf;
> +
> +	spin_lock_irq(&dma->queued_lock);
> +	list_add_tail(&buf->queue, &dma->queued_bufs);
> +	spin_unlock_irq(&dma->queued_lock);
> +
> +	dmaengine_submit(desc);
> +
> +	if (vb2_is_streaming(&dma->queue))
> +		dma_async_issue_pending(dma->dma);
> +}
> +
> +static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +	struct xvip_dma_buffer *buf, *nbuf;
> +	struct xvip_pipeline *pipe;
> +	int ret;
> +
> +	dma->sequence = 0;
> +
> +	/*
> +	 * Start streaming on the pipeline. No link touching an entity in the
> +	 * pipeline can be activated or deactivated once streaming is started.
> +	 *
> +	 * Use the pipeline object embedded in the first DMA object that starts
> +	 * streaming.
> +	 */
> +	pipe = dma->video.entity.pipe
> +	     ? to_xvip_pipeline(&dma->video.entity) : &dma->pipe;
> +
> +	ret = media_entity_pipeline_start(&dma->video.entity, &pipe->pipe);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* Verify that the configured format matches the output of the
> +	 * connected subdev.
> +	 */
> +	ret = xvip_dma_verify_format(dma);
> +	if (ret < 0)
> +		goto error_stop;
> +
> +	ret = xvip_pipeline_prepare(pipe, dma);
> +	if (ret < 0)
> +		goto error_stop;
> +
> +	/* Start the DMA engine. This must be done before starting the blocks
> +	 * in the pipeline to avoid DMA synchronization issues.
> +	 */
> +	dma_async_issue_pending(dma->dma);

Question: can the DMA engine be started without any buffers queued? The vb2_queue
struct has a min_buffers_needed field that can be set to a non-zero value. In
that case start_streaming won't be called until at least that many buffers have
been queued. Many DMA engines need that so this was added to the vb2 core to
avoid having to hack around this in the driver.

> +
> +	/* Start the pipeline. */
> +	xvip_pipeline_set_stream(pipe, true);
> +
> +	return 0;
> +
> +error_stop:
> +	media_entity_pipeline_stop(&dma->video.entity);
> +
> +error:
> +	/* Give back all queued buffers to videobuf2. */
> +	spin_lock_irq(&dma->queued_lock);
> +	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
> +		list_del(&buf->queue);
> +	}
> +	spin_unlock_irq(&dma->queued_lock);
> +
> +	return ret;
> +}
> +
> +static void xvip_dma_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +	struct xvip_pipeline *pipe = to_xvip_pipeline(&dma->video.entity);
> +	struct xvip_dma_buffer *buf, *nbuf;
> +
> +	/* Stop the pipeline. */
> +	xvip_pipeline_set_stream(pipe, false);
> +
> +	/* Stop and reset the DMA engine. */
> +	dmaengine_terminate_all(dma->dma);
> +
> +	/* Cleanup the pipeline and mark it as being stopped. */
> +	xvip_pipeline_cleanup(pipe);
> +	media_entity_pipeline_stop(&dma->video.entity);
> +
> +	/* Give back all queued buffers to videobuf2. */
> +	spin_lock_irq(&dma->queued_lock);
> +	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
> +		list_del(&buf->queue);
> +	}
> +	spin_unlock_irq(&dma->queued_lock);
> +}
> +
> +static struct vb2_ops xvip_dma_queue_qops = {
> +	.queue_setup = xvip_dma_queue_setup,
> +	.buf_prepare = xvip_dma_buffer_prepare,
> +	.buf_queue = xvip_dma_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = xvip_dma_start_streaming,
> +	.stop_streaming = xvip_dma_stop_streaming,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int
> +xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
> +			  | dma->xdev->v4l2_caps;
> +
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	else
> +		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
> +
> +	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
> +	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
> +		 dma->xdev->dev->of_node->name, dma->port);
> +
> +	return 0;
> +}
> +
> +/* FIXME: without this callback function, some applications are not configured
> + * with correct formats, and it results in frames in wrong format. Whether this
> + * callback needs to be required is not clearly defined, so it should be
> + * clarified through the mailing list.
> + */
> +static int
> +xvip_dma_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	if (f->index > 0)
> +		return -EINVAL;
> +
> +	f->pixelformat = dma->format.pixelformat;
> +	strlcpy(f->description, dma->fmtinfo->description,
> +		sizeof(f->description));
> +
> +	return 0;
> +}
> +
> +static int
> +xvip_dma_get_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	format->fmt.pix = dma->format;
> +
> +	return 0;
> +}
> +
> +static void
> +__xvip_dma_try_format(struct xvip_dma *dma, struct v4l2_pix_format *pix,
> +		      const struct xvip_video_format **fmtinfo)
> +{
> +	const struct xvip_video_format *info;
> +	unsigned int min_width;
> +	unsigned int max_width;
> +	unsigned int min_bpl;
> +	unsigned int max_bpl;
> +	unsigned int width;
> +	unsigned int align;
> +	unsigned int bpl;
> +
> +	/* Retrieve format information and select the default format if the
> +	 * requested format isn't supported.
> +	 */
> +	info = xvip_get_format_by_fourcc(pix->pixelformat);
> +	if (IS_ERR(info))
> +		info = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	/* The transfer alignment requirements are expressed in bytes. Compute
> +	 * the minimum and maximum values, clamp the requested width and convert
> +	 * it back to pixels.
> +	 */
> +	align = lcm(dma->align, info->bpp);
> +	min_width = roundup(XVIP_DMA_MIN_WIDTH, align);
> +	max_width = rounddown(XVIP_DMA_MAX_WIDTH, align);
> +	width = rounddown(pix->width * info->bpp, align);
> +
> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
> +	pix->height = clamp(pix->height, XVIP_DMA_MIN_HEIGHT,
> +			    XVIP_DMA_MAX_HEIGHT);
> +
> +	/* Clamp the requested bytes per line value. If the maximum bytes per
> +	 * line value is zero, the module doesn't support user configurable line
> +	 * sizes. Override the requested value with the minimum in that case.
> +	 */
> +	min_bpl = pix->width * info->bpp;
> +	max_bpl = rounddown(XVIP_DMA_MAX_WIDTH, dma->align);
> +	bpl = rounddown(pix->bytesperline, dma->align);
> +
> +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +
> +	if (fmtinfo)
> +		*fmtinfo = info;
> +}
> +
> +static int
> +xvip_dma_try_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +
> +	__xvip_dma_try_format(dma, &format->fmt.pix, NULL);
> +	return 0;
> +}
> +
> +static int
> +xvip_dma_set_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	const struct xvip_video_format *info;
> +
> +	__xvip_dma_try_format(dma, &format->fmt.pix, &info);
> +
> +	if (vb2_is_busy(&dma->queue))
> +		return -EBUSY;
> +
> +	dma->format = format->fmt.pix;
> +	dma->fmtinfo = info;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops xvip_dma_ioctl_ops = {
> +	.vidioc_querycap		= xvip_dma_querycap,
> +	.vidioc_enum_fmt_vid_cap	= xvip_dma_enum_format,
> +	.vidioc_g_fmt_vid_cap		= xvip_dma_get_format,
> +	.vidioc_g_fmt_vid_out		= xvip_dma_get_format,
> +	.vidioc_s_fmt_vid_cap		= xvip_dma_set_format,
> +	.vidioc_s_fmt_vid_out		= xvip_dma_set_format,
> +	.vidioc_try_fmt_vid_cap		= xvip_dma_try_format,
> +	.vidioc_try_fmt_vid_out		= xvip_dma_try_format,
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,

Add .vidioc_create_bufs = vb2_ioctl_create_bufs,

> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +
> +static const struct v4l2_file_operations xvip_dma_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,

I would also add:

	.read = vb2_fop_read,
	.write = vb2_fop_write,

and add VB2_READ or VB2_WRITE to dma->queue.io_modes.

You get it for free, it doesn't take any additional resources,
so why not?

However, to make that work correctly you need this patch:

https://patchwork.linuxtv.org/patch/28478/

It would make sense if you just add that patch to your xilinx tree.

Regards,

	Hans

> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Xilinx Video DMA Core
> + */
> +
> +int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
> +		  enum v4l2_buf_type type, unsigned int port)
> +{
> +	char name[14];
> +	int ret;
> +
> +	dma->xdev = xdev;
> +	dma->port = port;
> +	mutex_init(&dma->lock);
> +	mutex_init(&dma->pipe.lock);
> +	INIT_LIST_HEAD(&dma->queued_bufs);
> +	spin_lock_init(&dma->queued_lock);
> +
> +	dma->fmtinfo = xvip_get_format_by_fourcc(XVIP_DMA_DEF_FORMAT);
> +	dma->format.pixelformat = dma->fmtinfo->fourcc;
> +	dma->format.colorspace = V4L2_COLORSPACE_SRGB;
> +	dma->format.field = V4L2_FIELD_NONE;
> +	dma->format.width = XVIP_DMA_DEF_WIDTH;
> +	dma->format.height = XVIP_DMA_DEF_HEIGHT;
> +	dma->format.bytesperline = dma->format.width * dma->fmtinfo->bpp;
> +	dma->format.sizeimage = dma->format.bytesperline * dma->format.height;
> +
> +	/* Initialize the media entity... */
> +	dma->pad.flags = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> +		       ? MEDIA_PAD_FL_SINK : MEDIA_PAD_FL_SOURCE;
> +
> +	ret = media_entity_init(&dma->video.entity, 1, &dma->pad, 0);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* ... and the video node... */
> +	dma->video.fops = &xvip_dma_fops;
> +	dma->video.v4l2_dev = &xdev->v4l2_dev;
> +	dma->video.queue = &dma->queue;
> +	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
> +		 xdev->dev->of_node->name,
> +		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
> +		 port);
> +	dma->video.vfl_type = VFL_TYPE_GRABBER;
> +	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> +			   ? VFL_DIR_RX : VFL_DIR_TX;
> +	dma->video.release = video_device_release_empty;
> +	dma->video.ioctl_ops = &xvip_dma_ioctl_ops;
> +	dma->video.lock = &dma->lock;
> +
> +	video_set_drvdata(&dma->video, dma);
> +
> +	/* ... and the buffers queue... */
> +	dma->alloc_ctx = vb2_dma_contig_init_ctx(dma->xdev->dev);
> +	if (IS_ERR(dma->alloc_ctx))
> +		goto error;
> +
> +	dma->queue.type = type;
> +	dma->queue.io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF;
> +	dma->queue.lock = &dma->lock;
> +	dma->queue.drv_priv = dma;
> +	dma->queue.buf_struct_size = sizeof(struct xvip_dma_buffer);
> +	dma->queue.ops = &xvip_dma_queue_qops;
> +	dma->queue.mem_ops = &vb2_dma_contig_memops;
> +	dma->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
> +	ret = vb2_queue_init(&dma->queue);
> +	if (ret < 0) {
> +		dev_err(dma->xdev->dev, "failed to initialize VB2 queue\n");
> +		goto error;
> +	}
> +
> +	/* ... and the DMA channel. */
> +	sprintf(name, "port%u", port);
> +	dma->dma = dma_request_slave_channel(dma->xdev->dev, name);
> +	if (dma->dma == NULL) {
> +		dev_err(dma->xdev->dev, "no VDMA channel found\n");
> +		ret = -ENODEV;
> +		goto error;
> +	}
> +
> +	dma->align = 1 << dma->dma->device->copy_align;
> +
> +	ret = video_register_device(&dma->video, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(dma->xdev->dev, "failed to register video device\n");
> +		goto error;
> +	}
> +
> +	return 0;
> +
> +error:
> +	xvip_dma_cleanup(dma);
> +	return ret;
> +}
> +
> +void xvip_dma_cleanup(struct xvip_dma *dma)
> +{
> +	if (video_is_registered(&dma->video))
> +		video_unregister_device(&dma->video);
> +
> +	if (dma->dma)
> +		dma_release_channel(dma->dma);
> +
> +	if (!IS_ERR_OR_NULL(dma->alloc_ctx))
> +		vb2_dma_contig_cleanup_ctx(dma->alloc_ctx);
> +
> +	media_entity_cleanup(&dma->video.entity);
> +
> +	mutex_destroy(&dma->lock);
> +	mutex_destroy(&dma->pipe.lock);
> +}

<snip>

