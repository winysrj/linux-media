Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:38953 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbeLCUO5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 3 Dec 2018 15:14:57 -0500
Subject: Re: [PATCH v6 2/2] media: platform: Add Aspeed Video Engine driver
To: Eddie James <eajames@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1543347457-59224-1-git-send-email-eajames@linux.ibm.com>
 <1543347457-59224-3-git-send-email-eajames@linux.ibm.com>
 <1d5f3260-2d95-32b2-090e-2f57ae9e6833@xs4all.nl>
 <52cae852-5a2b-ee37-3829-73de7a47df1c@linux.ibm.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c5dbd34-a10c-04ce-43bb-646e712f0e99@xs4all.nl>
Date: Mon, 3 Dec 2018 21:14:48 +0100
MIME-Version: 1.0
In-Reply-To: <52cae852-5a2b-ee37-3829-73de7a47df1c@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/03/2018 05:39 PM, Eddie James wrote:
> 
> 
> On 12/03/2018 05:04 AM, Hans Verkuil wrote:
>> On 11/27/2018 08:37 PM, Eddie James wrote:
>>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>>> can capture and compress video data from digital or analog sources. With
>>> the Aspeed chip acting a service processor, the Video Engine can capture
>>> the host processor graphics output.
>>>
>>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>>> Make the video frames available through the V4L2 streaming interface.
>>>
>>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>>> ---

<snip>

>>> +static void aspeed_video_bufs_done(struct aspeed_video *video,
>>> +				   enum vb2_buffer_state state)
>>> +{
>>> +	unsigned long flags;
>>> +	struct aspeed_video_buffer *buf;
>>> +
>>> +	spin_lock_irqsave(&video->lock, flags);
>>> +	list_for_each_entry(buf, &video->buffers, link) {
>>> +		if (list_is_last(&buf->link, &video->buffers))
>>> +			buf->vb.flags |= V4L2_BUF_FLAG_LAST;
>> This really makes no sense. This flag is for codecs, not for receivers.
>>
>> You say in an earlier reply about this:
>>
>> "I mentioned before that dequeue calls hang in an error condition unless
>> this flag is specified. For example if resolution change is detected and
>> application is in the middle of trying to dequeue..."
>>
>> What error condition are you referring to? Isn't your application using
>> the select() or poll() calls to wait for events or new buffers to dequeue?
>> If you just call VIDIOC_DQBUF to wait in blocking mode for a new buffer,
>> then it will indeed block in that call.
>>
>> No other video receiver needs this flag, so there is something else that is
>> the cause.
> 
> Probably no one else uses it in blocking mode, but the thing should 
> still work. Why wouldn't it stop blocking if there is an error? Isn't 
> that normal?
> 
> As I said, the error condition I've tested this with is resolution 
> change. All the buffers are placed in error state, but dequeue does not 
> return.

If VIDIOC_DQBUF is waiting for a buffer, and the driver calls vb2_buffer_done,
then the ioctl will return. If not, then something else is wrong.

Is your application just requeueing the dequeued buffers? Does it work when
you use v4l2-ctl --stream-mmap?

> 
> I much prefer using blocking mode in applications because it reduces 
> complexity.
> 
> You say that the flag is for codecs, not receivers, but I don't see why 
> that has to be the case.

Because there is no concept of 'last' buffer for receivers. If the source
comes back with the same timings, then receiver will just pick it up again
(see also my other email on how video receivers behave when a source disappears).

> 
>>
>>> +		vb2_buffer_done(&buf->vb.vb2_buf, state);
>>> +	}
>>> +	INIT_LIST_HEAD(&video->buffers);
>>> +	spin_unlock_irqrestore(&video->lock, flags);
>>> +}
>>> +
>>> +static irqreturn_t aspeed_video_irq(int irq, void *arg)
>>> +{
>>> +	struct aspeed_video *video = arg;
>>> +	u32 sts = aspeed_video_read(video, VE_INTERRUPT_STATUS);
>>> +
>>> +	if (atomic_read(&video->clients) == 0) {
>>> +		dev_info(video->dev, "irq with no client; disabling irqs\n");
>>> +
>>> +		aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
>>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
>>> +		return IRQ_HANDLED;
>>> +	}
>>> +
>>> +	/* Resolution changed; reset entire engine and reinitialize */
>>> +	if (sts & VE_INTERRUPT_MODE_DETECT_WD) {
>>> +		dev_info(video->dev, "resolution changed; resetting\n");
>>> +		set_bit(VIDEO_RES_CHANGE, &video->flags);
>>> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>>> +		clear_bit(VIDEO_STREAMING, &video->flags);
>>> +
>>> +		aspeed_video_off(video);
>>> +		aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
>>> +
>>> +		schedule_delayed_work(&video->res_work,
>>> +				      RESOLUTION_CHANGE_DELAY);
>>> +		return IRQ_HANDLED;
>>> +	}
>>> +
>>> +	if (sts & VE_INTERRUPT_MODE_DETECT) {
>>> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
>>> +				    VE_INTERRUPT_MODE_DETECT, 0);
>>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
>>> +				   VE_INTERRUPT_MODE_DETECT);
>>> +
>>> +		set_bit(VIDEO_MODE_DETECT_DONE, &video->flags);
>>> +		wake_up_interruptible_all(&video->wait);
>>> +	}
>>> +
>>> +	if ((sts & VE_INTERRUPT_COMP_COMPLETE) &&
>>> +	    (sts & VE_INTERRUPT_CAPTURE_COMPLETE)) {
>>> +		struct aspeed_video_buffer *buf;
>>> +		u32 frame_size = aspeed_video_read(video,
>>> +						   VE_OFFSET_COMP_STREAM);
>>> +
>>> +		spin_lock(&video->lock);
>>> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>>> +		buf = list_first_entry_or_null(&video->buffers,
>>> +					       struct aspeed_video_buffer,
>>> +					       link);
>>> +		if (buf) {
>>> +			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, frame_size);
>>> +
>>> +			if (!list_is_last(&buf->link, &video->buffers)) {
>>> +				buf->vb.vb2_buf.timestamp = ktime_get_ns();
>>> +				buf->vb.sequence = video->sequence++;
>>> +				buf->vb.field = V4L2_FIELD_NONE;
>>> +				vb2_buffer_done(&buf->vb.vb2_buf,
>>> +						VB2_BUF_STATE_DONE);
>>> +				list_del(&buf->link);
>>> +			}
>>> +		}
>>> +		spin_unlock(&video->lock);
>>> +
>>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>>> +				    VE_SEQ_CTRL_TRIG_CAPTURE |
>>> +				    VE_SEQ_CTRL_FORCE_IDLE |
>>> +				    VE_SEQ_CTRL_TRIG_COMP, 0);
>>> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
>>> +				    VE_INTERRUPT_COMP_COMPLETE |
>>> +				    VE_INTERRUPT_CAPTURE_COMPLETE, 0);
>>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
>>> +				   VE_INTERRUPT_COMP_COMPLETE |
>>> +				   VE_INTERRUPT_CAPTURE_COMPLETE);
>>> +
>>> +		if (test_bit(VIDEO_STREAMING, &video->flags) && buf)
>>> +			aspeed_video_start_frame(video);
>>> +	}
>>> +
>>> +	return IRQ_HANDLED;
>>> +}
>>> +
>>> +static void aspeed_video_check_and_set_polarity(struct aspeed_video *video)
>>> +{
>>> +	int i;
>>> +	int hsync_counter = 0;
>>> +	int vsync_counter = 0;
>>> +	u32 sts;
>>> +
>>> +	for (i = 0; i < NUM_POLARITY_CHECKS; ++i) {
>>> +		sts = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>>> +		if (sts & VE_MODE_DETECT_STATUS_VSYNC)
>>> +			vsync_counter--;
>>> +		else
>>> +			vsync_counter++;
>>> +
>>> +		if (sts & VE_MODE_DETECT_STATUS_HSYNC)
>>> +			hsync_counter--;
>>> +		else
>>> +			hsync_counter++;
>>> +	}
>>> +
>>> +	if (hsync_counter < 0 || vsync_counter < 0) {
>>> +		u32 ctrl;
>>> +
>>> +		if (hsync_counter < 0) {
>>> +			ctrl = VE_CTRL_HSYNC_POL;
>>> +			video->detected_timings.polarities &=
>>> +				~V4L2_DV_HSYNC_POS_POL;
>>> +		} else {
>>> +			video->detected_timings.polarities |=
>>> +				V4L2_DV_HSYNC_POS_POL;
>>> +		}
>>> +
>>> +		if (vsync_counter < 0) {
>>> +			ctrl = VE_CTRL_VSYNC_POL;
>>> +			video->detected_timings.polarities &=
>>> +				~V4L2_DV_VSYNC_POS_POL;
>>> +		} else {
>>> +			video->detected_timings.polarities |=
>>> +				V4L2_DV_VSYNC_POS_POL;
>>> +		}
>>> +
>>> +		aspeed_video_update(video, VE_CTRL, 0, ctrl);
>>> +	}
>>> +}
>>> +
>>> +static bool aspeed_video_alloc_buf(struct aspeed_video *video,
>>> +				   struct aspeed_video_addr *addr,
>>> +				   unsigned int size)
>>> +{
>>> +	addr->virt = dma_alloc_coherent(video->dev, size, &addr->dma,
>>> +					GFP_KERNEL);
>>> +	if (!addr->virt)
>>> +		return false;
>>> +
>>> +	addr->size = size;
>>> +	return true;
>>> +}
>>> +
>>> +static void aspeed_video_free_buf(struct aspeed_video *video,
>>> +				  struct aspeed_video_addr *addr)
>>> +{
>>> +	dma_free_coherent(video->dev, addr->size, addr->virt, addr->dma);
>>> +	addr->size = 0;
>>> +	addr->dma = 0ULL;
>>> +	addr->virt = NULL;
>>> +}
>>> +
>>> +/*
>>> + * Get the minimum HW-supported compression buffer size for the frame size.
>>> + * Assume worst-case JPEG compression size is 1/8 raw size. This should be
>>> + * plenty even for maximum quality; any worse and the engine will simply return
>>> + * incomplete JPEGs.
>>> + */
>>> +static void aspeed_video_calc_compressed_size(struct aspeed_video *video,
>>> +					      unsigned int frame_size)
>>> +{
>>> +	int i, j;
>>> +	u32 compression_buffer_size_reg = 0;
>>> +	unsigned int size;
>>> +	const unsigned int num_compression_packets = 4;
>>> +	const unsigned int compression_packet_size = 1024;
>>> +	const unsigned int max_compressed_size = frame_size / 2; /* 4bpp / 8 */
>>> +
>>> +	video->max_compressed_size = UINT_MAX;
>>> +
>>> +	for (i = 0; i < 6; ++i) {
>>> +		for (j = 0; j < 8; ++j) {
>>> +			size = (num_compression_packets << i) *
>>> +				(compression_packet_size << j);
>>> +			if (size < max_compressed_size)
>>> +				continue;
>>> +
>>> +			if (size < video->max_compressed_size) {
>>> +				compression_buffer_size_reg = (i << 3) | j;
>>> +				video->max_compressed_size = size;
>>> +			}
>>> +		}
>>> +	}
>>> +
>>> +	aspeed_video_write(video, VE_STREAM_BUF_SIZE,
>>> +			   compression_buffer_size_reg);
>>> +
>>> +	dev_dbg(video->dev, "max compressed size: %x\n",
>>> +		video->max_compressed_size);
>>> +}
>>> +
>>> +#define res_check(v) test_and_clear_bit(VIDEO_MODE_DETECT_DONE, &(v)->flags)
>>> +
>>> +static int aspeed_video_get_resolution(struct aspeed_video *video)
>>> +{
>>> +	bool invalid_resolution = true;
>>> +	int rc;
>>> +	int tries = 0;
>>> +	u32 mds;
>>> +	u32 src_lr_edge;
>>> +	u32 src_tb_edge;
>>> +	u32 sync;
>>> +	struct v4l2_bt_timings *det = &video->detected_timings;
>>> +
>>> +	det->width = 0;
>>> +	det->height = 0;
>>> +
>>> +	/*
>>> +	 * Since we need max buffer size for detection, free the second source
>>> +	 * buffer first.
>>> +	 */
>>> +	if (video->srcs[1].size)
>>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>>> +
>>> +	if (video->srcs[0].size < VE_MAX_SRC_BUFFER_SIZE) {
>>> +		if (video->srcs[0].size)
>>> +			aspeed_video_free_buf(video, &video->srcs[0]);
>>> +
>>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0],
>>> +					    VE_MAX_SRC_BUFFER_SIZE)) {
>>> +			dev_err(video->dev,
>>> +				"failed to allocate source buffers\n");
>>> +			return -ENOMEM;
>>> +		}
>>> +	}
>>> +
>>> +	aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
>>> +
>>> +	do {
>>> +		if (tries) {
>>> +			set_current_state(TASK_INTERRUPTIBLE);
>>> +			if (schedule_timeout(INVALID_RESOLUTION_DELAY))
>>> +				return -EINTR;
>>> +		}
>>> +
>>> +		aspeed_video_enable_mode_detect(video);
>>> +
>>> +		rc = wait_event_interruptible_timeout(video->wait,
>>> +						      res_check(video),
>>> +						      MODE_DETECT_TIMEOUT);
>>> +		if (!rc) {
>>> +			dev_err(video->dev, "timed out on 1st mode detect\n");
>>> +			aspeed_video_disable_mode_detect(video);
>>> +			return -ETIMEDOUT;
>>> +		}
>>> +
>>> +		/* Disable mode detect in order to re-trigger */
>>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>>> +				    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
>>> +
>>> +		aspeed_video_check_and_set_polarity(video);
>>> +
>>> +		aspeed_video_enable_mode_detect(video);
>>> +
>>> +		rc = wait_event_interruptible_timeout(video->wait,
>>> +						      res_check(video),
>>> +						      MODE_DETECT_TIMEOUT);
>>> +		if (!rc) {
>>> +			dev_err(video->dev, "timed out on 2nd mode detect\n");
>>> +			aspeed_video_disable_mode_detect(video);
>>> +			return -ETIMEDOUT;
>>> +		}
>>> +
>>> +		src_lr_edge = aspeed_video_read(video, VE_SRC_LR_EDGE_DET);
>>> +		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
>>> +		mds = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>>> +		sync = aspeed_video_read(video, VE_SYNC_STATUS);
>>> +
>>> +		video->frame_bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
>>> +			VE_SRC_TB_EDGE_DET_BOT_SHF;
>>> +		video->frame_top = src_tb_edge & VE_SRC_TB_EDGE_DET_TOP;
>>> +		det->vfrontporch = video->frame_top;
>>> +		det->vbackporch = ((mds & VE_MODE_DETECT_V_LINES) >>
>>> +			VE_MODE_DETECT_V_LINES_SHF) - video->frame_bottom;
>>> +		det->vsync = (sync & VE_SYNC_STATUS_VSYNC) >>
>>> +			VE_SYNC_STATUS_VSYNC_SHF;
>>> +		if (video->frame_top > video->frame_bottom)
>>> +			continue;
>>> +
>>> +		video->frame_right = (src_lr_edge & VE_SRC_LR_EDGE_DET_RT) >>
>>> +			VE_SRC_LR_EDGE_DET_RT_SHF;
>>> +		video->frame_left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
>>> +		det->hfrontporch = video->frame_left;
>>> +		det->hbackporch = (mds & VE_MODE_DETECT_H_PIXELS) -
>>> +			video->frame_right;
>>> +		det->hsync = sync & VE_SYNC_STATUS_HSYNC;
>>> +		if (video->frame_left > video->frame_right)
>>> +			continue;
>>> +
>>> +		invalid_resolution = false;
>>> +	} while (invalid_resolution && (tries++ < INVALID_RESOLUTION_RETRIES));
>>> +
>>> +	if (invalid_resolution) {
>>> +		dev_err(video->dev, "invalid resolution detected\n");
>>> +		return -ERANGE;
>>> +	}
>>> +
>>> +	det->height = (video->frame_bottom - video->frame_top) + 1;
>>> +	det->width = (video->frame_right - video->frame_left) + 1;
>>> +
>>> +	/*
>>> +	 * Disable mode-detect watchdog, enable resolution-change watchdog and
>>> +	 * automatic compression after frame capture.
>>> +	 */
>>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0,
>>> +			    VE_INTERRUPT_MODE_DETECT_WD);
>>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0,
>>> +			    VE_SEQ_CTRL_AUTO_COMP | VE_SEQ_CTRL_EN_WATCHDOG);
>>> +
>>> +	dev_dbg(video->dev, "got resolution[%dx%d]\n", det->width,
>>> +		det->height);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_resolution(struct aspeed_video *video)
>>> +{
>>> +	struct v4l2_bt_timings *act = &video->active_timings;
>>> +	unsigned int size = act->width * act->height;
>>> +
>>> +	aspeed_video_calc_compressed_size(video, size);
>>> +
>>> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
>>> +	if (size < DIRECT_FETCH_THRESHOLD) {
>>> +		aspeed_video_write(video, VE_TGS_0,
>>> +				   FIELD_PREP(VE_TGS_FIRST,
>>> +					      video->frame_left - 1) |
>>> +				   FIELD_PREP(VE_TGS_LAST,
>>> +					      video->frame_right));
>>> +		aspeed_video_write(video, VE_TGS_1,
>>> +				   FIELD_PREP(VE_TGS_FIRST, video->frame_top) |
>>> +				   FIELD_PREP(VE_TGS_LAST,
>>> +					      video->frame_bottom + 1));
>>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_INT_DE);
>>> +	} else {
>>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_DIRECT_FETCH);
>>> +	}
>>> +
>>> +	/* Set capture/compression frame sizes */
>>> +	aspeed_video_write(video, VE_CAP_WINDOW,
>>> +			   act->width << 16 | act->height);
>>> +	aspeed_video_write(video, VE_COMP_WINDOW,
>>> +			   act->width << 16 | act->height);
>>> +	aspeed_video_write(video, VE_SRC_SCANLINE_OFFSET, act->width * 4);
>>> +
>>> +	size *= 4;
>>> +
>>> +	if (size == video->srcs[0].size / 2) {
>>> +		aspeed_video_write(video, VE_SRC1_ADDR,
>>> +				   video->srcs[0].dma + size);
>>> +	} else if (size == video->srcs[0].size) {
>>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>>> +			goto err_mem;
>>> +
>>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>>> +	} else {
>>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>>> +
>>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0], size))
>>> +			goto err_mem;
>>> +
>>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>>> +			goto err_mem;
>>> +
>>> +		aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
>>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>>> +	}
>>> +
>>> +	return 0;
>>> +
>>> +err_mem:
>>> +	dev_err(video->dev, "failed to allocate source buffers\n");
>>> +
>>> +	if (video->srcs[0].size)
>>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>>> +
>>> +	return -ENOMEM;
>>> +}
>>> +
>>> +static void aspeed_video_init_regs(struct aspeed_video *video)
>>> +{
>>> +	u32 comp_ctrl = VE_COMP_CTRL_RSVD |
>>> +		FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>>> +	u32 ctrl = VE_CTRL_AUTO_OR_CURSOR;
>>> +	u32 seq_ctrl = VE_SEQ_CTRL_JPEG_MODE;
>>> +
>>> +	if (video->frame_rate)
>>> +		ctrl |= FIELD_PREP(VE_CTRL_FRC, video->frame_rate);
>>> +
>>> +	if (video->yuv420)
>>> +		seq_ctrl |= VE_SEQ_CTRL_YUV420;
>>> +
>>> +	/* Unlock VE registers */
>>> +	aspeed_video_write(video, VE_PROTECTION_KEY, VE_PROTECTION_KEY_UNLOCK);
>>> +
>>> +	/* Disable interrupts */
>>> +	aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
>>> +	aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
>>> +
>>> +	/* Clear the offset */
>>> +	aspeed_video_write(video, VE_COMP_PROC_OFFSET, 0);
>>> +	aspeed_video_write(video, VE_COMP_OFFSET, 0);
>>> +
>>> +	aspeed_video_write(video, VE_JPEG_ADDR, video->jpeg.dma);
>>> +
>>> +	/* Set control registers */
>>> +	aspeed_video_write(video, VE_SEQ_CTRL, seq_ctrl);
>>> +	aspeed_video_write(video, VE_CTRL, ctrl);
>>> +	aspeed_video_write(video, VE_COMP_CTRL, comp_ctrl);
>>> +
>>> +	/* Don't downscale */
>>> +	aspeed_video_write(video, VE_SCALING_FACTOR, 0x10001000);
>>> +	aspeed_video_write(video, VE_SCALING_FILTER0, 0x00200000);
>>> +	aspeed_video_write(video, VE_SCALING_FILTER1, 0x00200000);
>>> +	aspeed_video_write(video, VE_SCALING_FILTER2, 0x00200000);
>>> +	aspeed_video_write(video, VE_SCALING_FILTER3, 0x00200000);
>>> +
>>> +	/* Set mode detection defaults */
>>> +	aspeed_video_write(video, VE_MODE_DETECT, 0x22666500);
>>> +}
>>> +
>>> +static int aspeed_video_start(struct aspeed_video *video)
>>> +{
>>> +	int rc;
>>> +
>>> +	aspeed_video_on(video);
>>> +
>>> +	aspeed_video_init_regs(video);
>>> +
>>> +	rc = aspeed_video_get_resolution(video);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	/*
>>> +	 * Set the timings here since the device was just opened for the first
>>> +	 * time.
>>> +	 */
>>> +	video->active_timings = video->detected_timings;
>> What happens if no valid signal was detected?
>>
>> My recommendation is to fallback to some default timings (VGA?) if no valid
>> initial timings were found.
>>
>> The expectation is that applications will always call QUERY_DV_TIMINGS first,
>> so it is really not all that important what the initial active_timings are,
>> as long as they are valid timings (valid as in: something that the hardware
>> can support).
> 
> See just above, this call returns with a failure if no signal is 
> detected, meaning the device cannot be opened. The only valid timings 
> are the detected timings.

That's wrong. You must ALWAYS be able to open the device. If not valid
resolution is detected, just fallback to some default.

> 
>>
>>> +
>>> +	rc = aspeed_video_set_resolution(video);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	video->pix_fmt.width = video->detected_timings.width;
>>> +	video->pix_fmt.height = video->detected_timings.height;
>> That must be active_timings.
> 
> OK sure, but they are the same at this point.

Yes, but it is confusing for the reading (i.e. me).

> 
>>
>>> +	video->pix_fmt.sizeimage = video->max_compressed_size;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void aspeed_video_stop(struct aspeed_video *video)
>>> +{
>>> +	cancel_delayed_work_sync(&video->res_work);
>>> +
>>> +	aspeed_video_off(video);
>>> +
>>> +	if (video->srcs[0].size)
>>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>>> +
>>> +	if (video->srcs[1].size)
>>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>>> +
>>> +	video->flags = 0;
>>> +}
>>> +
>>> +static int aspeed_video_querycap(struct file *file, void *fh,
>>> +				 struct v4l2_capability *cap)
>>> +{
>>> +	strscpy(cap->driver, DEVICE_NAME, sizeof(cap->driver));
>>> +	strscpy(cap->card, "Aspeed Video Engine", sizeof(cap->card));
>>> +	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
>>> +		 DEVICE_NAME);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_format(struct file *file, void *fh,
>>> +				    struct v4l2_fmtdesc *f)
>>> +{
>>> +	if (f->index)
>>> +		return -EINVAL;
>>> +
>>> +	f->pixelformat = V4L2_PIX_FMT_JPEG;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_format(struct file *file, void *fh,
>>> +				   struct v4l2_format *f)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	f->fmt.pix = video->pix_fmt;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_input(struct file *file, void *fh,
>>> +				   struct v4l2_input *inp)
>>> +{
>>> +	if (inp->index)
>>> +		return -EINVAL;
>>> +
>>> +	strscpy(inp->name, "Host VGA capture", sizeof(inp->name));
>>> +	inp->type = V4L2_INPUT_TYPE_CAMERA;
>>> +	inp->capabilities = V4L2_IN_CAP_DV_TIMINGS;
>>> +	inp->status = 0;
>> Status should be updated according to the current detection status:
>>
>> Set V4L2_IN_ST_NO_SIGNAL if no valid signal is detected. If you can detect
>> that there is a signal, but you cannot sync to it, then set V4L2_IN_ST_NO_SYNC
>> as well (depends on your hardware).
> 
> Right, but the device can't be opened if there is no signal.
> 
>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_input(struct file *file, void *fh, unsigned int *i)
>>> +{
>>> +	*i = 0;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_input(struct file *file, void *fh, unsigned int i)
>>> +{
>>> +	if (i)
>>> +		return -EINVAL;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_parm(struct file *file, void *fh,
>>> +				 struct v4l2_streamparm *a)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> +	a->parm.capture.readbuffers = 3;
>>> +	a->parm.capture.timeperframe.numerator = 1;
>>> +	if (!video->frame_rate)
>>> +		a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE;
>>> +	else
>>> +		a->parm.capture.timeperframe.denominator = video->frame_rate;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_parm(struct file *file, void *fh,
>>> +				 struct v4l2_streamparm *a)
>>> +{
>>> +	unsigned int frame_rate = 0;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	a->parm.capture.capability = V4L2_CAP_TIMEPERFRAME;
>>> +	a->parm.capture.readbuffers = 3;
>>> +
>>> +	if (a->parm.capture.timeperframe.numerator)
>>> +		frame_rate = a->parm.capture.timeperframe.denominator /
>>> +			a->parm.capture.timeperframe.numerator;
>>> +
>>> +	if (!frame_rate || frame_rate > MAX_FRAME_RATE) {
>>> +		frame_rate = 0;
>>> +		a->parm.capture.timeperframe.denominator = MAX_FRAME_RATE;
>>> +		a->parm.capture.timeperframe.numerator = 1;
>>> +	}
>>> +
>>> +	if (video->frame_rate != frame_rate) {
>>> +		video->frame_rate = frame_rate;
>>> +		aspeed_video_update(video, VE_CTRL, VE_CTRL_FRC,
>>> +				    FIELD_PREP(VE_CTRL_FRC, frame_rate));
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_framesizes(struct file *file, void *fh,
>>> +					struct v4l2_frmsizeenum *fsize)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (fsize->index)
>>> +		return -EINVAL;
>>> +
>>> +	if (fsize->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +		return -EINVAL;
>>> +
>>> +	fsize->discrete.width = video->pix_fmt.width;
>>> +	fsize->discrete.height = video->pix_fmt.height;
>>> +	fsize->type = V4L2_FRMSIZE_TYPE_DISCRETE;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_frameintervals(struct file *file, void *fh,
>>> +					    struct v4l2_frmivalenum *fival)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (fival->index)
>>> +		return -EINVAL;
>>> +
>>> +	if (fival->width != video->detected_timings.width ||
>>> +	    fival->height != video->detected_timings.height)
>>> +		return -EINVAL;
>>> +
>>> +	if (fival->pixel_format != V4L2_PIX_FMT_JPEG)
>>> +		return -EINVAL;
>>> +
>>> +	fival->type = V4L2_FRMIVAL_TYPE_CONTINUOUS;
>>> +
>>> +	fival->stepwise.min.denominator = MAX_FRAME_RATE;
>>> +	fival->stepwise.min.numerator = 1;
>>> +	fival->stepwise.max.denominator = 1;
>>> +	fival->stepwise.max.numerator = 1;
>>> +	fival->stepwise.step = fival->stepwise.max;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_set_dv_timings(struct file *file, void *fh,
>>> +				       struct v4l2_dv_timings *timings)
>>> +{
>>> +	int rc;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (timings->bt.width == video->active_timings.width &&
>>> +	    timings->bt.height == video->active_timings.height)
>>> +		return 0;
>>> +
>>> +	if (vb2_is_busy(&video->queue))
>>> +		return -EBUSY;
>>> +
>>> +	video->active_timings = timings->bt;
>>> +
>>> +	rc = aspeed_video_set_resolution(video);
>>> +	if (rc)
>>> +		return rc;
>>> +
>>> +	video->pix_fmt.width = timings->bt.width;
>>> +	video->pix_fmt.height = timings->bt.height;
>>> +	video->pix_fmt.sizeimage = video->max_compressed_size;
>>> +
>>> +	timings->type = V4L2_DV_BT_656_1120;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_get_dv_timings(struct file *file, void *fh,
>>> +				       struct v4l2_dv_timings *timings)
>>> +{
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	timings->type = V4L2_DV_BT_656_1120;
>>> +	timings->bt = video->active_timings;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_query_dv_timings(struct file *file, void *fh,
>>> +					 struct v4l2_dv_timings *timings)
>>> +{
>>> +	int rc;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	if (file->f_flags & O_NONBLOCK) {
>>> +		if (test_bit(VIDEO_RES_CHANGE, &video->flags))
>>> +			return -EAGAIN;
>>> +	} else {
>>> +		rc = wait_event_interruptible(video->wait,
>>> +					      !test_bit(VIDEO_RES_CHANGE,
>>> +							&video->flags));
>>> +		if (rc)
>>> +			return -EINTR;
>>> +	}
>>> +
>>> +	timings->type = V4L2_DV_BT_656_1120;
>>> +	timings->bt = video->detected_timings;
>> So this blocks until there is a valid signal? That's not what it should do.
>> If there is no signal detected it should return an error, not block.
> 
> It only blocks if the driver is in the process of re-detecting the 
> resolution; so we got an interrupt that the resolution changes, shut 
> down the engine, and are waiting to restart and re-detect the 
> resolution. This is limited by timeouts.

Ah, OK. That wasn't clear. Perhaps add a comment explaining that worst-case
the wait will return within so many milliseconds?

> I think this is reasonable to wait here because we know that we will 
> either get the new timings or no signal. There would be no point to 
> return the old timings, and immediately returning error would presumably 
> make applications give up even though a second later everything should 
> be good. I should add a check and return an error here if we got no 
> signal though.

Right.

> 
>>
>> See https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-query-dv-timings.html
>> for a list of possible error codes depending on whether there is no signal, or
>> whether there is no sync, or it is out-of-range.
>>
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_enum_dv_timings(struct file *file, void *fh,
>>> +					struct v4l2_enum_dv_timings *timings)
>>> +{
>>> +	if (timings->index)
>>> +		return -EINVAL;
>>> +
>>> +	return aspeed_video_get_dv_timings(file, fh, &timings->timings);
>> Just use v4l2_enum_dv_timings_cap here.
> 
> Oh, sure.
> 
>>
>>> +}
>>> +
>>> +static int aspeed_video_dv_timings_cap(struct file *file, void *fh,
>>> +				       struct v4l2_dv_timings_cap *cap)
>>> +{
>>> +	*cap = aspeed_video_timings_cap;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int aspeed_video_sub_event(struct v4l2_fh *fh,
>>> +				  const struct v4l2_event_subscription *sub)
>>> +{
>>> +	switch (sub->type) {
>>> +	case V4L2_EVENT_SOURCE_CHANGE:
>>> +		return v4l2_src_change_event_subscribe(fh, sub);
>>> +	}
>>> +
>>> +	return v4l2_ctrl_subscribe_event(fh, sub);
>>> +}
>>> +
>>> +static const struct v4l2_ioctl_ops aspeed_video_ioctl_ops = {
>>> +	.vidioc_querycap = aspeed_video_querycap,
>>> +
>>> +	.vidioc_enum_fmt_vid_cap = aspeed_video_enum_format,
>>> +	.vidioc_g_fmt_vid_cap = aspeed_video_get_format,
>>> +	.vidioc_s_fmt_vid_cap = aspeed_video_get_format,
>>> +	.vidioc_try_fmt_vid_cap = aspeed_video_get_format,
>>> +
>>> +	.vidioc_reqbufs = vb2_ioctl_reqbufs,
>>> +	.vidioc_querybuf = vb2_ioctl_querybuf,
>>> +	.vidioc_qbuf = vb2_ioctl_qbuf,
>>> +	.vidioc_expbuf = vb2_ioctl_expbuf,
>>> +	.vidioc_dqbuf = vb2_ioctl_dqbuf,
>>> +	.vidioc_create_bufs = vb2_ioctl_create_bufs,
>>> +	.vidioc_prepare_buf = vb2_ioctl_prepare_buf,
>>> +	.vidioc_streamon = vb2_ioctl_streamon,
>>> +	.vidioc_streamoff = vb2_ioctl_streamoff,
>>> +
>>> +	.vidioc_enum_input = aspeed_video_enum_input,
>>> +	.vidioc_g_input = aspeed_video_get_input,
>>> +	.vidioc_s_input = aspeed_video_set_input,
>>> +
>>> +	.vidioc_g_parm = aspeed_video_get_parm,
>>> +	.vidioc_s_parm = aspeed_video_set_parm,
>>> +	.vidioc_enum_framesizes = aspeed_video_enum_framesizes,
>>> +	.vidioc_enum_frameintervals = aspeed_video_enum_frameintervals,
>>> +
>>> +	.vidioc_s_dv_timings = aspeed_video_set_dv_timings,
>>> +	.vidioc_g_dv_timings = aspeed_video_get_dv_timings,
>>> +	.vidioc_query_dv_timings = aspeed_video_query_dv_timings,
>>> +	.vidioc_enum_dv_timings = aspeed_video_enum_dv_timings,
>>> +	.vidioc_dv_timings_cap = aspeed_video_dv_timings_cap,
>>> +
>>> +	.vidioc_subscribe_event = aspeed_video_sub_event,
>>> +	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>>> +};
>>> +
>>> +static void aspeed_video_update_jpeg_quality(struct aspeed_video *video)
>>> +{
>>> +	u32 comp_ctrl = FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>>> +
>>> +	aspeed_video_update(video, VE_COMP_CTRL,
>>> +			    VE_COMP_CTRL_DCT_LUM | VE_COMP_CTRL_DCT_CHR,
>>> +			    comp_ctrl);
>>> +}
>>> +
>>> +static void aspeed_video_update_subsampling(struct aspeed_video *video)
>>> +{
>>> +	if (video->jpeg.virt)
>>> +		aspeed_video_init_jpeg_table(video->jpeg.virt, video->yuv420);
>>> +
>>> +	if (video->yuv420)
>>> +		aspeed_video_update(video, VE_SEQ_CTRL, 0, VE_SEQ_CTRL_YUV420);
>>> +	else
>>> +		aspeed_video_update(video, VE_SEQ_CTRL, VE_SEQ_CTRL_YUV420, 0);
>>> +}
>>> +
>>> +static int aspeed_video_set_ctrl(struct v4l2_ctrl *ctrl)
>>> +{
>>> +	struct aspeed_video *video = container_of(ctrl->handler,
>>> +						  struct aspeed_video,
>>> +						  ctrl_handler);
>>> +
>>> +	switch (ctrl->id) {
>>> +	case V4L2_CID_JPEG_COMPRESSION_QUALITY:
>>> +		video->jpeg_quality = ctrl->val;
>>> +		aspeed_video_update_jpeg_quality(video);
>>> +		break;
>>> +	case V4L2_CID_JPEG_CHROMA_SUBSAMPLING:
>>> +		if (ctrl->val == V4L2_JPEG_CHROMA_SUBSAMPLING_420) {
>>> +			video->yuv420 = true;
>>> +			aspeed_video_update_subsampling(video);
>>> +		} else {
>>> +			video->yuv420 = false;
>>> +			aspeed_video_update_subsampling(video);
>>> +		}
>>> +		break;
>>> +	default:
>>> +		return -EINVAL;
>>> +	}
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static const struct v4l2_ctrl_ops aspeed_video_ctrl_ops = {
>>> +	.s_ctrl = aspeed_video_set_ctrl,
>>> +};
>>> +
>>> +static void aspeed_video_resolution_work(struct work_struct *work)
>>> +{
>>> +	int rc;
>>> +	struct delayed_work *dwork = to_delayed_work(work);
>>> +	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
>>> +						  res_work);
>>> +
>>> +	/* No clients remaining after delay */
>>> +	if (atomic_read(&video->clients) == 0)
>>> +		goto done;
>>> +
>>> +	aspeed_video_on(video);
>>> +
>>> +	aspeed_video_init_regs(video);
>>> +
>>> +	rc = aspeed_video_get_resolution(video);
>>> +	if (rc)
>>> +		dev_err(video->dev,
>>> +			"resolution changed; couldn't get new resolution\n");
>>> +
>>> +	if (video->detected_timings.width != video->active_timings.width ||
>>> +	    video->detected_timings.height != video->active_timings.height) {
>>> +		static const struct v4l2_event ev = {
>>> +			.type = V4L2_EVENT_SOURCE_CHANGE,
>>> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>>> +		};
>>> +
>>> +		v4l2_event_queue(&video->vdev, &ev);
>>> +	}
>>> +
>>> +done:
>>> +	clear_bit(VIDEO_RES_CHANGE, &video->flags);
>>> +	wake_up_interruptible_all(&video->wait);
>>> +}
>>> +
>>> +static int aspeed_video_open(struct file *file)
>>> +{
>>> +	int rc;
>>> +	struct aspeed_video *video = video_drvdata(file);
>>> +
>>> +	mutex_lock(&video->video_lock);
>>> +
>>> +	if (atomic_inc_return(&video->clients) == 1) {
>> I think I commented on this before: just use v4l2_fh_is_singular_file(). See e.g.
>> isc_open/release in drivers/media/platform/atmel/atmel-isc.c.
> 
> Indeed, I also replied before indicating that I'm using the clients 
> counter in aspeed_video_resolution_work where it would be tricky to 
> determine if there are no files open. I need that check to avoid turning 
> everything on again when no one is using it.

That makes no sense. aspeed_video_stop should stop aspeed_video_resolution_work().
I.e., aspeed_video_resolution_work() should never be running when the device is
not open.

Actually, you do that already.

Same for the irq routine: just make sure the interrupts are disabled in
aspeed_video_stop() and you are good.

Regards,

	Hans
