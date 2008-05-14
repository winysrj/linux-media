Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.tue.nl ([131.155.3.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1JwD4j-0002dT-D7
	for linux-dvb@linuxtv.org; Wed, 14 May 2008 11:15:08 +0200
Message-ID: <482AAD8A.80309@kompasmedia.nl>
Date: Wed, 14 May 2008 11:14:50 +0200
From: "Bas v.d. Wiel" <bas@kompasmedia.nl>
MIME-Version: 1.0
To: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
References: <48295A62.50708@kompasmedia.nl> <4829FA37.8030007@freenet.de>
In-Reply-To: <4829FA37.8030007@freenet.de>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechnoTrend 2300 DVB-C, does it work?
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

Hi Ruediger,
The AD-CP300 is exactly the card I own right now. I haven't been able to 
tune this card to a single channel yet, using whatever version of the 
Mantis driver, even though the card functions perfectly using Windows so 
the hardware is OK. My assumption is that a working Mantis card should 
be able to at least detect the channels, even if it's unable to decrypt 
them. I'm using the right frequencies, symbol rates and QAM-settings for 
tuning. They come straight from the working Windows side of the system, 
but nothing is found at all. I only receive a long stream of tuning 
failures using scan. I have time to wait for the Mantis driver to 
mature. On the Windows side of things MediaPortal is more or less ok. I 
just very much prefer to use Linux for my HTPC (or any of my systems for 
that matter).

But, if I understand you correctly, the TT2300 allows you to watch 
encrypted DVB-C under Linux, right?

Bas

Ruediger Dohmhardt wrote:
> Bas v.d. Wiel schrieb:
>> Hello list,
>> Because of my troubles with a TwinHan Mantis 2033 based board, I'm   
> Bas, I'm waiting for the working CI Interface on the AD-CP300 (2033) 
> card as well and I hope
> the CI/CAM is going to work by summer.
> Besides can't watching encrypted channels the card has worked 
> perfectly over the last 11/2 year.
> I use it with "vdr-1.60" and "xineliboutput".
> <http://www.twinhan.com/product_cable_2033.asp>
>> looking to buy something else that actually does work. I was advised 
>> that a Technotrend 2300 DVB-C + CI-module will work with Linux. 
>> This'll be the second time I'll be spending over 150 euro's on video 
>> hardware so I'd like to be sure: does this combination work with 
>> Linux, and MythTV in particular, to view encrypted channels?
>>   
> The TT-2300 (and the identical card from Hauppauge) are the cards I 
> have used over the last 5 years.
> I still use it for watching encrypted channels (i.e. when the Twinhan 
> card is useless).
>
> CAM:           Alphacrypt-light
> Smartcard:  Card from "Kabel Deutschland".
> Software:     vdr-1.4.7 with tvtime; I have no idea concerning MythTv.
>
> Ciao Ruediger D.
>
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
