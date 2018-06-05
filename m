Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f193.google.com ([209.85.217.193]:34657 "EHLO
        mail-ua0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750828AbeFEEI6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 00:08:58 -0400
Received: by mail-ua0-f193.google.com with SMTP id 74-v6so634381uav.1
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 21:08:58 -0700 (PDT)
Received: from mail-vk0-f54.google.com (mail-vk0-f54.google.com. [209.85.213.54])
        by smtp.gmail.com with ESMTPSA id 103-v6sm8640009uav.19.2018.06.04.21.08.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Jun 2018 21:08:56 -0700 (PDT)
Received: by mail-vk0-f54.google.com with SMTP id 128-v6so545940vkf.8
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 21:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
 <CAAFQd5D39CkA=GucUs7YOHwsdj0gbk55BiY_gSvArY_RH4uDkg@mail.gmail.com> <2cf4f7e8-f9e6-d62b-45a8-2c348af4aafe@linaro.org>
In-Reply-To: <2cf4f7e8-f9e6-d62b-45a8-2c348af4aafe@linaro.org>
From: Tomasz Figa <tfiga@chromium.org>
Date: Tue, 5 Jun 2018 13:08:44 +0900
Message-ID: <CAAFQd5BFq+pdEpBmpw5QsO+m+fsAhexhqA_uJg1G39Mpv5E3HQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware device
To: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 4, 2018 at 10:56 PM Stanimir Varbanov
<stanimir.varbanov@linaro.org> wrote:
>
> Hi Tomasz,
>
> On 06/04/2018 04:18 PM, Tomasz Figa wrote:
> > Hi Vikash,
> >
> > On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
> >> +static int __init venus_init(void)
> >> +{
> >> +       int ret;
> >> +
> >> +       ret = platform_driver_register(&qcom_video_firmware_driver);
> >> +       if (ret)
> >> +               return ret;
> >
> > Do we really need this firmware driver? As far as I can see, the
> > approach used here should work even without any driver bound to the
> > firmware device.
>
> We need device/driver bind because we need to call dma_configure() which
> internally doing iommus sID parsing.

I can see some drivers calling of_dma_configure() directly:
https://elixir.bootlin.com/linux/latest/ident/of_dma_configure

I'm not sure if it's more elegant, but should at least require less code.

By the way, can we really assume that probe of firmware platform
device really completes before we call venus_boot()?

Best regards,
Tomasz
