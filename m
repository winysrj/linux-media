Return-path: <mchehab@pedra>
Received: from ffm.saftware.de ([83.141.3.46]:56489 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab1EFQIH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 12:08:07 -0400
Message-ID: <4DC41CDF.8040001@linuxtv.org>
Date: Fri, 06 May 2011 18:07:59 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: Martin Vidovic <xtronom@gmail.com>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <724PeFNU87648S03.1304689679@web03.cms.usa.net>
In-Reply-To: <724PeFNU87648S03.1304689679@web03.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 05/06/2011 03:47 PM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>>> The best would be to create independent adapters for each independent CA
>>> device (ca0/caio0 pair) - they are independent after all (physically and
>>> in the way they're used).
>>
>> Physically, it's a general purpose TS I/O interface of the nGene
>> chipset. It just happens to be connected to a CI slot. On another board,
>> it might be connected to a modulator or just to some kind of socket.
>>
>> If the next version gets a connector for two switchable CI modules, then
>> the physical independence is gone. You'd have two ca nodes but only one
>> caio node. Or two caio nodes, that can't be used concurrently.
>>
>> Maybe the next version gets the ability to directly connect the TS input
>> from the frontend to the TS output to the CI slot to save copying around
>> the data, by using some kind of pin mux. Not physically independent either.
>>
>> It just looks physically independent in the one configuration
>> implemented now.
> 
> 
> When I read the cxd2099ar datasheet, I can see that in dual slot
> configuration, there is still one communication channel for the TS and one for
> the control.

It doesn't matter how the cxd2099ar works, because I'm talking about the
nGene chipset in place of any chipset having at least two TS inputs and
one TS output.

Btw., I don't think the cxd2099 driver has any obvious problems. It's
the nGene driver that registers the sec/caio interface.

> Also, it seems linux en50221 stack provides for the slot selection. So, why
> would you need two ca nodes ?

Because it's the most obvious way to use it. And more importantly
because the API sucks, if you have more than one device per node. You
can have only one reader, one writer, one poll function per node. For
example, you can't use one instance of mplayer to watch one channel with
fe0+dmx0+ca0 and a second instance of mplayer to watch or record another
channel with fe1+dmx1+ca0. You won't know which device has an event if
you use poll. The API even allows mixing multiple CI slots and built-in
descramblers in the same node. But try calling CA_RESET on a specific
slot or on a descrambler. It won't work. It's broken by design.

Do you know any implementation that has more than one CI slot per ca
device and that really is in use?

Regards,
Andreas
