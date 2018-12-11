Return-Path: <SRS0=Y87V=OU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65D6FC07E85
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17B6D20855
	for <linux-media@archiver.kernel.org>; Tue, 11 Dec 2018 16:41:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17B6D20855
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.vnet.ibm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbeLKQly (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 11 Dec 2018 11:41:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37174 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbeLKQly (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Dec 2018 11:41:54 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id wBBGceY5126660
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 11:41:50 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2pagp7s1eu-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-media@vger.kernel.org>; Tue, 11 Dec 2018 11:41:50 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-media@vger.kernel.org> from <eajames@linux.vnet.ibm.com>;
        Tue, 11 Dec 2018 16:41:48 -0000
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e15.ny.us.ibm.com (146.89.104.202) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Dec 2018 16:41:45 -0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id wBBGfiDT18481288
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Dec 2018 16:41:44 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E9AB2805E;
        Tue, 11 Dec 2018 16:41:44 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98F7D28060;
        Tue, 11 Dec 2018 16:41:43 +0000 (GMT)
Received: from [9.41.179.222] (unknown [9.41.179.222])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Dec 2018 16:41:43 +0000 (GMT)
Subject: Re: [PATCH v7 2/2] media: platform: Add Aspeed Video Engine driver
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Eddie James <eajames@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Cc:     mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-aspeed@lists.ozlabs.org, robh+dt@kernel.org,
        mchehab@kernel.org, linux-media@vger.kernel.org
References: <1544480791-92746-1-git-send-email-eajames@linux.ibm.com>
 <1544480791-92746-3-git-send-email-eajames@linux.ibm.com>
 <6567e0a4-ad58-1340-199e-e5d5b267f3ac@xs4all.nl>
From:   Eddie James <eajames@linux.vnet.ibm.com>
Date:   Tue, 11 Dec 2018 10:41:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6567e0a4-ad58-1340-199e-e5d5b267f3ac@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 18121116-0068-0000-0000-0000036FF6F5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010213; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000270; SDB=6.01130281; UDB=6.00587314; IPR=6.00910414;
 MB=3.00024655; MTD=3.00000008; XFM=3.00000015; UTC=2018-12-11 16:41:48
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 18121116-0069-0000-0000-000046BAD7C6
Message-Id: <08ffe734-7c08-370e-0a10-09f3924f24c0@linux.vnet.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-11_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812110150
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 12/11/2018 04:44 AM, Hans Verkuil wrote:
> On 12/10/18 11:26 PM, Eddie James wrote:
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
> <snip>
>
>> +static void aspeed_video_irq_res_change(struct aspeed_video *video)
>> +{
>> +	dev_dbg(video->dev, "Resolution changed; resetting\n");
>> +
>> +	set_bit(VIDEO_RES_CHANGE, &video->flags);
>> +	clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>> +
>> +	aspeed_video_off(video);
>> +	aspeed_video_bufs_done(video, VB2_BUF_STATE_ERROR);
>> +
>> +	schedule_delayed_work(&video->res_work, RESOLUTION_CHANGE_DELAY);
>> +}
>> +
>> +static irqreturn_t aspeed_video_irq(int irq, void *arg)
>> +{
>> +	struct aspeed_video *video = arg;
>> +	u32 sts = aspeed_video_read(video, VE_INTERRUPT_STATUS);
>> +
>> +	/* Resolution changed; reset entire engine and reinitialize */
>> +	if (sts & VE_INTERRUPT_MODE_DETECT_WD) {
> Does this only trigger when the resolution changed, or also when the signal
> disappears? For the purpose of this review I assume that it is also triggered
> when the signal goes away. The comment should be updated in that case that
> it is not just resolution changes, but also a dropped video signal.

That's correct, signal lost or resolution changed, I'll update the comment.

>
>> +		aspeed_video_irq_res_change(video);
>> +		return IRQ_HANDLED;
>> +	}
>> +
>> +	if (sts & VE_INTERRUPT_MODE_DETECT) {
>> +		if (test_bit(VIDEO_RES_DETECT, &video->flags)) {
>> +			aspeed_video_update(video, VE_INTERRUPT_CTRL,
>> +					    VE_INTERRUPT_MODE_DETECT, 0);
>> +			aspeed_video_write(video, VE_INTERRUPT_STATUS,
>> +					   VE_INTERRUPT_MODE_DETECT);
>> +
>> +			set_bit(VIDEO_MODE_DETECT_DONE, &video->flags);
>> +			wake_up_interruptible_all(&video->wait);
>> +		} else {
>> +			aspeed_video_irq_res_change(video);
>> +			return IRQ_HANDLED;
>> +		}
>> +	}
>> +
>> +	if ((sts & VE_INTERRUPT_COMP_COMPLETE) &&
>> +	    (sts & VE_INTERRUPT_CAPTURE_COMPLETE)) {
>> +		struct aspeed_video_buffer *buf;
>> +		u32 frame_size = aspeed_video_read(video,
>> +						   VE_OFFSET_COMP_STREAM);
>> +
>> +		spin_lock(&video->lock);
>> +		clear_bit(VIDEO_FRAME_INPRG, &video->flags);
>> +		buf = list_first_entry_or_null(&video->buffers,
>> +					       struct aspeed_video_buffer,
>> +					       link);
>> +		if (buf) {
>> +			vb2_set_plane_payload(&buf->vb.vb2_buf, 0, frame_size);
>> +
>> +			if (!list_is_last(&buf->link, &video->buffers)) {
>> +				buf->vb.vb2_buf.timestamp = ktime_get_ns();
>> +				buf->vb.sequence = video->sequence++;
>> +				buf->vb.field = V4L2_FIELD_NONE;
>> +				vb2_buffer_done(&buf->vb.vb2_buf,
>> +						VB2_BUF_STATE_DONE);
>> +				list_del(&buf->link);
>> +			}
>> +		}
>> +		spin_unlock(&video->lock);
>> +
>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>> +				    VE_SEQ_CTRL_TRIG_CAPTURE |
>> +				    VE_SEQ_CTRL_FORCE_IDLE |
>> +				    VE_SEQ_CTRL_TRIG_COMP, 0);
>> +		aspeed_video_update(video, VE_INTERRUPT_CTRL,
>> +				    VE_INTERRUPT_COMP_COMPLETE |
>> +				    VE_INTERRUPT_CAPTURE_COMPLETE, 0);
>> +		aspeed_video_write(video, VE_INTERRUPT_STATUS,
>> +				   VE_INTERRUPT_COMP_COMPLETE |
>> +				   VE_INTERRUPT_CAPTURE_COMPLETE);
>> +
>> +		if (test_bit(VIDEO_STREAMING, &video->flags) && buf)
>> +			aspeed_video_start_frame(video);
>> +	}
>> +
>> +	return IRQ_HANDLED;
>> +}
> <snip>
>
>> +static void aspeed_video_get_resolution(struct aspeed_video *video)
>> +{
>> +	bool invalid_resolution = true;
>> +	int rc;
>> +	int tries = 0;
>> +	u32 mds;
>> +	u32 src_lr_edge;
>> +	u32 src_tb_edge;
>> +	u32 sync;
>> +	struct v4l2_bt_timings *det = &video->detected_timings;
>> +
>> +	det->width = MIN_WIDTH;
>> +	det->height = MIN_HEIGHT;
>> +	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
>> +
>> +	/*
>> +	 * Since we need max buffer size for detection, free the second source
>> +	 * buffer first.
>> +	 */
>> +	if (video->srcs[1].size)
>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>> +
>> +	if (video->srcs[0].size < VE_MAX_SRC_BUFFER_SIZE) {
>> +		if (video->srcs[0].size)
>> +			aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[0],
>> +					    VE_MAX_SRC_BUFFER_SIZE)) {
>> +			dev_err(video->dev,
>> +				"Failed to allocate source buffers\n");
>> +			return;
>> +		}
>> +	}
>> +
>> +	aspeed_video_write(video, VE_SRC0_ADDR, video->srcs[0].dma);
>> +
>> +	do {
>> +		if (tries) {
>> +			set_current_state(TASK_INTERRUPTIBLE);
>> +			if (schedule_timeout(INVALID_RESOLUTION_DELAY))
>> +				return;
>> +		}
>> +
>> +		set_bit(VIDEO_RES_DETECT, &video->flags);
>> +		aspeed_video_enable_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		if (!rc) {
>> +			dev_err(video->dev, "Timed out; first mode detect\n");
>> +			clear_bit(VIDEO_RES_DETECT, &video->flags);
>> +			return;
>> +		}
>> +
>> +		/* Disable mode detect in order to re-trigger */
>> +		aspeed_video_update(video, VE_SEQ_CTRL,
>> +				    VE_SEQ_CTRL_TRIG_MODE_DET, 0);
>> +
>> +		aspeed_video_check_and_set_polarity(video);
>> +
>> +		aspeed_video_enable_mode_detect(video);
>> +
>> +		rc = wait_event_interruptible_timeout(video->wait,
>> +						      res_check(video),
>> +						      MODE_DETECT_TIMEOUT);
>> +		clear_bit(VIDEO_RES_DETECT, &video->flags);
>> +		if (!rc) {
>> +			dev_err(video->dev, "Timed out; second mode detect\n");
>> +			return;
>> +		}
>> +
>> +		src_lr_edge = aspeed_video_read(video, VE_SRC_LR_EDGE_DET);
>> +		src_tb_edge = aspeed_video_read(video, VE_SRC_TB_EDGE_DET);
>> +		mds = aspeed_video_read(video, VE_MODE_DETECT_STATUS);
>> +		sync = aspeed_video_read(video, VE_SYNC_STATUS);
>> +
>> +		video->frame_bottom = (src_tb_edge & VE_SRC_TB_EDGE_DET_BOT) >>
>> +			VE_SRC_TB_EDGE_DET_BOT_SHF;
>> +		video->frame_top = src_tb_edge & VE_SRC_TB_EDGE_DET_TOP;
>> +		det->vfrontporch = video->frame_top;
>> +		det->vbackporch = ((mds & VE_MODE_DETECT_V_LINES) >>
>> +			VE_MODE_DETECT_V_LINES_SHF) - video->frame_bottom;
>> +		det->vsync = (sync & VE_SYNC_STATUS_VSYNC) >>
>> +			VE_SYNC_STATUS_VSYNC_SHF;
>> +		if (video->frame_top > video->frame_bottom)
>> +			continue;
>> +
>> +		video->frame_right = (src_lr_edge & VE_SRC_LR_EDGE_DET_RT) >>
>> +			VE_SRC_LR_EDGE_DET_RT_SHF;
>> +		video->frame_left = src_lr_edge & VE_SRC_LR_EDGE_DET_LEFT;
>> +		det->hfrontporch = video->frame_left;
>> +		det->hbackporch = (mds & VE_MODE_DETECT_H_PIXELS) -
>> +			video->frame_right;
>> +		det->hsync = sync & VE_SYNC_STATUS_HSYNC;
>> +		if (video->frame_left > video->frame_right)
>> +			continue;
>> +
>> +		invalid_resolution = false;
>> +	} while (invalid_resolution && (tries++ < INVALID_RESOLUTION_RETRIES));
>> +
>> +	if (invalid_resolution) {
>> +		dev_err(video->dev, "Invalid resolution detected\n");
>> +		return;
>> +	}
>> +
>> +	det->height = (video->frame_bottom - video->frame_top) + 1;
>> +	det->width = (video->frame_right - video->frame_left) + 1;
>> +	video->v4l2_input_status = 0;
>> +
>> +	/*
>> +	 * Enable mode-detect watchdog, resolution-change watchdog and
>> +	 * automatic compression after frame capture.
>> +	 */
>> +	aspeed_video_update(video, VE_INTERRUPT_CTRL, 0,
>> +			    VE_INTERRUPT_MODE_DETECT_WD);
>> +	aspeed_video_update(video, VE_SEQ_CTRL, 0,
>> +			    VE_SEQ_CTRL_AUTO_COMP | VE_SEQ_CTRL_EN_WATCHDOG);
>> +
>> +	dev_dbg(video->dev, "Got resolution: %dx%d\n", det->width,
>> +		det->height);
>> +}
>> +
>> +static void aspeed_video_set_resolution(struct aspeed_video *video)
>> +{
>> +	struct v4l2_bt_timings *act = &video->active_timings;
>> +	unsigned int size = act->width * act->height;
>> +
>> +	aspeed_video_calc_compressed_size(video, size);
>> +
>> +	/* Don't use direct mode below 1024 x 768 (irqs don't fire) */
>> +	if (size < DIRECT_FETCH_THRESHOLD) {
>> +		aspeed_video_write(video, VE_TGS_0,
>> +				   FIELD_PREP(VE_TGS_FIRST,
>> +					      video->frame_left - 1) |
>> +				   FIELD_PREP(VE_TGS_LAST,
>> +					      video->frame_right));
>> +		aspeed_video_write(video, VE_TGS_1,
>> +				   FIELD_PREP(VE_TGS_FIRST, video->frame_top) |
>> +				   FIELD_PREP(VE_TGS_LAST,
>> +					      video->frame_bottom + 1));
>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_INT_DE);
>> +	} else {
>> +		aspeed_video_update(video, VE_CTRL, 0, VE_CTRL_DIRECT_FETCH);
>> +	}
>> +
>> +	/* Set capture/compression frame sizes */
>> +	aspeed_video_write(video, VE_CAP_WINDOW,
>> +			   act->width << 16 | act->height);
>> +	aspeed_video_write(video, VE_COMP_WINDOW,
>> +			   act->width << 16 | act->height);
>> +	aspeed_video_write(video, VE_SRC_SCANLINE_OFFSET, act->width * 4);
>> +
>> +	size *= 4;
>> +
>> +	if (size == video->srcs[0].size / 2) {
>> +		aspeed_video_write(video, VE_SRC1_ADDR,
>> +				   video->srcs[0].dma + size);
>> +	} else if (size == video->srcs[0].size) {
>> +		if (!aspeed_video_alloc_buf(video, &video->srcs[1], size))
>> +			goto err_mem;
>> +
>> +		aspeed_video_write(video, VE_SRC1_ADDR, video->srcs[1].dma);
>> +	} else {
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
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
>> +	return;
>> +
>> +err_mem:
>> +	dev_err(video->dev, "Failed to allocate source buffers\n");
>> +
>> +	if (video->srcs[0].size)
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>> +}
>> +
>> +static void aspeed_video_init_regs(struct aspeed_video *video)
>> +{
>> +	u32 comp_ctrl = VE_COMP_CTRL_RSVD |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_LUM, video->jpeg_quality) |
>> +		FIELD_PREP(VE_COMP_CTRL_DCT_CHR, video->jpeg_quality | 0x10);
>> +	u32 ctrl = VE_CTRL_AUTO_OR_CURSOR;
>> +	u32 seq_ctrl = VE_SEQ_CTRL_JPEG_MODE;
>> +
>> +	if (video->frame_rate)
>> +		ctrl |= FIELD_PREP(VE_CTRL_FRC, video->frame_rate);
>> +
>> +	if (video->yuv420)
>> +		seq_ctrl |= VE_SEQ_CTRL_YUV420;
>> +
>> +	/* Unlock VE registers */
>> +	aspeed_video_write(video, VE_PROTECTION_KEY, VE_PROTECTION_KEY_UNLOCK);
>> +
>> +	/* Disable interrupts */
>> +	aspeed_video_write(video, VE_INTERRUPT_CTRL, 0);
>> +	aspeed_video_write(video, VE_INTERRUPT_STATUS, 0xffffffff);
>> +
>> +	/* Clear the offset */
>> +	aspeed_video_write(video, VE_COMP_PROC_OFFSET, 0);
>> +	aspeed_video_write(video, VE_COMP_OFFSET, 0);
>> +
>> +	aspeed_video_write(video, VE_JPEG_ADDR, video->jpeg.dma);
>> +
>> +	/* Set control registers */
>> +	aspeed_video_write(video, VE_SEQ_CTRL, seq_ctrl);
>> +	aspeed_video_write(video, VE_CTRL, ctrl);
>> +	aspeed_video_write(video, VE_COMP_CTRL, comp_ctrl);
>> +
>> +	/* Don't downscale */
>> +	aspeed_video_write(video, VE_SCALING_FACTOR, 0x10001000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER0, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER1, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER2, 0x00200000);
>> +	aspeed_video_write(video, VE_SCALING_FILTER3, 0x00200000);
>> +
>> +	/* Set mode detection defaults */
>> +	aspeed_video_write(video, VE_MODE_DETECT, 0x22666500);
>> +}
>> +
>> +static void aspeed_video_start(struct aspeed_video *video)
>> +{
>> +	aspeed_video_on(video);
>> +
>> +	aspeed_video_init_regs(video);
>> +
>> +	aspeed_video_get_resolution(video);
>> +
>> +	/* Set timings since the device is being opened for the first time */
>> +	video->active_timings = video->detected_timings;
> OK, so as far as I can tell the get_resolution() function sets detected_timings
> to a default value (VGA) if it can't find a valid signal.
>
> Correct?

That is correct.

>
>> +	aspeed_video_set_resolution(video);
>> +
>> +	video->pix_fmt.width = video->active_timings.width;
>> +	video->pix_fmt.height = video->active_timings.height;
>> +	video->pix_fmt.sizeimage = video->max_compressed_size;
>> +}
>> +
>> +static void aspeed_video_stop(struct aspeed_video *video)
>> +{
>> +	set_bit(VIDEO_STOPPED, &video->flags);
>> +	cancel_delayed_work_sync(&video->res_work);
>> +
>> +	aspeed_video_off(video);
>> +
>> +	if (video->srcs[0].size)
>> +		aspeed_video_free_buf(video, &video->srcs[0]);
>> +
>> +	if (video->srcs[1].size)
>> +		aspeed_video_free_buf(video, &video->srcs[1]);
>> +
>> +	video->v4l2_input_status = V4L2_IN_ST_NO_SIGNAL;
>> +	video->flags = 0;
>> +}
> <snip>
>
>> +static int aspeed_video_query_dv_timings(struct file *file, void *fh,
>> +					 struct v4l2_dv_timings *timings)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	/*
>> +	 * This blocks only if the driver is currently in the process of
>> +	 * detecting a new resolution; in the event of no signal or timeout
>> +	 * this function is woken up.
>> +	 */
>> +	if (file->f_flags & O_NONBLOCK) {
>> +		if (test_bit(VIDEO_RES_CHANGE, &video->flags))
>> +			return -EAGAIN;
>> +	} else {
>> +		rc = wait_event_interruptible(video->wait,
>> +					      !test_bit(VIDEO_RES_CHANGE,
>> +							&video->flags));
>> +		if (rc)
>> +			return -EINTR;
>> +	}
>> +
>> +	timings->type = V4L2_DV_BT_656_1120;
>> +	timings->bt = video->detected_timings;
>> +
>> +	return 0;
>
> This does not return the right error if no signal was found.
>
> I think this should be:
>
> 	return video->v4l2_input_status ? -ENOLINK : 0;

Ah, right.

>
>> +}
> <snip>
>
>> +static void aspeed_video_resolution_work(struct work_struct *work)
>> +{
>> +	struct delayed_work *dwork = to_delayed_work(work);
>> +	struct aspeed_video *video = container_of(dwork, struct aspeed_video,
>> +						  res_work);
>> +
>> +	aspeed_video_on(video);
>> +
>> +	/* Exit early in case no clients remain */
>> +	if (test_bit(VIDEO_STOPPED, &video->flags))
>> +		goto done;
>> +
>> +	aspeed_video_init_regs(video);
>> +
>> +	aspeed_video_get_resolution(video);
>> +
>> +	if (video->detected_timings.width != video->active_timings.width ||
>> +	    video->detected_timings.height != video->active_timings.height) {
> I don't think this test is sufficient. Suppose the active timings are VGA,
> and now the signal disappears. The detected_timings will be set to VGA as
> well in that case, so there is no change. This test should take whether the
> 'signal present' status changes as well.

OK, good point, thanks.

>
>> +		static const struct v4l2_event ev = {
>> +			.type = V4L2_EVENT_SOURCE_CHANGE,
>> +			.u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION,
>> +		};
>> +
>> +		v4l2_event_queue(&video->vdev, &ev);
>> +	} else if (test_bit(VIDEO_STREAMING, &video->flags)) {
>> +		/* No resolution change so just restart streaming */
>> +		aspeed_video_start_frame(video);
>> +	}
>> +
>> +done:
>> +	clear_bit(VIDEO_RES_CHANGE, &video->flags);
>> +	wake_up_interruptible_all(&video->wait);
>> +}
>> +
>> +static int aspeed_video_open(struct file *file)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	mutex_lock(&video->video_lock);
>> +
>> +	rc = v4l2_fh_open(file);
>> +	if (rc) {
>> +		mutex_unlock(&video->video_lock);
>> +		return rc;
>> +	}
>> +
>> +	if (v4l2_fh_is_singular_file(file))
>> +		aspeed_video_start(video);
>> +
>> +	mutex_unlock(&video->video_lock);
>> +
>> +	return 0;
>> +}
>> +
>> +static int aspeed_video_release(struct file *file)
>> +{
>> +	int rc;
>> +	struct aspeed_video *video = video_drvdata(file);
>> +
>> +	mutex_lock(&video->video_lock);
>> +
>> +	if (v4l2_fh_is_singular_file(file))
>> +		aspeed_video_stop(video);
>> +
>> +	rc = _vb2_fop_release(file, NULL);
>> +
>> +	mutex_unlock(&video->video_lock);
>> +
>> +	return rc;
>> +}
> <snip>
>
> This is now looking very good. Just a few small issues remaining.
>
> Running checkpatch.pl --strict over the patch gives me three 'CHECK' items
> they you should also address:
>
> CHECK: struct mutex definition without comment
> #312: FILE: drivers/media/platform/aspeed-video.c:222:
> +       struct mutex video_lock;
>
> CHECK: spinlock_t definition without comment
> #315: FILE: drivers/media/platform/aspeed-video.c:225:
> +       spinlock_t lock;
>
> CHECK: usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt
> #580: FILE: drivers/media/platform/aspeed-video.c:490:
> +       udelay(100);

This one has to be udelay due to possibly being called in the interrupt 
handler...

>
> I think v8 can be the final version. It probably won't make 4.21, though.
> If I'll get a v8 today, then there is a small chance it might still make it.
> If not, then it'll be merged early in the 4.22 cycle.

OK, no worries either way. Will send v8 in a few.

Thanks for all the review!
Eddie

>
> Regards,
>
> 	Hans
>

