Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45597 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbALNrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 08:47:03 -0500
Message-id: <54B3D053.4010300@samsung.com>
Date: Mon, 12 Jan 2015 14:46:59 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
	Lee Jones <lee.jones@linaro.org>,
	Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash cell
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
 <20150109184606.GJ18076@amd> <54B38B55.7080503@samsung.com>
 <20150112132521.GA15838@amd>
In-reply-to: <20150112132521.GA15838@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/12/2015 02:25 PM, Pavel Machek wrote:
> Hi!
>
>>>> +struct max77693_sub_led {
>>>> +	/* related FLED output identifier */
>>>
>>> ->flash LED, about 4x.
>>>
>>>> +/* split composite current @i into two @iout according to @imax weights */
>>>> +static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
>>>> +{
>>>> +	u64 t = i;
>>>> +
>>>> +	t *= imax[1];
>>>> +	do_div(t, imax[0] + imax[1]);
>>>> +
>>>> +	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
>>>> +	iout[0] = i - iout[1];
>>>> +}
>>>
>>> Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
>>> divisons before t *=, so that 64-bit division is not neccessary?
>>
>> It is required. All these operations allow for splitting the composite
>> current into both outputs according to weights given in the imax
>> array.
>
> I know.
>
> What about this?
>
> static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
> {
> 	u32 t = i;
>
> 	t *= imax[1] / FLASH_IOUT_STEP;

Let's consider following case:

t = 1000000
imax[1] = 1000000

multiplication of the above will give 10^12 - much more than
it is possible to encode on 32 bits.

> 	t = t / (imax[0] + imax[1]);
> 	t /= FLASH_IOUT_STEP
>
> 	iout[1] = (u32)t;
> 	iout[0] = i - iout[1];
> }
>
> Does it lack precision?
>
> Thanks,
> 									Pavel
>


-- 
Best Regards,
Jacek Anaszewski
