Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:65275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246Ab1AJLqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:46:49 -0500
Message-ID: <4D2AF1A0.3090809@redhat.com>
Date: Mon, 10 Jan 2011 09:46:40 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Theodore Kilgore <kilgota@banach.math.auburn.edu>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl> <alpine.LNX.2.00.1101071656350.11281@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.1101071656350.11281@banach.math.auburn.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-01-2011 21:42, Theodore Kilgore escreveu:
 
>> Have you tried Mauro's media_build tree? I had to use it today to test a
>> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we 
> should
>> promote this more. 
> 
> Probably a good idea. I have been too busy to know about it, myself. And I 
> even do try to keep up with what is going on.
> 
>> I could add backwards compatibility builds to my 
> daily
>> build script that uses this in order to check for which kernel versions
>> this compiles if there is sufficient interest.
> 
> Nice, but don't bust your behind with a thing like that. Back when we were 
> discussing the idea of getting off of hg and onto git, I suggested 
> approximately the previous three minor versions of the kernel, no 
> more. And if there was a serious problem with 2.(current_release - 1) or 
> 2.(current_release - 2) such as instability or security issues, whatever, 
> then just drop that one. I think that to do this is reasonable if you or 
> anyone else has the time and needed skills. More than this is not 
> reasonable under any circumstances.

I think Hans can enable it. The backport effort on media-build is a way
easier than with -hg. For example, in order to support kernel 2.6.31 (the oldest
one on that tree), we need only 10 patches. The patches themself are simple:

$ wc -l *.patch
   61 v2.6.31_nodename.patch
  540 v2.6.32_kfifo.patch
   42 v2.6.33_input_handlers_are_int.patch
   70 v2.6.33_pvrusb2_sysfs.patch
   40 v2.6.34_dvb_net.patch
   22 v2.6.34_fix_define_warnings.patch
   16 v2.6.35_firedtv_handle_fcp.patch
  104 v2.6.35_i2c_new_probed_device.patch
  145 v2.6.35_work_handler.patch
  104 v2.6.36_input_getkeycode.patch
 1144 total

And almost all patches are trivial.

> Now, as to the question of switching over to and using git, here are my 
> recent personal experiences:
> 
> I started to do this switch-over only about a month ago, having been too 
> busy for several months previous due to an illness in the family. I found 
> that everything had changed in the meantime, and the hg trees had gone 
> away. 
> 
> Issue 0: This issue came up just as I was deciding to switch from 32 to 64 
> bit computing, so a lot of other stuff needed to be fixed or upgraded at 
> the same time. I was busy. Well, lots of people are busy, and for lots of 
> reasons. 
> 
> Issue 1: Which git tree? For someone who is going to get in at the 
> beginning, this is not obvious. This issue got solved, of course, but it 
> was the first one to face. For an outsider, I suspect that even this is 
> somewhat intimidating.

It is now well-indicated at the top of the git page at linuxtv.org.

> Issue 2: Problems totally unrelated to drivers/media rendered the new 
> kernel unusable for very a long time, approximately a couple of weeks. I 
> think I can call myself experienced in kernel configuration and 
> compilation, and also not a total neophyte as a developer. The issue was a 
> rather evil interaction between the new kernel, the new X driver for the 
> ATI Radeon chip, and the introduction of in-kernel modeswitching (KMS) in 
> X. It came about that if KMS was turned on then the video would cut off 
> completely halfway through the boot procedure, and if KMS was turned off 
> then I could not run X. I could use the distro kernel 2.6.35.7 and a 
> locally compiled 2.6.35.7 as well just fine, but I could not safely submit 
> a patch based on it. And my patches could not be tested against the git 
> kernel because I could not run the git kernel. This problem was ultimately 
> solved, and I was able to submit a rather small patch to add a camera to 
> an existing driver, on Christmas Eve. 

Yeah, KMS also affected me for some time on -git builds, until it become more
stable. The solution I used were to not start X on my test machine during that
period of time.

Anyway, with media_build tree, you can compile it against your 2.6.35.7 kernel.
Depending on what you're doing, this should be ok. 

Yet, with BKL changes, the better for developers is to use kernel 2.6.37 or upper, 
in orderto be sure that the driver will work properly without BKL and without any 
race/dead lock issue.

> Issue 3: I still need to grab the git tree for libv4l and start using it. 
> I have not even begun this. For some of the reasons why I am behind 
> schedule, see previous items.

You should really use it, as some webcam fixes happen there (like some 
sensors mounted with vflip/hflip). Fedora ships it by default, and most
applications there calls it. Not sure why some distros are still not
shipping it properly.

> The point is, problems similar to those which hit me could hit anybody at 
> any time and "anybody" means exactly what it says. This was not the first 
> time that I have installed a development kernel. It was the first time I 
> had any serious problems after doing so. Now, it is also true that after I 
> finally got the issues worked through I was pleased with the results and 
> would still run the new kernel by preference. But the problems were 
> extremely time consuming. IMHO problems like this are sooner or later 
> inevitable when it is mandatory to use a development kernel. Users are 
> impatient. Testers are impatient. Developers are impatient. We are all 
> impatient when things like this happen. People who are not sufficiently 
> knowledgeable, who are not sufficiently tenacious, or who simply do not 
> have sufficient time or motivation will just quit. It is something to 
> think about.
> 
> Theodore Kilgore
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

