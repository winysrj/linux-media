Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.acsalaska.net ([209.112.173.230]:10537 "EHLO
	hermes.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZFKW3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 18:29:05 -0400
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
From: Roger <rogerx@sdf.lonestar.org>
To: Mike Isely <isely@isely.net>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
	 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
	 <4A311A64.4080008@kernellabs.com>
	 <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 14:28:55 -0800
Message-Id: <1244759335.9812.2.camel@localhost2.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-06-11 at 13:48 -0500, Mike Isely wrote:
> On Thu, 11 Jun 2009, Steven Toth wrote:
> 
> > Mike Isely wrote:
> > > On Sun, 7 Jun 2009, Roger wrote:
> > > 
> > > > >From looking at "linux/drivers/media/dvb/frontends/s5h1411.c",  The
> > > > s5h1411_readreg wants to see "2" but is getting "-5" from the i2c bus.
> > > > 
> > > > --- Snip ---
> > > > 
> > > > s5h1411_readreg: readreg error (ret == -5)
> > > > pvrusb2: unregistering DVB devices
> > > > device: 'dvb0.net0': device_unregister
> > > > 
> > > > --- Snip ---
> > > > 
> > > > What exactly does this mean?
> > > 
> > > Roger:
> > > 
> > > It means that the module attempted an I2C transfer and the transfer failed.
> > > The I2C adapter within the pvrusb2 driver will return either the number of
> > > bytes that it transferred or a failure code.  The failure code, as is normal
> > > convention in the kernel, will be a negated errno value.  Thus the expected
> > > value of 2 would be the fact that it probably tried a 2 byte transfer, while
> > > the actual value returned of -5 indicate an EIO error, which is what the
> > > pvrusb2 driver will return when the underlying I2C transaction has failed.
> > > 
> > > Of course the real question is not that it failed but why it failed.  And
> > > for that I unfortunately do not have an answer.  It's possible that the
> > > s5h1411 driver did something that the chip didn't like and the chip
> > > responded by going deaf on the I2C bus.  More than a few I2C-driven parts
> > > can behave this way.  It's also possible that the part might have been busy
> > > and unable to respond - but usually in that case the driver for such a part
> > > will be written with this in mind and will know how / when to communicate
> > > with the hardware.
> > 
> > Roger:
> > 
> > Another possibility, although I don't know the PVRUSB2 driver too well, the
> > s5h1411 is being held in reset when the driver unloads _AFTER_ the last active
> > use was analog video (assuming the s5h1411 is floated in reset as the FX2
> > input port might be shared with the analog encoder)
> 
> Good point.  The pvrusb2 driver is not currently doing anything specific 
> - or at least deliberate - via the FX2 to move that part in/out of 
> reset.  (Of course, I am issuing FX2 commands to shift modes and that 
> might in turn be triggering other things.)  But even if I did do 
> something specific, what kind of impact is that likely to do on the 
> corresponding, blissfully ignorant, driver?
> 
> This actually drives towards a larger issue - the pvrusb2 driver works 
> with various V4L-only sub-devices, e.g. cx25840, which have no relevance 
> in digital mode but I can't really control when that corresponding 
> driver is enabled / disabled.  So if I have to take an extra step to 
> physically disable a chip when in digital mode, then this might impact 
> the sub-driver which otherwise is going to have no clue what is really 
> going on.
> 
>   -Mike
> 
> 
> -- 
> 
> Mike Isely
> isely @ isely (dot) net
> PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8


Just a freak accidental view of dmesg, and I found it absolutely loaded
with the following repeated errors (until the point I reloaded the
pvrusb2 modules this morning along with the cold boot of the HVR-1950
usb device).

All I have to say is, I've never seen this many s5h1411 related errors
ever.  I've set "options pvrusb2 debug=19".  So I think I'm onto
something?

reg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
s5h1411_writereg: writereg error 0x19 0xf5 0x0001, ret == -5)
tda18271_write_regs: ERROR: i2c_transfer returned: -5
tda18271_init: error -5 on line 805
tda18271_tune: error -5 on line 831
tda18271_set_params: error -5 on line 912
s5h1411_writereg: writereg error 0x19 0xf5 0x0000, ret == -5)
s5h1411_writereg: writereg error 0x19 0xf7 0x0000, ret == -5)
s5h1411_writereg: writereg error 0x19 0xf7 0x0001, ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)
s5h1411_readreg: readreg error (ret == -5)



-- 
Roger
http://rogerx.freeshell.org

