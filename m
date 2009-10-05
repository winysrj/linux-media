Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:63943 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755161AbZJEBxj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 21:53:39 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091004222347.GA31609@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004222347.GA31609@moon>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 21:54:37 -0400
Message-Id: <1254707677.9896.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-10-05 at 01:23 +0300, Aleksandr V. Piskunov wrote:
> On Sat, Oct 03, 2009 at 11:44:20AM -0400, Andy Walls wrote:
> > Aleksandr and Jean,
> > 
> > Zdrastvoitye & Bonjour,
> > 
> > To support the AVerMedia M166's IR microcontroller in ivtv and
> > ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in
> > 
> > 	http://linuxtv.org/hg/~awalls/ivtv
> > 
> 
> Now the last step to the decent support of M116 remote.
> 
> I spent hours banging my head against the wall, controller just doesn't
> give a stable keypresses, skips a lot of them. Increasing polling interval
> from default 100 ms to 400-500 ms helps a bit, but it only masks the
> problem. Decreasing polling interval below 50ms makes it skip virtually
> 90% of keypresses.
> 
> Basicly during the I2C operation that reads scancode, controller seems
> to stop processing input from IR sensor, resulting a loss of keypress.
> 
> So the solution(?) I found was to decrease the udelay in
> ivtv_i2c_algo_template from 10 to 5. Guess it just doubles the frequency
> of ivtv i2c bus or something like that. Problem went away, IR controller
> is now working as expected.

That's a long standing error in the ivtv driver.  It ran the I2C bus at
1/(2*10 usec) = 50 kHz instead of the standard 100 kHz.

Technically any I2C device should be able to handle clock rates down to
about DC IIRC; so there must be a bug in the IR microcontroller
implementation.

Also the CX23416 errantly marks its PCI register space as cacheable
which is probably wrong (see lspci output).  This may also be
interfering with proper I2C operation with i2c_algo_bit depedning on the
PCI bridges in your system.

> 
> So question is:
> 1) Is it ok to decrease udelay for this board?

Sure, I think.  It would actually run the ivtv I2C bus at the nominal
clock rate specified by the I2C specification.

I never had any reason to change it, as I feared causing regressions in
many well tested boards.


> 2) If yes, how to do it right?

Try:

# modprobe ivtv newi2c=1

to see if that works first. 


Regards,
Andy

