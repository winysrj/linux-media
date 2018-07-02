Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f66.google.com ([209.85.214.66]:54669 "EHLO
        mail-it0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752788AbeGBIqG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:46:06 -0400
Received: by mail-it0-f66.google.com with SMTP id s7-v6so163713itb.4
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:05 -0700 (PDT)
Received: from mail-it0-f53.google.com (mail-it0-f53.google.com. [209.85.214.53])
        by smtp.gmail.com with ESMTPSA id p130-v6sm1808632itc.38.2018.07.02.01.46.04
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:46:04 -0700 (PDT)
Received: by mail-it0-f53.google.com with SMTP id h19-v6so2615466itf.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org> <20180627152725.9783-15-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-15-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:45:52 +0900
Message-ID: <CAPBb6MWr2d3uADf23VMC92o=YDV6uS4a2Y3ErDFbwQkQhog_hg@mail.gmail.com>
Subject: Re: [PATCH v4 14/27] venus: helpers: add a helper function to set
 dynamic buffer mode
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

On Thu, Jun 28, 2018 at 12:31 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Adds a new helper function to set dynamic buffer mode if it is
> supported by current HFI version. The dynamic buffer mode is
> set unconditionally for both decoder outputs.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 22 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    | 15 +++------------
>  3 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 03121dbb4175..e3dc2772946f 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -519,6 +519,28 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
>
> +int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
> +{
> +       u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;

This could be const u32.

> +       struct hfi_buffer_alloc_mode mode;
> +       int ret;
> +
> +       if (!is_dynamic_bufmode(inst))
> +               return 0;
> +
> +       mode.type = HFI_BUFFER_OUTPUT;
> +       mode.mode = HFI_BUFFER_MODE_DYNAMIC;
> +
> +       ret = hfi_session_set_property(inst, ptype, &mode);
> +       if (ret)
> +               return ret;
> +
> +       mode.type = HFI_BUFFER_OUTPUT2;
> +
> +       return hfi_session_set_property(inst, ptype, &mode);
> +}
> +EXPORT_SYMBOL_GPL(venus_helper_set_dyn_bufmode);
> +
>  static void delayed_process_buf_func(struct work_struct *work)
>  {
>         struct venus_buffer *buf, *n;
> diff --git a/drivers/media/platform/qcom/venus/helpers.h b/drivers/media/platform/qcom/venus/helpers.h
> index 0e64aa95624a..52b961ed491e 100644
> --- a/drivers/media/platform/qcom/venus/helpers.h
> +++ b/drivers/media/platform/qcom/venus/helpers.h
> @@ -40,6 +40,7 @@ int venus_helper_set_output_resolution(struct venus_inst *inst,
>  int venus_helper_set_num_bufs(struct venus_inst *inst, unsigned int input_bufs,
>                               unsigned int output_bufs);
>  int venus_helper_set_color_format(struct venus_inst *inst, u32 fmt);
> +int venus_helper_set_dyn_bufmode(struct venus_inst *inst);
>  void venus_helper_acquire_buf_ref(struct vb2_v4l2_buffer *vbuf);
>  void venus_helper_release_buf_ref(struct venus_inst *inst, unsigned int idx);
>  void venus_helper_init_instance(struct venus_inst *inst);
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 31a240ab142b..92669a358a90 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -557,18 +557,9 @@ static int vdec_set_properties(struct venus_inst *inst)
>                         return ret;
>         }
>
> -       if (core->res->hfi_version == HFI_VERSION_3XX ||
> -           inst->cap_bufs_mode_dynamic) {
> -               struct hfi_buffer_alloc_mode mode;
> -
> -               ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
> -               mode.type = HFI_BUFFER_OUTPUT;
> -               mode.mode = HFI_BUFFER_MODE_DYNAMIC;
> -
> -               ret = hfi_session_set_property(inst, ptype, &mode);
> -               if (ret)
> -                       return ret;
> -       }
> +       ret = venus_helper_set_dyn_bufmode(inst);
> +       if (ret)
> +               return ret;
>
>         if (ctr->post_loop_deb_mode) {
>                 ptype = HFI_PROPERTY_CONFIG_VDEC_POST_LOOP_DEBLOCKER;
> --
> 2.14.1
>
