Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:44236 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1EDLUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 07:20:06 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19905.13923.40846.342434@morden.metzler>
Date: Wed, 4 May 2011 13:20:03 +0200
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4DC1236C.3000006@linuxtv.org>
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>
	<4DC1236C.3000006@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > > - ca0 would be reached from /dev/dvb/adapter0/ca0
 > > - ca[12], depending on if they are connected to the same physical adapter
 > > (PCI, USB, ...), would be reached from /dev/dvb/adapter1/ca[12] or
 > > /dev/dvb/adapter1/ca1 and /dev/dvb/adapter2/ca2 and there respective caio
 > > devices.
 > 
 > Of course I'm referring to devices connected to the same physical
 > adapter. Otherwise they would all be called ca0. Device enumeration
 > always starts at 0, for each adapter. What you're describing just
 > doesn't make sense.

Of course it does since it is not feasible to use the same adapter
number even on the same card when it provides multi-standard 
frontends which share dvr and demux devices. E.g., frontend0 and
frontend1 can belong to the same demod which can be DVB-C and -T 
(or other combinations, some demods can even do DVB-C/T/S2). 

frontend0 and frontend1 could then be DVB-C/T of demod 0
frontend2 and frontend3 would be DVB-C/T of demod 1.
frontend4 might be a DVB-S frontend of demod 2, frontend5 DVB-S of
demod 3. How do I know then which frontends belong to the 
4 demux/dvr devices? 
Or is there a standard way this is supposed to be handled?

There are no mechanism to connect a frontend with specific dvr or
demux devices in the current API. But you demand it for the caio device.

 
 > > - If the 3 ca devices are on the same adapter, then the driver writer should
 > > take care of the order of the mapping so that ca1 always map caio1 and
 > > ca2/caio2, ...; and if this is not feasable, then the driver writer should
 > > span the ca/caio devices on different /dev/dvb/adapter folders.
 > 
 > You can't create caio1 without creating caio0 first. Of course, you
 > could require driver writers to register those ca devices first that
 > have caio devices. But that conflicts with other policies the driver
 > author might already have chosen, e.g. to map the ca (descrambler)
 > device numbers to demux and dvr numbers, which seems way more intuitive
 > to me, because demux hardware usually comes with built-in descramblers.

A ca/caio pair is completely independent by design and should not get mixed with
other devices.

 > 
 > It's ugly to force random policies on drivers. Please create a proper
 > interface instead!
 > 

Then the whole API should first get proper interfaces. See above.


 > Last but not least, using a different adapter number wouldn't fit
 > either, because a DVB adapter is supposed to
 > - be one independent piece of hardware
 > - provide at least a frontend and a demux device

If you only plug in CI adapter modules in the octopus cards there are
no frontend and demux devices.
So, should we invent frontend and demux devices so that we are allowed
to use the DVB API? 
Or should we create a new independent API for this? 
Even if we copy 99% of the existing ca API?

 > At least on embedded devices, it simply isn't feasible to copy a TS to
 > userspace from a demux, just to copy it back to the kernel and again
 > back to userspace through a caio device, when live streaming.

Then do not use it on embedded devices. 
But this is how this hardware works and APIs will not change the hardware.

 >  But you
 > may want to provide a way to use the caio device for
 > offline-descrambling. Unless you want to force users to buy multiple
 > modules and multiple subscriptions for a single receiver, which in turn
 > would need multiple CI slots, you need a way to make sure caio can not
 > be used during live streaming. If this dependency is between different
 > adapters, then something is really, really wrong.

What dependency are you talking about?


 > 
 > Why don't you just create a new device, e.g. ciX, deprecate the use of
 > caX for CI devices, inherit CI-related existing ioctls from the CA API,
 > translate the existing read and write funtions to ioctls and then use
 > read and write for TS I/O? IIRC, Ralph suggested something similar. I'm
 > pretty sure this can be done without too much code and in a backwards
 > compatible way.


This would require changing all en50221 related user space code. I
only mentioned it would have been nice to have it this way from the
beginning. Now it would be too late since one usually gets loud 
screaming from everywhere if user space API changes
(not extensions) are even thought about.


-Ralph


