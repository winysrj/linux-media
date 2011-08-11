Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1HKLDs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2011 07:03:48 -0400
Message-ID: <4E43B703.5060401@redhat.com>
Date: Thu, 11 Aug 2011 08:03:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <20110811101638.GE5926@valkosipuli.localdomain>
In-Reply-To: <20110811101638.GE5926@valkosipuli.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 11-08-2011 07:16, Sakari Ailus escreveu:
> 
> Hi Mauro,
> 
> On Wed, Aug 03, 2011 at 02:21:05PM -0300, Mauro Carvalho Chehab wrote:
>> As already announced, we're continuing the planning for this year's 
>> media subsystem workshop.
>>
>> To avoid overriding the main ML with workshop-specifics, a new ML
>> was created:
>> 	workshop-2011@linuxtv.org
>>
>> I'll also be updating the event page at:
>> 	http://www.linuxtv.org/events.php
>>
>> Over the one-year period, we had 242 developers contributing to the
>> subsystem. Thank you all for that! Unfortunately, the space there is
>> limited, and we can't affort to have all developers there. 
>>
>> Due to that some criteria needed to be applied to create a short list
>> of people that were invited today to participate. 
>>
>> The main criteria were to select the developers that did significant 
>> contributions for the media subsystem over the last 1 year period, 
>> measured in terms of number of commits and changed lines to the kernel
>> drivers/media tree.
>>
>> As the used criteria were the number of kernel patches, userspace-only 
>> developers weren't included on the invitations. It would be great to 
>> have there open source application developers as well, in order to allow 
>> us to tune what's needed from applications point of view. 
>>
>> So, if you're leading the development of some V4L and/or DVB open-source 
>> application and wants to be there, or you think you can give good 
>> contributions for helping to improve the subsystem, please feel free 
>> to send us an email.
>>
>> With regards to the themes, we're received, up to now, the following 
>> proposals:
>>
>> ---------------------------------------------------------+----------------------
>> THEME                                                    | Proposed-by:
>> ---------------------------------------------------------+----------------------
>> Buffer management: snapshot mode                         | Guennadi
>> Rotation in webcams in tablets while streaming is active | Hans de Goede
>> V4L2 Spec ??? ambiguities fix                              | Hans Verkuil
>> V4L2 compliance test results                             | Hans Verkuil
>> Media Controller presentation (probably for Wed, 25)     | Laurent Pinchart
>> Workshop summary presentation on Wed, 25                 | Mauro Carvalho Chehab
>> ---------------------------------------------------------+----------------------
>>
>> From my side, I also have the following proposals:
>>
>> 1) DVB API consistency - what to do with the audio and video DVB API's 
>> that conflict with V4L2 and (somewhat) with ALSA?
>>
>> 2) Multi FE support - How should we handle a frontend with multiple 
>> delivery systems like DRX-K frontend?
>>
>> 3) videobuf2 - migration plans for legacy drivers
>>
>> 4) NEC IR decoding - how should we handle 32, 24, and 16 bit protocol
>> variations?
>>
>> Even if you won't be there, please feel free to propose themes for 
>> discussion, in order to help us to improve even more the subsystem.
> 
> Drawing from our recent discussions over e-mail, I would like to add another
> topic: the V4L2 on desktop vs. embedded systems.

Topic added to:
	http://www.linuxtv.org/events.php

> The V4L2 is being used as an application interface on desktop systems, but
> recently as support has been added to complex camera ISPs in embedded
> systems it is used for a different purpose: it's a much lower level
> interface for specialised user space which typically contains a middleware
> layer which provides its own application interface (e.g. GSTphotography).
> The V4L2 API in the two different kind of systems is exactly the same but
> its role is different: the hardware drivers are not up to offering an
> interface suitable for the use by general purpose applications.
> 
> To run generic purpose applications on such embedded systems, I have
> promoted the use of libv4l (either plain or with plugins) to provide what is
> missing from between the V4L2, Media controller and v4l2_subdev interfaces
> provided by kernel drivers --- which mostly allow controlling the hardware
> --- and what the general purpose applications need. Much of the missing
> functionality is usually implemented in algorithm frameworks and libraries
> that do not fit to kernel space: they are complex and often the algorithms
> themselves are under very restrictive licenses. There is an upside: the
> libv4l does contain an automatic exposure and a white balance algorithm
> which are suitable for some use cases.
> 
> Defining functionality suitable for general purpose applications at the
> level of V4L2 requires scores of policy decisions on embedded systems. One
> of the examples is the pipeline configuration for which the Media controller
> and v4l2_subdev interfaces are currently being used for. Applications such
> as Fcam <URL:http://fcam.garage.maemo.org/> do need to make these policy
> decisions by themselves. For this reason, I consider it highly important
> that the low level hardware control interface is available to the user space
> applications.
> 
> I think it is essential for the future support of such embedded devices in
> the mainline kernel to come to a common agreement on how this kind of
> systems should be implemented in a way that everyone's requirements are best
> taken into account. I believe this is in everyone's interest.

Since we start moving with MC API, I was afraid that we'll end by needing to
differentiate between a typical consumer hardware driver and a SoC specialized
hardware for embedded systems.

I remember I mentioned that a few times either at the ML and/or on some face to
face meetings.

That likely means that we'll need to create some profiles at the V4L2 spec, meant
to cover what API's should be implemented by each device type, and how libv4l
should be used.

While this is not written anywhere, except at the source code, but currently, 
we have several profiles already, adopted by most of the drivers. 

On very short terms, we have:

1) Radio devices: Simplest API: don't implement any streaming API nor any
   video-specific ioctl.
2) TV grabber: radio profile + streaming API + video ioctl's + ALSA API;
3) Webcams: TV grabber profile + libv4l for proprietary FOURCC formats;
4) TV tuners: TV grabber profile + tuner ioctl's + Remote Controller API;
5) Embedded cameras: Webcams + MC API.

A few devices don't fit on the above, as they use a few more things. For example,
pvrusb2 uses streaming ioctl's for radio, as it provides a MPEG streaming
with the audio channels.

In other words, I think that we should add a table at the V4L2 spec, mapping
each possible ioctl for the available API's to each possible device type.

Something like:

----------------+---------------+---------------+---------------+---------------+----------------
IOCTL/API	| RADIO		| TV GRABBER	| WEB CAM	| TV TUNER	| EMBEDDED CAMERA
----------------+---------------+---------------+---------------+---------------+----------------
VIDIOC_QUERYCAP | Mandatory	| Mandatory	| Mandatory	| Mandatory	| Mandatory
VIDIOC_G_TUNER	| Mandatory	| No		| No		| Mandatory	| No
ALSA API	| Optional	| Optional	| Optional	| Optional	| Optional
...
----------------+---------------+---------------+---------------+---------------+----------------

As unimplemented ioctl's will return -ENOTTY since kernel 3.1, it will be easier for applications 
to detect the device type based on that and to work accordingly.

A similar table will likely be needed, in order to map what controls are recommended for 
each device type.

Maybe the spec should also give a hint about where certain controls should be implemented: at the 
sensor, at the bridge/DSP block or software-emulated in libv4l, when the hardware doesn't have
direct support for it.

Regards,
Mauro
