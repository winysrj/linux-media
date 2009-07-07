Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:49962 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754154AbZGGCkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Jul 2009 22:40:51 -0400
Subject: Re: Re : [linux-dvb] Best stable DVB-S2 cards
From: hermann pitton <hermann-pitton@arcor.de>
To: Manu <eallaud@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1246930288.7402.0@manu-laptop>
References: <OFAEA012C7.BAA6BA92-ONC12575DE.00386C0E-C12575DE.00386C1B@devoteam.com>
	 <4A524C80.3010102@gmail.com>  <1246930288.7402.0@manu-laptop>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 07 Jul 2009 04:38:15 +0200
Message-Id: <1246934295.3741.16.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am Montag, den 06.07.2009, 21:31 -0400 schrieb Manu:
> Le 06/07/2009 15:12:00, Claes Lindblom a écrit :
> > Jens.Peder.Terjesen@devoteam.com wrote:
> > >
> > > -----sacha wrote: -----
> > >
> > > >To: claesl@gmail.com
> > > >From: sacha <sacha@hemmail.se>
> > > >Sent by: linux-dvb-bounces@linuxtv.org
> > > >Date: 22-06-2009 21:21
> > > >cc: linux-dvb@linuxtv.org
> > > >Subject: [linux-dvb] Best stable DVB-S2 cards
> > > >
> > > >Claes
> > > >Forget all that has with stability to do on Linux, it will never
> > > >work!
> > > >It is my experience after three years of desperate trying. I have
> > the
> > > >same card and some others. Sometimes they works sometimes no. 24
> > > >hours
> > > >running is called High Availability in IT world and can be assured
> > > >only
> > > >by the commercial solutions. Believe me, I spent 14 years in
> > > >commercial
> > > >Unix and know what I am talking about.
> > > >
> > > >KR
> > > >
> > > >>Hi,
> > > >>I currently have a Azurewave AD-SP400 CI (Twinhan VP-1041)  DVB-
> > S2
> > > >>card 
> > > >>but I'm not sure if it
> > > >>that stable to have it running 24h every day on a server.
> > > >>I'm looking for a good DVB-S2 card that works out of the box in
> > > >Linux 
> > > >>kernel, does anyone have any good
> > > >>recommendations, both with or without CI. It's important that it
> > is 
> > > >>stable so I don't have to restart the server.
> > > >>I'm running Ubuntu Server 9.04 64-bit with kernel
> > 2.6.28-11-server.
> > > >
> > > ></Claes
> > > >
> > >
> > > I have three Hauppauge HVR-4000. Two that have been used for DVB-S
> > for
> > > about one year and one for DVB-S2 for about half a year without any
> > > stability issues.
> > > In the beginning it was a little fiddly with patching v4l-dvb, but
> > > support for this card was included in v4l-dvb last autumn and in 
> > the
> > > 2.6.28 kernel in November or December last year.
> > >
> > Thats sounds really good, does it work well with DVB-S2 and Mythtv?
> > By the way to use them in the same computer?
> > 
> > What's the status of Technotrend TT 1600 and 3200 in the main
> > dvb-tree?
> > And how about the issues noted in this thread
> > http://linuxtv.org/pipermail/linux-dvb/2009-February/031779.html ?
> 
> Here TT 3200 works great (using CI) for DVB-S pnmy. I cant tell for S2 
> as there is no transponder (apart for one but which has a way too high 
> symbol rate). I use the v4l-dvb tree and mythtv's trunk (dont remember 
> if I use a patch or not).
> Bye
> Manu
> 

For the TT 1600 S2 are no further reports since then.

The only reason not to have one yet is being short of PCI slots (1
special, 1 as usual) and I would have to remove a triple capable card,
but still some PCIe slot is free, with not much getting back. The S2
stuff here is mostly what BBC HD already had last year.

If you fail on that one, I would still take it at the level of
dvbshop.net and pay for all previous and additional shipping.


Cheers,
Hermann




  


