Return-path: <mchehab@gaivota>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:2782 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371Ab0LaMzV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 07:55:21 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 00/10] [RFC] Prio handling and v4l2_device release callback
Date: Fri, 31 Dec 2010 13:55:05 +0100
Cc: linux-media@vger.kernel.org
References: <cover.1293657717.git.hverkuil@xs4all.nl> <201012311225.16349.hverkuil@xs4all.nl> <4D1DC0DD.7060809@redhat.com>
In-Reply-To: <4D1DC0DD.7060809@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311355.05143.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 31, 2010 12:39:09 Mauro Carvalho Chehab wrote:
> Em 31-12-2010 09:25, Hans Verkuil escreveu:
> > On Friday, December 31, 2010 12:01:17 Mauro Carvalho Chehab wrote:
> >> Em 29-12-2010 19:43, Hans Verkuil escreveu:
> >>> This patch series adds two new features to the V4L2 framework.
> >>>
> >>> The first 5 patches add support for VIDIOC_G/S_PRIORITY. All prio handling
> >>> will be done in the core for any driver that either uses struct v4l2_fh
> >>> (ivtv only at the moment) or has no open and release file operations (true
> >>> for many simple (radio) drivers). In all other cases the driver will have
> >>> to do the work.
> >>
> >> It doesn't make sense to implement this at core, and for some this will happen
> >> automatically, while, for others, drivers need to do something.
> > 
> > However, it makes it possible to gradually convert all drivers.
> 
> This will likely mean years of conversion.
> >  
> >>> Eventually all drivers should either use v4l2_fh or never set filp->private_data.
> >>
> >> I made a series of patches, due to BKL stuff converting the core to always
> >> use v4l2_fh on all drivers. This seems to be the right solution for it.
> > 
> > Can you point me to those patches? I remember seeing them, but can't remember where.
> 
> They are at devel/bkl branch. The main one is this:
> 
> http://git.linuxtv.org/media_tree.git?a=commitdiff;h=285267378581fbf852f24f3f99d2e937cd200fd5
> 
> I remember you had some issues on it, but it is just a matter of fixing them.

Thanks, I'll take a look.

> > I see two potential problems with this approach:
> > 
> > 1) A lot of drivers do not actually need to allocate a v4l2_fh struct, so it
> >    wastes memory. But on the other hand, it would be nicely consistent.
> 
> A typical driver allocates at least 2 buffers of 640x480x2. How much memory a
> v4l2_fh struct would require? I didn't calculate, but probably less than 0.01%.
> I don't think that the extra consumption of memory will have any real impact, even
> on embedded. On the other hand, if you need to add the priority handling via code,
> you'll probably waste more on codespace than the size of the struct.

Actually, I was thinking about the radio drivers which do not use buffers.

However, I realized that we also want to add an event that is sent whenever a
control changes value. It's not yet implemented, but it's easy to do with the
control framework. And since almost all drivers have controls, this also means
that all drivers need to use v4l2_fh since that is a prerequisite for events.

So it is indeed much better to create v4l2_fh structs in the core.

Regards,

	Hans

> 
> > 2) I prefer for core changes to have the least possible impact to existing drivers,
> >    and just convert existing drivers one by one.
> 
> A per-driver implementation means per-driver errors. A per-core implementation means
> that, once it is fixed, all drivers will be OK. 
> 
> > But I would have to see your patch series again to see the impact of such a
> > change.
> > 
> 
> > Regards,
> > 
> > 	Hans
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
