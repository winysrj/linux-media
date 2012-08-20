Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2122 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2HTIag (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 04:30:36 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC API] Renumber subdev ioctls
Date: Mon, 20 Aug 2012 10:30:30 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201208201030.30590.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all!

Recently I had to add two new ioctls for the subdev API (include/linux/v4l2-subdev.h)
and I noticed that the numbering of the ioctls was somewhat random.

In most cases the ioctl number was the same as the V4L2 API counterpart, but for
subdev-specific ioctls no rule exists.

There are a few problems with this: because of the lack of rules there is a chance
that in the future a subdev ioctl may end up to be identical to an existing V4L2
ioctl. Also, because the numbering isn't nicely increasing it makes it hard to create
a lookup table as was done for the V4L2 ioctls. Well, you could do it, but it would
be a very sparse array, wasting a lot of memory.

Lookup tables have proven to be very useful, so we might want to introduce them for
the subdev core code as well in the future.

Since the subdev API is still marked experimental, I propose to renumber the ioctls
and use the letter 'v' instead of 'V'. 'v' was used for V4L1, and so it is now
available for reuse.

We keep the old ioctls around for a few kernel cycles, and remove them some time
next year.

Note that some V4L2 ioctls are also available for use in the subdev API (control
ioctls in particular). By using a different letter for the ioctls this will make
it easy as well to decide what lookup table to use should we decide to introduce
that in the subdev core code in the future.

Comments?

Regards,

	Hans
