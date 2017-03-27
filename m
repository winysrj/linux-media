Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:56024 "EHLO
        lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751497AbdC0IsC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 04:48:02 -0400
Subject: Re: [PATCH v7 5/9] media: venus: vdec: add video decoder files
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <1489423058-12492-1-git-send-email-stanimir.varbanov@linaro.org>
 <1489423058-12492-6-git-send-email-stanimir.varbanov@linaro.org>
 <52b39f43-6f70-0cf6-abaf-4bb5bd2b3d86@xs4all.nl>
 <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
Cc: Andy Gross <andy.gross@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6ea4524d-9794-a9b5-8327-367152c92493@xs4all.nl>
Date: Mon, 27 Mar 2017 10:45:32 +0200
MIME-Version: 1.0
In-Reply-To: <be41ccbd-3ff1-bcae-c423-1acc68f35694@mm-sol.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/03/17 23:30, Stanimir Varbanov wrote:
> Thanks for the comments!
> 
> On 03/24/2017 04:41 PM, Hans Verkuil wrote:
>> Some comments and questions below:
>>
>> On 03/13/17 17:37, Stanimir Varbanov wrote:
>>> This consists of video decoder implementation plus decoder
>>> controls.
>>>
>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>> ---
>>>  drivers/media/platform/qcom/venus/vdec.c       | 1091 ++++++++++++++++++++++++
>>>  drivers/media/platform/qcom/venus/vdec.h       |   23 +
>>>  drivers/media/platform/qcom/venus/vdec_ctrls.c |  149 ++++
>>>  3 files changed, 1263 insertions(+)
>>>  create mode 100644 drivers/media/platform/qcom/venus/vdec.c
>>>  create mode 100644 drivers/media/platform/qcom/venus/vdec.h
>>>  create mode 100644 drivers/media/platform/qcom/venus/vdec_ctrls.c
>>>
>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>>> new file mode 100644
>>> index 000000000000..ec5203f2ba81
>>> --- /dev/null
>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>> @@ -0,0 +1,1091 @@
>>> +/*
>>> + * Copyright (c) 2012-2016, The Linux Foundation. All rights reserved.
>>> + * Copyright (C) 2017 Linaro Ltd.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License version 2 and
>>> + * only version 2 as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope that it will be useful,
>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> + * GNU General Public License for more details.
>>> + *
>>> + */
>>> +#include <linux/clk.h>
>>> +#include <linux/module.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/pm_runtime.h>
>>> +#include <linux/slab.h>
>>> +#include <media/v4l2-ioctl.h>
>>> +#include <media/v4l2-event.h>
>>> +#include <media/v4l2-ctrls.h>
>>> +#include <media/v4l2-mem2mem.h>
>>> +#include <media/videobuf2-dma-sg.h>
>>> +
>>> +#include "hfi_venus_io.h"
>>> +#include "core.h"
>>> +#include "helpers.h"
>>> +#include "vdec.h"
>>> +
>>> +static u32 get_framesize_uncompressed(unsigned int plane, u32 width, u32 height)
>>> +{
>>> +    u32 y_stride, uv_stride, y_plane;
>>> +    u32 y_sclines, uv_sclines, uv_plane;
>>> +    u32 size;
>>> +
>>> +    y_stride = ALIGN(width, 128);
>>> +    uv_stride = ALIGN(width, 128);
>>> +    y_sclines = ALIGN(height, 32);
>>> +    uv_sclines = ALIGN(((height + 1) >> 1), 16);
>>> +
>>> +    y_plane = y_stride * y_sclines;
>>> +    uv_plane = uv_stride * uv_sclines + SZ_4K;
>>> +    size = y_plane + uv_plane + SZ_8K;
>>> +
>>> +    return ALIGN(size, SZ_4K);
>>> +}
>>> +
>>> +static u32 get_framesize_compressed(unsigned int width, unsigned int height)
>>> +{
>>> +    return ((width * height * 3 / 2) / 2) + 128;
>>> +}
>>> +
>>> +static const struct venus_format vdec_formats[] = {
>>> +    {
>>> +        .pixfmt = V4L2_PIX_FMT_NV12,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE,
>>
>> Just curious: is NV12 the only uncompressed format supported by the hardware?
>> Or just the only one that is implemented here?
>>
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_MPEG4,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_MPEG2,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_H263,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_VC1_ANNEX_G,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_VC1_ANNEX_L,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_H264,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_VP8,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    }, {
>>> +        .pixfmt = V4L2_PIX_FMT_XVID,
>>> +        .num_planes = 1,
>>> +        .type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE,
>>> +    },
>>
>> num_planes is always 1, do you need it at all? And if it is always one,
>> why use _MPLANE at all? Is this for future additions?
>>
>>> +};
>>> +
> 
> <snip> three reasons:
> - _MPLAIN allows one plane only
> - downstream qualcomm driver use _MPLAIN (the second plain is used for extaradata, I ignored the extaradata support for now until v4l2 metadata api is merged)
> - I still believe that qualcomm firmware guys will add support the second or even third plain at some point.
> 
>>> +
>>> +static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>> +              u32 tag, u32 bytesused, u32 data_offset, u32 flags,
>>> +              u64 timestamp_us)
>>> +{
>>> +    struct vb2_v4l2_buffer *vbuf;
>>> +    struct vb2_buffer *vb;
>>> +    unsigned int type;
>>> +
>>> +    if (buf_type == HFI_BUFFER_INPUT)
>>> +        type = V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
>>> +    else
>>> +        type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>> +
>>> +    vbuf = helper_find_buf(inst, type, tag);
>>> +    if (!vbuf)
>>> +        return;
>>> +
>>> +    vbuf->flags = flags;
>>> +
>>> +    if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>>> +        vb = &vbuf->vb2_buf;
>>> +        vb->planes[0].bytesused =
>>> +            max_t(unsigned int, inst->output_buf_size, bytesused);
>>> +        vb->planes[0].data_offset = data_offset;
>>> +        vb->timestamp = timestamp_us * NSEC_PER_USEC;
>>> +        vbuf->sequence = inst->sequence++;
>>
>> timestamp and sequence are only set for CAPTURE, not OUTPUT. Is that correct?
> 
> Correct. I can add sequence for the OUTPUT queue too, but I have no idea how that sequence is used by userspace.

You set V4L2_BUF_FLAG_TIMESTAMP_COPY, so you have to copy the timestamp from the output buffer
to the capture buffer, if that makes sense for this codec. If not, then you shouldn't use that
V4L2_BUF_FLAG and just generate new timestamps whenever a capture buffer is ready.

For sequence numbering just give the output queue its own sequence counter.

Regards,

	Hans

> 
>>
>>> +
>>> +        if (vbuf->flags & V4L2_BUF_FLAG_LAST) {
>>> +            const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
>>> +
>>> +            v4l2_event_queue_fh(&inst->fh, &ev);
>>> +        }
>>> +    }
>>> +
>>> +    v4l2_m2m_buf_done(vbuf, VB2_BUF_STATE_DONE);
>>> +}
> 
> <snip>
> 
