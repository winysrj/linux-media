Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:16461 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1CLPGG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 10:06:06 -0500
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19835.35802.17724.340910@morden.metzler>
Date: Sat, 12 Mar 2011 16:06:02 +0100
To: Andreas Oberritter <obi@linuxtv.org>
Cc: Ralph Metzler <rjkm@metzlerbros.de>,
	Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
In-Reply-To: <4D7B8549.2090008@linuxtv.org>
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home>
	<4D7A452C.7020700@linuxtv.org>
	<4D7A97BB.4020704@gmail.com>
	<4D7B7524.2050108@linuxtv.org>
	<19835.32151.116648.554824@morden.metzler>
	<4D7B8549.2090008@linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Andreas Oberritter writes:
 > > They should be in different adapterX directories. 
 > > Even on the cards where you can connect up to 4 dual frontends or CAM adapters
 > > I currently use one adapter directory for every frontend and CAM.
 > 
 > That looks like a hack to me, that may work well for your PC style
 > adapter, e.g frontends and CAMs attached to PCI or USB. But how would

Exactly what I want to support with this.


 > you integrate audio and video decoders and hardware demux devices into
 > that scenario? Would you expect adapterN's frontend to be able to feed a
 > TS into adapterN+1's hardware demux and then into adapterN+2's video
 > decoder?

This would be up to the application since there is no hardware stream
routing on these cards and no general stream routing protocol for 
DVB in the kernel.

 > > If you want to "save" adapters one could put them in the same
 > > directory and caX would belong to camX. 
 > > More ca than cam devices could only occur on cards with mixed old and
 > > new style hardware. I am not aware of such cards.
 > 
 > DVB descramblers use ca devices, too. So it's certainly possible to occur.

Not in the same adapter directory.


 > And even if no hardware exists that uses CAM slots with such different
 > capabilities, we should be prepared when such hardware appears.

Then we also should not use the current API (or any) for the same reason?


 > > I think there are cards with dual frontend and two CAM adapters where
 > > normally data from frontendX is passed through caX (they are in the same adapter
 > > directory) but the paths can also be switched. I do not now how this is
 > > handled.
 > 
 > On our STB platform. we have four frontends and four CAM slots.
 > Frontends and CAM slots get connected on demand or even chained to allow
 > multiple CAMs to try to decode parts of the same TS. I don't see how
 > multiple adapters could fit in that situation.

Is this routing in hardware? If yes, it is totally different 
because your devices are not independent.
How do you support this with the current API?


Regards,
Ralph



