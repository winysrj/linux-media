Return-path: <mchehab@pedra>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:1658 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756964Ab0KNWtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 17:49:06 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Sun, 14 Nov 2010 23:48:51 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011142253.29768.arnd@arndb.de>
In-Reply-To: <201011142253.29768.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011142348.51859.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, November 14, 2010 22:53:29 Arnd Bergmann wrote:
> On Sunday 14 November 2010, Hans Verkuil wrote:
> > This patch series converts 24 v4l drivers to unlocked_ioctl. These are low
> > hanging fruit but you have to start somewhere :-)
> > 
> > The first patch replaces mutex_lock in the V4L2 core by mutex_lock_interruptible
> > for most fops.
> 
> The patches all look good as far as I can tell, but I suppose the title is
> obsolete now that the BKL has been replaced with a v4l-wide mutex, which
> is what you are removing in the series.

I guess I have to rename it, even though strictly speaking the branch I'm
working in doesn't have your patch merged yet.

BTW, replacing the BKL with a static mutex is rather scary: the BKL gives up
the lock whenever you sleep, the mutex doesn't. Since sleeping is very common
in V4L (calling VIDIOC_DQBUF will typically sleep while waiting for a new frame
to arrive), this will make it impossible for another process to access *any*
v4l2 device node while the ioctl is sleeping.

I am not sure whether that is what you intended. Or am I missing something?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
