Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33194 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754172Ab2HTUqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 16:46:09 -0400
Date: Mon, 20 Aug 2012 23:46:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC API] Renumber subdev ioctls
Message-ID: <20120820204604.GE721@valkosipuli.retiisi.org.uk>
References: <201208201030.30590.hverkuil@xs4all.nl>
 <50328A5F.20303@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50328A5F.20303@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Mon, Aug 20, 2012 at 04:05:03PM -0300, Mauro Carvalho Chehab wrote:
> Em 20-08-2012 05:30, Hans Verkuil escreveu:
> > Hi all!
> > 
> > Recently I had to add two new ioctls for the subdev API (include/linux/v4l2-subdev.h)
> > and I noticed that the numbering of the ioctls was somewhat random.
> > 
> > In most cases the ioctl number was the same as the V4L2 API counterpart, but for
> > subdev-specific ioctls no rule exists.
> > 
> > There are a few problems with this: because of the lack of rules there is a chance
> > that in the future a subdev ioctl may end up to be identical to an existing V4L2
> > ioctl. Also, because the numbering isn't nicely increasing it makes it hard to create
> > a lookup table as was done for the V4L2 ioctls. Well, you could do it, but it would
> > be a very sparse array, wasting a lot of memory.
> > 
> > Lookup tables have proven to be very useful, so we might want to introduce them for
> > the subdev core code as well in the future.
> > 
> > Since the subdev API is still marked experimental, I propose to renumber the ioctls
> > and use the letter 'v' instead of 'V'. 'v' was used for V4L1, and so it is now
> > available for reuse.
> 
> 'v' is already used (mainly by fs):
> 
> 'v'	00-1F	linux/ext2_fs.h		conflict!
> 'v'	00-1F	linux/fs.h		conflict!
> 'v'	00-0F	linux/sonypi.h		conflict!
> 'v'	C0-FF	linux/meye.h		conflict!
> 
> Reusing the ioctl numbering is a bad thing, as tracing code like strace will likely
> say that a different type of ioctl was called.
> 
> (Yeah, unfortunately, this end by merging with duplicated stuff :< )
> 
> Also, I don't like the idea of deprecating it just because of that: interfaces are
> supposed to be stable.
> 
> It should be noticed that there are very few ioctls there. So,
> using a lookup table is overkill.
> 
> IMO, the better is to sort the ioctl's there at the header file, in order to
> avoid ioctl duplicaton.

Many of the V4L2 IOCTLs are being used on subdevs, too, to the extent that
subdev_do_ioctl() in drivers/media/v4l2-core/v4l2-subdev.c has a switch
statement with over 20 cases. We'll get rid of two once the old crop IOCTLs
are removed but we've still got over 20, and the number is likely to grow in
the future. Still it's just a fraction of what V4L2 has.

We decided to use 'V' also for subdev IOCTLs for a reason I no longer
remember. It's true there can be clashes with regular V4L2 IOCTLs in terms
of IOCTL codes if the size of the argument struct matches. One of the
reasons to use 'V' might have been that then some of the IOCTLs on a device
would have different type (the letter in question) which wasn't considered
pretty. 'V' is for V4L2 after all, and V4L2 subdev interface is part of the
V4L2.

The numbering is based on using V4L2 IOCTLs as such if they were applicable
to subdevs as such (controls) in which case they're defined in videodev2.h,
and if there was even a loosely corresponding IOCTL in V4L2 then use the
same number (e.g. formats vs. media bus pixel codes) and otherwise something
else. The "something else" case hasn't happened yet.

It might have made sense to use a different type for the IOCTLs that aren't
V4L2 IOCTLs (i.e. are subdev IOCTLs) for clarity but it's quite late for
such a change. However if we think we definitely should do it then it should
be done now or not at all...

If we want to just improve the efficiency of the switch statement in
subdev_do_ioctl() we could divide the IOCTLs based on e.g. a few last bits
of the IOCTL number into buckets.

I don't have a strong opinion on this either way, but unless there's a
concrete problem related to it I'd keep it as-is. We will definitely pick a
new type for the property API when once we get that far. ;-)

Could you elaborate what you were about to add? Something that would fall
into the "something else" category perhaps?

Regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
