Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152Ab2E1MKt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 08:10:49 -0400
Message-ID: <4FC36B43.90703@redhat.com>
Date: Mon, 28 May 2012 09:10:43 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andy Walls <awalls@md.metrocast.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] file tree rearrangement - was: Re: [RFC PATCH 0/3] Improve
 Kconfig selection for media devices
References: <4FC24E34.3000406@redhat.com> <201205281142.20565.hverkuil@xs4all.nl> <4FC35B8E.5060102@redhat.com> <201205281345.09188.hverkuil@xs4all.nl>
In-Reply-To: <201205281345.09188.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 28-05-2012 08:45, Hans Verkuil escreveu:
> On Mon May 28 2012 13:03:42 Mauro Carvalho Chehab wrote:
>> Em 28-05-2012 06:42, Hans Verkuil escreveu:
>>> On Sun May 27 2012 22:15:08 Mauro Carvalho Chehab wrote:

<skip/>
 
>>> /media-core for the media*.c sources.
>>
>>
>> "media-core" is a very bad name, as "media" is the name of the subsystem. maybe
>> "media-ctrl-core" or something similar.
> 
> mc-core?

Ok.

<skip/>

>>> Another thing: I would move 'video grabber' away from webcams and to 'Analog TV/Video support'.
>>> And rename 'Digital TV' to 'Digital TV/Video' as well. A video grabber driver has much more to
>>> do with TV then it does with webcams.
>>
>> From the Kconfig perspective, the difference between the 3 video categories is that:
>>
>> - analog TV: tuner-core is required, and 10 other tuner drivers that are listed inside
>>   tuner core;
>>
>> - digital TV: tuners are needed, but those are either customised or auto-selected;
>>
>> - camera/grabber: no tuner is needed.
>>
>> Also, there are several professional camera devices at bttv, cx88, saa7134 and cx25821
>> that don't require tuners, and support for them can be compiled without tuner support.
>>
>> In other words, a camera driver and a grabber driver are very similar. Of course, a webcam 
>> will also require a sensor (on several drivers, the sensor is internal to the driver, so
>> no extra modules are needed). Of course, a platform camera driver will also require
>> "media controller", "subdev API", but those features are already enabled via other config options.
>>
>> So, from tuners' perspective, and from Kconfig's perspective, a video grabber is just 
>> like a professional camera driver, a cellphone camera or a webcam driver.
> 
> I would never have understood that from the menu names. In particular that 'Analog TV' implies
> a tuner. For me it could just as well imply a composite input video grabber.

(the discussion below is a little OT for file rearrangement - It belongs to the
Kconfig selection patches - I'm about to post a version 2 of it)

Can you use analog TV without a tuner? ;)

Analog TV is a clear concept for the end user: it is something that allows
tuning a channel and watch it. So, enabling this feature should enable
both functionality.

For us, this term causes some confusion as we generally use both "analog TV" and "V4L2"
to refer to the same thing.

> How about this:
> 
> 	[ ] Video (aka V4L2) support

DVB is also video. Also Radio is also V4L2 support. So, this seems confusing.

> 	[ ] Digital TV Tuner (aka DVB) support

On both above, I don't like the idea of using an acronym, as it limits the
scope. 

DVB, btw, is a bad name for the user interface, as users with other
digital standards like ATSC may not select it, as they don't have 
"DVB" standard.

Also, calling it as "tuner" also limits the scope and, worse than that, enforces
the idea to the user to call the entire device as "tuner" (ok, some manufacturers
do that, but, for us, when someone reports a problem at the tuner, we genrally think
about the PLL, and not about the entire device).

> 	[ ] Analog TV Tuner support
> 	[ ] Radio Tuner/Modulator support
> 	[ ] Remote Controller support
> 
> I didn't like the term 'Webcams and video grabbers' as that description is never 100%.
> The help text can clarify this in more detail, of course.

At version 2, I renamed it to: "Cameras/video grabbers support". Maybe we can use
"video capture devices" instead of "video grabbers" to be even more clearer.

Regards,
Mauro

