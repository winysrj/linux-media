Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38926 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727975AbeJWQbI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Oct 2018 12:31:08 -0400
Received: by mail-ot1-f67.google.com with SMTP id a18so472627otl.6
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2018 01:08:52 -0700 (PDT)
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com. [209.85.167.178])
        by smtp.gmail.com with ESMTPSA id f5-v6sm124078oih.51.2018.10.23.01.08.50
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Oct 2018 01:08:50 -0700 (PDT)
Received: by mail-oi1-f178.google.com with SMTP id k64-v6so361968oia.13
        for <linux-media@vger.kernel.org>; Tue, 23 Oct 2018 01:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <1540209912-24834-1-git-send-email-mgottam@codeaurora.org>
In-Reply-To: <1540209912-24834-1-git-send-email-mgottam@codeaurora.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Tue, 23 Oct 2018 17:08:39 +0900
Message-ID: <CAPBb6MUB6cOEgN3fnFfPBLMmVJQ4BbjWYeJRY1_v=oQW-vNWyg@mail.gmail.com>
Subject: Re: [PATCH v2] media: venus: handle peak bitrate set property
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

Hi Malathi,

On Mon, Oct 22, 2018 at 9:06 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>
> Max bitrate property is not supported for venus version 4xx.
> Return unsupported from packetization layer. Handle it in
> hfi_venus layer to exit gracefully to venc layer.
>
> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>

This seems to work, thanks!

Tested-by: Alexandre Courbot <acourbot@chromium.org>

> ---
>  drivers/media/platform/qcom/venus/hfi_cmds.c  | 2 +-
>  drivers/media/platform/qcom/venus/hfi_venus.c | 2 ++
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c b/drivers/media/platform/qcom/venus/hfi_cmds.c
> index e8389d8..87a4414 100644
> --- a/drivers/media/platform/qcom/venus/hfi_cmds.c
> +++ b/drivers/media/platform/qcom/venus/hfi_cmds.c
> @@ -1215,7 +1215,7 @@ static int pkt_session_set_property_1x(struct hfi_session_set_property_pkt *pkt,
>         }
>         case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
>                 /* not implemented on Venus 4xx */
> -               break;
> +               return -ENOTSUPP;
>         default:
>                 return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
>         }
> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c b/drivers/media/platform/qcom/venus/hfi_venus.c
> index 1240855..9d086b9 100644
> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
> @@ -1355,6 +1355,8 @@ static int venus_session_set_property(struct venus_inst *inst, u32 ptype,
>         pkt = (struct hfi_session_set_property_pkt *)packet;
>
>         ret = pkt_session_set_property(pkt, inst, ptype, pdata);
> +       if (ret == -ENOTSUPP)
> +               return 0;
>         if (ret)
>                 return ret;
>
> --
> 1.9.1
>
