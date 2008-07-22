Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KLMsZ-00081E-Tp
	for linux-dvb@linuxtv.org; Tue, 22 Jul 2008 20:46:32 +0200
Message-ID: <48862B02.1030304@iki.fi>
Date: Tue, 22 Jul 2008 21:46:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: tom <thomas@ickes-home.de>
References: <0MKxQS-1KLM2V1c9L-0001hx@mrelayeu.kundenserver.de>	<1216750591.6624.3.camel@super-klappi>
	<48862536.9070906@iki.fi> <1216752077.6686.4.camel@super-klappi>
In-Reply-To: <1216752077.6686.4.camel@super-klappi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WG:  Problems with MSI Digivox Duo DVB-T	USB,
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

tom wrote:
> .FE_READ_STATUS: Remote I/O error
> 
> Transponders: 1/63
> 
> Invalid section length or timeout: pid=17
> 
> Frontend closed
> 
> Any further ideas or informations which I can provide?

Looks like it almost immediately hangs when tuning is tried.
Could report what it prints to the debug (/var/log/debug probably).

Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
