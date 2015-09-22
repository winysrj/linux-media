Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:44062 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756775AbbIVIwN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 04:52:13 -0400
Subject: Re: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
To: Bryan Wu <pengw@nvidia.com>, hansverk@cisco.com,
	linux-media@vger.kernel.org, treding@nvidia.com
References: <1442861755-22743-1-git-send-email-pengw@nvidia.com>
 <1442861755-22743-2-git-send-email-pengw@nvidia.com>
Cc: ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	davidw@nvidia.com, gfitzer@nvidia.com, bmurthyv@nvidia.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <560116B5.3070904@xs4all.nl>
Date: Tue, 22 Sep 2015 10:52:05 +0200
MIME-Version: 1.0
In-Reply-To: <1442861755-22743-2-git-send-email-pengw@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

Thanks for this v3 patch series. It looks very good now. I have a few comments,
I think they are trivial to add and then I would just wait for the new MC code
to be merged. I hope it will be soon, but it's a bit unpredictable.

On 21-09-15 20:55, Bryan Wu wrote:
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
>  drivers/media/platform/tegra/tegra-channel.c | 782 +++++++++++++++++++++++++++
>  drivers/media/platform/tegra/tegra-core.c    | 252 +++++++++
>  drivers/media/platform/tegra/tegra-core.h    | 162 ++++++
>  drivers/media/platform/tegra/tegra-csi.c     | 566 +++++++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.c      | 581 ++++++++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.h      | 209 +++++++
>  10 files changed, 2568 insertions(+)
>  create mode 100644 drivers/media/platform/tegra/Kconfig
>  create mode 100644 drivers/media/platform/tegra/Makefile
>  create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.h
>  create mode 100644 drivers/media/platform/tegra/tegra-csi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.h
> 
> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> index f6bed19..553867f 100644
> --- a/drivers/media/platform/Kconfig
> +++ b/drivers/media/platform/Kconfig
> @@ -119,6 +119,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
>  source "drivers/media/platform/s5p-tv/Kconfig"
>  source "drivers/media/platform/am437x/Kconfig"
>  source "drivers/media/platform/xilinx/Kconfig"
> +source "drivers/media/platform/tegra/Kconfig"
>  
>  endif # V4L_PLATFORM_DRIVERS
>  

<snip>

> diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media/platform/tegra/tegra-channel.c
> new file mode 100644
> index 0000000..37a7017
> --- /dev/null
> +++ b/drivers/media/platform/tegra/tegra-channel.c
> @@ -0,0 +1,782 @@
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
> +#include <linux/atomic.h>
> +#include <linux/bitmap.h>
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/host1x.h>
> +#include <linux/kthread.h>
> +#include <linux/freezer.h>
> +#include <linux/lcm.h>
> +#include <linux/list.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ioctl.h>
> +#include <media/videobuf2-core.h>
> +#include <media/videobuf2-dma-contig.h>
> +
> +#include <soc/tegra/pmc.h>
> +
> +#include "tegra-vi.h"
> +
> +#define TEGRA_VI_SYNCPT_WAIT_TIMEOUT			200
> +
> +/* VI registers */
> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT			0x000
> +#define   VI_CFG_VI_INCR_SYNCPT_COND(x)			(((x) & 0xff) << 8)
> +#define   VI_CSI_PP_LINE_START(port)			(4 + (port) * 4)
> +#define   VI_CSI_PP_FRAME_START(port)			(5 + (port) * 4)
> +#define   VI_CSI_MW_REQ_DONE(port)			(6 + (port) * 4)
> +#define   VI_CSI_MW_ACK_DONE(port)			(7 + (port) * 4)
> +
> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT_CNTRL		0x004
> +#define TEGRA_VI_CFG_VI_INCR_SYNCPT_ERROR		0x008
> +#define TEGRA_VI_CFG_CTXSW				0x020
> +#define TEGRA_VI_CFG_INTSTATUS				0x024
> +#define TEGRA_VI_CFG_PWM_CONTROL			0x038
> +#define TEGRA_VI_CFG_PWM_HIGH_PULSE			0x03c
> +#define TEGRA_VI_CFG_PWM_LOW_PULSE			0x040
> +#define TEGRA_VI_CFG_PWM_SELECT_PULSE_A			0x044
> +#define TEGRA_VI_CFG_PWM_SELECT_PULSE_B			0x048
> +#define TEGRA_VI_CFG_PWM_SELECT_PULSE_C			0x04c
> +#define TEGRA_VI_CFG_PWM_SELECT_PULSE_D			0x050
> +#define TEGRA_VI_CFG_VGP1				0x064
> +#define TEGRA_VI_CFG_VGP2				0x068
> +#define TEGRA_VI_CFG_VGP3				0x06c
> +#define TEGRA_VI_CFG_VGP4				0x070
> +#define TEGRA_VI_CFG_VGP5				0x074
> +#define TEGRA_VI_CFG_VGP6				0x078
> +#define TEGRA_VI_CFG_INTERRUPT_MASK			0x08c
> +#define TEGRA_VI_CFG_INTERRUPT_TYPE_SELECT		0x090
> +#define TEGRA_VI_CFG_INTERRUPT_POLARITY_SELECT		0x094
> +#define TEGRA_VI_CFG_INTERRUPT_STATUS			0x098
> +#define TEGRA_VI_CFG_VGP_SYNCPT_CONFIG			0x0ac
> +#define TEGRA_VI_CFG_VI_SW_RESET			0x0b4
> +#define TEGRA_VI_CFG_CG_CTRL				0x0b8
> +#define   VI_CG_2ND_LEVEL_EN				0x1
> +#define TEGRA_VI_CFG_VI_MCCIF_FIFOCTRL			0x0e4
> +#define TEGRA_VI_CFG_TIMEOUT_WCOAL_VI			0x0e8
> +#define TEGRA_VI_CFG_DVFS				0x0f0
> +#define TEGRA_VI_CFG_RESERVE				0x0f4
> +#define TEGRA_VI_CFG_RESERVE_1				0x0f8
> +
> +/* CSI registers */
> +#define TEGRA_VI_CSI_BASE(x)				(0x100 + (x) * 0x100)
> +
> +#define TEGRA_VI_CSI_SW_RESET				0x000
> +#define TEGRA_VI_CSI_SINGLE_SHOT			0x004
> +#define   SINGLE_SHOT_CAPTURE				0x1
> +#define TEGRA_VI_CSI_SINGLE_SHOT_STATE_UPDATE		0x008
> +#define TEGRA_VI_CSI_IMAGE_DEF				0x00c
> +#define   BYPASS_PXL_TRANSFORM_OFFSET			24
> +#define   IMAGE_DEF_FORMAT_OFFSET			16
> +#define   IMAGE_DEF_DEST_MEM				0x1
> +#define TEGRA_VI_CSI_RGB2Y_CTRL				0x010
> +#define TEGRA_VI_CSI_MEM_TILING				0x014
> +#define TEGRA_VI_CSI_IMAGE_SIZE				0x018
> +#define   IMAGE_SIZE_HEIGHT_OFFSET			16
> +#define TEGRA_VI_CSI_IMAGE_SIZE_WC			0x01c
> +#define TEGRA_VI_CSI_IMAGE_DT				0x020
> +#define TEGRA_VI_CSI_SURFACE0_OFFSET_MSB		0x024
> +#define TEGRA_VI_CSI_SURFACE0_OFFSET_LSB		0x028
> +#define TEGRA_VI_CSI_SURFACE1_OFFSET_MSB		0x02c
> +#define TEGRA_VI_CSI_SURFACE1_OFFSET_LSB		0x030
> +#define TEGRA_VI_CSI_SURFACE2_OFFSET_MSB		0x034
> +#define TEGRA_VI_CSI_SURFACE2_OFFSET_LSB		0x038
> +#define TEGRA_VI_CSI_SURFACE0_BF_OFFSET_MSB		0x03c
> +#define TEGRA_VI_CSI_SURFACE0_BF_OFFSET_LSB		0x040
> +#define TEGRA_VI_CSI_SURFACE1_BF_OFFSET_MSB		0x044
> +#define TEGRA_VI_CSI_SURFACE1_BF_OFFSET_LSB		0x048
> +#define TEGRA_VI_CSI_SURFACE2_BF_OFFSET_MSB		0x04c
> +#define TEGRA_VI_CSI_SURFACE2_BF_OFFSET_LSB		0x050
> +#define TEGRA_VI_CSI_SURFACE0_STRIDE			0x054
> +#define TEGRA_VI_CSI_SURFACE1_STRIDE			0x058
> +#define TEGRA_VI_CSI_SURFACE2_STRIDE			0x05c
> +#define TEGRA_VI_CSI_SURFACE_HEIGHT0			0x060
> +#define TEGRA_VI_CSI_ISPINTF_CONFIG			0x064
> +#define TEGRA_VI_CSI_ERROR_STATUS			0x084
> +#define TEGRA_VI_CSI_ERROR_INT_MASK			0x088
> +#define TEGRA_VI_CSI_WD_CTRL				0x08c
> +#define TEGRA_VI_CSI_WD_PERIOD				0x090
> +
> +/* Channel registers */
> +static void tegra_channel_write(struct tegra_channel *chan,
> +				unsigned int addr, u32 val)
> +{
> +	writel(val, chan->vi->iomem + addr);
> +}
> +
> +/* CSI registers */
> +static void csi_write(struct tegra_channel *chan, unsigned int addr, u32 val)
> +{
> +	writel(val, chan->csi + addr);
> +}
> +
> +static u32 csi_read(struct tegra_channel *chan, unsigned int addr)
> +{
> +	return readl(chan->csi + addr);
> +}
> +
> +/* CSI channel IO Rail IDs */
> +static const int tegra_io_rail_csi_ids[] = {
> +	TEGRA_IO_RAIL_CSIA,
> +	TEGRA_IO_RAIL_CSIB,
> +	TEGRA_IO_RAIL_CSIC,
> +	TEGRA_IO_RAIL_CSID,
> +	TEGRA_IO_RAIL_CSIE,
> +	TEGRA_IO_RAIL_CSIF,
> +};
> +
> +void tegra_channel_fmts_bitmap_init(struct tegra_channel *chan,
> +				    struct tegra_vi_graph_entity *entity)
> +{
> +	int ret, index;
> +	struct v4l2_subdev *subdev = entity->subdev;
> +	struct v4l2_subdev_mbus_code_enum code = {
> +		.which = V4L2_SUBDEV_FORMAT_ACTIVE,
> +	};
> +	struct v4l2_subdev_format fmt;
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
> +
> +	/* Get colorspace format infor from subdev */
> +	ret = v4l2_subdev_call(subdev, pad, get_fmt, NULL, &fmt);
> +	if (ret >= 0)
> +		chan->format.colorspace = fmt.format.colorspace;
> +
> +	return;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * Tegra channel frame setup and capture operations */
> +
> +static int tegra_channel_capture_setup(struct tegra_channel *chan)
> +{
> +	u32 height = chan->format.height;
> +	u32 width = chan->format.width;
> +	u32 format = chan->fmtinfo->img_fmt;
> +	u32 data_type = chan->fmtinfo->img_dt;
> +	u32 word_count = tegra_core_get_word_count(width, chan->fmtinfo);
> +
> +	csi_write(chan, TEGRA_VI_CSI_ERROR_STATUS, 0xFFFFFFFF);
> +	csi_write(chan, TEGRA_VI_CSI_IMAGE_DEF,
> +		  ((chan->vi->pg_mode ? 1 : 0) << BYPASS_PXL_TRANSFORM_OFFSET) |
> +		  (format << IMAGE_DEF_FORMAT_OFFSET) |
> +		  IMAGE_DEF_DEST_MEM);
> +	csi_write(chan, TEGRA_VI_CSI_IMAGE_DT, data_type);
> +	csi_write(chan, TEGRA_VI_CSI_IMAGE_SIZE_WC, word_count);
> +	csi_write(chan, TEGRA_VI_CSI_IMAGE_SIZE,
> +		  (height << IMAGE_SIZE_HEIGHT_OFFSET) | width);
> +	return 0;
> +}
> +
> +static void tegra_channel_capture_error(struct tegra_channel *chan)
> +{
> +	u32 val;
> +
> +	val = csi_read(chan, TEGRA_VI_CSI_ERROR_STATUS);
> +	dev_err(&chan->video.dev, "TEGRA_VI_CSI_ERROR_STATUS 0x%08x\n", val);
> +}
> +
> +static int tegra_channel_capture_frame(struct tegra_channel *chan,
> +				       struct tegra_channel_buffer *buf)
> +{
> +	struct vb2_buffer *vb = &buf->buf;
> +	int err = 0;
> +	u32 thresh, value, frame_start;
> +	int bytes_per_line = chan->format.bytesperline;
> +
> +	/* Program buffer address by using surface 0 */
> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_MSB, 0x0);
> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_LSB, buf->addr);
> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_STRIDE, bytes_per_line);
> +
> +	/* Program syncpoint */
> +	frame_start = VI_CSI_PP_FRAME_START(chan->port);
> +	value = VI_CFG_VI_INCR_SYNCPT_COND(frame_start) |
> +		host1x_syncpt_id(chan->sp);
> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
> +
> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, SINGLE_SHOT_CAPTURE);
> +
> +	/* Use syncpoint to wake up */
> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
> +	err = host1x_syncpt_wait(chan->sp, thresh,
> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
> +	if (err) {
> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
> +		tegra_channel_capture_error(chan);
> +	}
> +
> +	/* Captured one frame */
> +	spin_lock(&chan->queued_lock);

No need for this spin_lock here. The spin_lock protects the chan->capture list,
but you're not using that here. So it can just be dropped.

> +	vb->v4l2_buf.sequence = chan->sequence++;
> +	vb->v4l2_buf.field = V4L2_FIELD_NONE;
> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
> +	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
> +	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> +	spin_unlock(&chan->queued_lock);
> +
> +	return err;
> +}
> +
> +static int tegra_channel_kthread_capture(void *data)
> +{
> +	struct tegra_channel *chan = data;
> +	struct tegra_channel_buffer *buf;
> +
> +	set_freezable();
> +
> +	while (1) {
> +		try_to_freeze();
> +wait_again:
> +		wait_event_interruptible(chan->wait,
> +					 !list_empty(&chan->capture) ||
> +					 kthread_should_stop());
> +		if (kthread_should_stop())
> +			break;
> +
> +		spin_lock(&chan->queued_lock);
> +		if (list_empty(&chan->capture)) {
> +			spin_unlock(&chan->queued_lock);
> +			goto wait_again;

Rather than a goto, just use 'continue' here.

> +		}
> +		buf = list_entry(chan->capture.next,
> +				 struct tegra_channel_buffer, queue);
> +		list_del_init(&buf->queue);
> +		spin_unlock(&chan->queued_lock);
> +
> +		tegra_channel_capture_frame(chan, buf);
> +	}
> +
> +	return 0;
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 queue operations
> + */
> +
> +static int
> +tegra_channel_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> +			  unsigned int *nbuffers, unsigned int *nplanes,
> +			  unsigned int sizes[], void *alloc_ctxs[])
> +{
> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
> +
> +	/* Make sure the image size is large enough. */
> +	if (fmt && fmt->fmt.pix.sizeimage < chan->format.sizeimage)
> +		return -EINVAL;
> +
> +	*nplanes = 1;
> +
> +	sizes[0] = fmt ? fmt->fmt.pix.sizeimage : chan->format.sizeimage;
> +	alloc_ctxs[0] = chan->alloc_ctx;
> +
> +	return 0;
> +}
> +
> +static int tegra_channel_buffer_prepare(struct vb2_buffer *vb)
> +{
> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
> +
> +	buf->chan = chan;
> +	buf->addr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +
> +	return 0;
> +}
> +
> +static void tegra_channel_buffer_queue(struct vb2_buffer *vb)
> +{
> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
> +
> +	/* Put buffer into the capture queue */
> +	spin_lock(&chan->queued_lock);
> +	list_add_tail(&buf->queue, &chan->capture);
> +	spin_unlock(&chan->queued_lock);
> +
> +	/* Wait up kthread for capture */
> +	wake_up_interruptible(&chan->wait);
> +}
> +
> +static int tegra_channel_set_stream(struct tegra_channel *chan, bool on)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad = &chan->pad;
> +	struct v4l2_subdev *subdev;
> +	int ret = 0;
> +
> +	entity = &chan->video.entity;
> +
> +	while (1) {
> +		pad = media_entity_remote_pad(pad);
> +		if (pad == NULL ||
> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
> +			break;
> +
> +		entity = pad->entity;
> +		subdev = media_entity_to_v4l2_subdev(entity);
> +		subdev->host_priv = chan;
> +		ret = v4l2_subdev_call(subdev, video, s_stream, on);
> +		if (on && ret < 0 && ret != -ENOIOCTLCMD)
> +			return ret;
> +	}
> +	return ret;
> +}
> +
> +static int tegra_channel_start_streaming(struct vb2_queue *vq, u32 count)
> +{
> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
> +	struct media_pipeline *pipe = chan->video.entity.pipe;
> +	struct tegra_channel_buffer *buf, *nbuf;
> +	int ret = 0;
> +
> +	if (!chan->vi->pg_mode && !chan->vi->has_sensors)
> +		dev_warn(&chan->video.dev,
> +			"is not in TPG mode and might not have \
> +			 any sensor connected!\n");

I wouldn't do this here. I think a better place is where chan->vi->has_sensors is
assigned: if it is false, then use dev_info to inform that this channel has no
sensors (or really, no other subdevs) connected.

That way the information about this is logged, but you don't get this warning in
the log every time you stream. That would be annoying, especially if having no
sensors is perfectly fine.

> +
> +	/* The first open then turn on power*/
> +	if (atomic_add_return(1, &chan->vi->power_on_refcnt) == 1) {
> +		tegra_vi_power_on(chan->vi);
> +
> +		usleep_range(5, 100);
> +		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL,
> +				    VI_CG_2ND_LEVEL_EN);
> +		usleep_range(10, 15);
> +	}
> +
> +	/* Disable DPD */
> +	ret = tegra_io_rail_power_on(chan->io_id);
> +	if (ret < 0) {
> +		dev_err(&chan->video.dev,
> +			"failed to power on CSI rail: %d\n", ret);
> +		goto error_power_on;
> +	}
> +
> +	/* Clean up status */
> +	csi_write(chan, TEGRA_VI_CSI_ERROR_STATUS, 0xFFFFFFFF);
> +
> +	ret = media_entity_pipeline_start(&chan->video.entity, pipe);
> +	if (ret < 0)
> +		goto error_pipeline_start;
> +
> +	/* Start the pipeline. */
> +	ret = tegra_channel_set_stream(chan, true);
> +	if (ret < 0)
> +		goto error_set_stream;
> +
> +	/* Note: Program VI registers after TPG, sensors and CSI streaming */
> +	ret = tegra_channel_capture_setup(chan);
> +	if (ret < 0)
> +		goto error_capture_setup;
> +
> +	chan->sequence = 0;
> +
> +	/* Start kthread to capture data to buffer */
> +	chan->kthread_capture = kthread_run(tegra_channel_kthread_capture, chan,
> +					    chan->video.name);
> +	if (!IS_ERR(chan->kthread_capture))
> +		return 0;
> +
> +	dev_err(&chan->video.dev, "failed to start kthread for capture!\n");
> +	ret = PTR_ERR(chan->kthread_capture);
> +
> +error_capture_setup:
> +	tegra_channel_set_stream(chan, false);
> +error_set_stream:
> +	media_entity_pipeline_stop(&chan->video.entity);
> +error_pipeline_start:
> +	tegra_io_rail_power_off(chan->io_id);
> +error_power_on:
> +	/* Return all queued buffers back to vb2 */
> +	spin_lock(&chan->queued_lock);
> +	vq->start_streaming_called = 0;

This assignment shouldn't be needed anymore. I'm pretty sure you can drop it.
If you still need it, then let me know why.

> +	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
> +		list_del(&buf->queue);
> +	}
> +	spin_unlock(&chan->queued_lock);

Returning these buffers can be split off into a separate function that can
be called by both stop and start_streaming. Only the state argument differs.

> +	return ret;
> +}
> +
> +static void tegra_channel_stop_streaming(struct vb2_queue *vq)
> +{
> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
> +	struct tegra_channel_buffer *buf, *nbuf;
> +	u32 thresh, value, mw_ack_done;
> +	int err;
> +
> +	/* Stop the kthread for capture */
> +	kthread_stop(chan->kthread_capture);
> +	chan->kthread_capture = NULL;
> +
> +	/* Program syncpoint */
> +	mw_ack_done = VI_CSI_MW_ACK_DONE(chan->port);
> +	value = VI_CFG_VI_INCR_SYNCPT_COND(mw_ack_done) |
> +		host1x_syncpt_id(chan->sp);
> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
> +
> +	/* Use syncpoint to wake up */
> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
> +	err = host1x_syncpt_wait(chan->sp, thresh,
> +			TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
> +	if (err)
> +		dev_err(&chan->video.dev, "MW_ACK_DONE syncpoint time out!\n");
> +
> +	media_entity_pipeline_stop(&chan->video.entity);
> +
> +	tegra_channel_set_stream(chan, false);
> +
> +	tegra_io_rail_power_off(chan->io_id);
> +
> +	/* The last release then turn off power */
> +	if (atomic_dec_and_test(&chan->vi->power_on_refcnt))
> +		tegra_vi_power_off(chan->vi);
> +
> +	/* Give back all queued buffers to videobuf2. */
> +	spin_lock(&chan->queued_lock);
> +	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
> +		list_del(&buf->queue);
> +	}
> +	spin_unlock(&chan->queued_lock);
> +}
> +
> +static const struct vb2_ops tegra_channel_queue_qops = {
> +	.queue_setup = tegra_channel_queue_setup,
> +	.buf_prepare = tegra_channel_buffer_prepare,
> +	.buf_queue = tegra_channel_buffer_queue,
> +	.wait_prepare = vb2_ops_wait_prepare,
> +	.wait_finish = vb2_ops_wait_finish,
> +	.start_streaming = tegra_channel_start_streaming,
> +	.stop_streaming = tegra_channel_stop_streaming,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 ioctls
> + */
> +
> +static int
> +tegra_channel_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
> +
> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
> +
> +	strlcpy(cap->driver, "tegra-video", sizeof(cap->driver));
> +	strlcpy(cap->card, chan->video.name, sizeof(cap->card));
> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
> +		 dev_name(chan->vi->dev), chan->port);
> +
> +	return 0;
> +}
> +
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
> +		return -EINVAL;
> +
> +	for (i = 0; i < f->index + 1; i++, index++)
> +		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);
> +
> +	f->pixelformat = tegra_core_get_fourcc_by_idx(index - 1);
> +
> +	return 0;
> +}
> +
> +static int
> +tegra_channel_get_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
> +
> +	format->fmt.pix = chan->format;
> +
> +	return 0;
> +}
> +
> +static void
> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_format *pix,
> +			   const struct tegra_video_format **fmtinfo)
> +{
> +	const struct tegra_video_format *info;
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
> +	info = tegra_core_get_format_by_fourcc(pix->pixelformat);
> +	if (!info)
> +		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
> +
> +	pix->pixelformat = info->fourcc;
> +	/* Change this when start adding interlace format support */
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	/* The transfer alignment requirements are expressed in bytes. Compute
> +	 * the minimum and maximum values, clamp the requested width and convert
> +	 * it back to pixels.
> +	 */
> +	align = lcm(chan->align, info->bpp);
> +	min_width = roundup(TEGRA_MIN_WIDTH, align);
> +	max_width = rounddown(TEGRA_MAX_WIDTH, align);
> +	width = roundup(pix->width * info->bpp, align);
> +
> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
> +	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT, TEGRA_MAX_HEIGHT);
> +
> +	/* Clamp the requested bytes per line value. If the maximum bytes per
> +	 * line value is zero, the module doesn't support user configurable line
> +	 * sizes. Override the requested value with the minimum in that case.
> +	 */
> +	min_bpl = pix->width * info->bpp;
> +	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
> +	bpl = roundup(pix->bytesperline, chan->align);
> +
> +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> +	pix->sizeimage = pix->bytesperline * pix->height;
> +	pix->colorspace = chan->format.colorspace;

This information should be obtained by asking the subdev we're connected to.

An example of how that should be done is here:

https://patchwork.linuxtv.org/patch/30661/

Unfortunately, this depends on this patch:

https://patchwork.linuxtv.org/patch/30659/

And that can't be merged until the MC rework is done.

So just add this to your TODO list for the time being.

> +
> +	if (fmtinfo)
> +		*fmtinfo = info;
> +}
> +
> +static int
> +tegra_channel_try_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
> +
> +	__tegra_channel_try_format(chan, &format->fmt.pix, NULL);
> +
> +	return 0;
> +}
> +
> +static int
> +tegra_channel_set_format(struct file *file, void *fh, struct v4l2_format *format)
> +{
> +	struct v4l2_fh *vfh = file->private_data;
> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
> +	const struct tegra_video_format *info;
> +
> +	if (vb2_is_busy(&chan->queue))
> +		return -EBUSY;
> +
> +	__tegra_channel_try_format(chan, &format->fmt.pix, &info);
> +
> +	chan->format = format->fmt.pix;
> +	chan->fmtinfo = info;
> +
> +	return 0;
> +}
> +
> +static const struct v4l2_ioctl_ops tegra_channel_ioctl_ops = {
> +	.vidioc_querycap		= tegra_channel_querycap,
> +	.vidioc_enum_fmt_vid_cap	= tegra_channel_enum_format,
> +	.vidioc_g_fmt_vid_cap		= tegra_channel_get_format,
> +	.vidioc_s_fmt_vid_cap		= tegra_channel_set_format,
> +	.vidioc_try_fmt_vid_cap		= tegra_channel_try_format,
> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
> +	.vidioc_streamon		= vb2_ioctl_streamon,
> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> +};
> +
> +/* -----------------------------------------------------------------------------
> + * V4L2 file operations
> + */
> +
> +static const struct v4l2_file_operations tegra_channel_fops = {
> +	.owner		= THIS_MODULE,
> +	.unlocked_ioctl	= video_ioctl2,
> +	.open		= v4l2_fh_open,
> +	.release	= vb2_fop_release,
> +	.read		= vb2_fop_read,
> +	.poll		= vb2_fop_poll,
> +	.mmap		= vb2_fop_mmap,
> +};
> +
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
> +	mutex_init(&chan->video_lock);
> +	INIT_LIST_HEAD(&chan->capture);
> +	init_waitqueue_head(&chan->wait);
> +	spin_lock_init(&chan->queued_lock);
> +
> +	/* Init video format */
> +	chan->fmtinfo = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
> +	chan->format.pixelformat = chan->fmtinfo->fourcc;
> +	chan->format.colorspace = V4L2_COLORSPACE_SRGB;
> +	chan->format.field = V4L2_FIELD_NONE;
> +	chan->format.width = TEGRA_DEF_WIDTH;
> +	chan->format.height = TEGRA_DEF_HEIGHT;
> +	chan->format.bytesperline = chan->format.width * chan->fmtinfo->bpp;
> +	chan->format.sizeimage = chan->format.bytesperline *
> +				    chan->format.height;
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

Regards,

	Hans
