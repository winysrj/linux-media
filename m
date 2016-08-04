Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:40874 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758604AbcHDO3g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 10:29:36 -0400
Subject: Re: [PATCHv2] v4l2-common: add s_selection helper function
To: Sakari Ailus <sakari.ailus@iki.fi>
References: <c6379bf1-4fdf-7deb-4312-86d26d0ee106@xs4all.nl>
 <20160804140313.GI3243@valkosipuli.retiisi.org.uk>
 <aa119982-53c6-37bf-d019-b6ccd27b5c8a@xs4all.nl>
 <20160804141734.GK3243@valkosipuli.retiisi.org.uk>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b343ec5f-0c03-ae92-ef92-a051b23060ca@xs4all.nl>
Date: Thu, 4 Aug 2016 16:27:27 +0200
MIME-Version: 1.0
In-Reply-To: <20160804141734.GK3243@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 08/04/2016 04:17 PM, Sakari Ailus wrote:
> On Thu, Aug 04, 2016 at 04:11:55PM +0200, Hans Verkuil wrote:
>>
>>
>> On 08/04/2016 04:03 PM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Mon, Aug 01, 2016 at 12:33:39PM +0200, Hans Verkuil wrote:
>>>> Checking the selection constraint flags is often forgotten by drivers, especially
>>>> if the selection code just clamps the rectangle to the minimum and maximum allowed
>>>> rectangles.
>>>>
>>>> This patch adds a simple helper function that checks the adjusted rectangle against
>>>> the constraint flags and either returns -ERANGE if it doesn't fit, or fills in the
>>>> new rectangle and returns 0.
>>>>
>>>> It also adds a small helper function to v4l2-rect.h to check if one rectangle fits
>>>> inside another.
>>>
>>> I could have misunderstood the purpose of the patch but... these flags are
>>> used by drivers in guidance in adjusting the rectangle in case there are
>>> hardware limitations, to make it larger or smaller than requested if the
>>> request can't be fulfillsed as such. The intent is *not* to return an error
>>> back to the user. In this respect it works quite like e.g. S_FMT does in
>>> cases an exact requested format can't be supported.
>>>
>>> <URL:https://www.linuxtv.org/downloads/v4l-dvb-apis/apb.html#v4l2-selection-flags>
>>>
>>> What can be done is rather driver specific.
>>>
>>
>> That's not what the spec says:
>>
>> https://hverkuil.home.xs4all.nl/spec/uapi/v4l/vidioc-g-selection.html
>>
>> ERANGE
>> It is not possible to adjust struct v4l2_rect r rectangle to satisfy all constraints given in the flags argument.
>>
>> It's rather unambiguous, I think.
>>
>> If you don't want an error, then just leave 'flags' to 0. That makes sense.
> 
> Does it? I can't imagine a use case for that.

That's just the standard behavior: "I'd like this selection rectangle, but adjust
however you like it to something that works."

> The common section still defines these flags differently, and that's the
> behaviour on V4L2 sub-device interface. Do we have a driver that implements
> support for these flags as you described?
> 

A quick check: fimc-capture, gsc-m2m, am437, vivid, fimc-lite, bdisp.

Note that VIDIOC_SUBDEV_S_SELECTION doesn't specify an ERANGE error, but I don't know
if that is intentional or an oversight. At least smiapp-core.c doesn't return an error.

Regards,

	Hans
