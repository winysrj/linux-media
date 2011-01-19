Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:59266 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754747Ab1ASQ5K (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 11:57:10 -0500
Date: Wed, 19 Jan 2011 10:57:10 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Jarod Wilson <jarod@wilsonet.com>
cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
In-Reply-To: <399CBB46-ACEB-403F-BAD5-87FD286D057B@wilsonet.com>
Message-ID: <alpine.DEB.1.10.1101191050560.22872@cnc.isely.net>
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net> <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
 <399CBB46-ACEB-403F-BAD5-87FD286D057B@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011, Jarod Wilson wrote:

> On Jan 19, 2011, at 8:20 AM, Mike Isely wrote:
> 
> > This probing behavior does not happen for HVR-1950 (or HVR-1900) since 
> > there's only one possible IR configuration there.
> 
> Just to be 100% clear, the device I'm poking it is definitely an
> HVR-1950, using ir_scheme PVR2_IR_SCHEME_ZILOG, so the probe bits
> shouldn't coming into play with anything I'm doing. Only just now
> started looking at the pvrusb2 code. Wow, there's a LOT of it. ;)

Yes, and yes :-)

The standalone driver version (which is loaded with ifdef's that allow 
compilation back to 2.6.11) makes the in-kernel driver look small by 
comparison.

There is a fair degree of compartmentalization between the modules.  
The roadmap to what it does for just HVR-1950 you can find by first 
looking at the declarations in pvrusb2-devattr.h and then the 
device-specific configurations in pvrusb2-devattr.c.  From there you can 
usually grep your way around to see how those configuration bits affect 
the rest of the driver.  Most of the really fun stuff is in 
pvrusb2-hdw.c.  Pretty much everything else supports or uses that 
central component.

The actual stuff which deals with I2C is not that large.  Beyond making 
the access possible at all, the driver largely just tries to stay out of 
the way of external logic that needs to reach the bus.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
