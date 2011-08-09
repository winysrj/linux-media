Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1HIU2S (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Aug 2011 16:28:18 -0400
Message-ID: <4E4198D2.8070104@redhat.com>
Date: Tue, 09 Aug 2011 22:30:10 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Adam Baker <linux@baker-net.org.uk>, workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com> <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu> <4E40E20C.2090001@redhat.com> <alpine.LNX.2.00.1108091138070.23136@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1108091138070.23136@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 08/09/2011 07:10 PM, Theodore Kilgore wrote:
>
>
> On Tue, 9 Aug 2011, Hans de Goede wrote:

<snip>

> No, but both Adam and I realized, approximately at the same time
> yesterday afternoon, something which is rather important here. Gphoto is
> not developed exclusively for Linux. Furthermore, it has a significant
> user base both on Windows and on MacOS, not to mention BSD. It really
> isn't nice to be screwing around too much with the way it works.

Right, so my plan is not to rip out the existing camlibs from libgphoto2,
but to instead add a new camlib which talks to /dev/video# nodes which
support the new to be defined v4l2 API for this. This camlib will then
take precedence over the old libusb based ones when running on a system
which has a new enough kernel. On systems without the new enough kernel
the matching portdriver won't find any ports, so the camlib will be
effectively disabled. On BSD the port driver for this new /dev/video#
API and the camlib won't even get compiled.

<snip>

>> It is time to quit thinking in band-aides and solve this properly,
>> 1 logical device means it gets 1 driver.
>>
>> This may be an approach which means some more work then others, but
>> I believe in the end that doing it right is worth the effort.
>
> Clearly, we agree about "doing it right is worth the effort." The whole
> discussion right now is about what is "right."

I'm sorry but I don't get the feeling that the discussion currently is
focusing on what is "right". To me too much attention is being spend
on not throwing away the effort put in the current libgphoto2 camlibs,
which I don't like for 2 reasons:
1) It distracts from doing what is right
2) It ignores the fact that a lot has been learned in doing those
camlibs, really really a lot. and all that can be re-used in a kernel
driver.

Let me try to phrase it in a way I think you'll understand. If we
agree on doing it right over all other things (such as the fact
that doing it right may take a considerable effort). Then this
could be an interesting assignment for some of the computer science
students I used to be a lecturer for. This assignment could read
something like "Given the existing situation and knowledge <
describe all that here>, do a re-design for the driverstack
for these dual mode cameras, assuming a completely fresh start".

Now if I were to give this assignment to a group of students, and
they would keep coming back with the "but re-doing the camlibs
in kernelspace is such a large effort, and we already have
them in userspace" argument against using one unified driver
for these devices, I would give them an F, because they are
clearly missing the "assuming a completely fresh start"
part of the assignment.

I'm sorry if this sounds a bit harsh, but this is the way how
the current discussion feels to me. If we agree on aiming for
"doing it right" then with that comes to me doing a software
design from scratch, so without taking into account what is
already there.

There are of course limits to the from scratch part, in the
end we want this to slot into the existing Linux practices
for webcams and stillcams, which means:
1) offering a v4l2 /dev/video# node for streaming; and
2) access to the pictures stored on the camera through libgphoto

Taking these 2 constrictions into account, and combining that
with my firm believe that the solution to all the device sharing
problems is handling both functions in a single driver, I end
up with only 1 option:

Have a kernel driver which provides both functions of the device,
with the streaming exported as a standard v4l2 device, and the
stillcam function exported with some to be defined API. Combined
with a libgphoto2 portlib and camlib for this new API, so that
existing libgphoto2 apps can still access the pictures as if
nothing was changed.

Regards,

Hans
