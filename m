Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:44744 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751249AbeERORL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 May 2018 10:17:11 -0400
Received: by mail-vk0-f67.google.com with SMTP id x66-v6so4894309vka.11
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 07:17:11 -0700 (PDT)
Received: from mail-vk0-f41.google.com (mail-vk0-f41.google.com. [209.85.213.41])
        by smtp.gmail.com with ESMTPSA id g28-v6sm1890865uab.15.2018.05.18.07.17.08
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 May 2018 07:17:09 -0700 (PDT)
Received: by mail-vk0-f41.google.com with SMTP id q189-v6so4911268vkb.0
        for <linux-media@vger.kernel.org>; Fri, 18 May 2018 07:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org> <20180515075859.17217-5-stanimir.varbanov@linaro.org>
In-Reply-To: <20180515075859.17217-5-stanimir.varbanov@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Fri, 18 May 2018 23:16:56 +0900
Message-ID: <CAAFQd5Aw70jUdaNXwZzkf22u5-2bmmCNBO9FkpQLNPo_9nwSzQ@mail.gmail.com>
Subject: Re: [PATCH v2 04/29] venus: hfi_cmds: add set_properties for 4xx version
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

On Tue, May 15, 2018 at 5:13 PM Stanimir Varbanov <
stanimir.varbanov@linaro.org> wrote:

> Adds set_properties method to handle newer 4xx properties and
> fall-back to 3xx for the rest.

> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
> ---
>   drivers/media/platform/qcom/venus/hfi_cmds.c | 64
+++++++++++++++++++++++++++-
>   1 file changed, 63 insertions(+), 1 deletion(-)

> diff --git a/drivers/media/platform/qcom/venus/hfi_cmds.c
b/drivers/media/platform/qcom/venus/hfi_cmds.c
> index 1cfeb7743041..6bd287154796 100644
> --- a/drivers/media/platform/qcom/venus/hfi_cmds.c
> +++ b/drivers/media/platform/qcom/venus/hfi_cmds.c

[snip]

> +       case HFI_PROPERTY_CONFIG_VENC_MAX_BITRATE:
> +               /* not implemented on Venus 4xx */

Shouldn't return -EINVAL here, similar to what
pkt_session_set_property_1x() does for unknown property?

> +               break;
> +       default:
> +               ret = pkt_session_set_property_3xx(pkt, cookie, ptype,
pdata);
> +               break;

nit: How about simply return pkt_session_set_property_3xx(pkt, cookie,
ptype, pdata); and removing the |ret| variable completely, since the return
below the switch can just return 0 all the time?

> +       }
> +
> +       return ret;
> +}
> +
>   int pkt_session_get_property(struct hfi_session_get_property_pkt *pkt,
>                               void *cookie, u32 ptype)
>   {
> @@ -1181,7 +1240,10 @@ int pkt_session_set_property(struct
hfi_session_set_property_pkt *pkt,
>          if (hfi_ver == HFI_VERSION_1XX)
>                  return pkt_session_set_property_1x(pkt, cookie, ptype,
pdata);

> -       return pkt_session_set_property_3xx(pkt, cookie, ptype, pdata);
> +       if (hfi_ver == HFI_VERSION_3XX)
> +               return pkt_session_set_property_3xx(pkt, cookie, ptype,
pdata);
> +
> +       return pkt_session_set_property_4xx(pkt, cookie, ptype, pdata);

nit: Since we're adding third variant, I'd consider using function pointers
here, but no strong opinion.

Best regards,
Tomasz
