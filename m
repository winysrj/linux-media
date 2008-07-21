Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay.chp.ru ([213.170.120.254] helo=ns.chp.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1KKsHE-0005oO-Uq
	for linux-dvb@linuxtv.org; Mon, 21 Jul 2008 12:05:57 +0200
Date: Mon, 21 Jul 2008 14:13:00 +0400
From: Goga777 <goga777@bk.ru>
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20080721141300.2ff0c582@bk.ru>
In-Reply-To: <1216609233.2909.27.camel@pc10.localdom.local>
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<487F3365.4070306@chaosmedia.org>
	<3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
	<20080718112256.6da5bdf9@bk.ru> <1216382683l.8087l.2l@manu-laptop>
	<1216609233.2909.27.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : szap - p - r options (was - T S2-3200 driver)
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

> > > > > with szap2 you also can tune to FTA channels using the option "-
> > > p"
> > > and read
> > > > > the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with
> > > mplayer for
> > > > > example..
> > > 
> > > 
> > > btw, could someone explain me what's difference between szap - r and
> > > szap - p options ?
> > > 
> > > when should I use -r options. when - p or both -r -p ???
> > > 
> > >   -r        : set up /dev/dvb/adapterX/dvr0 for TS recording
> > >   -p        : add pat and pmt to TS recording (implies -r)
> > 
> > I would guess that -r will just enable the dvr0 output so that you can 
> > record it by dumping it to a file, whereas -p will do the same plus pat 
> > and pmt which means that the stream will contain the necessary tables 
> > to select one of the channels (this pis probably needed by the app that 
> > will record/play the stream).
> > IOn brief try both and see whihc one works ;-)
> > HTH
> > Bye
> > Manu
> > 
> > 
> 
> Hi,
> 
> last time I tried -p did not work at all.

how did you recognize it ? what should be happen with - p option ?
did option -r work during you

Goga


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
