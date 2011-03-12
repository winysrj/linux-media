Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:33449 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877Ab1CLOiH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Mar 2011 09:38:07 -0500
Message-ID: <4D7B8549.2090008@linuxtv.org>
Date: Sat, 12 Mar 2011 15:38:01 +0100
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Ralph Metzler <rjkm@metzlerbros.de>
CC: Martin Vidovic <xtronom@gmail.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <alpine.LNX.2.00.1103101608030.9782@hp8540w.home>	<4D7A452C.7020700@linuxtv.org>	<4D7A97BB.4020704@gmail.com>	<4D7B7524.2050108@linuxtv.org> <19835.32151.116648.554824@morden.metzler>
In-Reply-To: <19835.32151.116648.554824@morden.metzler>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/12/2011 03:05 PM, Ralph Metzler wrote:
> Andreas Oberritter writes:
>  > On 03/11/2011 10:44 PM, Martin Vidovic wrote:
>  > > Andreas Oberritter wrote:
>  > >> It's rather unintuitive that some CAMs appear as ca0, while others as
>  > >> cam0.
>  > >>   
>  > > Ngene CI appears as both ca0 and cam0 (or sec0). The ca0 node is used
>  > > as usual, to setup the CAM. The cam0 (or sec0) node is used to read/write
>  > > transport stream. To me it  looks like an extension of the current API.
>  > 
>  > I see. This raises another problem. How to find out, which ca device
>  > cam0 relates to, in case there are more ca devices than cam devices?
>  > 
> 
> They should be in different adapterX directories. 
> Even on the cards where you can connect up to 4 dual frontends or CAM adapters
> I currently use one adapter directory for every frontend and CAM.

That looks like a hack to me, that may work well for your PC style
adapter, e.g frontends and CAMs attached to PCI or USB. But how would
you integrate audio and video decoders and hardware demux devices into
that scenario? Would you expect adapterN's frontend to be able to feed a
TS into adapterN+1's hardware demux and then into adapterN+2's video
decoder?

> If you want to "save" adapters one could put them in the same
> directory and caX would belong to camX. 
> More ca than cam devices could only occur on cards with mixed old and
> new style hardware. I am not aware of such cards.

DVB descramblers use ca devices, too. So it's certainly possible to occur.

And even if no hardware exists that uses CAM slots with such different
capabilities, we should be prepared when such hardware appears.

> I think there are cards with dual frontend and two CAM adapters where
> normally data from frontendX is passed through caX (they are in the same adapter
> directory) but the paths can also be switched. I do not now how this is
> handled.

On our STB platform. we have four frontends and four CAM slots.
Frontends and CAM slots get connected on demand or even chained to allow
multiple CAMs to try to decode parts of the same TS. I don't see how
multiple adapters could fit in that situation.

Regards,
Andreas
