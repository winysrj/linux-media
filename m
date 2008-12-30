Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <aeriksson@fastmail.fm>) id 1LHnFW-0006Ik-7j
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 23:39:43 +0100
To: Antti Palosaari <crope@iki.fi>
In-reply-to: <495A849D.30307@iki.fi>
References: <200812300909.49996.md001@gmx.de>
	<20081230100254.644B0942B31@tippex.mynet.homeunix.org>
	<495A849D.30307@iki.fi>
Mime-Version: 1.0
Date: Tue, 30 Dec 2008 23:39:23 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20081230223923.B62BE6BC001@tippex.mynet.homeunix.org>
Cc: linux-dvb@linuxtv.org, Martin Dauskardt <md001@gmx.de>
Subject: Re: [linux-dvb] Where to buy Anysee E30C in Europe ("Euroland")?
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



Hi Antti,

crope@iki.fi said:
> Anysee have standard ISO 7816 card reader interface + SoftCAM in the  driver.
> I did not implemented card reader due to lack of time &  interest. It
> probably needs own driver module for card reader and there  is no very
> similar module that can be used of base of the mode. 

Am I right in understanding that all information required to drive the driver 
is available? No lack of specs? I was thinking that we mught want to forward
it to the gregkh. He once put up an offer to write drivers for any hw if specs 
were provided.

> However  I did some
> protocol reverse-engineering and those results can be found from: http://
> www.otit.fi/~crope/v4l-dvb/anysee_ca_iso7816_protocol.txt Feel free to
> implement smart card reader module :)

I'm afaraid that's beyond my skill level. :-(


> This device is rather common in Finland and Sweden. Also found from
> Netherlands and Latvia.

So, there should be some interest in getting it supported. Here in Sweden it's 
the only DVB-C I've seen available on stores. 

/Anders


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
