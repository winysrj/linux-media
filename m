Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1LHo0l-0002G7-KB
	for linux-dvb@linuxtv.org; Wed, 31 Dec 2008 00:28:35 +0100
Message-ID: <495AAE96.5060207@iki.fi>
Date: Wed, 31 Dec 2008 01:28:22 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Anders Eriksson <aeriksson@fastmail.fm>
References: <200812300909.49996.md001@gmx.de>	<20081230100254.644B0942B31@tippex.mynet.homeunix.org>	<495A849D.30307@iki.fi>
	<20081230223923.B62BE6BC001@tippex.mynet.homeunix.org>
In-Reply-To: <20081230223923.B62BE6BC001@tippex.mynet.homeunix.org>
Cc: Martin Dauskardt <md001@gmx.de>, linux-dvb@linuxtv.org
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
> 
> Hi Antti,
> 
> crope@iki.fi said:
>> Anysee have standard ISO 7816 card reader interface + SoftCAM in the  driver.
>> I did not implemented card reader due to lack of time &  interest. It
>> probably needs own driver module for card reader and there  is no very
>> similar module that can be used of base of the mode. 
> 
> Am I right in understanding that all information required to drive the driver 
> is available? No lack of specs? I was thinking that we mught want to forward
> it to the gregkh. He once put up an offer to write drivers for any hw if specs 
> were provided.

No, there is no specs available. I did current driver by 
reverse-engineering. Reverse-engineering USB-protocol is not usually 
very bad task.

> 
>> However  I did some
>> protocol reverse-engineering and those results can be found from: http://
>> www.otit.fi/~crope/v4l-dvb/anysee_ca_iso7816_protocol.txt Feel free to
>> implement smart card reader module :)
> 
> I'm afaraid that's beyond my skill level. :-(
> 
> 
>> This device is rather common in Finland and Sweden. Also found from
>> Netherlands and Latvia.
> 
> So, there should be some interest in getting it supported. Here in Sweden it's 
> the only DVB-C I've seen available on stores. 

In Finland all DVB-T/C versions are sold (DVB-S/S2 version also exists, 
but not in Finland)
http://hintaseuranta.fi/tuote.aspx/44704
http://hintaseuranta.fi/tuote.aspx/161489
http://hintaseuranta.fi/tuote.aspx/42648

regards
Antti

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
