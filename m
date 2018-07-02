Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:39104 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964977AbeGBIqL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:46:11 -0400
Received: by mail-io0-f194.google.com with SMTP id e13-v6so14037989iof.6
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:11 -0700 (PDT)
Received: from mail-it0-f47.google.com (mail-it0-f47.google.com. [209.85.214.47])
        by smtp.gmail.com with ESMTPSA id p23-v6sm3241628itf.39.2018.07.02.01.46.09
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:46:10 -0700 (PDT)
Received: by mail-it0-f47.google.com with SMTP id s7-v6so164029itb.4
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org> <20180627152725.9783-16-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-16-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:45:58 +0900
Message-ID: <CAPBb6MVitXuqka=OjjMCcJ0QQQFtehdz=B-TKHDBORabuVGitw@mail.gmail.com>
Subject: Re: [PATCH v4 15/27] venus: helpers: add helper function to set
 actual buffer size
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org,
        Tomasz Figa <tfiga@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 28, 2018 at 12:30 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Add and use a helper function to set actual buffer size for
> particular buffer type. This is also preparation to use
> the second decoder output.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 12 ++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    | 10 ++--------
>  3 files changed, 15 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index e3dc2772946f..0cce664f093d 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -541,6 +541,18 @@ int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
>
> +int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype)
> +{
> +       u32 ptype = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;

const u32? Also valid for similar declarations in later patches.

> +       struct hfi_buffer_size_actual bufsz;
> +
> +       bufsz.type = buftype;
> +       bufsz.size = bufsize;
> +
> +       return hfi_session_set_property(inst, ptype, &bufsz);
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_set_bufsize);
> +
>  static void delayed_process_buf_func(struct work_struct *work)
>  {
>         struct venus_buffer *buf, *n;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 52b961ed491e..cd306bd8978f 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -41,6 +41,7 @@ int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
>                               unsigned int output_bufs);
>  int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
>  int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
> +int venus_helper_set_bufsize(struct venus_inst *inst, u32 bufsize, u32 buftype);
>  void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
>  void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
>  void venus_helper_init_instance(struct venus_inst *inst);
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 92669a358a90..eae9c651ac91 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -710,7 +710,6 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>  {
>         struct venus_inst *inst = vb2_get_drv_priv(q);
>         struct venus_core *core = inst->core;
> -       u32 ptype;
>         int ret;
>
>         mutex_lock(&inst->lock);
> @@ -740,13 +739,8 @@ static int vdec_start_streaming(struct vb2_queue *q, unsigned int count)
>                 goto deinit_sess;
>
>         if (core->res->hfi_version == HFI_VERSION_3XX) {
> -               struct hfi_buffer_size_actual buf_sz;
> -
> -               ptype = HFI_PROPERTY_PARAM_BUFFER_SIZE_ACTUAL;
> -               buf_sz.type = HFI_BUFFER_OUTPUT;
> -               buf_sz.size = inst->output_buf_size;
> -
> -               ret = hfi_session_set_property(inst, ptype, &buf_sz);
> +               ret = venus_helper_set_bufsize(inst, inst->output_buf_size,
> +                                              HFI_BUFFER_OUTPUT);
>                 if (ret)
>                         goto deinit_sess;
>         }
> --
> 2.14.1
>
