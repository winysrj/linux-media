Return-Path: <SRS0=OvUS=QF=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D20EC169C4
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 08:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2F49217F5
	for <linux-media@archiver.kernel.org>; Tue, 29 Jan 2019 08:25:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="fS5Ynd4p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfA2IZR (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 29 Jan 2019 03:25:17 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39285 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfA2IZN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Jan 2019 03:25:13 -0500
Received: by mail-ot1-f65.google.com with SMTP id n8so17158803otl.6
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 00:25:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8z4Kx57ExMUWfkFjieEKjRbZj5hOe0SwUMdmJNp6Ecs=;
        b=fS5Ynd4pX5D+Nn3upDmLjTrnrwC1ERqLG7gMJT3YtTCaSbsXTBGu4tBzvZf2LscSu/
         4JqCAc4UcwjQUC/Fiq914EVjeU6taOJ+Pz1Ch1qyLVP4jJ4JpVISB5kiDpqRAHvvKugU
         sVUEgxhOheEK2Hr9YuL+dNU5LKDTHmuR1Ip3k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8z4Kx57ExMUWfkFjieEKjRbZj5hOe0SwUMdmJNp6Ecs=;
        b=d6sUp9wdods9y3uEl+sMqiUgDOkJ9fGd2Q1aPg1JM5WiM8QejCZFNCIKSP8F1ECdYJ
         WfjkHOQO9AyobUH2O5rIkKnGJi13to59u8jMqP+toNKK42dlO257W0mSkUAL9jpAsyQ1
         BdH+UQMnprd8On49WztqEnKgss6ENm3irbJgQhMNK3t4QigMsqlP71nsdva6WQu0x3F8
         5Nti619LfxNFjg6BN2nUwrwCnzUdESX0oD740w3mqzby4Q3WUYmprKg3qjdc9IF/sltZ
         GsCepbr4iWfyoIxuCV2r4/tkDBCrLDIoL3IfaiMeH2CDF+KtvxZ9QMN1OWYzvXYXMqw4
         6NpA==
X-Gm-Message-State: AJcUukesrjCEmeQfEMgcZSikAPq+Oay4stAyq5mBrVuoIr2kA5W0PJIc
        DzgkQBTMqDVSlNyqUNWEZWUe91C1LCs=
X-Google-Smtp-Source: ALg8bN60IpTG8Bll4wrO+Vr+EA0A+VNRjRo1t/Es50awdYYhjNUkT/k18OkXY/Iy46RGU1MG8TUd6A==
X-Received: by 2002:a9d:348:: with SMTP id 66mr17921089otv.300.1548750311378;
        Tue, 29 Jan 2019 00:25:11 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id t201sm6108697oie.37.2019.01.29.00.25.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 00:25:10 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id e12so17163911otl.5
        for <linux-media@vger.kernel.org>; Tue, 29 Jan 2019 00:25:10 -0800 (PST)
X-Received: by 2002:a05:6830:1193:: with SMTP id u19mr19108121otq.152.1548750309754;
 Tue, 29 Jan 2019 00:25:09 -0800 (PST)
MIME-Version: 1.0
References: <20190117162008.25217-1-stanimir.varbanov@linaro.org>
 <20190117162008.25217-11-stanimir.varbanov@linaro.org> <CAAFQd5Cm1zyPzJnixwNmWzxn2zh=63YrA+ZzH-arW-VZ_x-Awg@mail.gmail.com>
 <28069a44-b188-6b89-2687-542fa762c00e@linaro.org> <CAAFQd5BevOV2r1tqmGPnVtdwirGMWU=ZJU85HjfnH-qMyQiyEg@mail.gmail.com>
 <bf5da04f-779f-e0d9-8cee-99e19096c651@linaro.org>
In-Reply-To: <bf5da04f-779f-e0d9-8cee-99e19096c651@linaro.org>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 29 Jan 2019 17:24:58 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CKOoZBmgGhyncdu7jNgb_5RPqqWtuCzh+ucE9LYqHfrA@mail.gmail.com>
Message-ID: <CAAFQd5CKOoZBmgGhyncdu7jNgb_5RPqqWtuCzh+ucE9LYqHfrA@mail.gmail.com>
Subject: Re: [PATCH 10/10] venus: dec: make decoder compliant with stateful
 codec API
To:     Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Vikash Garodia <vgarodia@codeaurora.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Malathi Gottam <mgottam@codeaurora.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 29, 2019 at 1:28 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Tomasz,
>
> On 1/28/19 9:38 AM, Tomasz Figa wrote:
> > On Fri, Jan 25, 2019 at 7:25 PM Stanimir Varbanov
> > <stanimir.varbanov@linaro.org> wrote:
> >>
> >> Hi Tomasz,
> >>
> >> Thanks for the comments!
> >>
> >> On 1/25/19 9:59 AM, Tomasz Figa wrote:
> >>> .Hi Stan,
> >>>
> >>> On Fri, Jan 18, 2019 at 1:21 AM Stanimir Varbanov
> >>> <stanimir.varbanov@linaro.org> wrote:
> >>>>
> >>>> This refactored code for start/stop streaming vb2 operations and
> >>>> adds a state machine handling similar to the one in stateful codec
> >>>> API documentation. One major change is that now the HFI session is
> >>>> started on STREAMON(OUTPUT) and stopped on REQBUF(OUTPUT,count=0),
> >>>> during that time streamoff(cap,out) just flush buffers but doesn't
> >>>> stop the session. The other major change is that now the capture
> >>>> and output queues are completely separated.
> >>>>
> >>>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> >>>> ---
> >>>>  drivers/media/platform/qcom/venus/core.h    |  20 +-
> >>>>  drivers/media/platform/qcom/venus/helpers.c |  23 +-
> >>>>  drivers/media/platform/qcom/venus/helpers.h |   5 +
> >>>>  drivers/media/platform/qcom/venus/vdec.c    | 449 ++++++++++++++++----
> >>>>  4 files changed, 389 insertions(+), 108 deletions(-)
> >>>>
> >>>
> >>> Thanks for the patch! Please see some comments inline.
> >>>
> >>>> diff --git a/drivers/media/platform/qcom/venus/core.h b/drivers/media/platform/qcom/venus/core.h
> >>>> index 79c7e816c706..5a133c203455 100644
> >>>> --- a/drivers/media/platform/qcom/venus/core.h
> >>>> +++ b/drivers/media/platform/qcom/venus/core.h
> >>>> @@ -218,6 +218,15 @@ struct venus_buffer {
> >>>>
> >>>>  #define to_venus_buffer(ptr)   container_of(ptr, struct venus_buffer, vb)
> >>>>
> >>>> +#define DEC_STATE_UNINIT               0
> >>>> +#define DEC_STATE_INIT                 1
> >>>> +#define DEC_STATE_CAPTURE_SETUP                2
> >>>> +#define DEC_STATE_STOPPED              3
> >>>> +#define DEC_STATE_SEEK                 4
> >>>> +#define DEC_STATE_DRAIN                        5
> >>>> +#define DEC_STATE_DECODING             6
> >>>> +#define DEC_STATE_DRC                  7
> >>>> +
> >>>>  /**
> >>>>   * struct venus_inst - holds per instance paramerters
> >>>>   *
> >>>> @@ -241,6 +250,10 @@ struct venus_buffer {
> >>>>   * @colorspace:        current color space
> >>>>   * @quantization:      current quantization
> >>>>   * @xfer_func: current xfer function
> >>>> + * @codec_state:       current codec API state (see DEC/ENC_STATE_)
> >>>> + * @reconf_wait:       wait queue for resolution change event
> >>>> + * @ten_bits:          does new stream is 10bits depth
> >>>> + * @buf_count:         used to count number number of buffers (reqbuf(0))
> >>>>   * @fps:               holds current FPS
> >>>>   * @timeperframe:      holds current time per frame structure
> >>>>   * @fmt_out:   a reference to output format structure
> >>>> @@ -255,8 +268,6 @@ struct venus_buffer {
> >>>>   * @opb_buftype:       output picture buffer type
> >>>>   * @opb_fmt:           output picture buffer raw format
> >>>>   * @reconfig:  a flag raised by decoder when the stream resolution changed
> >>>> - * @reconfig_width:    holds the new width
> >>>> - * @reconfig_height:   holds the new height
> >>>>   * @hfi_codec:         current codec for this instance in HFI space
> >>>>   * @sequence_cap:      a sequence counter for capture queue
> >>>>   * @sequence_out:      a sequence counter for output queue
> >>>> @@ -296,6 +307,9 @@ struct venus_inst {
> >>>>         u8 ycbcr_enc;
> >>>>         u8 quantization;
> >>>>         u8 xfer_func;
> >>>> +       unsigned int codec_state;
> >>>> +       wait_queue_head_t reconf_wait;
> >>>> +       int buf_count;
> >>>>         u64 fps;
> >>>>         struct v4l2_fract timeperframe;
> >>>>         const struct venus_format *fmt_out;
> >>>> @@ -310,8 +324,6 @@ struct venus_inst {
> >>>>         u32 opb_buftype;
> >>>>         u32 opb_fmt;
> >>>>         bool reconfig;
> >>>> -       u32 reconfig_width;
> >>>> -       u32 reconfig_height;
> >>>>         u32 hfi_codec;
> >>>>         u32 sequence_cap;
> >>>>         u32 sequence_out;
> >>>> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> >>>> index 637ce7b82d94..25d8cceccae4 100644
> >>>> --- a/drivers/media/platform/qcom/venus/helpers.c
> >>>> +++ b/drivers/media/platform/qcom/venus/helpers.c
> >>>> @@ -1030,16 +1030,15 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
> >>>>
> >>>>         v4l2_m2m_buf_queue(m2m_ctx, vbuf);
> >>>>
> >>>> -       if (!(inst->streamon_out & inst->streamon_cap))
> >>>> -               goto unlock;
> >>>> -
> >>>> -       ret = is_buf_refed(inst, vbuf);
> >>>> -       if (ret)
> >>>> -               goto unlock;
> >>>> +       if (IS_OUT(vb->vb2_queue, inst) || IS_CAP(vb->vb2_queue, inst)) {
> >>>
> >>> Wouldn't a simple vb2_is_streaming() work here?
> >>
> >> I'd say no, because the buffer can be queued but the streaming on that
> >> queue isn't started yet. The idea is to send buffers to firmware only
> >> when the streaming is on on that queue,
> >
> > Isn't it exactly what vb2_is_streaming(vb->vb2_queue) would check?
>
> Not exactly, q->streaming is set when user call STREAMON but most of the
> logic is in vb2::start_streaming, but start_streaming is called on first
> QBUF (see q->start_streaming_called flag).
>

Unless you set q->min_buffers_needed to 0.

[snip]

> >>>> +
> >>>>  struct venus_inst;
> >>>>  struct venus_core;
> >>>>
> >>>> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> >>>> index 7a9370df7515..306e0f7d3337 100644
> >>>> --- a/drivers/media/platform/qcom/venus/vdec.c
> >>>> +++ b/drivers/media/platform/qcom/venus/vdec.c
> >>>> @@ -201,28 +201,18 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
> >>>>         struct venus_inst *inst = to_inst(file);
> >>>>         const struct venus_format *fmt = NULL;
> >>>>         struct v4l2_pix_format_mplane *pixmp = &f->fmt.pix_mp;
> >>>> +       int ret;
> >>>>
> >>>>         if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >>>>                 fmt = inst->fmt_cap;
> >>>>         else if (f->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >>>>                 fmt = inst->fmt_out;
> >>>>
> >>>> -       if (inst->reconfig) {
> >>>> -               struct v4l2_format format = {};
> >>>> -
> >>>> -               inst->out_width = inst->reconfig_width;
> >>>> -               inst->out_height = inst->reconfig_height;
> >>>> -               inst->reconfig = false;
> >>>> -
> >>>> -               format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> >>>> -               format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
> >>>> -               format.fmt.pix_mp.width = inst->out_width;
> >>>> -               format.fmt.pix_mp.height = inst->out_height;
> >>>> -
> >>>> -               vdec_try_fmt_common(inst, &format);
> >>>> -
> >>>> -               inst->width = format.fmt.pix_mp.width;
> >>>> -               inst->height = format.fmt.pix_mp.height;
> >>>> +       if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> >>>> +               ret = wait_event_timeout(inst->reconf_wait, inst->reconfig,
> >>>> +                                        msecs_to_jiffies(100));
> >>>> +               if (!ret)
> >>>> +                       return -EINVAL;
> >>>
> >>> Nope, that's not what is expected to happen here. Especially since
> >>> you're potentially in non-blocking IO mode. Regardless of that, the
> >>
> >> OK, how to handle that when userspace (for example gstreamer) hasn't
> >> support for v4l2 events? The s5p-mfc decoder is doing the same sleep in
> >> g_fmt.
> >
> > I don't think that sleep in s5p-mfc was needed for gstreamer and
> > AFAICT other drivers don't have it. Doesn't gstreamer just set the
> > coded format on OUTPUT queue on its own? That should propagate the
> > format to the CAPTURE queue, without the need to parse the stream.
>
> I'm pretty sure that this is the case in gstreamer, I've CCed Nicolas
> for his opinion.
>
> In regard to this, I make it Venus changes to always set to the firmware
> the minimum supported resolution so that it always send to v4l2 driver
> the actual resolution and propagate that through v4l2 event to the
> userspace.
>

So, if I got it correctly, that would match the behavior I described
above, right?

> >
> >>
> >>> driver should check if the format information is ready and if not,
> >>> just fail with -EACCESS here.
> >>
> >> I already commented that on Alex's reply.
> >>
> >>>
> >>>>         }
> >>>>
> >>>>         pixmp->pixelformat = fmt->pixfmt;
> >>>> @@ -457,6 +447,10 @@ vdec_try_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> >>>>                 if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
> >>>>                         return -EINVAL;
> >>>>                 break;
> >>>> +       case V4L2_DEC_CMD_START:
> >>>> +               if (cmd->flags & V4L2_DEC_CMD_START_MUTE_AUDIO)
> >>>> +                       return -EINVAL;
> >>>
> >>> We don't support any flags here. You can just check if flags != 0.
> >>> (and similarly for STOP above)
> >>
> >> OK.
> >>
> >>>
> >>>> +               break;
> >>>>         default:
> >>>>                 return -EINVAL;
> >>>>         }
> >>>> @@ -477,18 +471,23 @@ vdec_decoder_cmd(struct file *file, void *fh, struct v4l2_decoder_cmd *cmd)
> >>>>
> >>>>         mutex_lock(&inst->lock);
> >>>>
> >>>> -       /*
> >>>> -        * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on decoder
> >>>> -        * input to signal EOS.
> >>>> -        */
> >>>> -       if (!(inst->streamon_out & inst->streamon_cap))
> >>>> -               goto unlock;
> >>>> +       if (cmd->cmd == V4L2_DEC_CMD_STOP) {
> >>>> +               /*
> >>>> +                * Implement V4L2_DEC_CMD_STOP by enqueue an empty buffer on
> >>>> +                * decoder input to signal EOS.
> >>>> +                */
> >>>> +               if (!(inst->streamon_out & inst->streamon_cap))
> >>>
> >>> Although & should technically work, I think you want && here.
> >>
> >> Both are fine in this case.
> >>
> >
> > Sorry for being picky, but they're fine in terms of whether they work
> > or not, but not code quality. We're clearly checking for a logical
> > conjunction of two boolean conditions and && is the right operator to
> > do it. Especially since streamon_out and streamon_cap are plain
> > integers, not stdbool (which would guarantee that the true values of
> > both are always the same).
>
> OK, will change that to logical AND.
>
> >
> >>>
> >>>> +                       goto unlock;
> >>>>
> >>>> -       fdata.buffer_type = HFI_BUFFER_INPUT;
> >>>> -       fdata.flags |= HFI_BUFFERFLAG_EOS;
> >>>> -       fdata.device_addr = 0xdeadbeef;
> >>>> +               fdata.buffer_type = HFI_BUFFER_INPUT;
> >>>> +               fdata.flags |= HFI_BUFFERFLAG_EOS;
> >>>> +               fdata.device_addr = 0xdeadb000;
> >>>>
> >>>> -       ret = hfi_session_process_buf(inst, &fdata);
> >>>> +               ret = hfi_session_process_buf(inst, &fdata);
> >>>> +
> >>>> +               if (!ret && inst->codec_state == DEC_STATE_DECODING)
> >>>> +                       inst->codec_state = DEC_STATE_DRAIN;
> >>>> +       }
> >>>>
> >>>>  unlock:
> >>>>         mutex_unlock(&inst->lock);
> >>>> @@ -649,20 +648,18 @@ static int vdec_output_conf(struct venus_inst *inst)
> >>>>         return 0;
> >>>>  }
> >>>>
> >>>> -static int vdec_init_session(struct venus_inst *inst)
> >>>> +static int vdec_session_init(struct venus_inst *inst)
> >>>>  {
> >>>>         int ret;
> >>>>
> >>>>         ret = hfi_session_init(inst, inst->fmt_out->pixfmt);
> >>>> -       if (ret)
> >>>> +       if (ret == -EINVAL)
> >>>> +               return 0;
> >>>> +       else if (ret)
> >>>>                 return ret;
> >>>>
> >>>> -       ret = venus_helper_set_input_resolution(inst, inst->out_width,
> >>>> -                                               inst->out_height);
> >>>> -       if (ret)
> >>>> -               goto deinit;
> >>>> -
> >>>> -       ret = venus_helper_set_color_format(inst, inst->fmt_cap->pixfmt);
> >>>> +       ret = venus_helper_set_input_resolution(inst, frame_width_min(inst),
> >>>> +                                               frame_height_min(inst));
> >>>>         if (ret)
> >>>>                 goto deinit;
> >>>>
> >>>> @@ -681,26 +678,19 @@ static int vdec_num_buffers(struct venus_inst *inst, unsigned int *in_num,
> >>>>
> >>>>         *in_num = *out_num = 0;
> >>>>
> >>>> -       ret = vdec_init_session(inst);
> >>>> -       if (ret)
> >>>> -               return ret;
> >>>> -
> >>>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_INPUT, &bufreq);
> >>>>         if (ret)
> >>>> -               goto deinit;
> >>>> +               return ret;
> >>>>
> >>>>         *in_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> >>>>
> >>>>         ret = venus_helper_get_bufreq(inst, HFI_BUFFER_OUTPUT, &bufreq);
> >>>>         if (ret)
> >>>> -               goto deinit;
> >>>> +               return ret;
> >>>>
> >>>>         *out_num = HFI_BUFREQ_COUNT_MIN(&bufreq, ver);
> >>>>
> >>>> -deinit:
> >>>> -       hfi_session_deinit(inst);
> >>>> -
> >>>> -       return ret;
> >>>> +       return 0;
> >>>>  }
> >>>>
> >>>>  static int vdec_queue_setup(struct vb2_queue *q,
> >>>> @@ -733,6 +723,10 @@ static int vdec_queue_setup(struct vb2_queue *q,
> >>>>                 return 0;
> >>>>         }
> >>>>
> >>>> +       ret = vdec_session_init(inst);
> >>>> +       if (ret)
> >>>> +               return ret;
> >>>> +
> >>>>         ret = vdec_num_buffers(inst, &in_num, &out_num);
> >>>>         if (ret)
> >>>>                 return ret;
> >>>> @@ -758,6 +752,11 @@ static int vdec_queue_setup(struct vb2_queue *q,
> >>>>                 inst->output_buf_size = sizes[0];
> >>>>                 *num_buffers = max(*num_buffers, out_num);
> >>>>                 inst->num_output_bufs = *num_buffers;
> >>>> +
> >>>> +               mutex_lock(&inst->lock);
> >>>> +               if (inst->codec_state == DEC_STATE_CAPTURE_SETUP)
> >>>> +                       inst->codec_state = DEC_STATE_STOPPED;
> >>>> +               mutex_unlock(&inst->lock);
> >>>>                 break;
> >>>>         default:
> >>>>                 ret = -EINVAL;
> >>>> @@ -794,80 +793,298 @@ static int vdec_verify_conf(struct venus_inst *inst)
> >>>>         return 0;
> >>>>  }
> >>>>
> >>>> -static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> >>>> +static int vdec_start_capture(struct venus_inst *inst)
> >>>>  {
> >>>> -       struct venus_inst *inst = vb2_get_drv_priv(q);
> >>>>         int ret;
> >>>>
> >>>> -       mutex_lock(&inst->lock);
> >>>> +       if (!inst->streamon_out)
> >>>> +               return -EINVAL;
> >>>>
> >>>> -       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> >>>> -               inst->streamon_out = 1;
> >>>> -       else
> >>>> -               inst->streamon_cap = 1;
> >>>> +       if (inst->codec_state == DEC_STATE_DECODING) {
> >>>> +               if (inst->reconfig)
> >>>> +                       goto reconfigure;
> >>>>
> >>>> -       if (!(inst->streamon_out & inst->streamon_cap)) {
> >>>> -               mutex_unlock(&inst->lock);
> >>>> +               venus_helper_queue_dpb_bufs(inst);
> >>>> +               venus_helper_process_initial_cap_bufs(inst);
> >>>> +               inst->streamon_cap = 1;
> >>>>                 return 0;
> >>>>         }
> >>>>
> >>>> -       venus_helper_init_instance(inst);
> >>>> +       if (inst->codec_state != DEC_STATE_STOPPED)
> >>>> +               return -EINVAL;
> >>>>
> >>>> -       inst->reconfig = false;
> >>>> -       inst->sequence_cap = 0;
> >>>> -       inst->sequence_out = 0;
> >>>> +reconfigure:
> >>>> +       ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> >>>> +       if (ret)
> >>>> +               return ret;
> >>>>
> >>>> -       ret = vdec_init_session(inst);
> >>>> +       ret = vdec_output_conf(inst);
> >>>>         if (ret)
> >>>> -               goto bufs_done;
> >>>> +               return ret;
> >>>> +
> >>>> +       ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> >>>> +                                       VB2_MAX_FRAME, VB2_MAX_FRAME);
> >>>> +       if (ret)
> >>>> +               return ret;
> >>>> +
> >>>> +       ret = venus_helper_intbufs_realloc(inst);
> >>>> +       if (ret)
> >>>> +               goto err;
> >>>> +
> >>>> +       ret = venus_helper_alloc_dpb_bufs(inst);
> >>>> +       if (ret)
> >>>> +               goto err;
> >>>> +
> >>>> +       ret = venus_helper_queue_dpb_bufs(inst);
> >>>> +       if (ret)
> >>>> +               goto free_dpb_bufs;
> >>>> +
> >>>> +       ret = venus_helper_process_initial_cap_bufs(inst);
> >>>> +       if (ret)
> >>>> +               goto free_dpb_bufs;
> >>>> +
> >>>> +       venus_helper_load_scale_clocks(inst->core);
> >>>> +
> >>>> +       ret = hfi_session_continue(inst);
> >>>> +       if (ret)
> >>>> +               goto free_dpb_bufs;
> >>>> +
> >>>> +       inst->codec_state = DEC_STATE_DECODING;
> >>>> +
> >>>> +       inst->streamon_cap = 1;
> >>>> +       inst->sequence_cap = 0;
> >>>> +       inst->reconfig = false;
> >>>> +
> >>>> +       return 0;
> >>>> +
> >>>> +free_dpb_bufs:
> >>>> +       venus_helper_free_dpb_bufs(inst);
> >>>> +err:
> >>>> +       return ret;
> >>>> +}
> >>>> +
> >>>> +static int vdec_start_output(struct venus_inst *inst)
> >>>> +{
> >>>> +       int ret;
> >>>> +
> >>>> +       if (inst->codec_state == DEC_STATE_SEEK) {
> >>>> +               ret = venus_helper_process_initial_out_bufs(inst);
> >>>> +               inst->codec_state = DEC_STATE_DECODING;
> >>>> +               goto done;
> >>>> +       }
> >>>> +
> >>>> +       if (inst->codec_state == DEC_STATE_INIT ||
> >>>> +           inst->codec_state == DEC_STATE_CAPTURE_SETUP) {
> >>>> +               ret = venus_helper_process_initial_out_bufs(inst);
> >>>> +               goto done;
> >>>> +       }
> >>>> +
> >>>> +       if (inst->codec_state != DEC_STATE_UNINIT)
> >>>> +               return -EINVAL;
> >>>> +
> >>>> +       venus_helper_init_instance(inst);
> >>>> +       inst->sequence_out = 0;
> >>>> +       inst->reconfig = false;
> >>>>
> >>>>         ret = vdec_set_properties(inst);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>>         ret = vdec_output_conf(inst);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>>         ret = vdec_verify_conf(inst);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>>         ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> >>>>                                         VB2_MAX_FRAME, VB2_MAX_FRAME);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>> -       ret = venus_helper_alloc_dpb_bufs(inst);
> >>>> +       ret = venus_helper_vb2_start_streaming(inst);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>> -       ret = venus_helper_vb2_start_streaming(inst);
> >>>> +       ret = venus_helper_process_initial_out_bufs(inst);
> >>>>         if (ret)
> >>>> -               goto deinit_sess;
> >>>> +               return ret;
> >>>>
> >>>> -       mutex_unlock(&inst->lock);
> >>>> +       inst->codec_state = DEC_STATE_INIT;
> >>>> +
> >>>> +done:
> >>>> +       inst->streamon_out = 1;
> >>>> +       return ret;
> >>>> +}
> >>>> +
> >>>> +static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
> >>>> +{
> >>>> +       struct venus_inst *inst = vb2_get_drv_priv(q);
> >>>> +       int ret;
> >>>> +
> >>>> +       mutex_lock(&inst->lock);
> >>>> +
> >>>> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> >>>> +               ret = vdec_start_capture(inst);
> >>>> +       else
> >>>> +               ret = vdec_start_output(inst);
> >>>>
> >>>> +       if (ret)
> >>>> +               goto error;
> >>>> +
> >>>> +       mutex_unlock(&inst->lock);
> >>>>         return 0;
> >>>>
> >>>> -deinit_sess:
> >>>> -       hfi_session_deinit(inst);
> >>>> -bufs_done:
> >>>> +error:
> >>>>         venus_helper_buffers_done(inst, VB2_BUF_STATE_QUEUED);
> >>>> +       mutex_unlock(&inst->lock);
> >>>> +       return ret;
> >>>> +}
> >>>> +
> >>>> +static void vdec_dst_buffers_done(struct venus_inst *inst,
> >>>> +                                 enum vb2_buffer_state state)
> >>>> +{
> >>>> +       struct vb2_v4l2_buffer *buf;
> >>>> +
> >>>> +       while ((buf = v4l2_m2m_dst_buf_remove(inst->m2m_ctx)))
> >>>> +               v4l2_m2m_buf_done(buf, state);
> >>>> +}
> >>>> +
> >>>> +static int vdec_stop_capture(struct venus_inst *inst)
> >>>> +{
> >>>> +       int ret = 0;
> >>>> +
> >>>> +       switch (inst->codec_state) {
> >>>> +       case DEC_STATE_DECODING:
> >>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
> >>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> >>>> +               inst->codec_state = DEC_STATE_STOPPED;
> >>>> +               break;
> >>>> +       case DEC_STATE_DRAIN:
> >>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> >>>
> >>> Does this also take care of buffers that were already given to the hardware?
> >>
> >> Hmm, looks like not handling them. Looking in state machine diagram it
> >> is not clear to me what to do with those buffers. Can you clarify what
> >> are your expectations here.
> >>
> >
> > Stopping a queue must reclaim the ownership of any buffers from that
> > queue back to the kernel (and then userspace). That means that after
> > the queue is stopped, all the buffers may be actually physically
> > unmapped from the device and freed. It's not a codec interface
> > requirement, but a general vb2 principle.
>
> OK got it. When the driver is in DRAIN and STREAMOFF(CAPTURE) is called
> we have to forcibly go to STOPPED without waiting for all capture
> buffers to be decoded?

Correct.

>
> >
> >>>
> >>>> +               inst->codec_state = DEC_STATE_STOPPED;
> >>>> +               break;
> >>>> +       case DEC_STATE_DRC:
> >>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_OUTPUT);
> >>>> +               vdec_dst_buffers_done(inst, VB2_BUF_STATE_ERROR);
> >>>> +               inst->codec_state = DEC_STATE_CAPTURE_SETUP;
> >>>> +               INIT_LIST_HEAD(&inst->registeredbufs);
> >>>> +               venus_helper_free_dpb_bufs(inst);
> >>>> +               break;
> >>>> +       default:
> >>>> +               return 0;
> >>>> +       }
> >>>> +
> >>>> +       return ret;
> >>>> +}
> >>>> +
> >>>> +static int vdec_stop_output(struct venus_inst *inst)
> >>>> +{
> >>>> +       int ret = 0;
> >>>> +
> >>>> +       switch (inst->codec_state) {
> >>>> +       case DEC_STATE_DECODING:
> >>>> +       case DEC_STATE_DRAIN:
> >>>> +       case DEC_STATE_STOPPED:
> >>>> +               ret = hfi_session_flush(inst, HFI_FLUSH_ALL);
> >>>
> >>> What's exactly the behavior of this hfi_session_flush() for all the
> >>> various flush types?
> >>
> >> hfi flush function is saying to the firmware to return the buffers of
> >> particular type (ALL=input+output+output2) to the v4l2 layer via
> >> buf_done hfi operation. The buffers must be returned before we exit from
> >> hfi_session_flush.
> >>
> >
> > Okay, so then stopping the OUTPUT queue must not flush the CAPTURE
> > buffers, which I believe is what the code above is doing.
>
> Yes, that would be the ideal case but in Venus case flushing INPUT
> buffers during DECODING produces an error from firmware, so I've
> workaraounded that by flushing INPUT+OUTPUT. I don't know how to deal
> with such behaivour.

Perhaps you could requeue such CAPTURE buffers back internally in the
driver, without returning them to the application?

In any way, let me think a bit more. Maybe we can simplify this?

Best regards,
Tomasz
