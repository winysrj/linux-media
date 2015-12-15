Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:52257 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895AbbLOPww (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Dec 2015 10:52:52 -0500
Date: Tue, 15 Dec 2015 13:52:45 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Benoit Parrot <bparrot@ti.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [Patch v5 1/2] media: v4l: ti-vpe: Add CAL v4l2 camera capture
 driver
Message-ID: <20151215135245.4d78f8a8@recife.lan>
In-Reply-To: <20151211221633.GF1517@ti.com>
References: <1447879632-22635-1-git-send-email-bparrot@ti.com>
	<1447879632-22635-2-git-send-email-bparrot@ti.com>
	<20151203111922.7b9bb226@recife.lan>
	<20151211221633.GF1517@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 11 Dec 2015 16:16:33 -0600
Benoit Parrot <bparrot@ti.com> escreveu:

> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote on Thu [2015-Dec-03 11:19:22 -0200]:
> > Em Wed, 18 Nov 2015 14:47:11 -0600
> > Benoit Parrot <bparrot@ti.com> escreveu:
> > 
> > > The Camera Adaptation Layer (CAL) is a block which consists of a dual
> > > port CSI2/MIPI camera capture engine.
> > > Port #0 can handle CSI2 camera connected to up to 4 data lanes.
> > > Port #1 can handle CSI2 camera connected to up to 2 data lanes.
> > > The driver implements the required API/ioctls to be V4L2 compliant.
> > > Driver supports the following:
> > >     - V4L2 API using DMABUF/MMAP buffer access based on videobuf2 api
> > >     - Asynchronous sensor sub device registration
> > 
> > Please see the comments I did for the git pull request. Additionally,
> > see below.
> 
> Yes I'll take care of the comments about the MAINTAINERS mods and patch order.
> 
> However I do have a few question on your comments, see below.

(removed the code that was already agreed or that Hans commented)

> > > 
> > > +/* register field read/write helpers */
> > > +static inline int get_field(u32 value, u32 mask, int shift)
> > > +{
> > > +	return (value & (mask << shift)) >> shift;
> > > +}
> > 
> > Please use the macros defined at bitmap.h instead of writing your own
> > version of it.
> 
> Not exactly sure what you meant here. 
> 
> Did you mean bitops.h instead as in change read_field() and write_field()
> to use __ffs or something like that?
> 
> If that is the case then I would have to change all of the bit mask and shift
> macros in cal_regs.h before I do that I want to make sure we are on the same
> page.

Yes, i mean include/linux/bitops.h.

There are several things that you dould use to simplify it using some
definitions there (and not only __ffs).

See those macros, for example:

#define BIT_MASK(nr)		(1UL << ((nr) % BITS_PER_LONG))

/*
 * Create a contiguous bitmask starting at bit position @l and ending at
 * position @h. For example
 * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
 */
#define GENMASK(h, l) \
	(((~0UL) << (l)) & (~0UL >> (BITS_PER_LONG - 1 - (h))))

#define GENMASK_ULL(h, l) \
	(((~0ULL) << (l)) & (~0ULL >> (BITS_PER_LONG_LONG - 1 - (h))))

Regards,
Mauro
