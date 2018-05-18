Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f196.google.com ([209.85.217.196]:41476 "EHLO
        mail-ua0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751117AbeEROXi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:23:38 -0400
Received: by mail-ua0-f196.google.com with SMTP id a3-v6so5444045uad.8
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 07:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-8-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-8-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@google.com>
Date: Fri, 18 May 2018 23:23:25 +0900
Message-ID: <CAAFQd5Ck1x1voV3=G_3yJEh_0S-4kYkx13P00kyMRbhJ4=sSCA@mail.gmail.com>
Subject: Re: [PATCH v2 07/29] venus: hfi_venus: add halt AXI support for Venus 4xx
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

On Tue, May 15, 2018 at 5:12 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> Add AXI halt support for version 4xx by using venus wrapper
> registers.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/hfi_venus.c | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)

> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c
b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 734ce11b0ed0..53546174aab8 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -532,6 +532,23 @@ static int venus_halt_axi(struct venus_hfi_device
*hdev)
>          u32 val;
>          int ret;

> +       if (hdev->core->res->hfi_version == HFI_VERSION_4XX) {
> +               val = venus_readl(hdev, WRAPPER_CPU_AXI_HALT);
> +               val |= BIT(16);

Can we have the bit defined?

> +               venus_writel(hdev, WRAPPER_CPU_AXI_HALT, val);
> +
> +               ret = readl_poll_timeout(base +
WRAPPER_CPU_AXI_HALT_STATUS,
> +                                        val, val & BIT(24),

Ditto.

Best regards,
Tomasz
