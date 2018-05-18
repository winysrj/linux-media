Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:40779 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753695AbeERIeE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 04:34:04 -0400
Received: by mail-vk0-f65.google.com with SMTP id e67-v6so4341524vke.7
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:34:04 -0700 (PDT)
Received: from mail-vk0-f52.google.com (mail-vk0-f52.google.com. [209.85.213.52])
        by smtp.gmail.com with ESMTPSA id 23-v6sm1168661uau.40.2018.05.18.01.34.02
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 01:34:02 -0700 (PDT)
Received: by mail-vk0-f52.google.com with SMTP id x66-v6so4328852vka.11
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 01:34:02 -0700 (PDT)
MIME-Version: 1.0
References: <20180424124436.26955-1-stanimir.varbanov@linaro.org> <20180424124436.26955-2-stanimir.varbanov@linaro.org>
In-Reply-To: <20180424124436.26955-2-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 18 May 2018 17:33:50 +0900
Message-ID: <CAAFQd5CYaeUNFMFrQAC2mofd80LKt6zxBRwAje4AoWbhGvGJ0A@mail.gmail.com>
Subject: Re: [PATCH 01/28] venus: hfi_msgs: correct pointer increment
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

Hi Stanimir,

Thanks for the series. I'll be gradually reviewing subsequent patches. Stay
tuned. :)

On Tue, Apr 24, 2018 at 9:56 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> Data pointer should be incremented by size of the structure not
> the size of a pointer, correct the mistake.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/hfi_msgs.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

> diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c
b/drivers/media/platform/qcom/venus/hfi_msgs.c
> index 90c93d9603dc..589e1a6b36a9 100644
> --- a/drivers/media/platform/qcom/venus/hfi_msgs.c
> +++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
> @@ -60,14 +60,14 @@ static void event_seq_changed(struct venus_core
*core, struct venus_inst *inst,
>                          frame_sz = (struct hfi_framesize *)data_ptr;
>                          event.width = frame_sz->width;
>                          event.height = frame_sz->height;
> -                       data_ptr += sizeof(frame_sz);
> +                       data_ptr += sizeof(*frame_sz);
>                          break;
>                  case HFI_PROPERTY_PARAM_PROFILE_LEVEL_CURRENT:
>                          data_ptr += sizeof(u32);
>                          profile_level = (struct hfi_profile_level
*)data_ptr;
>                          event.profile = profile_level->profile;
>                          event.level = profile_level->level;
> -                       data_ptr += sizeof(profile_level);
> +                       data_ptr += sizeof(*profile_level);
>                          break;
>                  default:
>                          break;

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
