Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11450 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab1HCUgl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Aug 2011 16:36:41 -0400
Message-ID: <4E39B150.40108@redhat.com>
Date: Wed, 03 Aug 2011 17:36:32 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-08-2011 16:53, Theodore Kilgore escreveu:
> 
> 
> On Wed, 3 Aug 2011, Mauro Carvalho Chehab wrote:
> 
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
>> V4L2 Spec ? ambiguities fix                              | Hans Verkuil
>> V4L2 compliance test results                             | Hans Verkuil
>> Media Controller presentation (probably for Wed, 25)     | Laurent Pinchart
>> Workshop summary presentation on Wed, 25                 | Mauro Carvalho Chehab
>> ---------------------------------------------------------+----------------------
>>
>> >From my side, I also have the following proposals:
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
>>
>> Thank you!
>> Mauro
> 
> Mauro,
> 
> Not saying that you need to change the program for this session to deal 
> with this topic, but an old and vexing problem is dual-mode devices. It is 
> an issue which needs some kind of unified approach, and, in my opinion, 
> consensus about policy and methodology.
> 
> As a very good example if this problem, several of the cameras that I have 
> supported as GSPCA devices in their webcam modality are also still cameras 
> and are supported, as still cameras, in Gphoto. This can cause a collision 
> between driver software in userspace which functions with libusb, and on 
> the other hand with a kernel driver which tries to grab the device.
> 
> Recent attempts to deal with this problem involve the incorporation of 
> code in libusb which disables a kernel module that has already grabbed the 
> device, allowing the userspace driver to function. This has made life a 
> little bit easier for some people, but not for everybody. For, the device 
> needs to be re-plugged in order to re-activate the kernel support. But 
> some of the "user-friencly" desktop setups used by some distros will 
> automatically start up a dual-mode camera with a gphoto-based program, 
> thereby making it impossible for the camera to be used as a webcam unless 
> the user goes for a crash course in how to disable the "feature" which has 
> been so thoughtfully (thoughtlessly?) provided. 
> 
> As the problem is not confined to cameras but also affects some other 
> devices, such as DSL modems which have a partition on them and are thus 
> seen as Mass Storage devices, perhaps it is time to try to find a 
> systematic approach to problems like this.
> 
> There are of course several possible approaches. 
> 
> 1. A kernel module should handle everything related to connecting up the 
> hardware. In that case, the existing userspace driver has to be modified 
> to use the kernel module instead of libusb. Those who support this option 
> would say that it gets everything under the control of the kernel, where 
> it belongs. OTOG, the possible result is to create a minor mess in 
> projects like Gphoto.
> 
> 2. The kernel module should be abolished, and all of its functionality 
> moved to userspace. This would of course involve difficulties 
> approximately equivalent to item 1. An advantage, in the eyes of some, 
> would be to cut down on the 
> yet-another-driver-for-yet-another-piece-of-peculiar-hardware syndrome 
> which obviously contributes to an in principle unlimited increase in the 
> size of the kernel codebase. A disadvantage would be that it would create 
> some disruption in webcam support.
> 
> 3. A further modification to libusb reactivates the kernel module 
> automatically, as soon as the userspace app which wanted to access the 
> device through a libusb-based driver library is closed. This seems 
> attractive, but it has certain deficiencies as well. One of them is that 
> it can not necessarily provide a smooth and informative user experience, 
> since circumstances can occur in which something appears to go wrong, but 
> the user gets no clear message saying what the problem is. In other words, 
> it is a patchwork solution which only slightly refines the current 
> patchwork solution in libusb, which is in itself only a slight improvement 
> on the original, unaddressed problem.
> 
> 4. ???
> 
> Several people are interested in this problem, but not much progress has 
> been made at this time. I think that the topic ought to be put somehow on 
> the front burner so that lots of people will try to think of the best way 
> to handle it. Many eyes, and all that.
> 
> Not saying change your schedule, as I said. Have a nice conference. I wish 
> I could attend. But I do hope by this message to raise some general 
> concern about this problem.

That's an interesting issue. 

A solution like (3) is a little bit out of scope, as it is a pure userspace
(or a mixed userspace USB stack) solution.

Technically speaking, letting the same device being handled by either an
userspace or a kernelspace driver doesn't seem smart to me, due to:
	- Duplicated efforts to maintain both drivers;
	- It is hard to sync a kernel driver with an userspace driver,
as you've pointed.

So, we're between (1) or (2). 

Moving the solution entirely to userspace will have, additionally, the
problem of having two applications trying to access the same hardware
using two different userspace instances (for example, an incoming videoconf
call while Gphoto is opened, assuming that such videoconf call would also
have an userspace driver).

IMO, the right solution is to work on a proper snapshot mode, in kernelspace,
and moving the drivers that have already a kernelspace out of Gphoto.

That's said, there is a proposed topic for snapshot buffer management. Maybe
it may cover the remaining needs for taking high quality pictures in Kernel.

The hole idea is to allocate additional buffers for snapshots, imagining that
the camera may be streaming in low quality/low resolution, and, once snapshot
is requested, it will take one high quality/high resolution picture.

Thanks,
Mauro
