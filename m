Return-path: <linux-media-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:51568 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZI3K5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Sep 2009 06:57:38 -0400
Date: Wed, 30 Sep 2009 12:57:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: =?UTF-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Cc: linux-kernel@vger.kernel.org, LMML <linux-media@vger.kernel.org>
Subject: Re: [2.6.31] ir-kbd-i2c oops.
Message-ID: <20090930125737.704413c8@hyperion.delvare>
In-Reply-To: <200909301016.15327.pluto@agmk.net>
References: <200909160300.28382.pluto@agmk.net>
	<200909161003.33090.pluto@agmk.net>
	<20090929161629.2a5c8d30@hyperion.delvare>
	<200909301016.15327.pluto@agmk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pawel,

I am removing the linux-i2c list from Cc, because it seems clear that
your problem is related to specific media drivers and not the i2c
subsystem.

On Wed, 30 Sep 2009 10:16:15 +0200, Paweł Sikora wrote:
> On Tuesday 29 September 2009 16:16:29 Jean Delvare wrote:
> > On Wed, 16 Sep 2009 10:03:32 +0200, Paweł Sikora wrote:
> > > On Wednesday 16 September 2009 08:57:01 Jean Delvare wrote:
> > > > Hi Pawel,
> > > >
> > > > I think this would be fixed by the following patch:
> > > > http://patchwork.kernel.org/patch/45707/
> > >
> > > still oopses. this time i've attached full dmesg.
> > 
> > Any news on this? Do you have a refined list of kernels which have the
> > bug and kernels which do not?
> 
> afaics in the 2.6.2{7,8}, the remote sends some noises to pc.
> effect: random characters on terminal and unusable login prompt.
> 
> now in the 2.6.31, the kernel module oopses during udev loading.
> so i've renamed the .ko to prevent loading.

This is contradictory with your initial statement: "afaics the
2.6.28.10 is also affected." It would be good to have real data points,
otherwise investigation will be very difficult...

It would be great if you could test kernel 2.6.30 and report whether it
oopses or not. The big ir-kbd-i2c changes went into kernel 2.6.31, so
my bet is that 2.6.30 should not oops, but I'd rather be certain of
this, otherwise we might keep searching in the wrong direction.

> > Tried 2.6.32-rc1? Tried the v4l-dvb repository?
> 
> no.
> 
> > I am also skeptical about the +0x64/0x1a52, ir_input_init() is a rather
> > small function and I fail to see how it could be 6738 bytes in binary size.
> 
> i've attached asm dump of ir-common.ko
> i found the '41 c7 80 cc ...' code in dump at adress 0x83e.

Not sure why you look at address 0x83e? The stack trace says +0x64. As
function ir_input_init() starts at 0x800, the oops address would be
0x864, which is:

864:	f0 0f ab 31          	lock bts %esi,(%rcx)

If my disassembler skills are still worth anything, this corresponds to
the set_bit instruction in:

	for (i = 0; i < IR_KEYTAB_SIZE; i++)
		set_bit(ir->ir_codes[i], dev->keybit);

in the source code. This suggests that ir->ir_codes is smaller than
expected (sounds unlikely as this array is included in struct
ir_input_state) or dev->keybit isn't large enough (sounds unlikely as
well, it should be large enough to contain 0x300 bits while ir keycodes
are all below 0x100.) So most probably something went wrong before and
we're only noticing now.

Are you running distribution kernels or self-compiled ones? Any local
patches applied?

Would you be able to apply debug patches and rebuild your kernel?
At this point, all I can offer is instrumenting ir_probe() and
ir_input_init() with log messages to see exactly what code paths are
taken and what parameters are passed around.

-- 
Jean Delvare
