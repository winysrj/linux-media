Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from susik.kapsa.cz ([212.24.154.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomasb@kapsa.cz>) id 1KIJGy-0006oo-6c
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 10:19:04 +0200
Received: from localhost (localhost [127.0.0.1])
	by susik.kapsa.cz (Postfix) with ESMTP id 5A8266036
	for <linux-dvb@linuxtv.org>; Mon, 14 Jul 2008 10:19:00 +0200 (CEST)
Date: Mon, 14 Jul 2008 10:19:00 +0200 (CEST)
From: Tomas Blaha <tomasb@kapsa.cz>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.1.1216017558.829.linux-dvb@linuxtv.org>
Message-ID: <Pine.LNX.4.61.0807140928510.18200@susik.kapsa.cz>
References: <mailman.1.1216017558.829.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="416572570-705159505-1216023540=:18200"
Subject: Re: [linux-dvb] Pinnacle PCTV Dual DVB-T Diversity Stick built in
 IR-Receiver supported ?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--416572570-705159505-1216023540=:18200
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hello,

I would like working remote too, but what I see from source code the=20
remote is not supported. There is

   struct dvb_usb_device_properties dib0700_devices[]

in dib0700_devices.c which lists abilities of devices and for this adapter=
=20
and "DiBcom STK7070PD reference design" there is no RC support. I even try=
=20
to enable the support as it is enabled on other devices from the same=20
family, but without luck. Drivers queryed the adapter for a RC keypress=20
afaik correctly, but only zeros were returned from the device.

--

Tom=C3=A1=C5=A1 Bl=C3=A1ha

e-mail:   tomas.blaha at kapsa.cz
JabberID: tomiiik at jabber.cz
ICQ:      76239430
--416572570-705159505-1216023540=:18200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--416572570-705159505-1216023540=:18200--
