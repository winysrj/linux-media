Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:39436 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbeEaIAF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 04:00:05 -0400
Received: by mail-ua0-f193.google.com with SMTP id v17-v6so14391870uak.6
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 01:00:04 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id e76-v6sm14860482vkf.9.2018.05.31.01.00.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 01:00:02 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id n134-v6so12773698vke.12
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 01:00:02 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-16-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-16-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 16:59:51 +0900
Message-ID: <CAAFQd5BgTB0s0Dp7rqAVqxrUA74KNZSCo67xwVBPoWnZHiudFQ@mail.gmail.com>
Subject: Re: [PATCH v2 15/29] venus: helpers: rename a helper function and use
 buffer mode from caps
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 15, 2018 at 5:06 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Rename is_reg_unreg_needed() to better name is_dynamic_bufmode() and
> use buffer mode from enumerated per codec capabilities.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 21 +++++++++++----------
>  1 file changed, 11 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 2b21f6ed7502..1eda19adbf28 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -354,18 +354,19 @@ session_process_buf(struct venus_inst *inst, struct vb2_v4l2_buffer *vbuf)
>         return 0;
>  }
>
> -static inline int is_reg_unreg_needed(struct venus_inst *inst)
> +static inline int is_dynamic_bufmode(struct venus_inst *inst)

nit: Could be made bool.

>  {
> -       if (inst->session_type == VIDC_SESSION_TYPE_DEC &&
> -           inst->core->res->hfi_version == HFI_VERSION_3XX)
> -               return 0;
> +       struct venus_core *core = inst->core;
> +       struct venus_caps *caps;
>
> -       if (inst->session_type == VIDC_SESSION_TYPE_DEC &&
> -           inst->cap_bufs_mode_dynamic &&
> -           inst->core->res->hfi_version == HFI_VERSION_1XX)
> +       caps = venus_caps_by_codec(core, inst->hfi_codec, inst->session_type);
> +       if (!caps)
>                 return 0;
>
> -       return 1;
> +       if (caps->cap_bufs_mode_dynamic)
> +               return 1;
> +
> +       return 0;

nit: return caps->cap_bufs_mode_dynamic;

Best regards,
Tomasz
