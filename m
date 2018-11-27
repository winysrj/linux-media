Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38736 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729421AbeK0TVQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 14:21:16 -0500
Received: by mail-wr1-f67.google.com with SMTP id v13so18202173wrw.5
        for <linux-media@vger.kernel.org>; Tue, 27 Nov 2018 00:24:09 -0800 (PST)
Subject: Re: [PATCH] arm64: dts: sdm845: add video nodes
To: Alexandre Courbot <acourbot@chromium.org>, mgottam@codeaurora.org
Cc: Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org, vgarodia@codeaurora.org
References: <1542708506-12680-1-git-send-email-mgottam@codeaurora.org>
 <CAPBb6MVzmxfRstUrTOtkJdCDaZEZO=UeP_u3btGKrsKasBijRg@mail.gmail.com>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <7e306c60-8603-a8c4-cbb3-526f8a63ee39@linaro.org>
Date: Tue, 27 Nov 2018 10:24:06 +0200
MIME-Version: 1.0
In-Reply-To: <CAPBb6MVzmxfRstUrTOtkJdCDaZEZO=UeP_u3btGKrsKasBijRg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alex,

On 11/27/18 9:31 AM, Alexandre Courbot wrote:
> On Tue, Nov 20, 2018 at 7:08 PM Malathi Gottam <mgottam@codeaurora.org> wrote:
>>
>> This adds video nodes to sdm845 based on the examples
>> in the bindings.
>>
>> Signed-off-by: Malathi Gottam <mgottam@codeaurora.org>
>> ---
>>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 34 ++++++++++++++++++++++++++++++++++
>>  1 file changed, 34 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> index 0c9a2aa..d82487d 100644
>> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
>> @@ -84,6 +84,10 @@
>>                         reg = <0 0x86200000 0 0x2d00000>;
>>                         no-map;
>>                 };
>> +               venus_region: venus@95800000 {
>> +                       reg = <0x0 0x95800000 0x0 0x500000>;
> 
> Note that the driver expects a size of 0x600000 here and will fail to
> probe if this is smaller.
> 

I have to send a patch to fix that size mismatch as we discussed that it
the other mail thread.

-- 
regards,
Stan
