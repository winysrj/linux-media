Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:42551 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386AbZAQI3m (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 17 Jan 2009 03:29:42 -0500
Date: Sat, 17 Jan 2009 09:29:29 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>, lexW <HondaNSX@gmx.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [linux-dvb] RFC - Flexcop Streaming watchdog (VDSB)
In-Reply-To: <alpine.DEB.2.00.0901170035190.18012@ybpnyubfg.ybpnyqbznva>
Message-ID: <alpine.LRH.1.10.0901170923030.5725@pub4.ifh.de>
References: <alpine.LRH.1.10.0901161548460.28478@pub2.ifh.de> <4970D464.5070509@gmx.de> <alpine.DEB.2.00.0901170035190.18012@ybpnyubfg.ybpnyqbznva>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Barry,
Hi Walter,

On Sat, 17 Jan 2009, BOUWSMA Barry wrote:
>>> For years there has been the Video Data Stream Borken-error with VDR and
>>> Technisat cards: The error occured randomly and unfrequently. A
>
>>> In fact it turned out, that the problem is worse with setups not based
>>> on VDR and the "VDSB-error" could be really easily reproduced (I'm not
>>> sure if this applies to all generations on SkyStar2-card). I'm
>
>> Which generation of cards have this problem? I did not see any VDSB with
>> my two Skystar 2.6D.
>
> Same here -- never experienced this ever in some four-ish years
> with one SkyStar2 of model long forgotten, with that card being
> the primary one used whenever possible...
>
> (in use typically several times per day, sometimes half a day
> uninterrupted, but on a production machine at 2.6.14-ish)

Using VDR or a single application (like kaffeine), you most likely don't 
see the error anymore thanks to the work-around which is already in place. 
It is resetting the streaming interface at the end of a streaming-session, 
ie. when the pid-filter count is going from 1 to 0. This happens all the 
time with VDR (and similar) when it is retuning.

Now when you launch an application which is just requesting a pid and 
another one which is tuning independently, you can fall easily in this 
problem.

I have to say, that the user which showed me the problem was using the 
rev2.8 and due to the lack of time I couldn't check with other versions 
than this card yet.

But I think those kind of problems also exist for older cards.

Patrick.

PS: how to reproduce:

shell 1: $ tzap channel
shell 2: $ dvbtraffic
[lots of output that streaming is working]
shell 1: $ <C-c>
shell 1: $ tzap "channel2_which is on a different frequency"
shell 2: no output of dvbtraffic any longer... (problem)

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
