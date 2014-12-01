Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55359 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbaLANn4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 08:43:56 -0500
Message-id: <547C7097.4040907@samsung.com>
Date: Mon, 01 Dec 2014 14:43:51 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
	b.zolnierkie@samsung.com, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	SangYoung Son <hello.son@smasung.com>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v8 11/14] DT: Add documentation for the mfd Maxim
 max77693
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-12-git-send-email-j.anaszewski@samsung.com>
 <20141129192607.GB17355@amd> <547C65F7.4090801@samsung.com>
 <20141201130231.GA24737@amd>
In-reply-to: <20141201130231.GA24737@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On 12/01/2014 02:02 PM, Pavel Machek wrote:
> Hi!
>
>>> Is this one needed? Just ommit child note if it is not there.
>>
>> It is needed because you can have one led connected two both
>> outputs. This allows to describe such a design.
>
> Ok.
>
>>>> +- maxim,trigger-type : Array of trigger types in order: flash, torch
>>>> +	Possible trigger types:
>>>> +		0 - Rising edge of the signal triggers the flash/torch,
>>>> +		1 - Signal level controls duration of the flash/torch.
>>>> +- maxim,trigger : Array of flags indicating which trigger can activate given led
>>>> +	in order: fled1, fled2
>>>> +	Possible flag values (can be combined):
>>>> +		1 - FLASH pin of the chip,
>>>> +		2 - TORCH pin of the chip,
>>>> +		4 - software via I2C command.
>>>
>>> Is it good idea to have bitfields like this?
>>>
>>> Make these required properties of the subnode?
>>
>> This is related to a single property: trigger. I think that splitting
>> it to three properties would make unnecessary noise in the
>> binding.
>
> Well, maybe it is not that much noise, and you'll have useful names
> (not a bitfield).

I think we'd need an opinion of at least one more person :)

> Should these properties move to the LED subnode?

I would leave them device specific.

Regards,
Jacek
