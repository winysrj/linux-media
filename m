Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56849 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3HSVDt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 17:03:49 -0400
Message-ID: <5212882F.6020702@gmail.com>
Date: Mon, 19 Aug 2013 23:03:43 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Andrzej Hajda <a.hajda@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH RFC v5] s5k5baf: add camera sensor driver
References: <1376918307-21490-1-git-send-email-a.hajda@samsung.com> <20130819133907.GN3719@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130819133907.GN3719@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 03:39 PM, Mark Rutland wrote:
> On Mon, Aug 19, 2013 at 02:18:27PM +0100, Andrzej Hajda wrote:
>> Driver for Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor
>> with embedded SoC ISP.
>> The driver exposes the sensor as two V4L2 subdevices:
>> - S5K5BAF-CIS - pure CMOS Image Sensor, fixed 1600x1200 format,
>>    no controls.
>> - S5K5BAF-ISP - Image Signal Processor, formats up to 1600x1200,
>>    pre/post ISP cropping, downscaling via selection API, controls.
>>
>> Signed-off-by: Sylwester Nawrocki<s.nawrocki@samsung.com>
>> Signed-off-by: Andrzej Hajda<a.hajda@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>> ---
>> v5
>> - removed non-standard samsung hflip/vflip device tree bindings
>>
>> v4
>> - GPL changed to GPLv2,
>> - bitfields replaced by u8,
>> - cosmetic changes,
>> - corrected s_stream flow,
>> - gpio pins are no longer exported,
>> - added I2C addresses to subdev names,
>> - CIS subdev registration postponed after
>>    succesfull HW initialization,
>> - added enums for pads,
>> - selections are initialized only during probe,
>> - default resolution changed to 1600x1200,
>> - state->error pattern removed from few other functions,
>> - entity link creation moved to registered callback.
[...]
>> ---
>>   .../devicetree/bindings/media/samsung-s5k5baf.txt  |   51 +
>>   MAINTAINERS                                        |    7 +
>>   drivers/media/i2c/Kconfig                          |    7 +
>>   drivers/media/i2c/Makefile                         |    1 +
>>   drivers/media/i2c/s5k5baf.c                        | 1980 ++++++++++++++++++++
>>   5 files changed, 2046 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>>   create mode 100644 drivers/media/i2c/s5k5baf.c
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> new file mode 100644
>> index 0000000..b1f2fde
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> @@ -0,0 +1,51 @@
>> +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
>> +-------------------------------------------------------------
>> +
>> +Required properties:
>> +
>> +- compatible     : "samsung,s5k5baf";
>> +- reg            : I2C slave address of the sensor;
>> +- vdda-supply    : analog power supply 2.8V (2.6V to 3.0V);
>> +- vddreg-supply          : regulator input power supply 1.8V (1.7V to 1.9V)
>> +                    or 2.8V (2.6V to 3.0);
>> +- vddio-supply   : I/O power supply 1.8V (1.65V to 1.95V)
>> +                    or 2.8V (2.5V to 3.1V);
>> +- gpios                  : GPIOs connected to STDBYN and RSTN pins,
>> +                    in order: STBYN, RSTN;
>> +- clock-frequency : master clock frequency in Hz;
>
> Why is this necessary? Could you not just require having a clocks
> property? You could then get equivalent functionality to the
> clock-frequency property by having a fixed-clock node if you don't ahve
> a real clock specifier to wire up.

Oops, looks like we didn't consolidate all the changes that were present in
v4 [1]. clock, clock-names should be required properties and 
clock-frequency
should be optional.

Yes, fixed clock could be used when, e.g. the sensor feeds its master clock
from a separate external oscillator.

The clock-frequency property is there to _set_ a board specific master 
clock
frequency of the sensor at the driver. I hope it doesn't fall into category
"doesn't describe hardware", because the optimal frequency often needs to be
specified per board and some common denominator value or range might not
work well, leading to video signal distortions, etc.

>> +
>> +Optional properties:
>> +
>> +- clocks         : contains the sensor's master clock specifier;
>> +- clock-names    : contains "mclk" entry;
>> +
>> +The device node should contain one 'port' child node with one child 'endpoint'
>> +node, according to the bindings defined in Documentation/devicetree/bindings/
>> +media/video-interfaces.txt. The following are properties specific to those nodes.
>> +
>> +endpoint node
>> +-------------
>> +
>> +- data-lanes     : (optional) an array specifying active physical MIPI-CSI2
>> +                   data output lanes and their mapping to logical lanes; the
>> +                   array's content is unused, only its length is meaningful;
>
> Is that a property of the driver, or does the design of the hardware
> mean that this can never encode useful information?

This sensor doesn't support the data lanes re-routing at the MIPI CSI-2
transmitter [2]. The data/clock lanes just appear on fixed physical pins,
thus there is nothing that could be done with data in the array. The number
of entries determines how many lanes are wired between the transmitter and
the receiver and this is configurable for that particular device in range
<1, 2> - it can transmit data on either 1 or 2 lanes.

Presumably an important detail missing here is that this is the common
property from video-interfaces.txt and what we mention here is only some
device-specific constraints.

> What does the length of the property imply?

The description of this property should really be as in v4 of the patch:

"- data-lanes : (optional) specifies MIPI CSI-2 data lanes as covered in
   video-interfaces.txt.  This property can be only used to specify number
   of data lanes, i.e. the array's content is unused, only its length is
   meaningful.  When this property is not specified default value of 1 lane
   will be used."


[1] http://www.spinics.net/lists/linux-media/msg66152.html
[2] http://www.mipi.org/specifications/camera-interface#CSI2

--
Thanks,
Sylwester
