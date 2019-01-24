Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25B6C282C6
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:34:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5001218AE
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 12:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="HdiXAAdy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfAXMeT (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 07:34:19 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37430 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727386AbfAXMeS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 07:34:18 -0500
Received: by mail-wr1-f65.google.com with SMTP id s12so6286172wrt.4
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 04:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Hx7aL0NE1DLYcW+Ju5gFQR46NxgF6vfmkfJD6arPey0=;
        b=HdiXAAdyw3oFmIvbMB4IcSL1gADAIJzjfj0fHKBKCkjENcgjVRWQfbOeuiGd3WkKdL
         nNsxC39YXX94P1NdHj5HQkE9Btw53IU3aYkuk7XFixMvnxWgcLZdY7cSTUaae8SAkA6h
         jOE+9GOKfpAFrtY/iegu1FvHx8RQvXAwtS3L4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hx7aL0NE1DLYcW+Ju5gFQR46NxgF6vfmkfJD6arPey0=;
        b=c+lHnmbFGTK0AyBGNvIBHamsn2a3jKwk4+cIQwVVvTHdv00n0QwNOjRuLaEjWDih/2
         2wgPpdb5Nks0T1mmXHpQEcUWASiDr45srnzjnIz3mmnnQUwHVj5YPPDI4XtQsep4eNbg
         5msv1Hm6ag/FWY9bJvqt2rQd47rpYh4cNUDFwiaWuld/fSqDvP/3sL5uyAvyExOJB3DQ
         iga/4IrAZPQ2WzjUBnbYupw0zrzvVz6V68R+pvEr3NuU2R6/ztbhPu/21oJQT9T/el4b
         dkIAmlEmKfHoiNJBGRgE2WAXBsTRByrb3hOHLwAwTPdPtAdyUrlXIH58yh8Tn+DSF/+1
         f59g==
X-Gm-Message-State: AJcUukdOlSx9PLan7LUAZ6NIwU5QLpoLbe80RaC8X3HUlb5KJeH/Ijcw
        IjaNdG8w6Mxog8Yl9XkPLq4a9w8TUDQ=
X-Google-Smtp-Source: ALg8bN6wTWiHW4HjWiKYZcvHHdWnaw1eGN/eppTUh0piwCXJqGjADrwGglGdnqK74hud8d6qZAhc5A==
X-Received: by 2002:adf:c612:: with SMTP id n18mr6813267wrg.174.1548333254684;
        Thu, 24 Jan 2019 04:34:14 -0800 (PST)
Received: from [192.168.27.209] ([37.157.136.206])
        by smtp.googlemail.com with ESMTPSA id h16sm205943476wrb.62.2019.01.24.04.34.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 04:34:14 -0800 (PST)
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Alexandre Courbot <acourbot@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org>
 <CAPBb6MWMOBRrRYbbVjvm=075o_Sbmh3jVj3PNZ2dmMXu6UOzmw@mail.gmail.com>
From:   Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <24a0dba6-5c18-189f-5f56-72f5cdd1bc90@linaro.org>
Date:   Thu, 24 Jan 2019 14:34:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAPBb6MWMOBRrRYbbVjvm=075o_Sbmh3jVj3PNZ2dmMXu6UOzmw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Alex,

Thanks for the comments!

On 1/24/19 10:44 AM, Alexandre Courbot wrote:
> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> This refactored code for start/stop streaming vb2 operations and
> 
> s/refactored/refactors?

Ack.

> 
>> adds a state machine handling similar to the one in stateful codec
>> API documentation. One major change is that now the HFI session is
>> started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=0),
>> during that time streamoff(cap,out) just flush buffers but doesn't
> 
> streamoff(cap,out) should probably be in capitals for consistency.

OK.

> 
>> stop the session. The other major change is that now the capture
>> and output queues are completely separated.
>>
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>  drivers/media/platform/qcom/venus/core.h    |  20 +-
>>  drivers/media/platform/qcom/venus/helpers.c |  23 +-
>>  drivers/media/platform/qcom/venus/helpers.h |   5 +
>>  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
>>  4 files changed, 389 insertions(+), 108 deletions(-)
>>
>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
>> index 79c7e816c706..5a133c203455 100644
>> --- a/drivers/media/platform/qcom/venus/core.h
>> +++ b/drivers/media/platform/qcom/venus/core.h
>> @@ -218,6 +218,15 @@ struct venus_buffer {
>>
>>  #define to_venus_buffer(ptr)   container_of(ptr, struct venus_buffer, vb)
>>
>> +#define DEC_STATE_UNINIT               0
> 
> Not sure about "uninit", DEC_STATE_DEINIT may be more explicit here?

I don't have strong opinion on that, so I will change it.

> 
>> +#define DEC_STATE_INIT                 1
>> +#define DEC_STATE_CAPTURE_SETUP                2
>> +#define DEC_STATE_STOPPED              3
>> +#define DEC_STATE_SEEK                 4
>> +#define DEC_STATE_DRAIN                        5
>> +#define DEC_STATE_DECODING             6
>> +#define DEC_STATE_DRC                  7
> 
> How about defining these as an enum, for better type safety? I'd also
> prefix with VENUS_ to avoid possible (if unlikely) name collisions.

OK.

> 
>> +
>>  /**
>>   * struct venus_inst - holds per instance paramerters
>>   *
>> @@ -241,6 +250,10 @@ struct venus_buffer {
>>   * @colorspace:        current color space
>>   * @quantization:      current quantization
>>   * @xfer_func: current xfer function
>> + * @codec_state:       current codec API state (see DEC/ENC_STATE_)
>> + * @reconf_wait:       wait queue for resolution change event
>> + * @ten_bits:          does new stream is 10bits depth
> 
> "is new stream 10 bits deep" maybe?

that is better description, but it should be in this patch (I have made
10bits support but didn't included in that initial stateful codec patch).

> 
>> + * @buf_count:         used to count number number of buffers (reqbuf(0))
> 
> "number" written twice here.

OK.

> 
>>   * @fps:               holds current FPS
>>   * @timeperframe:      holds current time per frame structure
>>   * @fmt_out:   a reference to output format structure
>> @@ -255,8 +268,6 @@ struct venus_buffer {
>>   * @opb_buftype:       output picture buffer type
>>   * @opb_fmt:           output picture buffer raw format
>>   * @reconfig:  a flag raised by decoder when the stream resolution changed
>> - * @reconfig_width:    holds the new width
>> - * @reconfig_height:   holds the new height
>>   * @hfi_codec:         current codec for this instance in HFI space
>>   * @sequence_cap:      a sequence counter for capture queue
>>   * @sequence_out:      a sequence counter for output queue
>> @@ -296,6 +307,9 @@ struct venus_inst {
>>         u8 ycbcr_enc;
>>         u8 quantization;
>>         u8 xfer_func;
>> +       unsigned int codec_state;
> 
> As mentioned above, with an enum the type of this member would make it
> obvious which values it can accept.
> 
>> +       wait_queue_head_t reconf_wait;
>> +       int buf_count;
>>         u64 fps;
>>         struct v4l2_fract timeperframe;
>>         const struct venus_format *fmt_out;
>> @@ -310,8 +324,6 @@ struct venus_inst {
>>         u32 opb_buftype;
>>         u32 opb_fmt;
>>         bool reconfig;
>> -       u32 reconfig_width;
>> -       u32 reconfig_height;
>>         u32 hfi_codec;
>>         u32 sequence_cap;
>>         u32 sequence_out;
>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
>> index 637ce7b82d94..25d8cceccae4 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.c
>> +++ b/drivers/media/platform/qcom/venus/helpers.c
>> @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
>>
>>         v4l2_m2m_buf_queue(m2m_ctx, vbuf);
>>
>> -       if (!(inst->streamon_out & inst->streamon_cap))
>> -               goto unlock;
>> -
>> -       ret = is_buf_refed(inst, vbuf);
>> -       if (ret)
>> -               goto unlock;
>> +       if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
>> +               ret = is_buf_refed(inst, vbuf);
>> +               if (ret)
>> +                       goto unlock;
>>
>> -       ret = session_process_buf(inst, vbuf);
>> -       if (ret)
>> -               return_buf_error(inst, vbuf);
>> +               ret = session_process_buf(inst, vbuf);
>> +               if (ret)
>> +                       return_buf_error(inst, vbuf);
>> +       }
>>
>>  unlock:
>>         mutex_unlock(&inst->lock);
>> @@ -1155,14 +1154,8 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>>         if (ret)
>>                 goto err_unload_res;
>>
>> -       ret = venus_helper_queue_dpb_bufs(inst);
>> -       if (ret)
>> -               goto err_session_stop;
>> -
>>         return 0;
>>
>> -err_session_stop:
>> -       hfi_session_stop(inst);
>>  err_unload_res:
>>         hfi_session_unload_res(inst);
>>  err_unreg_bufs:
>> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
>> index 2ec1c1a8b416..3b46139b5ee1 100644
>> --- a/drivers/media/platform/qcom/venus/helpers.h
>> +++ b/drivers/media/platform/qcom/venus/helpers.h
>> @@ -17,6 +17,11 @@
>>
>>  #include <media/videobuf2-v4l2.h>
>>
>> +#define IS_OUT(q, inst) (inst->streamon_out && \
>> +               q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> +#define IS_CAP(q, inst) (inst->streamon_cap && \
>> +               q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> 
> These macro names are pretty generic and we are at risk of a name
> collision in the future. Also the name conveys the idea that the macro
> will check for the buffer type only ; yet IIUC we also check that the
> corresponding queue is streaming? Maybe something like
> VENUS_BUF_OUT_READY() would be more meaningful.

OK, I agree that the name should be changed, but maybe
VENUS_OUT_QUEUE_READY is better?

> 
>> +
>>  struct venus_inst;
>>  struct venus_core;
>>
>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
>> index 7a9370df7515..306e0f7d3337 100644
>> --- a/drivers/media/platform/qcom/venus/vdec.c
>> +++ b/drivers/media/platform/qcom/venus/vdec.c
>> @@ -201,28 +201,18 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>>         struct venus_inst *inst = to_inst(file);
>>         const struct venus_format *fmt = NULL;
>>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
>> +       int ret;
>>
>>         if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>>                 fmt = inst->fmt_cap;
>>         else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>>                 fmt = inst->fmt_out;
>>
>> -       if (inst->reconfig) {
>> -               struct v4l2_format format = {};
>> -
>> -               inst->out_width = inst->reconfig_width;
>> -               inst->out_height = inst->reconfig_height;
>> -               inst->reconfig = false;
>> -
>> -               format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>> -               format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
>> -               format.fmt.pix_mp.width = inst->out_width;
>> -               format.fmt.pix_mp.height = inst->out_height;
>> -
>> -               vdec_try_fmt_common(inst, &format);
>> -
>> -               inst->width = format.fmt.pix_mp.width;
>> -               inst->height = format.fmt.pix_mp.height;
>> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
>> +               ret = wait_event_timeout(inst->reconf_wait, inst->reconfig,
>> +                                        msecs_to_jiffies(100));
>> +               if (!ret)
>> +                       return -EINVAL;

btw, EINVAL should be replaced with EACCES as per stateful codec
documentation. I kept it EINVAL because that is the Chromium unittest
expectation presently (maybe you should change that in the unittest?).

> 
> inst->reconfig is only true during the time between a reconfigure
> event and the start of the CAPTURE queue. This looks like G_FMT on the
> CAPTURE queue will only be successful during this very short amount of
> time. Is my understanding correct? I wonder whether I am missing
> something here because the Chromium tests are all passing. But if this
> is correct, then this looks very restrictive. For instance, one would
> not be able to do VIDIOC_G_FMT twice in a row.

I agree and I think your understanding is correct. This wait_event is
here only to support userspace clients which didn't implement v4l2
events handling (gstreamer).

I will think more about this.

> 
>>         }
>>
>>         pixmp->pixelformat = fmt->pixfmt;
>> @@ -457,6 +447,10 @@ vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>>                 if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
>>                         return -EINVAL;
>>                 break;
>> +       case V4L2_DEC_CMD_START:
>> +               if (cmd->flags & V4L2_DEC_CMD_START_MUTE_AUDIO)
>> +                       return -EINVAL;
>> +               break;
>>         default:
>>                 return -EINVAL;
>>         }
>> @@ -477,18 +471,23 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
>>
>>         mutex_lock(&inst->lock);
>>
>> -       /*
>> -        * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
>> -        * input to signal EOS.
>> -        */
>> -       if (!(inst->streamon_out & inst->streamon_cap))
>> -               goto unlock;
>> +       if (cmd->cmd == V4L2_DEC_CMD_STOP) {
>> +               /*
>> +                * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
>> +                * decoder input to signal EOS.
>> +                */
>> +               if (!(inst->streamon_out & inst->streamon_cap))
>> +                       goto unlock;
>>
>> -       fdata.buffer_type = HFI_BUFFER_INPUT;
>> -       fdata.flags |= HFI_BUFFERFLAG_EOS;
>> -       fdata.device_addr = 0xdeadbeef;
>> +               fdata.buffer_type = HFI_BUFFER_INPUT;
>> +               fdata.flags |= HFI_BUFFERFLAG_EOS;
>> +               fdata.device_addr = 0xdeadb000;
>>
>> -       ret = hfi_session_process_buf(inst, &fdata);
>> +               ret = hfi_session_process_buf(inst, &fdata);
>> +
>> +               if (!ret && inst->codec_state == DEC_STATE_DECODING)
>> +                       inst->codec_state = DEC_STATE_DRAIN;
>> +       }
>>
>>  unlock:
>>         mutex_unlock(&inst->lock);
>> @@ -649,20 +648,18 @@ static int vdec_output_conf(struct venus_inst *inst)
>>         return 0;
>>  }
>>
>> -static int vdec_init_session(struct venus_inst *inst)
>> +static int vdec_session_init(struct venus_inst *inst)
>>  {
>>         int ret;
>>
>>         ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
>> -       if (ret)
>> +       if (ret == -EINVAL)
>> +               return 0;
> 
> Why is -EINVAL ok? It would be helpful to have at least a comment to
> explain this behavior.

I changed hfi_session_int to return EINVAL when you call it more than
once, and this check is to avoid having of new flag in the decoder
instance structure. Also vdec_session_init is called by vb2::queue_setup
and will be called more than once.

> 
>> +       else if (ret)
>>                 return ret;
>>
>> -       ret = venus_helper_set_input_resolution(inst, inst->out_width,
>> -                                               inst->out_height);
>> -       if (ret)
>> -               goto deinit;
>> -
>> -       ret = venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
>> +       ret = venus_helper_set_input_resolution(inst, frame_width_min(inst),
>> +                                               frame_height_min(inst));
>>         if (ret)
>>                 goto deinit;
>>
>> @@ -681,26 +678,19 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
>>
>>         *in_num = *out_num = 0;
>>
>> -       ret = vdec_init_session(inst);
>> -       if (ret)
>> -               return ret;
>> -
>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
>>         if (ret)
>> -               goto deinit;
>> +               return ret;
>>
>>         *in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>>
>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
>>         if (ret)
>> -               goto deinit;
>> +               return ret;
>>
>>         *out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
>>
>> -deinit:
>> -       hfi_session_deinit(inst);
>> -
>> -       return ret;
>> +       return 0;
>>  }
>>
>>  static int vdec_queue_setup(struct vb2_queue *q,
>> @@ -733,6 +723,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
>>                 return 0;
>>         }
>>
>> +       ret = vdec_session_init(inst);
>> +       if (ret)
>> +               return ret;
>> +
>>         ret = vdec_num_buffers(inst, &in_num, &out_num);
>>         if (ret)
>>                 return ret;
>> @@ -758,6 +752,11 @@ static int vdec_queue_setup(struct vb2_queue *q,
>>                 inst->output_buf_size = sizes[0];
>>                 *num_buffers = max(*num_buffers, out_num);
>>                 inst->num_output_bufs = *num_buffers;
>> +
>> +               mutex_lock(&inst->lock);
>> +               if (inst->codec_state == DEC_STATE_CAPTURE_SETUP)
>> +                       inst->codec_state = DEC_STATE_STOPPED;
>> +               mutex_unlock(&inst->lock);
>>                 break;
>>         default:
>>                 ret = -EINVAL;
>> @@ -794,80 +793,298 @@ static int vdec_verify_conf(struct venus_inst *inst)
>>         return 0;
>>  }
>>
>> -static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>> +static int vdec_start_capture(struct venus_inst *inst)
>>  {
>> -       struct venus_inst *inst = vb2_get_drv_priv(q);
>>         int ret;
>>
>> -       mutex_lock(&inst->lock);
>> +       if (!inst->streamon_out)
>> +               return -EINVAL;
>>
>> -       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
>> -               inst->streamon_out = 1;
>> -       else
>> -               inst->streamon_cap = 1;
>> +       if (inst->codec_state == DEC_STATE_DECODING) {
>> +               if (inst->reconfig)
>> +                       goto reconfigure;
>>
>> -       if (!(inst->streamon_out & inst->streamon_cap)) {
>> -               mutex_unlock(&inst->lock);
>> +               venus_helper_queue_dpb_bufs(inst);
>> +               venus_helper_process_initial_cap_bufs(inst);
>> +               inst->streamon_cap = 1;
>>                 return 0;
>>         }
>>
>> -       venus_helper_init_instance(inst);
>> +       if (inst->codec_state != DEC_STATE_STOPPED)
>> +               return -EINVAL;
>>
>> -       inst->reconfig = false;
>> -       inst->sequence_cap = 0;
>> -       inst->sequence_out = 0;
>> +reconfigure:
>> +       ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
>> +       if (ret)
>> +               return ret;
>>
>> -       ret = vdec_init_session(inst);
>> +       ret = vdec_output_conf(inst);
>>         if (ret)
>> -               goto bufs_done;
>> +               return ret;
>> +
>> +       ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
>> +                                       VB2_MAX_FRAME, VB2_MAX_FRAME);
>> +       if (ret)
>> +               return ret;
>> +
>> +       ret = venus_helper_intbufs_realloc(inst);
>> +       if (ret)
>> +               goto err;
>> +
>> +       ret = venus_helper_alloc_dpb_bufs(inst);
>> +       if (ret)
>> +               goto err;
>> +
>> +       ret = venus_helper_queue_dpb_bufs(inst);
>> +       if (ret)
>> +               goto free_dpb_bufs;
>> +
>> +       ret = venus_helper_process_initial_cap_bufs(inst);
>> +       if (ret)
>> +               goto free_dpb_bufs;
>> +
>> +       venus_helper_load_scale_clocks(inst->core);
>> +
>> +       ret = hfi_session_continue(inst);
>> +       if (ret)
>> +               goto free_dpb_bufs;
>> +
>> +       inst->codec_state = DEC_STATE_DECODING;
>> +
>> +       inst->streamon_cap = 1;
>> +       inst->sequence_cap = 0;
>> +       inst->reconfig = false;
>> +
>> +       return 0;
>> +
>> +free_dpb_bufs:
>> +       venus_helper_free_dpb_bufs(inst);
>> +err:
>> +       return ret;
>> +}
>> +
>> +static int vdec_start_output(struct venus_inst *inst)
>> +{
>> +       int ret;
>> +
>> +       if (inst->codec_state == DEC_STATE_SEEK) {
>> +               ret = venus_helper_process_initial_out_bufs(inst);
>> +               inst->codec_state = DEC_STATE_DECODING;
>> +               goto done;
>> +       }
>> +
>> +       if (inst->codec_state == DEC_STATE_INIT ||
>> +           inst->codec_state == DEC_STATE_CAPTURE_SETUP) {
>> +               ret = venus_helper_process_initial_out_bufs(inst);
>> +               goto done;
>> +       }
>> +
>> +       if (inst->codec_state != DEC_STATE_UNINIT)
>> +               return -EINVAL;
>> +
>> +       venus_helper_init_instance(inst);
>> +       inst->sequence_out = 0;
>> +       inst->reconfig = false;
>>
>>         ret = vdec_set_properties(inst);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>>         ret = vdec_output_conf(inst);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>>         ret = vdec_verify_conf(inst);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>>         ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
>>                                         VB2_MAX_FRAME, VB2_MAX_FRAME);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>> -       ret = venus_helper_alloc_dpb_bufs(inst);
>> +       ret = venus_helper_vb2_start_streaming(inst);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>> -       ret = venus_helper_vb2_start_streaming(inst);
>> +       ret = venus_helper_process_initial_out_bufs(inst);
>>         if (ret)
>> -               goto deinit_sess;
>> +               return ret;
>>
>> -       mutex_unlock(&inst->lock);
>> +       inst->codec_state = DEC_STATE_INIT;
>> +
>> +done:
>> +       inst->streamon_out = 1;
>> +       return ret;
>> +}
>> +
>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +       struct venus_inst *inst = vb2_get_drv_priv(q);
>> +       int ret;
>> +
>> +       mutex_lock(&inst->lock);
>> +
>> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
>> +               ret = vdec_start_capture(inst);
>> +       else
>> +               ret = vdec_start_output(inst);
>>
>> +       if (ret)
>> +               goto error;
>> +
>> +       mutex_unlock(&inst->lock);
>>         return 0;
>>
>> -deinit_sess:
>> -       hfi_session_deinit(inst);
>> -bufs_done:
>> +error:
>>         venus_helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
>> +       mutex_unlock(&inst->lock);
>> +       return ret;
>> +}
>> +
>> +static void vdec_dst_buffers_done(struct venus_inst *inst,
>> +                                 enum vb2_buffer_state state)
> 
> This function is only called as follows:
> 
> vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> 
> Therefore the state argument does not seem particularly useful. Maybe
> we can omit it and give this function a more specific name like
> vdec_cancel_dst_buffers().

I agree, will fix that in next version.

> 
>> +{
>> +       struct vb2_v4l2_buffer *buf;
>> +
>> +       while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
>> +               v4l2_m2m_buf_done(buf, state);
>> +}
>> +
>> +static int vdec_stop_capture(struct venus_inst *inst)
>> +{
>> +       int ret = 0;
>> +
>> +       switch (inst->codec_state) {
>> +       case DEC_STATE_DECODING:
>> +               ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>> +               inst->codec_state = DEC_STATE_STOPPED;
>> +               break;
>> +       case DEC_STATE_DRAIN:
>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>> +               inst->codec_state = DEC_STATE_STOPPED;
>> +               break;
> 
> You can simplify these two cases a bit:
> 
>        case DEC_STATE_DECODING:
>                ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
>                /* fallthrough */
>        case DEC_STATE_DRAIN:
>               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
>                inst->codec_state = DEC_STATE_STOPPED;
>                break;
> 
>> +       case DEC_STATE_DRC:
> 
> Just caught this now, but what does "DRC" stand for?
> 

It stands for 'Dynamic Resolution Chnage', i.e. when the resolution is
changed runtime.

-- 
regards,
Stan
