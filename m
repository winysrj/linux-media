Return-path: <mchehab@pedra>
Received: from banach.math.auburn.edu ([131.204.45.3]:46025 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab1AGXFI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Jan 2011 18:05:08 -0500
Date: Fri, 7 Jan 2011 17:42:04 -0600 (CST)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Debug code in HG repositories
In-Reply-To: <201101072206.30323.hverkuil@xs4all.nl>
Message-ID: <alpine.LNX.2.00.1101071656350.11281@banach.math.auburn.edu>
References: <201101072053.37211@orion.escape-edv.de> <AANLkTinj2NcOcVUPifsNcvbs=Mivwe89+hg8XLsCJnQ7@mail.gmail.com> <201101072206.30323.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



On Fri, 7 Jan 2011, Hans Verkuil wrote:

> On Friday, January 07, 2011 21:13:31 Devin Heitmueller wrote:
> > On Fri, Jan 7, 2011 at 2:53 PM, Oliver Endriss <o.endriss@gmx.de> wrote:
> > > Hi guys,
> > >
> > > are you aware that there is a lot of '#if 0' code in the HG repositories
> > > which is not in GIT?
> > >
> > > When drivers were submitted to the kernel from HG, the '#if 0' stuff was
> > > stripped, unless it was marked as 'keep'...
> > >
> > > This was fine, when development was done with HG.
> > >
> > > As GIT is being used now, that code will be lost, as soon as the HG
> > > repositories have been removed...
> > >
> > > Any opinions how this should be handled?
> > >
> > > CU
> > > Oliver
> > 
> > I complained about this months ago.  The problem is that when we were
> > using HG, the HG repo was a complete superset of what went into Git
> > (including development/debug code).  But now that we use Git, neither
> > is a superset of the other.
> > 
> > If you base your changes on Git, you have to add back in all the
> > portability code (and any "#if 0" you added as the maintainer for
> > development/debugging).  Oh, and regular users cannot test any of your
> > changes because they aren't willing to upgrade their entire kernel.
> > 
> > If you base your changes on Hg, nothing merges cleanly when submitted
> > upstream so your patches get rejected.
> > 
> > Want to know why we are seeing regressions all over the place?
> > Because *NOBODY* is testing the code until after the kernel goes
> > stable (since while many are willing to install a v4l-dvb tree, very
> > few will are willing to upgrade their entire kernel just to test one
> > driver).  We've probably lost about 98% of our user base of testers.
> 
> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we should
> promote this more. I could add backwards compatibility builds to my daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.
> 
> > Oh, and users have to git clone 500M+ of data, and not everybody in
> > the world has bandwidth fast enough to make that worth their time (it
> > took me several hours last time I did it).
> 
> Currently the media_build tree copies the drivers from a git tree. Which, as
> you say, can be a big problem for non-developers. But all it really needs are
> the media drivers. So perhaps it might be a good idea to make a daily snapshot
> of the drivers and make it available for download on linuxtv.org. That archive
> is only 3.5 MB, so much easier to download.
> 
> > Anyway, I've beaten this horse to death and it's fallen on deaf ears.
> > Merge overhead has reached the point where it's just not worth my
> > time/effort to submit anything upstream anymore.
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
> 

I think you are both right. There, that ought to be pleasing. :-)

More seriously (quoting from above)

> Have you tried Mauro's media_build tree? I had to use it today to test a
> driver from git on a 2.6.35 kernel. Works quite nicely. Perhaps we 
should
> promote this more. 

Probably a good idea. I have been too busy to know about it, myself. And I 
even do try to keep up with what is going on.

> I could add backwards compatibility builds to my 
daily
> build script that uses this in order to check for which kernel versions
> this compiles if there is sufficient interest.

Nice, but don't bust your behind with a thing like that. Back when we were 
discussing the idea of getting off of hg and onto git, I suggested 
approximately the previous three minor versions of the kernel, no 
more. And if there was a serious problem with 2.(current_release - 1) or 
2.(current_release - 2) such as instability or security issues, whatever, 
then just drop that one. I think that to do this is reasonable if you or 
anyone else has the time and needed skills. More than this is not 
reasonable under any circumstances.

Now, as to the question of switching over to and using git, here are my 
recent personal experiences:

I started to do this switch-over only about a month ago, having been too 
busy for several months previous due to an illness in the family. I found 
that everything had changed in the meantime, and the hg trees had gone 
away. 

Issue 0: This issue came up just as I was deciding to switch from 32 to 64 
bit computing, so a lot of other stuff needed to be fixed or upgraded at 
the same time. I was busy. Well, lots of people are busy, and for lots of 
reasons. 

Issue 1: Which git tree? For someone who is going to get in at the 
beginning, this is not obvious. This issue got solved, of course, but it 
was the first one to face. For an outsider, I suspect that even this is 
somewhat intimidating.

Issue 2: Problems totally unrelated to drivers/media rendered the new 
kernel unusable for very a long time, approximately a couple of weeks. I 
think I can call myself experienced in kernel configuration and 
compilation, and also not a total neophyte as a developer. The issue was a 
rather evil interaction between the new kernel, the new X driver for the 
ATI Radeon chip, and the introduction of in-kernel modeswitching (KMS) in 
X. It came about that if KMS was turned on then the video would cut off 
completely halfway through the boot procedure, and if KMS was turned off 
then I could not run X. I could use the distro kernel 2.6.35.7 and a 
locally compiled 2.6.35.7 as well just fine, but I could not safely submit 
a patch based on it. And my patches could not be tested against the git 
kernel because I could not run the git kernel. This problem was ultimately 
solved, and I was able to submit a rather small patch to add a camera to 
an existing driver, on Christmas Eve. 

Issue 3: I still need to grab the git tree for libv4l and start using it. 
I have not even begun this. For some of the reasons why I am behind 
schedule, see previous items.

The point is, problems similar to those which hit me could hit anybody at 
any time and "anybody" means exactly what it says. This was not the first 
time that I have installed a development kernel. It was the first time I 
had any serious problems after doing so. Now, it is also true that after I 
finally got the issues worked through I was pleased with the results and 
would still run the new kernel by preference. But the problems were 
extremely time consuming. IMHO problems like this are sooner or later 
inevitable when it is mandatory to use a development kernel. Users are 
impatient. Testers are impatient. Developers are impatient. We are all 
impatient when things like this happen. People who are not sufficiently 
knowledgeable, who are not sufficiently tenacious, or who simply do not 
have sufficient time or motivation will just quit. It is something to 
think about.

Theodore Kilgore
