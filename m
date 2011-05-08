Return-path: <mchehab@gaivota>
Received: from ffm.saftware.de ([83.141.3.46]:49495 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1EHJxw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 05:53:52 -0400
Message-ID: <4DC6682C.4060907@linuxtv.org>
Date: Sun, 08 May 2011 11:53:48 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: Issa Gorissen <flop.m@usa.net>
CC: Martin Vidovic <xtronom@gmail.com>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <494PeFsCj8960S01.1304706575@web01.cms.usa.net>
In-Reply-To: <494PeFsCj8960S01.1304706575@web01.cms.usa.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello Issa,

On 05/06/2011 08:29 PM, Issa Gorissen wrote:
> From: Andreas Oberritter <obi@linuxtv.org>
>> On 05/06/2011 03:47 PM, Issa Gorissen wrote:
>>> Also, it seems linux en50221 stack provides for the slot selection. So,
> why
>>> would you need two ca nodes ?
>>
>> Because it's the most obvious way to use it. And more importantly
>> because the API sucks, if you have more than one device per node. You
>> can have only one reader, one writer, one poll function per node. For
>> example, you can't use one instance of mplayer to watch one channel with
>> fe0+dmx0+ca0 and a second instance of mplayer to watch or record another
>> channel with fe1+dmx1+ca0. You won't know which device has an event if
>> you use poll. The API even allows mixing multiple CI slots and built-in
>> descramblers in the same node. But try calling CA_RESET on a specific
>> slot or on a descrambler. It won't work. It's broken by design.
> 
> 
> You need to write a userspace soft which will handle the concurrent access of
> your ca device...

... to gain what exactly over using two distinct nodes?

How do you propose solving the problem with CA_RESET with a userspace soft?

> But for your given example, is there any card allowing you to do that (one ci
> slot, two tuners) ?

You don't seem to have understood my example. I was explaining some
drawbacks of having more than one CI slot, but only one node, answering
your prior question.

Besides that, it's highly probable that such a card exists. It wouldn't
make much sense to hardwire CI slots to tuners, if multiple tuners exist
on a board.

Disregarding the term "cards", there are variants of the Dreambox with
1, 2 or 4 CI slots combined with 1 to 4 tuners.

Regards,
Andreas
