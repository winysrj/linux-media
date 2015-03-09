Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:64625 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbCINpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 09:45:34 -0400
Message-id: <54FDA3FA.90900@samsung.com>
Date: Mon, 09 Mar 2015 14:45:30 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl
Subject: Re: [PATCH/RFC v12 10/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-11-git-send-email-j.anaszewski@samsung.com>
 <20150309105404.GC11954@valkosipuli.retiisi.org.uk>
 <54FD8FD4.2010305@samsung.com>
 <20150309123716.GE11954@valkosipuli.retiisi.org.uk>
In-reply-to: <20150309123716.GE11954@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/09/2015 01:37 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Mon, Mar 09, 2015 at 01:19:32PM +0100, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On 03/09/2015 11:54 AM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> On Wed, Mar 04, 2015 at 05:14:31PM +0100, Jacek Anaszewski wrote:
>>>> This patch adds device tree binding documentation for
>>>> the flash cell of the Maxim max77693 multifunctional device.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Lee Jones <lee.jones@linaro.org>
>>>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>>>> Cc: Bryan Wu <cooloney@gmail.com>
>>>> Cc: Richard Purdie <rpurdie@rpsys.net>
>>>> ---
>>>>   Documentation/devicetree/bindings/mfd/max77693.txt |   61 ++++++++++++++++++++
>>>>   1 file changed, 61 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>>>> index 38e6440..ab8fbd5 100644
>>>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>>>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>>>> @@ -76,7 +76,53 @@ Optional properties:
>>>>       Valid values: 4300000, 4700000, 4800000, 4900000
>>>>       Default: 4300000
>>>>
>>>> +- led : the LED submodule device node
>>>> +
>>>> +There are two LED outputs available - FLED1 and FLED2. Each of them can
>>>> +control a separate LED or they can be connected together to double
>>>> +the maximum current for a single connected LED. One LED is represented
>>>> +by one child node.
>>>> +
>>>> +Required properties:
>>>> +- compatible : Must be "maxim,max77693-led".
>>>> +
>>>> +Optional properties:
>>>> +- maxim,trigger-type : Flash trigger type.
>>>> +	Possible trigger types:
>>>> +		LEDS_TRIG_TYPE_EDGE (0) - Rising edge of the signal triggers
>>>> +			the flash,
>>>> +		LEDS_TRIG_TYPE_LEVEL (1) - Strobe pulse length controls duration
>>>> +			of the flash.
>>>> +- maxim,boost-mode :
>>>> +	In boost mode the device can produce up to 1.2A of total current
>>>> +	on both outputs. The maximum current on each output is reduced
>>>> +	to 625mA then. If not enabled explicitly, boost setting defaults to
>>>> +	LEDS_BOOST_FIXED in case both current sources are used.
>>>> +	Possible values:
>>>> +		LEDS_BOOST_OFF (0) - no boost,
>>>> +		LEDS_BOOST_ADAPTIVE (1) - adaptive mode,
>>>> +		LEDS_BOOST_FIXED (2) - fixed mode.
>>>> +- maxim,boost-mvout : Output voltage of the boost module in millivolts.
>>>> +- maxim,mvsys-min : Low input voltage level in millivolts. Flash is not fired
>>>> +	if chip estimates that system voltage could drop below this level due
>>>> +	to flash power consumption.
>>>> +
>>>> +Required properties of the LED child node:
>>>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>>>
>>> According to ePAPR, label is "a human readable string describing a device".
>>> There's no requirement that this would be unique, for instance. If you have
>>> a camera flash LED, there's necessarily no meaningful label for it, as it
>>> doesn't really tell the user anything (vs. HDD activity LED, for instance).
>>>
>>> I think I'd make this optional.
>>
>> OK.
>>
>>> What comes to entity naming in Media controller, the label isn't enough. As
>>> we haven't yet fully agreed on how to name the entities in the future, I'd
>>> propose sticking to current practices: chip name (and optional numerical LED
>>> ID) followed by the I2C address. The name should be specified by the driver.
>>>
>>> Do you have other than I2C busses required by the current drivers?
>>
>> I have AAT1290 device driven through GPIOs. There was also other driver,
>> for a similar device, submitted few days ago to linux-leds list.
>
> The problem indeed is defining a stable and unique identifier for a device
> in a system. In context of your patchset, I think this mostly matters in the
> V4L2 flash API wrapper patch.

It would be good if LED Flash class device name would match V4L2 Flash
sub-device name. LED class devices are assigned names on the basis of
'name' property of struct led-classdev, which is passed to the
device_create_with_groups function. Some LED class drivers use hardcoded
strings for 'name' and other ones use the value of DT 'label' property
as the first choice, if it is available.

> GPIO controlled devices are little bit more troublesome, as GPIO numbers
> alone aren't necessarily stable, but depend on the probing order. Well, i2c
> controllers could also be registered dynamically. The same goes for PCI
> devices, too, for instance.

For LED Flash devices we must also keep in mind that a device is created
per discrete LED component connected to one or more current outputs of 
the flash LED controller. There can be more than one LED Flash class
device created per flash LED controller. This problem seems to be
even harder than the case with more than one device of a kind in the
system, as the devices are controlled with the same hardware interface.

> Most i2c adapters have a static id, and PCI devices have a stable bus
> address (unless system configuration is modified by e.g. adding or removing
> OTHER devices).
>
> I wonder if this could be resolved on OF-based systems by adding a string
> property, say, device name, whenever where are more than one device of a
> kind in the system. The string could just contain a numeric value, say 0 or
> 1.

I can't think of a better solution, especially taking into account the
LED Flash class device case with multiple related
LED Flash class/v4l2-flash devices.

> Cc Hans and Laurent.

-- 
Best Regards,
Jacek Anaszewski
