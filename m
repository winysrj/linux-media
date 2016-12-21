Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:50961 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S934619AbcLUOES (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 09:04:18 -0500
Subject: Re: 3A / auto-exposure Region of Interest setting
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <Pine.LNX.4.64.1611281449520.6665@axis700.grange>
 <3544629.8KCDMPoHBf@avalon> <Pine.LNX.4.64.1612211142410.5430@axis700.grange>
 <Pine.LNX.4.64.1612211453150.5430@axis700.grange>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <14f51756-782a-cc8f-fe57-455e85b22a2c@xs4all.nl>
Date: Wed, 21 Dec 2016 15:04:14 +0100
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1612211453150.5430@axis700.grange>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21/12/16 14:56, Guennadi Liakhovetski wrote:
> ...one more issue to clarify - how to report compound controls with
> control events, which also until now only support 32- and 64-bit integers.

For compound controls you can only get an event, not what the new values
are. So you would have to call VIDIOC_G_EXT_CTRLS to obtain the new value.

Regards,

	Hans

>
> Thanks
> Guennadi
>
> On Wed, 21 Dec 2016, Guennadi Liakhovetski wrote:
>
>> Hi Laurent,
>>
>> On Tue, 29 Nov 2016, Laurent Pinchart wrote:
>>
>>> Hi Guennadi,
>>>
>>> (CC'ing Sakari)
>>>
>>> On Monday 28 Nov 2016 15:18:03 Guennadi Liakhovetski wrote:
>>>> Hi,
>>>>
>>>> Has anyone already considered supporting 3A (e.g. auto-exposure) Region of
>>>> Interest selection? In UVC this is the "Digital Region of Interest (ROI)
>>>> Control." Android defines ANDROID_CONTROL_AE_REGIONS,
>>>> ANDROID_CONTROL_AWB_REGIONS, ANDROID_CONTROL_AF_REGIONS. The UVC control
>>>> defines just a single rectangle for all (supported) 3A functions. That
>>>> could be implemented, defining a new selection target. However, Android
>>>> allows arbitrary numbers of ROI rectangles with associated weights. Any
>>>> ideas?
>>>
>>> Selections could be used, possibly with an update to the API to allow indexing
>>> selections for a given target. We'd be missing weights though. Another option
>>> would be to use compound controls.
>>
>> I talked to Hans online and he is in favour of a compound control for ROI
>> as well, which is also fine with me. Working on an implementation I
>> realised, that struct v4l2_query_ext_ctrl has min, max, step and default
>> values as 64-bit fields, which isn't enough for ROI. Shall they all be
>> replaced with unions of original values and pointers? As long as pointers
>> don't exceed 64 bits, we'll stay binary compatible. Or do we use those
>> fields similar to the STRING type to specify min, max, default number of
>> ROIs and a size of one ROI in step? I guess we should go with the latter.
>>
>> Thanks
>> Guennadi
>>
>>> --
>>> Regards,
>>>
>>> Laurent Pinchart
>>>
>>

