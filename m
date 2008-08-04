Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <markus.o.hahn@gmx.de>) id 1KQ1yJ-0001cP-Bt
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 17:27:45 +0200
Date: Mon, 04 Aug 2008 17:27:10 +0200
From: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
Message-ID: <20080804152710.70780@gmx.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fwd: Re: How to fix ioctl DVBFE_GET_INFO failed error?
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

-------- Original-Nachricht --------
Datum: Mon, 04 Aug 2008 17:24:40 +0200
Von: "Markus Oliver Hahn" <markus.o.hahn@gmx.de>
An: sacha <sacha@hemmail.se>
Betreff: Re: [linux-dvb] How to fix ioctl DVBFE_GET_INFO failed error?

yes it is a shame,  this half-way new frontend mess. =


You have to use oldstyle fe_status_t =

I`m on the way to rewrite scan  without this pity #ifdef VERSIONS =

But I belive there`s a lot to do with this multiproto drivers =


regards  markus =




-------- Original-Nachricht --------
> Datum: Fri, 01 Aug 2008 11:10:35 +0200
> Von: sacha <sacha@hemmail.se>
> An: linux-dvb@linuxtv.org
> Betreff: [linux-dvb] How to fix ioctl DVBFE_GET_INFO failed error?

> Hello
> =

> I am struggling with my Twinhan1041 card for a while now. I am on my way
> to give up.
> I hope someone give me a last chance.
> =

> I have this error when I try to scan "ioctl DVBFE_GET_INFO failed"
> =

> How to fix it? =

> Is there the most up to date instructions for this card somewhere?
> =

> KR
> =

> =

> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

-- =

GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/wasistshortview.php?mc=3Dsv_ext_m=
f@gmx

-- =

GMX Kostenlose Spiele: Einfach online spielen und Spa=DF haben mit Pastry P=
assion!
http://games.entertainment.gmx.net/de/entertainment/games/free/puzzle/61691=
96

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
