Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:64800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab1F0QOu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 12:14:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl  doesn't exist
Date: Mon, 27 Jun 2011 18:14:35 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <201106271656.04612.hverkuil@xs4all.nl> <4E08A2E6.6020902@redhat.com>
In-Reply-To: <4E08A2E6.6020902@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106271814.36251.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Monday 27 June 2011, Mauro Carvalho Chehab wrote:
> > The point is that the spec can easily be improved to make such 'NOP' operations
> > explicit, or to require that if a capability is present, then the corresponding
> > ioctl(s) must also be present. Things like that are easy to verify as well with
> > v4l2-compliance.
> 
> We currently have more than 64 ioctl's. Adding a capability bit for each doesn't
> seem the right thing to do. Ok, some could be grouped, but, even so, there are
> drivers that implement the VIDIOC_G, but doesn't implement the corresponding VIDIO_S.
> So, I think we don't have enough available bits for doing that.

It shouldn't be too hard to do an ioctl command that returns a le_bitmask with the
ioctl command number as an index (0 to 91, currently), and the bit set for each
command that has the corresponding v4l2_ioctl_ops member filled for the device.
That would be an obvious way to query the operations, but I don't know if it's
useful.

	Arnd
