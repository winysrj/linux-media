Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:56550 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZBVWEP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Feb 2009 17:04:15 -0500
Date: Sun, 22 Feb 2009 16:16:27 -0600 (CST)
From: kilgota@banach.math.auburn.edu
To: =?ISO-8859-15?Q?Tobias_St=F6ber?= <tobi@to-st.de>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Adam Baker <linux@baker-net.org.uk>,
	linux-media@vger.kernel.org
Subject: Re: RFCv1: v4l-dvb development models & old kernel support
In-Reply-To: <49A15889.30102@to-st.de>
Message-ID: <alpine.LNX.2.00.0902221413270.10870@banach.math.auburn.edu>
References: <200902211200.45373.hverkuil@xs4all.nl> <200902212347.47109.linux@baker-net.org.uk> <alpine.LNX.2.00.0902211811500.10147@banach.math.auburn.edu> <200902221057.17050.hverkuil@xs4all.nl> <49A15889.30102@to-st.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-863829203-106306253-1235340987=:10870"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---863829203-106306253-1235340987=:10870
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT



On Sun, 22 Feb 2009, Tobias Stöber wrote:

> Hi together,
>
> following this dicussion for some time, let me just add my solely personal 
> view. I'll have to prepend that I'm only a user in terms of v4l-dvb, but do 
> for instance quite a lot support for Eee PC netbooks. So some comments here 
> in some sense urged me to jump into this discussion.

You raise interesting points and complicated issues. I do not know if 
there is any ideal solution -- except, perhaps, time. I, unfortunately, 
can can see all sides of the issue, too...

>
> Hans Verkuil schrieb:
>> On Sunday 22 February 2009 02:15:51 kilgota@banach.math.auburn.edu wrote:
>>>>> Oldest supported Ubuntu kernel is 2.6.22 (7.10):
>>> This is a bit optimistic.
>>> 
>>> Matter of fact, I just bought a brand new eeePC in January, on which Asus
>>> chose to install Xandros. The response to uname -r is (I put this on a
>>> separate line in order to highlight it)
>>> 
>>> 2.6.21.4-eeepc

<snip>

>> 
>> I don't think these netbooks are relevant for us for the simple fact that 
>> the main use case of v4l-dvb on devices like this is the webcam, and that 
>> will obviously be supported by whatever linux version the manufactorer has 
>> installed.
>
> First to the "netbook" questions ...)
>
> I suppose that you Hans don't use any of these so called netbooks?
>
> Nevertheless these devices are common today, just for the fact, that they 
> offer a good value for money, are powerful enough for all the day to day 
> tasks a normal user may want to do and are sometimes the first ever 
> experience of normal users with linux. Furthermore you have a device which 
> weights around 1 kg and has roughly the size of an A5 piece of paper or 
> slightly larger.

Yes, indeed. And the Atom model, especially when upgraded to 2 gig of RAM, 
is far from a toy. It is a very powerful and fast machine. It compares 
quite well with the desktop system I was using until quite recently 
(single-core Sempron 2600+ with 1 gig of RAM) and also with the heavy 
laptop I was using until quite recently (old Dell Latitude C600 with 
800mhz Mobile Celeron and 384 meg of PC100 RAM, max capacity 512 meg of 
RAM). So I fully expect the eeePC to be the machine that I use while 
traveling, going to conferences, giving presentations, and this means as 
well that it has to be, ultimately, a second (or third or fourth) 
development platform for me because that is what I am doing.

For me, of course, this means that it will ultimately have to have a 
systematic kernel and software upgrade. But other problems impinge there. 
I mentioned that I am running a very contemporary distro on it, with a 
very contemporary kernel. But I have not removed the original installation 
yet. For example, right now the wireless works with the original 
installation, but the support for the RaLink2860 is not yet in a stock 
kernel. So an important hardware component is not easy to support. I have 
the ability and the patience to deal with a problem like this one. But I 
am obviously in a minority.

>
> Besides the netbooks there are other devices, that share the same kind of 
> linux distributions - or to make it more specific - say the Asus Eee Box 
> models, that also comes (if they come with linux) with a Asus specific kind 
> of Xandros linux, which itself is based on Debian etch and also newer parts 
> of Debian lenny / sid.

Well, now the other side of me is speaking. I admire Debian. But I have 
never used it. Debian has been too often too far behind on too many things 
-- kernel, libc version, libtool version, you name it. Then there are 
distros which base themselves on Debian, but are not Debian, and thereby 
seem to gain the attention of hardware manufacturers. I do not understand.

Have I mentioned a user who reported a new stillcam to me two months ago, 
and the first thing to do was to see if it is supported by a recent 
libgphoto2? Well, on his Debian workstation a newer libgphoto2 would have 
required a newer libtool. He uses the workstation in his job, so he did 
not want to mess with that. So at my urging he put Slax on an SD card for 
his eeePC, and the Slackware package libgphoto2-2.4.3 (and a couple of 
missing dependencies) and then finally was able to test the camera and yes 
it works and I posted an update to SVN yesterday evening, after 2 months 
of hassle.

I have had other experiences with users of certain distros, experiences 
which were not nearly so positive.

Part of my point here is that it is not only kernel development which is 
affected by dilatory distros. Userspace development is affected, 
too. Users are affected. Everyone is affected. Not just the kernel 
version is in question. Basic libraries are behind on their versions. 
An attempt to upgrade anything causes dependency hell. From my point 
of view, the only thing to do about the problem is to publicize it. One 
possible way to publicize it is to point out just how much trouble it 
causes.

>
> Just looking at the people I know (sometimes consider as friends), nearly 1/3 
> of them own such a device. More than 3/4 of them sticks to the default linux, 
> which certainly has its quirks and problems.

Indeed.


> Using any other linux distribution may introduce a very recent kernel or 
> other recent parts of software - but it just swaps Asus Xandros specific 
> problems with that of the particular distro or kernel.

Such as, for example, supporting the wireless card ...

Why don't you encourage your friends to put a live distro on an SD card 
to support some of the new stuff they want to install? It's easy. It's 
fun. It's cheap. And it does not have to be Slax if you or they prefer 
something else.

>
> The "netbook" itself is - just my personal view of it - just a small kind of 
> notebook device with sometime older (Celeron M353 cpu etc.) or in newer 
> models Intel Atom based hardware.
>
> This also means, that a lot of people just use it as a notebook, which means 
> they use some sort of peripherals. Nearly all of the people I know owning a 
> "netbook", don't use their netbook just as it came, all of them use some 
> additional hardware, most prominently a lot using DVB usb devices, 3G modems, 
> bluetooth or IrDA dongles, external video or webcam devices or adapters to 
> provide legacy serial or parallel interface ports.
>
> A lot of such devices are not supported by the kernel modules, that are 
> provides with the netbook, so one has to build additional kernel modules. 
> Sometime from other source, that the actual kernel source. In this case it is 
> very handy to be able to compile a fresh hg checkout.

Again, use an SD card with another distro on it. Me, I did not even try to 
compile that on the original distro with the original kernel. One look at 
that kernel version and I just *assumed* it would never work. But it ought 
to compile with any version that would pass as "current" which was my 
original point. So this says don't switch over to git and current kernel 
source.

>
> I don't want to bother you with a listing of cases in which people I know to 
> use a specific device or me even helping them to get it running on such 
> netbooks....

If you used a live distro, it would be even easier to do that.

>
> The point just is, that regardless of a device being classified as netbook or 
> notebook it is a very naive point of view to say:
>
> a) that it will only be used with to integrated software,

agree.


> b) that a manufacturer and or distribution will jump every few weeks onto a 
> recent kernel (which would be in some case a major task to install) and

also true, but some of the manufacturers and some of the distros *do* need 
a bit of education. Their behavior is really out of line. Perhaps we can 
be idealists and believe that if they actually could be made to understand 
how much trouble is caused, there might be a change?

>
> c) that every normal user has the abilities to master such a - in some sense 
> complicated task - as building and installing a complete kernel (building a 
> v4l-dvb checkout is a lot more easier).

Also true.

>
> Second ...)
>
> ... you just to a more wider viewpoint, or even just try to understand that 
> there may be just more things to consider as "development".
>
> The kernel itself is a great piece of work and the development it takes is in 
> some parts amazing. But - be honest - a kernel as such leads you nowhere. You 
> have to have other kind of software to build upon it ... say a linux 
> distribution.
>
> Here the first problem occurs, as distributions use different kernels and 
> most often introduce there own changes (not only regarding the kernel). Also 
> - if you have a running linux system, with sometimes very specific software 
> needs, which in most cases takes a lot of work to get *it all together* 
> running, you aren't easily changing lot of this, let it be kernel, distro or 
> whatever.

That is why I consider it a very bad thing to put together a distro which 
is full of old this and that which works well with the other pieces of 
itself but the attempt to upgrade any single piece of it requires one to 
jack up the hood ornament and roll a new car under it.

>
> So apart from embedded devices, the number of people using using older 
> distributions / kernels for a reason, isn't that small as you might believe.

This is true, and we should all understand that it it true. It is also a 
sad state of affairs.

>
> I personally thing that the people that jump on every new kernel are just the 
> *minority* here.
>
> Even distributions stick to a kernel version, that proved to be of a "good 
> quality" and apply later changes to that. Long time ago there was a "stable" 
> (2.2, 2.4) line of kernels and "developemt" kernels (2.3, 2.5). With the way 
> the kernel is managed today, there are certain kernels of - in my view - a 
> very bad quality.

All of this is also true. Equally, it is the case that some distros are 
not sufficiently paying attention to upgrading the kernel -- or for that 
matter anything else.

>
> So the question here about old kernels is just, how you developers defined 
> yourself:
>
> - do you care more about the development process, speed and ease of work, 
> including an easier way of new people into 4vl-dvb development, than it is 
> certainly wise to abandon all those things, that interfere with that
>
> OR
>
> - do you find it important, that there are actually more than the minority of 
> "new-kernel-users" people to actually use your work  .
>
> In this latter case you might have to admit, that it maybe a good to idea to 
> support more than just the recent kernel (or the 3 fewer kernels).

Any distro which is so far behind that it becomes impossible for any 
average user to upgrade anything without getting into dependency hell over 
one thing after another, because the distro is behind on too many fronts 
at the same time, seems to me can be left out in the cold. One cannot 
support distros like that in userspace, either. This is not an either-or 
question of elitism on the part of developers.

>
>> But it does raise the point that if we decide to drop support for kernels < 
>> 2.6.22 then it is probably a good idea to make a snapshot first so people 
>> can still have the option to upgrade their v4l-dvb, even though that 
>> version isn't maintained anymore by us.
>
> The problem here is, that a normal person will take a few dollars, euros 
> whatever ... goes into an electronics store or visits an online shop and buys 
> some device, let it be a webcam or DVB stick.
>
> A lot of hardware would require a very recent kernel, if it wouldn't be 
> possible to compile v4l-dvb itself out of the kernel. For Eee PC netbooks 
> with a 2.6.21.4 kernel it applies e.g. to DVB sticks with AF9015 chipsets 
> etc.

But why is the eeePC using the 2.6.21.4 kernel? What is it exactly that 
makes this difficult for the people who made that choice, to understand? I 
am not speaking of the people who bought one. I bought one. I did not buy 
one with Windows on it. I proudly bought Linux. But when I saw that this 
is kernel version 2.6.21.4 I was shocked.

>
> And a lot of hardware, freshly supported by kernel x.y.z. 1 1/2 years ago, 
> will not be available from that store as a new product.
>
> Whatever way you're choosing, it will be fine.
>
> If you decide to drop support for kernels below 2.6.22, I then know, that I 
> don't have to try it on out netbooks, and I know (and also can tell people), 
> that a device won't ever be supported with the default linux distro / netbook 
> until we use kernel 2.6.34 ... whatever.

Again, use a live distro on USB stick or SD card. Slax on SD card runs 
like a scalded dog. No perceptible performance hit, at all.

>
> I don't actually know, how important feedback from "normal" users is for you 
> and how much you actually get.

I have had to deal with lots of them. I just mentioned one of them in this 
letter. He was a very nice and very patient and very intelligent person. 
He also said that my instructions were very clear, which makes me feel 
good, too. I have had years of experience in writing instructions to 
people in similar situations, so I would hope that I got better at it. But 
this man, like some others, was caught in the situation that he was using 
a distro which is just too far behind on too many things at the same time, 
and the distro seems unable to catch up even when doing a major upgrade.

So the problem is not those users. It is those distros.

>
> But, again, in my view, the user that every few weeks upgrades his kernel is 
> the minority.

This is again true. The fact that I might do that puts me in the developer 
category, I suppose. But even people like me might have several machines 
and only do that on just one of them.


> Best regards, Tobias

Sorry for the long letter. It seems that there are things on which we 
agree and things on which we disagree. Both of us are concerned with 
users. But the users have not caused the problems, have they? Distros and 
hardware manufacturers have caused these problems, and the problems are 
really serious problems both for users and for developers. So a better 
solution has to be thought of, than just to indulge the dilatory behavior 
of the guilty in order to avoid displeasing some of the innocent.

Theodore Kilgore
---863829203-106306253-1235340987=:10870--
