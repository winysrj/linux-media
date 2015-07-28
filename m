Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38221 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbbG1Le4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jul 2015 07:34:56 -0400
Message-ID: <55B7687A.2020802@gmail.com>
Date: Tue, 28 Jul 2015 13:33:14 +0200
From: Jacek Anaszewski <jacek.anaszewski@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org, linux-media@vger.kernel.org
CC: pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v10.1] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1434699107-5678-1-git-send-email-j.anaszewski@samsung.com> <55B752A0.9060301@xs4all.nl>
In-Reply-To: <55B752A0.9060301@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 28.07.2015 12:00, Hans Verkuil wrote:
> On 06/19/2015 09:31 AM, Jacek Anaszewski wrote:
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
>> ---
>> - fixed possible NULL fled_cdev pointer dereference
>>    in the v4l2_flash_init function
>>
>>   drivers/media/v4l2-core/Kconfig                |   11 +
>>   drivers/media/v4l2-core/Makefile               |    2 +
>>   drivers/media/v4l2-core/v4l2-flash-led-class.c |  710 ++++++++++++++++++++++++
>>   include/media/v4l2-flash-led-class.h           |  148 +++++
>>   4 files changed, 871 insertions(+)
>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash-led-class.c
>>   create mode 100644 include/media/v4l2-flash-led-class.h
>>
>
> <snip>
>
>> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>> new file mode 100644
>> index 0000000..5bdfb8d
>> --- /dev/null
>> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>
> <snip>
>
>> +static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
>> +	.queryctrl = v4l2_subdev_queryctrl,
>> +	.querymenu = v4l2_subdev_querymenu,
>
> Why are these here? This should not be necessary. As long as the sd.ctrl_handler
> pointer is set, this is handled automatically.
>
>> +};
>> +
>> +static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
>> +	.core = &v4l2_flash_core_ops,
>> +};
>> +
>
> And if v4l2_flash_core_ops goes away, then this can go away as well.
>
> I know this driver has been merged, but I just noticed this while looking at
> something else.

I'll be able to verify this no sooner than in two weeks. Probably
you're right as I added this snippet without checking if it was
really necessary.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Best Regards,
Jacek Anaszewski
