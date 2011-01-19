Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:59479 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754375Ab1ASN23 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:28:29 -0500
Date: Wed, 19 Jan 2011 07:28:28 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@md.metrocast.net>
cc: Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
In-Reply-To: <1295443454.4317.6.camel@morgan.silverblock.net>
Message-ID: <alpine.DEB.1.10.1101190726120.5396@ivanova.isely.net>
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>  <1295439718.2093.17.camel@morgan.silverblock.net>  <20110119134009.1d473320@endymion.delvare>
 <1295443454.4317.6.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011, Andy Walls wrote:

> On Wed, 2011-01-19 at 13:40 +0100, Jean Delvare wrote:
> > On Wed, 19 Jan 2011 07:21:58 -0500, Andy Walls wrote:
> > > For debugging, you might want to hack in a probe of address 0x70 for
> > > your HVR-1950, to ensure the Tx side responds in the bridge driver. 
> > 
> > ... keeping in mind that the Z8 doesn't seem to like quick writes, so
> > short reads should be used for probing purpose.
> > 
> 
> Noted.  Thanks.
> 
> Actually, I think that might be due to the controller in the USB
> connected devices (hdpvr and pvrusb2).  The PCI connected devices, like
> cx18 cards, don't have a problem with the Z8, the default I2C probe
> method, and i2c-algo-bit.
> (A good example of why only bridge drivers should do any required
> probing.)
> 
> 
> Looking at the code in pvrusb2, it appears to already use a 0 length
> read for a probe:
> 
> http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/pvrusb2/pvrusb2-i2c-core.c;h=ccc884948f34b385563ccbf548c5f80b33cd4f08;hb=refs/heads/staging/for_2.6.38-rc1#l542

Yes but that function is used in two places: (1) If a bus scan is 
performed during initialization (normally it isn't), and (2) it is 
called once ONLY for a 24xxx device (targeting 0x71) in order to 
determine if it is dealing with the MCE variant.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
