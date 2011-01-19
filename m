Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:35580 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1ASNUN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:20:13 -0500
Date: Wed, 19 Jan 2011 07:20:12 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@md.metrocast.net>
cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
In-Reply-To: <1295439718.2093.17.camel@morgan.silverblock.net>
Message-ID: <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com> <1295439718.2093.17.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011, Andy Walls wrote:

> On Wed, 2011-01-19 at 00:20 -0500, Jarod Wilson wrote:
> 
> 
> >  Not working with
> > lirc_zilog yet, it fails to load, due to an -EIO ret to one of the
> > i2c_master_send() calls in lirc_zilog during probe of the TX side. Haven't
> > looked into it any more than that yet.
> 
> Well technically lirc_zilog doesn't "probe" anymore.  It relies on the
> bridge driver telling it the truth.

The bridge driver (pvrusb2) still does one probe if it's a 24xxx device: 
It probes 0x71 in order to determine if it is dealing with an MCE 
variant device.  Hauppauge did not change the USB ID when they released 
the 24xxx MCE variant (which has the IR blaster, thus the zilog device).  
The only way to tell the two devices apart is by discovering the 
existence of the zilog device - and the bridge driver needs to do this 
in order to properly disable its "emulated" I2C IR receiver which would 
otherwise be needed for the non-MCE device.

Based on the discussion here, could that probe be a source of trouble on 
the 24XXX MCE device?

This probing behavior does not happen for HVR-1950 (or HVR-1900) since 
there's only one possible IR configuration there.

  -Mike


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
