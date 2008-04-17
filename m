Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1JmPs5-00010b-9R
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 10:53:35 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb@linuxtv.org
In-Reply-To: <48065CB6.50709@elfarto.com>
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
	<200804130349.15215@orion.escape-edv.de>	<4801DED3.4020804@elfarto.com>
	<4803C2FA.1010408@hot.ee>  <48065CB6.50709@elfarto.com>
Date: Thu, 17 Apr 2008 10:53:26 +0200
Message-Id: <1208422406.12385.295.camel@rommel.snap.tv>
Mime-Version: 1.0
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Arthur Konovalov <kasjas@hot.ee>
Subject: Re: [linux-dvb] TT-Budget C-1501
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

Hi,

I have also added support for this card based on the little change you
showed here and some looking around in other drivers. I have gotten
information from technotrend that the proper i2c address for the tuner
is 0x61 (or 0xc2 as these adresses sometimes appear shifted for some
reason). With this address and the tuner driver loaded in debug mode I
seem to get some more response from the tuner, but still no lock. 

Now looking at the tda827x.c sources it seems this driver was
specifically written for dvb-t usage, and I'm uncertain wether it would
work out of the box for dvb-c. There are also some parts of the code I
don't understand, for instance the agcf callback. Harmut, do you know
anything more about this? The AGC2 gain value that is printed in debug
usually show 4 or 5 now, does this indicate a good signal or a bad
signal?

Also there is still the occational i2c timeouts that Stephen reported.
I'm not sure wether they are caused by the tuner or the demod, but they
appear to come so seldom that it should be able to complete a tuning
cycle. Any feedback on this would be welcome as well. Maybe Oliver has
some suggestions how to debug this?

Best regards

Sigmund Augdal

ons, 16.04.2008 kl. 21.08 +0100, skrev Stephen Dawkins:
> Arthur Konovalov wrote:
> > Stephen Dawkins wrote:
> > 
> >>>>I'm not entirely sure what I need todo next to get it working, any help
> >>>>will be greatly appreciated.
> >>>
> >>>See m920x.c or saa7134-dvb.c for drivers using tda10046 and/or tda827x.
> >>>
> >>
> >>I will take a look at them.
> >>
> > 
> > Hi,
> > do You have progress in that direction?
> > I'll very concerned, because I have this card too.
> > 
> > Arthur
> > 
> 
> Not yet I'm afraid.
> 
> Regards
> Stephen
> 
> > 
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> > 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
