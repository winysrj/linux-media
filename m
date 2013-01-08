Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53256 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab3AHM0K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 07:26:10 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MGB0031W3OYYK50@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Jan 2013 12:26:07 +0000 (GMT)
Received: from [106.116.147.88] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MGB0082V3VJ5960@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Jan 2013 12:26:07 +0000 (GMT)
Message-id: <50EC105E.1040206@samsung.com>
Date: Tue, 08 Jan 2013 13:26:06 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: RFC: add parameters to V4L controls
References: <50EAA78E.4090904@samsung.com>
 <201301071310.54428.hverkuil@xs4all.nl> <15086879.jLpyhrHcbt@avalon>
In-reply-to: <15086879.jLpyhrHcbt@avalon>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.01.2013 21:02, Laurent Pinchart wrote:
> Hi Hans,
>
> On Monday 07 January 2013 13:10:54 Hans Verkuil wrote:
>> On Mon January 7 2013 11:46:38 Andrzej Hajda wrote:
>>> Hi,
>>>
>>> I have included this proposition already in the post "[PATCH RFC 0/2]
>>> V4L: Add auto focus area control and selection" but it left unanswered.
>>> I repost it again in a separate e-mail, I hope this way it will be
>>> easier to attract attention.
>>>
>>> Problem description
>>>
>>> Currently V4L2 controls can have only single value (of type int, int64,
>>> string). Some hardware controls require more than single int parameter,
>>> for example to set auto-focus (AF) rectangle four coordinates should be
>>> passed, to set auto-focus spot two coordinates should be passed.
>>>
>>> Current solution
>>>
>>> In case of AF rectangle we can reuse selection API as in "[PATCH RFC
>>> 0/2] V4L: Add auto focus area control and selection" post.
>>> Pros:
>>> - reuse existing API,
>>> Cons:
>>> - two IOCTL's to perform one action,
>>> - non-atomic operation,
> Is it really an issue in your use cases, or is this only a theoretical problem
> ?
Currently it is not a blocker, but it shows additional issues which we 
should deal with, for example:
- which ioctls should trigger the AF action,
- default values for AF selection rectangle/spot, which should be 
(probably) reset after each change of format on device/pad.
Documenting it will make the situation clear for app/driver developers, 
but with atomic ioctl we could just forget about it.
Btw. there is already discussion about it in '[PATCH RFC 2/2] V4L: Add 
V4L2_CID_AUTO_FOCUS_AREA control'.
>
>>> - fits well only for rectangles and spots (but with unused fields width,
>>> height), in case of other parameters we should find a different way.
>>>
>>> Proposed solution
>>>
>>> The solution takes an advantage of the fact VIDIOC_(G/S/TRY)_EXT_CTRLS
>>> ioctls can be called with multiple controls per call.
>>>
>>> I will present it using AF area control example.
>>>
>>> There could be added four pseudo-controls, lets call them for short:
>>> LEFT, TOP, WIDTH, HEIGHT.
>>> Those controls could be passed together with
>>> V4L2_AUTO_FOCUS_AREA_RECTANGLE
>>> control in one ioctl as a kind of parameters.
>>>
>>> For example setting auto-focus spot would require calling
>>> VIDIOC_S_EXT_CTRLS with the following controls:
>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>>> - LEFT = ...
>>> - RIGHT = ...
>>>
>>> Setting AF rectangle:
>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>>> - LEFT = ...
>>> - TOP = ...
>>> - WIDTH = ...
>>> - HEIGHT = ...
>>>
>>> Setting  AF object detection (no parameters required):
>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
>> If you want to do this, then you have to make LEFT/TOP/WIDTH/HEIGHT real
>> controls. There is no such thing as a pseudo control. So you need five
>> new controls in total:
>>
>> V4L2_CID_AUTO_FOCUS_AREA
>> V4L2_CID_AUTO_FOCUS_LEFT
>> V4L2_CID_AUTO_FOCUS_RIGHT
>> V4L2_CID_AUTO_FOCUS_WIDTH
>> V4L2_CID_AUTO_FOCUS_HEIGHT
>>
>> I have no problem with this from the point of view of the control API, but
>> whether this is the best solution for implementing auto-focus is a different
>> issue and input from sensor specialists is needed as well (added Laurent
>> and Sakari to the CC list).
>>
>> The primary concern I have is that this does not scale to multiple focus
>> rectangles. This might not be relevant to auto focus, though.
> Time to implement a rectangle control type ? Or to make it possible to issue
> atomic transactions across ioctls ? We've been postponing this discussion for
> ages.
>
>>> I have presented all three cases to show the advantages of this solution:
>>> - atomicity - control and its parameters are passed in one call,
>>> - flexibility - we are not limited by a fixed number of parameters,
>>> - no-redundancy - we can pass only required parameters
>>>
>>> 	(no need to pass null width and height in case of spot selection),
>>>
>>> - extensibility - it is possible to extend parameters in the future,
>>> for example add parameters to V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION,
>>> without breaking API,
>>> - backward compatibility,
>>> - re-usability - this schema could be used in other controls,
>>>
>>> 	pseudo-controls could be re-used in other controls as well.
>>>
>>> - API backward compatibility.
Regards,
Andrzej

