Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:42889 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754080Ab1CQPjA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Mar 2011 11:39:00 -0400
Message-ID: <4D822B81.7060301@maxwell.research.nokia.com>
Date: Thu, 17 Mar 2011 17:40:49 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 4/4] omap3isp: lane shifter support
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de> <201103161846.35599.laurent.pinchart@ideasonboard.com> <4D81DD6C.1050706@matrix-vision.de> <201103171204.10785.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103171204.10785.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Laurent and Michael,

Laurent Pinchart wrote:
> On Thursday 17 March 2011 11:07:40 Michael Jones wrote:
>> On 03/16/2011 06:46 PM, Laurent Pinchart wrote:
>>> On Wednesday 16 March 2011 18:08:04 Sakari Ailus wrote:
>>>> Laurent Pinchart wrote:
>>>>> Hi Sakari,
>>>>>
>>>>>>> +	return in_info->bpp - out_info->bpp + additional_shift <= 6;
>>>>>>
>>>>>> Currently there are no formats that would behave badly in this check?
>>>>>> Perhaps it'd be good idea to take that into consideration. The shift
>>>>>> that can be done is even.
>>>>>
>>>>> I've asked Michael to remove the check because we have no misbehaving
>>>>> formats
>>>>>
>>>>> :-) Do you think we need to add a check back ?
>>>>
>>>> I think it would be helpful in debugging if someone decides to attach a
>>>> sensor which supports a shift of non-even bits (8 and 9 bits, for
>>>> example). In any case an invalid configuration is possible in such case,
>>>> and I don't think that should be allowed, should it?
>>>
>>> I agree it shouldn't be allowed, but the ISP driver doesn't support
>>> non-even widths at the moment, so there's no big risk. There could be an
>>> issue when a non-even width is added to the driver if the developer
>>> forgets to update the shift code. Maybe a comment in ispvideo.c above
>>> the big formats array would help making sure this is not forgotten ?
>>
>> I think now that additional_shift is also being considered which comes
>> from the board file, it makes sense to reintroduce the check for an even
>> shift.  As Sakari points out, this would be helpful for debugging if
>> someone tries using .data_lane_shift which is odd.
> 
> How should we handle such a broken .data_lane_shift value ? Always refuse to 
> start streaming (maybe with a kernel log message) ? Or should we catch it in 
> isp_register_entities() instead ?

If I understand correctly it's not possible to shift odd bits in any
case. It's a hardware limitation.

I'd perhaps have just the appropriate register bits in the platform data
so that leaves no room for accidental misconfiguration, but this is
perhaps just too much work for not much gain.

>>>>>>> @@ -247,6 +296,7 @@ static int isp_video_validate_pipeline(struct
>>>>>>> isp_pipeline *pipe)
>>>>>>>
>>>>>>>  		return -EPIPE;
>>>>>>>  	
>>>>>>>  	while (1) {
>>>>>>>
>>>>>>> +		unsigned int link_has_shifter;
>>>>>>
>>>>>> link_has_shifter is only used in one place. Would it be cleaner to
>>>>>> test below if it's the CCDC? A comment there could be nice, too.
>>>>>
>>>>> I would like that better as well, but between the line where
>>>>> link_has_shifter is set and the line where it is checked, the subdev
>>>>> variable changes so we can't just check subdev == &isp->isp_ccdc.subdev
>>>>> there.
>>>>
>>>> That's definitely valid. I take my comment back. The variable could be
>>>> called is_ccdc, though, since only the CCDC has that feature. No need to
>>>> generalise. :-)
>>
>> But this is not a feature of the CCDC, the lane shifter is outside of
>> the CCDC.  Each 'while (1)' iteration handles 2 subdevs on each side of
>> one link, so I think it makes sense for a particular iteration to say
>> "this link has", especially when the subdev ptr changes values between
>> the assignment of this var and its usage.  "is_ccdc" is vague as to
>> which side of the CCDC we're on.  'link_has_shifter' wasn't intended to
>> be general, it was supposed to mean 'this_is_the_link_with_the_shifter'.
>>  If you want to be more specific where that is in the pipeline, maybe
>> 'ccdc_sink_link'?  If you just want it to sound less like "this is one
>> of the links with a shifter" and more like "We've found _the_ link with
>> _the_ shifter", it could just be 'shifter_link'.
> 
> shifter_link sounds good to me.

I agree.

>> After we iron these two things out, are you guys ready to see v4?
> 
> That's fine with me.

For me, too!

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
