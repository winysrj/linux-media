Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1676 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195Ab2HVIwR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Aug 2012 04:52:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC API] Renumber subdev ioctls
Date: Wed, 22 Aug 2012 10:52:02 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201208201030.30590.hverkuil@xs4all.nl> <201208210839.53924.hverkuil@xs4all.nl> <20120821104415.GF721@valkosipuli.retiisi.org.uk>
In-Reply-To: <20120821104415.GF721@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221052.02338.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 21 2012 12:44:15 Sakari Ailus wrote:
> Hi Hans,
> 
> On Tue, Aug 21, 2012 at 08:39:53AM +0200, Hans Verkuil wrote:
> > On Mon August 20 2012 22:46:04 Sakari Ailus wrote:
> > > Hi Mauro and Hans,
> > > 
> > > On Mon, Aug 20, 2012 at 04:05:03PM -0300, Mauro Carvalho Chehab wrote:
> > > > Em 20-08-2012 05:30, Hans Verkuil escreveu:
> > > > > Hi all!
> > > > > 
> > > > > Recently I had to add two new ioctls for the subdev API (include/linux/v4l2-subdev.h)
> > > > > and I noticed that the numbering of the ioctls was somewhat random.
> > > > > 
> > > > > In most cases the ioctl number was the same as the V4L2 API counterpart, but for
> > > > > subdev-specific ioctls no rule exists.
> > > > > 
> > > > > There are a few problems with this: because of the lack of rules there is a chance
> > > > > that in the future a subdev ioctl may end up to be identical to an existing V4L2
> > > > > ioctl. Also, because the numbering isn't nicely increasing it makes it hard to create
> > > > > a lookup table as was done for the V4L2 ioctls. Well, you could do it, but it would
> > > > > be a very sparse array, wasting a lot of memory.
> > > > > 
> > > > > Lookup tables have proven to be very useful, so we might want to introduce them for
> > > > > the subdev core code as well in the future.
> > > > > 
> > > > > Since the subdev API is still marked experimental, I propose to renumber the ioctls
> > > > > and use the letter 'v' instead of 'V'. 'v' was used for V4L1, and so it is now
> > > > > available for reuse.
> > > > 
> > > > 'v' is already used (mainly by fs):
> > > > 
> > > > 'v'	00-1F	linux/ext2_fs.h		conflict!
> > > > 'v'	00-1F	linux/fs.h		conflict!
> > > > 'v'	00-0F	linux/sonypi.h		conflict!
> > > > 'v'	C0-FF	linux/meye.h		conflict!
> > > > 
> > > > Reusing the ioctl numbering is a bad thing, as tracing code like strace will likely
> > > > say that a different type of ioctl was called.
> > > > 
> > > > (Yeah, unfortunately, this end by merging with duplicated stuff :< )
> > > > 
> > > > Also, I don't like the idea of deprecating it just because of that: interfaces are
> > > > supposed to be stable.
> > > > 
> > > > It should be noticed that there are very few ioctls there. So,
> > > > using a lookup table is overkill.
> > > > 
> > > > IMO, the better is to sort the ioctl's there at the header file, in order to
> > > > avoid ioctl duplicaton.
> > > 
> > > Many of the V4L2 IOCTLs are being used on subdevs, too, to the extent that
> > > subdev_do_ioctl() in drivers/media/v4l2-core/v4l2-subdev.c has a switch
> > > statement with over 20 cases. We'll get rid of two once the old crop IOCTLs
> > > are removed but we've still got over 20, and the number is likely to grow in
> > > the future. Still it's just a fraction of what V4L2 has.
> > > 
> > > We decided to use 'V' also for subdev IOCTLs for a reason I no longer
> > > remember. It's true there can be clashes with regular V4L2 IOCTLs in terms
> > > of IOCTL codes if the size of the argument struct matches. One of the
> > > reasons to use 'V' might have been that then some of the IOCTLs on a device
> > > would have different type (the letter in question) which wasn't considered
> > > pretty. 'V' is for V4L2 after all, and V4L2 subdev interface is part of the
> > > V4L2.
> > > 
> > > The numbering is based on using V4L2 IOCTLs as such if they were applicable
> > > to subdevs as such (controls) in which case they're defined in videodev2.h,
> > > and if there was even a loosely corresponding IOCTL in V4L2 then use the
> > > same number (e.g. formats vs. media bus pixel codes) and otherwise something
> > > else. The "something else" case hasn't happened yet.
> > > 
> > > It might have made sense to use a different type for the IOCTLs that aren't
> > > V4L2 IOCTLs (i.e. are subdev IOCTLs) for clarity but it's quite late for
> > > such a change. However if we think we definitely should do it then it should
> > > be done now or not at all...
> > > 
> > > If we want to just improve the efficiency of the switch statement in
> > > subdev_do_ioctl() we could divide the IOCTLs based on e.g. a few last bits
> > > of the IOCTL number into buckets.
> > 
> > It's not so much the switch efficiency. In practice there will be no measurable
> > speed difference. But a lookup table allows one to easily look up information
> > about the ioctl.
> > 
> > But the main goal would be to guarantee that subdev ioctls and V4L2 ioctls
> > will never clash, since both types of ioctls can be used with a subdev node.
> 
> It's indeed possible to have clashes between the IOCTL codes but that does
> not matter so much: all IOCTLs related to buffers belong to V4L2 and
> anything related to pads belongs to subdevs only.
> 
> As long as a little care is taken when choosing the IOCTL number we
> shouldn't have issues any more we have now. Well, that said, the IOCTLs
> belonging to the something else category are more difficult to number in a
> good way. Perhaps starting from highest IOCTL numbers before the private
> IOCTLs would be one option.

Currently I've decided to use ioctl numbers that are unused in V4L2 (there are
quite a few holes in the ioctl numbering).

> > > I don't have a strong opinion on this either way, but unless there's a
> > > concrete problem related to it I'd keep it as-is. We will definitely pick a
> > > new type for the property API when once we get that far. ;-)
> > > 
> > > Could you elaborate what you were about to add? Something that would fall
> > > into the "something else" category perhaps?
> > 
> > Yes indeed. It's two new ioctls for setting/getting the EDID.
> 
> Do these IOCTLs have (or should they have) corresponding IOCTLs in V4L2?

No. These are unique to the subdevs.

> > Currently I've chosen ioctl numbers that are not used by V4L2 (there are a
> > number of 'holes' in the ioctl list).
> > 
> > If people think it is not worth the effort, then so be it. But if we do want
> > to do this, then we can't wait any longer.
> 
> One option would be to start using a new type for the new IOCTLs but leave
> the existing ones as they are. The end result would be less elegant since
> the subdev IOCTLs would use two different types but OTOH the V4L2 IOCTLs are
> being used on subdevs as-is, too. This would at least prevent future clashes
> in IOCTL codes between V4L2 and subdev interfaces.

I don't really like that idea.

I thought that Laurent's proposal of creating SUBDEV aliases of reused V4L2
ioctls had merit. That way v4l2-subdev.h would give a nice overview of
which V4L2 ioctls are supported by the subdev API. Currently no such overview
exists to my knowledge.

With regards to adding pad fields to the existing control structs: that won't
work with queryctrl: the reserved fields are output fields only, there is no
requirement that apps have to zero them, so you can't use them to enumerate
controls for a particular pad.

A new queryctrl ioctl would have to be created for that. So if we need this
functionality, then I believe it is better to combine that with a new
queryctrl ioctl.

Regards,

	Hans
