Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab0BINDR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 08:03:17 -0500
Message-ID: <4B715CEB.1070602@redhat.com>
Date: Tue, 09 Feb 2010 11:02:35 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for   subdevices
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>    <4B7012D1.40605@redhat.com>    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>    <4B705216.7040907@redhat.com>    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>    <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>    <Pine.LNX.4.64.1002091252530.4585@axis700.grange> <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>
In-Reply-To: <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> On Tue, 9 Feb 2010, Hans Verkuil wrote:
>>
>>>> On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
>>>>
>>>>> In fact, on all drivers, there are devices that needs to be turn on
>>> only
>>>>> when
>>>>> streaming is happening: sensors, analog TV/audio demods, digital
>>> demods.
>>>>> Also,
>>>>> a few devices (for example: TV tuners) could eventually be on power
>>> off
>>>>> when
>>>>> no device is opened.
>>>>>
>>>>> As the V4L core knows when this is happening (due to
>>>>> open/close/poll/streamon/reqbuf/qbuf/dqbuf hooks, I think the runtime
>>>>> management
>>>>> can happen at V4L core level.
>>>> Well, we can move it up to v4l core. Should it get any more
>>> complicated
>>>> than adding
>>>>
>>>> 	ret = pm_runtime_resume(&vdev->dev);
>>>> 	if (ret < 0 && ret != -ENOSYS)
>>>> 		return ret;
>>>>
>>>> to v4l2_open() and
>>>>
>>>> 	pm_runtime_suspend(&vdev->dev);
>>>>
>>>> to v4l2_release()?
>>> My apologies if I say something stupid as I know little about pm: are
>>> you
>>> assuming here that streaming only happens on one device node? That may
>>> be
>>> true for soc-camera, but other devices can have multiple streaming nodes
>>> (video, vbi, mpeg, etc). So the call to v4l2_release does not
>>> necessarily
>>> mean that streaming has stopped.
>> Of course you're right, and it concerns not only multiple streaming modes,
>> but simple cases of multiple openings of one node. I was too fast to
>> transfer the implementation from soc-camera to v4l2 - in soc-camera I'm
>> counting opens and closes and only calling pm hooks on first open and last
>> close. So, if we want to put it in v4l-core, we'd have to do something
>> similar, I presume.
> 
> I wouldn't mind having such counters. There are more situations where
> knowing whether it is the first open or last close comes in handy.

A simple count for an open bind to one device node is not enough, since you
may have just one open for /dev/radio and just one open for /dev/video, but
if /dev/radio is closed, it doesn't mean that you can safely power down it,
as /dev/video is still open.

Yet, I think it is doable.

> However, in general I think that pm shouldn't be done in the core. It is
> just too hardware dependent. E.g. there may both capture and display video
> nodes in the driver. And when the last capture stops you can for example
> power down the receiver chips. The same with display and transmitter
> chips. But if both are controlled by the same driver, then a general open
> counter will not work either.
> 
> But if you have ideas to improve the core to make it easier to add pm
> support to the drivers that need it, then I am all for it.

IMO, the runtime pm should be supported at V4L core, but some callbacks are
needed. Also, I can see some classes of PM at the core:

	TV standard demod and sensors only need to be powerup when streaming.
So, if someone is just opening the device to set some configuration, the config
may be stored on a shadow register but the real device may keep on powerdown state.

	On the other hand, the TV tuner may be needed if someone is, for example,
scanning the channels. Depending on the device, the other components like tv and 
audio demod may be in powerdown state.

So, I think that we'll need some callbacks to the drivers, in order to do the
power management on the applicable components. The final action should be at
the driver level, but supported by the core.

> 
> Regards,
> 
>         Hans
> 
>> Thanks
>> Guennadi
>> ---
>> Guennadi Liakhovetski, Ph.D.
>> Freelance Open-Source Software Developer
>> http://www.open-technology.de/
>>
> 
> 


-- 

Cheers,
Mauro
