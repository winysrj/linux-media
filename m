Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7576 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbbIUSqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2015 14:46:44 -0400
From: Bryan Wu <pengw@nvidia.com>
Subject: Re: [PATCH 1/3] [media] v4l: tegra: Add NVIDIA Tegra VI driver
To: Hans Verkuil <hverkuil@xs4all.nl>, <hansverk@cisco.com>,
	<linux-media@vger.kernel.org>, <treding@nvidia.com>
References: <1442367331-20046-1-git-send-email-pengw@nvidia.com>
 <1442367331-20046-2-git-send-email-pengw@nvidia.com>
 <55F932CA.2020502@xs4all.nl>
CC: <ebrower@nvidia.com>, <jbang@nvidia.com>, <swarren@nvidia.com>,
	<davidw@nvidia.com>, <gfitzer@nvidia.com>, <gerrit2@nvidia.com>
Message-ID: <56005092.4000504@nvidia.com>
Date: Mon, 21 Sep 2015 11:46:42 -0700
MIME-Version: 1.0
In-Reply-To: <55F932CA.2020502@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/16/2015 02:13 AM, Hans Verkuil wrote:
> Hi Bryan,
>
> Thanks for this patch series!
>
> The switch to a kthread helps a lot, but I still have a number of comments
> about it, primarily locking related.
>
> On 09/16/2015 03:35 AM, Bryan Wu wrote:
>> NVIDIA Tegra processor contains a powerful Video Input (VI) hardware
>> controller which can support up to 6 MIPI CSI camera sensors.
>>
>> This patch adds a V4L2 media controller and capture driver to support
>> Tegra VI hardware. It's verified with Tegra built-in test pattern
>> generator.
>>
>> Signed-off-by: Bryan Wu<pengw@nvidia.com>
>> Reviewed-by: Hans Verkuil<hans.verkuil@cisco.com>
>> ---
>>   drivers/media/platform/Kconfig               |   1 +
>>   drivers/media/platform/Makefile              |   2 +
>>   drivers/media/platform/tegra/Kconfig         |  10 +
>>   drivers/media/platform/tegra/Makefile        |   3 +
>>   drivers/media/platform/tegra/tegra-channel.c | 802 +++++++++++++++++++++++++++
>>   drivers/media/platform/tegra/tegra-core.c    | 252 +++++++++
>>   drivers/media/platform/tegra/tegra-core.h    | 162 ++++++
>>   drivers/media/platform/tegra/tegra-csi.c     | 566 +++++++++++++++++++
>>   drivers/media/platform/tegra/tegra-vi.c      | 581 +++++++++++++++++++
>>   drivers/media/platform/tegra/tegra-vi.h      | 213 +++++++
>>   10 files changed, 2592 insertions(+)
>>   create mode 100644 drivers/media/platform/tegra/Kconfig
>>   create mode 100644 drivers/media/platform/tegra/Makefile
>>   create mode 100644 drivers/media/platform/tegra/tegra-channel.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-core.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-core.h
>>   create mode 100644 drivers/media/platform/tegra/tegra-csi.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-vi.c
>>   create mode 100644 drivers/media/platform/tegra/tegra-vi.h
>>
>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
>> index f6bed19..553867f 100644
>> --- a/drivers/media/platform/Kconfig
>> +++ b/drivers/media/platform/Kconfig
>> @@ -119,6 +119,7 @@ source "drivers/media/platform/exynos4-is/Kconfig"
>>   source "drivers/media/platform/s5p-tv/Kconfig"
>>   source "drivers/media/platform/am437x/Kconfig"
>>   source "drivers/media/platform/xilinx/Kconfig"
>> +source "drivers/media/platform/tegra/Kconfig"
>>   
>>   endif # V4L_PLATFORM_DRIVERS
>>   
> <snip>
>
>> diff --git a/drivers/media/platform/tegra/tegra-channel.c b/drivers/media/platform/tegra/tegra-channel.c
>> new file mode 100644
>> index 0000000..8149016
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/tegra-channel.c
>> @@ -0,0 +1,802 @@
> <snip>
>
>> +static int tegra_channel_capture_frame(struct tegra_channel *chan)
>> +{
>> +	struct tegra_channel_buffer *buf = chan->active;
> I think this can just be passed as an argument instead of being a field
> in the chan struct. I'm not 100% certain, you'd have to check this.
Good point. I will remove the active of chan and pass a buffer pointer here.

>> +	struct vb2_buffer *vb = &buf->buf;
>> +	int err = 0;
>> +	u32 thresh, value, frame_start;
>> +	int bytes_per_line = chan->format.bytesperline;
>> +
>> +	if (!vb2_start_streaming_called(&chan->queue) || !buf)
>> +		return -EINVAL;
> Can this ever happen? Perhaps this should be using WARN_ON?
This check should be redundant. Let me remove them.


>> +
>> +	/* Program buffer address by using surface 0 */
>> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_MSB, 0x0);
>> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_OFFSET_LSB, buf->addr);
>> +	csi_write(chan, TEGRA_VI_CSI_SURFACE0_STRIDE, bytes_per_line);
>> +
>> +	/* Program syncpoint */
>> +	frame_start = VI_CSI_PP_FRAME_START(chan->port);
>> +	value = VI_CFG_VI_INCR_SYNCPT_COND(frame_start) |
>> +		host1x_syncpt_id(chan->sp);
>> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
>> +
>> +	csi_write(chan, TEGRA_VI_CSI_SINGLE_SHOT, SINGLE_SHOT_CAPTURE);
>> +
>> +	/* Use syncpoint to wake up */
>> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
>> +	err = host1x_syncpt_wait(chan->sp, thresh,
>> +			         TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
>> +	if (err) {
>> +		dev_err(&chan->video.dev, "frame start syncpt timeout!\n");
>> +		tegra_channel_capture_error(chan);
>> +	}
>> +
>> +	/* Captured one frame */
>> +	spin_lock_irq(&chan->queued_lock);
> Why use spinlock_irq? You're not in interrupt context. A normal spinlock is
> sufficient. Or perhaps the mutex_lock is enough (this function is already
> called with that lock held).

I will review the locking code here. looks like mutex_lock(chan->lock) 
is not required here. Or just keep one spinlock should be OK.

>> +	vb->v4l2_buf.sequence = chan->sequence++;
>> +	vb->v4l2_buf.field = V4L2_FIELD_NONE;
> Add a comment here that this will need to be changed if you ever start supporting
> interlaced formats.

Sure. fixed.

>> +	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
>> +	vb2_set_plane_payload(vb, 0, chan->format.sizeimage);
>> +	vb2_buffer_done(vb, err < 0 ? VB2_BUF_STATE_ERROR : VB2_BUF_STATE_DONE);
>> +	spin_unlock_irq(&chan->queued_lock);
>> +
>> +	return err;
>> +}
>> +
>> +static int tegra_channel_kthread_capture(void *data)
>> +{
>> +	struct tegra_channel *chan = data;
>> +
>> +	set_freezable();
>> +
>> +	while (1) {
>> +		try_to_freeze();
>> +		if (kthread_should_stop())
>> +			break;
>> +
>> +		wait_event_interruptible(chan->wait,
>> +					 !list_empty(&chan->capture));
>> +
>> +		spin_lock_irq(&chan->queued_lock);
> Can the capture queue be emptied between the wait_event_interruptible() and
> the spin_lock_irq()? It might be safer to do another list_empty() check here.
>

OK， fixed

>> +		chan->active = list_entry(chan->capture.next,
>> +				struct tegra_channel_buffer, queue);
>> +		list_del_init(&chan->active->queue);
>> +		spin_unlock_irq(&chan->queued_lock);
>> +		mutex_lock(&chan->lock);
> Here is another possible race condition. Actually, is the chan->lock even
> necessary? Only three functions take this lock: start_streaming, stop_streaming
> and this function. But this thread won't be started until the end of start_streaming
> (i.e. when that function already released the lock) and this thread will be
> stopped before stop_streaming takes the lock. So I don't think you ever need
> this lock since you never have concurrent access.
>
> That leaves a simple spin_lock (not spin_lock_irq!) to control access to the
> capture list.

Agree, I will remove chan->lock and just use one spinlock to protect the 
capture list.

>> +		tegra_channel_capture_frame(chan);
>> +		mutex_unlock(&chan->lock);
>> +	}
>> +
>> +	return 0;
>> +}
> <snip>
>
>> +static void tegra_channel_buffer_queue(struct vb2_buffer *vb)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vb->vb2_queue);
>> +	struct tegra_channel_buffer *buf = to_tegra_channel_buffer(vb);
>> +
>> +	/* Put buffer into the capture queue */
>> +	spin_lock_irq(&chan->queued_lock);
> See spin_lock_irq vs spin_lock vs mutex_lock discussion above. I won't refer to it
> anymore in the remainder of this review.
Sure, I will fix this.

>> +	list_add_tail(&buf->queue, &chan->capture);
>> +	spin_unlock_irq(&chan->queued_lock);
>> +
>> +	/* Wait up kthread for capture */
>> +	if (waitqueue_active(&chan->wait))
> No need for this test, wake_up_interruptible does the right thing if nobody
> is waiting for the wq.
OK, I will remove this.

>> +		wake_up_interruptible(&chan->wait);
>> +}
>> +
>> +static int tegra_channel_set_stream(struct tegra_channel *chan, bool on)
>> +{
>> +	struct media_entity *entity;
>> +	struct media_pad *pad;
>> +	struct v4l2_subdev *subdev;
>> +	int ret = 0;
>> +
>> +	entity = &chan->video.entity;
>> +
>> +	while (1) {
>> +		if (entity->num_pads > 1 && (chan->port & 0x1))
>> +			pad = &entity->pads[2];
> Shouldn't it be entity->num_pads > 2? You're getting the third pad here.
>
>> +		else
>> +			pad = &entity->pads[0];
> Magic numbers for pads[2] and pads[0]: this probably should use defines or at
> the minimum a comment.

Sorry, this are dead code. I should remove them.
pad starts from &chan->pad and iterate to each pad and call s_stream of 
each subdev.


>> +
>> +		if (!(pad->flags & MEDIA_PAD_FL_SINK))
>> +			break;
>> +
>> +		pad = media_entity_remote_pad(pad);
>> +		if (pad == NULL ||
>> +		    media_entity_type(pad->entity) != MEDIA_ENT_T_V4L2_SUBDEV)
>> +			break;
>> +
>> +		entity = pad->entity;
>> +		subdev = media_entity_to_v4l2_subdev(entity);
>> +		subdev->host_priv = chan;
>> +		ret = v4l2_subdev_call(subdev, video, s_stream, on);
>> +		if (on && ret < 0 && ret != -ENOIOCTLCMD)
>> +			return ret;
> You loop using this subdev entity, but the test at the start of the 'while'
> ('entity->num_pads > 1 && (chan->port & 0x1)') probably makes no sense for
> this entity.
Yeah, I should remove those dead code and will update them.


> Slightly off-topic since this is our problem, not yours: I think this function
> should become a core helper function (it's used in several drivers now). I also
> wonder if the assumption in most drivers that do this that the first pad is the
> sink pad is correct: is it really always a sink pad? Can there be multiple sink
> pads? If so, then you need to walk over all sink pads and call set_stream for
> any that has enabled links.

Exactly, this function is quite generic to me. But in this case each 
channel just have a sink pad no more others.

> All this is typically something that should be handled by a core function and
> that should wait until the whole MC 'next-gen' code is merged.
Yeah, introducing a API like media_entity_s_stream() or 
media_link_s_stream().


>> +	}
>> +	return ret;
>> +}
>> +
>> +static int tegra_channel_start_streaming(struct vb2_queue *vq, u32 count)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
>> +	struct media_pipeline *pipe = chan->video.entity.pipe;
>> +	struct tegra_channel_buffer *buf, *nbuf;
>> +	int ret = 0;
>> +
>> +	if (!chan->vi->pg_mode && !chan->vi->has_sensors) {
> I'm not sure about the has_sensors test: this makes the assumption that there is
> a v4l2_subdev that drives a sensor or a HDMI-CSI bridge like the Toshiba TC358743.
I'm also find it's quite hard to know whether there is a sensor subdev 
driver connects.
Currently, we have 3 subdev CSI instances in tegra-vi driver.

And VI can work at either TPG mode or sensor mode.

> But I know from past experience that sometimes it is fed via an FPGA or some other
> path where there is no v4l2-subdev driver available (or often even needed).

Looks like there is no good way to know that.

> So with this approach you would be forced to create a dummy subdev, just to
> satisfy this condition. I think this is too restrictive.

What about just give a warning here instead of quit?

>> +		dev_err(&chan->video.dev,
>> +			"is not in TPG mode and doesn't have \
>> +			 any sensor connected!\n");
>> +		ret = -EINVAL;
>> +		goto vb2_queued;
>> +	}
>> +
>> +	mutex_lock(&chan->lock);
>> +
>> +	/* The first open then turn on power*/
>> +	if (atomic_add_return(1, &chan->vi->power_on_refcnt) == 1) {
>> +		tegra_vi_power_on(chan->vi);
>> +
>> +		usleep_range(5, 100);
>> +		tegra_channel_write(chan, TEGRA_VI_CFG_CG_CTRL,
>> +				    VI_CG_2ND_LEVEL_EN);
>> +		usleep_range(10, 15);
>> +	}
>> +
>> +	/* Disable DPD */
>> +	ret = tegra_io_rail_power_on(chan->io_id);
>> +	if (ret < 0) {
>> +		dev_err(&chan->video.dev,
>> +			"failed to power on CSI rail: %d\n", ret);
>> +		goto error_power_on;
>> +	}
>> +
>> +	/* Clean up status */
>> +	csi_write(chan, TEGRA_VI_CSI_ERROR_STATUS, 0xFFFFFFFF);
>> +
>> +	ret = media_entity_pipeline_start(&chan->video.entity, pipe);
>> +	if (ret < 0)
>> +		goto error_pipeline_start;
>> +
>> +	/* Start the pipeline. */
>> +	ret = tegra_channel_set_stream(chan, true);
>> +	if (ret < 0)
>> +		goto error_set_stream;
>> +
>> +	/* Note: Program VI registers after TPG, sensors and CSI streaming */
>> +	ret = tegra_channel_capture_setup(chan);
>> +	if (ret < 0)
>> +		goto error_capture_setup;
>> +
>> +	chan->sequence = 0;
>> +	mutex_unlock(&chan->lock);
>> +
>> +	/* Start kthread to capture data to buffer */
>> +	chan->kthread_capture = kthread_run(tegra_channel_kthread_capture, chan,
>> +					    chan->video.name);
>> +	if (IS_ERR(chan->kthread_capture)) {
> I'd invert the test:
>
> 	if (!IS_ERR(chan->kthread_capture))
> 		return 0;
>
OK， fixed


>> +		dev_err(&chan->video.dev,
>> +			"failed to start kthread for capture!\n");
>> +		ret = PTR_ERR(chan->kthread_capture);
>> +		goto error_kthread_run;
>> +	}
>> +
>> +	return 0;
>> +
>> +error_kthread_run:
>> +error_capture_setup:
>> +	tegra_channel_set_stream(chan, false);
>> +error_set_stream:
>> +	media_entity_pipeline_stop(&chan->video.entity);
>> +error_pipeline_start:
>> +	tegra_io_rail_power_off(chan->io_id);
>> +error_power_on:
>> +	mutex_unlock(&chan->lock);
>> +vb2_queued:
>> +	/* Return all queued buffers back to vb2 */
>> +	spin_lock_irq(&chan->queued_lock);
>> +	vq->start_streaming_called = 0;
>> +	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
>> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_QUEUED);
>> +		list_del(&buf->queue);
>> +	}
>> +	spin_unlock_irq(&chan->queued_lock);
>> +	return ret;
>> +}
>> +
>> +static void tegra_channel_stop_streaming(struct vb2_queue *vq)
>> +{
>> +	struct tegra_channel *chan = vb2_get_drv_priv(vq);
>> +	struct tegra_channel_buffer *buf, *nbuf;
>> +	u32 thresh, value, mw_ack_done;
>> +	int err;
>> +
>> +	/* Stop the kthread for capture */
>> +	kthread_stop(chan->kthread_capture);
> I don't think this is enough: kthread_stop will wake up the thread, but
> the wake-up condition in the thread doesn't check for whether the thread
> should stop, so it will just continue waiting. The wake-up condition should
> be extended with a check that the kthread should exit.

Sure, I rework the kthread_capture code to check this in wait_event().

> You should also double-check that whatever buffer is being processed by the
> thread is also returned with vb2_buffer_done, even if the thread is stopped.
>

The following code will wait for the last frame finishing (MW_ACK_DONE 
syncpoint event).

>> +	chan->kthread_capture = NULL;
>> +
>> +	mutex_lock(&chan->lock);
>> +	/* Program syncpoint */
>> +	mw_ack_done = VI_CSI_MW_ACK_DONE(chan->port);
>> +	value = VI_CFG_VI_INCR_SYNCPT_COND(mw_ack_done) |
>> +		host1x_syncpt_id(chan->sp);
>> +	tegra_channel_write(chan, TEGRA_VI_CFG_VI_INCR_SYNCPT, value);
>> +
>> +	/* Use syncpoint to wake up */
>> +	thresh = host1x_syncpt_incr_max(chan->sp, 1);
>> +	err = host1x_syncpt_wait(chan->sp, thresh,
>> +			TEGRA_VI_SYNCPT_WAIT_TIMEOUT, &value);
>> +	if (err)
>> +		dev_err(&chan->video.dev, "MW_ACK_DONE syncpoint time out!\n");
>> +
>> +	media_entity_pipeline_stop(&chan->video.entity);
>> +
>> +	tegra_channel_set_stream(chan, false);
>> +
>> +	tegra_io_rail_power_off(chan->io_id);
>> +
>> +	/* The last release then turn off power */
>> +	if (atomic_dec_and_test(&chan->vi->power_on_refcnt))
>> +		tegra_vi_power_off(chan->vi);
>> +
>> +	mutex_unlock(&chan->lock);
>> +
>> +	/* Give back all queued buffers to videobuf2. */
>> +	spin_lock_irq(&chan->queued_lock);
>> +	list_for_each_entry_safe(buf, nbuf, &chan->capture, queue) {
>> +		vb2_buffer_done(&buf->buf, VB2_BUF_STATE_ERROR);
>> +		list_del(&buf->queue);
>> +	}
>> +	spin_unlock_irq(&chan->queued_lock);
>> +}
>> +
>> +static const struct vb2_ops tegra_channel_queue_qops = {
>> +	.queue_setup = tegra_channel_queue_setup,
>> +	.buf_prepare = tegra_channel_buffer_prepare,
>> +	.buf_queue = tegra_channel_buffer_queue,
>> +	.wait_prepare = vb2_ops_wait_prepare,
>> +	.wait_finish = vb2_ops_wait_finish,
>> +	.start_streaming = tegra_channel_start_streaming,
>> +	.stop_streaming = tegra_channel_stop_streaming,
>> +};
>> +
>> +/* -----------------------------------------------------------------------------
>> + * V4L2 ioctls
>> + */
>> +
>> +static int
>> +tegra_channel_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +
>> +	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
>> +	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
>> +
>> +	strlcpy(cap->driver, "tegra-video", sizeof(cap->driver));
>> +	strlcpy(cap->card, chan->video.name, sizeof(cap->card));
>> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
>> +		 dev_name(chan->vi->dev), chan->port);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +tegra_channel_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +	unsigned int index = 0, i;
>> +	unsigned long *fmts_bitmap = NULL;
>> +
>> +	if (chan->vi->pg_mode)
>> +		fmts_bitmap = chan->vi->tpg_fmts_bitmap;
>> +	else if (chan->vi->has_sensors)
>> +		fmts_bitmap = chan->fmts_bitmap;
> Hmm, interesting. If has_sensors == 0, then which formats should be supported.
> I think in that case you should just support *all* formats that the hardware
> supports. So fmts_bitmap should never be NULL.
Sure, I will remove this check.


>> +
>> +	if (!fmts_bitmap ||
>> +	    f->index > bitmap_weight(fmts_bitmap, MAX_FORMAT_NUM) - 1)
>> +		return -EINVAL;
>> +
>> +	for (i = 0; i < f->index + 1; i++, index++)
>> +		index = find_next_bit(fmts_bitmap, MAX_FORMAT_NUM, index);
>> +
>> +	f->pixelformat = tegra_core_get_fourcc_by_idx(index - 1);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +tegra_channel_get_format(struct file *file, void *fh, struct v4l2_format *format)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +
>> +	format->fmt.pix = chan->format;
>> +
>> +	return 0;
>> +}
>> +
>> +static void
>> +__tegra_channel_try_format(struct tegra_channel *chan, struct v4l2_pix_format *pix,
>> +			   const struct tegra_video_format **fmtinfo)
>> +{
>> +	const struct tegra_video_format *info;
>> +	unsigned int min_width;
>> +	unsigned int max_width;
>> +	unsigned int min_bpl;
>> +	unsigned int max_bpl;
>> +	unsigned int width;
>> +	unsigned int align;
>> +	unsigned int bpl;
>> +
>> +	/* Retrieve format information and select the default format if the
>> +	 * requested format isn't supported.
>> +	 */
>> +	info = tegra_core_get_format_by_fourcc(pix->pixelformat);
>> +	if (!info)
>> +		info = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
>> +
>> +	pix->pixelformat = info->fourcc;
>> +	pix->field = V4L2_FIELD_NONE;
>> +
>> +	/* The transfer alignment requirements are expressed in bytes. Compute
>> +	 * the minimum and maximum values, clamp the requested width and convert
>> +	 * it back to pixels.
>> +	 */
>> +	align = lcm(chan->align, info->bpp);
>> +	min_width = roundup(TEGRA_MIN_WIDTH, align);
>> +	max_width = rounddown(TEGRA_MAX_WIDTH, align);
>> +	width = roundup(pix->width * info->bpp, align);
>> +
>> +	pix->width = clamp(width, min_width, max_width) / info->bpp;
>> +	pix->height = clamp(pix->height, TEGRA_MIN_HEIGHT, TEGRA_MAX_HEIGHT);
>> +
>> +	/* Clamp the requested bytes per line value. If the maximum bytes per
>> +	 * line value is zero, the module doesn't support user configurable line
>> +	 * sizes. Override the requested value with the minimum in that case.
>> +	 */
>> +	min_bpl = pix->width * info->bpp;
>> +	max_bpl = rounddown(TEGRA_MAX_WIDTH, chan->align);
>> +	bpl = roundup(pix->bytesperline, chan->align);
>> +
>> +	pix->bytesperline = clamp(bpl, min_bpl, max_bpl);
>> +	pix->sizeimage = pix->bytesperline * pix->height;
>> +	pix->colorspace = V4L2_COLORSPACE_SRGB;
> This information should come from the subdev. Only if there is no subdev would you
> fallback to SRGB. If the subdev is for example an HDMI->CSI bridge, then the colorspace
> can be quite different.

OK, When probing each subdev, channel driver will get_fmt() from them 
and set to chan->format.colorspace.

>> +
>> +	if (fmtinfo)
>> +		*fmtinfo = info;
>> +
>> +	return;
> This return can be removed.

Removed

>> +}
>> +
>> +static int
>> +tegra_channel_try_format(struct file *file, void *fh, struct v4l2_format *format)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +
>> +	__tegra_channel_try_format(chan, &format->fmt.pix, NULL);
>> +
>> +	return 0;
>> +}
>> +
>> +static int
>> +tegra_channel_set_format(struct file *file, void *fh, struct v4l2_format *format)
>> +{
>> +	struct v4l2_fh *vfh = file->private_data;
>> +	struct tegra_channel *chan = to_tegra_channel(vfh->vdev);
>> +	const struct tegra_video_format *info;
>> +
>> +	if (vb2_is_busy(&chan->queue))
>> +		return -EBUSY;
>> +
>> +	__tegra_channel_try_format(chan, &format->fmt.pix, &info);
>> +
>> +	chan->format = format->fmt.pix;
>> +	chan->fmtinfo = info;
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ioctl_ops tegra_channel_ioctl_ops = {
>> +	.vidioc_querycap		= tegra_channel_querycap,
>> +	.vidioc_enum_fmt_vid_cap	= tegra_channel_enum_format,
>> +	.vidioc_g_fmt_vid_cap		= tegra_channel_get_format,
>> +	.vidioc_s_fmt_vid_cap		= tegra_channel_set_format,
>> +	.vidioc_try_fmt_vid_cap		= tegra_channel_try_format,
>> +	.vidioc_reqbufs			= vb2_ioctl_reqbufs,
>> +	.vidioc_querybuf		= vb2_ioctl_querybuf,
>> +	.vidioc_qbuf			= vb2_ioctl_qbuf,
>> +	.vidioc_dqbuf			= vb2_ioctl_dqbuf,
>> +	.vidioc_create_bufs		= vb2_ioctl_create_bufs,
>> +	.vidioc_expbuf			= vb2_ioctl_expbuf,
>> +	.vidioc_streamon		= vb2_ioctl_streamon,
>> +	.vidioc_streamoff		= vb2_ioctl_streamoff,
> In order to support HDMI->CSI bridges we'll likely need to add support for various
> other ioctls here (*_dv_timings, *_edid) which would pretty much pass on the arguments
> to the subdev.
>
> However, this can be added later.

OK, let's add it later when we start to bring up HDMI-CSI bridges.

>> +};
>> +
>> +/* -----------------------------------------------------------------------------
>> + * V4L2 file operations
>> + */
>> +
>> +static const struct v4l2_file_operations tegra_channel_fops = {
>> +	.owner		= THIS_MODULE,
>> +	.unlocked_ioctl	= video_ioctl2,
>> +	.open		= v4l2_fh_open,
>> +	.release	= vb2_fop_release,
>> +	.read		= vb2_fop_read,
>> +	.poll		= vb2_fop_poll,
>> +	.mmap		= vb2_fop_mmap,
>> +};
>> +
>> +int tegra_channel_init(struct tegra_vi *vi, unsigned int port)
>> +{
>> +	int ret;
>> +	struct tegra_channel *chan  = &vi->chans[port];
>> +
>> +	chan->vi = vi;
>> +	chan->port = port;
>> +
>> +	/* Init channel register base */
>> +	chan->csi = vi->iomem + TEGRA_VI_CSI_BASE(port);
>> +
>> +	/* VI Channel is 64 bytes alignment */
>> +	chan->align = 64;
>> +	chan->io_id = tegra_io_rail_csi_ids[chan->port];
>> +	mutex_init(&chan->lock);
>> +	mutex_init(&chan->video_lock);
>> +	INIT_LIST_HEAD(&chan->capture);
>> +	init_waitqueue_head(&chan->wait);
>> +	spin_lock_init(&chan->queued_lock);
>> +
>> +	/* Init video format */
>> +	chan->fmtinfo = tegra_core_get_format_by_fourcc(TEGRA_VF_DEF);
>> +	chan->format.pixelformat = chan->fmtinfo->fourcc;
>> +	chan->format.colorspace = V4L2_COLORSPACE_SRGB;
>> +	chan->format.field = V4L2_FIELD_NONE;
>> +	chan->format.width = TEGRA_DEF_WIDTH;
>> +	chan->format.height = TEGRA_DEF_HEIGHT;
>> +	chan->format.bytesperline = chan->format.width * chan->fmtinfo->bpp;
>> +	chan->format.sizeimage = chan->format.bytesperline *
>> +				    chan->format.height;
>> +
>> +	/* Initialize the media entity... */
>> +	chan->pad.flags = MEDIA_PAD_FL_SINK;
>> +
>> +	ret = media_entity_init(&chan->video.entity, 1, &chan->pad, 0);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* ... and the video node... */
>> +	chan->video.fops = &tegra_channel_fops;
>> +	chan->video.v4l2_dev = &vi->v4l2_dev;
>> +	chan->video.queue = &chan->queue;
>> +	snprintf(chan->video.name, sizeof(chan->video.name), "%s-%s-%u",
>> +		 dev_name(vi->dev), "output", port);
>> +	chan->video.vfl_type = VFL_TYPE_GRABBER;
>> +	chan->video.vfl_dir = VFL_DIR_RX;
>> +	chan->video.release = video_device_release_empty;
>> +	chan->video.ioctl_ops = &tegra_channel_ioctl_ops;
>> +	chan->video.lock = &chan->video_lock;
>> +
>> +	video_set_drvdata(&chan->video, chan);
>> +
>> +	/* Init host1x interface */
>> +	INIT_LIST_HEAD(&chan->client.list);
>> +	chan->client.dev = chan->vi->dev;
>> +
>> +	ret = host1x_client_register(&chan->client);
>> +	if (ret < 0) {
>> +		dev_err(chan->vi->dev, "failed to register host1x client: %d\n",
>> +			ret);
>> +		ret = -ENODEV;
>> +		goto host1x_register_error;
>> +	}
>> +
>> +	chan->sp = host1x_syncpt_request(chan->client.dev,
>> +					 HOST1X_SYNCPT_HAS_BASE);
>> +	if (!chan->sp) {
>> +		dev_err(chan->vi->dev, "failed to request host1x syncpoint\n");
>> +		ret = -ENOMEM;
>> +		goto host1x_sp_error;
>> +	}
>> +
>> +	/* ... and the buffers queue... */
>> +	chan->alloc_ctx = vb2_dma_contig_init_ctx(&chan->video.dev);
>> +	if (IS_ERR(chan->alloc_ctx)) {
>> +		dev_err(chan->vi->dev, "failed to init vb2 buffer\n");
>> +		ret = -ENOMEM;
>> +		goto vb2_init_error;
>> +	}
>> +
>> +	chan->queue.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
>> +	chan->queue.io_modes = VB2_MMAP | VB2_DMABUF | VB2_READ;
>> +	chan->queue.lock = &chan->video_lock;
>> +	chan->queue.drv_priv = chan;
>> +	chan->queue.buf_struct_size = sizeof(struct tegra_channel_buffer);
>> +	chan->queue.ops = &tegra_channel_queue_qops;
>> +	chan->queue.mem_ops = &vb2_dma_contig_memops;
>> +	chan->queue.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC
>> +				   | V4L2_BUF_FLAG_TSTAMP_SRC_EOF;
>> +	ret = vb2_queue_init(&chan->queue);
>> +	if (ret < 0) {
>> +		dev_err(chan->vi->dev, "failed to initialize VB2 queue\n");
>> +		goto vb2_queue_error;
>> +	}
>> +
>> +	ret = video_register_device(&chan->video, VFL_TYPE_GRABBER, -1);
>> +	if (ret < 0) {
>> +		dev_err(&chan->video.dev, "failed to register video device\n");
>> +		goto video_register_error;
>> +	}
>> +
>> +	return 0;
>> +
>> +video_register_error:
>> +	vb2_queue_release(&chan->queue);
>> +vb2_queue_error:
>> +	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
>> +vb2_init_error:
>> +	host1x_syncpt_free(chan->sp);
>> +host1x_sp_error:
>> +	host1x_client_unregister(&chan->client);
>> +host1x_register_error:
>> +	media_entity_cleanup(&chan->video.entity);
>> +	return ret;
>> +}
>> +
>> +int tegra_channel_cleanup(struct tegra_channel *chan)
>> +{
>> +	video_unregister_device(&chan->video);
>> +
>> +	vb2_queue_release(&chan->queue);
>> +	vb2_dma_contig_cleanup_ctx(chan->alloc_ctx);
>> +
>> +	host1x_syncpt_free(chan->sp);
>> +	host1x_client_unregister(&chan->client);
>> +
>> +	media_entity_cleanup(&chan->video.entity);
>> +
>> +	return 0;
>> +}
> <snip>
>
>> diff --git a/drivers/media/platform/tegra/tegra-vi.c b/drivers/media/platform/tegra/tegra-vi.c
>> new file mode 100644
>> index 0000000..295c25f
>> --- /dev/null
>> +++ b/drivers/media/platform/tegra/tegra-vi.c
>> @@ -0,0 +1,581 @@
>> +/*
>> + * NVIDIA Tegra Video Input Device
>> + *
>> + * Copyright (c) 2015, NVIDIA CORPORATION.  All rights reserved.
>> + *
>> + * Author: Bryan Wu<pengw@nvidia.com>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 as
>> + * published by the Free Software Foundation.
>> + */
>> +
>> +#include <linux/clk.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/of_graph.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/regulator/consumer.h>
>> +#include <linux/reset.h>
>> +#include <linux/slab.h>
>> +
>> +#include <media/media-device.h>
>> +#include <media/v4l2-async.h>
>> +#include <media/v4l2-common.h>
>> +#include <media/v4l2-device.h>
>> +#include <media/v4l2-of.h>
>> +
>> +#include <soc/tegra/pmc.h>
>> +
>> +#include "tegra-vi.h"
>> +
>> +/* In TPG mode, VI only support 2 formats */
>> +static void vi_tpg_fmts_bitmap_init(struct tegra_vi *vi)
>> +{
>> +	int index;
>> +
>> +	bitmap_zero(vi->tpg_fmts_bitmap, MAX_FORMAT_NUM);
>> +
>> +	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_SRGGB10_1X10);
>> +	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
>> +
>> +	index = tegra_core_get_idx_by_code(MEDIA_BUS_FMT_RGB888_1X32_PADHI);
>> +	bitmap_set(vi->tpg_fmts_bitmap, index, 1);
>> +}
>> +
>> +/*
>> + * Control Config
>> + */
>> +
>> +static const char *const vi_pattern_strings[] = {
>> +	"Disabled",
>> +	"Black/White Direct Mode",
>> +	"Color Patch Mode",
>> +};
>> +
>> +static int vi_s_ctrl(struct v4l2_ctrl *ctrl)
>> +{
>> +	struct tegra_vi *vi = container_of(ctrl->handler, struct tegra_vi,
>> +					   ctrl_handler);
>> +	switch (ctrl->id) {
>> +	case V4L2_CID_TEST_PATTERN:
>> +		vi->pg_mode = ctrl->val;
>> +		break;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct v4l2_ctrl_ops vi_ctrl_ops = {
>> +	.s_ctrl	= vi_s_ctrl,
>> +};
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Media Controller and V4L2
>> + */
>> +
>> +static void tegra_vi_v4l2_cleanup(struct tegra_vi *vi)
>> +{
>> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
>> +	v4l2_device_unregister(&vi->v4l2_dev);
>> +	media_device_unregister(&vi->media_dev);
>> +}
>> +
>> +static int tegra_vi_v4l2_init(struct tegra_vi *vi)
>> +{
>> +	int ret;
>> +
>> +	vi->media_dev.dev = vi->dev;
>> +	strlcpy(vi->media_dev.model, "NVIDIA Tegra Video Input Device",
>> +		sizeof(vi->media_dev.model));
>> +	vi->media_dev.hw_revision = 3;
>> +
>> +	ret = media_device_register(&vi->media_dev);
> This will likely change. Seehttps://lkml.org/lkml/2015/9/15/371  for more info.

According to that patch, this should be changed to media_device_init(). 
I guess I need wait for that merge right?

>> +	if (ret < 0) {
>> +		dev_err(vi->dev, "media device registration failed (%d)\n",
>> +			ret);
>> +		return ret;
>> +	}
>> +
>> +	vi->v4l2_dev.mdev = &vi->media_dev;
>> +	ret = v4l2_device_register(vi->dev, &vi->v4l2_dev);
>> +	if (ret < 0) {
>> +		dev_err(vi->dev, "V4L2 device registration failed (%d)\n",
>> +			ret);
>> +		goto register_error;
>> +	}
>> +
>> +	v4l2_ctrl_handler_init(&vi->ctrl_handler, 1);
>> +	vi->pattern = v4l2_ctrl_new_std_menu_items(&vi->ctrl_handler,
>> +					&vi_ctrl_ops, V4L2_CID_TEST_PATTERN,
>> +					ARRAY_SIZE(vi_pattern_strings) - 1,
>> +					0, 0, vi_pattern_strings);
>> +
>> +	if (vi->ctrl_handler.error) {
>> +		dev_err(vi->dev, "failed to add controls\n");
>> +		ret = vi->ctrl_handler.error;
>> +		goto ctrl_error;
>> +	}
>> +	vi->v4l2_dev.ctrl_handler = &vi->ctrl_handler;
>> +
>> +	ret = v4l2_ctrl_handler_setup(&vi->ctrl_handler);
>> +	if (ret < 0) {
>> +		dev_err(vi->dev, "failed to set controls\n");
>> +		goto ctrl_error;
>> +	}
>> +	return 0;
>> +
>> +
>> +ctrl_error:
>> +	v4l2_ctrl_handler_free(&vi->ctrl_handler);
>> +	v4l2_device_unregister(&vi->v4l2_dev);
>> +register_error:
>> +	media_device_unregister(&vi->media_dev);
>> +	return ret;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Platform Device Driver
>> + */
>> +
>> +int tegra_vi_power_on(struct tegra_vi *vi)
>> +{
>> +	int ret;
>> +
>> +	ret = regulator_enable(vi->vi_reg);
>> +	if (ret)
>> +		return ret;
>> +
>> +	ret = tegra_powergate_sequence_power_up(TEGRA_POWERGATE_VENC,
>> +						vi->vi_clk, vi->vi_rst);
>> +	if (ret) {
>> +		dev_err(vi->dev, "failed to power up!\n");
>> +		goto error_power_up;
>> +	}
>> +
>> +	ret = clk_set_rate(vi->vi_clk, 408000000);
>> +	if (ret) {
>> +		dev_err(vi->dev, "failed to set vi clock to 408MHz!\n");
>> +		goto error_clk_set_rate;
>> +	}
>> +
>> +	clk_prepare_enable(vi->csi_clk);
>> +
>> +	return 0;
>> +
>> +error_clk_set_rate:
>> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
>> +error_power_up:
>> +	regulator_disable(vi->vi_reg);
>> +	return ret;
>> +}
>> +
>> +void tegra_vi_power_off(struct tegra_vi *vi)
>> +{
>> +	reset_control_assert(vi->vi_rst);
>> +	clk_disable_unprepare(vi->vi_clk);
>> +	clk_disable_unprepare(vi->csi_clk);
>> +	tegra_powergate_power_off(TEGRA_POWERGATE_VENC);
>> +	regulator_disable(vi->vi_reg);
>> +}
>> +
>> +static int tegra_vi_channels_init(struct tegra_vi *vi)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
>> +		ret = tegra_channel_init(vi, i);
>> +		if (ret < 0) {
>> +			dev_err(vi->dev, "channel %d init failed\n", i);
>> +			return ret;
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +static int tegra_vi_channels_cleanup(struct tegra_vi *vi)
>> +{
>> +	unsigned int i;
>> +	int ret;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(vi->chans); i++) {
>> +		ret = tegra_channel_cleanup(&vi->chans[i]);
>> +		if (ret < 0) {
>> +			dev_err(vi->dev, "channel %d cleanup failed\n", i);
>> +			return ret;
>> +		}
>> +	}
>> +	return 0;
>> +}
>> +
>> +/* -----------------------------------------------------------------------------
>> + * Graph Management
>> + */
>> +
>> +static struct tegra_vi_graph_entity *
>> +tegra_vi_graph_find_entity(struct tegra_vi *vi,
>> +		       const struct device_node *node)
>> +{
>> +	struct tegra_vi_graph_entity *entity;
>> +
>> +	list_for_each_entry(entity, &vi->entities, list) {
>> +		if (entity->node == node)
>> +			return entity;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>> +static int tegra_vi_graph_build_links(struct tegra_vi *vi)
>> +{
>> +	u32 link_flags = MEDIA_LNK_FL_ENABLED;
>> +	struct device_node *node = vi->dev->of_node;
>> +	struct media_entity *source;
>> +	struct media_entity *sink;
>> +	struct media_pad *source_pad;
>> +	struct media_pad *sink_pad;
>> +	struct tegra_vi_graph_entity *ent;
>> +	struct v4l2_of_link link;
>> +	struct device_node *ep = NULL;
>> +	struct device_node *next;
>> +	struct tegra_channel *chan;
>> +	int ret = 0;
>> +
>> +	dev_dbg(vi->dev, "creating links for channels\n");
>> +
>> +	while (1) {
>> +		/* Get the next endpoint and parse its link. */
>> +		next = of_graph_get_next_endpoint(node, ep);
>> +		if (next == NULL)
>> +			break;
>> +
>> +		of_node_put(ep);
>> +		ep = next;
>> +
>> +		dev_dbg(vi->dev, "processing endpoint %s\n", ep->full_name);
>> +
>> +		ret = v4l2_of_parse_link(ep, &link);
>> +		if (ret < 0) {
>> +			dev_err(vi->dev, "failed to parse link for %s\n",
>> +				ep->full_name);
>> +			continue;
>> +		}
>> +
>> +		if (link.local_port > MAX_CHAN_NUM) {
>> +			dev_err(vi->dev, "wrong channel number for port %u\n",
>> +				link.local_port);
>> +			v4l2_of_put_link(&link);
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +
>> +		chan = &vi->chans[link.local_port];
>> +
>> +		dev_dbg(vi->dev, "creating link for channel %s\n",
>> +			chan->video.name);
>> +
>> +		/* Find the remote entity. */
>> +		ent = tegra_vi_graph_find_entity(vi, link.remote_node);
>> +		if (ent == NULL) {
>> +			dev_err(vi->dev, "no entity found for %s\n",
>> +				link.remote_node->full_name);
>> +			v4l2_of_put_link(&link);
>> +			ret = -ENODEV;
>> +			break;
>> +		}
>> +
>> +		source = ent->entity;
>> +		source_pad = &source->pads[(link.remote_port & 1) * 2 + 1];
>> +		sink = &chan->video.entity;
>> +		sink_pad = &chan->pad;
>> +
>> +		v4l2_of_put_link(&link);
>> +
>> +		/* Create the media link. */
>> +		dev_dbg(vi->dev, "creating %s:%u -> %s:%u link\n",
>> +			source->name, source_pad->index,
>> +			sink->name, sink_pad->index);
>> +
>> +		ret = media_entity_create_link(source, source_pad->index,
>> +					       sink, sink_pad->index,
>> +					       link_flags);
>> +		if (ret < 0) {
>> +			dev_err(vi->dev,
>> +				"failed to create %s:%u -> %s:%u link\n",
>> +				source->name, source_pad->index,
>> +				sink->name, sink_pad->index);
>> +			break;
>> +		}
>> +
>> +		tegra_channel_fmts_bitmap_init(chan, ent);
>> +	}
>> +
>> +	of_node_put(ep);
>> +	return ret;
>> +}
>> +
>> +static int tegra_vi_graph_notify_complete(struct v4l2_async_notifier *notifier)
>> +{
>> +	struct tegra_vi *vi =
>> +		container_of(notifier, struct tegra_vi, notifier);
>> +	int ret;
>> +
>> +	dev_dbg(vi->dev, "notify complete, all subdevs registered\n");
>> +
>> +	/* Create links for every entity. */
>> +	ret = tegra_vi_graph_build_links(vi);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	ret = v4l2_device_register_subdev_nodes(&vi->v4l2_dev);
>> +	if (ret < 0)
>> +		dev_err(vi->dev, "failed to register subdev nodes\n");
>> +
>> +	return ret;
>> +}
>> +
>> +static int tegra_vi_graph_notify_bound(struct v4l2_async_notifier *notifier,
>> +				   struct v4l2_subdev *subdev,
>> +				   struct v4l2_async_subdev *asd)
>> +{
>> +	struct tegra_vi *vi = container_of(notifier, struct tegra_vi, notifier);
>> +	struct tegra_vi_graph_entity *entity;
>> +
>> +	/* Locate the entity corresponding to the bound subdev and store the
>> +	 * subdev pointer.
>> +	 */
>> +	list_for_each_entry(entity, &vi->entities, list) {
>> +		if (entity->node != subdev->dev->of_node)
>> +			continue;
>> +
>> +		if (entity->subdev) {
>> +			dev_err(vi->dev, "duplicate subdev for node %s\n",
>> +				entity->node->full_name);
>> +			return -EINVAL;
>> +		}
>> +
>> +		dev_dbg(vi->dev, "subdev %s bound\n", subdev->name);
>> +		entity->entity = &subdev->entity;
>> +		entity->subdev = subdev;
>> +		return 0;
>> +	}
>> +
>> +	dev_err(vi->dev, "no entity for subdev %s\n", subdev->name);
>> +	return -EINVAL;
>> +}
>> +
>> +static void tegra_vi_graph_cleanup(struct tegra_vi *vi)
>> +{
>> +	struct tegra_vi_graph_entity *entityp;
>> +	struct tegra_vi_graph_entity *entity;
>> +
>> +	v4l2_async_notifier_unregister(&vi->notifier);
>> +
>> +	list_for_each_entry_safe(entity, entityp, &vi->entities, list) {
>> +		of_node_put(entity->node);
>> +		list_del(&entity->list);
>> +	}
>> +}
>> +
>> +static int tegra_vi_graph_init(struct tegra_vi *vi)
>> +{
>> +	struct device_node *node = vi->dev->of_node;
>> +	struct device_node *ep = NULL;
>> +	struct device_node *next;
>> +	struct device_node *remote = NULL;
>> +	struct tegra_vi_graph_entity *entity;
>> +	struct v4l2_async_subdev **subdevs = NULL;
>> +	unsigned int num_subdevs = 0;
>> +	int ret = 0, i;
>> +
>> +	/* Parse all the remote entities and put them into the list */
>> +	while (1) {
>> +		next = of_graph_get_next_endpoint(node, ep);
>> +		if (!next)
>> +			break;
>> +
>> +		of_node_put(ep);
>> +		ep = next;
>> +
>> +		remote = of_graph_get_remote_port_parent(ep);
>> +		if (!remote) {
>> +			ret = -EINVAL;
>> +			break;
>> +		}
>> +
>> +		entity = tegra_vi_graph_find_entity(vi, remote);
>> +		if (!entity) {
>> +			entity = devm_kzalloc(vi->dev, sizeof(*entity),
>> +					      GFP_KERNEL);
>> +			if (entity == NULL) {
>> +				of_node_put(remote);
>> +				ret = -ENOMEM;
>> +				break;
>> +			}
>> +
>> +			entity->node = remote;
>> +			entity->asd.match_type = V4L2_ASYNC_MATCH_OF;
>> +			entity->asd.match.of.node = remote;
>> +			list_add_tail(&entity->list, &vi->entities);
>> +			vi->num_subdevs++;
>> +		}
>> +	}
>> +	of_node_put(ep);
>> +
>> +	if (!vi->num_subdevs) {
>> +		dev_warn(vi->dev, "no subdev found in graph\n");
>> +		goto done;
>> +	}
>> +
>> +	/*
>> +	 * VI has at least MAX_CHAN_NUM / 2 subdevices for CSI blocks.
>> +	 * If just found CSI subdevices connecting to VI, VI has no sensors
>> +	 * described in DT but has to use test pattern generator mode.
>> +	 * Otherwise VI has sensors connecting.
>> +	 */
>> +	vi->has_sensors = (vi->num_subdevs > MAX_CHAN_NUM / 2);
>> +
>> +	/* Register the subdevices notifier. */
>> +	num_subdevs = vi->num_subdevs;
>> +	subdevs = devm_kzalloc(vi->dev, sizeof(*subdevs) * num_subdevs,
>> +			       GFP_KERNEL);
>> +	if (subdevs == NULL) {
>> +		ret = -ENOMEM;
>> +		goto done;
>> +	}
>> +
>> +	i = 0;
>> +	list_for_each_entry(entity, &vi->entities, list)
>> +		subdevs[i++] = &entity->asd;
>> +
>> +	vi->notifier.subdevs = subdevs;
>> +	vi->notifier.num_subdevs = num_subdevs;
>> +	vi->notifier.bound = tegra_vi_graph_notify_bound;
>> +	vi->notifier.complete = tegra_vi_graph_notify_complete;
>> +
>> +	ret = v4l2_async_notifier_register(&vi->v4l2_dev, &vi->notifier);
>> +	if (ret < 0) {
>> +		dev_err(vi->dev, "notifier registration failed\n");
>> +		goto done;
>> +	}
>> +
>> +	return 0;
>> +
>> +done:
>> +	if (ret < 0)
>> +		tegra_vi_graph_cleanup(vi);
>> +
>> +	return ret;
>> +}
> Hmmm. All this code should become helper core code. We'll have to see
> how we're going to do this once the MC next-gen patches are merged.
>
> <snip>
>
> Regards,
>
> 	Hans

-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
