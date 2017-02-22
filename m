Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.60.111]:32991 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932726AbdBVOkK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 22 Feb 2017 09:40:10 -0500
Subject: Re: [PATCH v9 1/2] Add OV5647 device tree documentation
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
References: <cover.1487334912.git.roliveir@synopsys.com>
 <5a93352142495528dd56d5e281a8ed8ad6404a05.1487334912.git.roliveir@synopsys.com>
 <dd33c7bc-e6f7-c234-c3c6-6cc4c7353c68@mentor.com>
 <a2887a9a-0317-eb89-b971-9b238a214459@synopsys.com>
 <cc6c914e-c3e7-7703-0405-104e701610cf@mentor.com>
 <20170221214813.GN16975@valkosipuli.retiisi.org.uk>
 <1b7e2802-dda1-0372-8738-17655dd8ca69@mentor.com>
 <0c251686-6f95-2f54-3d9c-9a97fa8dd947@synopsys.com>
 <eef5a0b8-c757-0af7-b856-8c29cf92134c@mentor.com>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <CARLOS.PALMINHA@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Rob Herring <robh+dt@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <67e7550c-df88-9ed8-8a82-ed79388a5fc0@synopsys.com>
Date: Wed, 22 Feb 2017 14:39:55 +0000
MIME-Version: 1.0
In-Reply-To: <eef5a0b8-c757-0af7-b856-8c29cf92134c@mentor.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir

On 2/22/2017 11:39 AM, Vladimir Zapolskiy wrote:
> Hi Ramiro,
> 
> On 02/22/2017 12:57 PM, Ramiro Oliveira wrote:
>> Hi Vladimir
>>
>> On 2/21/2017 10:37 PM, Vladimir Zapolskiy wrote:
>>> Hi Sakari,
>>>
>>> On 02/21/2017 11:48 PM, Sakari Ailus wrote:
>>>> Hi, Vladimir!
>>>>
>>>> How do you do? :-)
>>>
>>> deferring execution of boring tasks by doing code review :)
>>>
>>>> On Tue, Feb 21, 2017 at 10:48:09PM +0200, Vladimir Zapolskiy wrote:
>>>>> Hi Ramiro,
>>>>>
>>>>> On 02/21/2017 10:13 PM, Ramiro Oliveira wrote:
>>>>>> Hi Vladimir,
>>>>>>
>>>>>> Thank you for your feedback
>>>>>>
>>>>>> On 2/21/2017 3:58 PM, Vladimir Zapolskiy wrote:
>>>>>>> Hi Ramiro,
>>>>>>>
>>>>>>> On 02/17/2017 03:14 PM, Ramiro Oliveira wrote:
>>>>>>>> Create device tree bindings documentation.
>>>>>>>>
>>>>>>>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>>>>>>>> Acked-by: Rob Herring <robh@kernel.org>
>>>>>>>> ---
>>>>>>>>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
>>>>>>>>  1 file changed, 35 insertions(+)
>>>>>>>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
>>>>>>>>
>>>>>>>> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5647.txt b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
>>>>>>>> new file mode 100644
>>>>>>>> index 000000000000..31956426d3b9
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/Documentation/devicetree/bindings/media/i2c/ov5647.txt
>>>>>>>> @@ -0,0 +1,35 @@
>>>>>>>> +Omnivision OV5647 raw image sensor
>>>>>>>> +---------------------------------
>>>>>>>> +
>>>>>>>> +OV5647 is a raw image sensor with MIPI CSI-2 and CCP2 image data interfaces
>>>>>>>> +and CCI (I2C compatible) control bus.
>>>>>>>> +
>>>>>>>> +Required properties:
>>>>>>>> +
>>>>>>>> +- compatible		: "ovti,ov5647".
>>>>>>>> +- reg			: I2C slave address of the sensor.
>>>>>>>> +- clocks		: Reference to the xclk clock.
>>>>>>>
>>>>>>> Is "xclk" clock a pixel clock or something else?
>>>>>>>
>>>>>>
>>>>>> It's an external oscillator.
>>>>>
>>>>> hmm, I suppose a clock of any type could serve as a clock for the sensor.
>>>>> It can be an external oscillator on a particular board, or it can be
>>>>> something else on another board.
>>>>
>>>> Any clock source could be used I presume.
>>>>
>>>
>>> That's exactly my point, and it is a reason to rename "xclk" to something
>>> more generic.
>>>
>>
>> xclk it's the name being used in the camera datasheet, but I can change it to
>> something more generic
>>
> 
> Ah, if the name comes from the sensor datasheet, then it should be okay
> to keep it.
> 
>>>>>
>>>>> Can you please describe what for does ov5647 sensor need this clock, what
>>>>> is its function?
>>>>
>>>> Camera modules (sensors) quite commonly require an external clock as they do
>>>> not have an oscillator on their own. A lot of devices under
>>>> Documentation/devicetree/bindings/media/i2c/ have similar properties.
>>>>
>>>
>>> So, what should be a better replacement of "xclk" in the description above?
>>>
>>> E.g.
>>>
>>> - clocks		: Phandle to a device supply clock.
>>>
>>>>>
>>>>>>
>>>>>>>> +- clock-names		: Should be "xclk".
>>>
>>> We got an agreement that "clock-names" property is removed, nevertheless
>>> if it is added back, is should not be "xclk".
>>>
>>>>>>>
>>>>>>> You can remove this property, because there is only one source clock.
>>>>>>>
>>>>>>
>>>>>> Ok.
>>>>>>
>>>>>>>> +- clock-frequency	: Frequency of the xclk clock.
>>>>>>>
>>>>>>> And after the last updates in the driver this property can be removed as well.
>>>>>>>
>>>>>>
>>>>>> But I'm still using clk_get_rate in the driver, if I remove the frequency here
>>>>>> the probing will fail.
>>>>>>
>>>>>
>>>>> I doubt it, there should be no connection between a custom "clock-frequency"
>>>>> device tree property in a clock consumer device node and clk_get_rate() function
>>>>> from the CCF, which takes a clock provider as its argument.
>>>>
>>>> The purpose is to make sure the clock frequency is really usable for the
>>>> device, in this particular case the driver can work with one particular
>>>> frequency.
>>>>
>>>> That said, the driver does not appear to use the property at the moment. It
>>>> should.
>>>>
>>>> It'd be good to verify that the rate matches: clk_set_rate() is not
>>>> guaranteed to produce the requested clock rate, and the driver could
>>>> conceivably be updated with support for more frequencies. There are
>>>> typically a few frequencies that a SoC such a sensor is connected can
>>>> support, and 25 MHz is not one of the common frequencies. With this
>>>> property, the frequency would be always there explicitly.
>>>>
>>>
>>> I can provide my arguments given at v8 review time again, since I don't
>>> see a contradiction with my older comments.
>>>
>>> Briefly "clock-frequency" as a device tree property on a consumer side
>>> can be considered as redundant, because there is a mechanism to specify
>>> a wanted clock frequency on a clock provider side right in a board DTB.
>>>
>>> So, the clock frequency set up is delegated to CCF, and when any other
>>> than 25 MHz frequencies are got supported, that's only the matter of
>>> driver updates, DTBs won't be touched.
>>>
>>
>> In the driver, I'm using this piece of code to check that the frequency is 25Mhz
>>
>> 	xclk_freq = clk_get_rate(sensor->xclk);
>> 	if (xclk_freq != 25000000) {
>> 		dev_err(dev, "Unsupported clock frequency: %u\n", xclk_freq);
>> 		return -EINVAL;
>> 	}
>>
>> So if I don't define it here the probing will fail. Do you have another
>> suggestion for this?
>>
> 
> I don't completely understand, why does it fail? "clock-frequency" property
> is not a standard device node property on a clock consumer side, so, if we're
> still talking about v9 version of the driver, adding the property or removing
> it should have no effect.
> 
> Let's consider the simplest possible situation, when "xclk" is actually
> a fixed rate 25MHz oscillator (the clock device node is "fixed-clock"
> compatible), for such a clock clk_get_rate() returns 25MHz rate, the assert
> has to be passed. In case of a more complex scenario please reference to
> clock-bindings.txt documentation, in particular please take a look at
> "assigned-clocks" and "assigned-clock-rates" properties.
> 

You're right, I was forgetting about the frequency being defined in the fixed
clock declaration. I'll remove clock-frequency from the example.

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
