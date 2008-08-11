Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KSfFw-0002Bw-17
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 23:48:49 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <48A08201.6070505@iki.fi>
References: <48A08201.6070505@iki.fi>
Date: Mon, 11 Aug 2008 23:41:27 +0200
Message-Id: <1218490887.2676.73.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-C / DVB-T combo device multi mode driver
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

Am Montag, den 11.08.2008, 21:16 +0300 schrieb Antti Palosaari:
> hello
> I have a brand new Anysee E30 Combo Plus device. Device does have 
> ZL10353 DVB-T demodulator and TDA10023 DVB-C demodulator sharing one 
> Samsung tuner module. How I can handle this king of hardware? I see some 
>   possibilities;
> 1) add module param for mode select
> 2) make driver register two adapters
> 3) use multiproto
> 
> I have already done first choice and it is working, but it is not very 
> user friendly. I tried second one but didn't found way to lock tuner. 
> Multiproto sounds like good decision but it is not ready yet. So what to 
> do? Implement as 1) and wait for 3). Implementation of 2) is not 
> possible without hacking current dvb-usb-framework?
> 
> Any ideas?
> 
> regards
> Antti

to keep it as simple as possible seems to me currently the best.

This way it should be less work to make it flow later with multiproto or
any other suitable for all solution coming in, instead everybody now
starts working on his own solution to make it more user friendly.

We have some dual frontend cards on the saa7134 driver and it is fairly
easy to deal with them.

Even the Medion Quad CTX944 with two saa7131e, two tda8275ac1 hybrid
DVB-T and analog TV tuners, two tda10046a for DVB-T and on the DVB-S
side two tda8263 and two tda10086 is fairly easy to handle.

The shared dual isl6405 LNB supply has some issues with the second DVB-S
frontend voltage settings, but this is the same on the m$ drivers and
out of range for these questions currently.

My two cents.

Cheers,
Hermann








_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
