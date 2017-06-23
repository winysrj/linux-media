Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx209.ext.ti.com ([198.47.19.16]:24366 "EHLO
        fllnx209.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752170AbdFWW1a (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Jun 2017 18:27:30 -0400
Subject: Re: [PATCH v1 1/6] DT bindings: add bindings for ov965x camera module
To: "H. Nikolaus Schaller" <hns@goldelico.com>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Mark Rutland <mark.rutland@arm.com>,
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
 <3f0dcd4f-92ef-a79d-b00b-1f348a201bd2@ti.com>
 <74EE8B20-84A2-4579-ACBE-32E55CECE1C5@goldelico.com>
From: Suman Anna <s-anna@ti.com>
Message-ID: <e209912c-7a5c-b219-5b38-9b0b722be936@ti.com>
Date: Fri, 23 Jun 2017 17:24:26 -0500
MIME-Version: 1.0
In-Reply-To: <74EE8B20-84A2-4579-ACBE-32E55CECE1C5@goldelico.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2017 01:59 PM, H. Nikolaus Schaller wrote:
> Hi Suman,
> 
>> Am 23.06.2017 um 20:05 schrieb Suman Anna <s-anna@ti.com>:
>>
>>>>>
>>>>> Or does it just mean that it defines the property name?
>>>>
>>>> Please read the documentation link I sent - it's in the very bottom and
>>>> should have an example.
>>>
>>> I have seen it but it does not give me a good clue how to translate that into
>>> correct omap3isp node setup in a specific DT. Rather it raises more questions.
>>> Maybe because I don't understand completely what it is talking about.
>>>
>>> The fundamental question is if this "assigned-clock-rates" is already
>>> handled by ov965x->clk = devm_clk_get(&client->dev, NULL); ?
>>>
>>> Or should we define that for the omap3isp node?
>>>
>>> Then of course we need no new code and just use the right property names.
>>> And N900, N9 camera DTs should be updated.
>>
>> Look up of_clk_set_defaults() function in drivers/clk/clk-conf.c. This
>> function gets invoked usually during clock registration, and also gets
>> called in platform_drv_probe(), so the parents and clocks do get
>> configured before your driver gets probed. So, this provides a default
>> configuration if these properties are supplied (in either clock nodes or
>> actual device nodes), and if your driver needs to change the rates at
>> runtime, then you would have to do that in the driver itself.
> 
> Ok, now I understand. Thanks!
> 
> Quite hidden, but nice feature. I would never have thought that it exists.
> Especially as there are no examples around omap3isp cameras...
> 
> And an fgrep assigned-clock-rates shows not many use cases outside CPU/SoC
> include files.
> 
> But interestingly arch/arm/boot/dts/at91sam9g25ek.dts uses it for an ovti,ov2640 camera...
> 
> So it seems that we just have to write:
> 
> 	ov9655@30 {
> 		compatible = "ovti,ov9655";
> 		reg = <0x30>;
> 		clocks = <&isp 0>;	/* cam_clka */
> 		assigned-clocks = <&isp 0>;
> 		assigned-clock-rates = <24000000>;
> 	};

Yeah, that looks alright and should work.

regards
Suman

> 
> instead of introducing a new clock-frequency property and code to handle it.
> 
> Or do I misinterpret what "parents" and "clocks" are in this context?
