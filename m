Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:59631 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053AbZIMXcL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2009 19:32:11 -0400
Date: Sun, 13 Sep 2009 20:31:36 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: wk <handygewinnspiel@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
Message-ID: <20090913203136.41bb7ae0@caramujo.chehab.org>
In-Reply-To: <4AAD15A3.5080001@gmx.de>
References: <200909120021.48353.hverkuil@xs4all.nl>
	<4AAD15A3.5080001@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Sep 2009 17:54:11 +0200
wk <handygewinnspiel@gmx.de> escreveu:

> Hans Verkuil schrieb:
> > Hi all,
> >
> > I've started this as a new thread to prevent polluting the discussions of the
> > media controller as a concept.
> >
> > First of all, I have no doubt that everything that you can do with an ioctl,
> > you can also do with sysfs and vice versa. That's not the problem here.
> >
> > The problem is deciding which approach is the best.
> >
> >   
> 
> Is it really a good idea to create a dependency to some virtual file 
> system which may go away in future?
>  From time to time some of those seem to go away, for example devfs.

> Is it really unavoidable to have something in sysfs, something which is 
> really not possible with ioctls?
> And do you really want to depend on sysfs developers?

First of all, both ioctl's and sysfs are part of vfs support.

Second: where did you got the wrong information that sysfs would be deprecated? 

There's no plan to deprecate sysfs, and, since there are lots of
kernel-userspace API's depending on sysfs, you can't just remove it. 

It is completely different from what we had with devfs, where just device names
were created there, on a limited way (for example, no directories were allowed
at devfs). Yet, before devfs removal, sysfs was added to implement the same
features, providing even more functionality.

Removing sysfs is as hard as removing ioctl or procfs support on kernel.
You may change their internal implementation, but not the userspace API. 

Btw, if we'll seek for the last internal changes, among those three API's, the more
recent internal changes were at fs API where ioctl support is. There, the
Kernel big logs were removed. This required a review on all driver locks and changes
on almost all v4l/dvb drivers.

Also, wanting or not, sysfs is called on every kernel driver, so this
dependency already exists.

Cheers,
Mauro
