Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33054 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752651AbeEUMRM (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 May 2018 08:17:12 -0400
Received: by mail-wm0-f67.google.com with SMTP id x12-v6so11866509wmc.0
        for <linux-media@vger.kernel.org>; Mon, 21 May 2018 05:17:12 -0700 (PDT)
Subject: Re: [PATCH v2 07/29] venus: hfi_venus: add halt AXI support for Venus
 4xx
To: Tomasz Figa <tfiga@google.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        vgarodia@codeaurora.org
References: <20180515075859.17217-1-stanimir.varbanov@linaro.org>
 <20180515075859.17217-8-stanimir.varbanov@linaro.org>
 <CAAFQd5Ck1x1voV3=G_3yJEh_0S-4kYkx13P00kyMRbhJ4=sSCA@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <642a4a69-70fb-c72d-5700-1c55755d3073@linaro.org>
Date: Mon, 21 May 2018 15:17:09 +0300
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ck1x1voV3=G_3yJEh_0S-4kYkx13P00kyMRbhJ4=sSCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On 05/18/2018 05:23 PM, Tomasz Figa wrote:
> On Tue, May 15, 2018 at 5:12 PM Stanimir Varbanov <
> stanimir.varbanov@linaro.org> wrote:
> 
>> Add AXI halt support for version 4xx by using venus wrapper
>> registers.
> 
>> Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
>> ---
>>   drivers/media/platform/qcom/venus/hfi_venus.c | 17 +++++++++++++++++
>>   1 file changed, 17 insertions(+)
> 
>> diff --git a/drivers/media/platform/qcom/venus/hfi_venus.c
> b/drivers/media/platform/qcom/venus/hfi_venus.c
>> index 734ce11b0ed0..53546174aab8 100644
>> --- a/drivers/media/platform/qcom/venus/hfi_venus.c
>> +++ b/drivers/media/platform/qcom/venus/hfi_venus.c
>> @@ -532,6 +532,23 @@ static int venus_halt_axi(struct venus_hfi_device
> *hdev)
>>          u32 val;
>>          int ret;
> 
>> +       if (hdev->core->res->hfi_version == HFI_VERSION_4XX) {
>> +               val = venus_readl(hdev, WRAPPER_CPU_AXI_HALT);
>> +               val |= BIT(16);
> 
> Can we have the bit defined?
> 
>> +               venus_writel(hdev, WRAPPER_CPU_AXI_HALT, val);
>> +
>> +               ret = readl_poll_timeout(base +
> WRAPPER_CPU_AXI_HALT_STATUS,
>> +                                        val, val & BIT(24),
> 
> Ditto.

Sure will add defines.

-- 
regards,
Stan
