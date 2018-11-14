Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f68.google.com ([209.85.161.68]:43214 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731585AbeKNUxS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 15:53:18 -0500
Received: by mail-yw1-f68.google.com with SMTP id l200so1490929ywe.10
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 02:50:33 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id y16sm928049ywg.35.2018.11.14.02.50.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 02:50:31 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id p144-v6so6678111yba.11
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 02:50:31 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org> <1538222432-25894-2-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-2-git-send-email-sgorle@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 19:50:18 +0900
Message-ID: <CAAFQd5BXnZpzKP6TnzOpdaYMFc9OuhcOMjAqzTtZ00dhAnXA7w@mail.gmail.com>
Subject: Re: [PATCH v1 1/5] media: venus: handle video decoder resolution change
To: sgorle@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Srinu,

On Sat, Sep 29, 2018 at 9:01 PM Srinu Gorle <sgorle@codeaurora.org> wrote:
>
> Add logic for below to handle resolution change during video decode.
> - stream off support for video decoder OUTPUT plane and
>   flush old resolution OUTPUT plane buffers.

I think you mean CAPTURE (the decoded buffers)?

> - De-allocate and allocate video firmware internal buffers.
>   And also ensures g_fmt for output plane populated
>   only after SPS and PPS has parsed.

A resolution change would be triggered by new resolution parsed from a
SPS/PPS, so the format should be ready at that time right? Generally
the spec requires G_FMT to return the new resolution after the source
change event is signaled.

[snip]
> @@ -969,14 +1029,26 @@ void venus_helper_vb2_buf_queue(struct vb2_buffer *vb)
>         struct vb2_v4l2_buffer *vbuf = to_vb2_v4l2_buffer(vb);
>         struct venus_inst *inst = vb2_get_drv_priv(vb->vb2_queue);
>         struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +       struct venus_core *core = inst->core;
> +       struct device *dev = core->dev;
>         int ret;
> +       bool is_plane_enabled;
>
>         mutex_lock(&inst->lock);
>
>         v4l2_m2m_buf_queue(m2m_ctx, vbuf);
>
> -       if (!(inst->streamon_out & inst->streamon_cap))
> +       is_plane_enabled = inst->streamon_out &&
> +               vb->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE;
> +       is_plane_enabled |= inst->streamon_cap &&
> +               vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;

Why does the condition change?

Putting aside this change, why does this driver do anything here
actually? I think it should just call v4l2_m2m_qbuf() from vidioc_qbuf
and then the M2M framework would fire driver's .device_run() callback,
taking into account driver specific conditions. It would also take
care of any necessary streamon checks, so they don't need to be
explicitly repeated in the driver. Unrelated to the patch, but perhaps
should be considered while at it?

> +
> +       if (!is_plane_enabled) {
> +               dev_info(dev, "%s: Yet to start_stream the Q",
> +                        vb->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE ?
> +                        "FTB" : "ETB");
>                 goto unlock;
> +       }
>
>         ret = is_buf_refed(inst, vbuf);
>         if (ret)
> @@ -1009,37 +1081,72 @@ void venus_helper_vb2_stop_streaming(struct vb2_queue *q)
>         struct venus_core *core = inst->core;
>         int ret;
>
> -       mutex_lock(&inst->lock);
> -
> -       if (inst->streamon_out & inst->streamon_cap) {
> -               ret = hfi_session_stop(inst);
> -               ret |= hfi_session_unload_res(inst);
> +       hfi_session_stop(inst);
> +       ret = hfi_session_unload_res(inst);

Wouldn't this end up stopping and unloading two times, once for
CAPTURE and once for OUTPUT?

Also, stopping streaming on CAPTURE shouldn't have any side effects,
other than dropping any in flight CAPTURE buffers, so this change
sounds wrong.

> +       if (inst->hfi_codec == HFI_VIDEO_CODEC_H264)
>                 ret |= session_unregister_bufs(inst);
> -               ret |= intbufs_free(inst);
> -               ret |= hfi_session_deinit(inst);
> -
> -               if (inst->session_error || core->sys_error)
> -                       ret = -EIO;
> +       ret |= intbufs_free(inst);
> +       ret |= hfi_session_deinit(inst);
>
> -               if (ret)
> -                       hfi_session_abort(inst);
> +       if (inst->session_error || core->sys_error)
> +               ret = -EIO;
>
> -               venus_helper_free_dpb_bufs(inst);
> +       if (IS_V3(core) && ret)
> +               hfi_session_abort(inst);
>
> -               load_scale_clocks(core);
> -               INIT_LIST_HEAD(&inst->registeredbufs);
> -       }
> +       venus_helper_free_dpb_bufs(inst);
> +       load_scale_clocks(core);
> +       INIT_LIST_HEAD(&inst->registeredbufs);
>
>         venus_helper_buffers_done(inst, VB2_BUF_STATE_ERROR);
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
>
> -       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -               inst->streamon_out = 0;
> -       else
> -               inst->streamon_cap = 0;
> +int venus_helper_alloc_intbufs(struct venus_inst *inst)
> +{
> +       int ret = 0;
>
> -       mutex_unlock(&inst->lock);
> +       ret = intbufs_free(inst);
> +       ret |= intbufs_alloc(inst);

Please don't OR return values. If these two functions return two
different error codes, you get useless garbage in the variable...

> +
> +       return ret;
>  }
> -EXPORT_SYMBOL_GPL(venus_helper_vb2_stop_streaming);
> +EXPORT_SYMBOL_GPL(venus_helper_alloc_intbufs);
> +
> +int venus_helper_alloc_reconfig_bufs(struct venus_inst *inst)
> +{
> +       int ret = 0;
> +
> +       ret = unset_reconfig_buffers(inst);
> +       ret |= alloc_reconfig_buffers(inst);
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_alloc_reconfig_bufs);
> +
> +int venus_helper_queue_initial_bufs(struct venus_inst *inst, unsigned int type)
> +{
> +       struct v4l2_m2m_ctx *m2m_ctx = inst->m2m_ctx;
> +       struct v4l2_m2m_buffer *buf, *n;
> +       int ret;
> +
> +       if (type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +               v4l2_m2m_for_each_dst_buf_safe(m2m_ctx, buf, n) {
> +                       ret = session_process_buf(inst, &buf->vb);
> +                       if (ret)
> +                               return_buf_error(inst, &buf->vb);
> +               }
> +       }
> +       if (type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) {
> +               v4l2_m2m_for_each_src_buf_safe(m2m_ctx, buf, n) {
> +                       ret = session_process_buf(inst, &buf->vb);
> +                       if (ret)
> +                               return_buf_error(inst, &buf->vb);
> +               }
> +       }
> +       return 0;
> +}
> +EXPORT_SYMBOL(venus_helper_queue_initial_bufs);
>
>  int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>  {
> @@ -1064,14 +1171,8 @@ int venus_helper_vb2_start_streaming(struct venus_inst *inst)
>         if (ret)
>                 goto err_unload_res;
>
> -       ret = venus_helper_queue_dpb_bufs(inst);
> -       if (ret)
> -               goto err_session_stop;
> -
>         return 0;
>
> -err_session_stop:
> -       hfi_session_stop(inst);
>  err_unload_res:
>         hfi_session_unload_res(inst);
>  err_unreg_bufs:
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 2475f284..3de0c44 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -31,6 +31,8 @@ void venus_helper_buffers_done(struct venus_inst *inst,
>  int venus_helper_vb2_start_streaming(struct venus_inst *inst);
>  void venus_helper_m2m_device_run(void *priv);
>  void venus_helper_m2m_job_abort(void *priv);
> +int venus_helper_queue_initial_bufs(struct venus_inst *inst, unsigned int type);
> +int venus_helper_alloc_intbufs(struct venus_inst *inst);
>  int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
>                             struct hfi_buffer_requirements *req);
>  u32 venus_helper_get_framesz_raw(u32 hfi_fmt, u32 width, u32 height);
> @@ -62,4 +64,5 @@ int venus_helper_get_out_fmts(struct venus_inst *inst, u32 fmt, u32 *out_fmt,
>  int venus_helper_free_dpb_bufs(struct venus_inst *inst);
>  int venus_helper_power_enable(struct venus_core *core, u32 session_type,
>                               bool enable);
> +int venus_helper_alloc_reconfig_bufs(struct venus_inst *inst);
>  #endif
> diff --git a/drivers/media/platform/qcom/venus/hfi.c b/drivers/media/platform/qcom/venus/hfi.c
> index 2420782..36a4784 100644
> --- a/drivers/media/platform/qcom/venus/hfi.c
> +++ b/drivers/media/platform/qcom/venus/hfi.c
> @@ -308,6 +308,7 @@ int hfi_session_stop(struct venus_inst *inst)
>
>         return 0;
>  }
> +EXPORT_SYMBOL_GPL(hfi_session_stop);
>
>  int hfi_session_continue(struct venus_inst *inst)
>  {
> @@ -384,14 +385,14 @@ int hfi_session_unload_res(struct venus_inst *inst)
>         return 0;
>  }
>
> -int hfi_session_flush(struct venus_inst *inst)
> +int hfi_session_flush(struct venus_inst *inst, u32 mode)
>  {
>         const struct hfi_ops *ops = inst->core->ops;
>         int ret;
>
>         reinit_completion(&inst->done);
>
> -       ret = ops->session_flush(inst, HFI_FLUSH_ALL);
> +       ret = ops->session_flush(inst, mode);
>         if (ret)
>                 return ret;
>
> diff --git a/drivers/media/platform/qcom/venus/hfi.h b/drivers/media/platform/qcom/venus/hfi.h
> index 6038d8e..5e883a1 100644
> --- a/drivers/media/platform/qcom/venus/hfi.h
> +++ b/drivers/media/platform/qcom/venus/hfi.h
> @@ -170,7 +170,7 @@ struct hfi_ops {
>  int hfi_session_abort(struct venus_inst *inst);
>  int hfi_session_load_res(struct venus_inst *inst);
>  int hfi_session_unload_res(struct venus_inst *inst);
> -int hfi_session_flush(struct venus_inst *inst);
> +int hfi_session_flush(struct venus_inst *inst, u32 mode);
>  int hfi_session_set_buffers(struct venus_inst *inst,
>                             struct hfi_buffer_desc *bd);
>  int hfi_session_unset_buffers(struct venus_inst *inst,
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 991e158..98675db 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -207,7 +207,6 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>
>                 inst->out_width = inst->reconfig_width;
>                 inst->out_height = inst->reconfig_height;
> -               inst->reconfig = false;
>
>                 format.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
>                 format.fmt.pix_mp.pixelformat = inst->fmt_cap->pixfmt;
> @@ -223,6 +222,9 @@ static int vdec_g_fmt(struct file *file, void *fh, struct v4l2_format *f)
>         pixmp->pixelformat = fmt->pixfmt;
>
>         if (f->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +               if (!(inst->reconfig))
> +                       return -EINVAL;
> +
>                 pixmp->width = inst->width;
>                 pixmp->height = inst->height;
>                 pixmp->colorspace = inst->colorspace;
> @@ -451,6 +453,8 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
>                 if (cmd->flags & V4L2_DEC_CMD_STOP_TO_BLACK)
>                         return -EINVAL;
>                 break;
> +       case V4L2_DEC_CMD_START:
> +               return 0;
>         default:
>                 return -EINVAL;
>         }
> @@ -465,6 +469,9 @@ static int vdec_subscribe_event(struct v4l2_fh *fh,
>         struct hfi_frame_data fdata = {0};
>         int ret;
>
> +       if (cmd->cmd != V4L2_DEC_CMD_STOP)
> +               return 0;
> +

Huh? This callback should return an error in case of an unsupported command.

Also, the START command can't be just ignored. The STOP command must
pause the decoding until it's reset by restarting the streaming or
resumed by the START command.

>         ret = vdec_try_decoder_cmd(file, fh, cmd);
>         if (ret)
>                 return ret;
> @@ -790,22 +797,60 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
>         struct venus_inst *inst = vb2_get_drv_priv(q);
>         int ret;
> +       bool is_mplane_enabled;
>
>         mutex_lock(&inst->lock);
> +       is_mplane_enabled = q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +                               inst->streamon_cap;
> +       is_mplane_enabled |= q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE &&
> +                               inst->streamon_out;
>
> -       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> -               inst->streamon_out = 1;
> -       else
> -               inst->streamon_cap = 1;
> +       if (is_mplane_enabled) {
> +               mutex_unlock(&inst->lock);
> +               return 0;
> +       }
>
> -       if (!(inst->streamon_out & inst->streamon_cap)) {
> +       if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE &&
> +           !inst->streamon_out){
>                 mutex_unlock(&inst->lock);
>                 return 0;
>         }
>
> +       if (inst->streamon_out && !inst->streamon_cap &&
> +           q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +               ret = vdec_output_conf(inst);
> +               if (ret)
> +                       goto deinit_sess;
> +
> +               ret = venus_helper_set_num_bufs(inst, inst->num_input_bufs,
> +                                               inst->num_output_bufs,
> +                                               inst->num_output_bufs);
> +
> +               if (ret)
> +                       goto deinit_sess;
> +
> +               ret = vdec_verify_conf(inst);
> +               if (ret)
> +                       goto deinit_sess;
> +
> +               if (inst->reconfig)
> +                       ret = venus_helper_alloc_reconfig_bufs(inst);
> +
> +               if (ret)
> +                       goto deinit_sess;
> +
> +               ret = venus_helper_alloc_dpb_bufs(inst);
> +               if (ret)
> +                       goto deinit_sess;
> +
> +               if (inst->reconfig) {
> +                       hfi_session_continue(inst);
> +                       inst->reconfig = false;
> +               }
> +               goto enable_mplane;
> +       }
>         venus_helper_init_instance(inst);
>
> -       inst->reconfig = false;
>         inst->sequence_cap = 0;
>         inst->sequence_out = 0;
>
> @@ -830,14 +875,17 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>         if (ret)
>                 goto deinit_sess;
>
> -       ret = venus_helper_alloc_dpb_bufs(inst);
> -       if (ret)
> -               goto deinit_sess;
> -
>         ret = venus_helper_vb2_start_streaming(inst);
>         if (ret)
>                 goto deinit_sess;
>
> +enable_mplane:
> +       if (q->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE)
> +               inst->streamon_out = 1;
> +       else if (q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE)
> +               inst->streamon_cap = 1;
> +
> +       ret = venus_helper_queue_initial_bufs(inst, q->type);
>         mutex_unlock(&inst->lock);
>
>         return 0;
> @@ -854,12 +902,42 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>         return ret;
>  }
>
> +static void vdec_stop_streaming(struct vb2_queue *q)
> +{
> +       struct venus_inst *inst = vb2_get_drv_priv(q);
> +       int ret;
> +
> +       mutex_lock(&inst->lock);
> +
> +       if (!inst->streamon_cap && !inst->streamon_out)
> +               goto unlock;
> +
> +       if (inst->streamon_cap &&
> +           q->type == V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE) {
> +               ret = hfi_session_stop(inst);
> +               inst->streamon_cap = 0;
> +       }
> +
> +       if (inst->streamon_out && !inst->streamon_cap) {

This looks wrong. If the application stops OUT first and then CAP
later, this code won't run.

> +               inst->streamon_out = 0;
> +               venus_helper_vb2_stop_streaming(q);
> +       }

Stopping streaming on CAPTURE shouldn't have any significant side
effects - just any queued or not-dequeued-yet buffers would be
dropped. Stopping OUTPUT begins a seek. To completely reset the
decoder, one needs to stop OUTPUT and REQBUFS(0) on it.

Best regards,
Tomasz
