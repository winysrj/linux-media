Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:44061 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbbLJKKp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2015 05:10:45 -0500
Subject: Re: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
To: Bryan Wu <pengw@nvidia.com>, hansverk@cisco.com,
	linux-media@vger.kernel.org, treding@nvidia.com,
	linux-tegra@vger.kernel.org
References: <1447271448-30056-1-git-send-email-pengw@nvidia.com>
 <1447271448-30056-2-git-send-email-pengw@nvidia.com>
Cc: ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	davidw@nvidia.com, bmurthyv@nvidia.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56695050.9070103@xs4all.nl>
Date: Thu, 10 Dec 2015 11:13:36 +0100
MIME-Version: 1.0
In-Reply-To: <1447271448-30056-2-git-send-email-pengw@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

I came across a few bugs, see comments in the code:

On 11/11/15 20:50, Bryan Wu wrote:
> NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
> controller which can support up to 6 MIPI CSI camera sensors.
> 
> This patch adds a V4L2 media controller and capture driver to support
> Tegra VI hardware. It's verified with Tegra built-in test pattern
> generator.
> 
> Signed-off-by: Bryan Wu <pengw@nvidia.com>
> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/platform/Kconfig               |   1 +
>  drivers/media/platform/Makefile              |   2 +
>  drivers/media/platform/tegra/Kconfig         |  10 +
>  drivers/media/platform/tegra/Makefile        |   3 +
>  drivers/media/platform/tegra/tegra-channel.c | 849 +++++++++++++++++++++++++++
>  drivers/media/platform/tegra/tegra-core.c    | 254 ++++++++
>  drivers/media/platform/tegra/tegra-core.h    | 162 +++++
>  drivers/media/platform/tegra/tegra-csi.c     | 560 ++++++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.c      | 732 +++++++++++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.h      | 213 +++++++
>  10 files changed, 2786 insertions(+)
>  create mode 100644 drivers/media/platform/tegra/Kconfig
>  create mode 100644 drivers/media/platform/tegra/Makefile
>  create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.h
>  create mode 100644 drivers/media/platform/tegra/tegra-csi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.h
> 

<snip>

> diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media/platform/tegra/tegra-channel.c
> new file mode 100644
> index 0000000..63eb942
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-channel.c
> @@ -0,0 +1,849 @@

<snip>

> +void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan,
> +				    struct tegra_vi_graph_entity *entity)
> +{
> +	int ret, index;
> +	struct v4l2_subdev *subdev = entity->subdev;
> +	struct v4l2_subdev_mbus_code_enum code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +
> +	bitmap_zero(chan->fmts_bitmap, MAX_FORMAT_NUM);
> +
> +	while (1) {
> +		ret = v4l2_subdev_call(subdev, pad, enum_mbus_code,
> +				       NULL, &code);
> +		if (ret < 0)
> +			/* no more formats */
> +			break;
> +
> +		index = tegra_core_get_idx_by_code(code.code);
> +		if (index >= 0)
> +			bitmap_set(chan->fmts_bitmap, index, 1);
> +
> +		code.index++;
> +	}
> +}

See comments below in tegra_channel_init().

<snip>

> +static int
> +tegra_channel_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
> +	unsigned int index = 0, i;
> +	unsigned long *fmts_bitmap = NULL;
> +
> +	if (chan->vi->pg_mode)
> +		fmts_bitmap = chan->vi->tpg_fmts_bitmap;
> +	else
> +		fmts_bitmap = chan->fmts_bitmap;
> +
> +	if (f->index > bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM) - 1)

This should be:

	if (f->index >= bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM))

If fmts_bitmap is all zeroes then this condition worked out to 'if (0 > -1)'
where 0 is unsigned, so this goes into an infinite loop.

> +		return -EINVAL;
> +
> +	for (i = 0; i < f->index + 1; i++, index++)
> +		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);
> +
> +	f->pixelformat = tegra_core_get_fourcc_by_idx(index - 1);
> +
> +	return 0;
> +}

<snip>

> +int tegra_channel_init(struct tegra_vi *vi, unsigned int port)
> +{
> +	int ret;
> +	struct tegra_channel *chan  = &vi->chans[port];
> +
> +	chan->vi = vi;
> +	chan->port = port;
> +
> +	/* Init channel register base */
> +	chan->csi = vi->iomem + TEGRA_VI_CSI_BASE(port);
> +
> +	/* VI Channel is 64 bytes alignment */
> +	chan->align = 64;
> +	chan->io_id = tegra_io_rail_csi_ids[chan->port];
> +
> +	mutex_init(&chan->video_lock);
> +	INIT_LIST_HEAD(&chan->capture);
> +	INIT_LIST_HEAD(&chan->done);
> +	spin_lock_init(&chan->start_lock);
> +	spin_lock_init(&chan->done_lock);
> +	init_waitqueue_head(&chan->start_wait);
> +	init_waitqueue_head(&chan->done_wait);
> +
> +	/* Init video format */
> +	chan->fmtinfo = tegra_core_get_format_by_code(TEGRA_VF_DEF);
> +	chan->format.pixelformat = chan->fmtinfo->fourcc;
> +	chan->format.colorspace = V4L2_COLORSPACE_SRGB;
> +	chan->format.field = V4L2_FIELD_NONE;
> +	chan->format.width = TEGRA_DEF_WIDTH;
> +	chan->format.height = TEGRA_DEF_HEIGHT;
> +	chan->format.bytesperline = chan->format.width * chan->fmtinfo->bpp;
> +	chan->format.sizeimage = chan->format.bytesperline *
> +				    chan->format.height;


This sets the chan->format to a fixed default format, but if the subdev attached
to the channel doesn't support that format you'll have an inconsistent pipeline.

One option is to query the subdev for the current format and set the channel
format to that one. You may need to adapt tegra_channel_fmts_bitmap_init() as
well since the default format of the subdev may not be a format that this driver
can support. You can also just set the mediabus format of the subdev to the
first valid format in tegra_channel_fmts_bitmap_init() and fill in chan->format
based on that.

> +
> +	/* Initialize the media entity... */
> +	chan->pad.flags = MEDIA_PAD_FL_SINK;
> +
> +	ret = media_entity_init(&chan->video.entity, 1, &chan->pad, 0);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* ... and the video node... */
> +	chan->video.fops = &tegra_channel_fops;
> +	chan->video.v4l2_dev = &vi->v4l2_dev;
> +	chan->video.queue = &chan->queue;
> +	snprintf(chan->video.name, sizeof(chan->video.name), "%s-%s-%u",
> +		 dev_name(vi->dev), "output", port);
> +	chan->video.vfl_type = VFL_TYPE_GRABBER;
> +	chan->video.vfl_dir = VFL_DIR_RX;
> +	chan->video.release = video_device_release_empty;
> +	chan->video.ioctl_ops = &tegra_channel_ioctl_ops;
> +	chan->video.lock = &chan->video_lock;
> +
> +	video_set_drvdata(&chan->video, chan);
> +
> +	/* Init host1x interface */
> +	INIT_LIST_HEAD(&chan->client.list);
> +	chan->client.dev = chan->vi->dev;
> +
> +	ret = host1x_client_register(&chan->client);
> +	if (ret < 0) {
> +		dev_err(chan->vi->dev, "failed to register host1x client: %d\n",
> +			ret);
> +		ret = -ENODEV;
> +		goto host1x_register_error;
> +	}
> +
> +	chan->sp = host1x_syncpt_request(chan->client.dev,
> +					 HOST1X_SYNCPT_HAS_BASE);
> +	if (!chan->sp) {
> +		dev_err(chan->vi->dev, "failed to request host1x syncpoint\n");
> +		ret = -ENOMEM;
> +		goto host1x_sp_error;
> +	}
> +
> +	/* ... and the buffers queue... */
> +	chan->alloc_ctx = vb2_dma_contig_init_ctx(&chan->video.dev);

There is no way this can work! video.dev is the /dev/video character device, but this
should be the device that does the DMA transfer, which is chan->vi->dev.

> +	if (IS_ERR(chan->alloc_ctx)) {
> +		dev_err(chan->vi->dev, "failed to init vb2 buffer\n");
> +		ret = -ENOMEM;
> +		goto vb2_init_error;
> +	}
> +
> +	chan->queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	chan->queue.io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
> +	chan->queue.lock = &chan->video_lock;
> +	chan->queue.drv_priv = chan;
> +	chan->queue.buf_struct_size = sizeof(struct tegra_channel_buffer);
> +	chan->queue.ops = &tegra_channel_queue_qops;
> +	chan->queue.mem_ops = &vb2_dma_contig_memops;
> +	chan->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
> +				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
> +	ret = vb2_queue_init(&chan->queue);
> +	if (ret < 0) {
> +		dev_err(chan->vi->dev, "failed to initialize VB2 queue\n");
> +		goto vb2_queue_error;
> +	}
> +
> +	ret = video_register_device(&chan->video, VFL_TYPE_GRABBER, -1);
> +	if (ret < 0) {
> +		dev_err(&chan->video.dev, "failed to register video device\n");
> +		goto video_register_error;
> +	}
> +
> +	return 0;
> +
> +video_register_error:
> +	vb2_queue_release(&chan->queue);
> +vb2_queue_error:
> +	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
> +vb2_init_error:
> +	host1x_syncpt_free(chan->sp);
> +host1x_sp_error:
> +	host1x_client_unregister(&chan->client);
> +host1x_register_error:
> +	media_entity_cleanup(&chan->video.entity);
> +	return ret;
> +}
> +
> +int tegra_channel_cleanup(struct tegra_channel *chan)
> +{
> +	video_unregister_device(&chan->video);
> +
> +	vb2_queue_release(&chan->queue);
> +	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
> +
> +	host1x_syncpt_free(chan->sp);
> +	host1x_client_unregister(&chan->client);
> +
> +	media_entity_cleanup(&chan->video.entity);
> +
> +	return 0;
> +}

<snip>

> diff --git a/drivers/media/platform/tegra/tegra-vi.c b/drivers/media/platform/tegra/tegra-vi.c
> new file mode 100644
> index 0000000..6cc7395
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-vi.c
> @@ -0,0 +1,732 @@
> +/*
> + * NVIDIA Tegra Video Input Device
> + *
> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
> + *
> + * Author: Bryan Wu <pengw@nvidia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_graph.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/reset.h>
> +#include <linux/slab.h>
> +
> +#include <media/media-device.h>
> +#include <media/v4l2-async.h>
> +#include <media/v4l2-common.h>
> +#include <media/v4l2-device.h>
> +#include <media/v4l2-of.h>
> +
> +#include <soc/tegra/pmc.h>
> +
> +#include "tegra-vi.h"
> +
> +/* In TPG mode, VI only support 2 formats */
> +static void vi_tpg_fmts_bitmap_init(struct tegra_vi *vi)
> +{
> +	int index;
> +
> +	bitmap_zero(vi->tpg_fmts_bitmap, MAX_FORMAT_NUM);
> +
> +	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_SRGGB10_1X10);
> +	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
> +
> +	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_RGB888_1X32_PADHI);
> +	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
> +}
> +
> +/*
> + * Control Config
> + */
> +
> +static const char *const vi_pattern_strings[] = {
> +	"Disabled",
> +	"Black/White Direct Mode",
> +	"Color Patch Mode",
> +};
> +
> +static int vi_s_ctrl(struct v4l2_ctrl *ctrl)
> +{
> +	struct tegra_vi *vi = container_of(ctrl->handler, struct tegra_vi,
> +					   ctrl_handler);
> +	switch (ctrl->id) {
> +	case V4L2_CID_TEST_PATTERN:
> +		vi->pg_mode = ctrl->val;
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ctrl_ops vi_ctrl_ops = {
> +	.s_ctrl	= vi_s_ctrl,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * Media Controller and V4L2
> + */
> +
> +static void tegra_vi_v4l2_cleanup(struct tegra_vi *vi)
> +{
> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
> +	v4l2_device_unregister(&vi->v4l2_dev);
> +	media_device_unregister(&vi->media_dev);
> +}
> +
> +static int tegra_vi_v4l2_init(struct tegra_vi *vi)
> +{
> +	int ret;
> +
> +	vi->media_dev.dev = vi->dev;
> +	strlcpy(vi->media_dev.model, "NVIDIA Tegra Video Input Device",
> +		sizeof(vi->media_dev.model));
> +	vi->media_dev.hw_revision = 3;
> +
> +	ret = media_device_register(&vi->media_dev);
> +	if (ret < 0) {
> +		dev_err(vi->dev, "media device registration failed (%d)\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	vi->v4l2_dev.mdev = &vi->media_dev;
> +	ret = v4l2_device_register(vi->dev, &vi->v4l2_dev);
> +	if (ret < 0) {
> +		dev_err(vi->dev, "V4L2 device registration failed (%d)\n",
> +			ret);
> +		goto register_error;
> +	}
> +
> +	v4l2_ctrl_handler_init(&vi->ctrl_handler, 1);
> +	vi->pattern = v4l2_ctrl_new_std_menu_items(&vi->ctrl_handler,
> +					&vi_ctrl_ops, V4L2_CID_TEST_PATTERN,
> +					ARRAY_SIZE(vi_pattern_strings) - 1,
> +					0, 0, vi_pattern_strings);
> +
> +	if (vi->ctrl_handler.error) {
> +		dev_err(vi->dev, "failed to add controls\n");
> +		ret = vi->ctrl_handler.error;
> +		goto ctrl_error;
> +	}
> +	vi->v4l2_dev.ctrl_handler = &vi->ctrl_handler;
> +
> +	ret = v4l2_ctrl_handler_setup(&vi->ctrl_handler);
> +	if (ret < 0) {
> +		dev_err(vi->dev, "failed to set controls\n");
> +		goto ctrl_error;
> +	}
> +	return 0;
> +
> +
> +ctrl_error:
> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
> +	v4l2_device_unregister(&vi->v4l2_dev);
> +register_error:
> +	media_device_unregister(&vi->media_dev);
> +	return ret;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Platform Device Driver
> + */
> +
> +int tegra_vi_power_on(struct tegra_vi *vi)
> +{
> +	int ret;
> +
> +	ret = regulator_enable(vi->vi_reg);
> +	if (ret)
> +		return ret;
> +
> +	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VENC,
> +						vi->vi_clk, vi->vi_rst);
> +	if (ret) {
> +		dev_err(vi->dev, "failed to power up!\n");
> +		goto error_power_up;
> +	}
> +
> +	ret = clk_set_rate(vi->vi_clk, 408000000);
> +	if (ret) {
> +		dev_err(vi->dev, "failed to set vi clock to 408MHz!\n");
> +		goto error_clk_set_rate;
> +	}
> +
> +	clk_prepare_enable(vi->csi_clk);
> +
> +	return 0;
> +
> +error_clk_set_rate:
> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
> +error_power_up:
> +	regulator_disable(vi->vi_reg);
> +	return ret;
> +}
> +
> +void tegra_vi_power_off(struct tegra_vi *vi)
> +{
> +	reset_control_assert(vi->vi_rst);
> +	clk_disable_unprepare(vi->vi_clk);
> +	clk_disable_unprepare(vi->csi_clk);
> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
> +	regulator_disable(vi->vi_reg);
> +}
> +
> +static int tegra_vi_channels_init(struct tegra_vi *vi)
> +{
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
> +		ret = tegra_channel_init(vi, i);
> +		if (ret < 0) {
> +			dev_err(vi->dev, "channel %d init failed\n", i);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int tegra_vi_channels_cleanup(struct tegra_vi *vi)
> +{
> +	unsigned int i;
> +	int ret;
> +
> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
> +		ret = tegra_channel_cleanup(&vi->chans[i]);
> +		if (ret < 0) {
> +			dev_err(vi->dev, "channel %d cleanup failed\n", i);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Graph Management
> + */
> +
> +static struct tegra_vi_graph_entity *
> +tegra_vi_graph_find_entity(struct tegra_vi *vi,
> +		       const struct device_node *node)
> +{
> +	struct tegra_vi_graph_entity *entity;
> +
> +	list_for_each_entry(entity, &vi->entities, list) {
> +		if (entity->node == node)
> +			return entity;
> +	}
> +
> +	return NULL;
> +}
> +
> +static int tegra_vi_graph_build_one(struct tegra_vi *vi,
> +				    struct tegra_vi_graph_entity *entity)
> +{
> +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
> +	struct media_entity *local = entity->entity;
> +	struct media_entity *remote;
> +	struct media_pad *local_pad;
> +	struct media_pad *remote_pad;
> +	struct tegra_vi_graph_entity *ent;
> +	struct v4l2_of_link link;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	int ret = 0;
> +
> +	dev_dbg(vi->dev, "creating links for entity %s\n", local->name);
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
> +		dev_dbg(vi->dev, "processing endpoint %s\n", ep->full_name);
> +
> +		ret = v4l2_of_parse_link(ep, &link);
> +		if (ret < 0) {
> +			dev_err(vi->dev, "failed to parse link for %s\n",
> +				ep->full_name);
> +			continue;
> +		}
> +
> +		/* Skip sink ports, they will be processed from the other end of
> +		 * the link.
> +		 */
> +		if (link.local_port >= local->num_pads) {
> +			dev_err(vi->dev, "invalid port number %u on %s\n",
> +				link.local_port, link.local_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		local_pad = &local->pads[link.local_port];
> +
> +		if (local_pad->flags & MEDIA_PAD_FL_SINK) {
> +			dev_dbg(vi->dev, "skipping sink port %s:%u\n",
> +				link.local_node->full_name, link.local_port);
> +			v4l2_of_put_link(&link);
> +			continue;
> +		}
> +
> +		/* Skip channel entity , they will be processed separately. */
> +		if (link.remote_node == vi->dev->of_node) {
> +			dev_dbg(vi->dev, "skipping channel port %s:%u\n",
> +				link.local_node->full_name, link.local_port);
> +			v4l2_of_put_link(&link);
> +			continue;
> +		}
> +
> +		/* Find the remote entity. */
> +		ent = tegra_vi_graph_find_entity(vi, link.remote_node);
> +		if (ent == NULL) {
> +			dev_err(vi->dev, "no entity found for %s\n",
> +				link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -ENODEV;
> +			break;
> +		}
> +
> +		remote = ent->entity;
> +
> +		if (link.remote_port >= remote->num_pads) {
> +			dev_err(vi->dev, "invalid port number %u on %s\n",
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
> +		dev_dbg(vi->dev, "creating %s:%u -> %s:%u link\n",
> +			local->name, local_pad->index,
> +			remote->name, remote_pad->index);
> +
> +		ret = media_entity_create_link(local, local_pad->index,
> +					       remote, remote_pad->index,
> +					       link_flags);
> +		if (ret < 0) {
> +			dev_err(vi->dev,
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
> +static int tegra_vi_graph_build_links(struct tegra_vi *vi)
> +{
> +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
> +	struct device_node *node = vi->dev->of_node;
> +	struct media_entity *source;
> +	struct media_entity *sink;
> +	struct media_pad *source_pad;
> +	struct media_pad *sink_pad;
> +	struct tegra_vi_graph_entity *ent;
> +	struct v4l2_of_link link;
> +	struct device_node *ep = NULL;
> +	struct device_node *next;
> +	struct tegra_channel *chan;
> +	int ret = 0;
> +
> +	dev_dbg(vi->dev, "creating links for channels\n");
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
> +		dev_dbg(vi->dev, "processing endpoint %s\n", ep->full_name);
> +
> +		ret = v4l2_of_parse_link(ep, &link);
> +		if (ret < 0) {
> +			dev_err(vi->dev, "failed to parse link for %s\n",
> +				ep->full_name);
> +			continue;
> +		}
> +
> +		if (link.local_port > MAX_CHAN_NUM) {
> +			dev_err(vi->dev, "wrong channel number for port %u\n",
> +				link.local_port);
> +			v4l2_of_put_link(&link);
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		chan = &vi->chans[link.local_port];
> +
> +		dev_dbg(vi->dev, "creating link for channel %s\n",
> +			chan->video.name);
> +
> +		/* Find the remote entity. */
> +		ent = tegra_vi_graph_find_entity(vi, link.remote_node);
> +		if (ent == NULL) {
> +			dev_err(vi->dev, "no entity found for %s\n",
> +				link.remote_node->full_name);
> +			v4l2_of_put_link(&link);
> +			ret = -ENODEV;
> +			break;
> +		}
> +
> +		source = ent->entity;
> +		source_pad = &source->pads[link.remote_port];
> +		sink = &chan->video.entity;
> +		sink_pad = &chan->pad;
> +
> +		v4l2_of_put_link(&link);
> +
> +		/* Create the media link. */
> +		dev_dbg(vi->dev, "creating %s:%u -> %s:%u link\n",
> +			source->name, source_pad->index,
> +			sink->name, sink_pad->index);
> +
> +		ret = media_entity_create_link(source, source_pad->index,
> +					       sink, sink_pad->index,
> +					       link_flags);
> +		if (ret < 0) {
> +			dev_err(vi->dev,
> +				"failed to create %s:%u -> %s:%u link\n",
> +				source->name, source_pad->index,
> +				sink->name, sink_pad->index);
> +			break;
> +		}
> +
> +		tegra_channel_fmts_bitmap_init(chan, ent);

I don't think this works. The entity here is the csi subdev, but what you want to
determine the available formats is the actual sensor subdev. I.e., what is hooked
up as source to the csi subdev.

> +	}
> +
> +	of_node_put(ep);
> +	return ret;
> +}

<snip>

Regards,

	Hans
