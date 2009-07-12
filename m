Return-path: <linux-media-owner@vger.kernel.org>
Received: from paperboy.networkhell.de ([78.46.237.218]:39565 "EHLO
	paperboy.networkhell.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbZGLLEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 07:04:37 -0400
Message-ID: <4A59C33C.40701@networkhell.de>
Date: Sun, 12 Jul 2009 13:04:28 +0200
From: =?ISO-8859-1?Q?Matthias_M=FCller?= <keef@networkhell.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] problems with Terratec Cinergy 1200 DVB-C MK3 after
 mainboard switch
References: <4A58893E.4060508@networkhell.de>	<1247317322.3149.8.camel@palomino.walls.org> <4A58986E.1000405@networkhell.de>
In-Reply-To: <4A58986E.1000405@networkhell.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Matthias Müller schrieb:
> Ok, I cleaned the cards one more and atm there's only 1 card in the 
> system. Blew out all dust (the motherboard arrived brand new yesterday, 
> so probably not necessary), still the same probs. After heavy IO the 
> card dies.
> I plugged one of the cards back in the old motherboard and installed a 
> backup vdr, no probs at all with that card. Everything else on the new 
> mainboard works like a charm, so I doubt the board is broken.
>
> Still looking for any other hints,
>   
After testing it with a dvb-c ff card and having the same probs, I 
tracked it down further and it's triggered by fast switching of the cpu 
frequency. After disabling the ondemand governor everything works as 
expected.
So linux-media/linux-dvb are definitely the wrong lists for that kind of 
prob.

Thanks,
Matthias
