Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([192.100.122.233]:53913 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039Ab0I1NIv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 09:08:51 -0400
Message-ID: <4CA1E8D7.2010805@maxwell.research.nokia.com>
Date: Tue, 28 Sep 2010 16:08:39 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com>    <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com>    <201009262025.20852.hverkuil@xs4all.nl>    <201009281350.23233.laurent.pinchart@ideasonboard.com> <3c895d38527af5e6b5acdd783ff8dacb.squirrel@webmail.xs4all.nl>
In-Reply-To: <3c895d38527af5e6b5acdd783ff8dacb.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

Hans Verkuil wrote:
>>>> +
>>>> +#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
>>>> +#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
>>>> +#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
>>>> +			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
>>>> +#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
>>>> +			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)
>>>
>>> The ioctl numbering is a bit scary. We want to be able to reuse V4L2
>>> ioctls
>>> with subdevs where appropriate. But then we need to enumerate the subdev
>>> ioctls using a different character to avoid potential conflicts. E.g.
>>> 'S'
>>> instead of 'V'.
>>
>> There's little chance the ioctl values will conflict, as they encode the
>> structure size. However, it could still happen. That's why I've reused the
>> VIDIOC_G_FMT, VIDIOC_S_FMT, VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES
>> ioctl
>> numbers for those new ioctls, as they replace the V4L2 ioctls for
>> sub-devices.
>> We can also use another prefix, but there's a limited supply of them.
> 
> Hmm, perhaps we can use 'v'. That's currently in use by V4L1, but that's
> on the way out. I'm not sure what is wisdom here. Mauro should take a look
> at this, I think.

Similar V4L2 ioctls exists but they still are part of a different API.
So I'd go with 'S' (or something else non-'V') unless the ioctl is
exactly the same as in V4L2. And allocate numbers starting from 0 if
possible.

But I agree, let's wait Mauro's opinion...

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
