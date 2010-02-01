Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:57135 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753497Ab0BAVOa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Feb 2010 16:14:30 -0500
Subject: Re: Kernel Oops, dvb_dmxdev_filter_reset, bisected
From: Chicken Shack <chicken.shack@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Thomas Voegtle <tv@lio96.de>, obi@linuxtv.org,
	linux-media@vger.kernel.org
In-Reply-To: <4B672F95.5070009@redhat.com>
References: <alpine.LNX.2.00.1002011855590.30919@er-systems.de>
	 <4B672F95.5070009@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Feb 2010 22:09:31 +0100
Message-ID: <1265058571.1739.50.camel@brian.bconsult.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 01.02.2010, 17:46 -0200 schrieb Mauro Carvalho Chehab:
> Thomas Voegtle wrote:
> > 
> > Hello,
> > 
> > yesterday I moved from 2.6.31.y to 2.6.32 and found a reproducable
> > kernel oops.
> > Bug is in Linus' tree, too.


Mauro,
To begin with: Thanks for your investigation and patch authoring of
course.

Please let me state you where you are definitely wrong (unfortunately):


> Please try the two patches I sent to the ML today that fixes two potential
> situations where the OOPS bug may hit.


I tried them. As I wrote already, patch 1 bewares the system from
hanging up itself completely if alevt-dvb is being started for the
second time after the kernel oops.

But what concerns the real problem of the patch in question and
alevt-dvb as application, none of the two patches even touches even one
of the 2 described root problems, unfortunately.

So everything is just the same, nothing essential has changed.

> I suspect that alevt-dvb is doing something wrong with the memory of the machine.


I guess that this assumption is wrong.


> The more likely case happens when there's no more available memory for vmalloc(). 
> In this case, this code fails:
> 
>         dvbdemux->feed = vmalloc(dvbdemux->feednum * sizeof(struct dvb_demux_feed));
>         if (!dvbdemux->feed) {
>                 vfree(dvbdemux->filter);
>                 return -ENOMEM;
> 
> And the driver frees the memory. However, before the patch, it used to forget
> to reset dvbdemux->filter to NULL. Later, dvb_dmx_release() is called, and it
> tries to free an already freed memory, causing the OOPS.


This is interesting to be read, but it is not the root problem in our
special case.


> After applying those two patches, I can't see any other potential cause
> for the problem. Someone with aletv and a DVB-T signal with Teletext
> (it is not my case, I am at an ISDB-T area) should now take a look on 
> what's the application is doing and why aletv-dvb is exhausting the computer 
> memory used by vmalloc.

Even if it is not propagated officially the DVB-patched versions of
alevt-dvb also run with DVB-S equipment. All you need to do is to feed
them with the correct ttpid (teletext pid) on the command line.

Depends on your distro, as a variety of versions is being spread....
If you wish I can send you my corrected and enhanced version that you
can compile in 30 seconds.....


> > I bisected this down to:
> > 
> > root@scratchy:/data/kernel/linux-2.6# git bisect bad
> > 1cb662a3144992259edfd3cf9f54a6b25a913a0f is first bad commit
> > commit 1cb662a3144992259edfd3cf9f54a6b25a913a0f
> > Author: Andreas Oberritter <obi@linuxtv.org>
> > Date:   Tue Jul 14 20:28:50 2009 -0300
> > 
> >     V4L/DVB (12275): Add two new ioctls: DMX_ADD_PID and DMX_REMOVE_PID
> > ...
> > 
> > 
> > Reverting the patch on top of 2.6.33-rc6, I can start mplayer and alevt
> > with no problems.
> 
> If reverting this patch solves the issue, then I can see 2 possible reasons
> for the breakage:
> 	1) the behavior of the old ioctls changed a little bit for Teletext;
> 	2) your mplayer version has support to the new ioctls, and is doing
> something different. In this case, as aletv-dvb is not prepared for the 
> changes, it hits some internal bug, and it is working badly.

That sounds very very good and realistic.
That's why I appended my version of alevt-dvb as attachment of my mail
to Andy Walls.


> In any case, someone needs to dig at aletv and check what's happening there, 
> identifying the root cause. So, the better is to contact aletv-dvb maintainer. 

This is erratic in so far as there is no official maintainer of
alevt-dvb.

The program was written about 10 years ago by a guy called Edgar
Toernig, arrivable under <froese@gmx.de>.

Edgar never felt responsible for the DVB patches of alevt which were
written by a guy from Switzerland called Thomas Sailer two years later
(2001).

There have been lots of contributions for this beautiful piece of
software: a russian and a greek codepage implementation, the rather
crude DVB-patch by Thomas Sailer, lots of fonts and bugfixes all over
the years.

Edgar Toernig, the original author, never felt responsible for the DVB
part of his software - if he ever "maintained" something, then it was
and still is the analogue part of the program.

But the DVB implementation exists since 9 years and it did its work up
until kernel 2.6.31 final.

With Obi's patch, signed by you and Brandon, the problems started,
introducing kernel 2.6.32-rc1.
There hasn't been any issue for about 9 years concerning the DVB part of
the program.......


So call the DVB part of this beautiful piece of software a stepchild and
you're bloody right....


> It the error is due to (2), the fix is a patch to aletv-dvb. If it is (1),
> then a regression has occurred, and a patch to the kernel is needed. For someone
> to write such patch, he needs to know exactly where's the bug: e. g. what's the
> difference between the previous driver response and the new broken response.


We need both:
1. A volunteer who dives into alevt-dvb: The DVB implementation is
rather primitive and limited to 2 files: vbi.c and vbi.h.

2. A volunteer who dives into the pitfalls of the new demux device and
writes a kernel patch....

In clear words: The new DVB demux device can serve a multiplicity of
filters for a multiplicity of parallel recordings for instance.

A teletext application is something rather primitive in comparison to
what the actual Demux device can manage:

Its needs are utmost spartan: The needed filter type DMX_PES_OTHER and
that's it! Nothing more!


SO IF the new DVB demux device can control a multiplicity of filters
(AUDIO, VIDEO, OTHER, etc.) since 2.6.32-rc1 then why the hell is it
incapable to control something absolutely primitive like a dumb teletext
application????

So this is my basic thesis (in question form) why the issue can never be
a simple application issue for itself (i. e. the fault is situated only
in the architecture of the application). 


> Cheers,
> Mauro

It would be rather crazy to throw his beautiful piece of software into
the trashcan out of time issues or newer API issues.

So please help! And if you need further info then please ask me!

Regards

CS


> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


