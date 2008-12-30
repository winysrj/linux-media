Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1LHlDS-00048j-9Q
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 21:29:27 +0100
Message-ID: <495A849D.30307@iki.fi>
Date: Tue, 30 Dec 2008 22:29:17 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>, Martin Dauskardt <md001@gmx.de>
References: <200812300909.49996.md001@gmx.de>
	<20081230100254.644B0942B31@tippex.mynet.homeunix.org>
In-Reply-To: <20081230100254.644B0942B31@tippex.mynet.homeunix.org>
Cc: linux-dvb@linuxtv.org
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

Anders Eriksson wrote:
> Got one in sweden (Elgiganten, 1000 SEK iirc), but the card reader (CA/CI
> thing) turned out to be unsupported. Reading the kernel sources for the driver,
> i found a comment indicating that the CA/CI reader was not (yet) supported.

Anysee have standard ISO 7816 card reader interface + SoftCAM in the 
driver. I did not implemented card reader due to lack of time & 
interest. It probably needs own driver module for card reader and there 
is no very similar module that can be used of base of the mode. However 
I did some protocol reverse-engineering and those results can be found from:
http://www.otit.fi/~crope/v4l-dvb/anysee_ca_iso7816_protocol.txt
Feel free to implement smart card reader module :)

> Luckily, Elgiganten had a free 30 day return policy, so I returned mine.

This device is rather common in Finland and Sweden. Also found from 
Netherlands and Latvia.

regards
Antti

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
