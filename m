Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC8AC5CFFE
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 10:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F132084A
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 10:45:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3F132084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xs4all.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbeLKKo7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 05:44:59 -0500
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:59366 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726114AbeLKKo6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 05:44:58 -0500
Received: from [IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a] ([IPv6:2001:983:e9a7:1:5434:d88b:a352:4c5a])
        by smtp-cloud7.xs4all.net with ESMTPA
        id WfWqgG1ddQMWUWfWrg6vFW; Tue, 11 Dec 2018 11:44:53 +0100
Subject: Re: [PATCH v7 2/2] media: platform: Add Aspeed Video Engine driver
To:     Eddie James <eajames@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
 <1544480791-92746-3-git-send-email-eajames@linux.ibm.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6567e0a4-ad58-1340-199e-e5d5b267f3ac@xs4all.nl>
Date:   Tue, 11 Dec 2018 11:44:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1544480791-92746-3-git-send-email-eajames@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPTzEw3sx9WVtesCZli37Nu/cCJPcE8SouihVLF91uf9qqjoxm1VM+o1ZKJ3SeGOJwzU0x+pv4+fB+/o9njDFfCsQdKmFn2wwydq5dZ2UqtlQuEOHWep
 LgM/Bh39QDc8pKbZ+8PO3sSgvzF+3u5kThkhUrkY96W833IkzC5LXG5Z/M62VKD/ZBeiMA6wcF7fGS1vcn1CfGI+sfzy/u9Mb0hn4NSsuxzH/WSVg6iKH+j3
 k6GX20kTABoi0wMipNNkM7L9swXD6cuhv6E+JjR4HP78SgQOhUGR56A+InkZqIxNoIm0BLLOiGSioKpf4xmC8x9tbA33xziZhodT/XJU+Pni5BBq/Q2EORwl
 0Cz/NkuojijKZEp1ASfCGuciGjg24+ITrrJsy+qGRwAkdNLOVv9mleBwDwtQvXHI5Dp5Lyjr3QIMg17C8W3MSiJX+nHAU3sfDRy5zopiXsoeRvvYB0f55eV+
 ZvxdWqrOYQ8S1tk7zPc0ZjOE1/ROjyTby9U+FXWBQMgY2aujm7H0MgLI5do=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 12/10/18 11:26 PM, Eddie James wrote:
> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
> can capture and compress video data from digital or analog sources. With
> the Aspeed chip acting a service processor, the Video Engine can capture
> the host processor graphics output.
> 
> Add a V4L2 driver to capture video data and compress it to JPEG images.
> Make the video frames available through the V4L2 streaming interface.
> 
> Signed-off-by: Eddie James <eajames@linux.ibm.com>
> ---

<snip>

> +static void aspeed_video_irq_res_change(struct aspeed_video *video)
> +{
> +	dev_dbg(video->dev, "Resolution changed; resetting\n");
> +
> +	set_bit(VIDEO_RES_CHANGE, &video->flags);
> +	clear_bit(VIDEO_FRAME_INPRG, &video->flags);
> +
> +	aspeed_video_off(video);
> +	aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
> +
> +	schedule_delayed_work(&video->res_work, RESOLUTION_CHANGE_DELAY);
> +}
> +
> +static irqreturn_t aspeed_video_irq(int irq, void *arg)
> +{
> +	struct aspeed_video *video = arg;
> +	u32 sts = aspeed_video_read(video, VE_INTERRUPT_STATUS);
> +
> +	/* Resolution changed; reset entire engine and reinitialize */
> +	if (sts & VE_INTERRUPT_MODE_DETECT_WD) {

Does this only trigger when the resolution changed, or also when the signal
disappears? For the purpose of this review I assume that it is also triggered
when the signal goes away. The comment should be updated in that case that
it is not just resolution changes, but also a dropped video signal.

> +		aspeed_video_irq_res_change(video);
> +		return IRQ_HANDLED;
> +	}
> +
> +	if (sts & VE_INTERRUPT_MODE_DETECT) {
> +		if (test_bit(VIDEO_RES_DETECT, &video->flags)) {
> +			aspeed_video_update(video, VE_INTERRUPT_CTRL,
> +					    VE_INTERRUPT_MODE_DETECT, 0);
> +			aspeed_video_write(video, VE_INTERRUPT_STATUS,
> +					   VE_INTERRUPT_MODE_DETECT);
> +
> +			set_bit(VIDEO_MODE_DETECT_DONE, &video->flags);
> +			wake_up_interruptible_all(&video->wait);
> +		} else {
> +			aspeed_video_irq_res_change(video);
> +			return IRQ_HANDLED;
> +		}
> +	}
> +
> +	if ((sts & VE_INTERRUPT_COMP_COMPLETE) &&
> +	    (sts & VE_INTERRUPT_CAPTURE_COMPLETE)) {
> +		struct aspeed_video_buffer *buf;
> +		u32 frame_size = aspeed_video_read(video,
> +						   VE_OFFSET_COMP_STREAM);
> +
> +		spin_lock(&video->lock);
> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
> +		buf = list_first_entry_or_null(&video->buffers,
> +					       struct aspeed_video_buffer,
> +					       link);
> +		if (buf) {
> +			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, frame_size);
> +
> +			if (!list_is_last(&buf->link, &video->buffers)) {
> +				buf->vb.vb2_buf.timestamp = ktime_get_ns();
> +				buf->vb.sequence = video->sequence++;
> +				buf->vb.field = V4L2_FIELD_NONE;
> +				vb2_buffer_done(&buf->vb.vb2_buf,
> +						VB2_BUF_STATE_DONE);
> +				list_del(&buf->link);
> +			}
> +		}
> +		spin_unlock(&video->lock);
> +
> +		aspeed_video_update(video, VE_SEQ_CTRL,
> +				    VE_SEQ_CTRL_TRIG_CAPTURE |
> +				    VE_SEQ_CTRL_FORCE_IDLE |
> +				    VE_SEQ_CTRL_TRIG_COMP, 0);
> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
> +				    VE_INTERRUPT_COMP_COMPLETE |
> +				    VE_INTERRUPT_CAPTURE_COMPLETE, 0);
> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
> +				   VE_INTERRUPT_COMP_COMPLETE |
> +				   VE_INTERRUPT_CAPTURE_COMPLETE);
> +
> +		if (test_bit(VIDEO_STREAMING, &video->flags) && buf)
> +			aspeed_video_start_frame(video);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

<snip>

> +static void aspeed_video_get_resolution(struct aspeed_video *video)
> +{
> +	bool invalid_resolution = true;
> +	int rc;
> +	int tries = 0;
> +	u32 mds;
> +	u32 src_lr_edge;
> +	u32 src_tb_edge;
> +	u32 sync;
> +	struct v4l2_bt_timings *det = &video->detected_timings;
> +
> +	det->width = MIN_WIDTH;
> +	det->height = MIN_HEIGHT;
> +	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
> +
> +	/*
> +	 * Since we need max buffer size for detection, free the second source
> +	 * buffer first.
> +	 */
> +	if (video->srcs[1].size)
> +		aspeed_video_free_buf(video, &video->srcs[1]);
> +
> +	if (video->srcs[0].size < VE_MAX_SRC_BUFFER_SIZE) {
> +		if (video->srcs[0].size)
> +			aspeed_video_free_buf(video, &video->srcs[0]);
> +
> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0],
> +					    VE_MAX_SRC_BUFFER_SIZE)) {
> +			dev_err(video->dev,
> +				"Failed to allocate source buffers\n");
> +			return;
> +		}
> +	}
> +
> +	aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
> +
> +	do {
> +		if (tries) {
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			if (schedule_timeout(INVALID_RESOLUTION_DELAY))
> +				return;
> +		}
> +
> +		set_bit(VIDEO_RES_DETECT, &video->flags);
> +		aspeed_video_enable_mode_detect(video);
> +
> +		rc = wait_event_interruptible_timeout(video->wait,
> +						      res_check(video),
> +						      MODE_DETECT_TIMEOUT);
> +		if (!rc) {
> +			dev_err(video->dev, "Timed out; first mode detect\n");
> +			clear_bit(VIDEO_RES_DETECT, &video->flags);
> +			return;
> +		}
> +
> +		/* Disable mode detect in order to re-trigger */
> +		aspeed_video_update(video, VE_SEQ_CTRL,
> +				    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
> +
> +		aspeed_video_check_and_set_polarity(video);
> +
> +		aspeed_video_enable_mode_detect(video);
> +
> +		rc = wait_event_interruptible_timeout(video->wait,
> +						      res_check(video),
> +						      MODE_DETECT_TIMEOUT);
> +		clear_bit(VIDEO_RES_DETECT, &video->flags);
> +		if (!rc) {
> +			dev_err(video->dev, "Timed out; second mode detect\n");
> +			return;
> +		}
> +
> +		src_lr_edge = aspeed_video_read(video, VE_SRC_LR_EDGE_DET);
> +		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
> +		mds = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
> +		sync = aspeed_video_read(video, VE_SYNC_STATUS);
> +
> +		video->frame_bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
> +			VE_SRC_TB_EDGE_DET_BOT_SHF;
> +		video->frame_top = src_tb_edge & VE_SRC_TB_EDGE_DET_TOP;
> +		det->vfrontporch = video->frame_top;
> +		det->vbackporch = ((mds & VE_MODE_DETECT_V_LINES) >>
> +			VE_MODE_DETECT_V_LINES_SHF) - video->frame_bottom;
> +		det->vsync = (sync & VE_SYNC_STATUS_VSYNC) >>
> +			VE_SYNC_STATUS_VSYNC_SHF;
> +		if (video->frame_top > video->frame_bottom)
> +			continue;
> +
> +		video->frame_right = (src_lr_edge & VE_SRC_LR_EDGE_DET_RT) >>
> +			VE_SRC_LR_EDGE_DET_RT_SHF;
> +		video->frame_left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
> +		det->hfrontporch = video->frame_left;
> +		det->hbackporch = (mds & VE_MODE_DETECT_H_PIXELS) -
> +			video->frame_right;
> +		det->hsync = sync & VE_SYNC_STATUS_HSYNC;
> +		if (video->frame_left > video->frame_right)
> +			continue;
> +
> +		invalid_resolution = false;
> +	} while (invalid_resolution && (tries++ < INVALID_RESOLUTION_RETRIES));
> +
> +	if (invalid_resolution) {
> +		dev_err(video->dev, "Invalid resolution detected\n");
> +		return;
> +	}
> +
> +	det->height = (video->frame_bottom - video->frame_top) + 1;
> +	det->width = (video->frame_right - video->frame_left) + 1;
> +	video->v4l2_input_status = 0;
> +
> +	/*
> +	 * Enable mode-detect watchdog, resolution-change watchdog and
> +	 * automatic compression after frame capture.
> +	 */
> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0,
> +			    VE_INTERRUPT_MODE_DETECT_WD);
> +	aspeed_video_update(video, VE_SEQ_CTRL, 0,
> +			    VE_SEQ_CTRL_AUTO_COMP | VE_SEQ_CTRL_EN_WATCHDOG);
> +
> +	dev_dbg(video->dev, "Got resolution: %dx%d\n", det->width,
> +		det->height);
> +}
> +
> +static void aspeed_video_set_resolution(struct aspeed_video *video)
> +{
> +	struct v4l2_bt_timings *act = &video->active_timings;
> +	unsigned int size = act->width * act->height;
> +
> +	aspeed_video_calc_compressed_size(video, size);
> +
> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
> +	if (size < DIRECT_FETCH_THRESHOLD) {
> +		aspeed_video_write(video, VE_TGS_0,
> +				   FIELD_PREP(VE_TGS_FIRST,
> +					      video->frame_left - 1) |
> +				   FIELD_PREP(VE_TGS_LAST,
> +					      video->frame_right));
> +		aspeed_video_write(video, VE_TGS_1,
> +				   FIELD_PREP(VE_TGS_FIRST, video->frame_top) |
> +				   FIELD_PREP(VE_TGS_LAST,
> +					      video->frame_bottom + 1));
> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_INT_DE);
> +	} else {
> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_DIRECT_FETCH);
> +	}
> +
> +	/* Set capture/compression frame sizes */
> +	aspeed_video_write(video, VE_CAP_WINDOW,
> +			   act->width << 16 | act->height);
> +	aspeed_video_write(video, VE_COMP_WINDOW,
> +			   act->width << 16 | act->height);
> +	aspeed_video_write(video, VE_SRC_SCANLINE_OFFSET, act->width * 4);
> +
> +	size *= 4;
> +
> +	if (size == video->srcs[0].size / 2) {
> +		aspeed_video_write(video, VE_SRC1_ADDR,
> +				   video->srcs[0].dma + size);
> +	} else if (size == video->srcs[0].size) {
> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
> +			goto err_mem;
> +
> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
> +	} else {
> +		aspeed_video_free_buf(video, &video->srcs[0]);
> +
> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0], size))
> +			goto err_mem;
> +
> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
> +			goto err_mem;
> +
> +		aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
> +	}
> +
> +	return;
> +
> +err_mem:
> +	dev_err(video->dev, "Failed to allocate source buffers\n");
> +
> +	if (video->srcs[0].size)
> +		aspeed_video_free_buf(video, &video->srcs[0]);
> +}
> +
> +static void aspeed_video_init_regs(struct aspeed_video *video)
> +{
> +	u32 comp_ctrl = VE_COMP_CTRL_RSVD |
> +		FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
> +	u32 ctrl = VE_CTRL_AUTO_OR_CURSOR;
> +	u32 seq_ctrl = VE_SEQ_CTRL_JPEG_MODE;
> +
> +	if (video->frame_rate)
> +		ctrl |= FIELD_PREP(VE_CTRL_FRC, video->frame_rate);
> +
> +	if (video->yuv420)
> +		seq_ctrl |= VE_SEQ_CTRL_YUV420;
> +
> +	/* Unlock VE registers */
> +	aspeed_video_write(video, VE_PROTECTION_KEY, VE_PROTECTION_KEY_UNLOCK);
> +
> +	/* Disable interrupts */
> +	aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
> +	aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
> +
> +	/* Clear the offset */
> +	aspeed_video_write(video, VE_COMP_PROC_OFFSET, 0);
> +	aspeed_video_write(video, VE_COMP_OFFSET, 0);
> +
> +	aspeed_video_write(video, VE_JPEG_ADDR, video->jpeg.dma);
> +
> +	/* Set control registers */
> +	aspeed_video_write(video, VE_SEQ_CTRL, seq_ctrl);
> +	aspeed_video_write(video, VE_CTRL, ctrl);
> +	aspeed_video_write(video, VE_COMP_CTRL, comp_ctrl);
> +
> +	/* Don't downscale */
> +	aspeed_video_write(video, VE_SCALING_FACTOR, 0x10001000);
> +	aspeed_video_write(video, VE_SCALING_FILTER0, 0x00200000);
> +	aspeed_video_write(video, VE_SCALING_FILTER1, 0x00200000);
> +	aspeed_video_write(video, VE_SCALING_FILTER2, 0x00200000);
> +	aspeed_video_write(video, VE_SCALING_FILTER3, 0x00200000);
> +
> +	/* Set mode detection defaults */
> +	aspeed_video_write(video, VE_MODE_DETECT, 0x22666500);
> +}
> +
> +static void aspeed_video_start(struct aspeed_video *video)
> +{
> +	aspeed_video_on(video);
> +
> +	aspeed_video_init_regs(video);
> +
> +	aspeed_video_get_resolution(video);
> +
> +	/* Set timings since the device is being opened for the first time */
> +	video->active_timings = video->detected_timings;

OK, so as far as I can tell the get_resolution() function sets detected_timings
to a default value (VGA) if it can't find a valid signal.

Correct?

> +	aspeed_video_set_resolution(video);
> +
> +	video->pix_fmt.width = video->active_timings.width;
> +	video->pix_fmt.height = video->active_timings.height;
> +	video->pix_fmt.sizeimage = video->max_compressed_size;
> +}
> +
> +static void aspeed_video_stop(struct aspeed_video *video)
> +{
> +	set_bit(VIDEO_STOPPED, &video->flags);
> +	cancel_delayed_work_sync(&video->res_work);
> +
> +	aspeed_video_off(video);
> +
> +	if (video->srcs[0].size)
> +		aspeed_video_free_buf(video, &video->srcs[0]);
> +
> +	if (video->srcs[1].size)
> +		aspeed_video_free_buf(video, &video->srcs[1]);
> +
> +	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
> +	video->flags = 0;
> +}

<snip>

> +static int aspeed_video_query_dv_timings(struct file *file, void *fh,
> +					 struct v4l2_dv_timings *timings)
> +{
> +	int rc;
> +	struct aspeed_video *video = video_drvdata(file);
> +
> +	/*
> +	 * This blocks only if the driver is currently in the process of
> +	 * detecting a new resolution; in the event of no signal or timeout
> +	 * this function is woken up.
> +	 */
> +	if (file->f_flags & O_NONBLOCK) {
> +		if (test_bit(VIDEO_RES_CHANGE, &video->flags))
> +			return -EAGAIN;
> +	} else {
> +		rc = wait_event_interruptible(video->wait,
> +					      !test_bit(VIDEO_RES_CHANGE,
> +							&video->flags));
> +		if (rc)
> +			return -EINTR;
> +	}
> +
> +	timings->type = V4L2_DV_BT_656_1120;
> +	timings->bt = video->detected_timings;
> +
> +	return 0;


This does not return the right error if no signal was found.

I think this should be:

	return video->v4l2_input_status ? -ENOLINK : 0;

> +}

<snip>

> +static void aspeed_video_resolution_work(struct work_struct *work)
> +{
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
> +						  res_work);
> +
> +	aspeed_video_on(video);
> +
> +	/* Exit early in case no clients remain */
> +	if (test_bit(VIDEO_STOPPED, &video->flags))
> +		goto done;
> +
> +	aspeed_video_init_regs(video);
> +
> +	aspeed_video_get_resolution(video);
> +
> +	if (video->detected_timings.width != video->active_timings.width ||
> +	    video->detected_timings.height != video->active_timings.height) {

I don't think this test is sufficient. Suppose the active timings are VGA,
and now the signal disappears. The detected_timings will be set to VGA as
well in that case, so there is no change. This test should take whether the
'signal present' status changes as well.

> +		static const struct v4l2_event ev = {
> +			.type = V4L2_EVENT_SOURCE_CHANGE,
> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
> +		};
> +
> +		v4l2_event_queue(&video->vdev, &ev);
> +	} else if (test_bit(VIDEO_STREAMING, &video->flags)) {
> +		/* No resolution change so just restart streaming */
> +		aspeed_video_start_frame(video);
> +	}
> +
> +done:
> +	clear_bit(VIDEO_RES_CHANGE, &video->flags);
> +	wake_up_interruptible_all(&video->wait);
> +}
> +
> +static int aspeed_video_open(struct file *file)
> +{
> +	int rc;
> +	struct aspeed_video *video = video_drvdata(file);
> +
> +	mutex_lock(&video->video_lock);
> +
> +	rc = v4l2_fh_open(file);
> +	if (rc) {
> +		mutex_unlock(&video->video_lock);
> +		return rc;
> +	}
> +
> +	if (v4l2_fh_is_singular_file(file))
> +		aspeed_video_start(video);
> +
> +	mutex_unlock(&video->video_lock);
> +
> +	return 0;
> +}
> +
> +static int aspeed_video_release(struct file *file)
> +{
> +	int rc;
> +	struct aspeed_video *video = video_drvdata(file);
> +
> +	mutex_lock(&video->video_lock);
> +
> +	if (v4l2_fh_is_singular_file(file))
> +		aspeed_video_stop(video);
> +
> +	rc = _vb2_fop_release(file, NULL);
> +
> +	mutex_unlock(&video->video_lock);
> +
> +	return rc;
> +}

<snip>

This is now looking very good. Just a few small issues remaining.

Running checkpatch.pl --strict over the patch gives me three 'CHECK' items
they you should also address:

CHECK: struct mutex definition without comment
#312: FILE: drivers/media/platform/aspeed-video.c:222:
+       struct mutex video_lock;

CHECK: spinlock_t definition without comment
#315: FILE: drivers/media/platform/aspeed-video.c:225:
+       spinlock_t lock;

CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
#580: FILE: drivers/media/platform/aspeed-video.c:490:
+       udelay(100);

I think v8 can be the final version. It probably won't make 4.21, though.
If I'll get a v8 today, then there is a small chance it might still make it.
If not, then it'll be merged early in the 4.22 cycle.

Regards,

	Hans
