Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46554 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755049Ab0ISTF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:05:56 -0400
Subject: Re: RFC: BKL, locking and ioctls
From: Andy Walls <awalls@md.metrocast.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <4C95F76F.9090103@redhat.com>
References: <201009191229.35800.hverkuil@xs4all.nl>
	 <4C95F76F.9090103@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 15:05:46 -0400
Message-ID: <1284923146.2079.83.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-09-19 at 08:43 -0300, Mauro Carvalho Chehab wrote: 
> Hi Hans,
> 

> A per-dev lock may not be good on devices where you have lots of interfaces, and that allows
> more than one stream per interface.
> 
> So, I did a different implementation, implementing the mutex pointer per file handler.
> On devices that a simple lock is possible, all you need to do is to use the same locking
> for all file handles, but if drivers want a finer control, they can use a per-file handler
> lock.
> 
> I'm adding the patches I did at media-tree.git. I've created a separate branch there (devel/bkl):
> 	http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/devel/bkl
> 
> I've already applied there the other BKL-lock removal patches I've sent before, plus one new
> one, fixing a lock unbalance at bttv poll function (changeset 32d1c90c85).
> 
> The v4l2 core patches are at:
> 
> http://git.linuxtv.org/media_tree.git?a=commit;h=285267378581fbf852f24f3f99d2e937cd200fd5
> http://git.linuxtv.org/media_tree.git?a=commit;h=5f7b2159c87b08d4f0961c233a2d1d1b87c8b38d
> 
> The approach I took serializes open, close, ioctl, mmap, read and poll, e. g. all file operations
> done by the V4L devices.

Hi Mauro,

I took a look at your changes in the first link.  The approach seems
like it serializes too much for one fd, and not enough for multiple fd's
opened on the same device node.

for a single fd, ioctl() probably doesn't need to be serialized against
read() and poll() at all - at least for drivers that only provide the
read I/O method.

read() and poll() on the same device node in most cases can access to
shared data structure in kernel using test_bit() and atomic_read().
poll() usually just needs to check if a count is  > 0 in some incoming
buffer count or incoming byte count somewhere, right?


Multiple opens of the device node (e.g one fd for streaming, one fd for
control) is what MythTV does, so the locking on a per fd basis doesn't
work there.


Regards,
Andy


