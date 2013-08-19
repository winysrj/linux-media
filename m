Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58911 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab3HSRZy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 13:25:54 -0400
Message-id: <5212551F.5020301@samsung.com>
Date: Mon, 19 Aug 2013 19:25:51 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"rob.herring@calxeda.com" <rob.herring@calxeda.com>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	"grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH RFC v5] s5k5baf: add camera sensor driver
References: <1376918307-21490-1-git-send-email-a.hajda@samsung.com>
 <1376918739.3157.9.camel@hornet>
In-reply-to: <1376918739.3157.9.camel@hornet>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2013 03:25 PM, Pawel Moll wrote:
> On Mon, 2013-08-19 at 14:18 +0100, Andrzej Hajda wrote:
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
> 
> You probably want to use the "[<name>-]gpios" convention here (see
> Documentation/devicetree/bindings/gpio/gpio.txt), so something like
> stbyn-gpios and rstn-gpios.

Unless using multiple named properties is really preferred over a single
"gpios" property I would like to keep the single property containing
a list of GPIOs. Each list entry has clearly defined meaning and it
seems simpler to me to reference the GPIOs by index, rather than by name.
This also saves a few bytes in dtb and there is no need to store the list
of names in the driver.

Thanks,
Sylwester
