Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29849 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbALJqa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Jan 2015 04:46:30 -0500
Message-id: <54B397F2.6060205@samsung.com>
Date: Mon, 12 Jan 2015 10:46:26 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH/RFC v10 15/19] media: Add registration helpers for V4L2
 flash sub-devices
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-16-git-send-email-j.anaszewski@samsung.com>
 <20150109205432.GP18076@amd>
In-reply-to: <20150109205432.GP18076@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

Thanks for the review.

On 01/09/2015 09:54 PM, Pavel Machek wrote:
> On Fri 2015-01-09 16:23:05, Jacek Anaszewski wrote:
>> This patch adds helper functions for registering/unregistering
>> LED Flash class devices as V4L2 sub-devices. The functions should
>> be called from the LED subsystem device driver. In case the
>> support for V4L2 Flash sub-devices is disabled in the kernel
>> config the functions' empty versions will be used.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>
> Acked-by: Pavel Machek <pavel@ucw.cz>
>
>> +	/*
>> +	 * Indicator leds, unlike torch leds, are turned on/off basing
>> on
>
> leds -> LEDs.

Sure.

>> +	 * the state of V4L2_CID_FLASH_INDICATOR_INTENSITY control only.
>> +	 * Therefore it must be possible to set it to 0 level which in
>> +	 * the LED subsystem reflects LED_OFF state.
>> +	 */
>> +	if (cdata_id != INDICATOR_INTENSITY)
>> +		++__intensity;
>
> And normally we'd do i++ instead of ++i, and avoid __ for local
> variables...?

Pre-incrementation operator is favourable over the post-incrementation
one if we don't want to have an access to the value of a variable before
incrementation, which is the case here.
Maybe gcc detects the cases when the value of a variable is not assigned
and doesn't copy it before incrementing, however I haven't found any
reference. I see that often in the for loops the i++ version
is used, but I am not sure if this is done because developers are
aware that gcc will optimize it anyway or it is just an omission.

And regarding __ for local variable - I haven't found any restriction
about it in the Documentation/CodingStyle. Nevertheless I can rename
it to tmp or something.

>> +/**
>> + * struct v4l2_flash_ctrl_config - V4L2 Flash controls initialization data
>> + * @intensity:			constraints for the led in a non-flash mode
>> + * @flash_intensity:		V4L2_CID_FLASH_INTENSITY settings constraints
>> + * @flash_timeout:		V4L2_CID_FLASH_TIMEOUT constraints
>> + * @flash_faults:		possible flash faults
>> + * @has_external_strobe:	external strobe capability
>> + * @indicator_led:		signifies that a led is of indicator type
>> + */
>> +struct v4l2_flash_ctrl_config {
>> +	struct v4l2_ctrl_config intensity;
>> +	struct v4l2_ctrl_config flash_intensity;
>> +	struct v4l2_ctrl_config flash_timeout;
>> +	u32 flash_faults;
>> +	bool has_external_strobe:1;
>> +	bool indicator_led:1;
>> +};
>
> I don't think you are supposed to do boolean bit arrays.

These bit fields allow to reduce memory usage. If they were not bit
fields, the address of the next variable would be aligned to the
multiply of the CPU word size.
Please look e.g. at struct dev_pm_info in the file include/linux/pm.h.
It also contains boolean bit fields.

-- 
Best Regards,
Jacek Anaszewski
