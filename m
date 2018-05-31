Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:37194 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754103AbeEaI4c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 May 2018 04:56:32 -0400
Received: by mail-ua0-f196.google.com with SMTP id i3-v6so14513050uad.4
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 01:56:32 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id 129-v6sm12011595vkv.43.2018.05.31.01.56.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 31 May 2018 01:56:30 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id o17-v6so462517vka.2
        for <linux-media@vger.kernel.org>; Thu, 31 May 2018 01:56:29 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-17-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-17-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 31 May 2018 17:56:18 +0900
Message-ID: <CAAFQd5B+DH3+2-7VcqJ5J4VxmftUCgS18qmfRJVzNAA+6u1NxQ@mail.gmail.com>
Subject: Re: [PATCH v2 16/29] venus: add a helper function to set dynamic
 buffer mode
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

On Tue, May 15, 2018 at 5:05 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Adds a new helper function to set dynamic buffer mode if it is
> supported by current HFI version.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 22 ++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  1 +
>  drivers/media/platform/qcom/venus/vdec.c    | 15 +++------------
>  3 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 1eda19adbf28..824ad4d2d064 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -522,6 +522,28 @@ int venus_helper_set_color_format(struct venus_inst *inst, u32 pixfmt)
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_set_color_format);
>
> +int venus_helper_set_dyn_bufmode(struct venus_inst *inst)
> +{
> +       u32 ptype = HFI_PROPERTY_PARAM_BUFFER_ALLOC_MODE;
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

The function now sets HFI_BUFFER_OUTPUT2 in addition to
HFI_BUFFER_OUTPUT only, as set by orignal code. Is it intentional? I
guess we could have this mentioned in commit message.

Best regards,
Tomasz
