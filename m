Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:17257 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab1EDNPk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 4 May 2011 09:15:40 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19905.20858.398133.877952@morden.metzler>
Date: Wed, 4 May 2011 15:15:38 +0200
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Issa Gorissen <flop.m@usa.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4DC146E1.3000103@linuxtv.org>
References: <148PeDiAM3760S04.1304497658@web04.cms.usa.net>
	<4DC1236C.3000006@linuxtv.org>
	<19905.13923.40846.342434@morden.metzler>
	<4DC146E1.3000103@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > > Of course it does since it is not feasible to use the same adapter
 > > number even on the same card when it provides multi-standard 
 > > frontends which share dvr and demux devices. E.g., frontend0 and
 > > frontend1 can belong to the same demod which can be DVB-C and -T 
 > > (or other combinations, some demods can even do DVB-C/T/S2). 
 > 
 > There's absolutely no need to have more than one frontend device per
 > demod. Just add two commands, one to query the possible delivery systems
 > and one to switch the system. Why would you need more than one device
 > node at all, if you can only use one delivery system at a time?


Maybe because there is no proper documentation for this.


 > > Or is there a standard way this is supposed to be handled?
 > 
 > Yes. Since ages. The ioctl is called DMX_SET_SOURCE.

This does make no sense regarding my question.


 > > There are no mechanism to connect a frontend with specific dvr or
 > > demux devices in the current API. But you demand it for the caio device.
 > 
 > See above.

Ok, wrong formulation. There is no API to indicate which can connect
to which.


 > > A ca/caio pair is completely independent by design and should not get mixed with
 > > other devices.
 > 
 > I guess you're right, but I'm questioning your design.


How else can an independent CI interface be designed?
And this is how the hardware is. I cannot change this in software.

 > >  > It's ugly to force random policies on drivers. Please create a proper
 > >  > interface instead!
 > >  > 
 > > 
 > > Then the whole API should first get proper interfaces. See above.
 > 
 > Already done. See above.

And no proper documentation.


 > Of course, you shouldn't invent fake frontends. But, if you decide to
 > plug a frontend into your octopus card later on, then the frontend
 > device should appear under the same adapter number. Right?

No, it does not right now.

 
 > >  > At least on embedded devices, it simply isn't feasible to copy a TS to
 > >  > userspace from a demux, just to copy it back to the kernel and again
 > >  > back to userspace through a caio device, when live streaming.
 > > 
 > > Then do not use it on embedded devices. 
 > > But this is how this hardware works and APIs will not change the hardware.
 > 
 > In a similar way, I could propose to not use vanilla kernels, if you
 > don't want to come up with a good API.

Why? The driver works fine on top of vanilla kernels.

I do not really care if the driver itself gets into the kernel anymore.

 
-Ralph
