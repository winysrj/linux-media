Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbFmk-0003xy-FU
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 16:26:12 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6O001SRDEMXC80@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 04 Sep 2008 10:25:35 -0400 (EDT)
Date: Thu, 04 Sep 2008 10:25:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809012235.50974.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <48BFEFDE.7090600@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org>
	<200809012235.50974.hverkuil@xs4all.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hans Verkuil wrote:
> Hi Steve,
> 
> On Friday 29 August 2008 20:29:30 Steven Toth wrote:
>> Regarding the multiproto situation:
>>
>> A number of developers, maintainers and users are unhappy with the
>> multiproto situation, actually they've been unhappy for a considerable
>> amount of time. The linuxtv developer community (to some degree) is 
> seen
>> as a joke and a bunch in-fighting people. Multiproto is a great
>> demonstration of this. [1] The multiproto project has gone too far, 
> for
>> too long and no longer has any credibility in the eyes of many people.
>>
>> In response, a number developers have agreed that "enough is enough" 
> and
>> "it's time to take a new direction", for these developers the 
> technical,
>> political and personal cost of multiproto is too high. These 
> developers
>> have decided to make an announcement.
>>
>> Mauro Chehab, Michael Krufky, Patrick Boettcher and myself are hereby
>> announcing that we no longer support multiproto and are forming a
>> smaller dedicated project group which is focusing on adding next
>> generation S2/ISDB-T/DVB-H/DVB-T2/DVB-SH support to the kernel through 
> a 
>> different and simpler API.
>>
>> Basic patches and demo code for this API is currently available here.
>>
>> http://www.steventoth.net/linux/s2
>>
>> Does it even work? Yes
>> Is this new API complete? No
>> Is it perfect? No, we've already had feedback on structural and
>> namingspace changes that people would like to see.
>> Does it have bugs? Of course, we have a list of things we already know
>> we want to fix.
>>
>> but ...
>>
>> Is the new approach flexible? Yes, we're moving away from passing 
> fixed
>> modulation structures into the kernel.
>> Can we add to it without breaking the future ABI when unforseen
>> modulations types occur? Yes
>> Does it preserve backwards compatibility? Yes
>> Importantly, is the overall direction correct? Yes
>> Does it impact existing frontend drivers? No.
>> What's the impact to dvb-core? Small.
>> What's the impact to application developers? None, unless an 
> application 
>> developer wants to support the new standards - binary compatibility!
>>
>> We want feedback and we want progress, we aim to achieve it.
> 
> Feedback is no problem :-)
> 
> I noticed that the properties work very similar as to how extended 
> controls work in v4l: 
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#VIDIOC-G-EXT-CTRLS
> 
> It might be useful to compare the two.


yes, another developer also suggested this. It would be good to 
implement simmilar ideas - especially then they are already well 
established.


> 
> I would recommend adding a few reserved fields, since that has proven to 
> be very useful in v4l to make the API more future proof.

Interesting.

> 
> Also: is setting multiple properties an atomic action? E.g. if one 
> fails, are all other changes rolled back as well? And how do you give 
> the caller feedback on which property in the list failed? Will there 
> also be a TRY_PROPERTIES variant which just checks for correctness 
> without actually setting it? How do you query/test whether a device has 
> certain properties?

I've been thinking about this a lot and I'm leaning away from making the 
  sequence atomic, partly for the issue you raised and partly because 
when I tried to find concrete use cases where this was required I only 
came up with a few.

I want to explore this more, after I've published all of the feedback.

> 
> Do you need separate get and set commands? Why not either set or get a 
> list of properties, and setting them implies an automatic SEQ_COMPLETE 
> at the end. By having a variable length array of properties you do not 
> need to set the properties in multiple blocks of 16, so that simplifies 
> the API as well.

The 16 limit is going to be removed in favor of a more flexible (and 
traditional approach). A complete set of set's or get's is interesting. 
Let me see if I can find a use-case where we'd mix the two... if not 
then I agree with this, and it would simplify things even further.

We'll explore this more.

> 
> As I said, extended controls in v4l do something very similar. I thought 
> about the extended controls a great deal at the time, so it might 
> provide a handy comparison for you.

Yes.

> 
>> Importantly, this project group seeks your support.
>>
>> If you also feel frustrated by the multiproto situation and agree in
>> principle with this new approach, and the overall direction of the API
>> changes, then we welcome you and ask you to help us.
>>
>> Growing the list of supporting names by 100%, and allowing us to 
> publish
>> your name on the public mailing list, would show the non-maintainer
>> development community that we recognize the problem and we're taking
>> steps to correct the problem. We want to make LinuxTV a perfect 
> platform
>> for S2, ISDB-T and other advanced modulation types, without using the
>> multiproto patches.
>>
>> We're not asking you for technical help, although we'd like that  :) ,
>> we're just asking for your encouragement to move away from multiproto.
>>
>> If you feel that you want to support our movement then please help us 
> by
>> acking this email.
>>
>> Regards - Steve, Mike, Patrick and Mauro.
>>
>> Acked-by: Patrick Boettcher <pb@linuxtv.org>
>> Acked-by: Michael Krufky <mkrufky@linuxtv.org>
>> Acked-by: Steven Toth <stoth@linuxtv.org>
>> Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
>>
>> * [1]. Rather than point out the issues with multiproto here, take a
>> look at the patches and/or read the comments on the mailing lists.
> 
> While I am no dvb expert I do think that this is a good and simple 
> approach that should be reasonably future proof. It needs some work to 
> hammer out the details, but I like it.
> 
> Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Hans, thanks for your support and feedback.

Regards,

Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
