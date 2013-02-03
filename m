Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:45760 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3BCSyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Feb 2013 13:54:04 -0500
Received: by mail-ee0-f47.google.com with SMTP id e52so2826995eek.20
        for <linux-media@vger.kernel.org>; Sun, 03 Feb 2013 10:54:02 -0800 (PST)
Message-ID: <510EB23E.6070100@gmail.com>
Date: Sun, 03 Feb 2013 19:53:50 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Andrzej Hajda <a.hajda@samsung.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: RFC: add parameters to V4L controls
References: <50EAA78E.4090904@samsung.com> <201301071310.54428.hverkuil@xs4all.nl> <510AA736.5060803@samsung.com> <1409971.Bs77k1Sp6U@avalon>
In-Reply-To: <1409971.Bs77k1Sp6U@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/01/2013 11:17 PM, Laurent Pinchart wrote:
[...]
>>>> There could be added four pseudo-controls, lets call them for short:
>>>> LEFT, TOP, WIDTH, HEIGHT. Those controls could be passed together with
>>>> V4L2_AUTO_FOCUS_AREA_RECTANGLE control in one ioctl as a kind of
>>>> parameters.
>>>>
>>>> For example setting auto-focus spot would require calling
>>>> VIDIOC_S_EXT_CTRLS with the following controls:
>>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>>>> - LEFT = ...
>>>> - RIGHT = ...
>>>>
>>>> Setting AF rectangle:
>>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_RECTANGLE
>>>> - LEFT = ...
>>>> - TOP = ...
>>>> - WIDTH = ...
>>>> - HEIGHT = ...
>>>>
>>>> Setting  AF object detection (no parameters required):
>>>> - V4L2_CID_AUTO_FOCUS_AREA = V4L2_AUTO_FOCUS_AREA_OBJECT_DETECTION
>>>
>>> If you want to do this, then you have to make LEFT/TOP/WIDTH/HEIGHT real
>>> controls. There is no such thing as a pseudo control. So you need five
>>> new controls in total:
>>>
>>> V4L2_CID_AUTO_FOCUS_AREA
>>> V4L2_CID_AUTO_FOCUS_LEFT
>>> V4L2_CID_AUTO_FOCUS_RIGHT
>>> V4L2_CID_AUTO_FOCUS_WIDTH
>>> V4L2_CID_AUTO_FOCUS_HEIGHT
>>>
>>> I have no problem with this from the point of view of the control API, but
>>> whether this is the best solution for implementing auto-focus is a
>>> different issue and input from sensor specialists is needed as well
>>> (added Laurent and Sakari to the CC list).
>>>
>>> The primary concern I have is that this does not scale to multiple focus
>>> rectangles. This might not be relevant to auto focus, though.
>>
>> I think for more advanced hardware/configurations there is a need to
>> associate more information with the rectangles anyway. So the selections
>> API seems too limited. Probably a new IOCTL would be needed for that,
>> either standard or private.
>>
>> We've discussed it here with Andrzej and using such 4 controls to specify
>> the AF rectangle looks sufficient from our POV.
>>
>> I would just probably rename LEFT/RIGHT to POS_X/POS_Y or something,
>> as these 2 controls could be used in a focus mode where only spot
>> position needs to be specified.
>
> If position and size are sufficient, could we use the selection API instead ?
> An alternative would be to introduce rectangle controls. I'm a bit
> uncomfortable with using 4 controls here, as this could quickly grow out of
> control.

Yes, the selection API could be used as well. I actually have tested this
in the past with the s5c73m3 camera and its spot auto focus mode.

I just wanted to be sure there is no better alternatives, as it looked
a bit unusual to handle single feature with a mix of the controls and
the selection API calls. Although it works, such an interface looks a bit
clumsy to me, especially in cases where all we need is to pass just (x,y)
coordinates.

I have quickly added support for rectangle controls type [1] to see how
big changes it would require and what would be missing without significant
changes in the controls API.

So the main issues there are: the min/max/step/default value cannot
be queried (VIDIOC_QUERYCTRL) and it is troublesome to handle them in
the kernel, the control value change events wouldn't really work.

I learnt VIDIOC_QUERYCTRL is not supported for V4L2_CTRL_TYPE_INTEGER64
control type, then maybe we could have similarly some features not
available for V4L2_CTRL_TYPE_RECTANGLE ? Until there are further
extensions that address this;)

[1] http://git.linuxtv.org/snawrocki/media.git/ov965x-2-rect-type-ctrl

--

Regards,
Sylwester
