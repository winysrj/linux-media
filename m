Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24079 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab1K1NCw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Nov 2011 08:02:52 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LVD00LVGG8QAL60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 13:02:50 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LVD00502G8PDR@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 28 Nov 2011 13:02:50 +0000 (GMT)
Date: Mon, 28 Nov 2011 14:02:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v2 1/2] v4l: Add new alpha component control
In-reply-to: <201111281339.03100.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com,
	laurent.pinchart@ideasonboard.com, m.szyprowski@samsung.com,
	jonghun.han@samsung.com, riverful.kim@samsung.com,
	sw0312.kim@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ED38679.2080101@samsung.com>
References: <1322235572-22016-1-git-send-email-s.nawrocki@samsung.com>
 <201111281238.42045.hverkuil@xs4all.nl> <4ED37AEC.80105@samsung.com>
 <201111281339.03100.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/28/2011 01:39 PM, Hans Verkuil wrote:
> On Monday 28 November 2011 13:13:32 Sylwester Nawrocki wrote:
>> On 11/28/2011 12:38 PM, Hans Verkuil wrote:
>>> On Friday 25 November 2011 16:39:31 Sylwester Nawrocki wrote:
>>>> This control is intended for the video capture or memory-to-memory
>>>> devices that are capable of setting up a per-pixel alpha component to
>>>> some arbitrary value. The V4L2_CID_ALPHA_COMPONENT control allows to
>>>> set the alpha component for all pixels to a value in range from 0 to
>>>> 255.
>>>>
>>>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> ---
>>>>
>>>>  Documentation/DocBook/media/v4l/compat.xml         |   11 ++++++++
>>>>  Documentation/DocBook/media/v4l/controls.xml       |   25
>>>>
>>>> +++++++++++++++---- .../DocBook/media/v4l/pixfmt-packed-rgb.xml        |
>>>>
>>>>  7 ++++-
>>>>  drivers/media/video/v4l2-ctrls.c                   |    7 +++++
>>>>  include/linux/videodev2.h                          |    6 ++--
>>>>  5 files changed, 45 insertions(+), 11 deletions(-)
>>
>> ...
>>
>>>>  	/* MPEG controls */
>>>>  	/* Keep the order of the 'case's the same as in videodev2.h! */
>>>>
>>>> @@ -714,6 +715,12 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum
>>>> v4l2_ctrl_type *type, /* Max is calculated as RGB888 that is 2^24 */
>>>>
>>>>  		*max = 0xFFFFFF;
>>>>  		break;
>>>>
>>>> +	case V4L2_CID_ALPHA_COMPONENT:
>>>> +		*type = V4L2_CTRL_TYPE_INTEGER;
>>>> +		*step = 1;
>>>> +		*min = 0;
>>>> +		*max = 0xff;
>>>> +		break;
>>>
>>> Hmm. Do we really want to fix the max value to 0xff? The bits assigned to
>>> the alpha component will vary between 1 (V4L2_PIX_FMT_RGB555X), 4
>>> (V4L2_PIX_FMT_RGB444) or 8 (V4L2_PIX_FMT_RGB32). It wouldn't surprise me
>>> to see larger sizes as well in the future (e.g. 16 bits).
>>>
>>> I think the max value should be the largest alpha value the hardware can
>>> support. The application has to set it to the right value that
>>> corresponds to the currently chosen pixel format. The driver just copies
>>> the first N bits into the alpha value where N depends on the pixel
>>> format.
>>>
>>> what do you think?
>>
>> Yes, ideally the maximum value of the alpha control should be changing
>> depending on the set colour format.
>> Currently the maximum value of the control equals maximum alpha value for
>> the fourcc of maximum colour depth (V4L2_PIX_FMT_RGB32).
>>
>> What I found missing was a method for changing the control range
>> dynamically, without deleting and re-initializing the control handler.
>> If we reinitalize whole control handler the previously set control values
>> are lost.
> 
> You can just change the maximum field of struct v4l2_ctrl on the fly like 
> this:
> 
> struct v4l2_ctrl *my_ctrl;
> 
> v4l2_ctrl_lock(my_ctrl);
> my_ctrl->maximum = 10;
> if (my_ctrl->cur.val > my_ctrl->maximum)
> 	my_ctrl->cur.val = my_ctrl->maximum;
> v4l2_ctrl_unlock(my_ctrl);
> 
> Although this might warrant a v4l2_ctrl_update_range() function that does this
> for you. Because after a change like this a V4L2_EVENT_CTRL should also be 
> sent.
> 
> In any case, this functionality isn't hard to add. Just let me know if you 
> need it and I can make a patch for this.

Yes, it would be great if you could prepare a patch for v4l2_ctrl_update_range().
Then I could use it in the next iteration of the patches, instead of hacking 
at the driver. IIRC it's not the first time we needed changing the control range
dynamically.

--

Thanks!
Sylwester
