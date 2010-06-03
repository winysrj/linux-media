Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab0FCWIy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Jun 2010 18:08:54 -0400
Date: Thu, 3 Jun 2010 18:06:49 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, lirc@bartelmus.de
Subject: Re: [PATCH 1/3] IR: add core lirc device interface
Message-ID: <20100603220649.GC23375@redhat.com>
References: <20100601205005.GA28322@redhat.com>
 <20100601205137.GA31616@redhat.com>
 <4C074563.4080305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C074563.4080305@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 03, 2010 at 03:02:11AM -0300, Mauro Carvalho Chehab wrote:
> Em 01-06-2010 17:51, Jarod Wilson escreveu:
> > Add the core lirc device interface (http://lirc.org/).
> > 
> > This is a 99.9% unaltered lirc_dev device interface (only change being
> > the path to lirc.h), which has been carried in the Fedora kernels and
> > has been built for numerous other distro kernels for years. In the
> > next two patches in this series, ir-core will be wired up to make use
> > of the lirc interface as one of many IR protocol decoder options. In
> > this case, raw IR will be delivered to the lirc userspace daemon, which
> > will then handle the decoding.
> > 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/media/IR/Kconfig    |   11 +
> >  drivers/media/IR/Makefile   |    1 +
> >  drivers/media/IR/lirc_dev.c |  850 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/media/IR/lirc_dev.h |  228 ++++++++++++
> >  include/media/lirc.h        |  159 ++++++++
> >  5 files changed, 1249 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/media/IR/lirc_dev.c
> >  create mode 100644 drivers/media/IR/lirc_dev.h
> >  create mode 100644 include/media/lirc.h
> > 
...
> > +#ifdef CONFIG_COMPAT
> > +#define LIRC_GET_FEATURES_COMPAT32     _IOR('i', 0x00000000, __u32)
> > +
> > +#define LIRC_GET_SEND_MODE_COMPAT32    _IOR('i', 0x00000001, __u32)
> > +#define LIRC_GET_REC_MODE_COMPAT32     _IOR('i', 0x00000002, __u32)
> > +
> > +#define LIRC_GET_LENGTH_COMPAT32       _IOR('i', 0x0000000f, __u32)
> > +
> > +#define LIRC_SET_SEND_MODE_COMPAT32    _IOW('i', 0x00000011, __u32)
> > +#define LIRC_SET_REC_MODE_COMPAT32     _IOW('i', 0x00000012, __u32)
> > +
> > +long lirc_dev_fop_compat_ioctl(struct file *file,
> > +			       unsigned int cmd32,
> > +			       unsigned long arg)
> > +{
> > +	mm_segment_t old_fs;
> > +	int ret;
> > +	unsigned long val;
> > +	unsigned int cmd;
> > +
> > +	switch (cmd32) {
> > +	case LIRC_GET_FEATURES_COMPAT32:
> > +	case LIRC_GET_SEND_MODE_COMPAT32:
> > +	case LIRC_GET_REC_MODE_COMPAT32:
> > +	case LIRC_GET_LENGTH_COMPAT32:
> > +	case LIRC_SET_SEND_MODE_COMPAT32:
> > +	case LIRC_SET_REC_MODE_COMPAT32:
> > +		/*
> > +		 * These commands expect (unsigned long *) arg
> > +		 * but the 32-bit app supplied (__u32 *).
> > +		 * Conversion is required.
> > +		 */
> > +		if (get_user(val, (__u32 *)compat_ptr(arg)))
> > +			return -EFAULT;
> > +		lock_kernel();
> 
> Hmm... BKL? Are you sure you need it here? As BKL are being removed, please rewrite
> it to use another kind of lock.
> 
> On a first glance, I suspect that you should be locking &ir->irctl_lock inside
> lirc_dev_fop_ioctl() and just remove the BKL calls on lirc_dev_fop_compat_ioctl().

Ew, yeah, looks like there's some missing locking in lirc_dev_fop_ioctl(),
though its never been a problem in practice, from what I've seen... Okay,
will add locking there.

As for the compat bits... I actually pulled them out of the Fedora kernel
and userspace for a while, and there were only a few people who really ran
into issues with it, but I think if the new userspace and kernel are rolled
out at the same time in a new distro release (i.e., Fedora 14, in our
particular case), it should be mostly transparent to users. Christoph
wasn't a fan of the change, and actually asked me to revert it, so I'm
cc'ing him here for further feedback, but I'm inclined to say that if this
is the price we pay to get upstream, so be it.


> Btw, as this is the first in-tree kernel driver for lirc, I would just define the
> lirc ioctls with __u32 and remove the entire compat stuff.

I've pushed a patch into my ir-wip tree, ir branch, that does this:

http://git.wilsonet.com/linux-2.6-ir-wip.git/?a=shortlog;h=refs/heads/ir

I've tested it out, and things still work as expected w/my mceusb port and
the ir-lirc-codec ir-core bridge driver, after rebuilding the lirc
userspace (64-bit host) to match up the ioctl definitions.

> > +/*
> > + * from the next key press on the driver will send
> > + * LIRC_MODE2_FREQUENCY packets
> > + */
> > +#define LIRC_MEASURE_CARRIER_ENABLE    _IO('i', 0x00000021)
> > +#define LIRC_MEASURE_CARRIER_DISABLE   _IO('i', 0x00000022)
> > +
> > +#endif
> 
> Wow! There are lots of ioctls that aren't currently used. IMO, the better is to add
> at the file just the ioctls that are currently in usage, and to put some documentation
> about them at /Documentation.

Several of the ioctls were only very recently (past 4 months) added, but I
haven't a clue what they're actually used for... Adding something to
Documentation/ would definitely be prudent in any case.

-- 
Jarod Wilson
jarod@redhat.com

