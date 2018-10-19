Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727482AbeJTAiy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Oct 2018 20:38:54 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w9JGTUhj003856
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 12:32:02 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2n7fgxt7kc-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Fri, 19 Oct 2018 12:32:01 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Fri, 19 Oct 2018 10:32:01 -0600
Subject: Re: [PATCH v4 2/2] media: platform: Add Aspeed Video Engine driver
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, andrew@aj.id.au,
        openbmc@lists.ozlabs.org, robh+dt@kernel.org, mchehab@kernel.org,
        linux-media@vger.kernel.org
References: <1538769466-14860-1-git-send-email-eajames@linux.ibm.com>
 <1538769466-14860-3-git-send-email-eajames@linux.ibm.com>
 <4a02833e-67a6-ec4f-d2f6-e0368412eca8@xs4all.nl>
From: Eddie James <eajames@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2018 11:31:53 -0500
MIME-Version: 1.0
In-Reply-To: <4a02833e-67a6-ec4f-d2f6-e0368412eca8@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Message-Id: <8f204b56-71a9-7df8-ffb2-46b8a2935065@linux.vnet.ibm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/17/2018 05:41 AM, Hans Verkuil wrote:
> On 10/05/2018 09:57 PM, Eddie James wrote:
>> The Video Engine (VE) embedded in the Aspeed AST2400 and AST2500 SOCs
>> can capture and compress video data from digital or analog sources. With
>> the Aspeed chip acting a service processor, the Video Engine can capture
>> the host processor graphics output.
>>
>> Add a V4L2 driver to capture video data and compress it to JPEG images.
>> Make the video frames available through the V4L2 streaming interface.
>>
>> Signed-off-by: Eddie James <eajames@linux.ibm.com>
>> ---
>>   MAINTAINERS                           |    8 +
>>   drivers/media/platform/Kconfig        |    8 +
>>   drivers/media/platform/Makefile       |    1 +
>>   drivers/media/platform/aspeed-video.c | 1674 +++++++++++++++++++++++++++++++++
>>   4 files changed, 1691 insertions(+)
>>   create mode 100644 drivers/media/platform/aspeed-video.c
>>
> <snip>
>
>> +static void aspeed_video_check_polarity(struct aspeed_video *video)
>> +{
>> +	int i;
>> +	int hsync_counter = 0;
>> +	int vsync_counter = 0;
>> +	u32 sts;
>> +
>> +	for (i = 0; i < NUM_POLARITY_CHECKS; ++i) {
>> +		sts = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>> +		if (sts & VE_MODE_DETECT_STATUS_VSYNC)
>> +			vsync_counter--;
>> +		else
>> +			vsync_counter++;
>> +
>> +		if (sts & VE_MODE_DETECT_STATUS_HSYNC)
>> +			hsync_counter--;
>> +		else
>> +			hsync_counter++;
>> +	}
>> +
>> +	if (hsync_counter < 0 || vsync_counter < 0) {
>> +		u32 ctrl;
>> +
>> +		if (hsync_counter < 0)
>> +			ctrl = VE_CTRL_HSYNC_POL;
>> +		else
>> +			video->timings.polarities |= V4L2_DV_HSYNC_POS_POL;
>> +
>> +		if (vsync_counter < 0)
>> +			ctrl = VE_CTRL_VSYNC_POL;
>> +		else
>> +			video->timings.polarities |= V4L2_DV_VSYNC_POS_POL;
>> +
>> +		aspeed_video_update(video, VE_CTRL, 0, ctrl);
>> +	}
>> +}
>> +
>> +static bool aspeed_video_alloc_buf(struct aspeed_video *video,
>> +				   struct aspeed_video_addr *addr,
>> +				   unsigned int size)
>> +{
>> +	addr->virt = dma_alloc_coherent(video->dev, size, &addr->dma,
>> +					GFP_KERNEL);
>> +	if (!addr->virt)
>> +		return false;
>> +
>> +	addr->size = size;
>> +	return true;
>> +}
>> +
>> +static void aspeed_video_free_buf(struct aspeed_video *video,
>> +				  struct aspeed_video_addr *addr)
>> +{
>> +	dma_free_coherent(video->dev, addr->size, addr->virt, addr->dma);
>> +	addr->size = 0;
>> +	addr->dma = 0ULL;
>> +	addr->virt = NULL;
>> +}
>> +
>> +/*
>> + * Get the minimum HW-supported compression buffer size for the frame size.
>> + * Assume worst-case JPEG compression size is 1/8 raw size. This should be
>> + * plenty even for maximum quality; any worse and the engine will simply return
>> + * incomplete JPEGs.
>> + */
>> +static void aspeed_video_calc_compressed_size(struct aspeed_video *video)
>> +{
>> +	int i, j;
>> +	u32 compression_buffer_size_reg = 0;
>> +	unsigned int size;
>> +	const unsigned int num_compression_packets = 4;
>> +	const unsigned int compression_packet_size = 1024;
>> +	const unsigned int max_compressed_size =
>> +		video->width * video->height / 2;	/* 4 Bpp / 8 */
>> +
>> +	video->max_compressed_size = UINT_MAX;
>> +
>> +	for (i = 0; i < 6; ++i) {
>> +		for (j = 0; j < 8; ++j) {
>> +			size = (num_compression_packets << i) *
>> +				(compression_packet_size << j);
>> +			if (size < max_compressed_size)
>> +				continue;
>> +
>> +			if (size < video->max_compressed_size) {
>> +				compression_buffer_size_reg = (i << 3) | j;
>> +				video->max_compressed_size = size;
>> +			}
>> +		}
>> +	}
>> +
>> +	aspeed_video_write(video, VE_STREAM_BUF_SIZE,
>> +			   compression_buffer_size_reg);
>> +
>> +	dev_dbg(video->dev, "max compressed size: %x\n",
>> +		video->max_compressed_size);
>> +}
>> +
>> +#define res_check(v) test_and_clear_bit(VIDEO_MODE_DETECT_DONE, &(v)->flags)
>> +
>> +static int aspeed_video_get_resolution(struct aspeed_video *video)
>> +{
>> +	bool invalid_resolution = true;
>> +	int rc;
>> +	int tries = 0;
>> +	unsigned int bottom;
>> +	unsigned int left;
>> +	unsigned int right;
>> +	unsigned int size;
>> +	unsigned int top;
>> +	u32 mds;
>> +	u32 src_lr_edge;
>> +	u32 src_tb_edge;
>> +	u32 sync;
>> +	struct aspeed_video_addr src;
>> +
>> +	if (video->srcs[1].size)
>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>> +
>> +	if (video->srcs[0].size >= VE_MAX_SRC_BUFFER_SIZE) {
>> +		src = video->srcs[0];
>> +	} else {
>> +		if (video->srcs[0].size)
>> +			aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +		if (!aspeed_video_alloc_buf(video, &src,
>> +					    VE_MAX_SRC_BUFFER_SIZE))
>> +			goto err_mem;
>> +	}
>> +
>> +	aspeed_video_write(video, VE_SRC0_ADDR, src.dma);
>> +
>> +	video->width = 0;
>> +	video->height = 0;
>> +
>> +	do {
>> +		if (tries) {
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +			if (schedule_timeout(INVALID_RESOLUTION_DELAY))
>> +				return -EINTR;
>> +		}
>> +
>> +		aspeed_video_start_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		if (!rc) {
>> +			dev_err(video->dev, "timed out on 1st mode detect\n");
>> +			aspeed_video_disable_mode_detect(video);
>> +			return -ETIMEDOUT;
>> +		}
>> +
>> +		/* Disable mode detect in order to re-trigger */
>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>> +				    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
>> +
>> +		aspeed_video_check_polarity(video);
>> +
>> +		aspeed_video_start_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		if (!rc) {
>> +			dev_err(video->dev, "timed out on 2nd mode detect\n");
>> +			aspeed_video_disable_mode_detect(video);
>> +			return -ETIMEDOUT;
>> +		}
>> +
>> +		src_lr_edge = aspeed_video_read(video, VE_SRC_LR_EDGE_DET);
>> +		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
>> +		mds = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>> +		sync = aspeed_video_read(video, VE_SYNC_STATUS);
>> +
>> +		bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
>> +			VE_SRC_TB_EDGE_DET_BOT_SHF;
>> +		top = src_tb_edge & VE_SRC_TB_EDGE_DET_TOP;
>> +		video->timings.vfrontporch = top;
>> +		video->timings.vbackporch = ((mds & VE_MODE_DETECT_V_LINES) >>
>> +			VE_MODE_DETECT_V_LINES_SHF) - bottom;
>> +		video->timings.vsync = (sync & VE_SYNC_STATUS_VSYNC) >>
>> +			VE_SYNC_STATUS_VSYNC_SHF;
>> +		if (top > bottom)
>> +			continue;
>> +
>> +		right = (src_lr_edge & VE_SRC_LR_EDGE_DET_RT) >>
>> +			VE_SRC_LR_EDGE_DET_RT_SHF;
>> +		left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
>> +		video->timings.hfrontporch = left;
>> +		video->timings.hbackporch = (mds & VE_MODE_DETECT_H_PIXELS) -
>> +			right;
>> +		video->timings.hsync = sync & VE_SYNC_STATUS_HSYNC;
> It's a bit odd that timings.width/height isn't set here.
>
>> +		if (left > right)
>> +			continue;
>> +
>> +		invalid_resolution = false;
>> +	} while (invalid_resolution && (tries++ < INVALID_RESOLUTION_RETRIES));
>> +
>> +	if (invalid_resolution) {
>> +		dev_err(video->dev, "invalid resolution detected\n");
>> +		return -ERANGE;
>> +	}
> So far, so good. You now have detected the new resolution, but...
>
>> +
>> +	video->height = (bottom - top) + 1;
>> +	video->width = (right - left) + 1;
>> +	size = video->height * video->width;
> here and below you appear to actually switch the capture timings to the new
> resolution as well.

Hmm. I'm not sure I understand, the video->height and width represent 
the actual detected resolution. When a resolution change occurs, the 
entire engine is switched off and all buffers are set to error state 
(see the irq handler). Then (after a delay to wait for VGA stability) 
the engine is switched back on and the new resolution detected.

Regardless of how I keep track of the resolution, the video engine will 
return frames of the new size. The driver cannot control the actual 
resolution.

If userspace is determined to ignore the source change event, probably 
there will be bad memory access regardless of how everything is set up I 
would think.

>
> That should only happen when s_dv_timings is called.
>
> It is always very dangerous to automatically switch resolution since a new
> resolution might mean larger buffers, and userspace has to prepare for that.
>
> The normal sequence is:
>
> 1) the driver detects a change in resolution (or the video signal disappears
> completely). It will send V4L2_EVENT_SOURCE_CHANGE to let userspace know.
>
> 2) Userspace stops streaming, frees all buffers, calls QUERY_DV_TIMINGS and,
>     if valid, follows with S_DV_TIMINGS.
>
> 3) Userspace calls REQBUFS to allocate the new buffers sized for the new timings
>     and starts streaming again.
>
> That way everything remains under control of the application.

Yep, that's exactly how it works now, its just that the driver stops 
streaming internally before detecting new resolution.

Thanks,
Eddie

>
>> +
>> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
>> +	if (size < DIRECT_FETCH_THRESHOLD) {
>> +		aspeed_video_write(video, VE_TGS_0,
>> +				   FIELD_PREP(VE_TGS_FIRST, left - 1) |
>> +				   FIELD_PREP(VE_TGS_LAST, right));
>> +		aspeed_video_write(video, VE_TGS_1,
>> +				   FIELD_PREP(VE_TGS_FIRST, top) |
>> +				   FIELD_PREP(VE_TGS_LAST, bottom + 1));
>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_INT_DE);
>> +	} else {
>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_DIRECT_FETCH);
>> +	}
>> +
>> +	aspeed_video_write(video, VE_CAP_WINDOW,
>> +			   video->width << 16 | video->height);
>> +	aspeed_video_write(video, VE_COMP_WINDOW,
>> +			   video->width << 16 | video->height);
>> +	aspeed_video_write(video, VE_SRC_SCANLINE_OFFSET, video->width * 4);
>> +
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0,
>> +			    VE_INTERRUPT_MODE_DETECT_WD);
>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0,
>> +			    VE_SEQ_CTRL_AUTO_COMP | VE_SEQ_CTRL_EN_WATCHDOG);
>> +
>> +	dev_dbg(video->dev, "got resolution[%dx%d]\n", video->width,
>> +		video->height);
>> +
>> +	size *= 4;
>> +	if (size == src.size / 2) {
>> +		aspeed_video_write(video, VE_SRC1_ADDR, src.dma + size);
>> +		video->srcs[0] = src;
>> +	} else if (size == src.size) {
>> +		video->srcs[0] = src;
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>> +			goto err_mem;
>> +
>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>> +	} else {
>> +		aspeed_video_free_buf(video, &src);
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0], size))
>> +			goto err_mem;
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>> +			goto err_mem;
>> +
>> +		aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>> +	}
>> +
>> +	aspeed_video_calc_compressed_size(video);
>> +
>> +	return 0;
>> +
>> +err_mem:
>> +	dev_err(video->dev, "failed to allocate source buffers\n");
>> +
>> +	if (video->srcs[0].size)
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +	return -ENOMEM;
>> +}
> Regards,
>
> 	Hans
>
