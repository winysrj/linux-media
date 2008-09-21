Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KhOAK-0006jZ-24
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 14:35:53 +0200
Message-ID: <39633.85.23.68.42.1222000546.squirrel@webmail.kapsi.fi>
In-Reply-To: <200809210904.28192.dirk_vornheder@yahoo.de>
References: <200809152345.37786.dirk_vornheder@yahoo.de>
	<200809201953.39006.dirk_vornheder@yahoo.de> <48D53B37.6020001@iki.fi>
	<200809210904.28192.dirk_vornheder@yahoo.de>
Date: Sun, 21 Sep 2008 15:35:46 +0300 (EEST)
From: "Antti Palosaari" <crope@iki.fi>
To: "Dirk Vornheder" <dirk_vornheder@yahoo.de>
MIME-Version: 1.0
Cc: Antti Palosaari <crope@iki.fi>, linux-dvb@linuxtv.org
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

su 21.9.2008 10:04 Dirk Vornheder kirjoitti:
> Sep 21 08:17:51 lappc kernel: dvb-usb: found a 'AVerMedia DVB-T' in cold
> state, will try to load a firmware
> Sep 21 08:17:51 lappc kernel: firmware: requesting dvb-usb-af9015.fw
> Sep 21 08:17:51 lappc kernel: dvb-usb: downloading firmware from file
> 'dvb-
> usb-af9015.fw'
> Sep 21 08:17:51 lappc kernel: usbcore: registered new interface driver
> dvb_usb_af9015
>
> But i found no device entries in /dev/dvb.
>
> Dirk

Markus Ranne reported this working, see couple of mails back on the list.

But anyhow, looks like you has problem that firmware does not run.
Re-download and install firmware. Hopefully it helps.

regards
Antti


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
