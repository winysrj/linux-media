Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65091 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302Ab2AFN4O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2012 08:56:14 -0500
Received: by eekc4 with SMTP id c4so1065642eek.19
        for <linux-media@vger.kernel.org>; Fri, 06 Jan 2012 05:56:13 -0800 (PST)
Message-ID: <4F06FD76.2030508@gmail.com>
Date: Fri, 06 Jan 2012 14:56:06 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <1323011776-15967-2-git-send-email-snjw23@gmail.com> <20111210103344.GF1967@valkosipuli.localdomain> <4EE36FE1.1080601@gmail.com> <20111231120025.GD3677@valkosipuli.localdomain> <4F008E87.1070706@gmail.com> <20120104132249.GC9323@valkosipuli.localdomain>
In-Reply-To: <20120104132249.GC9323@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/04/2012 02:22 PM, Sakari Ailus wrote:
>>>>>> The V4L2_CID_FOCUS_AUTO menu control has currently following items:
>>>>>>   0 - V4L2_FOCUS_MANUAL,
>>>>>>   1 - V4L2_FOCUS_AUTO,
>>>>>>   2 - V4L2_FOCUS_AUTO_MACRO,
>>>>>>   3 - V4L2_FOCUS_AUTO_CONTINUOUS.
>>>>>
>>>>> I would put the macro mode to a separate menu since it's configuration for
>>>>> how the regular AF works rather than really different mode.
>>>>
>>>> Yes, makes sense. Most likely there could be also continuous macro auto focus..
>>>> I don't have yet an idea what could be a name for that new menu though.
>>>
>>> V4L2_CID_FOCUS_AUTO_DISTANCE? It could then have choices FULL or MACRO.
>>
>> How about V4L2_CID_FOCUS_AUTO_SCAN_RANGE ? Which would then have choices:
>> 	NORMAL,
>> 	MACRO,
>> 	INFINITY
>> ?
> 
> What does INFINITY signify? That lens is permanently positioned there?

Yes, I think that's just what it is supposed to mean, but I would have to double
check in the specs.

HeungJun, would you have some more details about the INFINITY setting ?

> The name of the control sounds good to me, but I might change the order of
> FOCUS and AUTO in it.

Ok, I'll fix it.

--

Thanks,
Sylwester
