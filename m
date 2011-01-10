Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:60482 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab1AJVXo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 16:23:44 -0500
Date: Mon, 10 Jan 2011 16:00:36 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
In-Reply-To: <4D2AF1A0.3090809@redhat.com>
Message-ID: <alpine.LNX.2.00.1101101423110.14109@banach.math.auburn.edu>
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl> <alpine.LNX.2.00.1101071656350.11281@banach.math.auburn.edu> <4D2AF1A0.3090809@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Mauro,

A few comments in-line. Vide infra.

On Mon, 10 Jan 2011, Mauro Carvalho Chehab wrote:

> Em 07-01-2011 21:42, Theodore Kilgore escreveu:
>  
> >> Have you tried Mauro's media_build tree? I had to use it today to test a
> >> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we 
> > should
> >> promote this more. 
> > 
> > Probably a good idea. I have been too busy to know about it, myself. And I 
> > even do try to keep up with what is going on.
> > 
> >> I could add backwards compatibility builds to my 
> > daily
> >> build script that uses this in order to check for which kernel versions
> >> this compiles if there is sufficient interest.
> > 
> > Nice, but don't bust your behind with a thing like that. Back when we were 
> > discussing the idea of getting off of hg and onto git, I suggested 
> > approximately the previous three minor versions of the kernel, no 
> > more. And if there was a serious problem with 2.(current_release - 1) or 
> > 2.(current_release - 2) such as instability or security issues, whatever, 
> > then just drop that one. I think that to do this is reasonable if you or 
> > anyone else has the time and needed skills. More than this is not 
> > reasonable under any circumstances.
> 
> I think Hans can enable it. The backport effort on media-build is a way
> easier than with -hg. For example, in order to support kernel 2.6.31 (the oldest
> one on that tree), we need only 10 patches. The patches themself are simple:
> 
> $ wc -l *.patch
>    61 v2.6.31_nodename.patch
>   540 v2.6.32_kfifo.patch
>    42 v2.6.33_input_handlers_are_int.patch
>    70 v2.6.33_pvrusb2_sysfs.patch
>    40 v2.6.34_dvb_net.patch
>    22 v2.6.34_fix_define_warnings.patch
>    16 v2.6.35_firedtv_handle_fcp.patch
>   104 v2.6.35_i2c_new_probed_device.patch
>   145 v2.6.35_work_handler.patch
>   104 v2.6.36_input_getkeycode.patch
>  1144 total
> 
> And almost all patches are trivial.

Great. I am glad Hans is able to do that. I also think that before some 
changes were made things had reached the point of being both ridiculous 
and impossible. People doing the work were being run ragged, and demands 
for legacy support were obviously unreasonable. 

I forget what all of the issues were in the pre-2.6.20 kernels. I vaguely 
recall there were some really bad ones. One of them that I have personal 
knowledge about was a major error in the USB Mass Storage module, detected 
and fixed somewhere around 2.6.18. Namely, if a device says it is Class 08 
the spec says the first pair of bulk endpoints will be used. Before the 
fix, last pair was being searched instead. The mistake is not confronted 
very often, of course, because few USB devices have more than one pair of 
bulk endpoints. But for those that do, ouch. In fact, the hardware which 
brought the mistake to daylight was the same camera which is supported in 
gspca/jeilinj.c. In still mode as a standard mass storage device, that 
camera uses the first pair of bulk endpoints. As it is supposed to do. But 
until things were fixed, the mass storage support was attempting to use 
the second pair, which did not work out very well. The second pair of the 
bulk endpoints gets used only in webcam mode for passing commands and 
responses.

The point of the above story is that sometimes in kernel development 
things are changed from wrong to right. Those who petulantly want their 
favorite ancient kernel to be supported simply ought to understand and 
accept out of hand. Should any kernel prior to the fixing of the above 
problem continue in use in any environment where it needs to support USB 
mass storage devices? Obviously not. The moral for the present and future 
is obvious, too. 

> 
> > Now, as to the question of switching over to and using git, here are my 
> > recent personal experiences:
> > 
> > I started to do this switch-over only about a month ago, having been too 
> > busy for several months previous due to an illness in the family. I found 
> > that everything had changed in the meantime, and the hg trees had gone 
> > away. 
> > 
> > Issue 0: This issue came up just as I was deciding to switch from 32 to 64 
> > bit computing, so a lot of other stuff needed to be fixed or upgraded at 
> > the same time. I was busy. Well, lots of people are busy, and for lots of 
> > reasons. 
> > 
> > Issue 1: Which git tree? For someone who is going to get in at the 
> > beginning, this is not obvious. This issue got solved, of course, but it 
> > was the first one to face. For an outsider, I suspect that even this is 
> > somewhat intimidating.
> 
> It is now well-indicated at the top of the git page at linuxtv.org.

Nice.

> 
> > Issue 2: Problems totally unrelated to drivers/media rendered the new 
> > kernel unusable for very a long time, approximately a couple of weeks. I 
> > think I can call myself experienced in kernel configuration and 
> > compilation, and also not a total neophyte as a developer. The issue was a 
> > rather evil interaction between the new kernel, the new X driver for the 
> > ATI Radeon chip, and the introduction of in-kernel modeswitching (KMS) in 
> > X. It came about that if KMS was turned on then the video would cut off 
> > completely halfway through the boot procedure, and if KMS was turned off 
> > then I could not run X. I could use the distro kernel 2.6.35.7 and a 
> > locally compiled 2.6.35.7 as well just fine, but I could not safely submit 
> > a patch based on it. And my patches could not be tested against the git 
> > kernel because I could not run the git kernel. This problem was ultimately 
> > solved, and I was able to submit a rather small patch to add a camera to 
> > an existing driver, on Christmas Eve. 
> 
> Yeah, KMS also affected me for some time on -git builds, until it become more
> stable. The solution I used were to not start X on my test machine during that
> period of time.

Oh. So that one bit you too, did it? You must have similar hardware. Well, 
I am glad that I was not alone. 

The only thing that I do not follow, though, is the last sentence. Namely, 
if one is trying to develop support for streaming video devices, just how 
does one test them without using X? So how exactly can that be a solution?

> 
> Anyway, with media_build tree, you can compile it against your 2.6.35.7 kernel.
> Depending on what you're doing, this should be ok. 

I really do like 2.6.37 better. Unfortunately, I am in the situation that 
I have to do some stuff which is 32-bit and some stuff which is 64-bit, so 
I need to maintain a dual-boot machine. So at this moment I am booted in 
2.6.35.7 32-bit trying to do a kernel cross-compile for an ARM gadget 
using tools which won't run in a 64-bit environment. Lots of fun, on too 
many fronts at once.

> 
> Yet, with BKL changes, the better for developers is to use kernel 2.6.37 or upper, 
> in orderto be sure that the driver will work properly without BKL and without any 
> race/dead lock issue.
> 
> > Issue 3: I still need to grab the git tree for libv4l and start using it. 
> > I have not even begun this. For some of the reasons why I am behind 
> > schedule, see previous items.
> 
> You should really use it, as some webcam fixes happen there (like some 
> sensors mounted with vflip/hflip). Fedora ships it by default, and most
> applications there calls it. Not sure why some distros are still not
> shipping it properly.

I fully agree. Did I mention that things are behind schedule? I am not 
sure which distros are "still not shipping it properly" though. I would 
not expect any distro to ship anything but a release version. For me it is 
obviously not possible to run a release version in any event. I am 
running a (slightly out of date) development version right now. For, 
usually the addition of kernel support for a webcam also requires the 
simultaneous addition of libv4lconvert support for its decompression 
algorithm at the very least.

> > The point is, problems similar to those which hit me could hit anybody at 
> > any time and "anybody" means exactly what it says. This was not the first 
> > time that I have installed a development kernel. It was the first time I 
> > had any serious problems after doing so. Now, it is also true that after I 
> > finally got the issues worked through I was pleased with the results and 
> > would still run the new kernel by preference. But the problems were 
> > extremely time consuming. IMHO problems like this are sooner or later 
> > inevitable when it is mandatory to use a development kernel. Users are 
> > impatient. Testers are impatient. Developers are impatient. We are all 
> > impatient when things like this happen. People who are not sufficiently 
> > knowledgeable, who are not sufficiently tenacious, or who simply do not 
> > have sufficient time or motivation will just quit. It is something to 
> > think about.

I will definitely stand by the previous paragraph. All of it. I am very 
glad that attempts are being made to overcome the problems.

Theodore Kilgore
