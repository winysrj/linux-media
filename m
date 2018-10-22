Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36703 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbeJVO3Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Oct 2018 10:29:25 -0400
Received: by mail-ot1-f67.google.com with SMTP id x4so37440436otg.3
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:12:19 -0700 (PDT)
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com. [209.85.210.44])
        by smtp.gmail.com with ESMTPSA id n43sm11663506otb.36.2018.10.21.23.12.17
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Oct 2018 23:12:18 -0700 (PDT)
Received: by mail-ot1-f44.google.com with SMTP id u22so38806969ota.12
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2018 23:12:17 -0700 (PDT)
MIME-Version: 1.0
References: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1539071530-1441-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 22 Oct 2018 15:12:06 +0900
Message-ID: <CAPBb6MWF2XWZyyKUXpe=JDmSfcyPcjgXWOd5VQDpmz9iA4C1PQ@mail.gmail.com>
Subject: Re: [PATCH] media: venus: amend buffer size for bitstream plane
To: mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 9, 2018 at 4:52 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> For lower resolutions, incase of encoder, the compressed
> frame size is more than half of the corresponding input
> YUV. Keep the size as same as YUV considering worst case.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>

This fixes some issues we had with low-resolution VP8 encoding. Maybe
this can be refined some more for higher resolutions, but the current
version at least works.

Tested-by: Alexandre Courbot <acourbot@chromium.org>

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
>
> --
> 1.9.1
>
