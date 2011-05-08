Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:37571 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027Ab1EHKat (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 May 2011 06:30:49 -0400
Message-ID: <4DC670AE.2070607@usa.net>
Date: Sun, 08 May 2011 12:30:06 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: Andreas Oberritter <obi@linuxtv.org>
CC: Martin Vidovic <xtronom@gmail.com>,
	Ralph Metzler <rjkm@metzlerbros.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Ngene cam device name
References: <494PeFsCj8960S01.1304706575@web01.cms.usa.net> <4DC6682C.4060907@linuxtv.org>
In-Reply-To: <4DC6682C.4060907@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 08/05/11 11:53, Andreas Oberritter wrote:
> Hello Issa,
>
> On 05/06/2011 08:29 PM, Issa Gorissen wrote:
>> From: Andreas Oberritter <obi@linuxtv.org>
>>> On 05/06/2011 03:47 PM, Issa Gorissen wrote:
>>>> Also, it seems linux en50221 stack provides for the slot selection. So,
>> why
>>>> would you need two ca nodes ?
>>> Because it's the most obvious way to use it. And more importantly
>>> because the API sucks, if you have more than one device per node. You
>>> can have only one reader, one writer, one poll function per node. For
>>> example, you can't use one instance of mplayer to watch one channel with
>>> fe0+dmx0+ca0 and a second instance of mplayer to watch or record another
>>> channel with fe1+dmx1+ca0. You won't know which device has an event if
>>> you use poll. The API even allows mixing multiple CI slots and built-in
>>> descramblers in the same node. But try calling CA_RESET on a specific
>>> slot or on a descrambler. It won't work. It's broken by design.
>>
>> You need to write a userspace soft which will handle the concurrent access of
>> your ca device...
> ... to gain what exactly over using two distinct nodes?
>
> How do you propose solving the problem with CA_RESET with a userspace soft?

Well, solving your problem of having two mplayer instances!

The CA_RESET ioctl will not reset one slot at a time obviously. But you
can do an interface reset via the control register, no ? In cases when
you remove/add a second/third/... module from one of the slot of a CI
device, then I guess the CA_RESET is broken because it will reset
everything... Have you got patches for that ?


>> But for your given example, is there any card allowing you to do that (one ci
>> slot, two tuners) ?
> You don't seem to have understood my example. I was explaining some
> drawbacks of having more than one CI slot, but only one node, answering
> your prior question.
>
> Besides that, it's highly probable that such a card exists. It wouldn't
> make much sense to hardwire CI slots to tuners, if multiple tuners exist
> on a board.
>
> Disregarding the term "cards", there are variants of the Dreambox with
> 1, 2 or 4 CI slots combined with 1 to 4 tuners.
>
> Regards,
> Andreas


I guess your point is valid, maybe the improvement you would like to see
will pop up when the need will be created...
