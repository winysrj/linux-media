Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@ickes-home.de>) id 1KLNW9-0002qa-7B
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 21:27:25 +0200
From: tom <thomas@ickes-home.de>
To: Antti Palosaari <crope@iki.fi>
In-Reply-To: <48863349.3090507@iki.fi>
References: <0MKxQS-1KLM2V1c9L-0001hx@mrelayeu.kundenserver.de>
	<1216750591.6624.3.camel@super-klappi>  <48862536.9070906@iki.fi>
	<1216752077.6686.4.camel@super-klappi>  <48862B02.1030304@iki.fi>
	<1216754067.6686.7.camel@super-klappi>  <48863349.3090507@iki.fi>
Date: Tue, 22 Jul 2008 21:26:18 +0200
Message-Id: <1216754778.6686.9.camel@super-klappi>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WG:  Problems with MSI Digivox	Duo	DVB-T	USB,
	Ubuntu 8.04
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

ah, ok. can I found to firmware on linuxtv?

Am Dienstag, den 22.07.2008, 22:21 +0300 schrieb Antti Palosaari:
> tom wrote:
> > have attached a message file, hope this helps. let me know if more is
> > required.
> 
> yes, it hangs when tuner is accessed. I have still no idea why. Could 
> you try newer firmware? Latest firmware is 4.95.0 and you are using very 
> old one 4.65.0.
> 
> 
> > 
> > Am Dienstag, den 22.07.2008, 21:46 +0300 schrieb Antti Palosaari:
> >> tom wrote:
> >>> .FE_READ_STATUS: Remote I/O error
> >>>
> >>> Transponders: 1/63
> >>>
> >>> Invalid section length or timeout: pid=17
> >>>
> >>> Frontend closed
> >>>
> >>> Any further ideas or informations which I can provide?
> >> Looks like it almost immediately hangs when tuning is tried.
> >> Could report what it prints to the debug (/var/log/debug probably).
> >>
> >> Antti
> 
> 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
