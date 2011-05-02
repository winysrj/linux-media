Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3779 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab1EBVbk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2011 17:31:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Mon, 2 May 2011 23:31:29 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <201105022202.57946.hverkuil@xs4all.nl> <BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
In-Reply-To: <BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105022331.29142.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday, May 02, 2011 22:59:09 Devin Heitmueller wrote:
> On Mon, May 2, 2011 at 4:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > It was merged without *asking* Andy. I know he has had some private stuff to
> > deal with this month so I wasn't surprised that he hadn't reviewed it yet.
> >
> > It would have been nice if he was reminded first of this patch. It's a
> > fairly substantial change that also has user-visible implications. The simple
> > fact is that this patch has not been reviewed and as a former cx18 maintainer
> > I think that it needs a review first.
> >
> > If someone had asked and Andy wouldn't have been able to review, then I'd have
> > jumped in and would have reviewed it.
> >
> > Andy, I hope you can look at it, but if not, then let me know and I'll do a
> > more in-depth review rather than just the simple scan I did now.
> >
> >> Now that the patch were committed, I won't revert it without a very good reason.
> >>
> >> With respect to the "conversion from UYVY format to YUYV", a simple patch could
> >> fix it, instead of removing the entire patchset.
> >
> > No, please remove the patchset because I have found two other issues:
> >
> > The patch adds this field:
> >
> >        struct v4l2_framebuffer fbuf;
> >
> > This is not needed, videobuf_iolock can be called with a NULL pointer instead
> > of &fbuf.
> >
> > The patch also adds tvnorm fields, but never sets s->tvnorm. And it's
> > pointless anyway since you can't change tvnorm while streaming.
> >
> > Given that I've found three things now without even trying suggests to me that
> > it is too soon to commit this. Sorry.
> >
> > Regards,
> >
> >        Hans
> 
> Indeed comments/review are always welcome, although it would have been
> great if it had happened a month ago.  It's the maintainer's
> responsibility to review patches, and if he has issues to raise them
> in a timely manner.  If he doesn't care enough or is too busy to
> publicly say "hold off on this" for whatever reason, then you can
> hardly blame Mauro for merging it.

It's also a good idea if the author of a patch pings the list if there
has been no feedback after one or two weeks. It's easy to forget patches,
people can be on vacation, be sick, or in the case of Andy, have a family
emergency.

> Likewise, I know there have indeed been cases in the past where code
> got upstream that caused regressions (in fact, you have personally
> been responsible for some of these if I recall).
> 
> Let's not throw the baby out with the bathwater.  If there are real
> structural issues with the patch, then let's get them fixed.  But if
> we're just talking about a few minor "unused variable" type of
> aesthetic issues, then that shouldn't constitute reverting the commit.
>  Do your review, and if an additional patch is needed with a half
> dozen removals of dead/unused code, then so be it.

Well, one structural thing I am not at all happy about (but it is Andy's
call) is that it uses videobuf instead of vb2. Since this patch only deals
with YUV it shouldn't be hard to use vb2. The problem with videobuf is that
it violates the V4L2 spec in several places so I would prefer not to use
videobuf in cx18. If only because converting cx18 to vb2 later will change
the behavior of the stream I/O (VIDIOC_REQBUFS in particular), which is
something I would like to avoid if possible.

I know that Andy started work on vb2 in cx18 for all stream types (not just
YUV). I have no idea of the current state of that work. But it might be a
good starting point to use this patch and convert it to vb2. Later Andy can
add vb2 support for the other stream types.

> We're not talking about an untested board profile submitted by some
> random user.  We're talking about a patch written by someone highly
> familiar with the chipset and it's *working code* that has been
> running in production for almost a year.

It's not about that, it's about merging something substantial without the SoB
of the maintainer and without asking the maintainer.

I'm not blaming anyone, it's just a miscommunication. What should happen with
this patch is up to Andy.

Regards,

	Hans
