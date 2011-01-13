Return-path: <mchehab@pedra>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52798 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932641Ab1AMMNR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 07:13:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LEY009T7NA1HE70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Jan 2011 12:13:13 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LEY00HW1NA1XZ@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Jan 2011 12:13:13 +0000 (GMT)
Date: Thu, 13 Jan 2011 13:13:10 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: RE: [GIT PATCHES FOR 2.6.38] Videbuf2 framework,
 NOON010PC30 sensor driver and s5p-fimc updates
In-reply-to: <000001cbb2fe$5d8f2290$18ad67b0$%p@samsung.com>
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Cc: 'Sylwester Nawrocki' <s.nawrocki@samsung.com>, pawel@osciak.com,
	linux-media@vger.kernel.org
Message-id: <000701cbb31b$3e692c40$bb3b84c0$%p@samsung.com>
Content-language: pl
References: <4D21FDC1.7000803@samsung.com> <4D2CBB3F.5050904@redhat.com>
 <000001cbb243$1051cb60$30f56220$%szyprowski@samsung.com>
 <4D2E0DD8.4010305@redhat.com> <000001cbb2fe$5d8f2290$18ad67b0$%p@samsung.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello again, Mauro,

On Thursday, January 13, 2011 9:46 AM Andrzej Pietrasiewicz  wrote:

> 
> Hello Mauro,
> 
> On Wednesday, January 12, 2011 9:24 PM Mauro Carvalho Chehab wrote:
> >
> > Em 12-01-2011 08:25, Marek Szyprowski escreveu:
> > > Hello Mauro,
> > >
> > > I've rebased our fimc and saa patches onto
> > http://linuxtv.org/git/mchehab/experimental.git
> > > vb2_test branch.
> > >
> > > The last 2 patches are for SAA7134 driver and are only to show that
> > videobuf2-dma-sg works
> > > correctly.
> >
> > On my first test with saa7134, it hanged. It seems that the code
> > reached a dead lock.
> >
> > On my test environment, I'm using a remote machine, without monitor.
> > My test is using
> > qv4l2 via a remote X server. Using a remote X server is an
> interesting
> > test, as it will likely loose some frames, increasing the probability
> > of races and dead locks.
> >
> 
> We did a similar test using a remote machine and qv4l2 with X
> forwarding.
> Both userptr and mmap worked. Read does not work because it is not
> implemented, but there was no freeze anyway, just green screen in
> qv4l2.
> However, we set "Capture Image Formats" to "YUV - 4:2:2 packed, YUV",
> "TV Standard" to "PAL". I enclose a (lengthy) log for reference - it is
> a log of a short session when modules where loaded, qv4l2 started,
> userptr mode run for a while and then mmap mode run for a while.
> 
> We did it on a 32-bit system. We are going to repeat the test on a 64-
> bit system, it just takes some time to set it up. Perhaps this is the
> difference.

We did the test on a 64-bit system, both locally and with X forwarding to a
remote machine. It works in both cases.
Our TV card is "Avermedia AverTV Super 007" pure analog. Yours is a hybrid
analog/ISDB card. Does your card work with videobuf 1? Perhaps you could do
such a test: please use code from the commit f73e66a8e91e4ebb "v4l: saa7134:
remove radio, vbi, mpeg, input, alsa, tvaudio, saa6752hs support" and see if
you TV card works with videobuf (not videobuf2)?

Andrzej


