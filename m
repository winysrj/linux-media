Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.kapsi.fi ([217.30.184.167] ident=Debian-exim)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <crope@iki.fi>) id 1KEMie-0005Ja-CY
	for linux-dvb@linuxtv.org; Thu, 03 Jul 2008 13:11:21 +0200
Message-ID: <486CB3D2.3000702@iki.fi>
Date: Thu, 03 Jul 2008 14:11:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Alistair M <tlli@hotmail.com>
References: <BAY136-W51AE9A3EF97CBB5CEA6E0ED29E0@phx.gbl>	<486B3617.3070702@iki.fi>
	<BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
In-Reply-To: <BAY136-W33BDD7C9C5D3A806143D41D2980@phx.gbl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Leadtek WinFast DTV Dongle Gold Remote issues
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

Alistair M wrote:
> Hello Antii,
> 
> I've attached the usb snoop. I hope I did it correctly.

It was correct :)

I added IR-code table to the driver. Now we should find correct keys for 
those codes.
1) install driver from http://linuxtv.org/hg/~anttip/af9015-new/ (make & 
make install; make rmmod; tail -100f /var/log/messages)
2) it should print remote codes to the message log when you press remote 
keys. Write down which key gives which code.

Here is example what it should output to the message-log when key is 
pressed;
af9015_rc_query: 00 00 1e 00 00 00 00 00
af9015_rc_query: 00 00 1f 00 00 00 00 00
af9015_rc_query: 00 00 20 00 00 00 00 00
af9015_rc_query: 00 00 21 00 00 00 00 00

report like:
number 1 = af9015_rc_query: 00 00 1f 00 00 00 00 00
channel up = af9015_rc_query: 00 00 1f 00 00 00 00 00
volume down = af9015_rc_query: 00 00 20 00 00 00 00 00

> Thank you so much for this.
> 
> Regards,
> Alistair.

regards
Antti

-- 
http://palosaari.fi/

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
