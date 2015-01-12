Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:23159 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbALIwl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 03:52:41 -0500
Message-id: <54B38B55.7080503@samsung.com>
Date: Mon, 12 Jan 2015 09:52:37 +0100
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
 <20150109184606.GJ18076@amd>
In-reply-to: <20150109184606.GJ18076@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the review.

On 01/09/2015 07:46 PM, Pavel Machek wrote:
> On Fri 2015-01-09 16:22:58, Jacek Anaszewski wrote:
>> This patch adds led-flash support to Maxim max77693 chipset.
>> A device can be exposed to user space through LED subsystem
>> sysfs interface. Device supports up to two leds which can
>> work in flash and torch mode. The leds can be triggered
>> externally or by software.
>>
>
>> +struct max77693_sub_led {
>> +	/* related FLED output identifier */
>
> ->flash LED, about 4x.
>
>> +/* split composite current @i into two @iout according to @imax weights */
>> +static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
>> +{
>> +	u64 t = i;
>> +
>> +	t *= imax[1];
>> +	do_div(t, imax[0] + imax[1]);
>> +
>> +	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
>> +	iout[0] = i - iout[1];
>> +}
>
> Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
> divisons before t *=, so that 64-bit division is not neccessary?

It is required. All these operations allow for splitting the composite
current into both outputs according to weights given in the imax array.

>> +static int max77693_led_flash_strobe_get(
>> +				struct led_classdev_flash *fled_cdev,
>> +				bool *state)
>> +{
>> +	struct max77693_sub_led *sub_led = flcdev_to_sub_led(fled_cdev);
>> +	struct max77693_led_device *led = sub_led_to_led(sub_led);
>> +	int ret;
>> +
>> +	if (!state)
>> +		return -EINVAL;
>> +
>> +	mutex_lock(&led->lock);
>> +
>> +	ret = max77693_strobe_status_get(led, state);
>> +
>> +	*state = !!(*state && (led->strobing_sub_led_id == sub_led->fled_id));
>> +
>> +
>> +	mutex_unlock(&led->lock);
>> +
>> +	return ret;
>> +}
>
> Maybe remove some empty lines?
>

Of course.

-- 
Best Regards,
Jacek Anaszewski
