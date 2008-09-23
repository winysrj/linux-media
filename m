Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KiAkZ-0003oP-57
	for linux-dvb@linuxtv.org; Tue, 23 Sep 2008 18:28:31 +0200
Date: Tue, 23 Sep 2008 18:27:57 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <200809221201.26115.hftom@free.fr>
Message-ID: <20080923162757.282370@gmx.net>
MIME-Version: 1.0
References: <200809211905.34424.hftom@free.fr> <20080921235429.18440@gmx.net>
	<200809221201.26115.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>, linux-dvb@linuxtv.org
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

> > >
> > > Hi Steve,
> > >
> > > I've managed to add S2 support to kaffeine, so it can scan and zap.
> > > However, i have a little problem with DVB-S:
> > > Before tuning to S2, S channels tune well with QAM_AUTO.
> > > But after having tuned to S2 channels, i can no more lock on S ones
> until
> > > i
> > > set modulation to QPSK insteed of QAM_AUTO for these S channels.
> > > Is this known?
> > >
> > > --
> > > Christophe Thommeret
> >
> > Hi Christophe,
...
> =

> > I'd be very happy to try out your patch for Kaffeine and give feedback
> if
> > you are ready to share it.
> =

> Sure, here it is (patch against current svn =

> http://websvn.kde.org/branches/extragear/kde3/multimedia/)
> =

> Atm, s2api is only used for S/S2.
> =

> P.S.
> In order to play H264/HD with kaffeine/xine, you need a fairly recent
> ffmpeg =

> and xine compiled with --with-external-ffmpeg configure option. (and of =

> course a quite strong cpu, unlike my old athlon-xp-2600 :)
> However, you can still record and/or broadcast without this update.

Success! Many thanks Christophe.

With the following:
HVR4000 card
S2API + multifrontend patch (hg clone http://linuxtv.org/hg/~stoth/s2-mfe)
ffmpeg from SVN
xine-lib from mercurial (compiled with --with-external-ffmpeg)
Kaffeine from SVN + Christophe's S2API patch

Scanning to find channels and tuning are working in Kaffeine for  DVB-T, DV=
B-S and DVB-S2.
S/S2 tuning and scanning is with S2API.

My CPU (3ghz core 2 quad) is fast enough to show live HD video so I can wat=
ch HD channels
live inside Kaffeine, or record to disk and watch afterwards. ASTRA HD+ and=
 ANIXE HD are
good. ARTE HD throws some errors and stutters a bit. Simul HD can crash Kaf=
feine.

I enabled the two lines in dvbstream.cpp which set modulation to QPSK inste=
ad of
QAM_AUTO for DVB-S.

Settings: number of xine threads >=3D 4, de-interlacing(CTRL-I) at minimum =
(is it useful for HD ?
I don't know). The load isn't always distributed well across the 4 cpus -- =
it can max out one
of them sometimes, with the others almost idle. Perhaps this can be improve=
d.

Regards,
Hans

-- =

Release early, release often.

Psssst! Schon vom neuen GMX MultiMessenger geh=F6rt? Der kann`s mit allen: =
http://www.gmx.net/de/go/multimessenger

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
