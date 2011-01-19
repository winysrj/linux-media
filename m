Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:58646 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754152Ab1ASMWH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 07:22:07 -0500
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
From: Andy Walls <awalls@md.metrocast.net>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
References: <1295205650.2400.27.camel@localhost>
	 <1295234982.2407.38.camel@localhost>
	 <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 07:21:58 -0500
Message-ID: <1295439718.2093.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-19 at 00:20 -0500, Jarod Wilson wrote:
> On Jan 16, 2011, at 10:29 PM, Andy Walls wrote:
> 
> > On Sun, 2011-01-16 at 14:20 -0500, Andy Walls wrote:
> >> Mauro,
> >> 
> >> Please pull the one ir-kbd-i2c change and multiple lirc_zilog changes
> >> for 2.6.38.
> >> 
> >> The one ir-kbd-i2c change is to put back a case to have ir-kbd-i2c set
> >> defaults for I2C client address 0x71.  I know I was the one who
> >> recommend that ir-kbd-i2c not do this, but I discovered pvrusb2 and bttv
> >> rely on it for the moment - Mea culpa.
> >> 
> >> The lirc_zilog changes are tested to work with both Tx and Rx with an
> >> HVR-1600.  I don't want to continue much further on lirc_zilog changes,
> >> unitl a few things happen:
> >> 
> >> 1. I have developed, and have had tested, a patch for the pvrusb2 driver
> >> to allow the in kernel lirc_zilog to bind to a Z8 on a pvrusb2 supported
> >> device.
> > 
> > Mauro,
> > 
> > I have developed a patch for pvrusb2 and Mike Isely provided his Ack.  I
> > have added it to my "z8" branch and this pull request.
> 
> I've finally got around to trying it out with the HVR-1950 I've got here,
> and it does do the trick for ir-kbd-i2c (albeit I never see proper key
> repeats, only alternating press/release key events).

Yay, a small victory.

I explicitly set the polling interval to 260 ms in pvrusb2, based on
your hdpvr findings and lirc_zilog code.  I guess you can try tweaking
that back to 100 ms.


>  Not working with
> lirc_zilog yet, it fails to load, due to an -EIO ret to one of the
> i2c_master_send() calls in lirc_zilog during probe of the TX side. Haven't
> looked into it any more than that yet.

Well technically lirc_zilog doesn't "probe" anymore.  It relies on the
bridge driver telling it the truth.

But yes, lirc_zilog is overly sensitive to anything not being right
during lirc_zilog.c:ir_probe().

BTW, does your HVR-1950 have a blaster?  The simple code I added to
pvrusb2 doesn't try to detect a unit on address 0x70.  It always assumes
the Z8 is Tx capable.

With the cx18 and ivtv cards, the Hauppauge EEPROM indicates whether a
blaster is present.  For those bridge drivers, I can communicate that
information to the IR modules.

For the hdpvr and pvrusb2, my short term plan was to always assume a Z8
could Tx, and make lirc_zilog not barf when it couldn't talk to a Tx
unit.  I notice that Mike had written some short, simple IR unit
detection code here for other reasons:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/pvrusb2/pvrusb2-i2c-core.c;h=ccc884948f34b385563ccbf548c5f80b33cd4f08;hb=refs/heads/staging/for_2.6.38-rc1#l661
http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/pvrusb2/pvrusb2-i2c-core.c;h=ccc884948f34b385563ccbf548c5f80b33cd4f08;hb=refs/heads/staging/for_2.6.38-rc1#l542

For debugging, you might want to hack in a probe of address 0x70 for
your HVR-1950, to ensure the Tx side responds in the bridge driver. 

Regards,
Andy



