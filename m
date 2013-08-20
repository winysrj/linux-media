Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33532 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HTPOr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 11:14:47 -0400
Message-id: <521387E4.4090705@samsung.com>
Date: Tue, 20 Aug 2013 17:14:44 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH RFC v5] s5k5baf: add camera sensor driver
References: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
 <5212551F.5020301@samsung.com> <52129C95.4070809@wwwdotorg.org>
 <1532139.bytBLuCBA6@flatron> <5212A2F7.9070100@wwwdotorg.org>
In-reply-to: <5212A2F7.9070100@wwwdotorg.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/2013 12:57 AM, Stephen Warren wrote:
> On 08/19/2013 04:53 PM, Tomasz Figa wrote:
>> On Monday 19 of August 2013 16:30:45 Stephen Warren wrote:
>>> On 08/19/2013 11:25 AM, Sylwester Nawrocki wrote:
>>>> On 08/19/2013 03:25 PM, Pawel Moll wrote:
>>>>> On Mon, 2013-08-19 at 14:18 +0100, Andrzej Hajda wrote:
>>>>>> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>>>>>> @@ -0,0 +1,51 @@
>>>>>> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC
>>>>>> ISP
>>>>>> +-------------------------------------------------------------
>>>>>> +
>>>>>> +Required properties:
>>>>>> +
>>>>>> +- compatible     : "samsung,s5k5baf";
>>>>>> +- reg            : I2C slave address of the sensor;
>>>>>> +- vdda-supply    : analog power supply 2.8V (2.6V to 3.0V);
>>>>>> +- vddreg-supply          : regulator input power supply 1.8V (1.7V
>>>>>> to 1.9V) +                    or 2.8V (2.6V to 3.0);
>>>>>> +- vddio-supply   : I/O power supply 1.8V (1.65V to 1.95V)
>>>>>> +                    or 2.8V (2.5V to 3.1V);
>>>>>> +- gpios                  : GPIOs connected to STDBYN and RSTN pins,
>>>>>> +                    in order: STBYN, RSTN;
>>>>>
>>>>> You probably want to use the "[<name>-]gpios" convention here (see
>>>>> Documentation/devicetree/bindings/gpio/gpio.txt), so something like
>>>>> stbyn-gpios and rstn-gpios.
>>>>
>>>> Unless using multiple named properties is really preferred over a
>>>> single "gpios" property I would like to keep the single property
>>>> containing a list of GPIOs. ...
>>>
>>> Yes, a separate property for each type of GPIO is typical. Multiple
>>> entries in the same property are allowed if they're used for the same
>>> purpose/type, whereas here they're clearly different things.

Yes, that's a good argument. Those GPIOs are pretty unrelated.

>>> Inconsistent with (some) other properties, admittedly...

It might depend on which properties we consider together.

>> I'm not really convinced about the superiority of named gpio properties 
>> over a single gpios property with multiple entries in this case. I'd say 
>> it's more just a matter of preference.
>>
>> See the clock or interrupt bindings. They all specify all the clocks and 
>> interrupts in single property, without any differentiation based on their 
>> purposes. Also keep in mind that original GPIO bindings used only a single 
>> "gpios" property and was only extended to allow named ones.
> 
> Well, it's not so much about what's best, but just being consistent with
> what's already there.

OK, thanks a lot for clarification. We'll rework this to use separate named
properties.

--
Thanks,
Sylwester
