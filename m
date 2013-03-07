Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:31882 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3CGKLk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Mar 2013 05:11:40 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Simplify VIDIOC_DBG_* ioctls
Date: Thu, 7 Mar 2013 11:11:03 +0100
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201303071111.03551.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

One thing that has annoyed me for a long time is that it is too much
work for drivers to implement these debug ioctls. What you really want in
a driver is just to implement functions to get and set registers and have
it all working automatically.

Also it is quite annoying that the v4l2-chip-ident.h header has to be updated
for every new chip for which you want to use these ioctls. Such hardcoded IDs
are frowned upon these days anyway, and for good reasons.

This RFC outlines a proposal to simplify matters.

One thing to remember is that this API was designed before we had subdevices,
so that made things more complex. The problem with that is also that non-i2c
subdevices cannot be addressed using these ioctls.

A first version of most of the proposed changes in this RFC is available
here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/chipid

The only thing missing there is DEVNODE_NAME support.

This is the current API:

#define V4L2_CHIP_MATCH_HOST       0  /* Match against chip ID on host (0 for the host) */
#define V4L2_CHIP_MATCH_I2C_DRIVER 1  /* Match against I2C driver name */
#define V4L2_CHIP_MATCH_I2C_ADDR   2  /* Match against I2C 7-bit address */
#define V4L2_CHIP_MATCH_AC97       3  /* Match against anciliary AC97 chip */

struct v4l2_dbg_match {
        __u32 type; /* Match type */
        union {     /* Match this chip, meaning determined by type */
                __u32 addr;
                char name[32];
        };
} __attribute__ ((packed));

struct v4l2_dbg_register {
        struct v4l2_dbg_match match;
        __u32 size;     /* register size in bytes */
        __u64 reg;
        __u64 val;
} __attribute__ ((packed));

/* VIDIOC_DBG_G_CHIP_IDENT */
struct v4l2_dbg_chip_ident {
        struct v4l2_dbg_match match;
        __u32 ident;       /* chip identifier as specified in <media/v4l2-chip-ident.h> */
        __u32 revision;    /* chip revision, chip specific */
} __attribute__ ((packed));

#define VIDIOC_DBG_S_REGISTER    _IOW('V', 79, struct v4l2_dbg_register)
#define VIDIOC_DBG_G_REGISTER   _IOWR('V', 80, struct v4l2_dbg_register)
#define VIDIOC_DBG_G_CHIP_IDENT _IOWR('V', 81, struct v4l2_dbg_chip_ident)

The idea is that with CHIP_IDENT you can discover which devices are addressable
and with G/S_REGISTER (only available as root) you can get/set registers.

You use v4l2_dbg_match to match devices based on the V4L2_CHIP_MATCH define.
So you can match 0-N host devices, 0-N AC97 devices, I2C devices based on their
address and I2C devices based on their driver name.

The idea is that you iterate over all possibilities and see what is available.
Obviously this is rather crude.

In addition, bridge drivers need to propagate any calls to one of these ioctls
to any subdevices they might have. This is somewhat painful and really
shouldn't be necessary since these days the v4l2 core has all that information.

So my proposal is as follows: first introduce a new ioctl:

#define V4L2_CHIP_FL_READABLE (1 << 0)
#define V4L2_CHIP_FL_WRITABLE (1 << 1)
#define V4L2_CHIP_FL_AC97     (1 << 2)

/* VIDIOC_DBG_G_CHIP_NAME */
struct v4l2_dbg_chip_name {
        struct v4l2_dbg_match match;
        char name[32];
        __u32 flags;
        __u32 reserved[8];
} __attribute__ ((packed));

#define VIDIOC_DBG_G_CHIP_NAME  _IOWR('V', 102, struct v4l2_dbg_chip_name)

And secondly introduce two new MATCH types:

#define V4L2_CHIP_MATCH_SUBDEV_IDX     4  /* Match against subdev index */
#define V4L2_CHIP_MATCH_SUBDEV_NAME    5  /* Match against subdev name */

The first matches sub-devices by just walking the list of sub-devices and
stopping at the given number (i.e. 0 is the first subdev in the list, 1 is
the second, etc).

The second matches sub-devices by the sub-device name (which is unique by
definition).

Note the absence of an ident field, that is no longer needed. Instead the name
is filled in: it is either the name of the subdev (unique) or the name of the
v4l2_device struct if there is no g_chip_name callback defined in the driver,
or the driver has to fill it in. Also note that the revision field has been
dropped. I have never seen it being used and few drivers set it anyway. It
can always be added later by using one of the reserved fields. I have no
really strong opinion on this, though.

The flags let the caller know whether it is possible to get or set registers.

There are a few other things I would like to change: the AC97 match type is
very awkward since an AC97 driver can be part of a bridge driver or it can be
a subdevice. What you really want to tell is whether or not the device follows
the AC97 register assignments. So rather than having a separate match type for
it, just set a flag telling the application that this is an AC97 device. This
allows us to phase out the AC97 match type.

I also would like to rename MATCH_HOST to MATCH_BRIDGE, which I think is a
more appropriate name.

Now, the v4l2-core can handle CHIP_NAME and the matching of sub-devices
completely on its own as it has all the information necessary. This means
that drivers only need to implement g/s_register. And g_chip_name only
needs to be implemented if there is something special that needs to be done,
such as setting the AC97 flag or if a bridge driver has multiple 'host'
devices. Currently the only driver where that applies is em28xx which has
an AC97 register block. So in the new scheme this would be implemented as
two bridge 'chips': the first is the main bridge device, the second is the
AC97 block which sets the AC97 flag.

All of this can be added without breaking the existing functionality.

The question is what to do afterwards. These ioctls are all marked as
experimental and "don't use in applications". Only v4l2-dbg should use these
ioctls. And besides, they are also called _DBG_ :-)

My personal opinion is that we have both CHIP_IDENT and CHIP_NAME co-exist
for one kernel release, but that any call to CHIP_IDENT will give a kernel
warning. Ditto for any use of MATCH_TYPE_I2C_DRIVER/I2C_ADDR/AC97.

In the next kernel DBG_G_CHIP_IDENT is dropped together with the chip-ident
header and MATCH_TYPE_I2C_DRIVER/I2C_ADDR/AC97. And all drivers using it can
be simplified.

The nice thing about all this is that almost everything can be handled in the
v4l2 core. So adding g/s_register to a subdev is enough to make it work for
any device using that subdev as there is no more need to add g/s_register
support to a bridge driver. And bridge drivers no longer have to pass it on
to subdev drivers either.

In addition, the matching is much improved since it is now covering all
subdevices and is never ambiguous (which it could be when using I2C_DRIVER).

Comments? Questions?

Regards,

	Hans
