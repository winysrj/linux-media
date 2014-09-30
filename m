Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2735 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaI3OEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 10:04:12 -0400
Message-ID: <542AB836.1060500@xs4all.nl>
Date: Tue, 30 Sep 2014 16:03:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Radhey Shyam Pandey <radheys@xilinx.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 09/11] v4l: xilinx: Add Xilinx Video IP core
References: <1412022477-28749-1-git-send-email-laurent.pinchart@ideasonboard.com> <1412022477-28749-10-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1412022477-28749-10-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Here is an initial review of this driver:

On 09/29/14 22:27, Laurent Pinchart wrote:
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
> ---
>  .../devicetree/bindings/media/xilinx/video.txt     |  52 ++
>  .../bindings/media/xilinx/xlnx,video.txt           |  55 ++
>  MAINTAINERS                                        |   9 +
>  drivers/media/platform/Kconfig                     |   1 +
>  drivers/media/platform/Makefile                    |   2 +
>  drivers/media/platform/xilinx/Kconfig              |  10 +
>  drivers/media/platform/xilinx/Makefile             |   3 +
>  drivers/media/platform/xilinx/xilinx-dma.c         | 995 +++++++++++++++++++++
>  drivers/media/platform/xilinx/xilinx-dma.h         | 109 +++
>  drivers/media/platform/xilinx/xilinx-vip.c         | 269 ++++++
>  drivers/media/platform/xilinx/xilinx-vip.h         | 227 +++++
>  drivers/media/platform/xilinx/xilinx-vipp.c        | 666 ++++++++++++++
>  drivers/media/platform/xilinx/xilinx-vipp.h        |  47 +
>  13 files changed, 2445 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/video.txt
>  create mode 100644 Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
>  create mode 100644 drivers/media/platform/xilinx/Kconfig
>  create mode 100644 drivers/media/platform/xilinx/Makefile
>  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-dma.h
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vip.h
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.c
>  create mode 100644 drivers/media/platform/xilinx/xilinx-vipp.h
> 
> Cc: devicetree@vger.kernel.org
> 
> diff --git a/Documentation/devicetree/bindings/media/xilinx/video.txt b/Documentation/devicetree/bindings/media/xilinx/video.txt
> new file mode 100644
> index 0000000..15720e4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/video.txt
> @@ -0,0 +1,52 @@
> +DT bindings for Xilinx video IP cores
> +-------------------------------------
> +
> +Xilinx video IP cores process video streams by acting as video sinks and/or
> +sources. They are connected by links through their input and output ports,
> +creating a video pipeline.
> +
> +Each video IP core is represented by an AMBA bus child node in the device
> +tree using bindings documented in this directory. Connections between the IP
> +cores are represented as defined in ../video-interfaces.txt.
> +
> +The whole  pipeline is represented by an AMBA bus child node in the device
> +tree using bindings documented in ./xlnx,video.txt.
> +
> +Common properties
> +-----------------
> +
> +The following properties are common to all Xilinx video IP cores.
> +
> +- xlnx,video-format: This property represents a video format transmitted on an
> +  AXI bus between video IP cores. How the format relates to the IP core is
> +  decribed in the IP core bindings documentation. The following formats are
> +  supported.
> +
> +	rbg
> +	xrgb
> +	yuv422
> +	yuv444
> +	rggb
> +	grbg
> +	gbrg
> +	bggr
> +
> +- xlnx,video-width: This property qualifies the video format with the sample
> +  width expressed as a number of bits per pixel component. All components must
> +  use the same width.
> +
> +The following table lists the supported formats and widths combinations, along
> +with the corresponding media bus pixel code.
> +
> +----------------+-------+-------------------------------------------------------
> +Format		| Width	| Media bus code
> +----------------+-------+-------------------------------------------------------
> +rbg		| 8	| V4L2_MBUS_FMT_RBG888_1X24
> +xrgb		| 8	| V4L2_MBUS_FMT_RGB888_1X32_PADHI
> +yuv422		| 8	| V4L2_MBUS_FMT_UYVY8_1X16
> +yuv444		| 8	| V4L2_MBUS_FMT_VUY888_1X24
> +rggb		| 8	| V4L2_MBUS_FMT_SRGGB8_1X8
> +grbg		| 8	| V4L2_MBUS_FMT_SGRBG8_1X8
> +gbrg		| 8	| V4L2_MBUS_FMT_SGBRG8_1X8
> +bggr		| 8	| V4L2_MBUS_FMT_SBGGR8_1X8
> +----------------+-------+-------------------------------------------------------
> diff --git a/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt b/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
> new file mode 100644
> index 0000000..5a02270
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/xilinx/xlnx,video.txt
> @@ -0,0 +1,55 @@
> +Xilinx Video IP Pipeline (VIPP)
> +-------------------------------
> +
> +General concept
> +---------------
> +
> +Xilinx video IP pipeline processes video streams through one or more Xilinx
> +video IP cores. Each video IP core is represented as documented in video.txt
> +and IP core specific documentation, xlnx,v-*.txt, in this directory. The DT
> +node of the VIPP represents as a top level node of the pipeline and defines
> +mappings between DMAs and the video IP cores.
> +
> +Required properties:
> +
> +- compatible: Must be "xlnx,video".
> +
> +- dmas, dma-names: List of one DMA specifier and identifier string (as defined
> +  in Documentation/devicetree/bindings/dma/dma.txt) per port. Each port
> +  requires a DMA channel with the identifier string set to "port" followed by
> +  the port index.
> +
> +- ports: Video port, using the DT bindings defined in ../video-interfaces.txt.
> +
> +Required port properties:
> +
> +- direction: should be either "input" or "output" depending on the direction
> +  of stream.
> +
> +Example:
> +
> +	video_cap {
> +		compatible = "xlnx,video";
> +		dmas = <&vdma_1 1>, <&vdma_3 1>;
> +		dma-names = "port0", "port1";
> +
> +		ports {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +
> +			port@0 {
> +				reg = <0>;
> +				direction = "input";
> +				vcap0_in0: endpoint {
> +					remote-endpoint = <&scaler0_out>;
> +				};
> +			};
> +			port@1 {
> +				reg = <1>;
> +				direction = "input";
> +				vcap0_in1: endpoint {
> +					remote-endpoint = <&switch_out1>;
> +				};
> +			};
> +		};
> +	};
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e80a275..8d09f6e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10216,6 +10216,15 @@ L:	linux-serial@vger.kernel.org
>  S:	Maintained
>  F:	drivers/tty/serial/uartlite.c
>  
> +XILINX VIDEO IP CORES
> +M:	Hyun Kwon <hyun.kwon@xilinx.com>
> +M:	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> +L:	linux-media@vger.kernel.org
> +T:	git git://linuxtv.org/media_tree.git
> +S:	Supported
> +F:	Documentation/devicetree/bindings/media/xilinx/
> +F:	drivers/media/platform/xilinx/
> +
>  XTENSA XTFPGA PLATFORM SUPPORT
>  M:	Max Filippov <jcmvbkbc@gmail.com>
>  L:	linux-xtensa@linux-xtensa.org
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index bee9074..2d1a452 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -126,6 +126,7 @@ config VIDEO_S3C_CAMIF
>  source "drivers/media/platform/soc_camera/Kconfig"
>  source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
> +source "drivers/media/platform/xilinx/Kconfig"
>  
>  endif # V4L_PLATFORM_DRIVERS
>  
> diff --git a/drivers/media/platform/Makefile b/drivers/media/platform/Makefile
> index 579046b..5655315 100644
> --- a/drivers/media/platform/Makefile
> +++ b/drivers/media/platform/Makefile
> @@ -49,4 +49,6 @@ obj-$(CONFIG_VIDEO_RENESAS_VSP1)	+= vsp1/
>  
>  obj-y	+= omap/
>  
> +obj-$(CONFIG_VIDEO_XILINX)		+= xilinx/
> +
>  ccflags-y += -I$(srctree)/drivers/media/i2c
> diff --git a/drivers/media/platform/xilinx/Kconfig b/drivers/media/platform/xilinx/Kconfig
> new file mode 100644
> index 0000000..f4347e9
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/Kconfig
> @@ -0,0 +1,10 @@
> +config VIDEO_XILINX
> +	tristate "Xilinx Video IP (EXPERIMENTAL)"
> +	depends on VIDEO_V4L2 && VIDEO_V4L2_SUBDEV_API && OF
> +	select VIDEOBUF2_DMA_CONTIG
> +	---help---
> +	  Driver for Xilinx Video IP Pipelines
> +
> +if VIDEO_XILINX
> +
> +endif #VIDEO_XILINX
> diff --git a/drivers/media/platform/xilinx/Makefile b/drivers/media/platform/xilinx/Makefile
> new file mode 100644
> index 0000000..3ef9c8e
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/Makefile
> @@ -0,0 +1,3 @@
> +xilinx-video-objs += xilinx-dma.o xilinx-vip.o xilinx-vipp.o
> +
> +obj-$(CONFIG_VIDEO_XILINX) += xilinx-video.o
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
> new file mode 100644
> index 0000000..e09e8bd
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -0,0 +1,995 @@
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
> +	    dma->format.width != fmt.format.width)
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
> + * @addr: DMA bus address for the buffer memory
> + * @length: total length of the buffer in bytes
> + * @bytesused: number of bytes used in the buffer
> + */
> +struct xvip_dma_buffer {
> +	struct vb2_buffer buf;
> +	struct list_head queue;
> +
> +	struct xvip_dma *dma;
> +
> +	dma_addr_t addr;
> +	unsigned int length;
> +	unsigned int bytesused;

Personally I think it is overkill to store these three values in the
buffer instead of just calling the vb2 access functions.

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
> +	v4l2_get_timestamp(&buf->buf.v4l2_buf.timestamp);
> +	vb2_set_plane_payload(&buf->buf, 0, buf->length);
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
> +	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +	buf->length = vb2_plane_size(vb, 0);
> +	buf->bytesused = 0;
> +
> +	return 0;
> +}
> +
> +static void xvip_dma_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vb->vb2_queue);
> +	struct xvip_dma_buffer *buf = to_xvip_dma_buffer(vb);
> +	struct dma_async_tx_descriptor *desc;
> +	u32 flags;
> +
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
> +		dma->xt.dir = DMA_DEV_TO_MEM;
> +		dma->xt.src_sgl = false;
> +		dma->xt.dst_sgl = true;
> +		dma->xt.dst_start = buf->addr;
> +	} else {
> +		flags = DMA_PREP_INTERRUPT | DMA_CTRL_ACK;
> +		dma->xt.dir = DMA_MEM_TO_DEV;
> +		dma->xt.src_sgl = true;
> +		dma->xt.dst_sgl = false;
> +		dma->xt.src_start = buf->addr;
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
> +static void xvip_dma_wait_prepare(struct vb2_queue *vq)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +
> +	mutex_unlock(&dma->lock);
> +}
> +
> +static void xvip_dma_wait_finish(struct vb2_queue *vq)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +
> +	mutex_lock(&dma->lock);
> +}
> +
> +static int xvip_dma_start_streaming(struct vb2_queue *vq, unsigned int count)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
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
> +		return ret;
> +
> +	/* Verify that the configured format matches the output of the
> +	 * connected subdev.
> +	 */
> +	ret = xvip_dma_verify_format(dma);
> +	if (ret < 0)
> +		goto error;
> +
> +	ret = xvip_pipeline_prepare(pipe, dma);
> +	if (ret < 0)
> +		goto error;
> +
> +	/* Start the DMA engine. This must be done before starting the blocks
> +	 * in the pipeline to avoid DMA synchronization issues.
> +	 */
> +	dma_async_issue_pending(dma->dma);
> +
> +	/* Start the pipeline. */
> +	xvip_pipeline_set_stream(pipe, true);
> +
> +	return 0;
> +
> +error:
> +	media_entity_pipeline_stop(&dma->video.entity);

In case of an error in start_streaming you have to requeue the buffers
(i.e. hand back the buffers to vb2):

	/* Give back all queued buffers to videobuf2. */
	spin_lock_irq(&dma->queued_lock);
	list_for_each_entry_safe(buf, nbuf, &dma->queued_bufs, queue) {
		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
		list_del(&buf->queue);
	}
	spin_unlock_irq(&dma->queued_lock);

otherwise the vb2 buffer administration will get confused.

> +	return ret;
> +}
> +
> +static void xvip_dma_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct xvip_dma *dma = vb2_get_drv_priv(vq);
> +	struct xvip_pipeline *pipe = to_xvip_pipeline(&dma->video.entity);
> +	struct xvip_dma_buffer *buf, *nbuf;
> +	struct xilinx_vdma_config config;
> +
> +	/* Stop the pipeline. */
> +	xvip_pipeline_set_stream(pipe, false);
> +
> +	/* Stop and reset the DMA engine. */
> +	dmaengine_device_control(dma->dma, DMA_TERMINATE_ALL, 0);
> +
> +	config.reset = 1;
> +
> +	dmaengine_device_control(dma->dma, DMA_SLAVE_CONFIG,
> +				 (unsigned long)&config);
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
> +	.wait_prepare = xvip_dma_wait_prepare,
> +	.wait_finish = xvip_dma_wait_finish,
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
> +	if (dma->queue.type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
> +		cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	else
> +		cap->capabilities = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;

cap->device_caps isn't set.

> +
> +	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
> +	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
> +	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));

Should be prefixed with "platform:" for platform drivers.

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
> +	mutex_lock(&dma->lock);
> +	f->pixelformat = dma->format.pixelformat;
> +	strlcpy(f->description, dma->fmtinfo->description,
> +		sizeof(f->description));
> +	mutex_unlock(&dma->lock);
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
> +	mutex_lock(&dma->lock);
> +	format->fmt.pix = dma->format;
> +	mutex_unlock(&dma->lock);
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
> +	pix->colorspace = V4L2_COLORSPACE_SRGB;

Colorspace information can be tricky: for capture the colorspace should
come from the subdevs (e.g. the HDMI receiver), for output the colorspace
is set by the application and passed on to the transmitter.

I'll have a presentation on this topic during the media mini-summit.

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
> +	struct xilinx_vdma_config config;
> +	int ret;
> +
> +	__xvip_dma_try_format(dma, &format->fmt.pix, &info);
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (vb2_is_streaming(&dma->queue)) {

That should be vb2_is_busy(): as soon as REQBUFS is called you can no longer
change the format.

> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	dma->format = format->fmt.pix;
> +	dma->fmtinfo = info;
> +
> +	/* Configure the DMA engine. */
> +	memset(&config, 0, sizeof(config));
> +
> +	config.park = 1;
> +	config.park_frm = 0;
> +	config.ext_fsync = 2;
> +
> +	dmaengine_device_control(dma->dma, DMA_SLAVE_CONFIG,
> +				 (unsigned long)&config);
> +
> +	ret = 0;
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_reqbufs(struct file *file, void *fh, struct v4l2_requestbuffers *rb)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_reqbufs(&dma->queue, rb);
> +	if (ret < 0)
> +		goto done;
> +
> +	dma->queue.owner = vfh;
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret ? ret : rb->count;
> +}
> +
> +static int
> +xvip_dma_querybuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +	ret = vb2_querybuf(&dma->queue, buf);
> +	mutex_unlock(&dma->lock);
> +
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_qbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_qbuf(&dma->queue, buf);
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_dqbuf(&dma->queue, buf, file->f_flags & O_NONBLOCK);
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_expbuf(struct file *file, void *priv, struct v4l2_exportbuffer *eb)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_expbuf(&dma->queue, eb);
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_streamon(&dma->queue, type);
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}
> +
> +static int
> +xvip_dma_streamoff(struct file *file, void *fh, enum v4l2_buf_type type)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +
> +	if (dma->queue.owner && dma->queue.owner != vfh) {
> +		ret = -EBUSY;
> +		goto done;
> +	}
> +
> +	ret = vb2_streamoff(&dma->queue, type);
> +
> +done:
> +	mutex_unlock(&dma->lock);
> +	return ret;
> +}

Use the vb2 helper functions rather than rolling your own. You can just plugin
the vb2_ioctl_* functions in xvip_dma_ioctl_ops.

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
> +	.vidioc_reqbufs			= xvip_dma_reqbufs,
> +	.vidioc_querybuf		= xvip_dma_querybuf,
> +	.vidioc_qbuf			= xvip_dma_qbuf,
> +	.vidioc_dqbuf			= xvip_dma_dqbuf,
> +	.vidioc_expbuf			= xvip_dma_expbuf,
> +	.vidioc_streamon		= xvip_dma_streamon,
> +	.vidioc_streamoff		= xvip_dma_streamoff,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +
> +static int xvip_dma_open(struct file *file)
> +{
> +	struct xvip_dma *dma = video_drvdata(file);
> +	struct v4l2_fh *vfh;
> +
> +	vfh = kzalloc(sizeof(*vfh), GFP_KERNEL);
> +	if (vfh == NULL)
> +		return -ENOMEM;
> +
> +	v4l2_fh_init(vfh, &dma->video);
> +	v4l2_fh_add(vfh);
> +
> +	file->private_data = vfh;
> +
> +	return 0;
> +}

Use v4l2_fh_open.

> +
> +static int xvip_dma_release(struct file *file)
> +{
> +	struct xvip_dma *dma = video_drvdata(file);
> +	struct v4l2_fh *vfh = file->private_data;
> +
> +	mutex_lock(&dma->lock);
> +	if (dma->queue.owner == vfh) {
> +		vb2_queue_release(&dma->queue);
> +		dma->queue.owner = NULL;
> +	}
> +	mutex_unlock(&dma->lock);
> +
> +	v4l2_fh_release(file);
> +
> +	file->private_data = NULL;
> +
> +	return 0;
> +}

Use vb2_fop_release().

> +
> +static unsigned int xvip_dma_poll(struct file *file, poll_table *wait)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +	ret = vb2_poll(&dma->queue, file, wait);
> +	mutex_unlock(&dma->lock);
> +
> +	return ret;
> +}

vb2_fop_poll()

> +
> +static int xvip_dma_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct xvip_dma *dma = to_xvip_dma(vfh->vdev);
> +	int ret;
> +
> +	mutex_lock(&dma->lock);
> +	ret = vb2_mmap(&dma->queue, vma);
> +	mutex_unlock(&dma->lock);
> +
> +	return ret;
> +}

vb2_fop_mmap()

> +
> +static struct v4l2_file_operations xvip_dma_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= xvip_dma_open,
> +	.release	= xvip_dma_release,
> +	.poll		= xvip_dma_poll,
> +	.mmap		= xvip_dma_mmap,
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
> +	dma->video.v4l2_dev = &xdev->v4l2_dev;
> +	dma->video.fops = &xvip_dma_fops;
> +	snprintf(dma->video.name, sizeof(dma->video.name), "%s %s %u",
> +		 xdev->dev->of_node->name,
> +		 type == V4L2_BUF_TYPE_VIDEO_CAPTURE ? "output" : "input",
> +		 port);
> +	dma->video.vfl_type = VFL_TYPE_GRABBER;
> +	dma->video.vfl_dir = type == V4L2_BUF_TYPE_VIDEO_CAPTURE
> +			   ? VFL_DIR_RX : VFL_DIR_TX;
> +	dma->video.release = video_device_release_empty;
> +	dma->video.ioctl_ops = &xvip_dma_ioctl_ops;

Set dma->video.queue to &dma->queue. That's all you need to be able to
use the vb2 helper functions.

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

Add VB2_READ/WRITE. It's basically for free, so why not?

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
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.h b/drivers/media/platform/xilinx/xilinx-dma.h
> new file mode 100644
> index 0000000..95bf6b2
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-dma.h
> @@ -0,0 +1,109 @@
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
> +#ifndef __XILINX_VIP_DMA_H__
> +#define __XILINX_VIP_DMA_H__
> +
> +#include <linux/dmaengine.h>
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
> +#include <linux/videodev2.h>
> +
> +#include <media/media-entity.h>
> +#include <media/v4l2-dev.h>
> +#include <media/videobuf2-core.h>
> +
> +struct dma_chan;
> +struct xvip_composite_device;
> +struct xvip_video_format;
> +
> +/**
> + * struct xvip_pipeline - Xilinx Video IP pipeline structure
> + * @pipe: media pipeline
> + * @lock: protects the pipeline @stream_count
> + * @use_count: number of DMA engines using the pipeline
> + * @stream_count: number of DMA engines currently streaming
> + * @num_dmas: number of DMA engines in the pipeline
> + * @output: DMA engine at the output of the pipeline
> + */
> +struct xvip_pipeline {
> +	struct media_pipeline pipe;
> +
> +	struct mutex lock;
> +	unsigned int use_count;
> +	unsigned int stream_count;
> +
> +	unsigned int num_dmas;
> +	struct xvip_dma *output;
> +};
> +
> +static inline struct xvip_pipeline *to_xvip_pipeline(struct media_entity *e)
> +{
> +	return container_of(e->pipe, struct xvip_pipeline, pipe);
> +}
> +
> +/**
> + * struct xvip_dma - Video DMA channel
> + * @list: list entry in a composite device dmas list
> + * @video: V4L2 video device associated with the DMA channel
> + * @pad: media pad for the video device entity
> + * @xdev: composite device the DMA channel belongs to
> + * @pipe: pipeline belonging to the DMA channel
> + * @port: composite device DT node port number for the DMA channel
> + * @lock: protects the @format, @fmtinfo and @queue fields
> + * @format: active V4L2 pixel format
> + * @fmtinfo: format information corresponding to the active @format
> + * @queue: vb2 buffers queue
> + * @alloc_ctx: allocation context for the vb2 @queue
> + * @sequence: V4L2 buffers sequence number
> + * @queued_bufs: list of queued buffers
> + * @queued_lock: protects the buf_queued list
> + * @dma: DMA engine channel
> + * @align: transfer alignment required by the DMA channel (in bytes)
> + * @xt: dma interleaved template for dma configuration
> + * @sgl: data chunk structure for dma_interleaved_template
> + */
> +struct xvip_dma {
> +	struct list_head list;
> +	struct video_device video;
> +	struct media_pad pad;
> +
> +	struct xvip_composite_device *xdev;
> +	struct xvip_pipeline pipe;
> +	unsigned int port;
> +
> +	struct mutex lock;
> +	struct v4l2_pix_format format;
> +	const struct xvip_video_format *fmtinfo;
> +
> +	struct vb2_queue queue;
> +	void *alloc_ctx;
> +	unsigned int sequence;
> +
> +	struct list_head queued_bufs;
> +	spinlock_t queued_lock;
> +
> +	struct dma_chan *dma;
> +	unsigned int align;
> +	struct dma_interleaved_template xt;
> +	struct data_chunk sgl[1];
> +};
> +
> +#define to_xvip_dma(vdev)	container_of(vdev, struct xvip_dma, video)
> +
> +int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
> +		  enum v4l2_buf_type type, unsigned int port);
> +void xvip_dma_cleanup(struct xvip_dma *dma);
> +
> +#endif /* __XILINX_VIP_DMA_H__ */
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.c b/drivers/media/platform/xilinx/xilinx-vip.c
> new file mode 100644
> index 0000000..32b6095
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-vip.c
> @@ -0,0 +1,269 @@
> +/*
> + * Xilinx Video IP Core
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
> +#include <linux/export.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +
> +#include "xilinx-vip.h"
> +
> +/* -----------------------------------------------------------------------------
> + * Helper functions
> + */
> +
> +static const struct xvip_video_format xvip_video_formats[] = {
> +	{ "rbg", 8, 3, V4L2_MBUS_FMT_RBG888_1X24, 0, NULL },
> +	{ "xrgb", 8, 4, V4L2_MBUS_FMT_RGB888_1X32_PADHI, V4L2_PIX_FMT_BGR32,
> +	  "RGB32 (BE)" },
> +	{ "yuv422", 8, 2, V4L2_MBUS_FMT_UYVY8_1X16, V4L2_PIX_FMT_YUYV,
> +	  "4:2:2, packed, YUYV" },
> +	{ "yuv444", 8, 3, V4L2_MBUS_FMT_VUY8_1X24, V4L2_PIX_FMT_YUV444,
> +	  "4:4:4, packed, YUYV" },
> +	{ "rggb", 8, 1, V4L2_MBUS_FMT_SRGGB8_1X8, V4L2_PIX_FMT_SGRBG8,
> +	  "Bayer 8-bit RGGB" },
> +	{ "grbg", 8, 1, V4L2_MBUS_FMT_SGRBG8_1X8, V4L2_PIX_FMT_SGRBG8,
> +	  "Bayer 8-bit GRBG" },
> +	{ "gbrg", 8, 1, V4L2_MBUS_FMT_SGBRG8_1X8, V4L2_PIX_FMT_SGBRG8,
> +	  "Bayer 8-bit GBRG" },
> +	{ "bggr", 8, 1, V4L2_MBUS_FMT_SBGGR8_1X8, V4L2_PIX_FMT_SBGGR8,
> +	  "Bayer 8-bit BGGR" },
> +};
> +
> +/**
> + * xvip_get_format_by_code - Retrieve format information for a media bus code
> + * @code: the format media bus code
> + *
> + * Return: a pointer to the format information structure corresponding to the
> + * given V4L2 media bus format @code, or ERR_PTR if no corresponding format can
> + * be found.
> + */
> +const struct xvip_video_format *xvip_get_format_by_code(unsigned int code)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xvip_video_formats); ++i) {
> +		const struct xvip_video_format *format = &xvip_video_formats[i];
> +
> +		if (format->code == code)
> +			return format;
> +	}
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +EXPORT_SYMBOL_GPL(xvip_get_format_by_code);
> +
> +/**
> + * xvip_get_format_by_fourcc - Retrieve format information for a 4CC
> + * @fourcc: the format 4CC
> + *
> + * Return: a pointer to the format information structure corresponding to the
> + * given V4L2 format @fourcc, or ERR_PTR if no corresponding format can be
> + * found.
> + */
> +const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc)
> +{
> +	unsigned int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(xvip_video_formats); ++i) {
> +		const struct xvip_video_format *format = &xvip_video_formats[i];
> +
> +		if (format->fourcc == fourcc)
> +			return format;
> +	}
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +EXPORT_SYMBOL_GPL(xvip_get_format_by_fourcc);
> +
> +/**
> + * xvip_of_get_format - Parse a device tree node and return format information
> + * @node: the device tree node
> + *
> + * Read the xlnx,video-format and xlnx,video-width properties from the device
> + * tree @node passed as an argument and return the corresponding format
> + * information.
> + *
> + * Return: a pointer to the format information structure corresponding to the
> + * format name and width, or ERR_PTR if no corresponding format can be found.
> + */
> +const struct xvip_video_format *xvip_of_get_format(struct device_node *node)
> +{
> +	const char *name;
> +	unsigned int i;
> +	u32 width;
> +	int ret;
> +
> +	ret = of_property_read_string(node, "xlnx,video-format", &name);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	ret = of_property_read_u32(node, "xlnx,video-width", &width);
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	for (i = 0; i < ARRAY_SIZE(xvip_video_formats); ++i) {
> +		const struct xvip_video_format *format = &xvip_video_formats[i];
> +
> +		if (strcmp(format->name, name) == 0 && format->width == width)
> +			return format;
> +	}
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +EXPORT_SYMBOL_GPL(xvip_of_get_format);
> +
> +/**
> + * xvip_set_format_size - Set the media bus frame format size
> + * @format: V4L2 frame format on media bus
> + * @fmt: media bus format
> + *
> + * Set the media bus frame format size. The width / height from the subdevice
> + * format are set to the given media bus format. The new format size is stored
> + * in @format. The width and height are clamped using default min / max values.
> + */
> +void xvip_set_format_size(struct v4l2_mbus_framefmt *format,
> +			  const struct v4l2_subdev_format *fmt)
> +{
> +	format->width = clamp_t(unsigned int, fmt->format.width,
> +				XVIP_MIN_WIDTH, XVIP_MAX_WIDTH);
> +	format->height = clamp_t(unsigned int, fmt->format.height,
> +			 XVIP_MIN_HEIGHT, XVIP_MAX_HEIGHT);
> +}
> +EXPORT_SYMBOL_GPL(xvip_set_format_size);
> +
> +/**
> + * xvip_clr_or_set - Clear or set the register with a bitmask
> + * @xvip: Xilinx Video IP device
> + * @addr: address of register
> + * @mask: bitmask to be set or cleared
> + * @set: boolean flag indicating whether to set or clear
> + *
> + * Clear or set the register at address @addr with a bitmask @mask depending on
> + * the boolean flag @set. When the flag @set is true, the bitmask is set in
> + * the register, otherwise the bitmask is cleared from the register
> + * when the flag @set is false.
> + *
> + * Fox eample, this function can be used to set a control with a boolean value
> + * requested by users. If the caller knows whether to set or clear in the first
> + * place, the caller should call xvip_clr() or xvip_set() directly instead of
> + * using this function.
> + */
> +void xvip_clr_or_set(struct xvip_device *xvip, u32 addr, u32 mask, bool set)
> +{
> +	u32 reg;
> +
> +	reg = xvip_read(xvip, addr);
> +	reg = set ? reg | mask : reg & ~mask;
> +	xvip_write(xvip, addr, reg);
> +}
> +EXPORT_SYMBOL_GPL(xvip_clr_or_set);
> +
> +/**
> + * xvip_clr_and_set - Clear and set the register with a bitmask
> + * @xvip: Xilinx Video IP device
> + * @addr: address of register
> + * @clr: bitmask to be cleared
> + * @set: bitmask to be set
> + *
> + * Clear a bit(s) of mask @clr in the register at address @addr, then set
> + * a bit(s) of mask @set in the register after.
> + */
> +void xvip_clr_and_set(struct xvip_device *xvip, u32 addr, u32 clr, u32 set)
> +{
> +	u32 reg;
> +
> +	reg = xvip_read(xvip, addr);
> +	reg &= ~clr;
> +	reg |= set;
> +	xvip_write(xvip, addr, reg);
> +}
> +EXPORT_SYMBOL_GPL(xvip_clr_and_set);
> +
> +/* -----------------------------------------------------------------------------
> + * Subdev operation helpers
> + */
> +
> +/**
> + * xvip_enum_mbus_code - Enumerate the media format code
> + * @subdev: V4L2 subdevice
> + * @fh: V4L2 subdevice file handle
> + * @code: returning media bus code
> + *
> + * Enumerate the media bus code of the subdevice. Return the corresponding
> + * pad format code. This function only works for subdevices with fixed format
> + * on all pads. Subdevices with multiple format should have their own
> + * function to enumerate mbus codes.
> + *
> + * Return: 0 if the media bus code is found, or -EINVAL if the format index
> + * is not valid.
> + */
> +int xvip_enum_mbus_code(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
> +			struct v4l2_subdev_mbus_code_enum *code)
> +{
> +	struct v4l2_mbus_framefmt *format;
> +
> +	if (code->index)
> +		return -EINVAL;
> +
> +	format = v4l2_subdev_get_try_format(fh, code->pad);
> +
> +	code->code = format->code;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xvip_enum_mbus_code);
> +
> +/**
> + * xvip_enum_frame_size - Enumerate the media bus frame size
> + * @subdev: V4L2 subdevice
> + * @fh: V4L2 subdevice file handle
> + * @fse: returning media bus frame size
> + *
> + * This function is a drop-in implementation of the subdev enum_frame_size pad
> + * operation. It assumes that the subdevice has one sink pad and one source
> + * pad, and that the format on the source pad is always identical to the
> + * format on the sink pad. Entities with different requirements need to
> + * implement their own enum_frame_size handlers.
> + *
> + * Return: 0 if the media bus frame size is found, or -EINVAL
> + * if the index or the code is not valid.
> + */
> +int xvip_enum_frame_size(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
> +			 struct v4l2_subdev_frame_size_enum *fse)
> +{
> +	struct v4l2_mbus_framefmt *format;
> +
> +	format = v4l2_subdev_get_try_format(fh, fse->pad);
> +
> +	if (fse->index || fse->code != format->code)
> +		return -EINVAL;
> +
> +	if (fse->pad == XVIP_PAD_SINK) {
> +		fse->min_width = XVIP_MIN_WIDTH;
> +		fse->max_width = XVIP_MAX_WIDTH;
> +		fse->min_height = XVIP_MIN_HEIGHT;
> +		fse->max_height = XVIP_MAX_HEIGHT;
> +	} else {
> +		/* The size on the source pad is fixed and always identical to
> +		 * the size on the sink pad.
> +		 */
> +		fse->min_width = format->width;
> +		fse->max_width = format->width;
> +		fse->min_height = format->height;
> +		fse->max_height = format->height;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(xvip_enum_frame_size);
> diff --git a/drivers/media/platform/xilinx/xilinx-vip.h b/drivers/media/platform/xilinx/xilinx-vip.h
> new file mode 100644
> index 0000000..2e2b0dc
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-vip.h
> @@ -0,0 +1,227 @@
> +/*
> + * Xilinx Video IP Core
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
> +#ifndef __XILINX_VIP_H__
> +#define __XILINX_VIP_H__
> +
> +#include <linux/io.h>
> +#include <media/v4l2-subdev.h>
> +
> +/*
> + * Minimum and maximum width and height common to most video IP cores. IP
> + * cores with different requirements must define their own values.
> + */
> +#define XVIP_MIN_WIDTH			32
> +#define XVIP_MAX_WIDTH			7680
> +#define XVIP_MIN_HEIGHT			32
> +#define XVIP_MAX_HEIGHT			7680
> +
> +/*
> + * Pad IDs. IP cores with with multiple inputs or outputs should define
> + * their own values.
> + */
> +#define XVIP_PAD_SINK			0
> +#define XVIP_PAD_SOURCE			1
> +
> +/* Xilinx Video IP Control Registers */
> +#define XVIP_CTRL_CONTROL			0x0000
> +#define XVIP_CTRL_CONTROL_SW_ENABLE		(1 << 0)
> +#define XVIP_CTRL_CONTROL_REG_UPDATE		(1 << 1)
> +#define XVIP_CTRL_CONTROL_BYPASS		(1 << 4)
> +#define XVIP_CTRL_CONTROL_TEST_PATTERN		(1 << 5)
> +#define XVIP_CTRL_CONTROL_FRAME_SYNC_RESET	(1 << 30)
> +#define XVIP_CTRL_CONTROL_SW_RESET		(1 << 31)
> +#define XVIP_CTRL_STATUS			0x0004
> +#define XVIP_CTRL_STATUS_PROC_STARTED		(1 << 0)
> +#define XVIP_CTRL_STATUS_EOF			(1 << 1)
> +#define XVIP_CTRL_ERROR				0x0008
> +#define XVIP_CTRL_ERROR_SLAVE_EOL_EARLY		(1 << 0)
> +#define XVIP_CTRL_ERROR_SLAVE_EOL_LATE		(1 << 1)
> +#define XVIP_CTRL_ERROR_SLAVE_SOF_EARLY		(1 << 2)
> +#define XVIP_CTRL_ERROR_SLAVE_SOF_LATE		(1 << 3)
> +#define XVIP_CTRL_IRQ_ENABLE			0x000c
> +#define XVIP_CTRL_IRQ_ENABLE_PROC_STARTED	(1 << 0)
> +#define XVIP_CTRL_IRQ_EOF			(1 << 1)
> +#define XVIP_CTRL_VERSION			0x0010
> +#define XVIP_CTRL_VERSION_MAJOR_MASK		(0xff << 24)
> +#define XVIP_CTRL_VERSION_MAJOR_SHIFT		24
> +#define XVIP_CTRL_VERSION_MINOR_MASK		(0xff << 16)
> +#define XVIP_CTRL_VERSION_MINOR_SHIFT		16
> +#define XVIP_CTRL_VERSION_REVISION_MASK		(0xf << 12)
> +#define XVIP_CTRL_VERSION_REVISION_SHIFT	12
> +#define XVIP_CTRL_VERSION_PATCH_MASK		(0xf << 8)
> +#define XVIP_CTRL_VERSION_PATCH_SHIFT		8
> +#define XVIP_CTRL_VERSION_INTERNAL_MASK		(0xff << 0)
> +#define XVIP_CTRL_VERSION_INTERNAL_SHIFT	0
> +
> +/* Xilinx Video IP Timing Registers */
> +#define XVIP_ACTIVE_SIZE			0x0020
> +#define XVIP_ACTIVE_VSIZE_MASK			(0x7ff << 16)
> +#define XVIP_ACTIVE_VSIZE_SHIFT			16
> +#define XVIP_ACTIVE_HSIZE_MASK			(0x7ff << 0)
> +#define XVIP_ACTIVE_HSIZE_SHIFT			0
> +#define XVIP_ENCODING				0x0028
> +#define XVIP_ENCODING_NBITS_8			(0 << 4)
> +#define XVIP_ENCODING_NBITS_10			(1 << 4)
> +#define XVIP_ENCODING_NBITS_12			(2 << 4)
> +#define XVIP_ENCODING_NBITS_16			(3 << 4)
> +#define XVIP_ENCODING_NBITS_MASK		(3 << 4)
> +#define XVIP_ENCODING_NBITS_SHIFT		4
> +#define XVIP_ENCODING_VIDEO_FORMAT_YUV422	(0 << 0)
> +#define XVIP_ENCODING_VIDEO_FORMAT_YUV444	(1 << 0)
> +#define XVIP_ENCODING_VIDEO_FORMAT_RGB		(2 << 0)
> +#define XVIP_ENCODING_VIDEO_FORMAT_YUV420	(3 << 0)
> +#define XVIP_ENCODING_VIDEO_FORMAT_MASK		(3 << 0)
> +#define XVIP_ENCODING_VIDEO_FORMAT_SHIFT	0
> +
> +/**
> + * struct xvip_device - Xilinx Video IP device structure
> + * @subdev: V4L2 subdevice
> + * @dev: (OF) device
> + * @iomem: device I/O register space remapped to kernel virtual memory
> + * @saved_ctrl: saved control register for resume / suspend
> + */
> +struct xvip_device {
> +	struct v4l2_subdev subdev;
> +	struct device *dev;
> +	void __iomem *iomem;
> +	u32 saved_ctrl;
> +};
> +
> +/**
> + * struct xvip_video_format - Xilinx Video IP video format description
> + * @name: AXI4 format name
> + * @width: AXI4 format width in bits per component
> + * @bpp: bytes per pixel (when stored in memory)
> + * @code: media bus format code
> + * @fourcc: V4L2 pixel format FCC identifier
> + * @description: format description, suitable for userspace
> + */
> +struct xvip_video_format {
> +	const char *name;
> +	unsigned int width;
> +	unsigned int bpp;
> +	unsigned int code;
> +	u32 fourcc;
> +	const char *description;
> +};
> +
> +const struct xvip_video_format *xvip_get_format_by_code(unsigned int code);
> +const struct xvip_video_format *xvip_get_format_by_fourcc(u32 fourcc);
> +const struct xvip_video_format *xvip_of_get_format(struct device_node *node);
> +void xvip_set_format_size(struct v4l2_mbus_framefmt *format,
> +			  const struct v4l2_subdev_format *fmt);
> +int xvip_enum_mbus_code(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
> +			struct v4l2_subdev_mbus_code_enum *code);
> +int xvip_enum_frame_size(struct v4l2_subdev *subdev, struct v4l2_subdev_fh *fh,
> +			 struct v4l2_subdev_frame_size_enum *fse);
> +
> +static inline u32 xvip_read(struct xvip_device *xvip, u32 addr)
> +{
> +	return ioread32(xvip->iomem + addr);
> +}
> +
> +static inline void xvip_write(struct xvip_device *xvip, u32 addr, u32 value)
> +{
> +	iowrite32(value, xvip->iomem + addr);
> +}
> +
> +static inline void xvip_clr(struct xvip_device *xvip, u32 addr, u32 clr)
> +{
> +	xvip_write(xvip, addr, xvip_read(xvip, addr) & ~clr);
> +}
> +
> +static inline void xvip_set(struct xvip_device *xvip, u32 addr, u32 set)
> +{
> +	xvip_write(xvip, addr, xvip_read(xvip, addr) | set);
> +}
> +
> +void xvip_clr_or_set(struct xvip_device *xvip, u32 addr, u32 mask, bool set);
> +void xvip_clr_and_set(struct xvip_device *xvip, u32 addr, u32 clr, u32 set);
> +
> +static inline void xvip_reset(struct xvip_device *xvip)
> +{
> +	xvip_write(xvip, XVIP_CTRL_CONTROL, XVIP_CTRL_CONTROL_SW_RESET);
> +}
> +
> +static inline void xvip_start(struct xvip_device *xvip)
> +{
> +	xvip_set(xvip, XVIP_CTRL_CONTROL,
> +		 XVIP_CTRL_CONTROL_SW_ENABLE | XVIP_CTRL_CONTROL_REG_UPDATE);
> +}
> +
> +static inline void xvip_stop(struct xvip_device *xvip)
> +{
> +	xvip_clr(xvip, XVIP_CTRL_CONTROL, XVIP_CTRL_CONTROL_SW_ENABLE);
> +}
> +
> +static inline void xvip_resume(struct xvip_device *xvip)
> +{
> +	xvip_write(xvip, XVIP_CTRL_CONTROL,
> +		   xvip->saved_ctrl | XVIP_CTRL_CONTROL_SW_ENABLE);
> +}
> +
> +static inline void xvip_suspend(struct xvip_device *xvip)
> +{
> +	xvip->saved_ctrl = xvip_read(xvip, XVIP_CTRL_CONTROL);
> +	xvip_write(xvip, XVIP_CTRL_CONTROL,
> +		   xvip->saved_ctrl & ~XVIP_CTRL_CONTROL_SW_ENABLE);
> +}
> +
> +static inline void xvip_set_frame_size(struct xvip_device *xvip,
> +				       const struct v4l2_mbus_framefmt *format)
> +{
> +	xvip_write(xvip, XVIP_ACTIVE_SIZE,
> +		   (format->height << XVIP_ACTIVE_VSIZE_SHIFT) |
> +		   (format->width << XVIP_ACTIVE_HSIZE_SHIFT));
> +}
> +
> +static inline void xvip_get_frame_size(struct xvip_device *xvip,
> +				       struct v4l2_mbus_framefmt *format)
> +{
> +	u32 reg;
> +
> +	reg = xvip_read(xvip, XVIP_ACTIVE_SIZE);
> +	format->width = (reg & XVIP_ACTIVE_HSIZE_MASK) >>
> +			XVIP_ACTIVE_HSIZE_SHIFT;
> +	format->height = (reg & XVIP_ACTIVE_VSIZE_MASK) >>
> +			 XVIP_ACTIVE_VSIZE_SHIFT;
> +}
> +
> +static inline void xvip_enable_reg_update(struct xvip_device *xvip)
> +{
> +	xvip_set(xvip, XVIP_CTRL_CONTROL, XVIP_CTRL_CONTROL_REG_UPDATE);
> +}
> +
> +static inline void xvip_disable_reg_update(struct xvip_device *xvip)
> +{
> +	xvip_clr(xvip, XVIP_CTRL_CONTROL, XVIP_CTRL_CONTROL_REG_UPDATE);
> +}
> +
> +static inline void xvip_print_version(struct xvip_device *xvip)
> +{
> +	u32 version;
> +
> +	version = xvip_read(xvip, XVIP_CTRL_VERSION);
> +
> +	dev_info(xvip->dev, "device found, version %u.%02x%x\n",
> +		 ((version & XVIP_CTRL_VERSION_MAJOR_MASK) >>
> +		  XVIP_CTRL_VERSION_MAJOR_SHIFT),
> +		 ((version & XVIP_CTRL_VERSION_MINOR_MASK) >>
> +		  XVIP_CTRL_VERSION_MINOR_SHIFT),
> +		 ((version & XVIP_CTRL_VERSION_REVISION_MASK) >>
> +		  XVIP_CTRL_VERSION_REVISION_SHIFT));
> +}
> +
> +#endif /* __XILINX_VIP_H__ */
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
> new file mode 100644
> index 0000000..7fbecad
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.c
> @@ -0,0 +1,666 @@
> +/*
> + * Xilinx Video IP Composite Device
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
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +
> +#include "xilinx-dma.h"
> +#include "xilinx-vipp.h"
> +
> +#define XVIPP_DMA_S2MM				0
> +#define XVIPP_DMA_MM2S				1
> +
> +/**
> + * struct xvip_graph_entity - Entity in the video graph
> + * @list: list entry in a graph entities list
> + * @node: the entity's DT node
> + * @entity: media entity, from the corresponding V4L2 subdev
> + * @asd: subdev asynchronous registration information
> + * @subdev: V4L2 subdev
> + */
> +struct xvip_graph_entity {
> +	struct list_head list;
> +	struct device_node *node;
> +	struct media_entity *entity;
> +
> +	struct v4l2_async_subdev asd;
> +	struct v4l2_subdev *subdev;
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Graph Management
> + */
> +
> +static struct xvip_graph_entity *
> +xvip_graph_find_entity(struct xvip_composite_device *xdev,
> +		       const struct device_node *node)
> +{
> +	struct xvip_graph_entity *entity;
> +
> +	list_for_each_entry(entity, &xdev->entities, list) {
> +		if (entity->node == node)
> +			return entity;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int xvip_graph_build_one(struct xvip_composite_device *xdev,
> +				struct xvip_graph_entity *entity)
> +{
> +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
> +	struct media_entity *local = entity->entity;
> +	struct media_entity *remote;
> +	struct media_pad *local_pad;
> +	struct media_pad *remote_pad;
> +	struct xvip_graph_entity *ent;
> +	struct v4l2_of_link link;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	int ret = 0;
> +
> +	dev_dbg(xdev->dev, "creating links for entity %s\n", local->name);
> +
> +	while (1) {
> +		/* Get the next endpoint and parse its link. */
> +		next = of_graph_get_next_endpoint(entity->node, ep);
> +		if (next == NULL)
> +			break;
> +
> +		of_node_put(ep);
> +		ep = next;
> +
> +		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
> +
> +		ret = v4l2_of_parse_link(ep, &link);
> +		if (ret < 0) {
> +			dev_err(xdev->dev, "failed to parse link for %s\n",
> +				ep->full_name);
> +			continue;
> +		}
> +
> +		/* Skip sink ports, they will be processed from the other end of
> +		 * the link.
> +		 */
> +		if (link.local_port >= local->num_pads) {
> +			dev_err(xdev->dev, "invalid port number %u on %s\n",
> +				link.local_port, link.local_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		local_pad = &local->pads[link.local_port];
> +
> +		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
> +			dev_dbg(xdev->dev, "skipping sink port %s:%u\n",
> +				link.local_node->full_name, link.local_port);
> +			v4l2_of_put_link(&link);
> +			continue;
> +		}
> +
> +		/* Skip DMA engines, they will be processed separately. */
> +		if (link.remote_node == xdev->dev->of_node) {
> +			dev_dbg(xdev->dev, "skipping DMA port %s:%u\n",
> +				link.local_node->full_name, link.local_port);
> +			v4l2_of_put_link(&link);
> +			continue;
> +		}
> +
> +		/* Find the remote entity. */
> +		ent = xvip_graph_find_entity(xdev, link.remote_node);
> +		if (ent == NULL) {
> +			dev_err(xdev->dev, "no entity found for %s\n",
> +				link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -ENODEV;
> +			break;
> +		}
> +
> +		remote = ent->entity;
> +
> +		if (link.remote_port >= remote->num_pads) {
> +			dev_err(xdev->dev, "invalid port number %u on %s\n",
> +				link.remote_port, link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		remote_pad = &remote->pads[link.remote_port];
> +
> +		v4l2_of_put_link(&link);
> +
> +		/* Create the media link. */
> +		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
> +			local->name, local_pad->index,
> +			remote->name, remote_pad->index);
> +
> +		ret = media_entity_create_link(local, local_pad->index,
> +					       remote, remote_pad->index,
> +					       link_flags);
> +		if (ret < 0) {
> +			dev_err(xdev->dev,
> +				"failed to create %s:%u -> %s:%u link\n",
> +				local->name, local_pad->index,
> +				remote->name, remote_pad->index);
> +			break;
> +		}
> +	}
> +
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +static struct xvip_dma *
> +xvip_graph_find_dma(struct xvip_composite_device *xdev, unsigned int port)
> +{
> +	struct xvip_dma *dma;
> +
> +	list_for_each_entry(dma, &xdev->dmas, list) {
> +		if (dma->port == port)
> +			return dma;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int xvip_graph_build_dma(struct xvip_composite_device *xdev)
> +{
> +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
> +	struct device_node *node = xdev->dev->of_node;
> +	struct media_entity *source;
> +	struct media_entity *sink;
> +	struct media_pad *source_pad;
> +	struct media_pad *sink_pad;
> +	struct xvip_graph_entity *ent;
> +	struct v4l2_of_link link;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	struct xvip_dma *dma;
> +	int ret = 0;
> +
> +	dev_dbg(xdev->dev, "creating links for DMA engines\n");
> +
> +	while (1) {
> +		/* Get the next endpoint and parse its link. */
> +		next = of_graph_get_next_endpoint(node, ep);
> +		if (next == NULL)
> +			break;
> +
> +		of_node_put(ep);
> +		ep = next;
> +
> +		dev_dbg(xdev->dev, "processing endpoint %s\n", ep->full_name);
> +
> +		ret = v4l2_of_parse_link(ep, &link);
> +		if (ret < 0) {
> +			dev_err(xdev->dev, "failed to parse link for %s\n",
> +				ep->full_name);
> +			continue;
> +		}
> +
> +		/* Find the DMA engine. */
> +		dma = xvip_graph_find_dma(xdev, link.local_port);
> +		if (dma == NULL) {
> +			dev_err(xdev->dev, "no DMA engine found for port %u\n",
> +				link.local_port);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		dev_dbg(xdev->dev, "creating link for DMA engine %s\n",
> +			dma->video.name);
> +
> +		/* Find the remote entity. */
> +		ent = xvip_graph_find_entity(xdev, link.remote_node);
> +		if (ent == NULL) {
> +			dev_err(xdev->dev, "no entity found for %s\n",
> +				link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -ENODEV;
> +			break;
> +		}
> +
> +		if (link.remote_port >= ent->entity->num_pads) {
> +			dev_err(xdev->dev, "invalid port number %u on %s\n",
> +				link.remote_port, link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (dma->pad.flags & MEDIA_PAD_FL_SOURCE) {
> +			source = &dma->video.entity;
> +			source_pad = &dma->pad;
> +			sink = ent->entity;
> +			sink_pad = &sink->pads[link.remote_port];
> +		} else {
> +			source = ent->entity;
> +			source_pad = &source->pads[link.remote_port];
> +			sink = &dma->video.entity;
> +			sink_pad = &dma->pad;
> +		}
> +
> +		v4l2_of_put_link(&link);
> +
> +		/* Create the media link. */
> +		dev_dbg(xdev->dev, "creating %s:%u -> %s:%u link\n",
> +			source->name, source_pad->index,
> +			sink->name, sink_pad->index);
> +
> +		ret = media_entity_create_link(source, source_pad->index,
> +					       sink, sink_pad->index,
> +					       link_flags);
> +		if (ret < 0) {
> +			dev_err(xdev->dev,
> +				"failed to create %s:%u -> %s:%u link\n",
> +				source->name, source_pad->index,
> +				sink->name, sink_pad->index);
> +			break;
> +		}
> +	}
> +
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +static int xvip_graph_notify_complete(struct v4l2_async_notifier *notifier)
> +{
> +	struct xvip_composite_device *xdev =
> +		container_of(notifier, struct xvip_composite_device, notifier);
> +	struct xvip_graph_entity *entity;
> +	int ret;
> +
> +	dev_dbg(xdev->dev, "notify complete, all subdevs registered\n");
> +
> +	/* Create links for every entity. */
> +	list_for_each_entry(entity, &xdev->entities, list) {
> +		ret = xvip_graph_build_one(xdev, entity);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	/* Create links for DMA channels. */
> +	ret = xvip_graph_build_dma(xdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = v4l2_device_register_subdev_nodes(&xdev->v4l2_dev);
> +	if (ret < 0)
> +		dev_err(xdev->dev, "failed to register subdev nodes\n");
> +
> +	return ret;
> +}
> +
> +static int xvip_graph_notify_bound(struct v4l2_async_notifier *notifier,
> +				   struct v4l2_subdev *subdev,
> +				   struct v4l2_async_subdev *asd)
> +{
> +	struct xvip_composite_device *xdev =
> +		container_of(notifier, struct xvip_composite_device, notifier);
> +	struct xvip_graph_entity *entity;
> +
> +	/* Locate the entity corresponding to the bound subdev and store the
> +	 * subdev pointer.
> +	 */
> +	list_for_each_entry(entity, &xdev->entities, list) {
> +		if (entity->node != subdev->dev->of_node)
> +			continue;
> +
> +		if (entity->subdev) {
> +			dev_err(xdev->dev, "duplicate subdev for node %s\n",
> +				entity->node->full_name);
> +			return -EINVAL;
> +		}
> +
> +		dev_dbg(xdev->dev, "subdev %s bound\n", subdev->name);
> +		entity->entity = &subdev->entity;
> +		entity->subdev = subdev;
> +		return 0;
> +	}
> +
> +	dev_err(xdev->dev, "no entity for subdev %s\n", subdev->name);
> +	return -EINVAL;
> +}
> +
> +static int xvip_graph_parse_one(struct xvip_composite_device *xdev,
> +				struct device_node *node)
> +{
> +	struct xvip_graph_entity *entity;
> +	struct device_node *remote;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	int ret = 0;
> +
> +	dev_dbg(xdev->dev, "parsing node %s\n", node->full_name);
> +
> +	while (1) {
> +		next = of_graph_get_next_endpoint(node, ep);
> +		if (next == NULL)
> +			break;
> +
> +		of_node_put(ep);
> +		ep = next;
> +
> +		dev_dbg(xdev->dev, "handling endpoint %s\n", ep->full_name);
> +
> +		remote = of_graph_get_remote_port_parent(ep);
> +		if (remote == NULL) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		/* Skip entities that we have already processed. */
> +		if (remote == xdev->dev->of_node ||
> +		    xvip_graph_find_entity(xdev, remote)) {
> +			of_node_put(remote);
> +			continue;
> +		}
> +
> +		entity = devm_kzalloc(xdev->dev, sizeof(*entity), GFP_KERNEL);
> +		if (entity == NULL) {
> +			of_node_put(remote);
> +			ret = -ENOMEM;
> +			break;
> +		}
> +
> +		entity->node = remote;
> +		entity->asd.match_type = V4L2_ASYNC_MATCH_OF;
> +		entity->asd.match.of.node = remote;
> +		list_add_tail(&entity->list, &xdev->entities);
> +		xdev->num_subdevs++;
> +	}
> +
> +	of_node_put(ep);
> +	return ret;
> +}
> +
> +static int xvip_graph_parse(struct xvip_composite_device *xdev)
> +{
> +	struct xvip_graph_entity *entity;
> +	int ret;
> +
> +	/*
> +	 * Walk the links to parse the full graph. Start by parsing the
> +	 * composite node and then parse entities in turn. The list_for_each
> +	 * loop will handle entities added at the end of the list while walking
> +	 * the links.
> +	 */
> +	ret = xvip_graph_parse_one(xdev, xdev->dev->of_node);
> +	if (ret < 0)
> +		return 0;
> +
> +	list_for_each_entry(entity, &xdev->entities, list) {
> +		ret = xvip_graph_parse_one(xdev, entity->node);
> +		if (ret < 0)
> +			break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int xvip_graph_dma_init_one(struct xvip_composite_device *xdev,
> +				   struct device_node *node)
> +{
> +	struct xvip_dma *dma;
> +	enum v4l2_buf_type type;
> +	const char *direction;
> +	unsigned int index;
> +	int ret;
> +
> +	ret = of_property_read_string(node, "direction", &direction);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (strcmp(direction, "input") == 0)
> +		type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	else if (strcmp(direction, "output") == 0)
> +		type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
> +	else
> +		return -EINVAL;
> +
> +	of_property_read_u32(node, "reg", &index);
> +
> +	dma = devm_kzalloc(xdev->dev, sizeof(*dma), GFP_KERNEL);
> +	if (dma == NULL)
> +		return -ENOMEM;
> +
> +	ret = xvip_dma_init(xdev, dma, type, index);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "%s initialization failed\n",
> +			node->full_name);
> +		return ret;
> +	}
> +
> +	list_add_tail(&dma->list, &xdev->dmas);
> +
> +	return 0;
> +}
> +
> +static int xvip_graph_dma_init(struct xvip_composite_device *xdev)
> +{
> +	struct device_node *ports;
> +	struct device_node *port;
> +	int ret;
> +
> +	ports = of_get_child_by_name(xdev->dev->of_node, "ports");
> +	if (ports == NULL) {
> +		dev_err(xdev->dev, "ports node not present\n");
> +		return -EINVAL;
> +	}
> +
> +	for_each_child_of_node(ports, port) {
> +		ret = xvip_graph_dma_init_one(xdev, port);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static void xvip_graph_cleanup(struct xvip_composite_device *xdev)
> +{
> +	struct xvip_graph_entity *entityp;
> +	struct xvip_graph_entity *entity;
> +	struct xvip_dma *dmap;
> +	struct xvip_dma *dma;
> +
> +	v4l2_async_notifier_unregister(&xdev->notifier);
> +
> +	list_for_each_entry_safe(entity, entityp, &xdev->entities, list) {
> +		of_node_put(entity->node);
> +		list_del(&entity->list);
> +	}
> +
> +	list_for_each_entry_safe(dma, dmap, &xdev->dmas, list) {
> +		xvip_dma_cleanup(dma);
> +		list_del(&dma->list);
> +	}
> +}
> +
> +static int xvip_graph_init(struct xvip_composite_device *xdev)
> +{
> +	struct xvip_graph_entity *entity;
> +	struct v4l2_async_subdev **subdevs = NULL;
> +	unsigned int num_subdevs;
> +	unsigned int i;
> +	int ret;
> +
> +	/* Init the DMA channels. */
> +	ret = xvip_graph_dma_init(xdev);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "DMA initialization failed\n");
> +		goto done;
> +	}
> +
> +	/* Parse the graph to extract a list of subdevice DT nodes. */
> +	ret = xvip_graph_parse(xdev);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "graph parsing failed\n");
> +		goto done;
> +	}
> +
> +	if (!xdev->num_subdevs) {
> +		dev_err(xdev->dev, "no subdev found in graph\n");
> +		goto done;
> +	}
> +
> +	/* Register the subdevices notifier. */
> +	num_subdevs = xdev->num_subdevs;
> +	subdevs = devm_kzalloc(xdev->dev, sizeof(*subdevs) * num_subdevs,
> +			       GFP_KERNEL);
> +	if (subdevs == NULL) {
> +		ret = -ENOMEM;
> +		goto done;
> +	}
> +
> +	i = 0;
> +	list_for_each_entry(entity, &xdev->entities, list)
> +		subdevs[i++] = &entity->asd;
> +
> +	xdev->notifier.subdevs = subdevs;
> +	xdev->notifier.num_subdevs = num_subdevs;
> +	xdev->notifier.bound = xvip_graph_notify_bound;
> +	xdev->notifier.complete = xvip_graph_notify_complete;
> +
> +	ret = v4l2_async_notifier_register(&xdev->v4l2_dev, &xdev->notifier);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "notifier registration failed\n");
> +		goto done;
> +	}
> +
> +	ret = 0;
> +
> +done:
> +	if (ret < 0)
> +		xvip_graph_cleanup(xdev);
> +
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Media Controller and V4L2
> + */
> +
> +static void xvip_composite_v4l2_cleanup(struct xvip_composite_device *xdev)
> +{
> +	v4l2_device_unregister(&xdev->v4l2_dev);
> +	media_device_unregister(&xdev->media_dev);
> +}
> +
> +static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
> +{
> +	int ret;
> +
> +	xdev->media_dev.dev = xdev->dev;
> +	strlcpy(xdev->media_dev.model, "Xilinx Video Composite Device",
> +		sizeof(xdev->media_dev.model));
> +	xdev->media_dev.hw_revision = 0;
> +
> +	ret = media_device_register(&xdev->media_dev);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "media device registration failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	xdev->v4l2_dev.mdev = &xdev->media_dev;
> +	ret = v4l2_device_register(xdev->dev, &xdev->v4l2_dev);
> +	if (ret < 0) {
> +		dev_err(xdev->dev, "V4L2 device registration failed (%d)\n",
> +			ret);
> +		media_device_unregister(&xdev->media_dev);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Platform Device Driver
> + */
> +
> +static int xvip_composite_probe(struct platform_device *pdev)
> +{
> +	struct xvip_composite_device *xdev;
> +	int ret;
> +
> +	xdev = devm_kzalloc(&pdev->dev, sizeof(*xdev), GFP_KERNEL);
> +	if (!xdev)
> +		return -ENOMEM;
> +
> +	xdev->dev = &pdev->dev;
> +	INIT_LIST_HEAD(&xdev->entities);
> +	INIT_LIST_HEAD(&xdev->dmas);
> +
> +	ret = xvip_composite_v4l2_init(xdev);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = xvip_graph_init(xdev);
> +	if (ret < 0)
> +		goto error;
> +
> +	platform_set_drvdata(pdev, xdev);
> +
> +	dev_info(xdev->dev, "device registered\n");
> +
> +	return 0;
> +
> +error:
> +	xvip_composite_v4l2_cleanup(xdev);
> +	return ret;
> +}
> +
> +static int xvip_composite_remove(struct platform_device *pdev)
> +{
> +	struct xvip_composite_device *xdev = platform_get_drvdata(pdev);
> +
> +	xvip_graph_cleanup(xdev);
> +	xvip_composite_v4l2_cleanup(xdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id xvip_composite_of_id_table[] = {
> +	{ .compatible = "xlnx,video" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, xvip_composite_of_id_table);
> +
> +static struct platform_driver xvip_composite_driver = {
> +	.driver = {
> +		.name = "xilinx-video",
> +		.of_match_table = xvip_composite_of_id_table,
> +	},
> +	.probe = xvip_composite_probe,
> +	.remove = xvip_composite_remove,
> +};
> +
> +module_platform_driver(xvip_composite_driver);
> +
> +MODULE_AUTHOR("Laurent Pinchart <laurent.pinchart@ideasonboard.com>");
> +MODULE_DESCRIPTION("Xilinx Video IP Composite Driver");
> +MODULE_LICENSE("GPL v2");
> diff --git a/drivers/media/platform/xilinx/xilinx-vipp.h b/drivers/media/platform/xilinx/xilinx-vipp.h
> new file mode 100644
> index 0000000..7b26ad5
> --- /dev/null
> +++ b/drivers/media/platform/xilinx/xilinx-vipp.h
> @@ -0,0 +1,47 @@
> +/*
> + * Xilinx Video IP Composite Device
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
> +#ifndef __XILINX_VIPP_H__
> +#define __XILINX_VIPP_H__
> +
> +#include <linux/list.h>
> +#include <linux/mutex.h>
> +#include <media/media-device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-device.h>
> +
> +/**
> + * struct xvip_composite_device - Xilinx Video IP device structure
> + * @v4l2_dev: V4L2 device
> + * @media_dev: media device
> + * @dev: (OF) device
> + * @notifier: V4L2 asynchronous subdevs notifier
> + * @entities: entities in the graph as a list of xvip_graph_entity
> + * @num_subdevs: number of subdevs in the pipeline
> + * @dmas: list of DMA channels at the pipeline output and input
> + */
> +struct xvip_composite_device {
> +	struct v4l2_device v4l2_dev;
> +	struct media_device media_dev;
> +	struct device *dev;
> +
> +	struct v4l2_async_notifier notifier;
> +	struct list_head entities;
> +	unsigned int num_subdevs;
> +
> +	struct list_head dmas;
> +};
> +
> +#endif /* __XILINX_VIPP_H__ */
> 

Regards,

	Hans
