Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.26]:61818 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1CPRGO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Mar 2011 13:06:14 -0400
Message-ID: <4D80EE74.3040703@maxwell.research.nokia.com>
Date: Wed, 16 Mar 2011 19:08:04 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Michael Jones <michael.jones@matrix-vision.de>,
	linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v3 4/4] omap3isp: lane shifter support
References: <1299830749-7269-1-git-send-email-michael.jones@matrix-vision.de> <1299830749-7269-5-git-send-email-michael.jones@matrix-vision.de> <4D80DAF1.3040002@maxwell.research.nokia.com> <201103161727.43838.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201103161727.43838.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Laurent Pinchart wrote:
> Hi Sakari,

Hi Laurent and Michael!

...
>>> +	return in_info->bpp - out_info->bpp + additional_shift <= 6;
>>
>> Currently there are no formats that would behave badly in this check?
>> Perhaps it'd be good idea to take that into consideration. The shift
>> that can be done is even.
> 
> I've asked Michael to remove the check because we have no misbehaving formats 
> :-) Do you think we need to add a check back ?

I think it would be helpful in debugging if someone decides to attach a
sensor which supports a shift of non-even bits (8 and 9 bits, for
example). In any case an invalid configuration is possible in such case,
and I don't think that should be allowed, should it?

>>> @@ -247,6 +296,7 @@ static int isp_video_validate_pipeline(struct
>>> isp_pipeline *pipe)
>>>
>>>  		return -EPIPE;
>>>  	
>>>  	while (1) {
>>>
>>> +		unsigned int link_has_shifter;
>>
>> link_has_shifter is only used in one place. Would it be cleaner to test
>> below if it's the CCDC? A comment there could be nice, too.
> 
> I would like that better as well, but between the line where link_has_shifter 
> is set and the line where it is checked, the subdev variable changes so we 
> can't just check subdev == &isp->isp_ccdc.subdev there.

That's definitely valid. I take my comment back. The variable could be
called is_ccdc, though, since only the CCDC has that feature. No need to
generalise. :-)

Cheers,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
