Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56503 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbZFSEdT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 00:33:19 -0400
Subject: cx18: Testing needed on preliminary MPC-718 support - Acer aspire
 idea 500/510
From: Andy Walls <awalls@radix.net>
To: Steve Firth <firth650@btinternet.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	ivtv-users@ivtvdriver.org, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
In-Reply-To: <1245033007.3578.80.camel@palomino.walls.org>
References: <etPan.4a3120b8.2047990e.3852@localhost>
	 <1244831165.3264.34.camel@palomino.walls.org>
	 <1245033007.3578.80.camel@palomino.walls.org>
Content-Type: text/plain
Date: Fri, 19 Jun 2009 00:30:06 -0400
Message-Id: <1245385806.20630.25.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-06-14 at 22:33 -0400, Andy Walls wrote:
> On Fri, 2009-06-12 at 14:26 -0400, Andy Walls wrote:
> > On Thu, 2009-06-11 at 16:20 +0100, Steve Firth wrote:
> 
> > >            I've de-lidded the MPC718 card and the chip set is as
> > > below.  
> > 

> > > Devices 
> > > ------- 
> > > Connexant CX23418 MPEG 2 Encoder 
> 
> > > Zarlink MT352/CG COFDM Demodulator 
> > 
> > Ugh.  There is a linux driver for this chip, but it wants an
> > initialization sequence of registers that are not publicly documented.


> I think the MPC718 variants might use at least 3 different DVB-T
> demodulators: Mitel/Zarlink MT352, Zarlink ZL10353, or some DiBcom chip
> supported by one of the dib7000x drivers.  It looks like you might have
> an older card.

Steve,

I have a preliminary set of patches for the MPC-718 boards with an
MT-352 demodulator here:

http://linuxtv.org/hg/~awalls/cx18-mpc718/

Please give it a test.

Some warnings:

1. Do not test DVB-T and analog from the antenna at the same time.  Both
sides of the card try to use the XC3028 silicon tuner for tuning, and
the cx18 driver currently has no interlock to stop bad things from
happening if you try both at once.

2. Test with 8 MHz DVB-T channels in UHF.  Those should be least likely
to introduce any unknowns by the xc2028 and mt352 drivers.

3. I mucked with the analog set up of the card too.  Let me know if
anything is better or newly broken.

4. Test with v4l2-ctl, ivtv-tune, and mplayer.  Don't test with MythTV -
too many variables.

5. These patches will fail to load DVB-T, if you have an MPC718 with a
ZL10353 or DiBcom demodulator.

6. These patches are for testing only.  The last patch in the set has
dubious origin (an MT352 init sequence pulled out of the Windows driver,
but slightly modified by me from what I could figure out).  I will
likely have to split this sequence out into an annoying
cx18-mpc718-mt352.fw file in the final version of this patch, for
inclusion into the kernel. 


Regards,
Andy


> > > XCeive 3028 Hybrid Tuner + analog demodulator 
> > 

> > > Hynix HY5DU283333B DDR RAM 
> > > 
> > > Cirrus(?) 5340 CZZ Audio A->D 

> Regards,
> Andy

