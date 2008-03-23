Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1JdG3O-0004R6-Ou
	for linux-dvb@linuxtv.org; Sun, 23 Mar 2008 03:35:27 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Andrea Giuliano <sarkiaponius@alice.it>
In-Reply-To: <47E56272.8050307@alice.it>
References: <47E56272.8050307@alice.it>
Date: Sun, 23 Mar 2008 03:27:06 +0100
Message-Id: <1206239226.5501.37.camel@pc08.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help needed...
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Andrea,

Am Samstag, den 22.03.2008, 20:48 +0100 schrieb Andrea Giuliano:
> Hi,
> 
> I can szap many free channels from Hotbird 13E, but none on some
> frequencies. For example, if the "test" file just contains the line:
> 
>     S 11766000 V 27500000 2/3
> 
> that I took from http://www.lyngsat.com/hotbird.html as many other which
> instead work percectly, the command:
> 
>     scan test > channels.conf
> 
> alway gives the following output:
> 
> scanning prova
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 11766000 V 27500000 2
>   >>> tune to: 11766:v:0:27500
> WARNING: >>> tuning failed!!!
>   >>> tune to: 11766:v:0:27500 (tuning failed)
> WARNING: >>> tuning failed!!!
> ERROR: initial tuning failed
> dumping lists (0 services)
> Done.
> 
> On the other hand, if I put manually some lines in channels.conf for
> such a frequency, I can zap to those channels, but in most cases I watch
> a different channel, not the one I expected to see.
> 
> This doesn't happen on other frequencies.
> 
> May be of some help the fact that I'm writing from Italy, and I cannot
> get channels from the scan for the most important italian channels: in
> particular, none of RAI network, nor Mediaset network, the biggest
> network in Italy.
> 
> Also, the signal became rather good after I bought an amplifier.
> Actually, I can see and record perfectly fine many channels. I don't
> think I have signal strength problems.
> 
> Any hint will be very much appreciated.
> 
> Best regards.
> 

likely you better become a bit more specific on what
card/tuner/channel-decoder you are, that other people might be able to
confirm or deny, given the flood of new hardware around.

According to the current "tda10086 fails?" thread, I should be on some
tuner for now, a tda8263, with just a minimal start up configuration.

On that Hotbird 13.0E crowd is nothing with high symbol rates so far, to
the few encrypted S2 transponders I have no access and they are out of
any interest for me.

However, your S 11766000 V 27500000 2/3 RAI stuff works without any
problems here. The Mediaset 11919 V is OK too, except ITALIA 1 (at the
moment) and the 11432 V is one of the few that fail for me too.

Without using anything more sophisticated for now, that sat stuff is a
moving target it seems. Not only all that always ongoing shuffling
around, also weather conditions, some even seem to stop broadcast from
time to time at all and others are sometimes encrypted and sometimes not
and so on.

So, interestingly, even on such a driver on bare bones for now, not only
driver optimization, but simple scan file update can do a lot, brought
394 new TV and radio services for now.

The road is much better paved as claimed, will have some beer now ;)

Cheers,
Hermann









_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
