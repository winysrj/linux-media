Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2HTTFJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Aug 2012 15:05:09 -0400
Message-ID: <50328A5F.20303@redhat.com>
Date: Mon, 20 Aug 2012 16:05:03 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC API] Renumber subdev ioctls
References: <201208201030.30590.hverkuil@xs4all.nl>
In-Reply-To: <201208201030.30590.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 20-08-2012 05:30, Hans Verkuil escreveu:
> Hi all!
> 
> Recently I had to add two new ioctls for the subdev API (include/linux/v4l2-subdev.h)
> and I noticed that the numbering of the ioctls was somewhat random.
> 
> In most cases the ioctl number was the same as the V4L2 API counterpart, but for
> subdev-specific ioctls no rule exists.
> 
> There are a few problems with this: because of the lack of rules there is a chance
> that in the future a subdev ioctl may end up to be identical to an existing V4L2
> ioctl. Also, because the numbering isn't nicely increasing it makes it hard to create
> a lookup table as was done for the V4L2 ioctls. Well, you could do it, but it would
> be a very sparse array, wasting a lot of memory.
> 
> Lookup tables have proven to be very useful, so we might want to introduce them for
> the subdev core code as well in the future.
> 
> Since the subdev API is still marked experimental, I propose to renumber the ioctls
> and use the letter 'v' instead of 'V'. 'v' was used for V4L1, and so it is now
> available for reuse.

'v' is already used (mainly by fs):

'v'	00-1F	linux/ext2_fs.h		conflict!
'v'	00-1F	linux/fs.h		conflict!
'v'	00-0F	linux/sonypi.h		conflict!
'v'	C0-FF	linux/meye.h		conflict!

Reusing the ioctl numbering is a bad thing, as tracing code like strace will likely
say that a different type of ioctl was called.

(Yeah, unfortunately, this end by merging with duplicated stuff :< )

Also, I don't like the idea of deprecating it just because of that: interfaces are
supposed to be stable.

It should be noticed that there are very few ioctls there. So,
using a lookup table is overkill.

IMO, the better is to sort the ioctl's there at the header file, in order to
avoid ioctl duplicaton.


> We keep the old ioctls around for a few kernel cycles, and remove them some time
> next year.
> 
> Note that some V4L2 ioctls are also available for use in the subdev API (control
> ioctls in particular). By using a different letter for the ioctls this will make
> it easy as well to decide what lookup table to use should we decide to introduce
> that in the subdev core code in the future.
> 
> Comments?
> 
> Regards,
> 
> 	Hans
> 

