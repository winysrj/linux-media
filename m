Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:48774 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZBVNs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 08:48:59 -0500
Message-ID: <49A15889.30102@to-st.de>
Date: Sun, 22 Feb 2009 14:52:09 +0100
From: =?ISO-8859-1?Q?Tobias_St=F6ber?= <tobi@to-st.de>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: kilgota@banach.math.auburn.edu,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk> <alpine.LNX.2.00.0902211811500.10147@banach.math.auburn.edu> <200902221057.17050.hverkuil@xs4all.nl>
In-Reply-To: <200902221057.17050.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi together,

following this dicussion for some time, let me just add my solely 
personal view. I'll have to prepend that I'm only a user in terms of 
v4l-dvb, but do for instance quite a lot support for Eee PC netbooks. So 
some comments here in some sense urged me to jump into this discussion.

Hans Verkuil schrieb:
> On Sunday 22 February 2009 02:15:51 kilgota@banach.math.auburn.edu wrote:
>>>> Oldest supported Ubuntu kernel is 2.6.22 (7.10):
>> This is a bit optimistic.
>>
>> Matter of fact, I just bought a brand new eeePC in January, on which Asus
>> chose to install Xandros. The response to uname -r is (I put this on a
>> separate line in order to highlight it)
>>
>> 2.6.21.4-eeepc
>>
>> Now, some might not think of Xandros as a leading distro. It certainly
>> would not have been my first choice. The choice of such an old kernel
>> confirms that impression. But the netbook hardware platform, I would say,
>> is a rather important one. The point is, if one is going to start looking
>> for kernels that are obviously too old to mess with but are in common use
>> then one has to go back even beyond 2.6.22. If it were my choice, I
>> wouldn't.
> 
> I don't think these netbooks are relevant for us for the simple fact that 
> the main use case of v4l-dvb on devices like this is the webcam, and that 
> will obviously be supported by whatever linux version the manufactorer has 
> installed.

First to the "netbook" questions ...)

I suppose that you Hans don't use any of these so called netbooks?

Nevertheless these devices are common today, just for the fact, that 
they offer a good value for money, are powerful enough for all the day 
to day tasks a normal user may want to do and are sometimes the first 
ever experience of normal users with linux. Furthermore you have a 
device which weights around 1 kg and has roughly the size of an A5 piece 
of paper or slightly larger.

Besides the netbooks there are other devices, that share the same kind 
of linux distributions - or to make it more specific - say the Asus Eee 
Box models, that also comes (if they come with linux) with a Asus 
specific kind of Xandros linux, which itself is based on Debian etch and 
also newer parts of Debian lenny / sid.

Just looking at the people I know (sometimes consider as friends), 
nearly 1/3 of them own such a device. More than 3/4 of them sticks to 
the default linux, which certainly has its quirks and problems.

Using any other linux distribution may introduce a very recent kernel or 
other recent parts of software - but it just swaps Asus Xandros specific 
problems with that of the particular distro or kernel.

The "netbook" itself is - just my personal view of it - just a small 
kind of notebook device with sometime older (Celeron M353 cpu etc.) or 
in newer models Intel Atom based hardware.

This also means, that a lot of people just use it as a notebook, which 
means they use some sort of peripherals. Nearly all of the people I know 
owning a "netbook", don't use their netbook just as it came, all of them 
use some additional hardware, most prominently a lot using DVB usb 
devices, 3G modems, bluetooth or IrDA dongles, external video or webcam 
devices or adapters to provide legacy serial or parallel interface ports.

A lot of such devices are not supported by the kernel modules, that are 
provides with the netbook, so one has to build additional kernel 
modules. Sometime from other source, that the actual kernel source. In 
this case it is very handy to be able to compile a fresh hg checkout.

I don't want to bother you with a listing of cases in which people I 
know to use a specific device or me even helping them to get it running 
on such netbooks....

The point just is, that regardless of a device being classified as 
netbook or notebook it is a very naive point of view to say:

a) that it will only be used with to integrated software,

b) that a manufacturer and or distribution will jump every few weeks 
onto a recent kernel (which would be in some case a major task to 
install) and

c) that every normal user has the abilities to master such a - in some 
sense complicated task - as building and installing a complete kernel 
(building a v4l-dvb checkout is a lot more easier).

Second ...)

... you just to a more wider viewpoint, or even just try to understand 
that there may be just more things to consider as "development".

The kernel itself is a great piece of work and the development it takes 
is in some parts amazing. But - be honest - a kernel as such leads you 
nowhere. You have to have other kind of software to build upon it ... 
say a linux distribution.

Here the first problem occurs, as distributions use different kernels 
and most often introduce there own changes (not only regarding the 
kernel). Also - if you have a running linux system, with sometimes very 
specific software needs, which in most cases takes a lot of work to get 
*it all together* running, you aren't easily changing lot of this, let 
it be kernel, distro or whatever.

So apart from embedded devices, the number of people using using older 
distributions / kernels for a reason, isn't that small as you might believe.

I personally thing that the people that jump on every new kernel are 
just the *minority* here.

Even distributions stick to a kernel version, that proved to be of a 
"good quality" and apply later changes to that. Long time ago there was 
a "stable" (2.2, 2.4) line of kernels and "developemt" kernels (2.3, 
2.5). With the way the kernel is managed today, there are certain 
kernels of - in my view - a very bad quality.

So the question here about old kernels is just, how you developers 
defined yourself:

- do you care more about the development process, speed and ease of 
work, including an easier way of new people into 4vl-dvb development, 
than it is certainly wise to abandon all those things, that interfere 
with that

OR

- do you find it important, that there are actually more than the 
minority of "new-kernel-users" people to actually use your work  .

In this latter case you might have to admit, that it maybe a good to 
idea to support more than just the recent kernel (or the 3 fewer kernels).

> But it does raise the point that if we decide to drop support for kernels < 
> 2.6.22 then it is probably a good idea to make a snapshot first so people 
> can still have the option to upgrade their v4l-dvb, even though that 
> version isn't maintained anymore by us.

The problem here is, that a normal person will take a few dollars, euros 
whatever ... goes into an electronics store or visits an online shop and 
buys some device, let it be a webcam or DVB stick.

A lot of hardware would require a very recent kernel, if it wouldn't be 
possible to compile v4l-dvb itself out of the kernel. For Eee PC 
netbooks with a 2.6.21.4 kernel it applies e.g. to DVB sticks with 
AF9015 chipsets etc.

And a lot of hardware, freshly supported by kernel x.y.z. 1 1/2 years 
ago, will not be available from that store as a new product.

Whatever way you're choosing, it will be fine.

If you decide to drop support for kernels below 2.6.22, I then know, 
that I don't have to try it on out netbooks, and I know (and also can 
tell people), that a device won't ever be supported with the default 
linux distro / netbook until we use kernel 2.6.34 ... whatever.

I don't actually know, how important feedback from "normal" users is for 
you and how much you actually get.

But, again, in my view, the user that every few weeks upgrades his 
kernel is the minority.

Best regards, Tobias

