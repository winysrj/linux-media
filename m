Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:64805 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbZDEUVN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 16:21:13 -0400
Subject: Re: [PATCH 3/6] ir-kbd-i2c: Switch to the new-style device binding
	model
From: Andy Walls <awalls@radix.net>
To: Mike Isely <isely@pobox.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
References: <20090404142427.6e81f316@hyperion.delvare>
	 <20090404142837.3e12824c@hyperion.delvare>
	 <Pine.LNX.4.64.0904041045380.32720@cnc.isely.net>
	 <20090405010539.187e6268@hyperion.delvare>
	 <Pine.LNX.4.64.0904041807300.32720@cnc.isely.net>
	 <20090405161803.70810455@hyperion.delvare>
	 <Pine.LNX.4.64.0904051315490.32738@cnc.isely.net>
Content-Type: text/plain
Date: Sun, 05 Apr 2009 16:19:52 -0400
Message-Id: <1238962792.3337.122.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 2009-04-05 at 13:33 -0500, Mike Isely wrote:

>  Also, lirc makes it possible to userspace map the underlying 
> IR codes to keybindings and associate multiple different remotes - all 
> of that is apparently hardcoded in ir-kbd-i2c.

Yes.  My first remote for my PC was an HP OEM'ed and customized unit.
LIRC's text configuration files made support for the remote's
non-standard keys a task for 'vi' and not 'make'.

Key mappings belong in configuration files - not hard coded in the
kernel.



>   Wierd or not, your 
> change makes it hard(er) on those who legitimately wish to use lirc.  
> Here's an interesting summary:
> 
> If fact, the only pvrusb2-driven hardware from Hauppauge that is known 
> to work with ir-kbd-i2c are the old 29xxx and 24xxx model series (not 
> the "MCE" series).  Those devices are out of production, AFAIK.  The 
> current devices being sold by Hauppauge don't work at all with 
> ir-kbd-i2c and probably never will.
> 
> Perhaps one can conclude that there hasn't been a lot of pressure (that 
> I know about) to deal with updating / enhancing / replacing ir-kbd-i2c 
> because lirc happens to be filling the niche better in many cases.

Here is where LIRC may be its own worst enemy.  LIRC has filled some
shortcomings in the kernel for support of IR device functions for so
long (LWN says LIRC is 10 years old), that large numbers of users have
come to depend on its operation, while at the same time apparently
removing impetus for doing much to update the in kernel IR device
support.

Some of the discussion on the LKML about why an input layer device is
sufficient for handling most, but not all cases is interesting:

http://lkml.org/lkml/2008/9/11/63

Gerd also enlightens us on why we have ir-kdb-i2c in kernel in that
post.  It appears that ir-kbd-i2c was written to avoid using LIRC for TV
card I2C IR devices for the most common use cases.  As such, it's a 90%
(80%, 70% ?) solution: no blasting, no raw IR parsing for unknown
protocols, only the most "common" remotes supported, and, of course, no
support for non-I2C devices.


My needs don't fit that unfortunately.  I need IR blasting, an uncommon
remote supported, and both USB and I2C IR device support.


Regards,
Andy

