Return-path: <mchehab@gaivota>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:4204 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab0LYJEx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 25 Dec 2010 04:04:53 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: opinions about non-page-aligned buffers?
Date: Sat, 25 Dec 2010 10:04:47 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTimMMzxbnXT8nRJYWHmgjX_RJ2goj+j083JB5eLz@mail.gmail.com> <201012250032.18082.hverkuil@xs4all.nl> <AANLkTi=hjsZ=S1OJ1o5Z2xsynBDbi3fRETLFOBfTMhQ8@mail.gmail.com>
In-Reply-To: <AANLkTi=hjsZ=S1OJ1o5Z2xsynBDbi3fRETLFOBfTMhQ8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012251004.47828.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Saturday, December 25, 2010 00:47:22 Rob Clark wrote:
> On Fri, Dec 24, 2010 at 5:32 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > On Friday, December 24, 2010 22:29:37 Rob Clark wrote:
> >> Hi all,
> >>
> >> The request has come up on OMAP4 to support non-page-aligned v4l2
> >> buffers.  (This is in context of v4l2 display, but the same reasons
> >> would apply for a camera.)  For most common resolutions, this would
> >> help us get much better memory utilization for a range of memory (or
> >> rather address space) used for YUV buffers.
> >
> > Can you explain this in more detail? I don't really see how non-page
> > aligned buffers would lead to 'much better' memory usage. I would expect
> > that the best savings you could achieve would be PAGE_SIZE-1 per buffer.
> >
> 
> Due to how the buffers are mapped, the savings is actually quite
> substantial.  What actually happens is the region of memory that the
> buffers are allocated from has a stride of 16kb or 32kb.  (For NV12, Y
> has a 16kb stride, and UV is  disjoint is a 32kb stride.)  To keep
> things somewhat sane for userspace, the Y followed by UV gets mmap'd
> into consecutive 4kb pages.  So we are actually loosing 1.5 * (4kb -
> width) per buffer by forcing page alignment.  With non page-aligned
> buffers we can pack buffers next to each other, ie. so one buffer may
> exist within the stride of another buffer.

I understand. But what is the size of your buffers and how many are there?
Fiddling with non-page aligned buffers will only make sense if the savings are
substantial compared to the total size of the buffers. In my experience the
buffers are so large that savings of 1-2 pages per buffer aren't worth it.

Regards,

	Hans

> 
> 
> BR,
> -R
> 
> 
> > Regards,
> >
> >        Hans
> >
> >> However it would require
> >> a small change in the client application, since most (all) v4l2 apps
> >> that I have seen are assuming the offsets they are given to mmap are
> >> page aligned.
> >>
> >> I am curious if anyone has any suggestions about how to enable this.
> >> Ideally it would be some sort of opt-in feature to avoid breaking apps
> >> that are not aware the the offsets to mmap may not be page aligned.
> >>
> >> BR,
> >> -R
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>
> >
> > --
> > Hans Verkuil - video4linux developer - sponsored by Cisco
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
