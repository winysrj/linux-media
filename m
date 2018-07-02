Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:35062 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754364AbeGBIqW (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 04:46:22 -0400
Received: by mail-io0-f195.google.com with SMTP id q4-v6so14045132iob.2
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:22 -0700 (PDT)
Received: from mail-it0-f41.google.com (mail-it0-f41.google.com. [209.85.214.41])
        by smtp.gmail.com with ESMTPSA id k20-v6sm7484077iok.9.2018.07.02.01.46.20
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 01:46:21 -0700 (PDT)
Received: by mail-it0-f41.google.com with SMTP id o5-v6so10031115itc.1
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 01:46:20 -0700 (PDT)
MIME-Version: 1.0
References: <20180627152725.9783-1-stanimir.varbanov@linaro.org> <20180627152725.9783-25-stanimir.varbanov@linaro.org>
In-Reply-To: <20180627152725.9783-25-stanimir.varbanov@linaro.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 2 Jul 2018 17:46:09 +0900
Message-ID: <CAPBb6MVPrparfoAMaVwsDrwPO1K8cnWb24WdZFGeU5aoEqDt5w@mail.gmail.com>
Subject: Re: [PATCH v4 24/27] venus: helpers: move frame size calculations on
 common place
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

On Thu, Jun 28, 2018 at 12:28 AM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> This move the calculations of raw and compressed buffer sizes
> on common helper and make it identical for encoder and decoder.
>
> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 98 +++++++++++++++++++++++++++++
>  drivers/media/platform/qcom/venus/helpers.h |  2 +
>  drivers/media/platform/qcom/venus/vdec.c    | 54 ++++------------
>  drivers/media/platform/qcom/venus/venc.c    | 56 ++++-------------
>  4 files changed, 126 insertions(+), 84 deletions(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 6b31c91528ed..a342472ae2f0 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -452,6 +452,104 @@ int venus_helper_get_bufreq(struct venus_inst *inst, u32 type,
>  }
>  EXPORT_SYMBOL_GPL(venus_helper_get_bufreq);
>
> +static u32 get_framesize_raw_nv12(u32 width, u32 height)
> +{
> +       u32 y_stride, uv_stride, y_plane;
> +       u32 y_sclines, uv_sclines, uv_plane;
> +       u32 size;
> +
> +       y_stride = ALIGN(width, 128);
> +       uv_stride = ALIGN(width, 128);
> +       y_sclines = ALIGN(height, 32);
> +       uv_sclines = ALIGN(((height + 1) >> 1), 16);
> +
> +       y_plane = y_stride * y_sclines;
> +       uv_plane = uv_stride * uv_sclines + SZ_4K;
> +       size = y_plane + uv_plane + SZ_8K;

Do you know the reason for this extra 8K at the end?
