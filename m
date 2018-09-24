Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:41989 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726139AbeIXXoc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Sep 2018 19:44:32 -0400
Subject: Re: [ANN] Draft Agenda for the media summit on Thursday Oct 25th in
 Edinburgh
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <9ee40db8-244b-c019-be7d-39925e87bf6f@xs4all.nl>
 <20180924141228.10227b1d@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <12eb26b5-a701-68d9-b81b-576812ff7169@xs4all.nl>
Date: Mon, 24 Sep 2018 19:41:13 +0200
MIME-Version: 1.0
In-Reply-To: <20180924141228.10227b1d@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/24/2018 07:12 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 24 Sep 2018 16:42:13 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi all,
>>
>> We are organizing a media mini-summit on Thursday October 25th in
>> Edinburgh, Edinburgh International Conference Centre.
>>
>> If you plan to attend, please let Mauro know. It is open for all, but
>> we have a limited number of seats.
> 
> No need to let me explicitly know in advance, but be sure to register for
> it at the ELCE/OSS register site. I'll use their tracking system to
> know who will be there. We have a limited number of seats there, and
> I'm relying on their system to control the number of attendees for
> us.

Do you have a link of where to register? How many registrations do we have now?

Regards,

	Hans

> 
>>
>> Name of the room for the summit: TBD
> 
> I'll get the room name with the event organizers and post it later
> on this thread.
> 
>>
>> Currently known attendees (please add/remove names as needed):
>>
>> Sakari Ailus <sakari.ailus@iki.fi>
>> Mauro Carvalho Chehab <mchehab@s-opensource.com>
>> Ezequiel Garcia <ezequiel@collabora.com>
>> Michael Ira Krufky <mkrufky@linuxtv.org>
>> Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>> Hans Verkuil <hverkuil@xs4all.nl>
>> Sean Young <sean@mess.org>
>>
>> Agenda (First draft!)
>> =====================
>>
>> General remarks: the given start/end times for the various topics are
>> approximate since it is always hard to predict how long a discussion will take.
>> If people are attending other summits and those conflict with specific media
>> topics they want to be part of, then let me know and we can rearrange the
>> schedule to (hopefully) accommodate that.
>>
>> 9:00-9:15: Introduction (Hans Verkuil)
>>
>> 9:15-9:30: Status of the HDMI CEC kernel support (Hans Verkuil)
>> 	Give a quick overview of the status: what has been merged, what is
>> 	still pending, what is under development.
>>
>> 9:30-9:45: Save/restore controls from MTD (Ricardo Ribalda Delgado)
>> 	Industrial/Scientific sensors usually come with very extensive
>> 	calibration information such as: per column gain, list of dead
>> 	pixels, temperature sensor offset... etc
>>
>> 	We are saving that information on an flash device that is located
>> 	by the sensor.
>>
>> 	Show how we are integrating that calibration flash with v4l2-ctrl.
>> 	And if this feature is useful for someone else and upstream it.
>>
>> 9:45-11:00: Complex Cameras (Mauro Carvalho Chehab)
>> 	I expect that we could have something to discuss there about complex
>> 	cameras. So, I'd reserve a 50 mins slot for it.
>>
>> 	The idea is to discuss about the undergoing work with complex camera
>> 	development is happening.
>>
>> 	As we're working to merge request API, another topic for discussion
>> 	is how to add support for requests on it (or on a separate but related
>> 	library).
>>
>> 11:00-11:15: Break
>>
>> 11:15-12:00: Automated Testing (Ezequiel Garcia)
>> 	There is a lot of discussion going on around testing,
>> 	so it's a good opportunity for us to talk about our
>> 	current testing infrastructure.
>>
>> 	We are already doing a good job with v4l2-compliance.
>> 	Can we do more?
>>
>> Lunch
>>
>> 13:30-14:30: Stateless Codec userspace (Hans Verkuil)
>> 	Support for stateless codecs and Request API should be merged for
>> 	4.20, and the next step is to discuss how to organize the userspace
>> 	support.
>>
>> 	Hopefully by the time the media summit starts we'll have some better
>> 	ideas of what we want in this area.
>>
>> 14:30-15:15: Which ioctls should be replaced with better versions? (Hans Verkuil)
>> 	Some parts of the V4L2 API are awkward to use and I think it would be
>> 	a good idea to look at possible candidates for that.
>>
>> 	Examples are the ioctls that use struct v4l2_buffer: the multiplanar support is
>> 	really horrible, and writing code to support both single and multiplanar is hard.
>> 	We are also running out of fields and the timeval isn't y2038 compliant.
>>
>> 	A proof-of-concept is here:
>>
>> 	https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=v4l2-buffer&id=a95549df06d9900f3559afdbb9da06bd4b22d1f3
>>
>> 	It's a bit old, but it gives a good impression of what I have in mind.
>>
>> 	Another candidate is VIDIOC_SUBDEV_ENUM_FRAME_INTERVAL/VIDIOC_ENUM_FRAMEINTERVALS:
>> 	expressing frame intervals as a fraction is really awkward and so is the fact
>> 	that the subdev and 'normal' ioctls are not the same.
>>
>> 	Discuss what possible other ioctls are candidates for a refresh.
>>
>> 15:15-15:30: Break
>>
>> 15:30-16:00: Discuss the media development process
>> 	Since we are all here, discuss any issues there may be with the media
>> 	subsystem development process. Anything to improve?
>>
>> 16:00-16:15: Wrap up
>> 	Create action items (and who will take care of them) if needed.
>> 	Summarize and conclude the day.
>>
>> End of the day: Key Signing Party
>>
>> Regards,
>>
>> 	Hans
> 
> 
> 
> Thanks,
> Mauro
> 
