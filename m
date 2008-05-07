Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hyatt.suomi.net ([82.128.152.22])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1Jts1W-0003gc-3y
	for linux-dvb@linuxtv.org; Thu, 08 May 2008 00:22:11 +0200
Received: from tiku.suomi.net ([82.128.154.67])
	by hyatt.suomi.net (Sun Java System Messaging Server 6.2-3.04 (built
	Jul 15 2005)) with ESMTP id <0K0I00AQ0RFVEKB0@hyatt.suomi.net> for
	linux-dvb@linuxtv.org; Thu, 08 May 2008 01:21:31 +0300 (EEST)
Received: from spam2.suomi.net (spam2.suomi.net [212.50.131.166])
	by mailstore.suomi.net
	(Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007;
	32bit)) with ESMTP id <0K0I00KMTRFVLO70@mailstore.suomi.net> for
	linux-dvb@linuxtv.org; Thu, 08 May 2008 01:21:31 +0300 (EEST)
Date: Thu, 08 May 2008 01:21:08 +0300
From: Antti Palosaari <crope@iki.fi>
In-reply-to: <4821F9A9.6030304@ncircle.nullnet.fi>
To: Tomi Orava <tomimo@ncircle.nullnet.fi>
Message-id: <48222B54.3030601@iki.fi>
MIME-version: 1.0
References: <43276.192.168.9.10.1192357983.squirrel@ncircle.nullnet.fi>
	<20071018181040.GA6960@dose.home.local>
	<20071018182940.GA7317@dose.home.local>
	<20071018201418.GA16574@dose.home.local>
	<47075.192.168.9.10.1193248379.squirrel@ncircle.nullnet.fi>
	<472A0CC2.8040509@free.fr> <480F9062.6000700@free.fr>
	<16781.192.100.124.220.1209712634.squirrel@ncircle.nullnet.fi>
	<481B4A78.8090305@free.fr>
	<30354.192.100.124.220.1209969477.squirrel@ncircle.nullnet.fi>
	<481F66B0.4090302@free.fr> <4821F9A9.6030304@ncircle.nullnet.fi>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Testers wanted for alternative version of Terratec
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

hello Tomi
I looked through your driver and here is some comments raised up.

- why cinergyt2_cmd, why not dvb_usb_generic_rw ?
- USB IDs are usually defined in own file dvb-usb-ids.h
- remote control code seems quite complex and long, maybe there is 
easier way?

regards
Antti
-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
