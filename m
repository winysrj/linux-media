Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:33300 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762078AbdEWHPF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 May 2017 03:15:05 -0400
Received: by mail-qt0-f181.google.com with SMTP id t26so120357864qtg.0
        for <linux-media@vger.kernel.org>; Tue, 23 May 2017 00:15:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170523001448.iryswhvw2irtdyuz@rob-hp-laptop>
References: <1494939383-18937-1-git-send-email-benjamin.gaignard@linaro.org>
 <1494939383-18937-2-git-send-email-benjamin.gaignard@linaro.org> <20170523001448.iryswhvw2irtdyuz@rob-hp-laptop>
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Date: Tue, 23 May 2017 09:15:04 +0200
Message-ID: <CA+M3ks4erq+_ty4pq1yTTz3JXk+MjLvh=EXGsnYh5G7wVWqVnw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] binding for stm32 cec driver
To: Rob Herring <robh@kernel.org>
Cc: Yannick Fertre <yannick.fertre@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, devicetree@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-05-23 2:14 GMT+02:00 Rob Herring <robh@kernel.org>:
> On Tue, May 16, 2017 at 02:56:22PM +0200, Benjamin Gaignard wrote:
>
> Commit message?

is missing, sorry..

>
> Preferred subject prefix is "dt-bindings: media: ..."

ok

>
>> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
>> ---
>>  .../devicetree/bindings/media/st,stm32-cec.txt        | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/st,stm32-cec.txt
>>
>> diff --git a/Documentation/devicetree/bindings/media/st,stm32-cec.txt b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
>> new file mode 100644
>> index 0000000..6be2381
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/st,stm32-cec.txt
>> @@ -0,0 +1,19 @@
>> +STMicroelectronics STM32 CEC driver
>> +
>> +Required properties:
>> + - compatible : value should be "st,stm32-cec"
>
> All stm32 chips have same CEC block?

yes the block is the same for all stm32 f4/f7/h7 chips

>
>> + - reg : Physical base address of the IP registers and length of memory
>> +      mapped region.
>> + - clocks : from common clock binding: handle to CEC clocks
>> + - clock-names : from common clock binding: must be "cec" and "hdmi-cec".
>> + - interrupts : CEC interrupt number to the CPU.
>> +
>> +Example for stm32f746:
>> +
>> +cec: cec@40006c00 {
>> +     compatible = "st,stm32-cec";
>> +     reg = <0x40006C00 0x400>;
>> +     interrupts = <94>;
>> +     clocks = <&rcc 0 STM32F7_APB1_CLOCK(CEC)>, <&rcc 1 CLK_HDMI_CEC>;
>> +     clock-names = "cec", "hdmi-cec";
>> +};
>> --
>> 1.9.1
>>
