Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f195.google.com ([209.85.219.195]:40050 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbeKNVHu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Nov 2018 16:07:50 -0500
Received: by mail-yb1-f195.google.com with SMTP id g9-v6so6709923ybh.7
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 03:05:03 -0800 (PST)
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com. [209.85.219.182])
        by smtp.gmail.com with ESMTPSA id w68-v6sm5613027ywa.61.2018.11.14.03.05.01
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 03:05:01 -0800 (PST)
Received: by mail-yb1-f182.google.com with SMTP id u103-v6so6718702ybi.5
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2018 03:05:01 -0800 (PST)
MIME-Version: 1.0
References: <1538222432-25894-1-git-send-email-sgorle@codeaurora.org> <1538222432-25894-5-git-send-email-sgorle@codeaurora.org>
In-Reply-To: <1538222432-25894-5-git-send-email-sgorle@codeaurora.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 14 Nov 2018 20:04:48 +0900
Message-ID: <CAAFQd5BoP1jbzLam7X1TOxEMNCkVDTkjNWbBkcn3zdiScy0HjA@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] media: venus: video decoder drop frames handling
To: sgorle@codeaurora.org
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

On Sat, Sep 29, 2018 at 9:01 PM Srinu Gorle <sgorle@codeaurora.org> wrote:
>
> - when drop frame flag received from venus h/w, reset buffer
>   parameters and update v4l2 buffer flags as error buffer.
>
> Signed-off-by: Srinu Gorle <sgorle@codeaurora.org>
> ---
>  drivers/media/platform/qcom/venus/vdec.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
> index 0035cf2..311f209 100644
> --- a/drivers/media/platform/qcom/venus/vdec.c
> +++ b/drivers/media/platform/qcom/venus/vdec.c
> @@ -991,6 +991,12 @@ static void vdec_buf_done(struct venus_inst *inst, unsigned int buf_type,
>         if (hfi_flags & HFI_BUFFERFLAG_DATACORRUPT)
>                 state = VB2_BUF_STATE_ERROR;
>
> +       if (hfi_flags & HFI_BUFFERFLAG_DROP_FRAME) {
> +               vb->planes[0].bytesused = 0;
> +               vb->timestamp = 0;
> +               state = VB2_BUF_STATE_ERROR;
> +       }

What does this HFI_BUFFERFLAG_DROP_FRAME flag mean? When would it
happen? I assume it applies only to CAPTURE buffers, since for OUTPUT
buffers you must not set the bytesuses/timestamp yourself, right? Is
the buffer guaranteed to have no decoded frame inside or the frame
could be there, but incomplete/corrupted?

Best regards,
Tomasz
