Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:40622 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756731AbZDKRmQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Apr 2009 13:42:16 -0400
Subject: Re: Kernel 2.6.29 breaks DVB-T ASUSTeK Tiger LNA Hybrid Capture
	Device
From: hermann pitton <hermann-pitton@arcor.de>
To: Thomas Horsten <thomas@horsten.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
In-Reply-To: <1239392121.18683.15.camel@pc07.localdom.local>
References: <5d932cdc0904081249j59bccc7cg864753d22479d9a8@mail.gmail.com>
	 <1239227821.9855.5.camel@pc07.localdom.local>
	 <5d932cdc0904081805q49f712b8sa27f1b8c89b05661@mail.gmail.com>
	 <1239392121.18683.15.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 19:41:44 +0200
Message-Id: <1239471704.6643.26.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi,

for the record.

> scrolled at least over some saa7134 related diffs just, thousands of
> lines, but no exact catch yet.
> 
> It seems the i2c gate control of the tda8290 at 0x96 is broken in DVB-T
> mode open/close related.
> 
> Correct behavior with current mercurial tuning the tuner at 0xc0.
> 
> saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
> saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
> saa7133[0]: i2c xfer: < 10 06 [fd quirk] < 11 =af >
> saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
> saa7133[0]: i2c xfer: < 10 01 91 >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
> saa7133[0]: i2c xfer: < 10 03 00 >
> saa7133[0]: i2c xfer: < 10 43 [fd quirk] < 11 =03 >
> saa7133[0]: i2c xfer: < 10 43 03 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 00 2e 70 00 16 14 4b 1c 06 24 00 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 90 ff 60 00 59 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 a0 40 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c1 =09 =a8 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 c0 99 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 60 3c >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 30 11 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 c0 39 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 50 4f >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
> saa7133[0]: i2c xfer: < 10 01 91 >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
> saa7133[0]: i2c xfer: < 10 03 00 >
> saa7133[0]: i2c xfer: < 10 31 54 >
> saa7133[0]: i2c xfer: < 10 32 03 >
> 
> 
> On the broken 2.6.29.1 it looks like that.
> 
> 
> saa7133[0]: i2c xfer: < 10 22 [fd quirk] < 11 =ff >
> saa7133[0]: i2c xfer: < 10 21 [fd quirk] < 11 =ff >
> saa7133[0]: i2c xfer: < 10 20 [fd quirk] < 11 =ff >
> saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
> saa7133[0]: i2c xfer: < 10 01 91 >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
> saa7133[0]: i2c xfer: < 10 03 00 >
> saa7133[0]: i2c xfer: < 10 43 [fd quirk] < 11 =03 >
> saa7133[0]: i2c xfer: < 10 43 03 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 00 32 c0 00 16 5a 5b 1c 06 24 00 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 90 ff 60 00 59 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 a0 40 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c1 =09 =a8 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 c0 99 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 60 3c >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 30 10 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 c0 39 >
> saa7133[0]: i2c xfer: < 96 21 c0 >
> saa7133[0]: i2c xfer: < c0 50 5f >
> saa7133[0]: i2c xfer: < 96 21 80 >
> saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
> saa7133[0]: i2c xfer: < 10 01 91 >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> saa7133[0]: i2c xfer: < 10 03 [fd quirk] < 11 =00 >
> saa7133[0]: i2c xfer: < 10 03 00 >
> saa7133[0]: i2c xfer: < 10 31 60 >
> saa7133[0]: i2c xfer: < 10 32 02 >
> saa7133[0]: i2c xfer: < 10 33 aa >
> saa7133[0]: i2c xfer: < 10 34 aa >
> saa7133[0]: i2c xfer: < 10 35 ab >
> saa7133[0]: i2c xfer: < 10 4d 0c >
> saa7133[0]: i2c xfer: < 10 4e 00 >
> saa7133[0]: i2c xfer: < 10 16 [fd quirk] < 11 =a8 >
> saa7133[0]: i2c xfer: < 10 16 a8 >
> saa7133[0]: i2c xfer: < 10 01 [fd quirk] < 11 =91 >
> saa7133[0]: i2c xfer: < 10 01 91 >
> saa7133[0]: i2c xfer: < 10 02 [fd quirk] < 11 =1c >
> saa7133[0]: i2c xfer: < 10 02 1c >
> 
> Mauro had a fix during further changes for the upcoming 2.6.30 commits
> on mercurial, but it seems to be broken already previously.
> 
> The open gate, write to tuner, close gate commands are no longer in the
> also previously known sequence and might cause the trouble visible on
> the saa713x.

To apply Mauros tda827x i2c gate control patch to 2.6.29.1 does bring
back the old open/close behavior, but does not fix the broken DVB-T.

This one.
http://linuxtv.org/hg/v4l-dvb/rev/8424b48ea1c6

It was just the most obvious difference, but that the tda8275ac1 is not
much impressed by the open gate is known and there was no disorder in
open and close commands.

Cheers,
Hermann






