Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:58724 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab0KOJSD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Nov 2010 04:18:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH 0/8] V4L BKL removal: first round
Date: Mon, 15 Nov 2010 10:17:41 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <cover.1289740431.git.hverkuil@xs4all.nl> <201011142253.29768.arnd@arndb.de> <201011142348.51859.hverkuil@xs4all.nl>
In-Reply-To: <201011142348.51859.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201011151017.41453.arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday 14 November 2010 23:48:51 Hans Verkuil wrote:
> On Sunday, November 14, 2010 22:53:29 Arnd Bergmann wrote:
> > On Sunday 14 November 2010, Hans Verkuil wrote:
> > > This patch series converts 24 v4l drivers to unlocked_ioctl. These are low
> > > hanging fruit but you have to start somewhere :-)
> > > 
> > > The first patch replaces mutex_lock in the V4L2 core by mutex_lock_interruptible
> > > for most fops.
> > 
> > The patches all look good as far as I can tell, but I suppose the title is
> > obsolete now that the BKL has been replaced with a v4l-wide mutex, which
> > is what you are removing in the series.
> 
> I guess I have to rename it, even though strictly speaking the branch I'm
> working in doesn't have your patch merged yet.
> 
> BTW, replacing the BKL with a static mutex is rather scary: the BKL gives up
> the lock whenever you sleep, the mutex doesn't. Since sleeping is very common
> in V4L (calling VIDIOC_DQBUF will typically sleep while waiting for a new frame
> to arrive), this will make it impossible for another process to access any
> v4l2 device node while the ioctl is sleeping.
> 
> I am not sure whether that is what you intended. Or am I missing something?

I was aware that something like this could happen, but I apparently
misjudged how big the impact is. The general pattern for ioctls is that
those that get called frequently do not sleep, so it can almost always be
called with a mutex held.

	Arnd
