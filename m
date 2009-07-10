Return-path: <linux-media-owner@vger.kernel.org>
Received: from proxy2.bredband.net ([195.54.101.72]:59572 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZGJIGU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jul 2009 04:06:20 -0400
Received: from iph1.telenor.se (195.54.127.132) by proxy2.bredband.net (7.3.140.3)
        id 49F59CBD0179BB36 for linux-media@vger.kernel.org; Fri, 10 Jul 2009 09:46:00 +0200
Message-ID: <4A56F1B8.9020908@my-home.se>
Date: Fri, 10 Jul 2009 09:46:00 +0200
From: Claes Lindblom <claes.lindblom@my-home.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: claesl@gmail.com
Subject: Re : [linux-dvb] Best stable DVB-S2 cards
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>Am Montag, den 06.07.2009, 21:31 -0400 schrieb Manu:
>> Le 06/07/2009 15:12:00, Claes Lindblom a écrit :
>> > jens.peder.terje...@devoteam.com wrote:
>> > >
>> > > -----sacha wrote: -----
>> > >
>> > > >To: cla...@gmail.com
>> > > >From: sacha <sa...@hemmail.se>
>> > > >Sent by: linux-dvb-boun...@linuxtv.org
>> > > >Date: 22-06-2009 21:21
>> > > >cc: linux-...@linuxtv.org
>> > > >Subject: [linux-dvb] Best stable DVB-S2 cards
>> > > >
>> > > >Claes
>> > > >Forget all that has with stability to do on Linux, it will never
>> > > >work!
>> > > >It is my experience after three years of desperate trying. I have
>> > the
>> > > >same card and some others. Sometimes they works sometimes no. 24
>> > > >hours
>> > > >running is called High Availability in IT world and can be assured
>> > > >only
>> > > >by the commercial solutions. Believe me, I spent 14 years in
>> > > >commercial
>> > > >Unix and know what I am talking about.
>> > > >
>> > > >KR
>> > > >
>> > > >>Hi,
>> > > >>I currently have a Azurewave AD-SP400 CI (Twinhan VP-1041)  DVB-
>> > S2
>> > > >>card
>> > > >>but I'm not sure if it
>> > > >>that stable to have it running 24h every day on a server.
>> > > >>I'm looking for a good DVB-S2 card that works out of the box in
>> > > >Linux
>> > > >>kernel, does anyone have any good
>> > > >>recommendations, both with or without CI. It's important that it
>> > is
>> > > >>stable so I don't have to restart the server.
>> > > >>I'm running Ubuntu Server 9.04 64-bit with kernel
>> > 2.6.28-11-server.
>> > > >
>> > > ></Claes
>> > > >
>> > >
>> > > I have three Hauppauge HVR-4000. Two that have been used for DVB-S
>> > for
>> > > about one year and one for DVB-S2 for about half a year without any
>> > > stability issues.
>> > > In the beginning it was a little fiddly with patching v4l-dvb, but
>> > > support for this card was included in v4l-dvb last autumn and in
>> > the
>> > > 2.6.28 kernel in November or December last year.
>> > >
>> > Thats sounds really good, does it work well with DVB-S2 and Mythtv?
>> > By the way to use them in the same computer?
>> >
>> > What's the status of Technotrend TT 1600 and 3200 in the main
>> > dvb-tree?
>> > And how about the issues noted in this thread
>> > http://linuxtv.org/pipermail/linux-dvb/2009-February/031779.html ?
>>
>> Here TT 3200 works great (using CI) for DVB-S pnmy. I cant tell for S2
>> as there is no transponder (apart for one but which has a way too high
>> symbol rate). I use the v4l-dvb tree and mythtv's trunk (dont remember
>> if I use a patch or not).
>> Bye
>> Manu
>>
>
>For the TT 1600 S2 are no further reports since then.
>
>The only reason not to have one yet is being short of PCI slots (1
>special, 1 as usual) and I would have to remove a triple capable card,
>but still some PCIe slot is free, with not much getting back. The S2
>stuff here is mostly what BBC HD already had last year.
>
>If you fail on that one, I would still take it at the level of
>dvbshop.net and pay for all previous and additional shipping.
>

It sounds like a possible card to try. I was also starting to look at
the TeVii S470 PCIe card but it's the same here at the linuxtv wiki
that there are no comments, only that it is supported.
At http://www.tevii.com/product_s470.html you can read that they have
Linux support but the download drivers are multiproto.
Is anyone using this card?

Right now I'm looking for a good card for DVB-S2 that I can replace my
VP 1041 card that's not so stable anymore with recent kernel
and S2API for mantis.

Regards
Claes
