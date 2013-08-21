Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60989 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab3HUJNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 05:13:37 -0400
Message-id: <521484BD.1070005@samsung.com>
Date: Wed, 21 Aug 2013 11:13:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
	Arun Kumar K <arun.kk@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	devicetree@vger.kernel.org, swarren@wwwdotorg.org,
	mark.rutland@arm.com, Pawel.Moll@arm.com, galak@codeaurora.org,
	a.hajda@samsung.com, sachin.kamat@linaro.org,
	shaik.ameer@samsung.com, kilyeon.im@samsung.com,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH v7 13/13] V4L: Add driver for s5k4e5 image sensor
References: <1377066881-5423-1-git-send-email-arun.kk@samsung.com>
 <52146403.9050702@xs4all.nl> <4486068.1NMnLxuSKb@flatron>
 <201308211024.58303.hverkuil@xs4all.nl>
In-reply-to: <201308211024.58303.hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/21/2013 10:24 AM, Hans Verkuil wrote:
>>>> +static const char * const s5k4e5_supply_names[] = {
>>>> +	"svdda",
>>>> +	"svddio"
>>>> +};
>>>
>>> I'm no regulator expert, but shouldn't this list come from the DT or
>>> platform_data? Or are these names specific to this sensor?
>>
>> This is a list of regulator input (aka supply) names. In other words those 
>> are usually names of pins of the consumer device (s5k4e5 chip in this 
>> case) to which the regulators are connected. They are used as lookup keys 
>> when looking up regulators, either from device tree or lookup tables.
> 
> How does that work if you have two of these sensors? E.g. in a stereo-camera?
> Can the regulator subsystem map those pins to the correct regulators?
> 
> Again, sorry for my ignorance in this area as I've never used it. I just
> want to make sure this information is stored in the right place.

The _voltage regulator supply names_ are fixed but _voltage regulator_
is matched with a consumer device based on the supply name and name of
the consumer device. See usage of struct regulator_consumer_supply, e.g.
in arch/arm/mach-s5pv210/mach-goni.c board file. This is an example of
non-dt system, and something that would presumably be created by a driver
like em28xx if it wanted to use that sensor. I.e. em28xx would first
need to create a voltage regulator device and then pass in a
struct regulator_init_data the list of voltage supply definitions for
the consumers to be able to use this regulator.


In case of device tree the voltage supplies are specified in 
a DT node, which can be referenced by subsystems/drivers through 
struct device::of_node.

	reg_a: voltage-regulator-a {
		compatible = "regulator-fixed";
		regulator-name = "REG_5V_A";
		regulator-min-microvolt = <5000000>;
		regulator-max-microvolt = <5000000>;
		gpio = <...>;
		...
	};

	reg_b: voltage-regulator-b {
		compatible = "regulator-fixed";
		regulator-name = "REG_3.3V_B";
		regulator-min-microvolt = <3300000>;
		regulator-max-microvolt = <3300000>;
		gpio = <...>;
		...
	};

	s5k4e5@20 {
		compatible = "samsung,s5k4e5";
		reg = <0x20>;
		...
		svdda-supply = <&reg_a>;
		svddio-supply = <&reg_b>;
		...
	};

The regulator supply names are part of name of the property defining
a voltage regulator for a device. Properties in form of 
[supply_name]-supply are parsed by the regulator core when consumer
device driver calls regulator_get(). This way drivers don't need to
care whether the system is booted from Device Tree or not. They just
keep using the regulator API and the regulator supply lookup is done
the the core based on data in a board file or in device tree blob.

This is similar to the clock API operation, except that clkdev entries 
are usually defined per SOC/MCU rather than per board.

I hope it helps. I looked yesterday at the em28xx driver. Do you happen
to know if there is a schematic for one of devices this driver supports ?
Sorry, I didn't dig to hard yet.
At first sight I thought it may look a bit problematic and require 
significant amount of code to define regulators for the all supported 
sensors by this driver, should it be made to work with sensors that 
are currently known to be used only in embedded systems and use the 
regulators API. However it should be as simple as defining at least one 
regulator device and attaching regulator supply list definition for all 
supported sensors. Thus not that scary at all. And the subdev drivers 
can continue to use regulator API, without a need for any hacks making 
it optional through e.g. platform_data flag. And IMO if the regulator 
API is disabled currently by some x86 distros it should be enabled,
as long as some drivers need it.

--
Regards,
Sylwester
