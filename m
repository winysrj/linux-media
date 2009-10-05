Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:64404 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621AbZJEI3v (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 04:29:51 -0400
Date: Mon, 5 Oct 2009 10:29:01 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
Message-ID: <20091005102901.5d8447a2@hyperion.delvare>
In-Reply-To: <1254707677.9896.10.camel@palomino.walls.org>
References: <1254584660.3169.25.camel@palomino.walls.org>
	<20091004222347.GA31609@moon>
	<1254707677.9896.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 04 Oct 2009 21:54:37 -0400, Andy Walls wrote:
> On Mon, 2009-10-05 at 01:23 +0300, Aleksandr V. Piskunov wrote:
> > So the solution(?) I found was to decrease the udelay in
> > ivtv_i2c_algo_template from 10 to 5. Guess it just doubles the frequency
> > of ivtv i2c bus or something like that. Problem went away, IR controller
> > is now working as expected.
> 
> That's a long standing error in the ivtv driver.  It ran the I2C bus at
> 1/(2*10 usec) = 50 kHz instead of the standard 100 kHz.
> 
> Technically any I2C device should be able to handle clock rates down to
> about DC IIRC; so there must be a bug in the IR microcontroller
> implementation.
> 
> Also the CX23416 errantly marks its PCI register space as cacheable
> which is probably wrong (see lspci output).  This may also be
> interfering with proper I2C operation with i2c_algo_bit depedning on the
> PCI bridges in your system.
> 
> > 
> > So question is:
> > 1) Is it ok to decrease udelay for this board?
> 
> Sure, I think.  It would actually run the ivtv I2C bus at the nominal
> clock rate specified by the I2C specification.

FWIW, 100 kHz isn't the "nominal" I2C clock rate, but the maximum clock
rate for normal I2C. It is perfectly valid to run I2C buses as lower
clock frequencies. I don't even think there is a minimum for I2C (but
there is a minimum of 10 kHz for SMBus.)

But of course different hardware implementations may not fully cover
the standard I2C or SMBus frequency range, and it is possible that a TV
adapter manufacturer designed its hardware to run the I2C bus at a
fixed frequency and we have to use that frequency to make the adapter
happy.

> I never had any reason to change it, as I feared causing regressions in
> many well tested boards.

This is a possibility, indeed. But for obvious performance reasons, I'd
rather use 100 kHz as the default, and let boards override it with a
lower frequency of their choice if needed. Obviously this provides an
easy improvement path, where each board can be tested separately and
I2C bus frequency bumped from 50 kHz to 100 kHz after some good testing.

Some boards might even support fast I2C, up to 400 kHz but limited to
250 kHz by the i2c-algo-bit implementation.

-- 
Jean Delvare
