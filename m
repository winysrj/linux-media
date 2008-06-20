Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1K9nzV-00005y-CW
	for linux-dvb@linuxtv.org; Fri, 20 Jun 2008 23:17:55 +0200
Message-ID: <485C1E73.7030509@ncircle.nullnet.fi>
Date: Sat, 21 Jun 2008 00:17:39 +0300
From: Tomi Orava <tomimo@ncircle.nullnet.fi>
MIME-Version: 1.0
To: Thierry Merle <thierry.merle@free.fr>
References: <472A0CC2.8040509@free.fr>
	<480F9062.6000700@free.fr>	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>	<481B4A78.8090305@free.fr>	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>	<481F66B0.4090302@free.fr>
	<4821F9A9.6030304@ncircle.nullnet.fi>	<48236E1F.5080300@free.fr>	<60450.192.168.9.10.1210618180.squirrel@ncircle.nullnet.fi>	<Pine.LNX.4.64.0805122100590.7907@pub3.ifh.de>
	<20080616152430.GA9995@dose.home.local> <485C0886.5070606@free.fr>
In-Reply-To: <485C0886.5070606@free.fr>
Cc: Tino Keitel <tino.keitel@tikei.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of	Terratec
 Cinergy T2 driver
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

> To follow easily the state of this patch and keep track on it, I put it
> in a hg repo:
> http://linuxtv.org/hg/~tmerle/cinergyT2
> And to sum-up, 3 issues:
> - possible lirc issue
>     http://article.gmane.org/gmane.linux.drivers.dvb/37865
>    But I am not sure this is a problem, just a lack in lirc conf.

Since that time the "internal" remote control code has been removed
and the driver now uses the common dvb-usb-rc code.
This should not be a problem anymore, but needs to be verified.

> - possible dvb-t tuning issue
>     http://article.gmane.org/gmane.linux.drivers.dvb/41632
>    To be confirmed

I have requested more test data from the reporter a month ago ...

> - rmmod: driver count is not well managed, dvb-usb framework issue
>    This prevents the ability to remove drivers that do not support
> suspend before passing in suspend mode.

Regards,
Tomi Orava

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
