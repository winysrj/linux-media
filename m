Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:27420 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3HWJs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 05:48:27 -0400
Message-id: <52172FE7.8040506@samsung.com>
Date: Fri, 23 Aug 2013 11:48:23 +0200
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
 <9243520.EzMBhpL3jX@flatron> <52172A13.1080701@samsung.com>
In-reply-to: <52172A13.1080701@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2013 11:23 AM, Sylwester Nawrocki wrote:
>>>> +- stbyn-gpios	  : GPIO connected to STDBYN pin;
>>>> >> > +- rstn-gpios	  : GPIO connected to RSTN pin;
>> >
>> > Both GPIOs above have names suggesting that they are active low. I wonder 
>> > how the GPIO flags cell is interpreted here, namely the polarity bit.

To be more clear, the polarity bit specifies GPIO state at the GPIO controller
(SoC) that corresponds to active STANDBY or RESET signal state at the sensor.
So it is supposed to cover any inverter in between the sensor and an SoC.

> That's a good point. The GPIO flags are be used to specify active state
> of the GPIO. Some sensors happen to use different active state for those
> signals. It's not the case for this sensor though AFAICT.
> 
> Anyway IMO it would be better to name those gpios: "stby-gpios",
> "rst-gpios" in case there appear revisions that have their pin named STDBY
> or RST rather than STDBYN, RSTN. That seems rather unlikely though, but
> since there are devices to which that could apply I think for consistency
> it might be better to remove indication of polarity from the GPIO names.



-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
