Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:3021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548Ab0ISUve (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 16:51:34 -0400
Message-ID: <4C9677CC.50609@redhat.com>
Date: Sun, 19 Sep 2010 17:51:24 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>
Subject: Re: RFC: BKL, locking and ioctls
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com>	 <1284921482.2079.57.camel@morgan.silverblock.net>	 <4C96600E.8090905@redhat.com>  <201009192138.08412.hverkuil@xs4all.nl> <1284926220.2079.105.camel@morgan.silverblock.net>
In-Reply-To: <1284926220.2079.105.camel@morgan.silverblock.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-09-2010 16:57, Andy Walls escreveu:
> On Sun, 2010-09-19 at 21:38 +0200, Hans Verkuil wrote:
>> On Sunday, September 19, 2010 21:10:06 Mauro Carvalho Chehab wrote:
>>> Em 19-09-2010 15:38, Andy Walls escreveu:
>>>> On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
>>>>> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:
> 
>> Requirements I can think of:
>>
>> 1) The basic capture and output streaming (either read/write or streaming I/O) must
>> perform well. There is no need to go to extreme measures here, since the typical
>> control flow is to prepare a buffer, setup the DMA and then wait for the DMA to
>> finish. So this is not terribly time sensitive and it is perfectly OK to have to
>> wait (within reason) for another ioctl from another thread to finish first.
> 
> I'll add a data point to this one.  A sleep in read() can noticeably
> affect application performance.  Last time I had cx18 use a mutex in
> read(), live playback performance was really bad.  The read() call would
> sleep for around 10 ms - not good at normal frame rates.  It was a
> highly(?) contended mutex for the buffer queue between DMA and the
> read() call - bad idea.
> 
> According to conversations on the ksummit2010 mailing list, the 10 ms
> sleep may have been due to the default 100 HZ tick and other reasons.
> Patches from the RT tree may be integrated soon that make mutexes
> (mutices?) much better performers.

If read() and poll() are not protected, almost all drivers will break, except, perhaps,
for cx18, ivtv and pvrusb2. Streaming data need to be protected on both, when
using mmap().

Yet, having a mutex there doesn't mean that the driver will sleep. The issue you felt
is likely due to some other trouble, and not for the mutex itself.

Cheers,
Mauro
