Return-path: <mchehab@gaivota>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1802 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab0LaLZb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 06:25:31 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 00/10] [RFC] Prio handling and v4l2_device release callback
Date: Fri, 31 Dec 2010 12:25:16 +0100
Cc: linux-media@vger.kernel.org
References: <cover.1293657717.git.hverkuil@xs4all.nl> <4D1DB7FD.1040601@redhat.com>
In-Reply-To: <4D1DB7FD.1040601@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012311225.16349.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 31, 2010 12:01:17 Mauro Carvalho Chehab wrote:
> Em 29-12-2010 19:43, Hans Verkuil escreveu:
> > This patch series adds two new features to the V4L2 framework.
> > 
> > The first 5 patches add support for VIDIOC_G/S_PRIORITY. All prio handling
> > will be done in the core for any driver that either uses struct v4l2_fh
> > (ivtv only at the moment) or has no open and release file operations (true
> > for many simple (radio) drivers). In all other cases the driver will have
> > to do the work.
> 
> It doesn't make sense to implement this at core, and for some this will happen
> automatically, while, for others, drivers need to do something.

However, it makes it possible to gradually convert all drivers.
 
> > Eventually all drivers should either use v4l2_fh or never set filp->private_data.
> 
> I made a series of patches, due to BKL stuff converting the core to always
> use v4l2_fh on all drivers. This seems to be the right solution for it.

Can you point me to those patches? I remember seeing them, but can't remember where.

I see two potential problems with this approach:

1) A lot of drivers do not actually need to allocate a v4l2_fh struct, so it
   wastes memory. But on the other hand, it would be nicely consistent.

2) I prefer for core changes to have the least possible impact to existing drivers,
   and just convert existing drivers one by one.

But I would have to see your patch series again to see the impact of such a
change.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
