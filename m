Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:35063 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab1ASRoR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 12:44:17 -0500
Date: Wed, 19 Jan 2011 18:43:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Andy Walls <awalls@md.metrocast.net>, Mike Isely <isely@isely.net>,
	linux-media@vger.kernel.org, Jarod Wilson <jarod@redhat.com>,
	Janne Grunau <j@jannau.net>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES for 2.6.38] Zilog Z8 IR unit fixes
Message-ID: <20110119184322.0e5d12cd@endymion.delvare>
In-Reply-To: <D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com>
References: <1295205650.2400.27.camel@localhost>
	<1295234982.2407.38.camel@localhost>
	<848D2317-613E-42B1-950D-A227CFF15C5B@wilsonet.com>
	<1295439718.2093.17.camel@morgan.silverblock.net>
	<alpine.DEB.1.10.1101190714570.5396@ivanova.isely.net>
	<1295444282.4317.20.camel@morgan.silverblock.net>
	<20110119145002.6f94f800@endymion.delvare>
	<D7F0E4A6-5A23-4A28-95F8-0A088F1D6114@wilsonet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 19 Jan 2011 12:12:49 -0500, Jarod Wilson wrote:
> On Jan 19, 2011, at 8:50 AM, Jean Delvare wrote:
> 
> > Hi Andy,
> > 
> > On Wed, 19 Jan 2011 08:38:02 -0500, Andy Walls wrote:
> >> As I understand it, the rules/guidelines for I2C probing are now
> >> something like this:
> >> 
> >> 1. I2C device driver modules (ir-kbd-i2c, lirc_zilog, etc.) should not
> >> do hardware probes at all.  They are to assume the bridge or platform
> >> drivers verified the I2C slave hardware's existence somehow.
> >> 
> >> 2. Bridge drivers (pvrusb, hdpvr, cx18, ivtv, etc.) should not ask the
> >> I2C subsystem to probe hardware that it knows for sure exists, or knows
> >> for sure does not exist.  Just add the I2C device or not.
> >> 
> >> 3. Bridge drivers should generally ask the I2C subsystem to probe for
> >> hardware that _may_ exist.
> >> 
> >> 4. If the default I2C subsystem hardware probe method doesn't work on a
> >> particular hardware unit, the bridge driver may perform its own hardware
> >> probe or provide a custom hardware probe method to the I2C subsystem.
> >> hdpvr and pvrusb2 currently do the former.
> > 
> > Yes, that's exactly how things are supposed to work now. And hopefully
> > it makes sense and helps you all write cleaner code (that was the
> > intent at least.)
> 
> One more i2c question...
> 
> Am I correct in assuming that since the zilog is a single device, which
> can be accessed via two different addresses (0x70 for tx, 0x71 for rx),
> that i2c_new_device() just once with both addresses in i2c_board_info
> is correct, vs. calling i2c_new_device() once for each address?

Preliminary technical nitpicking: you can't actually pass two addresses
in i2c_board_info, so the second address has to be passed as platform
data.

I am sorry if you expected an authoritative answer, but... both options
are actually possible.

If you use a single call to i2c_new_device(), you'll have a single
i2c_client to start with, and you'll have to instantiate the second one
in the probe function using i2c_new_dummy().

If you instead decide to call i2c_new_device() twice, there will be two
calls to the probe function (which can be the same one in a single
driver, or two different ones in separate drivers, at your option.) If
any synchronization is needed between the two i2c_clients, you have to
use the bridge driver as a relay, as Andy proposed doing already.

Really, both are possible, and the two options aren't that different in
the end. I can't think of anything that can be done with one that
couldn't be achieved with the other.

> At least, I'm reasonably sure that was the key to making the hdpvr IR
> behave with lirc_zilog, and after lunch, I should know if that's also
> the case for pvrusb2 devices w/a zilog IR chip.

-- 
Jean Delvare
