Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1JoGLv-0002ID-Ox
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 13:08:00 +0200
From: Sigmund Augdal <sigmund@snap.tv>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	e9hack <e9hack@googlemail.com>
In-Reply-To: <4807C1A6.8000909@t-online.de>
References: <1160.81.96.162.238.1208023139.squirrel@webmail.elfarto.com>
	<200804130349.15215@orion.escape-edv.de>	<4801DED3.4020804@elfarto.com>
	<4803C2FA.1010408@hot.ee> <48065CB6.50709@elfarto.com>
	<1208422406.12385.295.camel@rommel.snap.tv>
	<34260.217.8.27.117.1208427888.squirrel@webmail.elfarto.com>
	<4807AFE2.40400@t-online.de> <4807B386.1050109@elfarto.com>
	<4807C1A6.8000909@t-online.de>
Date: Tue, 22 Apr 2008 13:07:48 +0200
Message-Id: <1208862469.7807.7.camel@rommel.snap.tv>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

tor, 17.04.2008 kl. 23.31 +0200, skrev Hartmut Hackmann:
<snip>
> Do you have a datasheet of the tda10023? From the first glance, i have the
> impression that it was only used with a conventional tuner yet. With the
> silicon tuner, the chip needs to be programmed to use a different IF. We
> beed to find out how this is done.
I don't have any datasheet. I tried playing around with some of the
values in the init-tab, and they do affect the signal levels (signal and
snr) reported, but I haven't managed to find something that does give a
lock. There is also a if_freq variable in the current driver sources
that does not seem to be passed to the chip directly but is used in some
computations. In the current driver this value is selected based on
channel bandwidth (being only used for dvb-t this far). I've tried with
several values for this (8MHz, 0MHz, 4MHz and the currently used 5MHz
for 8MHz bandwidth channels).

Birr: Do you have any info on this, as you seem to be the last developer
working on that demod?

Best regards

Sigmund Augdal
> 
> Best regards
>    Hartmut
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
