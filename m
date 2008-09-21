Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n30.bullet.mail.ukl.yahoo.com ([87.248.110.147])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <dirk_vornheder@yahoo.de>) id 1KhJ0A-00064g-SJ
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 09:05:07 +0200
From: Dirk Vornheder <dirk_vornheder@yahoo.de>
To: Antti Palosaari <crope@iki.fi>,
 linux-dvb@linuxtv.org
Date: Sun, 21 Sep 2008 09:04:27 +0200
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<200809201953.39006.dirk_vornheder@yahoo.de>
	<48D53B37.6020001@iki.fi> (sfid-20080920_200615_807989_643FFC56)
In-Reply-To: <48D53B37.6020001@iki.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809210904.28192.dirk_vornheder@yahoo.de>
Subject: Re: [linux-dvb] New unspported device AVerMedia DVB-T
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


> >>
> >> Looks like tuner is not identified. Could you load af9015 with some
> >> debugging enabled to see more information?
> >>
> >> 1) remove all dvb-modules "make rmmod"
> >> 2) load af9015 with debug enabled "modprobe dvb-usb-af9015 debug=3"
> >>
> >> after that there should be more information in message-log.
> >
> > Sep 20 19:51:13 lappc kernel: af9015: command failed:255
> > Sep 20 19:51:13 lappc kernel: af9015: eeprom read failed:-1
> > Sep 20 19:51:13 lappc kernel: dvb_usb_af9015: probe of 3-3:1.0 failed
> > with error -1
> > Sep 20 19:51:13 lappc kernel: usbcore: registered new interface driver
> > dvb_usb_af9015
>
> hmm, now it even fails to read eeprom :( I have no idea why. Could you
> try to poweroff and do cold start to see if it loads driver properly
> then...
>
> Antti

Sep 21 08:17:51 lappc kernel: dvb-usb: found a 'AVerMedia DVB-T' in cold 
state, will try to load a firmware
Sep 21 08:17:51 lappc kernel: firmware: requesting dvb-usb-af9015.fw
Sep 21 08:17:51 lappc kernel: dvb-usb: downloading firmware from file 'dvb-
usb-af9015.fw'
Sep 21 08:17:51 lappc kernel: usbcore: registered new interface driver 
dvb_usb_af9015

But i found no device entries in /dev/dvb.

Dirk

		
___________________________________________________________ 
Telefonate ohne weitere Kosten vom PC zum PC: http://messenger.yahoo.de


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
