Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:9019 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111AbaLHK3Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 05:29:24 -0500
Message-id: <54857D7B.8050304@samsung.com>
Date: Mon, 08 Dec 2014 11:29:15 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-leds@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, s.nawrocki@samsung.com,
	robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
	ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com> <20141204161201.GB29080@amd>
In-reply-to: <20141204161201.GB29080@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On 12/04/2014 05:12 PM, Pavel Machek wrote:
> Hi!
>
>>>> +- maxim,boost-mode :
>>>> +	In boost mode the device can produce up to 1.2A of total current
>>>> +	on both outputs. The maximum current on each output is reduced
>>>> +	to 625mA then. If there are two child led nodes defined then boost
>>>> +	is enabled by default.
>>>> +	Possible values:
>>>> +		MAX77693_LED_BOOST_OFF - no boost,
>>>> +		MAX77693_LED_BOOST_ADAPTIVE - adaptive mode,
>>>> +		MAX77693_LED_BOOST_FIXED - fixed mode.
>>>> +- maxim,boost-vout : Output voltage of the boost module in millivolts.
>>>> +- maxim,vsys-min : Low input voltage level in millivolts. Flash is not fired
>>>> +	if chip estimates that system voltage could drop below this level due
>>>> +	to flash power consumption.
>>>> +
>>>> +Required properties of the LED child node:
>>>> +- label : see Documentation/devicetree/bindings/leds/common.txt
>>>> +- maxim,fled_id : Identifier of the fled output the led is connected to;
>>>
>>> I'm pretty sure this will be needed for about every chip that can drive
>>> multiple LEDs. Shouldn't it be documented in the generic documentation?
>>
>> OK.
>
> Well... "fled_id" is not exactly suitable name. On other busses, it
> would be "reg = <1>"?

I'm ok with "reg". This scheme is used for pca963x.txt and is described
as "number of LED line". We could define it similarly in the common.txt.
A device would have to specify the range of allowed values though.
I would add such a note to the generic binding.

Regards,
Jacek
