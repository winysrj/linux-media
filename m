Return-path: <linux-media-owner@vger.kernel.org>
Received: from utm.netup.ru ([193.203.36.250]:46330 "EHLO utm.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147Ab0AaUvh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 15:51:37 -0500
Subject: Re: CAM appears to introduce packet loss
From: Abylai Ospan <aospan@netup.ru>
To: Marc Schmitt <marc.schmitt@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <b36f333c1001310943t3f655b03w2fe75a63b3e952a7@mail.gmail.com>
References: <b36f333c1001310412r40cb425cp7a5a0d282c6a716a@mail.gmail.com>
	 <1264941827.28401.3.camel@alkaloid.netup.ru>
	 <b36f333c1001310707w3397a5a6i758031262d8591a7@mail.gmail.com>
	 <b36f333c1001310723p561d7a69x955b2d4a6d9b4e1@mail.gmail.com>
	 <1264951975.28401.8.camel@alkaloid.netup.ru>
	 <b36f333c1001310825n6ae6e5dbg45a0cf135d2e89e@mail.gmail.com>
	 <1264955483.28401.32.camel@alkaloid.netup.ru>
	 <b36f333c1001310943t3f655b03w2fe75a63b3e952a7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 23:49:58 +0300
Message-ID: <1264970998.28401.54.camel@alkaloid.netup.ru>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > You can:
> > 1. Try to contact with CAM vendor and check maximum bitrate which can be
> > passed throught this CAM
> I tried that CAM in a TV with DVB-C support. The image was perfect so
> I suspect that the CAM itself can handle it unless the TV did HW PID
> filtering before sending the stream to the CAM, as you point out
> below... Is that to be expected?
Depends on TV vendor. But it's not impossible.

> > 2. Try to find reception card with hardware PID filtering and pass only
> > interesting PID's throught CAM. Bitrate should be equal to bitrate of
> > one channel - aprox. 4-5 mbit/sec ( not 40 mbit/sec).
> Do you have a recommendation for such a card?
try to search on linuxtv wiki.

> Would it be possible to do the filtering in software somehow?
usually TS going from demod to CI directly without any programmable IC
between. in this case you can't do PID filtering nor SW nor HW.

> > 3.may be some fixes can be made on TS output from demod. Demod's usually
> > has tunable TS output timings/forms. You should check TS clock by
> > oscilloscope and then try to change TS timings/forms in demod.
> 
> Unfortunately, I don't have the necessary equipment/knowledge to do this. :(
> I'd assume the DVB provider could give me the TS clock? But then I'm
> at bit at a loss with "change TS timings/forms in demod". What exactly
> are you referring to by "demod".
"demod" is IC doing demodulation of signal and producing Transport
Stream. In your card seems "Philips TDA10021" is used as DVB-C
demodulator.

-- 
Abylai Ospan <aospan@netup.ru>
NetUP Inc.

