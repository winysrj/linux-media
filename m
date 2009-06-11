Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:58198 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758031AbZFKEFb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 00:05:31 -0400
Date: Wed, 10 Jun 2009 23:05:33 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Roger <rogerx@sdf.lonestar.org>
cc: linux-media@vger.kernel.org
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
In-Reply-To: <1244446830.3797.6.camel@localhost2.local>
Message-ID: <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
References: <1244446830.3797.6.camel@localhost2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 7 Jun 2009, Roger wrote:

> >From looking at "linux/drivers/media/dvb/frontends/s5h1411.c",  The
> s5h1411_readreg wants to see "2" but is getting "-5" from the i2c bus.
> 
> --- Snip ---
> 
> s5h1411_readreg: readreg error (ret == -5)
> pvrusb2: unregistering DVB devices
> device: 'dvb0.net0': device_unregister
> 
> --- Snip ---
> 
> What exactly does this mean?

Roger:

It means that the module attempted an I2C transfer and the transfer 
failed.  The I2C adapter within the pvrusb2 driver will return either 
the number of bytes that it transferred or a failure code.  The failure 
code, as is normal convention in the kernel, will be a negated errno 
value.  Thus the expected value of 2 would be the fact that it probably 
tried a 2 byte transfer, while the actual value returned of -5 indicate 
an EIO error, which is what the pvrusb2 driver will return when the 
underlying I2C transaction has failed.

Of course the real question is not that it failed but why it failed.  
And for that I unfortunately do not have an answer.  It's possible that 
the s5h1411 driver did something that the chip didn't like and the chip 
responded by going deaf on the I2C bus.  More than a few I2C-driven 
parts can behave this way.  It's also possible that the part might have 
been busy and unable to respond - but usually in that case the driver 
for such a part will be written with this in mind and will know how / 
when to communicate with the hardware.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
