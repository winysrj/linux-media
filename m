Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from susik.kapsa.cz ([212.24.154.100])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomasb@kapsa.cz>) id 1KIIM7-0004ls-2t
	for linux-dvb@linuxtv.org; Mon, 14 Jul 2008 09:20:19 +0200
Received: from localhost (localhost [127.0.0.1])
	by susik.kapsa.cz (Postfix) with ESMTP id BA0AB6036
	for <linux-dvb@linuxtv.org>; Mon, 14 Jul 2008 09:20:15 +0200 (CEST)
Date: Mon, 14 Jul 2008 09:20:15 +0200 (CEST)
From: Tomas Blaha <tomasb@kapsa.cz>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.1.1216017558.829.linux-dvb@linuxtv.org>
Message-ID: <Pine.LNX.4.61.0807140906410.18200@susik.kapsa.cz>
References: <mailman.1.1216017558.829.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="416572570-879104232-1216020015=:18200"
Subject: Re: [linux-dvb] Scan issues on Pinnacle 2001e DAUL Diversity
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

--416572570-879104232-1216020015=:18200
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Mon, 14 Jul 2008 linux-dvb-request@linuxtv.org wrote:

> I am working on DVB-T for the first time. I am using a Pinnacle PCTV 2001=
e
> USB DVB-T dongle.In that the device dri vers are getting registered and t=
he
> device is getting detected.I am using a 2.6.23.15 kernel.
>=20
> [...]
>=20
> But, after that when i am trying to run any scan application , it is show=
ing
> "scan failed".
>=20
> the dmesg after running scan application is,
>=20
> [...]
>
> >>> tune to:
> 474166000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_AUTO:QAM_64:TRANSMIS=
SION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
> WARNING: >>> tuning failed!!!
>
> [...]
>=20
> Can Anyone Please tell me if you have faced a similar problem or what is
> happening ?
> Do i have to add something to the kernel?

Hello,

I have the same tuner and this output is what I have, when there is a low=
=20
or none signal. Dvbscan needs a quite good signal to proceed. Try to=20
obtain channels.conf on the internet insteed of scanning, then try to zap=
=20
to some channel and see signal level and error rate from tzap application=
=20
while moving antena around.

I have solved this way my problem with one multiplex, which I couldn't=20
scan for months. I have found, that placing antena horizontally on one=20
place of my window gives me sufficcient signal to receive :-)


--

Tom=C3=A1=C5=A1 Bl=C3=A1ha

e-mail:   tomas.blaha at kapsa.cz
JabberID: tomiiik at jabber.cz
ICQ:      76239430
--416572570-879104232-1216020015=:18200
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--416572570-879104232-1216020015=:18200--
