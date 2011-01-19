Return-path: <mchehab@pedra>
Received: from cnc.isely.net ([64.81.146.143]:40065 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab1ASORR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 09:17:17 -0500
Date: Wed, 19 Jan 2011 08:17:16 -0600 (CST)
From: Mike Isely <isely@isely.net>
To: Andy Walls <awalls@md.metrocast.net>
cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Mike Isely <isely@isely.net>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
In-Reply-To: <1295444282.4317.20.camel@morgan.silverblock.net>
Message-ID: <alpine.DEB.1.10.1101190812390.5396@ivanova.isely.net>
References: <1295205650.2400.27.camel@localhost>  <1295234982.2407.38.camel@localhost>  <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>  <1295439718.2093.17.camel@morgan.silverblock.net>  <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
 <1295444282.4317.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On Wed, 19 Jan 2011, Andy Walls wrote:

   [...]

> 
> So the HVR-1950 only has Z8's capable of both Tx and Rx?  No HVR-1950
> has an Rx only Z8 unit?

As far as I know, that is indeed the case - Tx and Rx always.

It's the older 24xxx devices where there could be a difference, and 
that's why the probe only takes place there.  (And in the receive-only 
24xxx configuration it's not a Z8 but something wierd that is only 
accessible through FX2 commands not via I2C, which is why the bridge 
driver emulates the older I2C chip, making IR reception behave like the 
original 29xxx device.)

  -Mike

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
