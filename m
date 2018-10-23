Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw1-f66.google.com ([209.85.161.66]:39307 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbeJWLLt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 07:11:49 -0400
Received: by mail-yw1-f66.google.com with SMTP id v1-v6so16854114ywv.6
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 19:50:31 -0700 (PDT)
Received: from mail-yw1-f46.google.com (mail-yw1-f46.google.com. [209.85.161.46])
        by smtp.gmail.com with ESMTPSA id h62-v6sm2371702ywa.53.2018.10.22.19.50.29
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Oct 2018 19:50:29 -0700 (PDT)
Received: by mail-yw1-f46.google.com with SMTP id 135-v6so16849490ywo.8
        for <linux-media@vger.kernel.org>; Mon, 22 Oct 2018 19:50:29 -0700 (PDT)
MIME-Version: 1.0
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 23 Oct 2018 11:50:17 +0900
Message-ID: <CAAFQd5BcFr11Hpngpn6hNL91OibAxUv25yh2qMohgfxsKusACw@mail.gmail.com>
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
To: mgottam@codeaurora.org
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

Hi Malathi,

On Tue, Oct 9, 2018 at 4:58 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> For lower resolutions, incase of encoder, the compressed
> frame size is more than half of the corresponding input
> YUV. Keep the size as same as YUV considering worst case.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/helpers.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
> index 2679adb..05c5423 100644
> --- a/drivers/media/platform/qcom/venus/helpers.c
> +++ b/drivers/media/platform/qcom/venus/helpers.c
> @@ -649,7 +649,7 @@ u32 venus_helper_get_framesz(u32 v4l2_fmt, u32 width, u32 height)
>         }
>
>         if (compressed) {
> -               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2 / 2;
> +               sz = ALIGN(height, 32) * ALIGN(width, 32) * 3 / 2;
>                 return ALIGN(sz, SZ_4K);
>         }

Note that the driver should not enforce one particular buffer size for
bitstream buffers unless it's a workaround for broken firmware or
hardware. The userspace should be able to select the desired size.

Best regards,
Tomasz
