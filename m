Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:34452 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3HWJXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:23:35 -0400
Message-id: <52172A13.1080701@samsung.com>
Date: Fri, 23 Aug 2013 11:23:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com,
	linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ian.campbell@citrix.com>,
	Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v7] s5k5baf: add camera sensor driver
References: <1377096091-7284-1-git-send-email-a.hajda@samsung.com>
 <9243520.EzMBhpL3jX@flatron>
In-reply-to: <9243520.EzMBhpL3jX@flatron>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2013 12:39 AM, Tomasz Figa wrote:
>> Documentation/devicetree/bindings/media/samsung-s5k5baf.txt create mode
>> > 100644 drivers/media/i2c/s5k5baf.c
>> > 
>> > diff --git a/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> > b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt new file
>> > mode 100644
>> > index 0000000..d680d99
>> > --- /dev/null
>> > +++ b/Documentation/devicetree/bindings/media/samsung-s5k5baf.txt
>> > @@ -0,0 +1,59 @@
>> > +Samsung S5K5BAF UXGA 1/5" 2M CMOS Image Sensor with embedded SoC ISP
>> > +--------------------------------------------------------------------
>> > +
>> > +Required properties:
>> > +
>> > +- compatible	  : "samsung,s5k5baf";
>> > +- reg		  : I2C slave address of the sensor;
>
> Can this sensor have an aribitrary slave address or only a set of well 
> known possible addresses (e.g. listed in documentation)?

According to the datasheet it can have one of two I2C addresses (0x2D, 0x3C),
selectable by a dedicated pin. Also they may be revisions of the device that
use different addresses. I believe what addresses are possible is out of
scope of this binding document. We can handle whatever is used.

>> > +- vdda-supply	  : analog power supply 2.8V (2.6V to 3.0V);
>> > +- vddreg-supply	  : regulator input power supply 1.8V (1.7V to 
> 1.9V)
>> > +		    or 2.8V (2.6V to 3.0);
>> > +- vddio-supply	  : I/O power supply 1.8V (1.65V to 1.95V)
>> > +		    or 2.8V (2.5V to 3.1V);
>> > +- stbyn-gpios	  : GPIO connected to STDBYN pin;
>> > +- rstn-gpios	  : GPIO connected to RSTN pin;
>
> Both GPIOs above have names suggesting that they are active low. I wonder 
> how the GPIO flags cell is interpreted here, namely the polarity bit.

That's a good point. The GPIO flags are be used to specify active state
of the GPIO. Some sensors happen to use different active state for those
signals. It's not the case for this sensor though AFAICT.

Anyway IMO it would be better to name those gpios: "stby-gpios",
"rst-gpios" in case there appear revisions that have their pin named STDBY
or RST rather than STDBYN, RSTN. That seems rather unlikely though, but
since there are devices to which that could apply I think for consistency
it might be better to remove indication of polarity from the GPIO names.


