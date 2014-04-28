Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52331 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbaD1LZN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Apr 2014 07:25:13 -0400
Message-id: <535E3A95.6010206@samsung.com>
Date: Mon, 28 Apr 2014 13:25:09 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	s.nawrocki@samsung.com, a.hajda@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC v3 5/5] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1397228216-6657-1-git-send-email-j.anaszewski@samsung.com>
 <1397228216-6657-6-git-send-email-j.anaszewski@samsung.com>
 <20140416182141.GG8753@valkosipuli.retiisi.org.uk>
 <534F9044.6080508@samsung.com>
 <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
In-reply-to: <20140423152435.GJ8753@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 04/23/2014 05:24 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Thu, Apr 17, 2014 at 10:26:44AM +0200, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> Thanks for the review.
>>
>> On 04/16/2014 08:21 PM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> Thanks for the update!
>>>
>> [...]
>>>> +static inline enum led_brightness v4l2_flash_intensity_to_led_brightness(
>>>> +					struct led_ctrl *config,
>>>> +					u32 intensity)
>>>
>>> Fits on a single line.
>>>
>>>> +{
>>>> +	return intensity / config->step;
>>>
>>> Shouldn't you first decrement the minimum before the division?
>>
>> Brightness level 0 means that led is off. Let's consider following case:
>>
>> intensity - 15625
>> config->step - 15625
>> intensity / config->step = 1 (the lowest possible current level)
>
> In V4L2 controls the minimum is not off, and zero might not be a possible
> value since minimum isn't divisible by step.
>
> I wonder how to best take that into account.

I've assumed that in MODE_TORCH a led is always on. Switching
the mode to MODE_FLASH or MODE_OFF turns the led off.
This way we avoid the problem with converting 0 uA value to
led_brightness, as available torch brightness levels start from
the minimum current level value and turning the led off is
accomplished on transition to MODE_OFF or MODE_FLASH, by
calling brightness_set op with led_brightness = 0.

[...]

>>>> +/*
>>>> + * V4L2 subdev internal operations
>>>> + */
>>>> +
>>>> +static int v4l2_flash_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>>>> +{
>>>> +	struct v4l2_flash *v4l2_flash = v4l2_subdev_to_v4l2_flash(sd);
>>>> +	struct led_classdev *led_cdev = v4l2_flash->led_cdev;
>>>> +
>>>> +	mutex_lock(&led_cdev->led_lock);
>>>> +	v4l2_call_flash_op(sysfs_lock, led_cdev);
>>>
>>> Have you thought about device power management yet?
>>
>> Having in mind that the V4L2 Flash sub-device is only a wrapper
>> for LED driver, shouldn't power management be left to the
>> drivers?
>
> How does the LED controller driver know it needs to power the device up in
> that case?
>
> I think an s_power() op which uses PM runtime to set the power state until
> V4L2 sub-device switches to it should be enough. But I'm fine leaving it out
> from this patchset.
>

This solution looks reasonable.

Regards,
Jacek Anaszewski


