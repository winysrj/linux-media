Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:60928 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628Ab1HJA3o (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 20:29:44 -0400
Date: Tue, 9 Aug 2011 19:34:44 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <hdegoede@redhat.com>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Adam Baker <linux@baker-net.org.uk>, workshop-2011@linuxtv.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
In-Reply-To: <4E4198D2.8070104@redhat.com>
Message-ID: <alpine.LNX.2.00.1108091825160.23684@banach.math.auburn.edu>
References: <4E398381.4080505@redhat.com> <4E3A91D1.1040000@redhat.com> <4E3B9597.4040307@redhat.com> <201108072353.42237.linux@baker-net.org.uk> <alpine.LNX.2.00.1108072103200.20613@banach.math.auburn.edu> <4E3FE86A.5030908@redhat.com>
 <alpine.LNX.2.00.1108081208080.21409@banach.math.auburn.edu> <4E40E20C.2090001@redhat.com> <alpine.LNX.2.00.1108091138070.23136@banach.math.auburn.edu> <4E4198D2.8070104@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On Tue, 9 Aug 2011, Hans de Goede wrote:

> Hi,
> 
> On 08/09/2011 07:10 PM, Theodore Kilgore wrote:
> > 
> > 
> > On Tue, 9 Aug 2011, Hans de Goede wrote:
> 
> <snip>
> 
> > No, but both Adam and I realized, approximately at the same time
> > yesterday afternoon, something which is rather important here. Gphoto is
> > not developed exclusively for Linux. Furthermore, it has a significant
> > user base both on Windows and on MacOS, not to mention BSD. It really
> > isn't nice to be screwing around too much with the way it works.
> 
> Right, so my plan is not to rip out the existing camlibs from libgphoto2,
> but to instead add a new camlib which talks to /dev/video# nodes which
> support the new to be defined v4l2 API for this. This camlib will then
> take precedence over the old libusb based ones when running on a system
> which has a new enough kernel. On systems without the new enough kernel
> the matching portdriver won't find any ports, so the camlib will be
> effectively disabled. 

And then, I assume you mean, the old camlib will still work.

On BSD the port driver for this new /dev/video#
> API and the camlib won't even get compiled.
> 
> <snip>
> 
> > > It is time to quit thinking in band-aides and solve this properly,
> > > 1 logical device means it gets 1 driver.
> > > 
> > > This may be an approach which means some more work then others, but
> > > I believe in the end that doing it right is worth the effort.
> > 
> > Clearly, we agree about "doing it right is worth the effort." The whole
> > discussion right now is about what is "right."
> 
> I'm sorry but I don't get the feeling that the discussion currently is
> focusing on what is "right". 

You are very impatient. 

> To me too much attention is being spend
> on not throwing away the effort put in the current libgphoto2 camlibs,
> which I don't like for 2 reasons:
> 1) It distracts from doing what is right
> 2) It ignores the fact that a lot has been learned in doing those
> camlibs, really really a lot. and all that can be re-used in a kernel
> driver.

Note that your two items can contradict or cancel each other out if one is 
not careful?

> 
> Let me try to phrase it in a way I think you'll understand. If we
> agree on doing it right over all other things (such as the fact
> that doing it right may take a considerable effort). Then this
> could be an interesting assignment for some of the computer science
> students I used to be a lecturer for. This assignment could read
> something like "Given the existing situation and knowledge <
> describe all that here>, do a re-design for the driverstack
> for these dual mode cameras, assuming a completely fresh start".
> 
> Now if I were to give this assignment to a group of students, and
> they would keep coming back with the "but re-doing the camlibs
> in kernelspace is such a large effort, and we already have
> them in userspace" argument against using one unified driver
> for these devices, I would give them an F, because they are
> clearly missing the "assuming a completely fresh start"
> part of the assignment.


Well, for one thing, Hans, we do not have here any instructor who is 
giving us an assignment. And nobody is in the position to specify that the 
assignment says "assuming a completely fresh start" -- unless Linus 
happens to be reading this thread and chimes in. Otherwise, unless there 
is a convincing demonstration that "assuming a completely fresh start" is 
an absolute and unavoidable necessity, someone is probably going to 
disagree. 

> 
> I'm sorry if this sounds a bit harsh, 

Yes, I am sorry about that, too.

but this is the way how
> the current discussion feels to me. If we agree on aiming for
> "doing it right" then with that comes to me doing a software
> design from scratch, so without taking into account what is
> already there.

Here, a counter-argument is to point out, as I did in a mail earlier this 
afternoon, that "without taking account what is already there" might 
possibly let one overlook something important. And, no, I am not referring 
to the userspace-kernelspace problem with this. I am referring to the fact 
that simply to dump the entire contents of the camera "into cache" (and to 
keep it there for quite a while) might not necessarily be a good idea and 
it had been quite consciously rejected to do that in the design of 
libgphoto2. Not because it is in userspace, but because to do that eats 
up and ties up RAM of which one cannot assume there is a surplus.

Do not misunderstand, though. I am not even going so far as to say that 
libgphoto2 made the right decision. It certainly has its drawbacks, in 
that it places severe requirements on someone programming a driver for 
a really stupid camera. But what I *am* saying is that the issue was 
anticipated, the issue was faced, and a conscious decision was made. This 
is the opposite of not anticipating, not facing an issue, and not making 
any conscious decision. 

Oh, another example of such lack of deep thought has produced the current 
crisis, too. I am referring to the amazing decision of some user interface 
designers that an app for downloading still photos has to be fired up 
immediately, just as soon as the "still camera" is plugged in. I would 
really hate to be a passenger in a sailboat piloted by one of those guys.
But, hey, nobody is perfect.

> 
> There are of course limits to the from scratch part, in the
> end we want this to slot into the existing Linux practices
> for webcams and stillcams, which means:
> 1) offering a v4l2 /dev/video# node for streaming; and
> 2) access to the pictures stored on the camera through libgphoto
> 
> Taking these 2 constrictions into account, and combining that
> with my firm believe that the solution to all the device sharing
> problems is handling both functions in a single driver, I end
> up with only 1 option:
> 
> Have a kernel driver which provides both functions of the device,
> with the streaming exported as a standard v4l2 device, and the
> stillcam function exported with some to be defined API. Combined
> with a libgphoto2 portlib and camlib for this new API, so that
> existing libgphoto2 apps can still access the pictures as if
> nothing was changed.

Well, what I _do_ think is that we need to agree about precisely what is 
supposed to work and what is not, in an operational sense. But we are 
still fuzzy about that. For example, you seemed to assert this morning 
that the webcam functionality needs to be able to preempt any running 
stillcam app and to grab the camera. Why? Or did I misunderstand you?

Then after we (and everybody else with an interest in the matter) have 
settled on precisely how the outcome is supposed to behave, we need to 
take a couple of test cases. Probably the best would be to, get some 
people to look at one driver and see if anything can be done to make that 
driver work better, using either Plan A or Plan B, or, for that matter, 
Plan C.


Theodore Kilgore
