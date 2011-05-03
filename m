Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56676 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab1ECNH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 May 2011 09:07:59 -0400
Received: by eyx24 with SMTP id 24so14599eyx.19
        for <linux-media@vger.kernel.org>; Tue, 03 May 2011 06:07:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304390415.2461.126.camel@localhost>
References: <E1QGwlS-0006ys-15@www.linuxtv.org>
	<201105022202.57946.hverkuil@xs4all.nl>
	<BANLkTinzrccpQHk1qrDyT6VbfTPVBCGKkQ@mail.gmail.com>
	<201105022331.29142.hverkuil@xs4all.nl>
	<1304390415.2461.126.camel@localhost>
Date: Tue, 3 May 2011 09:07:57 -0400
Message-ID: <BANLkTi=LENT2DgPBdoBFWp7K-fBTWHL67g@mail.gmail.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw
 YUV video capture
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	Simon Farnsworth <simon.farnsworth@onelan.co.uk>,
	Steven Toth <stoth@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Andy,

On Mon, May 2, 2011 at 10:40 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Hi All,
>
> Ah crud, what a mess.  Where to begin...?
>
> Where have I been:
>
> On 30 March 2011, my 8-year-old son was diagnosed with Necrotizing
> Fasciitis caused by Invasive Group A Streptococcous - otherwise known as
> "Flesh-eating bacteria":
>
> http://en.wikipedia.org/wiki/Necrotizing_fasciitis
> http://www.ncbi.nlm.nih.gov/pubmedhealth/PMH0002415/
>
> By the grace of God, my son was diagnosed very early.  He only lost the
> fascia on his left side and one lymph node - damage essentially
> unnoticable to anyone, including my son himself.  His recovery progress
> is excellent and he is now back to his normal life. Yay! \O/

I am very sorry to hear about this, and am happy to hear he is doing
better now.  My thoughts go out to you and your family.

> Naturally, Linux driver development disappeared from my mind during the
> extended hospital stay, multiple surgeries, and post-hospitalization
> recovery.
>
> As always; yard-work, house-work, work-work, choir practice, kids'
> sports, kids' after school clubs, and kids' instrument lessons also
> consume my time.

Lest we not forget our relative priorities.  LinuxTV isn't saving the
world: it's making it easier for people to watch television.  I think
everyone here would be appalled if your priorities were reversed just
for the benefit of fixing TV tuners.

> History of this patch:
<snip>

> My thoughts:
>
> 1. I don't want to stop progress, so I did not NACK this patch.  I don't
> exactly like the patch either, so I didn't ACK it.

I can certainly appreciate this, as I've been in this situation myself
more than once.

> 2. At a minimum someone needs to review Simon's revised patch that tried
> to address my comments.  That patch has to be better than this one.
> Hans has already noticed a few of the bugs I pointed out to Steven and
> Simon.

Admittedly it's unfortunate that we didn't know there was a newer
version of the patch, and it would definitely be a shame to see
Simon's incremental work go to waste.  That said, it would be nice to
perhaps see the incremental improvements separated out into a separate
patch from Steven's original, so we can understand what constitutes
the original work versus what were the cleanup/improvements made by
Simon.

> 3. I value that this patch has been tested, but I am guessing the
> use-case was limited.  The toughest cx18 use-cases involve a lot of
> concurrency - multiple stream captures (MPEG, VBI, YUV, PCM) on multiple
> boards (3 or 4).  I had to do a lot of work with the driver to get that
> concurrency reliable and performing well.  Has this been tested post-BKL
> removal?  Have screen sizes other than the full-screen size been tested?

Good questions.  Simon?

> 4. I do not like using videobuf(1) for this.  Videobuf(1) is a buggy
> dead-end IMO.  I will NACK any patch that tries to fix anything due to
> videobuf(1) related problems introduced into cx18 by this patch.
> There's no point in throwing too much effort into fixing what would
> likely be unfixable.

I don't think we're trying to make videobuf1 into something it's not.
The goal here is feature parity with other VB1 based devices.  In
fact, it's not even that:  it's just being able to meet the userland
API requirements related to providing video frames instead of a stream
of YUV bytes.

> 5. When I am done with my videobuf2 stuff for cx18, I will essentially
> revert this one and add in my new implementation after sufficient
> testing.  Though given the amount of time I have for this, maybe the
> last HVR-1600 will be dead before then.

I don't see why anyone would have any objection to this provided it
doesn't result in any regression in functionality.  The only concerns
I would have were if the VB2 cutover was submitted before fully baked,
resulting in some loss of existing functionality that was considered
important to the user base.  And of course the more practical concern
that it's unclear even by your own admission when/if this would
actually happen.

> Summary:
>
> 1. I'm not going to fix any YUV related problems merging this patch
> causes.  It's the YUV stream of an MPEG capture card that's more
> expensive than a simple frame grabber.  (I've only heard of it being
> used for live play of video games and of course for Simon's
> application.)

Seems reasonable.  To my knowledge nobody has been using the cx18 YUV
support anyway other than Simon, which is what prompted his
contributions in the first place.  In fact in the long term I would be
perfectly happy to see /dev/video32 disappear entirely since it just
causes confusion for regular users trying to figure out what video
device to choose.

> 2. I'd at least like Simon's revised patch to be merged instead, to fix
> the known deficincies in this one.

Agreed.

> 3. If merging this patch, means a change to videobuf2 in the future is
> not allowed, than I'd prefer to NACK the patch that introduces
> videobuf(1) into cx18.

I cannot imagine any case where moving the driver to VB2 would be
blocked by having put in this patch.  I think everybody agrees that
VB2 is the long-term solution.  It's just a question of who incurs the
cost of conversion and at what point in time.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
