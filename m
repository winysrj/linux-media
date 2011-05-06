Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:60912 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757Ab1EFKxA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 06:53:00 -0400
Message-ID: <4DC3D309.8040202@linuxtv.org>
Date: Fri, 06 May 2011 12:52:57 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: linux-media@vger.kernel.org
Subject: Re: multiple delivery systems in one device
References: <19906.31252.838100.862025@morden.metzler>
In-Reply-To: <19906.31252.838100.862025@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/05/2011 12:21 PM, Ralph Metzler wrote:
> Hi,
> 
> since it seems devices with several delivery systems can be queried 
> with one command:
> 
> Andreas Oberritter writes:
>  > > Of course it does since it is not feasible to use the same adapter
>  > > number even on the same card when it provides multi-standard 
>  > > frontends which share dvr and demux devices. E.g., frontend0 and
>  > > frontend1 can belong to the same demod which can be DVB-C and -T 
>  > > (or other combinations, some demods can even do DVB-C/T/S2). 
>  > 
>  > There's absolutely no need to have more than one frontend device per
>  > demod. Just add two commands, one to query the possible delivery systems
>  > and one to switch the system. Why would you need more than one device
>  > node at all, if you can only use one delivery system at a time?
> 
> can somebody tell me how this is done and how it has to be supported
> in the demod driver?

Such commands don't exist yet and therefore need to be added as required.
For the Dreambox, we're currently using a proprietary interface to switch
between C and T, when the frontend is closed.

For an implementation within the bounds of the API, the device must not
be closed. Hence, I'd propose something like the following:

- In the driver, implement the set_property callback. For the property
  DTV_DELIVERY_SYSTEM, do whatever is required to change the delivery
  system if required, e.g.:
  - Add and call a function to pause the frontend thread.
  - Call fe->ops->sleep(fe) et al. (c.f. dvb_powerdown_on_sleep).
  - Set fe->ops to the new struct dvb_frontend_ops pointer.
  - Call dvb_frontend_reinitialise(fe);
    - Fix dvb_frontend_thread() to not call ops.set_voltage and
      ops.set_tone unless non-null.

- Add an S2API property DTV_DELIVERY_SYSTEMS which can be used
  to query the available delivery systems.

- Add a default 'get_property' implementation to dvb_frontend.c:
  - tvp->u.buffer.data[0] = c->delivery_system;
    tvp->u.buffer.len = 1;

- Implement ops.get_property in the driver, e.g.:
    tvp->u.buffer.data[0] = SYS_DVBC_ANNEX_AC;
    tvp->u.buffer.data[1] = SYS_DVBT;
    tvp->u.buffer.data[2] = SYS_DVBT2;
    tvp->u.buffer.len = 3;

- Increment minor API version.

Regards,
Andreas
