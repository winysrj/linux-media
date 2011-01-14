Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab1ANWIV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Jan 2011 17:08:21 -0500
Date: Fri, 14 Jan 2011 17:08:00 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Jean Delvare <khali@linux-fr.org>, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH] hdpvr: enable IR part
Message-ID: <20110114220759.GG9849@redhat.com>
References: <20110114195448.GA9849@redhat.com>
 <1295041480.2459.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295041480.2459.9.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Jan 14, 2011 at 04:44:40PM -0500, Andy Walls wrote:
> On Fri, 2011-01-14 at 14:54 -0500, Jarod Wilson wrote:
> > A number of things going on here, but the end result is that the IR part
> > on the hdpvr gets enabled, and can be used with ir-kbd-i2c and/or
> > lirc_zilog.
> > 
> > First up, there are some conditional build fixes that come into play
> > whether i2c is built-in or modular. Second, we're swapping out
> > i2c_new_probed_device() for i2c_new_device(), as in my testing, probing
> > always fails, but we *know* that all hdpvr devices have a z8 chip at
> > 0x70 and 0x71. Third, we're poking at an i2c address directly without a
> > client, and writing some magic bits to actually turn on this IR part
> > (this could use some improvement in the future). Fourth, some of the
> > i2c_adapter storage has been reworked, as the existing implementation
> > used to lead to an oops following i2c changes c. 2.6.31.
> > 
> > Earlier editions of this patch have been floating around the 'net for a
> > while, including being patched into Fedora kernels, and they *do* work.
> > This specific version isn't yet tested, beyond loading ir-kbd-i2c and
> > confirming that it does bind to the RX address of the hdpvr:
> > 
> > Registered IR keymap rc-hauppauge-new
> > input: i2c IR (HD PVR) as /devices/virtual/rc/rc1/input6
> > rc1: i2c IR (HD PVR) as /devices/virtual/rc/rc1
> > ir-kbd-i2c: i2c IR (HD PVR) detected at i2c-1/1-0071/ir0 [Hauppage HD PVR I2C]
> > 
> > (Yes, I'm posting before fully testing, and I do have a reason for that,
> > and will post a v2 after testing this weekend, if need be)...
> 
> As discussed on IRC
> 1. no need to probe for the Z8 as HD PVR always has one.  

Did a bit further prodding w/i2cdetect under Jean's guidance[1]. The hdpvr
hardware doesn't like the quick writes used by the i2c_new_probed_device()
routine, but does work with short reads for detection. That would require
writing a custom probe routine though, and just isn't worth the effort on
the hdpvr, since we know it always has an IR part, so i2c_new_device()
really is the way to go here.

[1] 'i2cdetect -l' shows my hdpvr at i2c-1, 'i2cdetect 1', which probes
similar to i2_new_probed_device() doesn't return a device where expected,
but 'i2cdetect -r 1', which uses a short read, does.

> 2. accessing the chip at address 0x54 directly should eventually be
> reworked with nicer i2c subsystem methods, but that can wait

Agreed, this should be cleaned up at some point.

> Note, that code in lirc_zilog.c indicates that ir-kbd-i2c.c's function
> get_key_haup_xvr() *may* need some additions to account for the Rx data
> format.  I'm not sure of this though.  (Or a custom get_key() in the
> hdpvr module could be provided as a function pointer to ir-kbd-i2c.c via
> platform_data.)
> 
> I will provide a debug patch in another email so that it's easier to see
> the data ir-kbd-i2c.c sees coming from the Z8.

I'll tack that onto the machine I've got hooked to the hdpvr and see what
I can see this weekend, thanks much for the pointers.

-- 
Jarod Wilson
jarod@redhat.com

