Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:42014 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026AbZELA5v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 20:57:51 -0400
Received: by bwz22 with SMTP id 22so2990309bwz.37
        for <linux-media@vger.kernel.org>; Mon, 11 May 2009 17:57:51 -0700 (PDT)
Date: Mon, 11 May 2009 20:58:03 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Andy Walls <awalls@radix.net>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] FM1216ME_MK3 some changes
Message-ID: <20090511205803.712c3fcb@glory.loctelecom.ru>
In-Reply-To: <1242012951.3753.21.camel@pc07.localdom.local>
References: <20090422174848.1be88f61@glory.loctelecom.ru>
	<1240452534.3232.70.camel@palomino.walls.org>
	<20090423203618.4ac2bc6f@glory.loctelecom.ru>
	<1240537394.3231.37.camel@palomino.walls.org>
	<20090427192905.3ad2b88c@glory.loctelecom.ru>
	<20090428151832.241fa9b4@pedra.chehab.org>
	<20090428195922.1a079e46@glory.loctelecom.ru>
	<1240974643.4280.24.camel@pc07.localdom.local>
	<20090429201225.6ba681cf@glory.loctelecom.ru>
	<1241050556.3710.109.camel@pc07.localdom.local>
	<20090506044231.31f2d8aa@glory.loctelecom.ru>
	<1241654513.5862.37.camel@pc07.localdom.local>
	<1241665384.3147.53.camel@palomino.walls.org>
	<1241741304.4864.29.camel@pc07.localdom.local>
	<1241834493.3482.140.camel@palomino.walls.org>
	<1241836025.3717.9.camel@pc07.localdom.local>
	<1241916185.3694.8.camel@pc07.localdom.local>
	<20090510085258.03068a1e@glory.loctelecom.ru>
	<1242012951.3753.21.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/tQGAMxQ+pcdEJ66jymsQilz"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/tQGAMxQ+pcdEJ66jymsQilz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, 11 May 2009 05:35:51 +0200
hermann pitton <hermann-pitton@arcor.de> wrote:

> Dmitri,
> 
> Am Sonntag, den 10.05.2009, 08:52 +1000 schrieb Dmitri Belimov:
> > Hi All.
> > 
> > > [snip]
> > > > > 
> > > > > Channel designations I dug out of ivtv-tune:
> > > > > 
> > > > > S38 439.250 MHz (European cable)
> > > > > H18 439.250 MHz (SECAM France)
> > > > > 47  440.250 MHz (PAL China)
> > > > > 059 440.250 MHz (PAL Argentina)
> > > > > 
> > > > > come close, but are unaffected by the change from 442 to 441
> > > > > as the bandswitch cutover point.  These channels fall right
> > > > > on top of the cutover, but are not affected by the proposed
> > > > > change in any meaningful way.  The VHF-High filter and VCO
> > > > > would still be used.  Dmitri's proposed change is a "don't
> > > > > care" unless the cutover point is changed to 440 MHz. 
> > > > > 
> > > > > 
> > > > > Let's pretend that the proposed cutover point is 440 MHz.
> > > 
> > > NO! it is not
> > > 
> > > Dmitri,
> > > 
> > > can you cut one off and tell us what it is all about ?
> > > 
> > > Unless you do so, all other is pointless and I likely stop to
> > > participate in such stuff.
> > 
> > Sorry my delay. I lost subject of discussion. What main question??
> > 
> > 1. AGC TOP of RF part - I think need support for MK3
> > 2. Changing to 441MHz is not critical. We can write some
> > information about this case to Wiki or docs.
> 
> for 2.: Discussed to the end if you stay at 441MHz. If you still want
> to have it in, just send  a patch and no more info is needed. (Likely
> Andy is giving only examples for more difficult cases, sorry.)

This is my patch.

diff -r b40d628f830d linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 28 03:35:42 2009 +1000
@@ -558,8 +558,8 @@
 
 static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
 	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
-	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
-	{ 16 * 999.99        , 0x8e, 0x04, },
+	{ 16 * 441.00 /*MHz*/, 0x8e, 0x02, },
+	{ 16 * 864.00        , 0x8e, 0x04, },
 };
 
 static struct tuner_params tuner_fm1216me_mk3_params[] = {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

 
> for 1.: I would like to be absolutely sure, that we are talking about
> the same tuner. I want to have the exact filters on it at least.
>
> 3.: That is what Andy noted. Following the Philips datasheet for TOP,
> it should be added for negative modulation, positive modulation and FM
> accordingly. (2 and 3 are out of discussion)
> 
> If you still have some sort of Secam fire and can improve it, we must
> know the tuner you are on "exactly". If it is the original Philips,
> without any such TOP suggestions over the full range in recent
> datasheets (???), I assume you might have them, I would say you can
> proceed, if you have shown that you are really still on the same
> tuner.

Ok. I read the datasheet, make photos inside tuner.

With my best regards, Dmitry.

> Cheers,
> Hermann
> 
> 
> 
> 
> 
> 

--MP_/tQGAMxQ+pcdEJ66jymsQilz
Content-Type: text/x-patch; name=behold_mk3_range.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=behold_mk3_range.patch

diff -r b40d628f830d linux/drivers/media/common/tuners/tuner-types.c
--- a/linux/drivers/media/common/tuners/tuner-types.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/common/tuners/tuner-types.c	Tue Apr 28 03:35:42 2009 +1000
@@ -558,8 +558,8 @@
 
 static struct tuner_range tuner_fm1216me_mk3_pal_ranges[] = {
 	{ 16 * 158.00 /*MHz*/, 0x8e, 0x01, },
-	{ 16 * 442.00 /*MHz*/, 0x8e, 0x02, },
-	{ 16 * 999.99        , 0x8e, 0x04, },
+	{ 16 * 441.00 /*MHz*/, 0x8e, 0x02, },
+	{ 16 * 864.00        , 0x8e, 0x04, },
 };
 
 static struct tuner_params tuner_fm1216me_mk3_params[] = {

Signed-off-by: Beholder Intl. Ltd. Dmitry Belimov <d.belimov@gmail.com>

--MP_/tQGAMxQ+pcdEJ66jymsQilz--
