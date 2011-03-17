Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:44374 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab1CQPvH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 11:51:07 -0400
Message-ID: <4D822DE7.9030909@matrix-vision.de>
Date: Thu, 17 Mar 2011 16:51:03 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 4/4] omap3isp: lane shifter support
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de> <201103161846.35599.laurent.pinchart@ideasonboard.com> <4D81DD6C.1050706@matrix-vision.de> <201103171204.10785.laurent.pinchart@ideasonboard.com> <4D822B81.7060301@maxwell.research.nokia.com>
In-Reply-To: <4D822B81.7060301@maxwell.research.nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/17/2011 04:40 PM, Sakari Ailus wrote:
> Hi Laurent and Michael,
> 
> Laurent Pinchart wrote:
>> On Thursday 17 March 2011 11:07:40 Michael Jones wrote:
>>> On 03/16/2011 06:46 PM, Laurent Pinchart wrote:
>>>> On Wednesday 16 March 2011 18:08:04 Sakari Ailus wrote:
>>>>> Laurent Pinchart wrote:
>>>>>> Hi Sakari,
>>>>>>
>>>>>>>> +	return in_info->bpp - out_info->bpp + additional_shift <= 6;
>>>>>>>
>>>>>>> Currently there are no formats that would behave badly in this check?
>>>>>>> Perhaps it'd be good idea to take that into consideration. The shift
>>>>>>> that can be done is even.
>>>>>>
>>>>>> I've asked Michael to remove the check because we have no misbehaving
>>>>>> formats
>>>>>>
>>>>>> :-) Do you think we need to add a check back ?
>>>>>
>>>>> I think it would be helpful in debugging if someone decides to attach a
>>>>> sensor which supports a shift of non-even bits (8 and 9 bits, for
>>>>> example). In any case an invalid configuration is possible in such case,
>>>>> and I don't think that should be allowed, should it?
>>>>
>>>> I agree it shouldn't be allowed, but the ISP driver doesn't support
>>>> non-even widths at the moment, so there's no big risk. There could be an
>>>> issue when a non-even width is added to the driver if the developer
>>>> forgets to update the shift code. Maybe a comment in ispvideo.c above
>>>> the big formats array would help making sure this is not forgotten ?
>>>
>>> I think now that additional_shift is also being considered which comes
>>> from the board file, it makes sense to reintroduce the check for an even
>>> shift.  As Sakari points out, this would be helpful for debugging if
>>> someone tries using .data_lane_shift which is odd.
>>
>> How should we handle such a broken .data_lane_shift value ? Always refuse to 
>> start streaming (maybe with a kernel log message) ? Or should we catch it in 
>> isp_register_entities() instead ?
> 
> If I understand correctly it's not possible to shift odd bits in any
> case. It's a hardware limitation.
> 
> I'd perhaps have just the appropriate register bits in the platform data
> so that leaves no room for accidental misconfiguration, but this is
> perhaps just too much work for not much gain.
> 

Actually, that's the way .data_lane_shift was originally defined
(0,1,2,3), and I left it that way to minimize confusion.  I was mistaken
above when I said that .data_lane_shift could sneak an odd shift to
isp_video_is_shiftable(), because .data_lane_shift is multiplied by 2
before getting passed there.  So I would like to leave this as is, and
it sounds like we have a consensus on this.

I'll submit v4 soon, then.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
