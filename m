Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:40051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab0IST0L (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:26:11 -0400
Message-ID: <4C9663C8.2060808@redhat.com>
Date: Sun, 19 Sep 2010 16:26:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <201009191229.35800.hverkuil@xs4all.nl>	 <4C95F76F.9090103@redhat.com> <1284923146.2079.83.camel@morgan.silverblock.net>
In-Reply-To: <1284923146.2079.83.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 16:05, Andy Walls escreveu:
> On Sun, 2010-09-19 at 08:43 -0300, Mauro Carvalho Chehab wrote: 
>> Hi Hans,
>>
> 
>> A per-dev lock may not be good on devices where you have lots of interfaces, and that allows
>> more than one stream per interface.
>>
>> So, I did a different implementation, implementing the mutex pointer per file handler.
>> On devices that a simple lock is possible, all you need to do is to use the same locking
>> for all file handles, but if drivers want a finer control, they can use a per-file handler
>> lock.
>>
>> I'm adding the patches I did at media-tree.git. I've created a separate branch there (devel/bkl):
>> 	http://git.linuxtv.org/media_tree.git?a=shortlog;h=refs/heads/devel/bkl
>>
>> I've already applied there the other BKL-lock removal patches I've sent before, plus one new
>> one, fixing a lock unbalance at bttv poll function (changeset 32d1c90c85).
>>
>> The v4l2 core patches are at:
>>
>> http://git.linuxtv.org/media_tree.git?a=commit;h=285267378581fbf852f24f3f99d2e937cd200fd5
>> http://git.linuxtv.org/media_tree.git?a=commit;h=5f7b2159c87b08d4f0961c233a2d1d1b87c8b38d
>>
>> The approach I took serializes open, close, ioctl, mmap, read and poll, e. g. all file operations
>> done by the V4L devices.
> 
> Hi Mauro,
> 
> I took a look at your changes in the first link.  The approach seems
> like it serializes too much for one fd, and not enough for multiple fd's
> opened on the same device node.

Had you look at em28xx and vivi implementation? On both cases, we're using a per-device locking.
That's completely valid. For vivi, a per-fh would also work fine, but it won't make any difference,
as the support for multiple streams for vivi got removed. In the care of em28xx, a per-device-node
lock wouldn't work, since the data that needs to be protected is global for the entire device.

A real per-fd implementation will likely need an additional lock on the driver level, for some
ioctls. The core shouldn't prevent it.

> for a single fd, ioctl() probably doesn't need to be serialized against
> read() and poll() at all - at least for drivers that only provide the
> read I/O method.
> 
> read() and poll() on the same device node in most cases can access to
> shared data structure in kernel using test_bit() and atomic_read().
> poll() usually just needs to check if a count is  > 0 in some incoming
> buffer count or incoming byte count somewhere, right?

There are very few drivers that only implements read() method - I think only cx18 and ivtv.
In the mmap() case, you still need to protect read() x mmap(), read() x open(), and other
possible race issues. Some of them will even happen on single fd cases, especially if you
have multiple threads accessing the same fd. Of course, the mutex is more important on multiple-fd
cases, like the em28xx example.

> Multiple opens of the device node (e.g one fd for streaming, one fd for
> control) is what MythTV does, so the locking on a per fd basis doesn't
> work there.

Cheers,
Mauro
