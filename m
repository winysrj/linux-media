Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:50843 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753786AbdFWSG3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 14:06:29 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
To: "H. Nikolaus Schaller" <hns@goldelico.com>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hugues Fruchet <hugues.fruchet@st.com>,
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
        <linux-media@vger.kernel.org>
References: <1498143942-12682-1-git-send-email-hugues.fruchet@st.com>
 <d14b8c6e-b480-36f0-ed0a-684647617dbe@suse.de>
 <3E7B1344-ECE6-4CCC-9E9D-7521BB566CDE@goldelico.com>
 <13144955.Kq5qljPvgI@avalon>
 <24C976BF-52FD-4509-BCE4-9AE41B335482@goldelico.com>
 <88d0e8ea-74e4-6845-4e0d-8cd0f3a054be@suse.de>
 <05CBF9B8-2297-447B-860D-A89126B46FC9@goldelico.com>
From: Suman Anna <s-anna@ti.com>
Message-ID: <3f0dcd4f-92ef-a79d-b00b-1f348a201bd2@ti.com>
Date: Fri, 23 Jun 2017 13:05:26 -0500
MIME-Version: 1.0
In-Reply-To: <05CBF9B8-2297-447B-860D-A89126B46FC9@goldelico.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nikolaus,

On 06/23/2017 10:22 AM, H. Nikolaus Schaller wrote:
> Hi,
> 
>> Am 23.06.2017 um 16:57 schrieb Andreas Färber <afaerber@suse.de>:
>>
>> Am 23.06.2017 um 16:53 schrieb H. Nikolaus Schaller:
>>> Hi Laurent,
>>>
>>>> Am 23.06.2017 um 13:58 schrieb Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
>>>>
>>>> Hi Nikolaus,
>>>>
>>>> On Friday 23 Jun 2017 12:59:24 H. Nikolaus Schaller wrote:
>>>>> Am 23.06.2017 um 12:46 schrieb Andreas Färber <afaerber@suse.de>:
>>>>>> Am 23.06.2017 um 12:25 schrieb H. Nikolaus Schaller:
>>>>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>>>>> b/Documentation/devicetree/bindings/media/i2c/ov965x.txt new file mode
>>>>>>>> 100644
>>>>>>>> index 0000000..0e0de1f
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov965x.txt
>>>>>>>> @@ -0,0 +1,37 @@
>>>>>>>> +* Omnivision OV9650/9652/9655 CMOS sensor
>>>>>>>> +
>>>>>>>> +The Omnivision OV965x sensor support multiple resolutions output, such
>>>>>>>> as
>>>>>>>> +CIF, SVGA, UXGA. It also can support YUV422/420, RGB565/555 or raw RGB
>>>>>>>> +output format.
>>>>>>>> +
>>>>>>>> +Required Properties:
>>>>>>>> +- compatible: should be one of
>>>>>>>> +	"ovti,ov9650"
>>>>>>>> +	"ovti,ov9652"
>>>>>>>> +	"ovti,ov9655"
>>>>>>>> +- clocks: reference to the mclk input clock.
>>>>>>>
>>>>>>> I wonder why you have removed the clock-frequency property?
>>>>>>>
>>>>>>> In some situations the camera driver must be able to tell the clock
>>>>>>> source which frequency it wants to see.
>>>>>>
>>>>>> That's what assigned-clock-rates property is for:
>>>>>>
>>>>>> https://www.kernel.org/doc/Documentation/devicetree/bindings/clock/clock-b
>>>>>> indings.txt
>>>>>>
>>>>>> AFAIU clock-frequency on devices is deprecated and equivalent to having
>>>>>> a clocks property pointing to a fixed-clock, which is different from a
>>>>>> clock with varying rate.
>>>>>
>>>>> I am not sure if that helps here. The OMAP3-ISP does not have a fixed clock
>>>>> rate so we can only have the driver define what it wants to see.
>>>>>
>>>>> And common practise for OMAP3-ISP based camera modules (e.g. N900, N9) is
>>>>> that they do it in the driver.
>>>>>
>>>>> Maybe ISP developers can comment?
>>>>
>>>> The OMAP3 ISP is a variable-frequency clock provider. The clock frequency is 
>>>> controlled by the clock consumer. As such, it's up to the consumer to decide 
>>>> whether to compute and request the clock rate dynamically at runtime, or use 
>>>> the assigned-clock-rates property in DT.
>>>>
>>>> Some ISPs include a clock generator, others don't. It should make no 
>>>> difference whether the clock is provided by the ISP, by a dedicated clock 
>>>> source in the SoC or by a discrete on-board adjustable clock source.
>>>
>>> Thanks for explaining the background.
>>>
>>> Do you have an hint or example how to use the assigned-clock-rates property in
>>> a DT for a camera module connected to the omap3isp?
>>>
>>> Or does it just mean that it defines the property name?
>>
>> Please read the documentation link I sent - it's in the very bottom and
>> should have an example.
> 
> I have seen it but it does not give me a good clue how to translate that into
> correct omap3isp node setup in a specific DT. Rather it raises more questions.
> Maybe because I don't understand completely what it is talking about.
> 
> The fundamental question is if this "assigned-clock-rates" is already
> handled by ov965x->clk = devm_clk_get(&client->dev, NULL); ?
> 
> Or should we define that for the omap3isp node?
> 
> Then of course we need no new code and just use the right property names.
> And N900, N9 camera DTs should be updated.

Look up of_clk_set_defaults() function in drivers/clk/clk-conf.c. This
function gets invoked usually during clock registration, and also gets
called in platform_drv_probe(), so the parents and clocks do get
configured before your driver gets probed. So, this provides a default
configuration if these properties are supplied (in either clock nodes or
actual device nodes), and if your driver needs to change the rates at
runtime, then you would have to do that in the driver itself.

regards
Suman
