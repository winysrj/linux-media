Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab1HJHA3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 03:00:29 -0400
Message-ID: <4E422CFC.3000705@redhat.com>
Date: Wed, 10 Aug 2011 09:02:20 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Adam Baker <linux@baker-net.org.uk>, workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu> <4E40E20C.2090001@redhat.com> <alpine.LNX.2.00.1108091138070.23136@banach.math.auburn.edu> <4E4198D2.8070104@redhat.com> <alpine.LNX.2.00.1108091825160.23684@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108091825160.23684@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/10/2011 02:34 AM, Theodore Kilgore wrote:
>
>

<snip>

>> but this is the way how
>> the current discussion feels to me. If we agree on aiming for
>> "doing it right" then with that comes to me doing a software
>> design from scratch, so without taking into account what is
>> already there.
>
> Here, a counter-argument is to point out, as I did in a mail earlier this
> afternoon, that "without taking account what is already there" might
> possibly let one overlook something important. And, no, I am not referring
> to the userspace-kernelspace problem with this. I am referring to the fact
> that simply to dump the entire contents of the camera "into cache" (and to
> keep it there for quite a while) might not necessarily be a good idea and
> it had been quite consciously rejected to do that in the design of
> libgphoto2. Not because it is in userspace, but because to do that eats
> up and ties up RAM of which one cannot assume there is a surplus.

This is an implementation detail which has little to do with the fundamental
choice of whether or not we want 2 separate drivers or 1 single driver.

In part of the snipped message you called me impatient (no offense taken),
my perceived impatience is stemming from what to me feels like we are dancing
around the real issue here. The fundamental question is do we want 2 separate
drivers or 1 single driver for these devices.

Lets answer that first, using all we've learned from the past. But without
taking into account that one choice or the other will involve re-doing lots
of code, as to me that is a poor argument from a technical pov.

<snip>

>> There are of course limits to the from scratch part, in the
>> end we want this to slot into the existing Linux practices
>> for webcams and stillcams, which means:
>> 1) offering a v4l2 /dev/video# node for streaming; and
>> 2) access to the pictures stored on the camera through libgphoto
>>
>> Taking these 2 constrictions into account, and combining that
>> with my firm believe that the solution to all the device sharing
>> problems is handling both functions in a single driver, I end
>> up with only 1 option:
>>
>> Have a kernel driver which provides both functions of the device,
>> with the streaming exported as a standard v4l2 device, and the
>> stillcam function exported with some to be defined API. Combined
>> with a libgphoto2 portlib and camlib for this new API, so that
>> existing libgphoto2 apps can still access the pictures as if
>> nothing was changed.
>
> Well, what I _do_ think is that we need to agree about precisely what is
> supposed to work and what is not, in an operational sense. But we are
> still fuzzy about that. For example, you seemed to assert this morning
> that the webcam functionality needs to be able to preempt any running
> stillcam app and to grab the camera. Why? Or did I misunderstand you?

You've misunderstood me. We need to distinguish between an application
having a tie to the device (so having a fd open) and the application
doing an actual operation on the device.

No application should be able to pre-empt an ongoing operation by
another application. Attempting an operation while another operation
is ongoing should result in -EBUSY.

This differs significantly from what we've currently where:
1) There is no distinguishing going on between an app having a tie and
an app actually doing an operation. Only one app can have a fd open

2) Some apps (userspace apps) can pre-empt other apps, taking away
their fd and cancelling any ongoing operations

The above is what leads me to me still firm believe that having
a single driver is the only solution. My reasoning is as follows

1) We cannot count on apps closing the fd when they have no immediate
use for the device, iow open != in-use

2) Thus we need to allow both libgphoto2 and v4l2 apps to have the device
open at the same time

3) When actual in-use (so an operation is ongoing) attempt by another apps
to start an operation will result in -EBUSY

4) 2 + 3 can only be realized by having a single driver

Regards,

Hans
