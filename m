Return-path: <linux-media-owner@vger.kernel.org>
Received: from paperboy.networkhell.de ([78.46.237.218]:35900 "EHLO
	paperboy.networkhell.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZGKNtk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jul 2009 09:49:40 -0400
Message-ID: <4A58986E.1000405@networkhell.de>
Date: Sat, 11 Jul 2009 15:49:34 +0200
From: =?UTF-8?B?TWF0dGhpYXMgTcO8bGxlcg==?= <keef@networkhell.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] problems with Terratec Cinergy 1200 DVB-C MK3 after
 mainboard switch
References: <4A58893E.4060508@networkhell.de> <1247317322.3149.8.camel@palomino.walls.org>
In-Reply-To: <1247317322.3149.8.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

> You appear to be experiencing PCI bus errors.  Read errors on the PCI
> bus return 0xffffffff and it looks like that's happening on your system:
>
> 	(rev ff) (prog-if ff)
>
> PCI bus error are usually caused by the PCI bridge chips on your
> motherboard being overwhelmed or by bus signals of marginal quality or,
> of course, by actually defective hardware.
>
> As something simple and easy to try, I would suggest:
>
> 1. Remove *all* your PCI cards
> 2. Blow the dust out of *all* the slots.
> 3. Reseat the cards.
>
> That will hopefully improve the signal quality on the bus.
>
>   
Ok, I cleaned the cards one more and atm there's only 1 card in the 
system. Blew out all dust (the motherboard arrived brand new yesterday, 
so probably not necessary), still the same probs. After heavy IO the 
card dies.
I plugged one of the cards back in the old motherboard and installed a 
backup vdr, no probs at all with that card. Everything else on the new 
mainboard works like a charm, so I doubt the board is broken.

Still looking for any other hints,

Matthias

