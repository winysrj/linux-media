Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62041 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757117Ab2ADWGS (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 Jan 2012 17:06:18 -0500
Received: by eekc4 with SMTP id c4so17031020eek.19
        for <linux-media@vger.kernel.org>; Wed, 04 Jan 2012 14:06:17 -0800 (PST)
Message-ID: <4F04CD55.2000500@gmail.com>
Date: Wed, 04 Jan 2012 23:06:13 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun, Kim" <riverful.kim@samsung.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans de Goede <hdegoede@redhat.com>,
	Luca Risolia <luca.risolia@studio.unibo.it>
Subject: Re: [RFC PATCH 1/4] v4l: Add V4L2_CID_PRESET_WHITE_BALANCE menu control
References: <1325053428-2626-1-git-send-email-riverful.kim@samsung.com> <4F007DED.4070201@gmail.com> <20120104203933.GJ9323@valkosipuli.localdomain> <201201042157.17040.laurent.pinchart@ideasonboard.com> <4F04C394.5050302@iki.fi>
In-Reply-To: <4F04C394.5050302@iki.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/04/2012 10:24 PM, Sakari Ailus wrote:
>>>>> I don't quite understand the purpose of the do_white_balance; the
>>>>> automatic white balance algorithm is operational until it's disabled,
>>>>> and after disabling it the white balance shouldn't change. What is the
>>>>> extra functionality that the do_white_balance control implements?
>>>>
>>>> Maybe DO_WHITE_BALANCE was inspired by some hardware's behaviour, I don't
>>>> know. I have nothing against this control. It allows you to perform
>>>> one-shot white balance in a given moment in time. Simple and clear.
>>>
>>> Well, yes, if you have an automatic white balance algorithm which supports
>>> "one-shot" mode. Typically it's rather a feedback loop. I guess this means
>>> "just run one iteration".
>>>
>>> Something like this should possibly be used to get the white balance
>>> correct by pointing the camera to an object of known colour (white
>>> typically, I think). But this isn't it, at least based on the description
>>> in the spec.
>>
>> Then either the spec is incorrect, or I'm mistaken. My understanding of the
>> DO_WHITE_BALANCE control is exactly what you described.
> 
> This is what the spec says:
> 
> "This is an action control. When set (the value is ignored), the device will do
> a white balance and then hold the current setting. Contrast this with the
> boolean V4L2_CID_AUTO_WHITE_BALANCE, which, when activated, keeps adjusting the
> white balance."
> 
> I wonder if that should be then changed --- or is it just me who got a different
> idea from the above description?

Only you ? :-) Same as Laurent, I understood this control can be used to do white
balance after pointing camera to a white object. Not sure if the description
needs to be changed.

> My understanding is that the operation for getting the white balance information
> from a white object is by far simpler than getting the white balance correct
> without that.
> 
> These seem to be only two references to this control in drivers and both drivers
> are grossly misusing it. On one of them the description is "white balance
> background: blue" and on the other it's "night mode".
> 
> That makes me wonder in what kind of circumstances this control was originally
> introduced. Whatever it was, it seems to have taken place before 16th April in
> 2005. :-)
> 
> I think we could change the description to something more suitable or just
> remove this one...

Why remove it ? It's a useful control. And the abuses at the drivers is different
story.

-- 
Regards,
Sylwester
