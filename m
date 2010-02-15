Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:61416 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab0BOMrM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 07:47:12 -0500
Subject: Re: [PATCH 2/5 v2] sony-tuner: Subdev conversion from
 wis-sony-tuner
From: Andy Walls <awalls@radix.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Pete Eberlein <pete@sensoray.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
In-Reply-To: <201002150810.47694.hverkuil@xs4all.nl>
References: <1265934787.4626.251.camel@pete-desktop>
	 <201002141618.13113.hverkuil@xs4all.nl>
	 <1266185448.4974.37.camel@palomino.walls.org>
	 <201002150810.47694.hverkuil@xs4all.nl>
Content-Type: text/plain
Date: Mon, 15 Feb 2010 07:47:01 -0500
Message-Id: <1266238021.3075.7.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2010-02-15 at 08:10 +0100, Hans Verkuil wrote:
> On Sunday 14 February 2010 23:10:48 Andy Walls wrote:
> > On Sun, 2010-02-14 at 16:18 +0100, Hans Verkuil wrote:
> > > On Saturday 13 February 2010 00:17:44 Hans Verkuil wrote:
> > > > On Friday 12 February 2010 23:36:20 Pete Eberlein wrote:
> > > > > On Fri, 2010-02-12 at 22:03 +0100, Hans Verkuil wrote:

> > > After thinking about this a bit more I decided that this tuner should be split
> > > up into two drivers: one for the mpx device and one for the actual tuner. This
> > > should be fairly easy to do.
> > > 
> > > One other thing that this accomplishes is that it is easier to see whether the
> > > tuner code can actually be merged into tuner-types.c. From what I can see now
> > > I would say that that is possible for the NTSC_M and NTSC_M_JP models. The
> > > PAL/SECAM model is harder since it needs to setup the tuner whenever the
> > > standard changes. But it seems that that is also possible by adding code
> > > to simple_std_setup() in tuner-simple.c.
> > > 
> > > I'm pretty sure that these tuners can just be folded into tuner-types.c
> > > and tuner-simple.c. We probably only need an mpx driver.
> > > 
> > > Andy, can you also take a look?
> > 
> > Sure.  It looks like to me you actually have three chips:
> > 
> > - oscillator/mixer (at address 0x60 like a TUA6030)
> > - programmable IF PLL demodulator (at address 0x43 like a TDA9887)
> > - MPX demodulator/dematrix IC.
> 
> I've been focusing so much on the IF_I2C_ADDR and MPX_I2C_ADDR defines that
> I completely missed the fact that there is also the tuner at 0x60 :-(
> 
> You are completely correct: it looks very much like a standard simple
> tuner + tda9887.

I should mention that I noticed

1. The IF demodulator seems to programmed with an usual take over point:
+8 dB, IIRC.  A port into the common tuner stuff should lose track of
setting like these.


2. This driver has some funny IF offset "IFPCoff" that is applied when
calling set freq.  tuner-simple and friends may need slight
modifications to handle this requirment for these tuner, but it
shouldn't be hard.

The trend in tuner-simple has been to add a switch() statement when
these sorts of exceptions are needed, as it is most expedient.  IMHO,
this is a bad trend.  I think it would be better to modify the tuner
information structures to handle this "IFPCoff" value.
Just an opinion...

Regards,
Andy

