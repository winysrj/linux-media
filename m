Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbZIMBeC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Sep 2009 21:34:02 -0400
Date: Sat, 12 Sep 2009 22:33:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andy Walls <awalls@radix.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Media controller: sysfs vs ioctl
Message-ID: <20090912223327.5aff7872@caramujo.chehab.org>
In-Reply-To: <1252781303.7571.24.camel@palomino.walls.org>
References: <200909120021.48353.hverkuil@xs4all.nl>
	<829197380909120641w66f8d092yfd307186da20edc2@mail.gmail.com>
	<20090912114535.19f9716f@caramujo.chehab.org>
	<200909121712.35718.hverkuil@xs4all.nl>
	<20090912125445.14610988@caramujo.chehab.org>
	<1252781303.7571.24.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 12 Sep 2009 14:48:23 -0400
Andy Walls <awalls@radix.net> escreveu:

> On Sat, 2009-09-12 at 12:54 -0300, Mauro Carvalho Chehab wrote:
> > Em Sat, 12 Sep 2009 17:12:35 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > > I'm currently trying to get ivtv media-controller-aware. It's probably the
> > > most complex driver when it comes to topology that I have access to, so that
> > > would be a good test case.
> > 
> > The most complex hardware for PC I'm aware is the cx25821. Unfortunately, the
> > driver is currently in bad shape, in terms of CodingStyle (including the
> > removal of large blocks of code that are repeated several times along the
> > driver), needing lots of changes in order to get merged.
> > 
> > For those interested, the code is at:
> > 	http://linuxtv.org/hg/~mchehab/cx25821/
> > 
> > I'll likely do some work on it during this merge window for its inclusion
> > upstream (probably at drivers/staging - since I doubt we'll have enough time to
> > clean it up right now).
> > 
> > It has several blocks that can be used for video in and video out. The current
> > driver has support for 8 simultaneous video inputs and 4 simultaneous video
> > output. I'm not sure, but I won't doubt that you can exchange inputs and
> > outputs or even group them. So, this is a good candidate for some media
> > controller tests. I'll try to do it via sysfs, running some tests and post the
> > results.
> 
> 
> I read the available specs for that chip when I saw the source code
> appear in a repo of yours several months ago.  The public data sheet is
> here.
> 
> http://www.conexant.com/servlets/DownloadServlet/PBR-201499-004.pdf?docid=1501&revid=4
> 
> The chip looks like it is a good fit for surveillance applications.
> 
> The block diagram indicates it is essentially a Video (10x CCIR656) and
> Audio (5x I2S) router, with a pile of GPIOS (48), 3 I2C busses, and
> support for inbound and outbound DMA channels.  The chip also has built
> in scalers and motion detection.  Managing the chip itself doesn't look
> too complicated, but once intergrated with other devices like
> compression CODECs, a CX25853 devices, or general purpose
> microcontrollers, I imagine it could get complex to manage.
> 
> The reference design brief is here:
> 
> http://www.conexant.com/servlets/DownloadServlet/RED-202183-001.pdf?docid=2184&revid=1

Yes, this board is very powerful, and very complex designs are possible with it.

> I agree with the coding style problems of the current driver.

Yes. It will take some time until cleaning it up and letting it done for being
at drivers/media.

Cheers,
Mauro
