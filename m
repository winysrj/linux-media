Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51327 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755371Ab1ECCjY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 22:39:24 -0400
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>
In-Reply-To: <201105022331.29142.hverkuil@xs4all.nl>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	 <201105022202.57946.hverkuil@xs4all.nl>
	 <BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
	 <201105022331.29142.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 May 2011 22:40:15 -0400
Message-ID: <1304390415.2461.126.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi All,

Ah crud, what a mess.  Where to begin...?

Where have I been:

On 30 March 2011, my 8-year-old son was diagnosed with Necrotizing
Fasciitis caused by Invasive Group A Streptococcous - otherwise known as
"Flesh-eating bacteria":

http://en.wikipedia.org/wiki/Necrotizing_fasciitis
http://www.ncbi.nlm.nih.gov/pubmedhealth/PMH0002415/

By the grace of God, my son was diagnosed very early.  He only lost the
fascia on his left side and one lymph node - damage essentially
unnoticable to anyone, including my son himself.  His recovery progress
is excellent and he is now back to his normal life. Yay! \O/

Naturally, Linux driver development disappeared from my mind during the
extended hospital stay, multiple surgeries, and post-hospitalization
recovery.

As always; yard-work, house-work, work-work, choir practice, kids'
sports, kids' after school clubs, and kids' instrument lessons also
consume my time.




History of this patch:

1. Steven wrote the bulk of it 10 months ago:

	http://www.kernellabs.com/hg/~stoth/cx18-videobuf/

2. At Steven's request, I took a day and reviewed it on July 10 2010 and
provide comments off-list.  (I will provide them in a follow up to Mauro
Devin and Hans).

3. The patch languished as Steven didn't have time to make the fixes and
neither did I.

4. Videobuf2 came along as did good documentation on the deficiencies of
videobuf1:

http://linuxtv.org/downloads/presentations/summit_jun_2010/20100614-v4l2_summit-videobuf.pdf
http://linuxtv.org/downloads/presentations/summit_jun_2010/Videobuf_Helsinki_June2010.pdf
http://lwn.net/Articles/415883/

5. I started independent work to implement videobuf2 for YUV and
actually using zero-copy.  My progress is very slow.

http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18-vb2-proto
http://git.linuxtv.org/awalls/media_tree.git?a=shortlog;h=refs/heads/cx18_39

6. Simon submits the patches to the list as one big patch.

7. Off-list I forward the same 5 emails of comments to Simon as I
provided in #2 to Steven.

8. Simon addresses most of the comments and provides a revised patch
off-list asking for review.  I haven't had time to look at it.

9. Mauro commits the original patch that Simon submitted to the list.


My thoughts:

1. I don't want to stop progress, so I did not NACK this patch.  I don't
exactly like the patch either, so I didn't ACK it.

2. At a minimum someone needs to review Simon's revised patch that tried
to address my comments.  That patch has to be better than this one.
Hans has already noticed a few of the bugs I pointed out to Steven and
Simon.

3. I value that this patch has been tested, but I am guessing the
use-case was limited.  The toughest cx18 use-cases involve a lot of
concurrency - multiple stream captures (MPEG, VBI, YUV, PCM) on multiple
boards (3 or 4).  I had to do a lot of work with the driver to get that
concurrency reliable and performing well.  Has this been tested post-BKL
removal?  Have screen sizes other than the full-screen size been tested?

4. I do not like using videobuf(1) for this.  Videobuf(1) is a buggy
dead-end IMO.  I will NACK any patch that tries to fix anything due to
videobuf(1) related problems introduced into cx18 by this patch.
There's no point in throwing too much effort into fixing what would
likely be unfixable.

5. When I am done with my videobuf2 stuff for cx18, I will essentially
revert this one and add in my new implementation after sufficient
testing.  Though given the amount of time I have for this, maybe the
last HVR-1600 will be dead before then.


Summary:

1. I'm not going to fix any YUV related problems merging this patch
causes.  It's the YUV stream of an MPEG capture card that's more
expensive than a simple frame grabber.  (I've only heard of it being
used for live play of video games and of course for Simon's
application.)

2. I'd at least like Simon's revised patch to be merged instead, to fix
the known deficincies in this one.

3. If merging this patch, means a change to videobuf2 in the future is
not allowed, than I'd prefer to NACK the patch that introduces
videobuf(1) into cx18.


Regards,
Andy



On Mon, 2011-05-02 at 23:31 +0200, Hans Verkuil wrote:
> On Monday, May 02, 2011 22:59:09 Devin Heitmueller wrote:
> > On Mon, May 2, 2011 at 4:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > > It was merged without *asking* Andy. I know he has had some private stuff to
> > > deal with this month so I wasn't surprised that he hadn't reviewed it yet.
> > >
> > > It would have been nice if he was reminded first of this patch. It's a
> > > fairly substantial change that also has user-visible implications. The simple
> > > fact is that this patch has not been reviewed and as a former cx18 maintainer
> > > I think that it needs a review first.
> > >
> > > If someone had asked and Andy wouldn't have been able to review, then I'd have
> > > jumped in and would have reviewed it.
> > >
> > > Andy, I hope you can look at it, but if not, then let me know and I'll do a
> > > more in-depth review rather than just the simple scan I did now.
> > >
> > >> Now that the patch were committed, I won't revert it without a very good reason.
> > >>
> > >> With respect to the "conversion from UYVY format to YUYV", a simple patch could
> > >> fix it, instead of removing the entire patchset.
> > >
> > > No, please remove the patchset because I have found two other issues:
> > >
> > > The patch adds this field:
> > >
> > >        struct v4l2_framebuffer fbuf;
> > >
> > > This is not needed, videobuf_iolock can be called with a NULL pointer instead
> > > of &fbuf.
> > >
> > > The patch also adds tvnorm fields, but never sets s->tvnorm. And it's
> > > pointless anyway since you can't change tvnorm while streaming.
> > >
> > > Given that I've found three things now without even trying suggests to me that
> > > it is too soon to commit this. Sorry.
> > >
> > > Regards,
> > >
> > >        Hans
> > 
> > Indeed comments/review are always welcome, although it would have been
> > great if it had happened a month ago.  It's the maintainer's
> > responsibility to review patches, and if he has issues to raise them
> > in a timely manner.  If he doesn't care enough or is too busy to
> > publicly say "hold off on this" for whatever reason, then you can
> > hardly blame Mauro for merging it.
> 
> It's also a good idea if the author of a patch pings the list if there
> has been no feedback after one or two weeks. It's easy to forget patches,
> people can be on vacation, be sick, or in the case of Andy, have a family
> emergency.
> 
> > Likewise, I know there have indeed been cases in the past where code
> > got upstream that caused regressions (in fact, you have personally
> > been responsible for some of these if I recall).
> > 
> > Let's not throw the baby out with the bathwater.  If there are real
> > structural issues with the patch, then let's get them fixed.  But if
> > we're just talking about a few minor "unused variable" type of
> > aesthetic issues, then that shouldn't constitute reverting the commit.
> >  Do your review, and if an additional patch is needed with a half
> > dozen removals of dead/unused code, then so be it.
> 
> Well, one structural thing I am not at all happy about (but it is Andy's
> call) is that it uses videobuf instead of vb2. Since this patch only deals
> with YUV it shouldn't be hard to use vb2. The problem with videobuf is that
> it violates the V4L2 spec in several places so I would prefer not to use
> videobuf in cx18. If only because converting cx18 to vb2 later will change
> the behavior of the stream I/O (VIDIOC_REQBUFS in particular), which is
> something I would like to avoid if possible.
> 
> I know that Andy started work on vb2 in cx18 for all stream types (not just
> YUV). I have no idea of the current state of that work. But it might be a
> good starting point to use this patch and convert it to vb2. Later Andy can
> add vb2 support for the other stream types.
> 
> > We're not talking about an untested board profile submitted by some
> > random user.  We're talking about a patch written by someone highly
> > familiar with the chipset and it's *working code* that has been
> > running in production for almost a year.
> 
> It's not about that, it's about merging something substantial without the SoB
> of the maintainer and without asking the maintainer.
> 
> I'm not blaming anyone, it's just a miscommunication. What should happen with
> this patch is up to Andy.
> 
> Regards,
> 
> 	Hans


