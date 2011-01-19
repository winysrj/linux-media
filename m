Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:45147 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753059Ab1ASNh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:37:58 -0500
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
From: Andy Walls <awalls@md.metrocast.net>
To: Mike Isely <isely@isely.net>
Cc: Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>,
	Jean Delvare <khali@linux-fr.org>, Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
In-Reply-To: <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
References: <1295205650.2400.27.camel@localhost>
	 <1295234982.2407.38.camel@localhost>
	 <848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	 <1295439718.2093.17.camel@morgan.silverblock.net>
	 <alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 08:38:02 -0500
Message-ID: <1295444282.4317.20.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 2011-01-19 at 07:20 -0600, Mike Isely wrote:
> On Wed, 19 Jan 2011, Andy Walls wrote:
> 
> > On Wed, 2011-01-19 at 00:20 -0500, Jarod Wilson wrote:
> > 
> > 
> > >  Not working with
> > > lirc_zilog yet, it fails to load, due to an -EIO ret to one of the
> > > i2c_master_send() calls in lirc_zilog during probe of the TX side. Haven't
> > > looked into it any more than that yet.
> > 
> > Well technically lirc_zilog doesn't "probe" anymore.  It relies on the
> > bridge driver telling it the truth.
> 
> The bridge driver (pvrusb2) still does one probe if it's a 24xxx device: 
> It probes 0x71 in order to determine if it is dealing with an MCE 
> variant device.  Hauppauge did not change the USB ID when they released 
> the 24xxx MCE variant (which has the IR blaster, thus the zilog device).  
> The only way to tell the two devices apart is by discovering the 
> existence of the zilog device - and the bridge driver needs to do this 
> in order to properly disable its "emulated" I2C IR receiver which would 
> otherwise be needed for the non-MCE device.
> 
> Based on the discussion here, could that probe be a source of trouble on 
> the 24XXX MCE device?

IMO, No. I think it is needed and just fine.

As I understand it, the rules/guidelines for I2C probing are now
something like this:

1. I2C device driver modules (ir-kbd-i2c, lirc_zilog, etc.) should not
do hardware probes at all.  They are to assume the bridge or platform
drivers verified the I2C slave hardware's existence somehow.

2. Bridge drivers (pvrusb, hdpvr, cx18, ivtv, etc.) should not ask the
I2C subsystem to probe hardware that it knows for sure exists, or knows
for sure does not exist.  Just add the I2C device or not.

3. Bridge drivers should generally ask the I2C subsystem to probe for
hardware that _may_ exist.

4. If the default I2C subsystem hardware probe method doesn't work on a
particular hardware unit, the bridge driver may perform its own hardware
probe or provide a custom hardware probe method to the I2C subsystem.
hdpvr and pvrusb2 currently do the former.


> This probing behavior does not happen for HVR-1950 (or HVR-1900) since 
> there's only one possible IR configuration there.

So the HVR-1950 only has Z8's capable of both Tx and Rx?  No HVR-1950
has an Rx only Z8 unit?

Regards,
Andy



