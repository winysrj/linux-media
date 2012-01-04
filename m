Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56753 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab2ADWEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 17:04:53 -0500
Received: by eekc4 with SMTP id c4so17030303eek.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 14:04:52 -0800 (PST)
Message-ID: <4F04CCFE.7070608@gmail.com>
Date: Wed, 04 Jan 2012 23:04:46 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <201201021217.00336.laurent.pinchart@ideasonboard.com> <4F0219C3.1030401@gmail.com> <201201031455.35771.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201031455.35771.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/03/2012 02:55 PM, Laurent Pinchart wrote:
>>>>> parameter. We also need to discuss how the af statistics window
>>>>> configuration is done. I'm not certain there could even be a
>>>>> standardised
>>>>
>>>> Do we need multiple windows for AF statistics ?
>>>>
>>>> If not, I'm inclined to use four separate controls for window
>>>> configuration. (X, Y, WIDTH, HEIGHT). This was Hans' preference in
>>>> previous discussions [1].
>>>
>>> For the OMAP3 ISP we need multiple statistics windows. AEWB can use more
>>> than 32 windows. Having separate controls for that wouldn't be
>>> practical.
>>
>> OK, so the control API in current form doesn't seem capable of setting up
>> the statistics windows. There is also little space in struct
>> v4l2_ext_control for any major extensions.
>>
>> We might need to define dedicated set of selection targets in the selection
>> API for handling multiple windows.
>>
>> Yet, to avoid forcing applications to use the selection API where
>> rectangles aren't needed - only single spot coordinates, how about
>> defining following two controls ?
>>
>> * AF spot coordinates when focus mode is set to V4L2_AUTO_FOCUS_MODE_SPOT
>>
>>  - V4L2_CID_AUTO_FOCUS_POSITION_X - horizontal position in pixels relative
>>                                     to the left of frame
>>  - V4L2_CID_AUTO_FOCUS_POSITION_Y - vertical position in pixels relative
>>                                     to the top of frame
> 
> What about a point control type instead ? :-) X and Y coordinates could be 
> stored on 32 bits each.

That's more appealing than two separate controls :-) If Hans agrees to
add a point control type (fingers crossed :)) I could prepare relevant patch
to see how it looks like. I've analysed roughly what would need to be changed,
the effort is quite significant but not so invasive for drivers.

I thought about using new V4L2_CTRL_FLAG* for VIDIOC_QUERYCTRL to indicate
which field of the point data structure is queried.

The only real problem seem to be events, I can't see simple method for adding
two sets of min/max/step/def values to the control event payload. There would
probably have to be two separate control change events for each point structure
field.

-- 

Regards,
Sylwester
