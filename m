Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48137 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab2ABUzi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2012 15:55:38 -0500
Received: by eekc4 with SMTP id c4so15459766eek.19
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2012 12:55:37 -0800 (PST)
Message-ID: <4F0219C3.1030401@gmail.com>
Date: Mon, 02 Jan 2012 21:55:31 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, riverful.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFC/PATCH 1/5] v4l: Convert V4L2_CID_FOCUS_AUTO control to a
 menu control
References: <1323011776-15967-1-git-send-email-snjw23@gmail.com> <20111231120025.GD3677@valkosipuli.localdomain> <4F008E87.1070706@gmail.com> <201201021217.00336.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201201021217.00336.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/02/2012 12:16 PM, Laurent Pinchart wrote:
>> * controls for starting/stopping auto focusing (V4L2_CID_FOCUS_AUTO ==
>> false)
>>
>>   V4L2_CID_START_AUTO_FOCUS (button) - start auto focusing,
>>   V4L2_CID_STOP_AUTO_FOCUS  (button) - stop auto focusing (might be also
>>                                        useful in V4L2_FOCUS_AUTO == true),
> 
> Maybe V4L2_CID_AUTO_FOCUS_START and V4L2_CID_AUTO_FOCUS_STOP to be consistent 
> with the other proposed controls ?

Yes, you're right, I'll change them to make consistent with others.
I've noticed that too, but a little bit too late:)

>> * auto focus status
>>
>>   V4L2_CID_AUTO_FOCUS_STATUS (menu, read-only) - whether focusing is in
>>                                                  progress or not,
>>   possible entries:
>>
>>   - V4L2_AUTO_FOCUS_STATUS_IDLE,    // auto focusing not enabled or force
>>                                        stopped 
>>   - V4L2_AUTO_FOCUS_STATUS_BUSY,    // focusing in progress
>>   - V4L2_AUTO_FOCUS_STATUS_SUCCESS, // single-shot auto focusing succeed
>>                                     // or continuous AF in progress
>>   - V4L2_AUTO_FOCUS_STATUS_FAIL,    // auto focusing failed
>>
>>
>> * V4L2_CID_FOCUS_AUTO would retain its current semantics:
>>
>>   V4L2_CID_FOCUS_AUTO (boolean) - selects auto/manual focus
>>       false - manual
>>       true  - auto continuous
>>
>> * AF algorithm scan range, V4L2_CID_FOCUS_AUTO_SCAN_RANGE with choices:
>>
>>   - V4L2_AUTO_FOCUS_SCAN_RANGE_NORMAL,
>>   - V4L2_AUTO_FOCUS_SCAN_RANGE_MACRO,
>>   - V4L2_AUTO_FOCUS_SCAN_RANGE_INFINITY
>>
...
>>
>> * select auto focus mode
>>
>> V4L2_CID_AUTO_FOCUS_MODE
>>         V4L2_AUTO_FOCUS_MODE_NORMAL     - "normal" auto focus (whole frame?)
>>         V4L2_AUTO_FOCUS_MODE_SPOT       - spot location passed with other
>>         controls or selection API
>>         V4L2_AUTO_FOCUS_MODE_RECTANGLE  - rectangle passed with other
>>         controls or selection API
> 
> Soudns good to me.
>
>>> parameter. We also need to discuss how the af statistics window
>>> configuration is done. I'm not certain there could even be a standardised
>>
>> Do we need multiple windows for AF statistics ?
>>
>> If not, I'm inclined to use four separate controls for window
>> configuration. (X, Y, WIDTH, HEIGHT). This was Hans' preference in
>> previous discussions [1].
> 
> For the OMAP3 ISP we need multiple statistics windows. AEWB can use more than 
> 32 windows. Having separate controls for that wouldn't be practical.

OK, so the control API in current form doesn't seem capable of setting up the
statistics windows. There is also little space in struct v4l2_ext_control for
any major extensions.

We might need to define dedicated set of selection targets in the selection
API for handling multiple windows.

Yet, to avoid forcing applications to use the selection API where rectangles
aren't needed - only single spot coordinates, how about defining following
two controls ?

* AF spot coordinates when focus mode is set to V4L2_AUTO_FOCUS_MODE_SPOT

 - V4L2_CID_AUTO_FOCUS_POSITION_X - horizontal position in pixels relative
                                    to the left of frame
 - V4L2_CID_AUTO_FOCUS_POSITION_Y - vertical position in pixels relative
                                    to the top of frame

--

Thanks,
Sylwester
