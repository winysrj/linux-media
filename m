Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:46355 "EHLO extserv.mm-sol.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751181AbdCYWrE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 25 Mar 2017 18:47:04 -0400
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Subject: Re: [PATCH v7 4/9] media: venus: adding core part and helper
 functions
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-5-git-send-email-stanimir.varbanov@linaro.org>
 <249f2504-ed86-acc5-2f65-21c2217590ba@xs4all.nl>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <22a4a026-28ff-9bd8-502a-79eedde9b5dd@mm-sol.com>
Date: Sun, 26 Mar 2017 00:36:42 +0200
MIME-Version: 1.0
In-Reply-To: <249f2504-ed86-acc5-2f65-21c2217590ba@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the comments!

On 03/24/2017 04:23 PM, Hans Verkuil wrote:
> Some review comments below:
>
> On 03/13/17 17:37, Stanimir Varbanov wrote:
>>  * core.c has implemented the platform dirver methods, file
>
> dirver -> driver
>
>> operations and v4l2 registration.
>>
>>  * helpers.c has implemented common helper functions for:
>>    - buffer management
>>
>>    - vb2_ops and functions for format propagation,
>>
>>    - functions for allocating and freeing buffers for
>>    internal usage. The buffer parameters describing internal
>>    buffers depends on current format, resolution and codec.
>>
>>    - functions for calculation of current load of the
>>    hardware. Depending on the count of instances and
>>    resolutions it selects the best clock rate for the video
>>    core.
>>
>>  * firmware loader
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.c     | 386 ++++++++++++++++
>>  drivers/media/platform/qcom/venus/core.h     | 306 +++++++++++++
>>  drivers/media/platform/qcom/venus/firmware.c | 107 +++++
>>  drivers/media/platform/qcom/venus/firmware.h |  22 +
>>  drivers/media/platform/qcom/venus/helpers.c  | 632 +++++++++++++++++++++++++++
>>  drivers/media/platform/qcom/venus/helpers.h  |  41 ++
>>  6 files changed, 1494 insertions(+)
>>  create mode 100644 drivers/media/platform/qcom/venus/core.c
>>  create mode 100644 drivers/media/platform/qcom/venus/core.h
>>  create mode 100644 drivers/media/platform/qcom/venus/firmware.c
>>  create mode 100644 drivers/media/platform/qcom/venus/firmware.h
>>  create mode 100644 drivers/media/platform/qcom/venus/helpers.c
>>  create mode 100644 drivers/media/platform/qcom/venus/helpers.h
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
>> new file mode 100644
>> index 000000000000..557b6ec4cc48
>> --- /dev/null
>> +++ b/drivers/media/platform/qcom/venus/core.c
>> @@ -0,0 +1,386 @@
>> +/*
>> + * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
>> + * Copyright (C) 2017 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +#include <linux/clk.h>
>> +#include <linux/init.h>
>> +#include <linux/ioctl.h>
>> +#include <linux/list.h>
>> +#include <linux/module.h>
>> +#include <linux/of_device.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/slab.h>
>> +#include <linux/types.h>
>> +#include <linux/pm_runtime.h>
>> +#include <media/videobuf2-v4l2.h>
>> +#include <media/v4l2-mem2mem.h>
>> +#include <media/v4l2-ioctl.h>
>> +
>> +#include "core.h"
>> +#include "vdec.h"
>> +#include "venc.h"
>> +#include "firmware.h"
>> +
>> +static const struct hfi_core_ops venus_core_ops;
>> +
>> +static void venus_sys_error_handler(struct work_struct *work)
>> +{
>> +	struct venus_core *core =
>> +			container_of(work, struct venus_core, work.work);
>> +	int ret;
>> +
>> +	dev_warn(core->dev, "system error occurred, starting recovery!\n");
>> +
>> +	pm_runtime_get_sync(core->dev);
>> +
>> +	hfi_core_deinit(core, true);
>> +
>> +	hfi_destroy(core);
>> +
>> +	mutex_lock(&core->lock);
>> +
>> +	venus_shutdown(&core->dev_fw);
>> +
>> +	pm_runtime_put_sync(core->dev);
>> +
>> +	ret = hfi_create(core, &venus_core_ops);
>> +
>> +	pm_runtime_get_sync(core->dev);
>> +
>> +	ret = venus_boot(core->dev, &core->dev_fw);
>> +
>> +	ret = hfi_core_resume(core, true);
>
> Why assign to ret if you're going to ignore it anyway? Either drop the assignment
> or do something with it.

Since this is on the recovery path I'm not sure how to proceed on error 
path. Delay the workqueue and try again later? Whatever, I can rework 
this to print the errors instead of ignoring them.

>
>> +
>> +	enable_irq(core->irq);
>> +
>> +	mutex_unlock(&core->lock);
>> +
>> +	ret = hfi_core_init(core);
>> +	if (ret)
>> +		dev_err(core->dev, "hfi_core_init (%d)\n", ret);
>> +
>> +	pm_runtime_put_sync(core->dev);
>> +
>> +	core->sys_error = false;
>> +}
>> +

<snip>

>> +/**
>> + * struct venus_inst - holds per instance paramerters
>> + *
>> + * @list:	used for attach an instance to the core
>> + * @lock:	instance lock
>> + * @core:	a reference to the core struct
>> + * @internalbufs:	a list of internal bufferes
>> + * @registeredbufs:	a list of registered capture bufferes
>> + * @ctrl_handler:	v4l control handler
>> + * @controls:	an union of decoder and encoder control parameters
>> + * @fh:	 a holder of v4l file handle structure
>> + * @width:	current capture width
>> + * @height:	current capture height
>> + * @out_width:	current output width
>> + * @out_height:	current output height
>> + * @colorspace:	current color space
>> + * @quantization:	current quantization
>> + * @xfer_func:	current xfer function
>> + * @fps:		holds current FPS
>> + * @timeperframe:	holds current time per frame structure
>> + * @fmt_out:	a reference to output format structure
>> + * @fmt_cap:	a reference to capture format structure
>> + * @num_input_bufs:	holds number of input buffers
>> + * @num_output_bufs:	holds number of output buffers
>> + * @input_buf_size	holds input buffer size
>> + * @output_buf_size:	holds output buffer size
>> + * @reconfig:	a flag raised by decoder when the stream resolution changed
>> + * @reconfig_width:	holds the new width
>> + * @reconfig_height:	holds the new height
>> + * @sequence:		a sequence counter
>> + * @codec_cfg:	a flag used to annonce a codec configuration
>> + * @m2m_dev:	a reference to m2m device structure
>> + * @m2m_ctx:	a reference to m2m context structure
>> + * @state:	current state of the instance
>> + * @done:	a completion for sync HFI operation
>> + * @error:	an error returned during last HFI sync operation
>> + * @session_error:	a flag rised by HFI interface in case of session error
>> + * @ops:		HFI operations
>> + * @priv:	a private for HFI operations callbacks
>> + * @session_type:	the type of the session (decoder or encoder)
>> + * @hprop:	an union used as a holder by get property
>> + * @cap_width:	width capability
>> + * @cap_height:	height capability
>> + * @cap_mbs_per_frame:	macroblocks per frame capability
>> + * @cap_mbs_per_sec:	macroblocks per second capability
>> + * @cap_framerate:	framerate capability
>> + * @cap_scale_x:		horizontal scaling capability
>> + * @cap_scale_y:		vertical scaling capability
>> + * @cap_bitrate:		bitrate capability
>> + * @cap_hier_p:		hier capability
>> + * @cap_ltr_count:	LTR count capability
>> + * @cap_secure_output2_threshold: secure OUTPUT2 threshold capability
>> + * @cap_bufs_mode_static:	buffers allocation mode capability
>> + * @cap_bufs_mode_dynamic:	buffers allocation mode capability
>> + * @pl_count:	count of supported profiles/levels
>> + * @pl:		supported profiles/levels
>> + * @bufreq:	holds buffer requirements
>> + */
>> +struct venus_inst {
>> +	struct list_head list;
>> +	struct mutex lock;
>> +	struct venus_core *core;
>> +	struct list_head internalbufs;
>> +	struct list_head registeredbufs;
>> +
>> +	struct v4l2_ctrl_handler ctrl_handler;
>> +	union {
>> +		struct vdec_controls dec;
>> +		struct venc_controls enc;
>> +	} controls;
>> +	struct v4l2_fh fh;
>> +	unsigned int streamon_cap, streamon_out;
>> +	u32 width;
>> +	u32 height;
>> +	u32 out_width;
>> +	u32 out_height;
>> +	u32 colorspace;
>> +	u8 ycbcr_enc;
>> +	u8 quantization;
>> +	u8 xfer_func;
>> +	u64 fps;
>> +	struct v4l2_fract timeperframe;
>> +	const struct venus_format *fmt_out;
>> +	const struct venus_format *fmt_cap;
>> +	unsigned int num_input_bufs;
>> +	unsigned int num_output_bufs;
>> +	unsigned int input_buf_size;
>> +	unsigned int output_buf_size;
>> +	bool reconfig;
>> +	u32 reconfig_width;
>> +	u32 reconfig_height;
>> +	u64 sequence;
>> +	bool codec_cfg;
>> +	struct v4l2_m2m_dev *m2m_dev;
>> +	struct v4l2_m2m_ctx *m2m_ctx;
>> +	unsigned int state;
>> +	struct completion done;
>> +	unsigned int error;
>> +	bool session_error;
>> +	const struct hfi_inst_ops *ops;
>> +	u32 session_type;
>> +	union hfi_get_property hprop;
>> +	struct hfi_capability cap_width;
>> +	struct hfi_capability cap_height;
>> +	struct hfi_capability cap_mbs_per_frame;
>> +	struct hfi_capability cap_mbs_per_sec;
>> +	struct hfi_capability cap_framerate;
>> +	struct hfi_capability cap_scale_x;
>> +	struct hfi_capability cap_scale_y;
>> +	struct hfi_capability cap_bitrate;
>> +	struct hfi_capability cap_hier_p;
>> +	struct hfi_capability cap_ltr_count;
>> +	struct hfi_capability cap_secure_output2_threshold;
>> +	bool cap_bufs_mode_static;
>> +	bool cap_bufs_mode_dynamic;
>> +	unsigned int pl_count;
>> +	struct hfi_profile_level pl[HFI_MAX_PROFILE_COUNT];
>> +	struct hfi_buffer_requirements bufreq[HFI_BUFFER_TYPE_MAX];
>
> Just a suggestion: this might work better if you split it in groups of
> related fields with a comment above each group that gives an indication
> of what it is for. It's a solid block of fields right now and I think
> it can be made a bit easier to read that way.
>

I agree, it will look better. Will try to restructure it.

<snip>

>> +
>> +int helper_vb2_buf_prepare(struct vb2_buffer *vb)
>> +{
>> +	struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
>> +
>> +	if (vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
>> +	    vb2_plane_size(vb, 0) < inst->output_buf_size)
>> +		return -EINVAL;
>> +	else if (vb2_plane_size(vb, 0) < inst->input_buf_size)
>
> This logic can't be right: if type == CAPTURE and the plane_size
>> = output_buf_size, then it will fall into the 'else' and check
> the same plane_size against the input_buf_size, which is clearly
> wrong for a CAPTURE buffer.

Obviously this is wrong, will correct.

<snip>

-- 
regards,
Stan
