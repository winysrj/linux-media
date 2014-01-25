Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3773 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaAYJAz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Jan 2014 04:00:55 -0500
Message-ID: <52E37D2D.1030400@xs4all.nl>
Date: Sat, 25 Jan 2014 10:00:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Hans Verkuil <hansverk@cisco.com>, linux-media@vger.kernel.org,
	m.chehab@samsung.com, laurent.pinchart@ideasonboard.com,
	t.stanislaws@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 02/21] v4l2-ctrls: add unit string.
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl> <1390221974-28194-3-git-send-email-hverkuil@xs4all.nl> <20140124103519.GA13820@valkosipuli.retiisi.org.uk> <52E24C42.6020103@cisco.com> <20140124155432.GF13820@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140124155432.GF13820@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 01/24/2014 04:54 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Jan 24, 2014 at 12:19:30PM +0100, Hans Verkuil wrote:
>> On 01/24/2014 11:35 AM, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> Thanks for the patchset!
>>>
>>> On Mon, Jan 20, 2014 at 01:45:55PM +0100, Hans Verkuil wrote:
>>>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>>>> index 0b347e8..3998049 100644
>>>> --- a/include/media/v4l2-ctrls.h
>>>> +++ b/include/media/v4l2-ctrls.h
>>>> @@ -85,6 +85,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>>>>    * @ops:	The control ops.
>>>>    * @id:	The control ID.
>>>>    * @name:	The control name.
>>>> +  * @unit:	The control's unit. May be NULL.
>>>>    * @type:	The control type.
>>>>    * @minimum:	The control's minimum value.
>>>>    * @maximum:	The control's maximum value.
>>>> @@ -130,6 +131,7 @@ struct v4l2_ctrl {
>>>>  	const struct v4l2_ctrl_ops *ops;
>>>>  	u32 id;
>>>>  	const char *name;
>>>> +	const char *unit;
>>>
>>> What would you think of using a numeric value (with the standardised units
>>> #defined)? I think using a string begs for unmanaged unit usage. Code that
>>> deals with units might work with one driver but not with another since it
>>> uses a slightly different string for unit x.
>>
>> First of all, you always need a string. You don't want GUIs like qv4l2 to have
>> to switch on a unit in order to generate the unit strings. That's impossible to
>> keep up to date.
> 
> That's true when when you want to show that to the user, yes. But when you
> have an application which tries to figure out which value to put to the
> control, a numeric value is more convenient.
> 
> Kernel interfaces seldom use strings and that's for a good reason.

Well, actually, the kernel is in many places moving away from IDs to strings.
Headers full of IDs are surprisingly hard to maintain.

> 
>> In addition, private controls can have really strange custom units, so you want
>> to have a string there as well.
> 
> Good point as well.
> 
>> Standard controls can have their unit string set in v4l2-ctrls.c, just as their
>> name is set there these days, thus ensuring consistency.
>>
>> What I had in mind is that videodev2.h defines a list of standardized unit strings,
>> e.g.:
>>
>> #define V4L2_CTRL_UNIT_USECS "usecs"
>> #define V4L2_CTRL_UNIT_MSECS "msecs"
> 
> That's possible as well, but requires the user to e.g. use if (strcmp())
> ... instead of just plain switch (unit) { ... }.
> 
> I'd also very much prefer to stick to SI units and prefixes where applicable
> if we end up using strings. Combining the unit and prefix could make sense.
> 
>> and apps can do strcmp(qc->unit, V4L2_CTRL_UNIT_USECS) to see what the unit is.
>> If a driver doesn't use one of those standardized unit strings, then it is a
>> driver bug.
>>
>>> A prefix could be potentially nice, too, so ms and µs would still have the
>>> same unit but a different prefix.
>>
>> Can you give an example of a prefix? I don't really follow what you want to
>> achieve.
> 
> You use them in your own example above. :-)
> 
> <URL:http://en.wikipedia.org/wiki/SI_prefix>
> 

Ah, that sort of prefix.

I don't think the prefix makes sense, for a number of reasons: first I think it
makes life even harder for applications, since they now have to factor in a SI
prefix as well. Secondly, what to do with units like km/s? There are two prefixes
there (e.g. mm/usecs is also a valid speed representation).

I think that for the initial version we just add the unit string as that is needed
anyway. There are more than enough reserved fields available to add a unit_id field
later, but frankly, I'd like to see some real-life use-cases first.

Regards,

	Hans
