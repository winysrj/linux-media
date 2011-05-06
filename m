Return-path: <mchehab@pedra>
Received: from cmsout02.mbox.net ([165.212.64.32]:59941 "EHLO
	cmsout02.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932478Ab1EFS3k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 May 2011 14:29:40 -0400
Date: Fri, 06 May 2011 20:29:35 +0200
From: "Issa Gorissen" <flop.m@usa.net>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Ngene cam device name
CC: Martin Vidovic <xtronom@gmail.com>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	<linux-media@vger.kernel.org>
Mime-Version: 1.0
Message-ID: <494PeFsCj8960S01.1304706575@web01.cms.usa.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: Andreas Oberritter <obi@linuxtv.org>
> On 05/06/2011 03:47 PM, Issa Gorissen wrote:
> > From: Andreas Oberritter <obi@linuxtv.org>
> >>> The best would be to create independent adapters for each independent
CA
> >>> device (ca0/caio0 pair) - they are independent after all (physically
and
> >>> in the way they're used).
> >>
> >> Physically, it's a general purpose TS I/O interface of the nGene
> >> chipset. It just happens to be connected to a CI slot. On another board,
> >> it might be connected to a modulator or just to some kind of socket.
> >>
> >> If the next version gets a connector for two switchable CI modules, then
> >> the physical independence is gone. You'd have two ca nodes but only one
> >> caio node. Or two caio nodes, that can't be used concurrently.
> >>
> >> Maybe the next version gets the ability to directly connect the TS input
> >> from the frontend to the TS output to the CI slot to save copying around
> >> the data, by using some kind of pin mux. Not physically independent
either.
> >>
> >> It just looks physically independent in the one configuration
> >> implemented now.
> > 
> > 
> > When I read the cxd2099ar datasheet, I can see that in dual slot
> > configuration, there is still one communication channel for the TS and one
for
> > the control.
> 
> It doesn't matter how the cxd2099ar works, because I'm talking about the
> nGene chipset in place of any chipset having at least two TS inputs and
> one TS output.


Don't know the ngene bridge enough to comment on this.


> 
> Btw., I don't think the cxd2099 driver has any obvious problems. It's
> the nGene driver that registers the sec/caio interface.
> 
> > Also, it seems linux en50221 stack provides for the slot selection. So,
why
> > would you need two ca nodes ?
> 
> Because it's the most obvious way to use it. And more importantly
> because the API sucks, if you have more than one device per node. You
> can have only one reader, one writer, one poll function per node. For
> example, you can't use one instance of mplayer to watch one channel with
> fe0+dmx0+ca0 and a second instance of mplayer to watch or record another
> channel with fe1+dmx1+ca0. You won't know which device has an event if
> you use poll. The API even allows mixing multiple CI slots and built-in
> descramblers in the same node. But try calling CA_RESET on a specific
> slot or on a descrambler. It won't work. It's broken by design.


You need to write a userspace soft which will handle the concurrent access of
your ca device...

But for your given example, is there any card allowing you to do that (one ci
slot, two tuners) ?

