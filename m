Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:62326 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbbCIMTg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Mar 2015 08:19:36 -0400
Message-id: <54FD8FD4.2010305@samsung.com>
Date: Mon, 09 Mar 2015 13:19:32 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
	rpurdie@rpsys.net, s.nawrocki@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v12 10/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1425485680-8417-1-git-send-email-j.anaszewski@samsung.com>
 <1425485680-8417-11-git-send-email-j.anaszewski@samsung.com>
 <20150309105404.GC11954@valkosipuli.retiisi.org.uk>
In-reply-to: <20150309105404.GC11954@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.

On 03/09/2015 11:54 AM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Wed, Mar 04, 2015 at 05:14:31PM +0100, Jacek Anaszewski wrote:
>> This patch adds device tree binding documentation for
>> the flash cell of the Maxim max77693 multifunctional device.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Lee Jones <lee.jones@linaro.org>
>> Cc: Chanwoo Choi <cw00.choi@samsung.com>
>> Cc: Bryan Wu <cooloney@gmail.com>
>> Cc: Richard Purdie <rpurdie@rpsys.net>
>> ---
>>   Documentation/devicetree/bindings/mfd/max77693.txt |   61 ++++++++++++++++++++
>>   1 file changed, 61 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/mfd/max77693.txt b/Documentation/devicetree/bindings/mfd/max77693.txt
>> index 38e6440..ab8fbd5 100644
>> --- a/Documentation/devicetree/bindings/mfd/max77693.txt
>> +++ b/Documentation/devicetree/bindings/mfd/max77693.txt
>> @@ -76,7 +76,53 @@ Optional properties:
>>       Valid values: 4300000, 4700000, 4800000, 4900000
>>       Default: 4300000
>>
>> +- led : the LED submodule device node
>> +
>> +There are two LED outputs available - FLED1 and FLED2. Each of them can
>> +control a separate LED or they can be connected together to double
>> +the maximum current for a single connected LED. One LED is represented
>> +by one child node.
>> +
>> +Required properties:
>> +- compatible : Must be "maxim,max77693-led".
>> +
>> +Optional properties:
>> +- maxim,trigger-type : Flash trigger type.
>> +	Possible trigger types:
>> +		LEDS_TRIG_TYPE_EDGE (0) - Rising edge of the signal triggers
>> +			the flash,
>> +		LEDS_TRIG_TYPE_LEVEL (1) - Strobe pulse length controls duration
>> +			of the flash.
>> +- maxim,boost-mode :
>> +	In boost mode the device can produce up to 1.2A of total current
>> +	on both outputs. The maximum current on each output is reduced
>> +	to 625mA then. If not enabled explicitly, boost setting defaults to
>> +	LEDS_BOOST_FIXED in case both current sources are used.
>> +	Possible values:
>> +		LEDS_BOOST_OFF (0) - no boost,
>> +		LEDS_BOOST_ADAPTIVE (1) - adaptive mode,
>> +		LEDS_BOOST_FIXED (2) - fixed mode.
>> +- maxim,boost-mvout : Output voltage of the boost module in millivolts.
>> +- maxim,mvsys-min : Low input voltage level in millivolts. Flash is not fired
>> +	if chip estimates that system voltage could drop below this level due
>> +	to flash power consumption.
>> +
>> +Required properties of the LED child node:
>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>
> According to ePAPR, label is "a human readable string describing a device".
> There's no requirement that this would be unique, for instance. If you have
> a camera flash LED, there's necessarily no meaningful label for it, as it
> doesn't really tell the user anything (vs. HDD activity LED, for instance).
>
> I think I'd make this optional.

OK.

> What comes to entity naming in Media controller, the label isn't enough. As
> we haven't yet fully agreed on how to name the entities in the future, I'd
> propose sticking to current practices: chip name (and optional numerical LED
> ID) followed by the I2C address. The name should be specified by the driver.
>
> Do you have other than I2C busses required by the current drivers?

I have AAT1290 device driven through GPIOs. There was also other driver,
for a similar device, submitted few days ago to linux-leds list.

>> +- led-sources : see Documentation/devicetree/bindings/leds/common.txt;
>> +		device current output identifiers: 0 - FLED1, 1 - FLED2
>> +
>> +Optional properties of the LED child node:
>> +- max-microamp : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 15625 - 250000
>> +- flash-max-microamp : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 15625 - 1000000
>> +- flash-timeout-us : see Documentation/devicetree/bindings/leds/common.txt
>> +		Range: 62500 - 1000000
>> +
>>   Example:
>> +#include <dt-bindings/leds/max77693.h>
>> +
>>   	max77693@66 {
>>   		compatible = "maxim,max77693";
>>   		reg = <0x66>;
>> @@ -117,5 +163,20 @@ Example:
>>   			maxim,thermal-regulation-celsius = <75>;
>>   			maxim,battery-overcurrent-microamp = <3000000>;
>>   			maxim,charge-input-threshold-microvolt = <4300000>;
>> +
>> +		led {
>> +			compatible = "maxim,max77693-led";
>> +			maxim,trigger-type = <LEDS_TRIG_TYPE_LEVEL>;
>> +			maxim,boost-mode = <LEDS_BOOST_FIXED>;
>> +			maxim,boost-mvout = <5000>;
>> +			maxim,mvsys-min = <2400>;
>> +
>> +			camera_flash: flash-led {
>> +				label = "max77693-flash1";
>> +				led-sources = <0>, <1>;
>> +				max-microamp = <500000>;
>> +				flash-max-microamp = <1250000>;
>> +				flash-timeout-us = <1000000>;
>> +			};
>>   		};
>>   	};
>


-- 
Best Regards,
Jacek Anaszewski
