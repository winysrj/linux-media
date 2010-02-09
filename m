Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab0BIPKv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Feb 2010 10:10:51 -0500
Message-ID: <4B717AD3.4050500@redhat.com>
Date: Tue, 09 Feb 2010 13:10:11 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-pm@lists.linux-foundation.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: Re: [PATCH/RESEND] soc-camera: add runtime pm support for    subdevices
References: <Pine.LNX.4.64.1002081044150.4936@axis700.grange>    <4B7012D1.40605@redhat.com>    <Pine.LNX.4.64.1002081447020.4936@axis700.grange>    <4B705216.7040907@redhat.com>    <Pine.LNX.4.64.1002091053470.4585@axis700.grange>    <26fe28e3dda70da4d133a9dbc3f2bc74.squirrel@webmail.xs4all.nl>    <Pine.LNX.4.64.1002091252530.4585@axis700.grange>    <2aa8130b9fd7fe9f9fb2cf626ff58831.squirrel@webmail.xs4all.nl>    <4B715CEB.1070602@redhat.com> <0c196b926b744e04a94850d4d3b1e029.squirrel@webmail.xs4all.nl>
In-Reply-To: <0c196b926b744e04a94850d4d3b1e029.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> Hans Verkuil wrote:

>>> But if you have ideas to improve the core to make it easier to add pm
>>> support to the drivers that need it, then I am all for it.
>> IMO, the runtime pm should be supported at V4L core, but some callbacks
>> are
>> needed. Also, I can see some classes of PM at the core:
>>
>> 	TV standard demod and sensors only need to be powerup when streaming.
> 
> Definitely not the demod: that's generally used to detect whether there is
> a TV signal and what audio format is used. You want that also when not
> streaming. I guess it can be powered down though when no files are open.

This is device-specific: on some devices, the tuner provides the info (and
even decode the audio carrier). Also, on some modes (e. g. radio), the demod 
may be turned off.

>> So, I think that we'll need some callbacks to the drivers, in order to do
>> the
>> power management on the applicable components. The final action should be
>> at
>> the driver level, but supported by the core.
> 
> I guess the essential information is:
> 
> 1) is someone using the driver (i.e. is a device node open, which is not
> necessarily limited to v4l2-type device nodes)?
> 2) are we actively streaming from or to some particular input or output?
> 
> And we probably need some easy way to detect and set the powersaving state
> for each component (subdev or the main v4l2_device).

krefs can be a good alternative to check device usage and enable powersaving,
but we'll need some callbacks to save/restore chip register values per dev/subdev.
> 
> I really need to research the pm stuff...
> 
> Regards,
> 
>          Hans
> 
>>> Regards,
>>>
>>>         Hans
>>>
>>>> Thanks
>>>> Guennadi
>>>> ---
>>>> Guennadi Liakhovetski, Ph.D.
>>>> Freelance Open-Source Software Developer
>>>> http://www.open-technology.de/
>>>>
>>>
>>
>> --
>>
>> Cheers,
>> Mauro
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 
> 


-- 

Cheers,
Mauro
