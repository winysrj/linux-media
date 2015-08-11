Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46340 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964822AbbHKM7n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 08:59:43 -0400
Message-ID: <55C9F131.2080306@xs4all.nl>
Date: Tue, 11 Aug 2015 14:57:21 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>
CC: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
	pavel@ucw.cz, cooloney@gmail.com, rpurdie@rpsys.net,
	sakari.ailus@iki.fi, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH v10.1] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1434699107-5678-1-git-send-email-j.anaszewski@samsung.com> <55B752A0.9060301@xs4all.nl> <55C9F0F4.1060602@samsung.com>
In-Reply-To: <55C9F0F4.1060602@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/15 14:56, Jacek Anaszewski wrote:
> On 07/28/2015 12:00 PM, Hans Verkuil wrote:
>> On 06/19/2015 09:31 AM, Jacek Anaszewski wrote:
>>> This patch adds helper functions for registering/unregistering
>>> LED Flash class devices as V4L2 sub-devices. The functions should
>>> be called from the LED subsystem device driver. In case the
>>> support for V4L2 Flash sub-devices is disabled in the kernel
>>> config the functions' empty versions will be used.
>>>
>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> Cc: Sakari Ailus <sakari.ailus@iki.fi>
>>> Cc: Hans Verkuil <hans.verkuil@cisco.com>
>>> ---
>>> - fixed possible NULL fled_cdev pointer dereference
>>>    in the v4l2_flash_init function
>>>
>>>   drivers/media/v4l2-core/Kconfig                |   11 +
>>>   drivers/media/v4l2-core/Makefile               |    2 +
>>>   drivers/media/v4l2-core/v4l2-flash-led-class.c |  710 ++++++++++++++++++++++++
>>>   include/media/v4l2-flash-led-class.h           |  148 +++++
>>>   4 files changed, 871 insertions(+)
>>>   create mode 100644 drivers/media/v4l2-core/v4l2-flash-led-class.c
>>>   create mode 100644 include/media/v4l2-flash-led-class.h
>>>
>>
>> <snip>
>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>>> new file mode 100644
>>> index 0000000..5bdfb8d
>>> --- /dev/null
>>> +++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
>>
>> <snip>
>>
>>> +static const struct v4l2_subdev_core_ops v4l2_flash_core_ops = {
>>> +    .queryctrl = v4l2_subdev_queryctrl,
>>> +    .querymenu = v4l2_subdev_querymenu,
>>
>> Why are these here? This should not be necessary. As long as the sd.ctrl_handler
>> pointer is set, this is handled automatically.
> 
> I removed these two lines and indeed driver works well without it.
> 
>>> +};
>>> +
>>> +static const struct v4l2_subdev_ops v4l2_flash_subdev_ops = {
>>> +    .core = &v4l2_flash_core_ops,
>>> +};
>>> +
>>
>> And if v4l2_flash_core_ops goes away, then this can go away as well.
> 
> What should I pass as the second argument to v4l2_subdev_init then?
> It seems that ops can't be NULL:
> 
> void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
> {
>         INIT_LIST_HEAD(&sd->list);
>         BUG_ON(!ops);     <---------------

In that case just give an empty ops struct.

I really need to look at this whether I can remove that BUG_ON.

Regards,

	Hans

>         sd->ops = ops;
>         sd->v4l2_dev = NULL;
>         sd->flags = 0;
>         sd->name[0] = '\0';
>         sd->grp_id = 0;
>         sd->dev_priv = NULL;
>         sd->host_priv = NULL;
> #if defined(CONFIG_MEDIA_CONTROLLER)
>         sd->entity.name = sd->name;
>         sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> #endif
> }
> 
>>
>> I know this driver has been merged, but I just noticed this while looking at
>> something else.
>>
>> Regards,
>>
>>     Hans
>>
> 
