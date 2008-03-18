Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aa011msr.fastwebnet.it ([85.18.95.71])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <insomniac@slackware.it>) id 1Jbdvz-00073h-G7
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 16:41:06 +0100
Date: Tue, 18 Mar 2008 16:38:12 +0100
From: insomniac <insomniac@slackware.it>
To: Antti Palosaari <crope@iki.fi>
Message-ID: <20080318163812.343b0a87@slackware.it>
In-Reply-To: <47DFDCC4.4090001@iki.fi>
References: <ea4209750803180734m67c0990byabb81bb2ec52d992@mail.gmail.com>
	<47DFDCC4.4090001@iki.fi>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dib7770 tunner
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

On Tue, 18 Mar 2008 17:16:20 +0200
Antti Palosaari <crope@iki.fi> wrote:

> dib7770 is 3 in 1 solution, usb-bridge + demodulator + tuner. You can 
> try dib7070 tuner driver. STK7070P looks rather similar (but less 
> integrated).

If I'm not wrong, after taking a look at the sources, dib7070 tuner
driver is located into dvb_usb_dib0700.ko module. Well, it's actually
loaded, but tuner still doesn't work.
Anyway, dmesg says that the kernel tries to load mt2060 module, but
that it fails:

DVB: registering frontend 0 (DiBcom 7000PC)...
mt2060 I2C read failed

So.. was I wrong? How can I force to use dib7070 tuner driver as you
just suggested? Sorry for dumb questions, but I have a DVB card since
5 days.

Thanks,
-- 
Andrea Barberio

a.barberio@oltrelinux.com - Linux&C.
andrea.barberio@slackware.it - Slackware Linux Project Italia
GPG key on http://insomniac.slackware.it/gpgkey.asc
2818 A961 D6D8 1A8C 6E84  6181 5FA6 03B2 E68A 0B7D
SIP: 5327786, Phone: 06 916503784

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
