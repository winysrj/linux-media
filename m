Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEDEC43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75CA22147C
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfBYLKO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:10:14 -0500
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:33389 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726574AbfBYLKO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 06:10:14 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yE9BgKySB4HFnyE9CgK31e; Mon, 25 Feb 2019 12:10:11 +0100
Subject: Re: [PATCH v3 2/3] [media] allegro: add Allegro DVT video IP core
 driver
To:     Michael Tretter <m.tretter@pengutronix.de>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Cc:     kernel@pengutronix.de, robh+dt@kernel.org, mchehab@kernel.org,
        tfiga@chromium.org, dshah@xilinx.com
References: <20190213175124.3695-1-m.tretter@pengutronix.de>
 <20190213175124.3695-3-m.tretter@pengutronix.de>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <73ed0f6b-0c8d-83c3-9f35-037c7f930cfb@xs4all.nl>
Date:   Mon, 25 Feb 2019 12:10:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190213175124.3695-3-m.tretter@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfPrDMVu+vvFX7lEIHuRR3yJfei6chdW7UDOKDK4RtQBp5YX8XFpBEuqCoHxjlr9/Fn34q5mNzhcMn7ODwfZR4r1WBsexzI6Jkw2PK4n8baasooHdAlRj
 XpfiydsetLQhi0pDmMqC5SU2sNdhCSTYDbC8aeL6ItwVXlKyIR6cvfU99hyWBG0hfzAVyua/xrZFGPSfwaIlFRuRYimJO+39oUk5FL4EWqJ2jiZWj57QTdXi
 /XQ7HDL/gJyyYIJbzwD3q0r0gdCODy+hqdeDbBYb7xkjG3YC8KtxNgjNtK96fz1JW/YpwuAL02ZszfXuA9k2pK2h5B/zAmgTywVm95DRHu5mitWhR2o/gMMG
 pFAYQHXwwpWTdA9xWh/Z18SU9PbVIe8iYIRIcJcJ0b/WEqor1E3KuwAMGrPwpKCpFt8UhjjBUxxl9Fy3coMtztio3C/zykBp+8/56lYlAjEOOGgKIbtPi/1s
 iSzRwOi8nxk07baPAqkJRlLG2vQhW7eQBF1LkA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/13/19 6:51 PM, Michael Tretter wrote:
> Add a V4L2 mem-to-mem driver for Allegro DVT video IP cores as found in
> the EV family of the Xilinx ZynqMP SoC. The Zynq UltraScale+ Device
> Technical Reference Manual uses the term VCU (Video Codec Unit) for the
> encoder, decoder and system integration block.
> 
> This driver takes care of interacting with the MicroBlaze MCU that
> controls the actual IP cores. The IP cores and MCU are integrated in the
> FPGA. The xlnx_vcu driver is responsible for configuring the clocks and
> providing information about the codec configuration.
> 
> The driver currently only supports the H.264 video encoder.
> 
> Signed-off-by: Michael Tretter <m.tretter@pengutronix.de>
> ---

<snip>

> +static void allegro_finish_frame(struct allegro_channel *channel,
> +				 struct mcu_msg_encode_frame_response *msg)
> +{
> +	struct allegro_dev *dev = channel->dev;
> +	struct vb2_v4l2_buffer *src_buf;
> +	struct vb2_v4l2_buffer *dst_buf;
> +	struct {
> +		u32 offset;
> +		u32 size;
> +	} *partition;
> +	enum vb2_buffer_state state = VB2_BUF_STATE_ERROR;
> +
> +	src_buf = v4l2_m2m_src_buf_remove(channel->fh.m2m_ctx);
> +
> +	dst_buf = v4l2_m2m_dst_buf_remove(channel->fh.m2m_ctx);
> +	dst_buf->sequence = channel->csequence++;
> +
> +	if (msg->error_code) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: error while encoding frame: %x\n",
> +			 channel->mcu_channel_id, msg->error_code);
> +		goto err;
> +	}
> +
> +	if (msg->partition_table_size != 1) {
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "channel %d: only handling first partition table entry (%d entries)\n",
> +			  channel->mcu_channel_id, msg->partition_table_size);
> +	}
> +
> +	if (msg->partition_table_offset +
> +	    msg->partition_table_size * sizeof(*partition) >
> +	    vb2_plane_size(&dst_buf->vb2_buf, 0)) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: partition table outside of dst_buf\n",
> +			 channel->mcu_channel_id);
> +		goto err;
> +	}
> +
> +	partition =
> +	    vb2_plane_vaddr(&dst_buf->vb2_buf, 0) + msg->partition_table_offset;
> +	if (partition->offset + partition->size >
> +	    vb2_plane_size(&dst_buf->vb2_buf, 0)) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: encoded frame is outside of dst_buf (offset 0x%x, size 0x%x)\n",
> +			 channel->mcu_channel_id, partition->offset,
> +			 partition->size);
> +		goto err;
> +	}
> +
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		"channel %d: encoded frame of size %d is at offset 0x%x\n",
> +		channel->mcu_channel_id, partition->size, partition->offset);
> +
> +	/*
> +	 * TODO The partition->offset differs from the ENCODER_STREAM_OFFSET.
> +	 * Does the encoder add any data before its configured offset that we
> +	 * need to handle?
> +	 */
> +
> +	vb2_set_plane_payload(&dst_buf->vb2_buf, 0,
> +			      partition->offset + partition->size);
> +
> +	state = VB2_BUF_STATE_DONE;
> +
> +	dst_buf->vb2_buf.timestamp = src_buf->vb2_buf.timestamp;
> +	dst_buf->field = src_buf->field;
> +
> +	dst_buf->flags &= ~V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	dst_buf->flags |= src_buf->flags & V4L2_BUF_FLAG_TSTAMP_SRC_MASK;
> +	if (src_buf->flags & V4L2_BUF_FLAG_TIMECODE) {
> +		dst_buf->timecode = src_buf->timecode;
> +		dst_buf->flags |= V4L2_BUF_FLAG_TIMECODE;
> +	} else {
> +		dst_buf->flags &= ~V4L2_BUF_FLAG_TIMECODE;
> +	}

Use v4l2_m2m_buf_copy_metadata() instead of copying this manually.

> +	if (msg->is_idr) {
> +		dst_buf->flags |= V4L2_BUF_FLAG_KEYFRAME;
> +		dst_buf->flags &= ~V4L2_BUF_FLAG_PFRAME;
> +	} else {
> +		dst_buf->flags |= V4L2_BUF_FLAG_PFRAME;
> +		dst_buf->flags &= ~V4L2_BUF_FLAG_KEYFRAME;
> +	}
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "channel %d: encoded frame (%s%s, %d bytes)\n",
> +		 channel->mcu_channel_id,
> +		 msg->is_idr ? "IDR, " : "",
> +		 msg->slice_type == AL_ENC_SLICE_TYPE_I ? "I slice" :
> +		 msg->slice_type == AL_ENC_SLICE_TYPE_P ? "P slice" : "unknown",
> +		 partition->size);
> +
> +err:
> +	v4l2_m2m_buf_done(src_buf, VB2_BUF_STATE_DONE);
> +
> +	if (channel->stop) {
> +		const struct v4l2_event eos_event = {
> +			.type = V4L2_EVENT_EOS
> +		};
> +		dst_buf->flags |= V4L2_BUF_FLAG_LAST;
> +		v4l2_event_queue_fh(&channel->fh, &eos_event);
> +	}
> +
> +	v4l2_m2m_buf_done(dst_buf, state);
> +	v4l2_m2m_job_finish(dev->m2m_dev, channel->fh.m2m_ctx);
> +}
> +
> +static int allegro_handle_init(struct allegro_dev *dev,
> +			       struct mcu_msg_init_reply *msg)
> +{
> +	complete(&dev->init_complete);
> +
> +	return 0;
> +}
> +
> +static int
> +allegro_handle_create_channel(struct allegro_dev *dev,
> +			      struct mcu_msg_create_channel_response *msg)
> +{
> +	struct allegro_channel *channel;
> +	int err = 0;
> +
> +	channel = allegro_find_channel_by_user_id(dev, msg->user_id);
> +	if (IS_ERR(channel)) {
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "received %s for unknown user %d\n",
> +			  msg_type_name(msg->header.type),
> +			  msg->user_id);
> +		return -EINVAL;
> +	}
> +
> +	if (msg->error_code) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "user %d: failed to create channel: error %d",
> +			 channel->user_id, msg->error_code);
> +		return -EINVAL;
> +	}
> +
> +	channel->mcu_channel_id = msg->channel_id;
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "user %d: channel has channel id %d\n",
> +		 channel->user_id, channel->mcu_channel_id);
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "channel %d: intermediate buffers: %d x %d bytes\n",
> +		 channel->mcu_channel_id, msg->int_buffers_count,
> +		 msg->int_buffers_size);
> +	err = allocate_intermediate_buffers(channel, msg->int_buffers_count,
> +					    msg->int_buffers_size);
> +	if (err) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: failed to allocate intermediate buffers",
> +			 channel->mcu_channel_id);
> +		goto out;
> +	}
> +	allegro_mcu_push_buffer_intermediate(channel);
> +	if (err) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: failed to push reference buffers",
> +			 channel->mcu_channel_id);
> +		goto out;
> +	}
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "channel %d: reference buffers: %d x %d bytes\n",
> +		 channel->mcu_channel_id, msg->rec_buffers_count,
> +		 msg->rec_buffers_size);
> +	err = allocate_reference_buffers(channel, msg->rec_buffers_count,
> +					 msg->rec_buffers_size);
> +	if (err) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: failed to allocate reference buffers",
> +			 channel->mcu_channel_id);
> +		goto out;
> +	}
> +	err = allegro_mcu_push_buffer_reference(channel);
> +	if (err) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "channel %d: failed to push reference buffers",
> +			 channel->mcu_channel_id);
> +		goto out;
> +	}
> +
> +	channel->created = true;
> +
> +	/*
> +	 * FIXME Need to send CHANNEL_DESTROY if we fail to allocate the
> +	 * intermediate or reference buffers?
> +	 */
> +out:
> +	complete(&channel->completion);
> +	return err;
> +}
> +
> +static int
> +allegro_handle_destroy_channel(struct allegro_dev *dev,
> +		struct mcu_msg_destroy_channel_response *msg)
> +{
> +	struct allegro_channel *channel;
> +
> +	channel = allegro_find_channel_by_channel_id(dev, msg->channel_id);
> +	if (IS_ERR(channel)) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "received %s for unknown channel %d\n",
> +			 msg_type_name(msg->header.type),
> +			 msg->channel_id);
> +		return -EINVAL;
> +	}
> +
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +			"user %d: vcu destroyed channel %d\n",
> +			channel->user_id, channel->mcu_channel_id);
> +	complete(&channel->completion);
> +
> +	return 0;
> +}
> +
> +static int
> +allegro_handle_encode_frame(struct allegro_dev *dev,
> +			    struct mcu_msg_encode_frame_response *msg)
> +{
> +	struct allegro_channel *channel;
> +
> +	channel = allegro_find_channel_by_channel_id(dev, msg->channel_id);
> +	if (IS_ERR(channel)) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "received %s for unknown channel %d\n",
> +			 msg_type_name(msg->header.type),
> +			 msg->channel_id);
> +		return -EINVAL;
> +	}
> +
> +	allegro_finish_frame(channel, msg);
> +
> +	return 0;
> +}
> +
> +static int allegro_receive_message(struct allegro_dev *dev)
> +{
> +	struct mcu_msg_header *header;
> +	ssize_t size;
> +	int err = 0;
> +
> +	/*
> +	 * FIXME header is struct mcu_msg_header, but we are allocating memory
> +	 * for a struct mcu_msg_encode_one_frm_response, because we only need
> +	 * to parse the header before we can determine the type and size of
> +	 * the actual message and struct mcu_msg_encode_one_frm_response is
> +	 * currently the largest message.
> +	 */
> +	header = kmalloc(sizeof(struct mcu_msg_encode_frame_response),
> +			 GFP_KERNEL);
> +	if (!header)
> +		return -ENOMEM;
> +
> +	size = allegro_mbox_read(dev, &dev->mbox_status, header,
> +				 sizeof(struct mcu_msg_encode_frame_response));
> +	if (size < sizeof(*header)) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "invalid mbox message (%ld): must be at least %lu\n",
> +			 size, sizeof(*header));
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	switch(header->type) {
> +	case MCU_MSG_TYPE_INIT:
> +		err = allegro_handle_init(dev,
> +				(struct mcu_msg_init_reply *) header);
> +		break;
> +	case MCU_MSG_TYPE_CREATE_CHANNEL:
> +		err = allegro_handle_create_channel(dev,
> +				(struct mcu_msg_create_channel_response *)header);
> +		break;
> +	case MCU_MSG_TYPE_DESTROY_CHANNEL:
> +		err = allegro_handle_destroy_channel(dev,
> +				(struct mcu_msg_destroy_channel_response *)header);
> +		break;
> +	case MCU_MSG_TYPE_ENCODE_FRAME:
> +		err = allegro_handle_encode_frame(dev,
> +				(struct mcu_msg_encode_frame_response *)header);
> +		break;
> +	default:
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "%s: unknown message %s\n",
> +			  __func__, msg_type_name(header->type));
> +		err = -EINVAL;
> +		break;
> +	}
> +
> +out:
> +	kfree(header);
> +
> +	return err;
> +}
> +
> +irqreturn_t allegro_hardirq(int irq, void *data)
> +{
> +	struct allegro_dev *dev = data;
> +	unsigned int status;
> +
> +	regmap_read(dev->regmap, AL5_ITC_CPU_IRQ_STA, &status);
> +	if (!(status & AL5_ITC_CPU_IRQ_STA_TRIGGERED))
> +		return IRQ_NONE;
> +
> +	regmap_write(dev->regmap, AL5_ITC_CPU_IRQ_CLR, status);
> +
> +	/*
> +	 * The downstream driver suggests to wait until the clear has
> +	 * propagated through the hardware, i.e.,
> +	 *
> +	 * 	!(read(AL5_ITC_CPU_IRQ_STA) & AL5_ITC_CPU_IRQ_STA_TRIGGERED)
> +	 *
> +	 * I assume that waiting for the interrupt to be cleared is not
> +	 * required and just continue execution.
> +	 */
> +
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +irqreturn_t allegro_irq_thread(int irq, void *data)
> +{
> +	struct allegro_dev *dev = data;
> +
> +	allegro_receive_message(dev);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void allegro_copy_firmware(struct allegro_dev *dev,
> +				  const u8 * const buf, size_t size)
> +{
> +	int err = 0;
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		"copy mcu firmware (%lu B) to SRAM\n", size);
> +	err = regmap_bulk_write(dev->sram, 0x0, buf, size / 4);
> +	if (err)
> +		v4l2_err(&dev->v4l2_dev,
> +			 "failed to copy firmware: %d\n", err);
> +}
> +
> +static void allegro_copy_fw_codec(struct allegro_dev *dev,
> +				  const u8 * const buf, size_t size)
> +{
> +	int err;
> +	dma_addr_t icache_offset, dcache_offset;
> +
> +	/*
> +	 * The downstream allocates 600 KB for the codec firmware to have some
> +	 * extra space for "possible extensions." My tests were fine with
> +	 * allocating just enough memory for the actual firmware, but I am not
> +	 * sure that the firmware really does not use the remaining space.
> +	 */
> +	err = allegro_alloc_buffer(dev, &dev->firmware, size);
> +	if (err) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "failed to allocate %lu bytes for firmware\n", size);
> +		return;
> +	}
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		"copy codec firmware (%ld B) to phys 0x%llx",
> +		size, dev->firmware.paddr);
> +	memcpy(dev->firmware.vaddr, buf, size);
> +
> +	regmap_write(dev->regmap, AXI_ADDR_OFFSET_IP,
> +		     upper_32_bits(dev->firmware.paddr));
> +
> +	/*
> +	 * TODO I am not sure what the icache and dcache offsets are doing.
> +	 * Copy behavior from downstream driver for now.
> +	 */
> +	icache_offset = dev->firmware.paddr - MCU_CACHE_OFFSET;
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		"icache_offset: msb = 0x%x, lsb = 0x%x\n",
> +		upper_32_bits(icache_offset), lower_32_bits(icache_offset));
> +	regmap_write(dev->regmap, AL5_ICACHE_ADDR_OFFSET_MSB,
> +		     upper_32_bits(icache_offset));
> +	regmap_write(dev->regmap, AL5_ICACHE_ADDR_OFFSET_LSB,
> +		     lower_32_bits(icache_offset));
> +
> +	dcache_offset =
> +	    (dev->firmware.paddr & 0xffffffff00000000) - MCU_CACHE_OFFSET;
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		 "dcache_offset: msb = 0x%x, lsb = 0x%x\n",
> +		 upper_32_bits(dcache_offset), lower_32_bits(dcache_offset));
> +	regmap_write(dev->regmap, AL5_DCACHE_ADDR_OFFSET_MSB,
> +		     upper_32_bits(dcache_offset));
> +	regmap_write(dev->regmap, AL5_DCACHE_ADDR_OFFSET_LSB,
> +		     lower_32_bits(dcache_offset));
> +}
> +
> +static void allegro_free_fw_codec(struct allegro_dev *dev)
> +{
> +	allegro_free_buffer(dev, &dev->firmware);
> +}
> +
> +/*
> + * Control functions for the MCU
> + */
> +
> +static int allegro_mcu_enable_interrupts(struct allegro_dev *dev)
> +{
> +	return regmap_write(dev->regmap, AL5_ITC_CPU_IRQ_MSK, BIT(0));
> +}
> +
> +static int allegro_mcu_disable_interrupts(struct allegro_dev *dev)
> +{
> +	return regmap_write(dev->regmap, AL5_ITC_CPU_IRQ_MSK, 0);
> +}
> +
> +static int allegro_mcu_wait_for_sleep(struct allegro_dev *dev)
> +{
> +	unsigned long timeout;
> +	unsigned int status;
> +
> +	timeout = jiffies + msecs_to_jiffies(100);
> +	while (regmap_read(dev->regmap, AL5_MCU_STA, &status) == 0 &&
> +	       status != AL5_MCU_STA_SLEEP) {
> +		if (time_after(jiffies, timeout))
> +			return -ETIMEDOUT;
> +		cpu_relax();
> +	}
> +
> +	return 0;
> +}
> +
> +static int allegro_mcu_start(struct allegro_dev *dev)
> +{
> +	unsigned long timeout;
> +	unsigned int status;
> +	int err;
> +
> +	err = regmap_write(dev->regmap, AL5_MCU_WAKEUP, BIT(0));
> +	if (err)
> +		return err;
> +
> +	timeout = jiffies + msecs_to_jiffies(100);
> +	while (regmap_read(dev->regmap, AL5_MCU_STA, &status) == 0 &&
> +	       status == AL5_MCU_STA_SLEEP) {
> +		if (time_after(jiffies, timeout))
> +			return -ETIMEDOUT;
> +		cpu_relax();
> +	}
> +
> +	err = regmap_write(dev->regmap, AL5_MCU_WAKEUP, 0);
> +	if (err)
> +		return err;
> +
> +	return 0;
> +}
> +
> +static int allegro_mcu_reset(struct allegro_dev *dev)
> +{
> +	int err;
> +
> +	err = regmap_write(dev->regmap,
> +			   AL5_MCU_RESET_MODE, AL5_MCU_RESET_MODE_SLEEP);
> +	if (err < 0)
> +		return err;
> +
> +	err = regmap_write(dev->regmap, AL5_MCU_RESET, AL5_MCU_RESET_SOFT);
> +	if (err < 0)
> +		return err;
> +
> +	return allegro_mcu_wait_for_sleep(dev);
> +}
> +
> +/*
> + * Create the MCU channel
> + *
> + * After the channel has been created, the picture size, format, colorspace
> + * and framerate are fixed. Also the codec, profile, bitrate, etc. cannot be
> + * changed anymore.
> + *
> + * The channel can be created only once. The MCU will accept source buffers
> + * and stream buffers only after a channel has been created.
> + */
> +static int allegro_create_channel(struct allegro_channel *channel)
> +{
> +	struct allegro_dev *dev = channel->dev;
> +	unsigned long timeout;
> +	int err;
> +	enum v4l2_mpeg_video_h264_level min_level;
> +
> +	if (channel->created) {
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "channel already has been created\n");
> +		return 0;
> +	}
> +
> +	channel->user_id = allegro_next_user_id(dev);
> +	if (channel->user_id < 0) {
> +		v4l2_err(&dev->v4l2_dev,
> +			 "no free channels available\n");
> +		return -EBUSY;
> +	}
> +	set_bit(channel->user_id, &dev->channel_user_ids);
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "user %d: creating channel (%4.4s, %dx%d@%d) \n",
> +		 channel->user_id,
> +		 (char *)&channel->codec, channel->width, channel->height, 25);
> +
> +	min_level = select_minimum_h264_level(channel->width, channel->height);
> +	if (channel->level < min_level) {
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "user %d: selected Level %s too low: increasing to Level %s\n",
> +			  channel->user_id,
> +			  v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL)[channel->level],
> +			  v4l2_ctrl_get_menu(V4L2_CID_MPEG_VIDEO_H264_LEVEL)[min_level]);
> +		channel->level = min_level;
> +	}
> +
> +	reinit_completion(&channel->completion);
> +	allegro_mcu_send_create_channel(dev, channel);
> +	timeout = wait_for_completion_timeout(&channel->completion,
> +					      msecs_to_jiffies(5000));
> +	if (timeout == 0) {
> +		err = -ETIMEDOUT;
> +		goto err;
> +	}
> +	if (!channel->created) {
> +		/* FIXME Return a proper error code */
> +		err = -1;
> +		goto err;
> +	}
> +
> +	v4l2_dbg(1, debug, &dev->v4l2_dev,
> +		 "channel %d: accepting buffers\n",
> +		 channel->mcu_channel_id);
> +
> +	return 0;
> +
> +err:
> +	clear_bit(channel->user_id, &dev->channel_user_ids);
> +	channel->user_id = -1;
> +	return err;
> +}
> +
> +static void allegro_destroy_channel(struct allegro_channel *channel)
> +{
> +	struct allegro_dev *dev = channel->dev;
> +	unsigned long timeout;
> +
> +	if (!channel->created) {
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "cannot destroy channel: has not been created\n");
> +		return;
> +	}
> +
> +	reinit_completion(&channel->completion);
> +	allegro_mcu_send_destroy_channel(dev, channel);
> +	timeout = wait_for_completion_timeout(&channel->completion,
> +					      msecs_to_jiffies(5000));
> +	if (timeout == 0)
> +		v4l2_warn(&dev->v4l2_dev,
> +			  "timeout while destroying channel %d\n",
> +			  channel->mcu_channel_id);
> +
> +	channel->mcu_channel_id = -1;
> +	channel->created = false;
> +	clear_bit(channel->user_id, &dev->channel_user_ids);
> +	channel->user_id = -1;
> +
> +	destroy_intermediate_buffers(channel);
> +	destroy_reference_buffers(channel);
> +}
> +
> +static void allegro_set_default_params(struct allegro_channel *channel)
> +{
> +	channel->width = ALLEGRO_WIDTH_DEFAULT;
> +	channel->height = ALLEGRO_HEIGHT_DEFAULT;
> +	channel->stride = round_up(channel->width, 32);
> +
> +	channel->colorspace = V4L2_COLORSPACE_REC709;
> +	channel->ycbcr_enc = V4L2_YCBCR_ENC_DEFAULT;
> +	channel->quantization = V4L2_QUANTIZATION_DEFAULT;
> +	channel->xfer_func = V4L2_XFER_FUNC_DEFAULT;
> +
> +	channel->pixelformat = V4L2_PIX_FMT_NV12;
> +	channel->sizeimage_raw = channel->stride * channel->height * 3 / 2;
> +
> +	channel->codec = V4L2_PIX_FMT_H264;
> +	channel->profile = V4L2_MPEG_VIDEO_H264_PROFILE_BASELINE;
> +	channel->level =
> +		select_minimum_h264_level(channel->width, channel->height);
> +	channel->sizeimage_encoded =
> +		estimate_stream_size(channel->width, channel->height);
> +
> +	channel->bitrate_mode = V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
> +	channel->bitrate = maximum_bitrate(channel->level);
> +	channel->bitrate_peak = maximum_bitrate(channel->level);
> +	channel->cpb_size = maximum_cpb_size(channel->level);
> +	channel->gop_size = ALLEGRO_GOP_SIZE_DEFAULT;
> +}
> +
> +static int allegro_queue_setup(struct vb2_queue *vq,
> +			       unsigned int *nbuffers, unsigned int *nplanes,
> +			       unsigned int sizes[],
> +			       struct device *alloc_devs[])
> +{
> +	struct allegro_channel *channel = vb2_get_drv_priv(vq);
> +	struct allegro_dev *dev = channel->dev;
> +
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		 "%s: queue setup[%s]: nplanes = %d\n",
> +		 vq->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture",
> +		 *nplanes == 0 ? "REQBUFS" : "CREATE_BUFS", *nplanes);
> +
> +	if (*nplanes != 0) {
> +		if (*nplanes != 1)
> +			return -EINVAL;
> +		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +			if (sizes[0] < channel->sizeimage_encoded)
> +				return -EINVAL;
> +
> +		} else {
> +			if (sizes[0] < channel->sizeimage_raw)
> +				return -EINVAL;
> +		}
> +	} else {
> +		*nplanes = 1;
> +		if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +			sizes[0] = channel->sizeimage_encoded;
> +		} else {
> +			sizes[0] = channel->sizeimage_raw;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int allegro_buf_prepare(struct vb2_buffer *vb)
> +{
> +	struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
> +	struct allegro_channel *channel = vb2_get_drv_priv(vb->vb2_queue);
> +	struct allegro_dev *dev = channel->dev;
> +
> +	if (V4L2_TYPE_IS_OUTPUT(vb->vb2_queue->type)) {
> +		if (vbuf->field == V4L2_FIELD_ANY)
> +			vbuf->field = V4L2_FIELD_NONE;
> +		if (vbuf->field != V4L2_FIELD_NONE) {
> +			v4l2_err(&dev->v4l2_dev,
> +				 "channel %d: unsupported field\n",
> +				 channel->mcu_channel_id);
> +			return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static void allegro_buf_queue(struct vb2_buffer *vb)
> +{
> +	struct allegro_channel *channel = vb2_get_drv_priv(vb->vb2_queue);
> +	struct allegro_dev *dev = channel->dev;
> +	struct vb2_queue *vq = vb->vb2_queue;
> +	struct allegro_buffer al_buf;
> +
> +	if (vq->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		al_buf.paddr = vb2_dma_contig_plane_dma_addr(vb, 0);
> +		al_buf.size = vb2_plane_size(vb, 0);
> +
> +		v4l2_dbg(1, debug, &dev->v4l2_dev,
> +			 "channel %d: queuing stream buffer: paddr: 0x%08llx, %ld bytes\n",
> +			 channel->mcu_channel_id, al_buf.paddr, al_buf.size);
> +		allegro_mcu_send_put_stream_buffer(dev, channel, al_buf);
> +	}
> +
> +	v4l2_m2m_buf_queue(channel->fh.m2m_ctx, to_vb2_v4l2_buffer(vb));
> +}
> +
> +static int allegro_start_streaming(struct vb2_queue *q, unsigned int count)
> +{
> +	struct allegro_channel *channel = vb2_get_drv_priv(q);
> +	struct allegro_dev *dev = channel->dev;
> +
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		 "%s: start streaming\n",
> +		 q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture");
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		channel->osequence = 0;
> +	} else {
> +		channel->csequence = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +static void allegro_stop_streaming(struct vb2_queue *q)
> +{
> +	struct allegro_channel *channel = vb2_get_drv_priv(q);
> +	struct allegro_dev *dev = channel->dev;
> +	struct vb2_v4l2_buffer *buffer;
> +
> +	v4l2_dbg(2, debug, &dev->v4l2_dev,
> +		 "%s: stop streaming\n",
> +		 q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT ? "output" : "capture");
> +
> +	if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT) {
> +		while ((buffer = v4l2_m2m_src_buf_remove(channel->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buffer, VB2_BUF_STATE_ERROR);
> +	} else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
> +		/*
> +		 * FIXME The channel is created during queue_setup().
> +		 * Therefore, destroying it in stop_streaming might result in
> +		 * a start_streaming() without a channel, which is really bad.
> +		 */

I think this is fixed now, is this an outdated comment?

There are a few FIXMEs and TODOs in this source, it's probably a good idea to
check them and fix them where it makes sense for v4.

> +		allegro_destroy_channel(channel);
> +		while ((buffer = v4l2_m2m_dst_buf_remove(channel->fh.m2m_ctx)))
> +			v4l2_m2m_buf_done(buffer, VB2_BUF_STATE_ERROR);
> +	}
> +}

Regards,

	Hans
