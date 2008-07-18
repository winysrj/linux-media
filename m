Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n32.bullet.mail.ukl.yahoo.com ([87.248.110.149])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1KKkmF-0007T2-53
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 04:05:28 +0200
Date: Fri, 18 Jul 2008 08:04:43 -0400
From: manu <eallaud@yahoo.fr>
To: linux-dvb@linuxtv.org
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<487F3365.4070306@chaosmedia.org>
	<3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
	<20080718112256.6da5bdf9@bk.ru>
In-Reply-To: <20080718112256.6da5bdf9@bk.ru> (from goga777@bk.ru on Fri Jul
	18 03:22:56 2008)
Message-Id: <1216382683l.8087l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  szap - p - r options (was - T S2-3200 driver)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Le 18.07.2008 03:22:56, Goga777 a =E9crit=A0:
> > > with szap2 you also can tune to FTA channels using the option "-
> p"
> and read
> > > the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with
> mplayer for
> > > example..
> =

> =

> btw, could someone explain me what's difference between szap - r and
> szap - p options ?
> =

> when should I use -r options. when - p or both -r -p ???
> =

>   -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
>   -p        : add pat and pmt to TS recording (implies -r)

I would guess that -r will just enable the dvr0 output so that you can =

record it by dumping it to a file, whereas -p will do the same plus pat =

and pmt which means that the stream will contain the necessary tables =

to select one of the channels (this pis probably needed by the app that =

will record/play the stream).
IOn brief try both and see whihc one works ;-)
HTH
Bye
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
