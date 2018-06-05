Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34882 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751531AbeFEIpM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Jun 2018 04:45:12 -0400
Received: by mail-wm0-f66.google.com with SMTP id j15-v6so3470606wme.0
        for <linux-media@vger.kernel.org>; Tue, 05 Jun 2018 01:45:12 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] venus: register separate driver for firmware
 device
To: Tomasz Figa <tfiga@chromium.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: vgarodia@codeaurora.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, andy.gross@linaro.org,
        bjorn.andersson@linaro.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <1527884768-22392-1-git-send-email-vgarodia@codeaurora.org>
 <1527884768-22392-6-git-send-email-vgarodia@codeaurora.org>
 <CAAFQd5D39CkA=GucUs7YOHwsdj0gbk55BiY_gSvArY_RH4uDkg@mail.gmail.com>
 <2cf4f7e8-f9e6-d62b-45a8-2c348af4aafe@linaro.org>
 <CAAFQd5BFq+pdEpBmpw5QsO+m+fsAhexhqA_uJg1G39Mpv5E3HQ@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <fd74c277-e8d3-a026-fbd2-914a029e8efe@linaro.org>
Date: Tue, 5 Jun 2018 11:45:08 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BFq+pdEpBmpw5QsO+m+fsAhexhqA_uJg1G39Mpv5E3HQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: Arnd

On 06/05/2018 07:08 AM, Tomasz Figa wrote:
> On Mon, Jun 4, 2018 at 10:56 PM Stanimir Varbanov
> <stanimir.varbanov@linaro.org> wrote:
>>
>> Hi Tomasz,
>>
>> On 06/04/2018 04:18 PM, Tomasz Figa wrote:
>>> Hi Vikash,
>>>
>>> On Sat, Jun 2, 2018 at 5:27 AM Vikash Garodia <vgarodia@codeaurora.org> wrote:
>>>> +static int __init venus_init(void)
>>>> +{
>>>> +       int ret;
>>>> +
>>>> +       ret = platform_driver_register(&qcom_video_firmware_driver);
>>>> +       if (ret)
>>>> +               return ret;
>>>
>>> Do we really need this firmware driver? As far as I can see, the
>>> approach used here should work even without any driver bound to the
>>> firmware device.
>>
>> We need device/driver bind because we need to call dma_configure() which
>> internally doing iommus sID parsing.
> 
> I can see some drivers calling of_dma_configure() directly:
> https://elixir.bootlin.com/linux/latest/ident/of_dma_configure
> 
> I'm not sure if it's more elegant, but should at least require less code.

I think that in this case of non-TZ where we do iommu mapping by hand we
can use shared-dma-pool reserved memory see how venus_boot has been
implemented in the beginning [1].

Arnd what do you think?

Some background, we have a use-case where the memory for firmware needs
to be mapped by the venus driver by hand instead of TZ firmware calls.
I.e. we want to support both, iommu mapping from the driver and mapping
done by TZ firmware. How we will differentiate what mapping (TZ or
non-TZ) will be used is a separate issue.

> 
> By the way, can we really assume that probe of firmware platform
> device really completes before we call venus_boot()?

I'd say we cannot.

-- 
regards,
Stan

[1] https://lkml.org/lkml/2017/4/28/214
