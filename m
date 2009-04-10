Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51]:54362 "EHLO
	mail-in-11.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737AbZDJTtH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 15:49:07 -0400
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: hermann pitton <hermann-pitton@arcor.de>
To: Thomas Horsten <thomas@horsten.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
In-Reply-To: <5d932cdc0904081805q49f712b8sa27f1b8c89b05661@mail.gmail.com>
References: <5d932cdc0904081249j59bccc7cg864753d22479d9a8@mail.gmail.com>
	 <1239227821.9855.5.camel@pc07.localdom.local>
	 <5d932cdc0904081805q49f712b8sa27f1b8c89b05661@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 21:35:21 +0200
Message-Id: <1239392121.18683.15.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Donnerstag, den 09.04.2009, 02:05 +0100 schrieb Thomas Horsten:
> Hi Hermann,
> 
> 2009/4/8 hermann pitton <hermann-pitton@arcor.de>:
> 
> > does it make any difference too with the current mercurial v4l-dvb ?
> >
> > I did not look any further, since some tones coming currently from above
> > I don't like, more those from Linus after having 800 plus patches.
> 
> After installing the mercurial drivers and rebooting the symptoms are
> exactly the same. Another tuner card in the same machine (a Hauppauge
> Nova-T 500 Dual DVB-T) works fine.
> 
> If you have any ideas I am willing to experiment to get this to work
> again. If I have some time over Easter I might try git-dissecting the
> changes to find the patch that introduced the behaviour but since it
> is running on quite a big server the turnaround time to reboot and try
> new modules is about 30 minutes :(
> 

scrolled at least over some saa7134 related diffs just, thousands of
lines, but no exact catch yet.

It seems the i2c gate control of the tda8290 at 0x96 is broken in DVB-T
mode open/close related.

Correct behavior with current mercurial tuning the tuner at 0xc0.

saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
saa7133[0]: i2c xfer: < 10 01 91 >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
saa7133[0]: i2c xfer: < 10 03 00 >
saa7133[0]: i2c xfer: < 10 43 [fd quirk] < 11 =03 >
saa7133[0]: i2c xfer: < 10 43 03 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 00 2e 70 00 16 14 4b 1c 06 24 00 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 90 ff 60 00 59 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 a0 40 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c1 =09 =a8 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 c0 99 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 60 3c >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 30 11 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 c0 39 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 50 4f >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
saa7133[0]: i2c xfer: < 10 01 91 >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
saa7133[0]: i2c xfer: < 10 03 00 >
saa7133[0]: i2c xfer: < 10 31 54 >
saa7133[0]: i2c xfer: < 10 32 03 >


On the broken 2.6.29.1 it looks like that.


saa7133[0]: i2c xfer: < 10 22 [fd quirk] < 11 =ff >
saa7133[0]: i2c xfer: < 10 21 [fd quirk] < 11 =ff >
saa7133[0]: i2c xfer: < 10 20 [fd quirk] < 11 =ff >
saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
saa7133[0]: i2c xfer: < 10 01 91 >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
saa7133[0]: i2c xfer: < 10 03 00 >
saa7133[0]: i2c xfer: < 10 43 [fd quirk] < 11 =03 >
saa7133[0]: i2c xfer: < 10 43 03 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 00 32 c0 00 16 5a 5b 1c 06 24 00 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 90 ff 60 00 59 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 a0 40 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c1 =09 =a8 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 c0 99 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 60 3c >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 30 10 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 c0 39 >
saa7133[0]: i2c xfer: < 96 21 c0 >
saa7133[0]: i2c xfer: < c0 50 5f >
saa7133[0]: i2c xfer: < 96 21 80 >
saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
saa7133[0]: i2c xfer: < 10 01 91 >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >
saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
saa7133[0]: i2c xfer: < 10 03 00 >
saa7133[0]: i2c xfer: < 10 31 60 >
saa7133[0]: i2c xfer: < 10 32 02 >
saa7133[0]: i2c xfer: < 10 33 aa >
saa7133[0]: i2c xfer: < 10 34 aa >
saa7133[0]: i2c xfer: < 10 35 ab >
saa7133[0]: i2c xfer: < 10 4d 0c >
saa7133[0]: i2c xfer: < 10 4e 00 >
saa7133[0]: i2c xfer: < 10 16 [fd quirk] < 11 =a8 >
saa7133[0]: i2c xfer: < 10 16 a8 >
saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
saa7133[0]: i2c xfer: < 10 01 91 >
saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
saa7133[0]: i2c xfer: < 10 02 1c >

Mauro had a fix during further changes for the upcoming 2.6.30 commits
on mercurial, but it seems to be broken already previously.

The open gate, write to tuner, close gate commands are no longer in the
also previously known sequence and might cause the trouble visible on
the saa713x.

Cheers,
Hermann


