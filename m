Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp27.orange.fr ([80.12.242.96])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kdn3X-0000hp-Gt
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 16:22:00 +0200
Received: from me-wanadoo.net (localhost [127.0.0.1])
	by mwinf2721.orange.fr (SMTP Server) with ESMTP id 1C1BF1C00091
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 16:21:26 +0200 (CEST)
Received: from stratocaster.lan (ANantes-256-1-171-44.w90-25.abo.wanadoo.fr
	[90.25.242.44])
	by mwinf2721.orange.fr (SMTP Server) with ESMTP id EBCD51C00089
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 16:21:25 +0200 (CEST)
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Thu, 11 Sep 2008 16:21:44 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809111621.44365.hftom@free.fr>
Subject: [linux-dvb] Multiple frontends on a single adapter support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi all,

( Please don't mix this thread with the "DVB-S2 / Multiproto and future =

modulation support" thread (like i did:) )

Summary:

Some devices provide several tuners, even of different types.
So called "Dual" or "Twin" tuners can be used at the same time.
Some others (like HVR4000) can't be used at the same time.

My initial question was: How could an application know that 2 (or more) tun=
ers =

are exclusive (when one is used the other(s) is(are) not free.)

I suggested the following:
Since actually all multiple tuners drivers expose several fontend0 in separ=
ate =

adapters, maybe a solution for exclusive tuners could be to have :
- adapter0/frontend0 -> S/S2 tuner
- adapter0/frontend1 -> T tuner
so, an application could assume that these tuners are exclusive.

Janne Grunau acked the idea and said that an experimental driver for HVR400=
0 =

is already doing this.

This was confirmed by Steven Toth:
"Correct, frontend1, demux1, dvr1 etc. All on the same adapter. The =

driver and multi-frontend patches manage exclusive access to the single =

internal resource."
=A0=A0=A0=A0=A0=A0=A0=A0
Andreas Oberritter said:
"This way is used on dual and quad tuner Dreambox models." (non exclusive =

tuners).
"How about dropping demux1 and dvr1 for this adapter (exclusive tuners), si=
nce =

they don't create any benefit? IMHO the number of demux devices should alwa=
ys =

equal the number of simultaneously usable transport stream inputs."

Uri Shkolnik said:
"Some of the hardware devices which using our chipset have two tuners per =

instance, and should expose 1-2 tuners with 0-2 demux (TS), since not all D=
TV =

standard are TS based, and when they are (TS based), it depends when you ar=
e =

using two given tuners together (diversity =A0mode, same content) or each o=
ne =

is used separately (different frequency and modulation, different content, =

etc.)."



So, here are my questions:

@Steven Toth:
What do you think of Andreas' suggestion? Do you think it could be done tha=
t =

way for HVR4000 (and 3000?) ?

@Uri Shkolnik:
Do you mean that non-TS based standards don't make use of multiplexing at a=
ll?

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
