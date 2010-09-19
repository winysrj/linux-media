Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:59537 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753512Ab0IST5N (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Sep 2010 15:57:13 -0400
Subject: Re: RFC: BKL, locking and ioctls
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <201009192138.08412.hverkuil@xs4all.nl>
References: <fm127xqs7xbmiabppyr1ifai.1284910330767@email.android.com>
	 <1284921482.2079.57.camel@morgan.silverblock.net>
	 <4C96600E.8090905@redhat.com>  <201009192138.08412.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Sep 2010 15:57:00 -0400
Message-ID: <1284926220.2079.105.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2010-09-19 at 21:38 +0200, Hans Verkuil wrote:
> On Sunday, September 19, 2010 21:10:06 Mauro Carvalho Chehab wrote:
> > Em 19-09-2010 15:38, Andy Walls escreveu:
> > > On Sun, 2010-09-19 at 18:10 +0200, Hans Verkuil wrote:
> > >> On Sunday, September 19, 2010 17:38:18 Andy Walls wrote:

> Requirements I can think of:
> 
> 1) The basic capture and output streaming (either read/write or streaming I/O) must
> perform well. There is no need to go to extreme measures here, since the typical
> control flow is to prepare a buffer, setup the DMA and then wait for the DMA to
> finish. So this is not terribly time sensitive and it is perfectly OK to have to
> wait (within reason) for another ioctl from another thread to finish first.

I'll add a data point to this one.  A sleep in read() can noticeably
affect application performance.  Last time I had cx18 use a mutex in
read(), live playback performance was really bad.  The read() call would
sleep for around 10 ms - not good at normal frame rates.  It was a
highly(?) contended mutex for the buffer queue between DMA and the
read() call - bad idea.

According to conversations on the ksummit2010 mailing list, the 10 ms
sleep may have been due to the default 100 HZ tick and other reasons.
Patches from the RT tree may be integrated soon that make mutexes
(mutices?) much better performers.

Regards,
Andy

> 2) While capturing/displaying other threads must be able to control the device at the
> same time and gather status information. This also means that such a thread should
> not be blocked from controlling the device because a dqbuf ioctl happens to be waiting
> for the DMA to finish in the main thread.
> 
> 3) We must also make sure that the mem-to-mem drivers keep working. That might be a
> special case that will become more important in the future. These are the only device
> nodes that can do capture and output streaming at the same time.
> 
> Regards,
> 
> 	Hans



