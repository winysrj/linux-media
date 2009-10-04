Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:58969 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757911AbZJDUmI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 4 Oct 2009 16:42:08 -0400
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
 M116 for newer kernels
From: Andy Walls <awalls@radix.net>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
In-Reply-To: <20091004083139.GA20457@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
	 <20091004083139.GA20457@moon>
Content-Type: text/plain
Date: Sun, 04 Oct 2009 16:44:17 -0400
Message-Id: <1254689057.3148.139.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-10-04 at 11:31 +0300, Aleksandr V. Piskunov wrote:
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
> > 01/03: ivtv: Defer legacy I2C IR probing until after setup of known I2C devices
> > http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=3d243437f046
> > 
> > 02/03: ivtv: Add explicit IR controller initialization for the AVerTV M116
> > http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=0127ed2ea55b
> > 
> > 03/03: ir-kbd-i2c: Add support for the AVerTV M116 with the new binding model
> > http://linuxtv.org/hg/~awalls/ivtv?cmd=changeset;node=c10e0d5d895c
> > 
> > 
> > I cannot really test them as I still am using an older kernel.  Could
> > you please review, and test them if possible?
> > 
> 
> Thank you, Andy! Much more elegant solution than simply pounding 0x40 on every ivtv
> board.

Thank you.  Of course as Jean has pointed out, I have some things to
clean up.

> Tested on 2.6.30.8, one of Ubuntu mainline kernel builds.

Thank you for testing.

> ivtv-i2c part works, ivtv_i2c_new_ir() gets called, according to /sys/bus/i2c
> device @ 0x40 gets a name ir_rx_em78p153s_ave.
> 
> Now according to my (very) limited understanding of new binding model, ir-kbd-i2c
> should attach to this device by its name. Somehow it doesn't, ir-kbd-i2c gets loaded
> silently without doing anything.

As you probably know, the truncated name cannot be matched.


Regards,
Andy

