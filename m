Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56895 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbcCXPzM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 11:55:12 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0O4J00LIVW7WC1B0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Mar 2016 15:55:08 +0000 (GMT)
Message-id: <56F40DDB.8040805@samsung.com>
Date: Thu, 24 Mar 2016 16:55:07 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	gjasny@googlemail.com, hdegoede@redhat.com, hverkuil@xs4all.nl
Subject: Re: [PATCH 13/15] mediactl: Add media device ioctl API
References: <1453133860-21571-1-git-send-email-j.anaszewski@samsung.com>
 <1453133860-21571-14-git-send-email-j.anaszewski@samsung.com>
 <56C1C775.2090002@linux.intel.com> <56C1CD3E.6090108@samsung.com>
 <20160218120951.GO32612@valkosipuli.retiisi.org.uk>
 <56C5C3C0.7000808@samsung.com>
 <20160321000714.GE11084@valkosipuli.retiisi.org.uk>
 <56F11205.8000903@samsung.com>
 <20160323162413.GK11084@valkosipuli.retiisi.org.uk>
In-reply-to: <20160323162413.GK11084@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2016 05:24 PM, Sakari Ailus wrote:
> Hi Jacek,
>
> On Tue, Mar 22, 2016 at 10:36:05AM +0100, Jacek Anaszewski wrote:
>> Hi Sakari,
>>
>> On 03/21/2016 01:07 AM, Sakari Ailus wrote:
>>> Hi Jacek,
>>>
>>> On Thu, Feb 18, 2016 at 02:14:40PM +0100, Jacek Anaszewski wrote:
>>>> Hi Sakari,
>>>>
>>>> On 02/18/2016 01:09 PM, Sakari Ailus wrote:
>>>>> Hi Jacek,
>>>>>
>>>>> On Mon, Feb 15, 2016 at 02:06:06PM +0100, Jacek Anaszewski wrote:
>>>>>> Hi Sakari,
>>>>>>
>>>>>> Thanks for the review.
>>>>>>
>>>>>> On 02/15/2016 01:41 PM, Sakari Ailus wrote:
>>>>>>> Hi Jacek,
>>>>>>>
>>>>>>> Jacek Anaszewski wrote:
>>>>>>>> Ioctls executed on complex media devices need special handling.
>>>>>>>> For instance some ioctls need to be targeted for specific sub-devices,
>>>>>>>> depending on the media device configuration. The APIs being introduced
>>>>>>>> address such requirements.
>>>>>>>>
>>>>>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>>>>>> ---
>>>>>>>>   utils/media-ctl/Makefile.am          |    2 +-
>>>>>>>>   utils/media-ctl/libv4l2media_ioctl.c |  404 ++++++++++++++++++++++++++++++++++
>>>>>>>>   utils/media-ctl/libv4l2media_ioctl.h |   48 ++++
>>>>>>>>   3 files changed, 453 insertions(+), 1 deletion(-)
>>>>>>>>   create mode 100644 utils/media-ctl/libv4l2media_ioctl.c
>>>>>>>>   create mode 100644 utils/media-ctl/libv4l2media_ioctl.h
>>>>>>>>
>>>>>>>> diff --git a/utils/media-ctl/Makefile.am b/utils/media-ctl/Makefile.am
>>>>>>>> index 3e883e0..7f18624 100644
>>>>>>>> --- a/utils/media-ctl/Makefile.am
>>>>>>>> +++ b/utils/media-ctl/Makefile.am
>>>>>>>> @@ -1,6 +1,6 @@
>>>>>>>>   noinst_LTLIBRARIES = libmediactl.la libv4l2subdev.la libmediatext.la
>>>>>>>>
>>>>>>>> -libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h
>>>>>>>> +libmediactl_la_SOURCES = libmediactl.c mediactl-priv.h libv4l2media_ioctl.c libv4l2media_ioctl.h
>>>>>>>>   libmediactl_la_CFLAGS = -static $(LIBUDEV_CFLAGS)
>>>>>>>>   libmediactl_la_LDFLAGS = -static $(LIBUDEV_LIBS)
>>>>>>>>
>>>>>>>> diff --git a/utils/media-ctl/libv4l2media_ioctl.c b/utils/media-ctl/libv4l2media_ioctl.c
>>>>>>>> new file mode 100644
>>>>>>>> index 0000000..b186121
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/utils/media-ctl/libv4l2media_ioctl.c
>>>>>>>> @@ -0,0 +1,404 @@
>>>>>>>> +/*
>>>>>>>> + * Copyright (c) 2015 Samsung Electronics Co., Ltd.
>>>>>>>> + *              http://www.samsung.com
>>>>>>>> + *
>>>>>>>> + * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>>>>>> + *
>>>>>>>> + * This program is free software; you can redistribute it and/or modify
>>>>>>>> + * it under the terms of the GNU Lesser General Public License as published by
>>>>>>>> + * the Free Software Foundation; either version 2.1 of the License, or
>>>>>>>> + * (at your option) any later version.
>>>>>>>> + *
>>>>>>>> + * This program is distributed in the hope that it will be useful,
>>>>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
>>>>>>>> + * Lesser General Public License for more details.
>>>>>>>> + */
>>>>>>>> +
>>>>>>>> +#include <errno.h>
>>>>>>>> +#include <stdlib.h>
>>>>>>>> +#include <sys/syscall.h>
>>>>>>>> +#include <unistd.h>
>>>>>>>> +
>>>>>>>> +#include <linux/videodev2.h>
>>>>>>>> +
>>>>>>>> +#include "libv4l2media_ioctl.h"
>>>>>>>> +#include "mediactl-priv.h"
>>>>>>>> +#include "mediactl.h"
>>>>>>>> +#include "v4l2subdev.h"
>>>>>>>> +
>>>>>>>> +#define VIDIOC_CTRL(type)					\
>>>>>>>> +	((type) == VIDIOC_S_CTRL ? "VIDIOC_S_CTRL" :		\
>>>>>>>> +				   "VIDIOC_G_CTRL")
>>>>>>>> +
>>>>>>>> +#define VIDIOC_EXT_CTRL(type)					\
>>>>>>>> +	((type) == VIDIOC_S_EXT_CTRLS ? 			\
>>>>>>>> +		"VIDIOC_S_EXT_CTRLS"	:			\
>>>>>>>> +		 ((type) == VIDIOC_G_EXT_CTRLS ? 		\
>>>>>>>> +				    "VIDIOC_G_EXT_CTRLS" :	\
>>>>>>>> +				    "VIDIOC_TRY_EXT_CTRLS"))
>>>>>>>> +
>>>>>>>> +#define SYS_IOCTL(fd, cmd, arg) \
>>>>>>>> +	syscall(SYS_ioctl, (int)(fd), (unsigned long)(cmd), (void *)(arg))
>>>>>>>> +
>>>>>>>> +
>>>>>>>> +int media_ioctl_ctrl(struct media_device *media, int request,
>>>>>>>
>>>>>>> unsigned int request
>>>>>>
>>>>>> OK.
>>>>>>
>>>>>>>
>>>>>>>> +		     struct v4l2_control *arg)
>>>>>>>
>>>>>>> I wonder if it'd make sense to always use v4l2_ext_control instead. You
>>>>>>> can't access 64-bit integer controls with VIDIOC_S_CTRL for instance.
>>>>>>
>>>>>> This function is meant to handle VIDIOC_S_CTRL/VIDIOC_G_CTRL ioctls.
>>>>>> For ext ctrls there is media_ioctl_ext_ctrl().
>>>>>
>>>>> Is there any reason not to use extended control always?
>>>>>
>>>>> In other words, do we have a driver that does support Media controller but
>>>>> does not support extended controls?
>>>>
>>>> Shouldn't we support non-extended controls for backward compatibility
>>>> reasons? I am not aware of the policy in this matter.
>>>
>>> To put it bluntly, supporting the non-extended controls in this use is waste
>>> of time IMHO.
>>
>> OK, I'll drop the non-ext controls related API then.
>>
>>>>>>> As this is a user space library, I'd probably add a function to handle
>>>>>>> S/G/TRY control each.
>>>>>>
>>>>>> There is media_ioctl_ext_ctrl() that handles VIDIOC_S_EXT_CTRLS,
>>>>>> VIDIOC_G_EXT_CTRLS and VIDIOC_TRY_EXT_CTRLS.
>>>>>>
>>>>>>> Have you considered binding the control to a video node rather than a
>>>>>>> media device? We have many sensors on current media devices already, and
>>>>>>> e.g. exposure time control can be found in multiple sub-devices.
>>>>>>
>>>>>> Doesn't v4l2-ctrl-redir config entry address that?
>>>>>
>>>>> How does it work if you have, say, two video nodes where you can capture
>>>>> images from a different sensor? I.e. your media graph could look like this:
>>>>>
>>>>> 	sensor0 -> CSI-2 0 -> video0
>>>>>
>>>>> 	sensor1 -> CSI-2 1 -> video1
>>>>
>>>> Exemplary config settings for this case:
>>>>
>>>> v4l2-ctrl-redir 0x0098091f -> "sensor0"
>>>> v4l2-ctrl-redir 0x0098091f -> "sensor1"
>>>>
>>>> In media_ioctl_ctrl the v4l2_subdev_get_pipeline_entity_by_cid(media,
>>>> ctrl.id) is called which walks through the pipeline and checks if there
>>>> has been a v4l2 control redirection defined for given entity.
>>>
>>> That's still based on media device, not video device. Two video devices may
>>> be part of different pipelines, and a different sensor as well.
>>>
>>> Redirecting the controls should be based on a video node, not media device.
>>
>> Why do you consider it as based on a media device? I'd rather say that
>> it is based on media entity, so indirectly based on media device.
>> Is it what you have on mind?
>
> The first argument of the functions in the patch is a pointer ot the media
> device, not the media entity.

OK, so could you precise what you mean by binding the control to video
node rather to a media device? How would you see the config and the API?
Maybe some config example would allow me to catch the gist of your idea.

>>
>>>>
>>>> If no redirection is defined then the control is set on the first
>>>> entity in the pipeline that supports it. Effectively, for this
>>>> arrangement no redirection would be required if the control
>>>> is to be set on sensors. It would be required if we wanted
>>>> to bind the control to the videoN entity. Now I am wondering
>>>> if I should change the entry name to v4l2-ctrl-binding, or maybe
>>>> someone has better idea?
>>>>
>>>> BTW, are there some unique identifiers added to the entity names if
>>>> more than one entity of a name is to be registered? E.g. what would
>>>> happen if I had two S5C73M3 sensors in a media device? I assumed that
>>>> entity names are unique.
>>>
>>> Yes. Currently we've got away with the problem by adding the i2c address of
>>> i2c devices to the entity name. The proper solution (there was a lengthy
>>> discussion on it ~ a year ago, too late to try to find out exactly when)
>>> would be to provide all the available information on the entity to the user
>>> space using the property API (which we don't have yet). The entity name
>>> remains unique in most situations but it's not necessarily stable.
>>>
>>
>> I assume that the fact that they're not stable mean that we cannot rely
>> on the entity name. Using sub-dev names and video device names seems
>> reasonable then.
>
> They're even less so, unfortunately; the device nodes depend e.g. on the
> initialisation order an other devices. Please use the entity names, they're
> the best option for now.

OK.

> I wish I'll have some time to proceed the work on the property API. So many
> things to do, but so little time. :-I
>

I know that feel :-|

-- 
Best regards,
Jacek Anaszewski
