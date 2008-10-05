Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m95BJrrA010147
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:19:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m95BJeVn020864
	for <video4linux-list@redhat.com>; Sun, 5 Oct 2008 07:19:41 -0400
Date: Sun, 5 Oct 2008 08:19:31 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Shah, Hardik" <hardik.shah@ti.com>
Message-ID: <20081005081931.1dfdd7b4@pedra.chehab.org>
In-Reply-To: <5A47E75E594F054BAF48C5E4FC4B92AB02D603E9FB@dbde02.ent.ti.com>
References: <200810031633.43418.hverkuil@xs4all.nl>
	<5A47E75E594F054BAF48C5E4FC4B92AB02D603E9FB@dbde02.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-fbdev-devel@lists.sourceforge.net"
	<linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [PATCH] OMAP 2/3 V4L2 display driver on video planes
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Fri, 3 Oct 2008 20:10:36 +0530
"Shah, Hardik" <hardik.shah@ti.com> wrote:


> > 2) Can you describe what the non-standard v4l2 ioctls are used for? I
> > suspect that some of these can be done differently. Something like a
> > chromakey is already available in v4l2 (through VIDIOC_G/S_FBUF and
> > VIDIOC_G/S_FMT), things like mirror is available as a control, and
> > rotation should perhaps be a control as well. Ditto for background
> > color. These are just ideas, it depends on how it is used exactly.
> [Shah, Hardik] Hans I will revisit the code and will provide you with the sufficient information.

I don't like the idea of having private ioctls. This generally means that only
a very restricted subset of userspace apps that are aware of the that API will
work. This is really bad.

So, I prefer to discuss the need for newer ioctls and add it into the standard
whenever make some sense (ok, maybe you might have some ioctls that are really
very specific for your app and that won't break userspace apps - I've acked
with 2 private ioctls on uvc driver in the past due to that).

> > 3) Some of the lines are broken up rather badly probably to respect the
> > 80 column maximum. Note that the 80 column maximum is a recommendation,
> > and that readability is more important. So IMHO it's better to have a
> > slightly longer line and break it up at a more logical place. However,
> > switching to video_ioctl2 will automatically reduce the indentation, so
> > this might not be that much of an issue anymore.
> [Shah, Hardik] 80 column was implemented to make the checkpatch pass.  Point noted and will take care of this.

The 80 column rule isn't there for nothing.

It is a sort of checking if some common bad practices aren't used inside the
drivers, like having lots of indentation levels inside the functions, or long
("Pascal like") names for vars.

So, if you are having several points where you're violating the rule, probably
your code is very complex or you are using long names instead of short ones. On
the fisrt case, try to break the complex stuff  into smaller and simpler static
functions. The compiler will deal with those functions like inline, so this
won't cost cpu cycles, but it will make easier for people to understand what
you're doing.

> > It is possible to setup a mercurial repository on linuxtv.org? I thought
> > that Manju has an account by now.

I don't remember if I created an account for Manju. If not, please ping me. I
prefer to not setup an account for every single developer, since LinuxTV
machine is not meant to be a host server.

Perhaps the better would be for you to have one public machine where you all
can work and merge your work. I'm OK on pulling and seeing patches outside LinuxTV.

> > This is useful as well for all the
> > other omap camera patches. I've seen omap patches popping up all over
> > the place for the past six months (if not longer) but it needs to be a
> > bit more organized if you want it to be merged. Setting up v4l-dvb
> > repositories containing the new patches is a good way of streamlining
> > the process.
> > 
> > Obviously the process is more complicated for you since the omap stuff
> > relies on various subsystems and platform code. Perhaps someone within
> > TI should be coordinating this?
> [Shah, Hardik] we are in process of coordinating this.

One option in the future is to base your work on a git tree. I've changed a lot
the proccess of submitting patches upstream, to avoid having to rebase my tree
(Yet, I had to do two rebases during 2.6.27 cycle). If I can keep my tree
without rebase, the developers may rely on it and start sending me git pull
requests also. Let's see if I can do this for 2.6.28.

I think we should start discussing using git trees as the reference for
v4l/dvb development, and start moving developers tree to git. This would solve
the issues with complex projects like OMAP, where you need to touch not only on
V4L/DVB subsystem.

This topic deserves some more discussion, 

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
