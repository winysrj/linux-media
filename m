Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:42887 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbZJEKvn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 06:51:43 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
From: Andy Walls <awalls@radix.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091005102901.5d8447a2@hyperion.delvare>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004222347.GA31609@moon> <1254707677.9896.10.camel@palomino.walls.org>
	 <20091005102901.5d8447a2@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 05 Oct 2009 06:36:05 -0400
Message-Id: <1254738965.3980.3.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-10-05 at 10:29 +0200, Jean Delvare wrote:
> On Sun, 04 Oct 2009 21:54:37 -0400, Andy Walls wrote:
> > On Mon, 2009-10-05 at 01:23 +0300, Aleksandr V. Piskunov wrote:

> > > 
> > > So question is:
> > > 1) Is it ok to decrease udelay for this board?
> > 
> > Sure, I think.  It would actually run the ivtv I2C bus at the nominal
> > clock rate specified by the I2C specification.
> 
> FWIW, 100 kHz isn't the "nominal" I2C clock rate, but the maximum clock
> rate for normal I2C. It is perfectly valid to run I2C buses as lower
> clock frequencies. I don't even think there is a minimum for I2C (but
> there is a minimum of 10 kHz for SMBus.)

Ah, thanks.  I was too lazy to go read my copy of the spec.


> But of course different hardware implementations may not fully cover
> the standard I2C or SMBus frequency range, and it is possible that a TV
> adapter manufacturer designed its hardware to run the I2C bus at a
> fixed frequency and we have to use that frequency to make the adapter
> happy.

This is very plausible for a microcontroller implementation of an I2C
slave, which is the case here.


> > I never had any reason to change it, as I feared causing regressions in
> > many well tested boards.
> 
> This is a possibility, indeed. But for obvious performance reasons, I'd
> rather use 100 kHz as the default, and let boards override it with a
> lower frequency of their choice if needed. Obviously this provides an
> easy improvement path, where each board can be tested separately and
> I2C bus frequency bumped from 50 kHz to 100 kHz after some good testing.
> 
> Some boards might even support fast I2C, up to 400 kHz but limited to
> 250 kHz by the i2c-algo-bit implementation.

I can add a module option to ivtv for I2C clock rate.  It may take a few
days.

Regards,
Andy

