Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f194.google.com ([209.85.217.194]:32821 "EHLO
        mail-ua0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750957AbeERNyD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 09:54:03 -0400
Received: by mail-ua0-f194.google.com with SMTP id i2-v6so5400022uah.0
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 06:54:03 -0700 (PDT)
Received: from mail-ua0-f170.google.com (mail-ua0-f170.google.com. [209.85.217.170])
        by smtp.gmail.com with ESMTPSA id o24-v6sm1309913vki.33.2018.05.18.06.54.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 06:54:01 -0700 (PDT)
Received: by mail-ua0-f170.google.com with SMTP id a3-v6so5376069uad.8
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 06:54:01 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-4-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-4-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 18 May 2018 22:53:48 +0900
Message-ID: <CAAFQd5DVz-VcyR5DibXjRXCzy=w0PeoG0ru8Eadc4+thCX4f=A@mail.gmail.com>
Subject: Re: [PATCH v2 03/29] venus: hfi: update sequence event to handle more properties
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

On Tue, May 15, 2018 at 5:14 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> HFI version 4xx can pass more properties in the sequence change
> event, extend the event structure with them.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/hfi.h      |  9 ++++++
>   drivers/media/platform/qcom/venus/hfi_msgs.c | 46
++++++++++++++++++++++++++++
>   2 files changed, 55 insertions(+)

> diff --git a/drivers/media/platform/qcom/venus/hfi.h
b/drivers/media/platform/qcom/venus/hfi.h
> index 5466b7d60dd0..21376d93170f 100644
> --- a/drivers/media/platform/qcom/venus/hfi.h
> +++ b/drivers/media/platform/qcom/venus/hfi.h
> @@ -74,6 +74,15 @@ struct hfi_event_data {
>          u32 tag;
>          u32 profile;
>          u32 level;

nit; Could we add a comment saying that it showed in 4xx?

[snip]

> +               case HFI_PROPERTY_CONFIG_VDEC_ENTROPY:
> +                       data_ptr += sizeof(u32);
> +                       entropy_mode = *(u32 *)data_ptr;
> +                       event.entropy_mode = entropy_mode;

Is the |entropy_mode| local variable necessary?

Best regards,
Tomasz
