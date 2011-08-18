Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55393 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab1HRU7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Aug 2011 16:59:43 -0400
Received: by eyx24 with SMTP id 24so1441359eyx.19
        for <linux-media@vger.kernel.org>; Thu, 18 Aug 2011 13:59:41 -0700 (PDT)
Message-ID: <4E4D7D3A.4040708@gmail.com>
Date: Thu, 18 Aug 2011 22:59:38 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
References: <20110818092158.GA8872@valkosipuli.localdomain>	 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>	 <1313667122.25065.8.camel@smile>	 <20110818115131.GD8872@valkosipuli.localdomain> <1313674341.25065.17.camel@smile> <4E4D4840.7050207@gmail.com> <4E4D61CD.40405@iki.fi>
In-Reply-To: <4E4D61CD.40405@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2011 09:02 PM, Sakari Ailus wrote:
>>>>>
>>>>> He-h, I guess you are not going to apply this one.
>>>>> The patch breaks init logic of the device. If we have no ->power(), we
>>>>> still need to bring the device to the known state. I have no good idea
>>>>> how to do this.
>>>>
>>>> I don't think it breaks anything actually. Albeit in practice one is still
>>>> likely to put the adp1653 reset line to the board since that lowers its power
>>>> consumption significantly.
>>> Yeah, even in practice we might see various ways of a chip connection.
>>>
>>>> Instead of being in power-up state after opening the flash subdev, it will
>>>> reach this state already when the system is powered up. At subdev open all
>>>> the relevant registers are written to anyway, so I don't see an issue here.
>>> You mean at first writing to the V4L2 value, do you? Because ->open()
>>> uses set_power() which will be skipped in case of no ->power method
>>> defined.
>>>
>>>> I think either this one, or one should check in probe() that the power()
>>>> callback is non-NULL.
>>>> The board code is going away in the near future so this callback will
>>>> disappear eventually anyway.
>>> So, it's up to you to include or not my last patch.
>>>
>>>> The gpio code in the board file should likely
>>>> be moved to the driver itself.
>>> The line could be different, the hw could be used in environment w/o
>>> gpio, but with (for example) external gate, and so on. I think current
>>> generic driver is pretty okay.
>>
>> Would it make sense to use the regulator API in place of the platform_data
>> callback? If there is only one GPIO then it's easy to create a 'fixed voltage
>> regulator' for this.
> 
> I don't know the regulator framework very well, but do you mean creating a new
> regulator which just controls a gpio? It would be preferable that this wouldn't
> create a new driver nor add any board core.

I'm afraid your requirements are too demanding :)
Yes, I meant creating a new regulator. In case the ADP1635 voltage regulator
is inhibited through a GPIO at a host processor such regulator would in fact
be only flipping a GPIO (and its driver would request the GPIO and set it into
a default inactive state during its initialization). But the LDO for ADP1635
could be also a part of larger PMIC device, which are often configured through
I2C and have their generic drivers (in drivers/regulator). So the regulator API
in some extent abstracts the power supply details. There is a common API at the
client driver side regardless of the details how the power is actually enabled/
disabled.

I've seen some patches for the device tree bindings for the regulator API
but I guess this is not in the mainline yet.

Currently the 'fixed voltage regulator' is instantiated by creating a platform 
device, with an appropriate 'id', in the board code. And you have to create... 
a platform data for it :) The driver is common for all such devices
(drivers/regulator/fixed.c). 

> 
>> Does the 'platform_data->power' callback control power supply on pin 14 (VDD)
>> or does it do something else?
> 
> No. The chip is always powered on the N900 but pulling down (or up, I don't remember)
> its reset pin puts the chip to reset and causes the current draw to reach almost zero.
> I think it's in the class of some or few tens of µA. Someone still might implement

According to the datasheet it's even less, below 1 uA :)

"Shutdown Current (EN = GND, TJ = −40°C to +85°C) = 0.1μA (Typ.), 1μA (Max)"

So the reset (EN) pin is basically a GPIO, but it could be as well some signal
provided by a glue FPGA, driven by a memory mapped register(s).
Then the callback is most flexible, but it's a little bit ugly at the same time:)
If I were you I, would probably originally put a GPIO number in platform_data,
instead of a function callback. But that depends on priorities.

> a board containing the adp1653 which would require enabling a regulator for it.
 
Indeed, I guess there is no point in adding support for the power supply control
over the regulator API now. When someone needs it on some other board, it can
be added in the driver then.

--
Regards,
Sylwester
