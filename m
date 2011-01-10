Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192Ab1AJL2E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:28:04 -0500
Message-ID: <4D2AED3F.3010109@redhat.com>
Date: Mon, 10 Jan 2011 09:27:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl>
In-Reply-To: <201101072206.30323.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-01-2011 19:06, Hans Verkuil escreveu:
> On Friday, January 07, 2011 21:13:31 Devin Heitmueller wrote:
>> On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
>>> Hi guys,
>>>
>>> are you aware that there is a lot of '#if 0' code in the HG repositories
>>> which is not in GIT?
>>>
>>> When drivers were submitted to the kernel from HG, the '#if 0' stuff was
>>> stripped, unless it was marked as 'keep'...
>>>
>>> This was fine, when development was done with HG.
>>>
>>> As GIT is being used now, that code will be lost, as soon as the HG
>>> repositories have been removed...
>>>
>>> Any opinions how this should be handled?

Oliver,

There are some code there that it may make sense to bring back to -git and to
upstream, or to convert into some of the new kernel tracing facilities, but we
need to review them, as there are some codes inside the #if 0 that are simply 
dead code, where people were intending to use some alternative way to implement 
the driver, but gave up and just forgot to clean up the mess. Several of those
code don't even compile today, due to the kABI changes.

With respect to debug printk messages, I dunno if you've already used, but
dev_dbg() functions (and other similar ones) are very interesting: depending
on the way you compile your kernel, they're converted into dynamic_printk's, 
and they can be enabled/disabled via /sys/kernel/debug/. It is a way better than
just adding normal printk's, as you can tell the kernel to enable just the debug
message at some line.

For example:

$ cat /sys/kernel/debug/dynamic_debug/control |grep cx231xx
/home/v4l/new_build/v4l/cx231xx-input.c:93 [cx231xx]cx231xx_ir_init - "Trying to bind ir at bus %d, addr 0x%02x\012"
/home/v4l/new_build/v4l/cx231xx-input.c:57 [cx231xx]cx231xx_ir_init - "%s\012"
/home/v4l/new_build/v4l/cx231xx-input.c:45 [cx231xx]get_key_isdbt - "scancode = %02x\012"
/home/v4l/new_build/v4l/cx231xx-input.c:32 [cx231xx]get_key_isdbt - "%s\012"

by using:

# echo "file cx231xx-input.c +p" > /sys/kernel/debug/dynamic_debug/control

All the above debug lines will be enabled. You can do, instead:

# echo "file cx231xx-input.c line 45 +p" > /sys/kernel/debug/dynamic_debug/control

If you're interested just at the scancode printk line.

At least on the distros I use (RHEL6 and Fedora 14), dynamic printk support is enabled
by default on kernel, so, this is very useful to me, as I don't need to recompile
the entire kernel to test.

>>>
>>> CU
>>> Oliver
>>
>> I complained about this months ago.  The problem is that when we were
>> using HG, the HG repo was a complete superset of what went into Git
>> (including development/debug code).  But now that we use Git, neither
>> is a superset of the other.
>>
>> If you base your changes on Git, you have to add back in all the
>> portability code (and any "#if 0" you added as the maintainer for
>> development/debugging).  Oh, and regular users cannot test any of your
>> changes because they aren't willing to upgrade their entire kernel.
>>
>> If you base your changes on Hg, nothing merges cleanly when submitted
>> upstream so your patches get rejected.
>>
>> Want to know why we are seeing regressions all over the place?
>> Because *NOBODY* is testing the code until after the kernel goes
>> stable (since while many are willing to install a v4l-dvb tree, very
>> few will are willing to upgrade their entire kernel just to test one
>> driver).  We've probably lost about 98% of our user base of testers.
> 
> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
> promote this more. I could add backwards compatibility builds to my daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.

I'm using it currently on most of my tests. I know that there are several
users using it.

>> Oh, and users have to git clone 500M+ of data, and not everybody in
>> the world has bandwidth fast enough to make that worth their time (it
>> took me several hours last time I did it).
> 
> Currently the media_build tree copies the drivers from a git tree. Which, as
> you say, can be a big problem for non-developers. But all it really needs are
> the media drivers. So perhaps it might be a good idea to make a daily snapshot
> of the drivers and make it available for download on linuxtv.org. That archive
> is only 3.5 MB, so much easier to download.

No, you don't need to have it. Have you looked at the build.sh script?
It downloads and compiles everything using the latest tarball from:
	http://linuxtv.org/downloads/drivers/
Currently, the archive has 3.3Mb. The tarball is updated when a change is
done on the latest development branch (It is still pointing to staging/for_v2.6.38,
as I didn't finish to add the backport to linux-next changes).

>> Anyway, I've beaten this horse to death and it's fallen on deaf ears.
>> Merge overhead has reached the point where it's just not worth my
>> time/effort to submit anything upstream anymore.
> 
> The hg tree is dead. Douglas Landgraf tried to maintain it, but it's just too
> much work. Any attempt to work from the hg tree is doomed. The media_build
> seems to be a viable alternative. As a developer you still have to go through
> the painful process of cloning the git repo, but it is a one time thing. Once
> it's cloned then you only have to follow the new commits, which is much, much
> faster.
> 
> And regarding regressions: I'm amazed how few regressions we have considering
> the furious rate of development. The media subsystem is still one of the most
> active subsystems in the kernel and probably will remain so for the forseeable
> future as well.
> 
> It would be a shame not to submit patches upstream, that never ends well in
> the long run.
> 
> With respect to '#if 0': for the most part I'd say: good riddance. In my
> many years of experience as a SW engineer I have never seen anyone actually
> turn on '#if 0' code once it's been in the code for more than, say, a year.
> Usually people just leave it there because they are too lazy to remove it,
> or they don't understand what it is for and are too scared to remove it.
> 
> If it is code partially implementing a feature that needs more work, then
> it may sound like a good idea to keep it. However, after it's in the code for
> more than a year, then nobody remembers what the code was about and what still
> had to be done to make it work. And it's hell to figure that out after such a
> long time. Never put such code in the mainline. Keep it in a branch if you
> have to.

This is the case of most #if 0 code. On a few drivers, it were used to turn on some
special debug messages. Btw, using #if 0 for debug is a bad practice, as some
upstream change may break it - Instead, it should do something like #if CONFIG_DEBUG_foo,
and having some Kconfig to allow enabling/disabling it.
> 
> Anyway, if there is some '#if 0' code that you want to preserve in git, then
> you have to make a patch to add it. But you probably will have to have very
> good reasons for adding '#if 0' code to the mainline.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

