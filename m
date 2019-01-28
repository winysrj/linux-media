Return-Path: <SRS0=ymVG=QE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5980C282CD
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58D6020879
	for <linux-media@archiver.kernel.org>; Mon, 28 Jan 2019 16:28:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZvC1r4tt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390653AbfA1Q2q (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 28 Jan 2019 11:28:46 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43841 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728613AbfA1Q2p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 28 Jan 2019 11:28:45 -0500
Received: by mail-wr1-f65.google.com with SMTP id r10so18722581wrs.10
        for <linux-media@vger.kernel.org>; Mon, 28 Jan 2019 08:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7TyVTB+N1bFdNS+UUZWz+X5zu3QBWLQHyj1iOfEAMgY=;
        b=ZvC1r4tth0XnXHN1nfoNxfQhF/sNSwJMpBVQmMCQtvOqR38bWCjrGzBsIBrbdjF2Ai
         U18F2F/V6DnVppZW5NLDmeWziCvvyU42VPg/HZ5N9YOLR+g2i4Ca5OQN1rVxlDv5e2Q+
         /xM7Q1GwKOu5yIJrxxaBwCUQpLjbh1w2XQGC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7TyVTB+N1bFdNS+UUZWz+X5zu3QBWLQHyj1iOfEAMgY=;
        b=CaO2P5+IZPOjKCJKIETO5xIm+u39VplI5joQDUuXAZrv9x63Hk0Jx/Bnu00+usoeU4
         UXIWj1sT4SnQiRIToYPiCm3jXq3he2J8CMzzr5ZKbZ+tOsfwwpBNzZY5iOgt8RROcObT
         iycQGXLXm84Ifd1NVNP7XJa2D00+KFtfbFMkU112Oi4kBPizkyV7TT7isebzetlmf/HJ
         UeEIAQ+5gK9eRW9nsGt21WGuB0easQ7oeT0hy8j3D4dfCvWvaWzGlU2agG2DWYz8HHnx
         /HGQhN9kyFxMB64+lcn1yvy16iMuew3mbiAvu8XfoSY/oghuKggUYCXpTaqJTHhmazsC
         5iWw==
X-Gm-Message-State: AJcUukcraH61DHEinRWDsGmbkJv0yPvhRC6qe77IasT0/3/lPbE8eeCq
        adLagRi8MOV6wjMRDfOmLDInFg==
X-Google-Smtp-Source: ALg8bN6VIB1t+XpNtr4UZK7F7euW+WEv3bLKjcmT5PQC8P/zkq1atKt4gGrwoiyqc372WZNZaeC5qw==
X-Received: by 2002:a5d:6187:: with SMTP id j7mr22606828wru.300.1548692921533;
        Mon, 28 Jan 2019 08:28:41 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id y138sm82966740wmc.16.2019.01.28.08.28.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Jan 2019 08:28:40 -0800 (PST)
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org>
 <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org>
 <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <bf5da04f-779f-e0d9-8cee-99e19096c651@linaro.org>
Date:   Mon, 28 Jan 2019 18:28:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Tomasz,

On 1/28/19 9:38 AM, Tomasz Figa wrote:
> On Fri, Jan 25, 2019 at 7:25 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi Tomasz,
>>
>> Thanks for the comments!
>>
>> On 1/25/19 9:59 AM, Tomasz Figa wrote:
>>> .Hi Stan,
>>>
>>> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
>>> <stanimir.varbanov@linaro.org> wrote:
>>>>
>>>> This refactored code for start/stop streaming vb2 operations and
>>>> adds a state machine handling similar to the one in stateful codec
>>>> API documentation. One major change is that now the HFI session is
>>>> started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=0),
>>>> during that time streamoff(cap,out) just flush buffers but doesn't
>>>> stop the session. The other major change is that now the capture
>>>> and output queues are completely separated.
>>>>
>>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>>>> ---
>>>>  drivers/media/platform/qcom/venus/core.h    |  20 +-
>>>>  drivers/media/platform/qcom/venus/helpers.c |  23 +-
>>>>  drivers/media/platform/qcom/venus/helpers.h |   5 +
>>>>  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
>>>>  4 files changed, 389 insertions(+), 108 deletions(-)
>>>>
>>>
>>> Thanks for the patch! Please see some comments inline.
>>>
>>>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>>>> index 79c7e816c706..5a133c203455 100644
>>>> --- a/drivers/media/platform/qcom/venus/core.h
>>>> +++ b/drivers/media/platform/qcom/venus/core.h
>>>> @@ -218,6 +218,15 @@ struct venus_buffer {
>>>>
>>>>  #define to_venus_buffer(ptr)   container_of(ptr, struct venus_buffer, vb)
>>>>
>>>> +#define DEC_STATE_UNINIT               0
>>>> +#define DEC_STATE_INIT                 1
>>>> +#define DEC_STATE_CAPTURE_SETUP                2
>>>> +#define DEC_STATE_STOPPED              3
>>>> +#define DEC_STATE_SEEK                 4
>>>> +#define DEC_STATE_DRAIN                        5
>>>> +#define DEC_STATE_DECODING             6
>>>> +#define DEC_STATE_DRC                  7
>>>> +
>>>>  /**
>>>>   * struct venus_inst - holds per instance paramerters
>>>>   *
>>>> @@ -241,6 +250,10 @@ struct venus_buffer {
>>>>   * @colorspace:        current color space
>>>>   * @quantization:      current quantization
>>>>   * @xfer_func: current xfer function
>>>> + * @codec_state:       current codec API state (see DEC/ENC_STATE_)
>>>> + * @reconf_wait:       wait queue for resolution change event
>>>> + * @ten_bits:          does new stream is 10bits depth
>>>> + * @buf_count:         used to count number number of buffers (reqbuf(0))
>>>>   * @fps:               holds current FPS
>>>>   * @timeperframe:      holds current time per frame structure
>>>>   * @fmt_out:   a reference to output format structure
>>>> @@ -255,8 +268,6 @@ struct venus_buffer {
>>>>   * @opb_buftype:       output picture buffer type
>>>>   * @opb_fmt:           output picture buffer raw format
>>>>   * @reconfig:  a flag raised by decoder when the stream resolution changed
>>>> - * @reconfig_width:    holds the new width
>>>> - * @reconfig_height:   holds the new height
>>>>   * @hfi_codec:         current codec for this instance in HFI space
>>>>   * @sequence_cap:      a sequence counter for capture queue
>>>>   * @sequence_out:      a sequence counter for output queue
>>>> @@ -296,6 +307,9 @@ struct venus_inst {
>>>>         u8 ycbcr_enc;
>>>>         u8 quantization;
>>>>         u8 xfer_func;
>>>> +       unsigned int codec_state;
>>>> +       wait_queue_head_t reconf_wait;
>>>> +       int buf_count;
>>>>         u64 fps;
>>>>         struct v4l2_fract timeperframe;
>>>>         const struct venus_format *fmt_out;
>>>> @@ -310,8 +324,6 @@ struct venus_inst {
>>>>         u32 opb_buftype;
>>>>         u32 opb_fmt;
>>>>         bool reconfig;
>>>> -       u32 reconfig_width;
>>>> -       u32 reconfig_height;
>>>>         u32 hfi_codec;
>>>>         u32 sequence_cap;
>>>>         u32 sequence_out;
>>>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>>>> index 637ce7b82d94..25d8cceccae4 100644
>>>> --- a/drivers/media/platform/qcom/venus/helpers.c
>>>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>>>> @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
>>>>
>>>>         v4l2_m2m_buf_queue(m2m_ctx, vbuf);
>>>>
>>>> -       if (!(inst->streamon_out & inst->streamon_cap))
>>>> -               goto unlock;
>>>> -
>>>> -       ret = is_buf_refed(inst, vbuf);
>>>> -       if (ret)
>>>> -               goto unlock;
>>>> +       if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
>>>
>>> Wouldn't a simple vb2_is_streaming() work here?
>>
>> I'd say no, because the buffer can be queued but the streaming on that
>> queue isn't started yet. The idea is to send buffers to firmware only
>> when the streaming is on on that queue,
> 
> Isn't it exactly what vb2_is_streaming(vb->vb2_queue) would check?

Not exactly, q->streaming is set when user call STREAMON but most of the
logic is in vb2::start_streaming, but start_streaming is called on first
QBUF (see q->start_streaming_called flag).

> 
>> otherwise we only queue the
>> buffer in m2m_buf_queue (and send for processing once the streaming on
>> that particular queue is started).
>>
>>>
>>>> +               ret = is_buf_refed(inst, vbuf);
>>>> +               if (ret)
>>>> +                       goto unlock;
>>>>
>>>> -       ret = session_process_buf(inst, vbuf);
>>>> -       if (ret)
>>>> -               return_buf_error(inst, vbuf);
>>>> +               ret = session_process_buf(inst, vbuf);
>>>> +               if (ret)
>>>> +                       return_buf_error(inst, vbuf);
>>>> +       }
>>>
>>> The driver is handing the buffer to the firmware directly, bypassing
>>> the m2m helpers. What's the purpose for using those helpers then? (Or
>>> the reason not to do this instead in the device_run m2m callback?)
>>
>> I bypass m2m device_run because it checks for streaming on both (capture
>> and output) queues which contradicts with codec spec where the queues
>> are independent to each other.
>>
> 
> Sounds like the m2m helpers are not a good tool for implementing codec
> drivers then.

Something like that, but the helpers (like m2m_src_buf_remove_by_buf and
etc.) and .vidioc are good and saving code duplication especially
v4l2_m2m_fop_poll and v4l2_m2m_fop_mmap.

> 
>>>
>>>>
>>>>  unlock:
>>>>         mutex_unlock(&inst->lock);
>>>> @@ -1155,14 +1154,8 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>>>>         if (ret)
>>>>                 goto err_unload_res;
>>>>
>>>> -       ret = venus_helper_queue_dpb_bufs(inst);
>>>> -       if (ret)
>>>> -               goto err_session_stop;
>>>> -
>>>>         return 0;
>>>>
>>>> -err_session_stop:
>>>> -       hfi_session_stop(inst);
>>>>  err_unload_res:
>>>>         hfi_session_unload_res(inst);
>>>>  err_unreg_bufs:
>>>> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
>>>> index 2ec1c1a8b416..3b46139b5ee1 100644
>>>> --- a/drivers/media/platform/qcom/venus/helpers.h
>>>> +++ b/drivers/media/platform/qcom/venus/helpers.h
>>>> @@ -17,6 +17,11 @@
>>>>
>>>>  #include <media/videobuf2-v4l2.h>
>>>>
>>>> +#define IS_OUT(q, inst) (inst->streamon_out && \
>>>> +               q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>>> +#define IS_CAP(q, inst) (inst->streamon_cap && \
>>>> +               q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>>
>>> The names are really misleading, as they suggest that it's only a test
>>> for OUTPUT or CAPTURE. How about IS_OUT/CAP_AND_STREAMING()?
>>
>> On Alex's comments I proposed VENUS_OUT/CAP_QUEUE_READY. I don't know
>> which is better name.
>>
> 
> Well, for macros, the name must clearly indicate what the macro is
> doing. VENUS_OUT_QUEUE_READY doesn't indicate that the macro actually
> checks if the queue is OUT.

I agree, will change with your.

> 
> Perhaps you could just get rid of these macros and write the checks
> explicitly as below?
> 
> V4L2_TYPE_IS_OUTPUT(q->type) && vb2_is_streaming(q)
> (and similarly for CAPTURE)
> 
>>>
>>>> +
>>>>  struct venus_inst;
>>>>  struct venus_core;
>>>>
>>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>>>> index 7a9370df7515..306e0f7d3337 100644
>>>> --- a/drivers/media/platform/qcom/venus/vdec.c
>>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>>>> @@ -201,28 +201,18 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>>>>         struct venus_inst *inst = to_inst(file);
>>>>         const struct venus_format *fmt = NULL;
>>>>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>>>> +       int ret;
>>>>
>>>>         if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>>>                 fmt = inst->fmt_cap;
>>>>         else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>>>                 fmt = inst->fmt_out;
>>>>
>>>> -       if (inst->reconfig) {
>>>> -               struct v4l2_format format = {};
>>>> -
>>>> -               inst->out_width = inst->reconfig_width;
>>>> -               inst->out_height = inst->reconfig_height;
>>>> -               inst->reconfig = false;
>>>> -
>>>> -               format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>>> -               format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
>>>> -               format.fmt.pix_mp.width = inst->out_width;
>>>> -               format.fmt.pix_mp.height = inst->out_height;
>>>> -
>>>> -               vdec_try_fmt_common(inst, &format);
>>>> -
>>>> -               inst->width = format.fmt.pix_mp.width;
>>>> -               inst->height = format.fmt.pix_mp.height;
>>>> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>>>> +               ret = wait_event_timeout(inst->reconf_wait, inst->reconfig,
>>>> +                                        msecs_to_jiffies(100));
>>>> +               if (!ret)
>>>> +                       return -EINVAL;
>>>
>>> Nope, that's not what is expected to happen here. Especially since
>>> you're potentially in non-blocking IO mode. Regardless of that, the
>>
>> OK, how to handle that when userspace (for example gstreamer) hasn't
>> support for v4l2 events? The s5p-mfc decoder is doing the same sleep in
>> g_fmt.
> 
> I don't think that sleep in s5p-mfc was needed for gstreamer and
> AFAICT other drivers don't have it. Doesn't gstreamer just set the
> coded format on OUTPUT queue on its own? That should propagate the
> format to the CAPTURE queue, without the need to parse the stream.

I'm pretty sure that this is the case in gstreamer, I've CCed Nicolas
for his opinion.

In regard to this, I make it Venus changes to always set to the firmware
the minimum supported resolution so that it always send to v4l2 driver
the actual resolution and propagate that through v4l2 event to the
userspace.

> 
>>
>>> driver should check if the format information is ready and if not,
>>> just fail with -EACCESS here.
>>
>> I already commented that on Alex's reply.
>>
>>>
>>>>         }
>>>>
>>>>         pixmp->pixelformat = fmt->pixfmt;
>>>> @@ -457,6 +447,10 @@ vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>>>>                 if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
>>>>                         return -EINVAL;
>>>>                 break;
>>>> +       case V4L2_DEC_CMD_START:
>>>> +               if (cmd->flags & V4L2_DEC_CMD_START_MUTE_AUDIO)
>>>> +                       return -EINVAL;
>>>
>>> We don't support any flags here. You can just check if flags != 0.
>>> (and similarly for STOP above)
>>
>> OK.
>>
>>>
>>>> +               break;
>>>>         default:
>>>>                 return -EINVAL;
>>>>         }
>>>> @@ -477,18 +471,23 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>>>>
>>>>         mutex_lock(&inst->lock);
>>>>
>>>> -       /*
>>>> -        * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
>>>> -        * input to signal EOS.
>>>> -        */
>>>> -       if (!(inst->streamon_out & inst->streamon_cap))
>>>> -               goto unlock;
>>>> +       if (cmd->cmd == V4L2_DEC_CMD_STOP) {
>>>> +               /*
>>>> +                * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
>>>> +                * decoder input to signal EOS.
>>>> +                */
>>>> +               if (!(inst->streamon_out & inst->streamon_cap))
>>>
>>> Although & should technically work, I think you want && here.
>>
>> Both are fine in this case.
>>
> 
> Sorry for being picky, but they're fine in terms of whether they work
> or not, but not code quality. We're clearly checking for a logical
> conjunction of two boolean conditions and && is the right operator to
> do it. Especially since streamon_out and streamon_cap are plain
> integers, not stdbool (which would guarantee that the true values of
> both are always the same).

OK, will change that to logical AND.

> 
>>>
>>>> +                       goto unlock;
>>>>
>>>> -       fdata.buffer_type = HFI_BUFFER_INPUT;
>>>> -       fdata.flags |= HFI_BUFFERFLAG_EOS;
>>>> -       fdata.device_addr = 0xdeadbeef;
>>>> +               fdata.buffer_type = HFI_BUFFER_INPUT;
>>>> +               fdata.flags |= HFI_BUFFERFLAG_EOS;
>>>> +               fdata.device_addr = 0xdeadb000;
>>>>
>>>> -       ret = hfi_session_process_buf(inst, &fdata);
>>>> +               ret = hfi_session_process_buf(inst, &fdata);
>>>> +
>>>> +               if (!ret && inst->codec_state == DEC_STATE_DECODING)
>>>> +                       inst->codec_state = DEC_STATE_DRAIN;
>>>> +       }
>>>>
>>>>  unlock:
>>>>         mutex_unlock(&inst->lock);
>>>> @@ -649,20 +648,18 @@ static int vdec_output_conf(struct venus_inst *inst)
>>>>         return 0;
>>>>  }
>>>>
>>>> -static int vdec_init_session(struct venus_inst *inst)
>>>> +static int vdec_session_init(struct venus_inst *inst)
>>>>  {
>>>>         int ret;
>>>>
>>>>         ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
>>>> -       if (ret)
>>>> +       if (ret == -EINVAL)
>>>> +               return 0;
>>>> +       else if (ret)
>>>>                 return ret;
>>>>
>>>> -       ret = venus_helper_set_input_resolution(inst, inst->out_width,
>>>> -                                               inst->out_height);
>>>> -       if (ret)
>>>> -               goto deinit;
>>>> -
>>>> -       ret = venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
>>>> +       ret = venus_helper_set_input_resolution(inst, frame_width_min(inst),
>>>> +                                               frame_height_min(inst));
>>>>         if (ret)
>>>>                 goto deinit;
>>>>
>>>> @@ -681,26 +678,19 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
>>>>
>>>>         *in_num = *out_num = 0;
>>>>
>>>> -       ret = vdec_init_session(inst);
>>>> -       if (ret)
>>>> -               return ret;
>>>> -
>>>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
>>>>         if (ret)
>>>> -               goto deinit;
>>>> +               return ret;
>>>>
>>>>         *in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>>>>
>>>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
>>>>         if (ret)
>>>> -               goto deinit;
>>>> +               return ret;
>>>>
>>>>         *out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>>>>
>>>> -deinit:
>>>> -       hfi_session_deinit(inst);
>>>> -
>>>> -       return ret;
>>>> +       return 0;
>>>>  }
>>>>
>>>>  static int vdec_queue_setup(struct vb2_queue *q,
>>>> @@ -733,6 +723,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
>>>>                 return 0;
>>>>         }
>>>>
>>>> +       ret = vdec_session_init(inst);
>>>> +       if (ret)
>>>> +               return ret;
>>>> +
>>>>         ret = vdec_num_buffers(inst, &in_num, &out_num);
>>>>         if (ret)
>>>>                 return ret;
>>>> @@ -758,6 +752,11 @@ static int vdec_queue_setup(struct vb2_queue *q,
>>>>                 inst->output_buf_size = sizes[0];
>>>>                 *num_buffers = max(*num_buffers, out_num);
>>>>                 inst->num_output_bufs = *num_buffers;
>>>> +
>>>> +               mutex_lock(&inst->lock);
>>>> +               if (inst->codec_state == DEC_STATE_CAPTURE_SETUP)
>>>> +                       inst->codec_state = DEC_STATE_STOPPED;
>>>> +               mutex_unlock(&inst->lock);
>>>>                 break;
>>>>         default:
>>>>                 ret = -EINVAL;
>>>> @@ -794,80 +793,298 @@ static int vdec_verify_conf(struct venus_inst *inst)
>>>>         return 0;
>>>>  }
>>>>
>>>> -static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>>>> +static int vdec_start_capture(struct venus_inst *inst)
>>>>  {
>>>> -       struct venus_inst *inst = vb2_get_drv_priv(q);
>>>>         int ret;
>>>>
>>>> -       mutex_lock(&inst->lock);
>>>> +       if (!inst->streamon_out)
>>>> +               return -EINVAL;
>>>>
>>>> -       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>>> -               inst->streamon_out = 1;
>>>> -       else
>>>> -               inst->streamon_cap = 1;
>>>> +       if (inst->codec_state == DEC_STATE_DECODING) {
>>>> +               if (inst->reconfig)
>>>> +                       goto reconfigure;
>>>>
>>>> -       if (!(inst->streamon_out & inst->streamon_cap)) {
>>>> -               mutex_unlock(&inst->lock);
>>>> +               venus_helper_queue_dpb_bufs(inst);
>>>> +               venus_helper_process_initial_cap_bufs(inst);
>>>> +               inst->streamon_cap = 1;
>>>>                 return 0;
>>>>         }
>>>>
>>>> -       venus_helper_init_instance(inst);
>>>> +       if (inst->codec_state != DEC_STATE_STOPPED)
>>>> +               return -EINVAL;
>>>>
>>>> -       inst->reconfig = false;
>>>> -       inst->sequence_cap = 0;
>>>> -       inst->sequence_out = 0;
>>>> +reconfigure:
>>>> +       ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
>>>> +       if (ret)
>>>> +               return ret;
>>>>
>>>> -       ret = vdec_init_session(inst);
>>>> +       ret = vdec_output_conf(inst);
>>>>         if (ret)
>>>> -               goto bufs_done;
>>>> +               return ret;
>>>> +
>>>> +       ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
>>>> +                                       VB2_MAX_FRAME, VB2_MAX_FRAME);
>>>> +       if (ret)
>>>> +               return ret;
>>>> +
>>>> +       ret = venus_helper_intbufs_realloc(inst);
>>>> +       if (ret)
>>>> +               goto err;
>>>> +
>>>> +       ret = venus_helper_alloc_dpb_bufs(inst);
>>>> +       if (ret)
>>>> +               goto err;
>>>> +
>>>> +       ret = venus_helper_queue_dpb_bufs(inst);
>>>> +       if (ret)
>>>> +               goto free_dpb_bufs;
>>>> +
>>>> +       ret = venus_helper_process_initial_cap_bufs(inst);
>>>> +       if (ret)
>>>> +               goto free_dpb_bufs;
>>>> +
>>>> +       venus_helper_load_scale_clocks(inst->core);
>>>> +
>>>> +       ret = hfi_session_continue(inst);
>>>> +       if (ret)
>>>> +               goto free_dpb_bufs;
>>>> +
>>>> +       inst->codec_state = DEC_STATE_DECODING;
>>>> +
>>>> +       inst->streamon_cap = 1;
>>>> +       inst->sequence_cap = 0;
>>>> +       inst->reconfig = false;
>>>> +
>>>> +       return 0;
>>>> +
>>>> +free_dpb_bufs:
>>>> +       venus_helper_free_dpb_bufs(inst);
>>>> +err:
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int vdec_start_output(struct venus_inst *inst)
>>>> +{
>>>> +       int ret;
>>>> +
>>>> +       if (inst->codec_state == DEC_STATE_SEEK) {
>>>> +               ret = venus_helper_process_initial_out_bufs(inst);
>>>> +               inst->codec_state = DEC_STATE_DECODING;
>>>> +               goto done;
>>>> +       }
>>>> +
>>>> +       if (inst->codec_state == DEC_STATE_INIT ||
>>>> +           inst->codec_state == DEC_STATE_CAPTURE_SETUP) {
>>>> +               ret = venus_helper_process_initial_out_bufs(inst);
>>>> +               goto done;
>>>> +       }
>>>> +
>>>> +       if (inst->codec_state != DEC_STATE_UNINIT)
>>>> +               return -EINVAL;
>>>> +
>>>> +       venus_helper_init_instance(inst);
>>>> +       inst->sequence_out = 0;
>>>> +       inst->reconfig = false;
>>>>
>>>>         ret = vdec_set_properties(inst);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>>         ret = vdec_output_conf(inst);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>>         ret = vdec_verify_conf(inst);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>>         ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
>>>>                                         VB2_MAX_FRAME, VB2_MAX_FRAME);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>> -       ret = venus_helper_alloc_dpb_bufs(inst);
>>>> +       ret = venus_helper_vb2_start_streaming(inst);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>> -       ret = venus_helper_vb2_start_streaming(inst);
>>>> +       ret = venus_helper_process_initial_out_bufs(inst);
>>>>         if (ret)
>>>> -               goto deinit_sess;
>>>> +               return ret;
>>>>
>>>> -       mutex_unlock(&inst->lock);
>>>> +       inst->codec_state = DEC_STATE_INIT;
>>>> +
>>>> +done:
>>>> +       inst->streamon_out = 1;
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>>>> +{
>>>> +       struct venus_inst *inst = vb2_get_drv_priv(q);
>>>> +       int ret;
>>>> +
>>>> +       mutex_lock(&inst->lock);
>>>> +
>>>> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>>> +               ret = vdec_start_capture(inst);
>>>> +       else
>>>> +               ret = vdec_start_output(inst);
>>>>
>>>> +       if (ret)
>>>> +               goto error;
>>>> +
>>>> +       mutex_unlock(&inst->lock);
>>>>         return 0;
>>>>
>>>> -deinit_sess:
>>>> -       hfi_session_deinit(inst);
>>>> -bufs_done:
>>>> +error:
>>>>         venus_helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
>>>> +       mutex_unlock(&inst->lock);
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static void vdec_dst_buffers_done(struct venus_inst *inst,
>>>> +                                 enum vb2_buffer_state state)
>>>> +{
>>>> +       struct vb2_v4l2_buffer *buf;
>>>> +
>>>> +       while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
>>>> +               v4l2_m2m_buf_done(buf, state);
>>>> +}
>>>> +
>>>> +static int vdec_stop_capture(struct venus_inst *inst)
>>>> +{
>>>> +       int ret = 0;
>>>> +
>>>> +       switch (inst->codec_state) {
>>>> +       case DEC_STATE_DECODING:
>>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
>>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>>>> +               inst->codec_state = DEC_STATE_STOPPED;
>>>> +               break;
>>>> +       case DEC_STATE_DRAIN:
>>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>>>
>>> Does this also take care of buffers that were already given to the hardware?
>>
>> Hmm, looks like not handling them. Looking in state machine diagram it
>> is not clear to me what to do with those buffers. Can you clarify what
>> are your expectations here.
>>
> 
> Stopping a queue must reclaim the ownership of any buffers from that
> queue back to the kernel (and then userspace). That means that after
> the queue is stopped, all the buffers may be actually physically
> unmapped from the device and freed. It's not a codec interface
> requirement, but a general vb2 principle.

OK got it. When the driver is in DRAIN and STREAMOFF(CAPTURE) is called
we have to forcibly go to STOPPED without waiting for all capture
buffers to be decoded?

> 
>>>
>>>> +               inst->codec_state = DEC_STATE_STOPPED;
>>>> +               break;
>>>> +       case DEC_STATE_DRC:
>>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
>>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>>>> +               inst->codec_state = DEC_STATE_CAPTURE_SETUP;
>>>> +               INIT_LIST_HEAD(&inst->registeredbufs);
>>>> +               venus_helper_free_dpb_bufs(inst);
>>>> +               break;
>>>> +       default:
>>>> +               return 0;
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static int vdec_stop_output(struct venus_inst *inst)
>>>> +{
>>>> +       int ret = 0;
>>>> +
>>>> +       switch (inst->codec_state) {
>>>> +       case DEC_STATE_DECODING:
>>>> +       case DEC_STATE_DRAIN:
>>>> +       case DEC_STATE_STOPPED:
>>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
>>>
>>> What's exactly the behavior of this hfi_session_flush() for all the
>>> various flush types?
>>
>> hfi flush function is saying to the firmware to return the buffers of
>> particular type (ALL=input+output+output2) to the v4l2 layer via
>> buf_done hfi operation. The buffers must be returned before we exit from
>> hfi_session_flush.
>>
> 
> Okay, so then stopping the OUTPUT queue must not flush the CAPTURE
> buffers, which I believe is what the code above is doing.

Yes, that would be the ideal case but in Venus case flushing INPUT
buffers during DECODING produces an error from firmware, so I've
workaraounded that by flushing INPUT+OUTPUT. I don't know how to deal
with such behaivour.

> 
>>>
>>>> +               inst->codec_state = DEC_STATE_SEEK;
>>>> +               break;
>>>> +       case DEC_STATE_INIT:
>>>> +       case DEC_STATE_CAPTURE_SETUP:
>>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_INPUT);
>>>> +               break;
>>>> +       default:
>>>> +               break;
>>>> +       }
>>>> +
>>>> +       return ret;
>>>> +}
>>>> +
>>>> +static void vdec_stop_streaming(struct vb2_queue *q)
>>>> +{
>>>> +       struct venus_inst *inst = vb2_get_drv_priv(q);
>>>> +       int ret = -EINVAL;
>>>> +
>>>> +       mutex_lock(&inst->lock);
>>>> +
>>>> +       if (IS_CAP(q, inst))
>>>> +               ret = vdec_stop_capture(inst);
>>>> +       else if (IS_OUT(q, inst))
>>>> +               ret = vdec_stop_output(inst);
>>>> +
>>>> +       venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
>>>> +
>>>> +       if (ret)
>>>> +               goto unlock;
>>>> +
>>>>         if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>>>                 inst->streamon_out = 0;
>>>>         else
>>>>                 inst->streamon_cap = 0;
>>>> +
>>>> +unlock:
>>>>         mutex_unlock(&inst->lock);
>>>> -       return ret;
>>>> +}
>>>> +
>>>> +static void vdec_session_release(struct venus_inst *inst)
>>>> +{
>>>> +       struct venus_core *core = inst->core;
>>>> +       int ret, abort = 0;
>>>> +
>>>> +       mutex_lock(&inst->lock);
>>>> +
>>>> +       inst->codec_state = DEC_STATE_UNINIT;
>>>> +
>>>> +       ret = hfi_session_stop(inst);
>>>> +       abort = (ret && ret != -EINVAL) ? 1 : 0;
>>>> +       ret = hfi_session_unload_res(inst);
>>>> +       abort = (ret && ret != -EINVAL) ? 1 : 0;
>>>> +       ret = venus_helper_unregister_bufs(inst);
>>>> +       abort = (ret && ret != -EINVAL) ? 1 : 0;
>>>> +       ret = venus_helper_intbufs_free(inst);
>>>> +       abort = (ret && ret != -EINVAL) ? 1 : 0;
>>>> +       ret = hfi_session_deinit(inst);
>>>> +       abort = (ret && ret != -EINVAL) ? 1 : 0;
>>>> +
>>>> +       if (inst->session_error || core->sys_error)
>>>> +               abort = 1;
>>>> +
>>>> +       if (abort)
>>>> +               hfi_session_abort(inst);
>>>> +
>>>> +       venus_helper_free_dpb_bufs(inst);
>>>> +       venus_helper_load_scale_clocks(core);
>>>> +       INIT_LIST_HEAD(&inst->registeredbufs);
>>>> +
>>>> +       mutex_unlock(&inst->lock);
>>>> +}
>>>> +
>>>> +static int vdec_buf_init(struct vb2_buffer *vb)
>>>> +{
>>>> +       struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
>>>> +
>>>> +       inst->buf_count++;
>>>> +
>>>> +       return venus_helper_vb2_buf_init(vb);
>>>> +}
>>>> +
>>>> +static void vdec_buf_cleanup(struct vb2_buffer *vb)
>>>> +{
>>>> +       struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
>>>> +
>>>> +       inst->buf_count--;
>>>> +       if (!inst->buf_count)
>>>> +               vdec_session_release(inst);
>>>>  }
>>>>
>>>>  static const struct vb2_ops vdec_vb2_ops = {
>>>>         .queue_setup = vdec_queue_setup,
>>>> -       .buf_init = venus_helper_vb2_buf_init,
>>>> +       .buf_init = vdec_buf_init,
>>>> +       .buf_cleanup = vdec_buf_cleanup,
>>>>         .buf_prepare = venus_helper_vb2_buf_prepare,
>>>>         .start_streaming = vdec_start_streaming,
>>>> -       .stop_streaming = venus_helper_vb2_stop_streaming,
>>>> +       .stop_streaming = vdec_stop_streaming,
>>>>         .buf_queue = venus_helper_vb2_buf_queue,
>>>>  };
>>>>
>>>> @@ -891,6 +1108,7 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>>>
>>>>         vbuf->flags = flags;
>>>>         vbuf->field = V4L2_FIELD_NONE;
>>>> +       vb = &vbuf->vb2_buf;
>>>>
>>>>         if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>>>>                 vb = &vbuf->vb2_buf;
>>>> @@ -903,6 +1121,9 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>>>                         const struct v4l2_event ev = { .type = V4L2_EVENT_EOS };
>>>>
>>>>                         v4l2_event_queue_fh(&inst->fh, &ev);
>>>> +
>>>> +                       if (inst->codec_state == DEC_STATE_DRAIN)
>>>> +                               inst->codec_state = DEC_STATE_STOPPED;
>>>>                 }
>>>>         } else {
>>>>                 vbuf->sequence = inst->sequence_out++;
>>>> @@ -914,17 +1135,69 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>>>>         if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
>>>>                 state = VB2_BUF_STATE_ERROR;
>>>>
>>>> +       if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME) {
>>>> +               state = VB2_BUF_STATE_ERROR;
>>>> +               vb2_set_plane_payload(vb, 0, 0);
>>>> +               vb->timestamp = 0;
>>>> +       }
>>>> +
>>>>         v4l2_m2m_buf_done(vbuf, state);
>>>>  }
>>>>
>>>> +static void vdec_event_change(struct venus_inst *inst,
>>>> +                             struct hfi_event_data *ev_data, bool sufficient)
>>>> +{
>>>> +       static const struct v4l2_event ev = {
>>>> +               .type = V4L2_EVENT_SOURCE_CHANGE,
>>>> +               .u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION };
>>>> +       struct device *dev = inst->core->dev_dec;
>>>> +       struct v4l2_format format = {};
>>>> +
>>>> +       mutex_lock(&inst->lock);
>>>> +
>>>> +       format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>>>> +       format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
>>>> +       format.fmt.pix_mp.width = ev_data->width;
>>>> +       format.fmt.pix_mp.height = ev_data->height;
>>>> +
>>>> +       vdec_try_fmt_common(inst, &format);
>>>> +
>>>> +       inst->width = format.fmt.pix_mp.width;
>>>> +       inst->height = format.fmt.pix_mp.height;
>>>> +
>>>> +       inst->out_width = ev_data->width;
>>>> +       inst->out_height = ev_data->height;
>>>> +
>>>> +       dev_dbg(dev, "event %s sufficient resources (%ux%u)\n",
>>>> +               sufficient ? "" : "not", ev_data->width, ev_data->height);
>>>> +
>>>> +       if (sufficient) {
>>>> +               hfi_session_continue(inst);
>>>> +       } else {
>>>> +               switch (inst->codec_state) {
>>>> +               case DEC_STATE_INIT:
>>>> +                       inst->codec_state = DEC_STATE_CAPTURE_SETUP;
>>>> +                       break;
>>>> +               case DEC_STATE_DECODING:
>>>> +                       inst->codec_state = DEC_STATE_DRC;
>>>> +                       break;
>>>> +               default:
>>>> +                       break;
>>>> +               }
>>>> +       }
>>>> +
>>>> +       inst->reconfig = true;
>>>> +       v4l2_event_queue_fh(&inst->fh, &ev);
>>>> +       wake_up(&inst->reconf_wait);
>>>> +
>>>> +       mutex_unlock(&inst->lock);
>>>> +}
>>>> +
>>>>  static void vdec_event_notify(struct venus_inst *inst, u32 event,
>>>>                               struct hfi_event_data *data)
>>>>  {
>>>>         struct venus_core *core = inst->core;
>>>>         struct device *dev = core->dev_dec;
>>>> -       static const struct v4l2_event ev = {
>>>> -               .type = V4L2_EVENT_SOURCE_CHANGE,
>>>> -               .u.src_change.changes = V4L2_EVENT_SRC_CH_RESOLUTION };
>>>>
>>>>         switch (event) {
>>>>         case EVT_SESSION_ERROR:
>>>> @@ -934,18 +1207,10 @@ static void vdec_event_notify(struct venus_inst *inst, u32 event,
>>>>         case EVT_SYS_EVENT_CHANGE:
>>>>                 switch (data->event_type) {
>>>>                 case HFI_EVENT_DATA_SEQUENCE_CHANGED_SUFFICIENT_BUF_RESOURCES:
>>>> -                       hfi_session_continue(inst);
>>>> -                       dev_dbg(dev, "event sufficient resources\n");
>>>> +                       vdec_event_change(inst, data, true);
>>>>                         break;
>>>>                 case HFI_EVENT_DATA_SEQUENCE_CHANGED_INSUFFICIENT_BUF_RESOURCES:
>>>> -                       inst->reconfig_height = data->height;
>>>> -                       inst->reconfig_width = data->width;
>>>> -                       inst->reconfig = true;
>>>> -
>>>> -                       v4l2_event_queue_fh(&inst->fh, &ev);
>>>> -
>>>> -                       dev_dbg(dev, "event not sufficient resources (%ux%u)\n",
>>>> -                               data->width, data->height);
>>>> +                       vdec_event_change(inst, data, false);
>>>>                         break;
>>>>                 case HFI_EVENT_RELEASE_BUFFER_REFERENCE:
>>>>                         venus_helper_release_buf_ref(inst, data->tag);
>>>> @@ -978,8 +1243,12 @@ static void vdec_inst_init(struct venus_inst *inst)
>>>>         inst->hfi_codec = HFI_VIDEO_CODEC_H264;
>>>>  }
>>>>
>>>> +static void vdec_m2m_device_run(void *priv)
>>>> +{
>>>> +}
>>>> +
>>>
>>> Aha, I guess this partially answers my earlier question about the
>>> usage of m2m helpers in this driver. Is there really any reason to use
>>> them then?
>>
>> Exactly. We discussed that a year ago and decided to keep m2m for now,
>> because there are few m2m helpers which are used. But strongly speaking
>> the m2m depency is not needed.
> 
> Hopefully we can come up with a codec framework relatively soon now,
> once we finally establish the official codec interface.

I hope so :)

> 
> Best regards,
> Tomasz
> 

-- 
regards,
Stan
