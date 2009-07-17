Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:50344 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942AbZGQWuf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 18:50:35 -0400
Subject: Re: AVerMedia AVerTV GO 007 FM, no radio sound (with routing
	enabled)
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Pham Thanh Nam <phamthanhnam.ptn@gmail.com>,
	Laszlo Kustan <lkustan@gmail.com>, linux-media@vger.kernel.org
In-Reply-To: <20090717051956.1b6253c4@pedra.chehab.org>
References: <88b49f150907161417r7d487078h3e27b514cf8dd5cf@mail.gmail.com>
	 <1247794346.3921.22.camel@AcerAspire4710>
	 <1247797282.3187.47.camel@pc07.localdom.local>
	 <1247803058.26678.2.camel@AcerAspire4710>
	 <20090717051956.1b6253c4@pedra.chehab.org>
Content-Type: text/plain
Date: Sat, 18 Jul 2009 00:49:50 +0200
Message-Id: <1247870990.4268.31.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 17.07.2009, 05:19 -0300 schrieb Mauro Carvalho Chehab:
> Em Fri, 17 Jul 2009 10:57:38 +0700
> Pham Thanh Nam <phamthanhnam.ptn@gmail.com> escreveu:
> 
> > Hi
> > So, should we add an option for this card? For example:
> > modprobe saa7134 card=57 radioontv
> 
> IMO, we should just apply a patch doing the right thing.
> 
> I couldn't find any explanation for the change. Let's just fix it with a good
> explanation and hope that this will work with all AverTV GO 007 FM boards. If
> not, someone will complain.
> 
> 
> 
> Cheers,
> Mauro

have looked up some details and agree with Mauro here.

First, Avermedia cards on the saa7134 driver are all identified safely
by PCI subsystem. No problems and we deal with GO 007 FM tda8275c1 and
not the later tda8275ac1.

Assaf reported the radio working, _but later_ he reported also that the
frequencies are off. I saw the same later too and lots of ghosting radio
stations with Asus P7131 Dual until Hartmut added radio IF support for
saa7133/35/31e and all tda8290 tuners with the 5.5MHz filter.

LINE1 was never changed for radio on the GO 007. Assaf's patch came in
with a bunch of patches Nickolay collected that time.
http://linuxtv.org/hg/v4l-dvb/rev/291d5d1089eb

Then Hartmut added correct basic radio IF support and I guess this did
"break" the previous "ghost" radio.
http://linuxtv.org/hg/v4l-dvb/rev/b9edd4165113

Else there was only this change unrelated to radio.

----
hg export 5481
# HG changeset patch
# User Mauro Carvalho Chehab <mchehab@infradead.org>
# Date 1175168859 10800
# Node ID 9f42fb6940eeaa63305b1048811ea25d74c9e806
# Parent  bcf83c0130363da08eabac5092013ed6fec1d9eb
4linux: Fix audio input for AverTv Go 007

From: Damian Minkov <damencho@damencho.com>

Fix audio input source for capturing(playing) audio on AverTv Go 007 cards.

Signed-off-by: Damian Minkov <damencho@damencho.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r bcf83c013036 -r 9f42fb6940ee linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Mar 29 08:47:04 2007 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Thu Mar 29 08:47:39 2007 -0300
@@ -1544,12 +1544,12 @@
                },{
                        .name = name_comp1,
                        .vmux = 0,
-                       .amux = LINE2,
+                       .amux = LINE1,
                        .gpio = 0x02,
                },{
                        .name = name_svideo,
                        .vmux = 6,
-                       .amux = LINE2,
+                       .amux = LINE1,
                        .gpio = 0x02,
                }},
                .radio = {
------------------

And furthermore it has .gpiomask = 0x00300003
and gpio21 is set high for radio and low for TV.

		.radio = {
			.name = name_radio,
			.amux = LINE1,
			.gpio = 0x00300001,
		},

That is why changing the radio amux to TV just works.

Cheers,
Hermann




