Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:48204 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753159AbbHUJ3l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Aug 2015 05:29:41 -0400
Message-ID: <55D6EF58.7030509@xs4all.nl>
Date: Fri, 21 Aug 2015 11:28:56 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Bryan Wu <pengw@nvidia.com>, hansverk@cisco.com,
	linux-media@vger.kernel.org
CC: ebrower@nvidia.com, jbang@nvidia.com, swarren@nvidia.com,
	treding@nvidia.com, wenjiaz@nvidia.com, davidw@nvidia.com,
	gfitzer@nvidia.com
Subject: Re: [PATCH 1/2] [media] v4l: tegra: Add NVIDIA Tegra VI driver
References: <1440118300-32491-1-git-send-email-pengw@nvidia.com> <1440118300-32491-5-git-send-email-pengw@nvidia.com>
In-Reply-To: <1440118300-32491-5-git-send-email-pengw@nvidia.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

Thanks for contributing this driver, very much appreciated.

I do have some comments below, basically about the same things we discussed
privately before.

On 08/21/2015 02:51 AM, Bryan Wu wrote:
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
>  drivers/media/platform/Kconfig               |    1 +
>  drivers/media/platform/Makefile              |    2 +
>  drivers/media/platform/tegra/Kconfig         |    9 +
>  drivers/media/platform/tegra/Makefile        |    3 +
>  drivers/media/platform/tegra/tegra-channel.c | 1074 ++++++++++++++++++++++++++
>  drivers/media/platform/tegra/tegra-core.c    |  295 +++++++
>  drivers/media/platform/tegra/tegra-core.h    |  134 ++++
>  drivers/media/platform/tegra/tegra-vi.c      |  585 ++++++++++++++
>  drivers/media/platform/tegra/tegra-vi.h      |  224 ++++++
>  include/dt-bindings/media/tegra-vi.h         |   35 +
>  10 files changed, 2362 insertions(+)
>  create mode 100644 drivers/media/platform/tegra/Kconfig
>  create mode 100644 drivers/media/platform/tegra/Makefile
>  create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.c
>  create mode 100644 drivers/media/platform/tegra/tegra-core.h
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>  create mode 100644 drivers/media/platform/tegra/tegra-vi.h
>  create mode 100644 include/dt-bindings/media/tegra-vi.h
> 

<snip>

> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
> +{
> +	struct tegra_channel_buffer *buf = chan->active;
> +	struct vb2_buffer *vb = &buf->buf;
> +	int err = 0;
> +	u32 thresh, value, frame_start;
> +	int bytes_per_line = chan->format.bytesperline;
> +
> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
> +		return -EINVAL;
> +
> +	if (chan->bypass)
> +		goto bypass_done;
> +
> +	/* Program buffer address */
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_MSB + chan->surface * 8,
> +		  0x0);
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_OFFSET_LSB + chan->surface * 8,
> +		  buf->addr);
> +	csi_write(chan,
> +		  TEGRA_VI_CSI_SURFACE0_STRIDE + chan->surface * 4,
> +		  bytes_per_line);
> +
> +	/* Program syncpoint */
> +	frame_start = sp_bit(chan, SP_PP_FRAME_START);
> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT,
> +			    frame_start | host1x_syncpt_id(chan->sp));
> +
> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, 0x1);
> +
> +	/* Use syncpoint to wake up */
> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
> +
> +	mutex_unlock(&chan->lock);
> +	err = host1x_syncpt_wait(chan->sp, thresh,
> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
> +	mutex_lock(&chan->lock);
> +
> +	if (err) {
> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
> +		tegra_channel_capture_error(chan, err);
> +	}
> +
> +bypass_done:
> +	/* Captured one frame */
> +	spin_lock_irq(&chan->queued_lock);
> +	vb->v4l2_buf.sequence = chan->sequence++;
> +	vb->v4l2_buf.field = V4L2_FIELD_NONE;
> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
> +	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
> +	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
> +	spin_unlock_irq(&chan->queued_lock);
> +
> +	return err;
> +}
> +
> +static void tegra_channel_work(struct work_struct *work)
> +{
> +	struct tegra_channel *chan =
> +		container_of(work, struct tegra_channel, work);
> +
> +	while (1) {
> +		spin_lock_irq(&chan->queued_lock);
> +		if (list_empty(&chan->capture)) {
> +			chan->active = NULL;
> +			spin_unlock_irq(&chan->queued_lock);
> +			return;
> +		}
> +		chan->active = list_entry(chan->capture.next,
> +				struct tegra_channel_buffer, queue);
> +		list_del_init(&chan->active->queue);
> +		spin_unlock_irq(&chan->queued_lock);
> +
> +		mutex_lock(&chan->lock);
> +		tegra_channel_capture_frame(chan);
> +		mutex_unlock(&chan->lock);
> +	}
> +}
> +
> +/* -----------------------------------------------------------------------------
> + * videobuf2 queue operations
> + */
> +
> +static int
> +tegra_channel_queue_setup(struct vb2_queue *vq, const struct v4l2_format *fmt,
> +		     unsigned int *nbuffers, unsigned int *nplanes,
> +		     unsigned int sizes[], void *alloc_ctxs[])
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
> +	/* Put buffer into the  capture queue */
> +	spin_lock_irq(&chan->queued_lock);
> +	list_add_tail(&buf->queue, &chan->capture);
> +	spin_unlock_irq(&chan->queued_lock);
> +
> +	/* Start work queue to capture data to buffer */
> +	if (vb2_start_streaming_called(&chan->queue))
> +		schedule_work(&chan->work);
> +}
> +
> +static int tegra_channel_set_stream(struct tegra_channel *chan, bool on)
> +{
> +	struct media_entity *entity;
> +	struct media_pad *pad;
> +	struct v4l2_subdev *subdev;
> +	int ret = 0;
> +
> +	entity = &chan->video.entity;
> +
> +	while (1) {
> +		if (entity->num_pads > 1 && (chan->port & 0x1))
> +			pad = &entity->pads[2];
> +		else
> +			pad = &entity->pads[0];
> +
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
> +	if (!chan->vi->pg_mode && !chan->remote_entity) {
> +		dev_err(&chan->video.dev,
> +			"is not in TPG mode and has not sensor connected!\n");
> +		ret = -EINVAL;
> +		goto vb2_queued;
> +	}
> +
> +	mutex_lock(&chan->lock);
> +
> +	/* Start CIL clock */
> +	clk_set_rate(chan->cil_clk, 102000000);
> +	clk_prepare_enable(chan->cil_clk);
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
> +	cil_write(chan, TEGRA_CSI_CIL_STATUS, 0xFFFFFFFF);
> +	cil_write(chan, TEGRA_CSI_CILX_STATUS, 0xFFFFFFFF);
> +	pp_write(chan, TEGRA_CSI_PIXEL_PARSER_STATUS, 0xFFFFFFFF);
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
> +	mutex_unlock(&chan->lock);
> +
> +	/* Start work queue to capture data to buffer */
> +	schedule_work(&chan->work);
> +
> +	return 0;
> +
> +error_capture_setup:
> +	tegra_channel_set_stream(chan, false);
> +error_set_stream:
> +	media_entity_pipeline_stop(&chan->video.entity);
> +error_pipeline_start:
> +	tegra_io_rail_power_off(chan->io_id);
> +error_power_on:
> +	clk_disable_unprepare(chan->cil_clk);
> +	mutex_unlock(&chan->lock);
> +vb2_queued:
> +	/* Return all queued buffers back to vb2 */
> +	spin_lock_irq(&chan->queued_lock);
> +	vq->start_streaming_called = 0;
> +	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
> +		list_del(&buf->queue);
> +	}
> +	spin_unlock_irq(&chan->queued_lock);
> +	return ret;
> +}

OK, so this whole sequence for running the DMA remains very confusing.

First of all, this needs more documentation, especially about the fact that this
uses shadow registers.

Secondly, at the very least you need to create per-channel workqueues instead of
using the global workqueue (schedule_work schedules the work on the global queue).

But I would replace the whole workqueue handling with per-channel kthreads instead:
where you call schedule_work above in start_streaming you start the thread. The
thread keeps going while there are buffers queued, and if no buffers are available
it will wait until it is woken up again. In buffer_queue you can wake up the thread
after queueing the buffer.

In stop streaming you stop the thread.

Doing it this way allows you to remove the 'vq->start_streaming_called = 0' line
above: the fact that you need it there is an indication that there is something
wrong with the design. The real problem is that buffer_queue does too much: buffer_queue
should just queue up the buffer for the DMA engine but it should never (re)start the
DMA engine. Starting and stopping should be handled in start/stop_streaming.

This keeps the design clean. I've seen other drivers that do similar things to what
is done here, and that always created a mess.

In addition, the way it works now in this driver is that the worker function is
called on start_streaming AND for every buffer_queue, so it looks like you can get
multiple worker functions running at the same time. It's all pretty weird.

Keeping all the DMA handling in a single thread makes the control mechanism much
cleaner.

<snip>

> +static void
> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_format *pix,
> +		      const struct tegra_video_format **fmtinfo)
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
> +		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF_FOURCC);
> +
> +	pix->pixelformat = info->fourcc;
> +	pix->field = V4L2_FIELD_NONE;
> +
> +	/* The transfer alignment requirements are expressed in bytes. Compute
> +	 * the minimum and maximum values, clamp the requested width and convert
> +	 * it back to pixels.
> +	 */
> +	align = lcm(chan->align, info->bpp);
> +	min_width = roundup(TEGRA_MIN_WIDTH, align);
> +	max_width = rounddown(TEGRA_MAX_WIDTH, align);
> +	width = rounddown(pix->width * info->bpp, align);
> +
> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
> +	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT,
> +			    TEGRA_MAX_HEIGHT);
> +
> +	/* Clamp the requested bytes per line value. If the maximum bytes per
> +	 * line value is zero, the module doesn't support user configurable line
> +	 * sizes. Override the requested value with the minimum in that case.
> +	 */
> +	min_bpl = pix->width * info->bpp;
> +	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
> +	bpl = rounddown(pix->bytesperline, chan->align);
> +
> +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
> +	pix->sizeimage = pix->bytesperline * pix->height;

The colorspace is still not set: using the test pattern generator as a source
I would select SRGB for Bayer and RGB pixelformats and REC709 for YUV pixelformats.

> +
> +	if (fmtinfo)
> +		*fmtinfo = info;
> +}

<snip>

> +static int tegra_channel_v4l2_open(struct file *file)
> +{
> +	struct tegra_channel *chan = video_drvdata(file);
> +	struct tegra_vi_device *vi = chan->vi;
> +	int ret = 0;
> +
> +	mutex_lock(&vi->lock);
> +	ret = v4l2_fh_open(file);
> +	if (ret)
> +		goto unlock;
> +
> +	/* The first open then turn on power*/
> +	if (!vi->power_on_refcnt) {

Instead of using your own counter you can also call:

	if (v4l2_fh_is_singular_file(file)) {

> +		tegra_vi_power_on(chan->vi);
> +
> +		usleep_range(5, 100);
> +		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL, 1);
> +		tegra_channel_write(chan, TEGRA_CSI_CLKEN_OVERRIDE, 0);
> +		usleep_range(10, 15);
> +	}
> +	vi->power_on_refcnt++;
> +
> +unlock:
> +	mutex_unlock(&vi->lock);
> +	return ret;
> +}
> +
> +static int tegra_channel_v4l2_release(struct file *file)
> +{
> +	struct tegra_channel *chan = video_drvdata(file);
> +	struct tegra_vi_device *vi = chan->vi;
> +	int ret = 0;
> +
> +	mutex_lock(&vi->lock);
> +	vi->power_on_refcnt--;
> +	/* The last release then turn off power */
> +	if (!vi->power_on_refcnt)

And here do the same:

	if (v4l2_fh_is_singular_file(file)) {

> +		tegra_vi_power_off(chan->vi);
> +	ret = _vb2_fop_release(file, NULL);

Is this the correct order? What if you are streaming and while streaming
close the filehandle? Will the fact that the power is turned off before
stop_streaming is called (_vb2_fop_release will call that) cause a problem?

> +	mutex_unlock(&vi->lock);
> +
> +	return ret;
> +}

Regards,

	Hans

