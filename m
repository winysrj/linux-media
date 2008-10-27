Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Bitte_antworten@will-hier-weg.de>)
	id 1KuSg9-0003O2-By
	for linux-dvb@linuxtv.org; Mon, 27 Oct 2008 15:02:46 +0100
Date: Mon, 27 Oct 2008 15:02:11 +0100
From: Bitte_antworten@will-hier-weg.de
In-Reply-To: <200810251712.00078.dkuhlen@gmx.net>
Message-ID: <20081027140211.168320@gmx.net>
MIME-Version: 1.0
References: <20081025141920.87960@gmx.net> <200810251712.00078.dkuhlen@gmx.net>
To: Dominik Kuhlen <dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cinergyT2 renamed drivers (was Re: stb0899 drivers)
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

Thanks Dominik, I found it out yesterday. The CinergyT2 is working fine now=
, but it is nearly impossible to use the PCTV452e with (an unmodified) kaff=
eine. It simply doesn't lock in more than 90% of my tests. The only channel=
 that works sometimes is "Das Erste" and the lock takes appr. 1 minute.
So I reverted to multiproto again which works fine (except "NDR")
Dirk
-------- Original-Nachricht --------
> Datum: Sat, 25 Oct 2008 17:11:59 +0200
> Von: Dominik Kuhlen <dkuhlen@gmx.net>
> An: linux-dvb@linuxtv.org
> Betreff: [linux-dvb] cinergyT2 renamed drivers (was Re:  stb0899 drivers)

> Hi,
> On Saturday 25 October 2008, Bitte_antworten@will-hier-weg.de wrote:
> > Hi Igor,
> > =

> > I tried your tree with my Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and
> it works with the modified szap.
> > Unfortunately my Terratec CinergyT2 doesn't work anymore. I can't load
> the modul because of many undefined symbols. So I reverted everything to
> multiproto and both devices are working again. What should I do? =

> the module name has changed to
> dvb-usb-cinergyT2
> =

> > Thanks =

> > Dirk
> > =

> ---snip---
> =

> =

> Dominik

-- =

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
