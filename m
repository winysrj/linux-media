Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40260 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751488AbdFWO5X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 10:57:23 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
To: "H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Suman Anna <s-anna@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Discussions about the Letux Kernel
        <letux-kernel@openphoenux.org>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Rob Herring <robh+dt@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Yannick Fertre <yannick.fertre@st.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <d14b8c6e-b480-36f0-ed0a-684647617dbe@suse.de>
 <3E7B1344-ECE6-4CCC-9E9D-7521BB566CDE@goldelico.com>
 <13144955.Kq5qljPvgI@avalon>
 <24C976BF-52FD-4509-BCE4-9AE41B335482@goldelico.com>
From: =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
Message-ID: <88d0e8ea-74e4-6845-4e0d-8cd0f3a054be@suse.de>
Date: Fri, 23 Jun 2017 16:57:19 +0200
MIME-Version: 1.0
In-Reply-To: <24C976BF-52FD-4509-BCE4-9AE41B335482@goldelico.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 23.06.2017 um 16:53 schrieb H. Nikolaus Schaller:
> Hi Laurent,
> 
>> Am 23.06.2017 um 13:58 schrieb Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>
>> Hi Nikolaus,
>>
>> On Friday 23 Jun 2017 12:59:24 H. Nikolaus Schaller wrote:
>>> Am 23.06.2017 um 12:46 schrieb Andreas Färber <afaerber@suse.de>:
>>>> Am 23.06.2017 um 12:25 schrieb H. Nikolaus Schaller:
>>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>>> b/Documentation/devicetree/bindings/media/i2c/ov965x.txt new file mode
>>>>>> 100644
>>>>>> index 0000000..0e0de1f
>>>>>> --- /dev/null
>>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>>> @@ -0,0 +1,37 @@
>>>>>> +* Omnivision OV9650/9652/9655 CMOS sensor
>>>>>> +
>>>>>> +The Omnivision OV965x sensor support multiple resolutions output, such
>>>>>> as
>>>>>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>>>>>> +output format.
>>>>>> +
>>>>>> +Required Properties:
>>>>>> +- compatible: should be one of
>>>>>> +	"ovti,ov9650"
>>>>>> +	"ovti,ov9652"
>>>>>> +	"ovti,ov9655"
>>>>>> +- clocks: reference to the mclk input clock.
>>>>>
>>>>> I wonder why you have removed the clock-frequency property?
>>>>>
>>>>> In some situations the camera driver must be able to tell the clock
>>>>> source which frequency it wants to see.
>>>>
>>>> That's what assigned-clock-rates property is for:
>>>>
>>>> https://www.kernel.org/doc/Documentation/devicetree/bindings/clock/clock-b
>>>> indings.txt
>>>>
>>>> AFAIU clock-frequency on devices is deprecated and equivalent to having
>>>> a clocks property pointing to a fixed-clock, which is different from a
>>>> clock with varying rate.
>>>
>>> I am not sure if that helps here. The OMAP3-ISP does not have a fixed clock
>>> rate so we can only have the driver define what it wants to see.
>>>
>>> And common practise for OMAP3-ISP based camera modules (e.g. N900, N9) is
>>> that they do it in the driver.
>>>
>>> Maybe ISP developers can comment?
>>
>> The OMAP3 ISP is a variable-frequency clock provider. The clock frequency is 
>> controlled by the clock consumer. As such, it's up to the consumer to decide 
>> whether to compute and request the clock rate dynamically at runtime, or use 
>> the assigned-clock-rates property in DT.
>>
>> Some ISPs include a clock generator, others don't. It should make no 
>> difference whether the clock is provided by the ISP, by a dedicated clock 
>> source in the SoC or by a discrete on-board adjustable clock source.
> 
> Thanks for explaining the background.
> 
> Do you have an hint or example how to use the assigned-clock-rates property in
> a DT for a camera module connected to the omap3isp?
> 
> Or does it just mean that it defines the property name?

Please read the documentation link I sent - it's in the very bottom and
should have an example.

Regards,
Andreas

-- 
SUSE Linux GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
