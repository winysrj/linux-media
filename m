Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f211.google.com ([209.85.220.211]:36434 "EHLO
	mail-fx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab0BGTNo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Feb 2010 14:13:44 -0500
Received: by fxm3 with SMTP id 3so6624914fxm.39
        for <linux-media@vger.kernel.org>; Sun, 07 Feb 2010 11:13:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1265568384.7704.24.camel@brian.bconsult.de>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265411523.4064.23.camel@localhost>
	 <1265413149.2063.20.camel@brian.bconsult.de>
	 <1265415910.2558.17.camel@localhost>
	 <1265446554.1733.36.camel@brian.bconsult.de>
	 <1265515083.2666.139.camel@localhost>
	 <1265553812.3063.22.camel@palomino.walls.org>
	 <1265556597.2424.26.camel@brian.bconsult.de>
	 <846899811002071010w4e0e7b7frd423e6574b26e3f0@mail.gmail.com>
	 <1265568384.7704.24.camel@brian.bconsult.de>
Date: Sun, 7 Feb 2010 20:13:42 +0100
Message-ID: <846899811002071113y7424479fsf5f5ea0b837e40e2@mail.gmail.com>
Subject: Re: "However, if you don't want to lose your freedom, you had better
	not follow him." (Re: Videotext application crashes the kernel due to
	DVB-demux patch)
From: HoP <jpetrous@gmail.com>
To: Chicken Shack <chicken.shack@gmx.de>
Cc: Andy Walls <awalls@radix.net>,
	Francesco Lavra <francescolavra@interfree.it>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Andreas Oberritter <obi@linuxtv.org>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chicken

2010/2/7 Chicken Shack <chicken.shack@gmx.de>:
> Am Sonntag, den 07.02.2010, 19:10 +0100 schrieb HoP:
>> Hi Chicken,
>>
>> >
>> > However I am still alone with the other problem I always stressed:
>> >
>> > When using alevt-dvb (I attached my overworked version 1.7.0 in earlier
>> > mails - please do have a look at it!) the application hangs when you
>> > decide to switch to a channel that is part of a new transponder.
>> > The program hangs then. That means the way alevt-dvb is dealing with the
>> > PMT (program map table) is highly incomplete.
>> > It needs a reset function to read the new PMT when the transponder is
>> > being changed...
>> >
>>
>> If you tell me which application is managing channel zaping function
>> then we can try to find way how to signal that to alevt-dvb.
>
> Hi Hello Honza,
>
> well, every application being capable of playing back DVB-TV with
> in-built receiver engine could manage that.
>
> Just the examples that I know:
>
> 1. mplayer (receiver engine is good old dvbstream from D. Chapman)
> 2. xine-ui (receiver engine is libxine)
> 3. kaffeine (dito 2.)
> 4. mythtv (don't know which)
> 5. xawtv (proprietary receiver engine)
>
>

Oki, seems you not understood me fully. I ment exactly your configuration.
I need to know:

1, which application is tuning to transponder in your case.
2, is there only one alevt-dvb instance running? Typically, there is the only
one, but, of course I can imagine you do some postprocessing of ALL
teletext services on current transponder.

>> > I do not know how to program that simple reset function. But I know that
>> > this is the definite key to resolve the issue.
>> > PMT reading, PMT opening, PMT parsing.......
>> > Everything is already inside of the source code of alevt-dvb.
>> >
>>
>> In case, if more then one DVB application is running, one is something
>> like "master" (which do frontend operation, ie. channel change)
>> and rest are slaves. So master has to signal channel/transponder change
>> to the all slaves. Typically, it is done by some custom specific way.
>> For example master can open some well-known unix socket
>> where all slaves are connecting and where, in case of channel change,
>> is sent (by master) some info about such event.
>
> Yes, exactly that's the way it is! Right!
>
> But however the "master" application is doing this tuning job, it's not
> our problem issue right here.
> Our problem issue right here is how to make the "slave" application
> comprehend what the "master" application just managed to do.
>
> When I was doing the code cleanup of the complete Flexcop driver series
> Patrick Boettcher taught me what a software watchdog is and how it
> works. The Conexant frontend / demodulator chip does not work together
> with the Flexcop main chip without a software watchdog performing
> reinitialization every 400 milliseconds. That came into my mind a couple
> of minutes ago.
>

Well, we should stay outside kernel layer. Best solution should be
to manage signalling (of transponder change and futher information)
inside userland level. And this is why I was asking who is the master
(who is doing channel change)

> So how about giving alevt-dvb a software watchdog function that just
> looks up lets say every 2 seconds whether the PMT has changed or not,
> performing a reinitialisation of the PMT treatment built inside, i. e.
> doing something like a restart of alevt-dvb?
>

To find how to catch that "PMT has changed" we have to know
who is doing such PMT change operation.

> Would that be a pratical solution?
> Or what would be your personal proposal, Honza?
>
> Cheers
>
> CS
>
> P. S.: The decisive case the program must learn to deal with is NOT a
> simple channel change, as you express it above, Honza.
> The proggy can already run multiple instances in parallel console
> sessions if the transponder is one and the same......
>
> The decisive case the program must learn to deal with is a combination
> of channel change PLUS transponder change, which makes it necessary to
> read, work over and parse a complete new PMT (program map table) causing
> the UI to at least starting the main program of the new transponder
> (which is ZDF f. ex. if the transponder is ZDFVision.
> Everything clear so far? Questions?
>

Still the only one question - how it works for you now? How do you
zap to channel right now? I expect you have some favourite application.

Cheers

/Honza
