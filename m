Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KiV30-0007Ki-I8
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 16:08:56 +0200
Date: Wed, 24 Sep 2008 16:08:21 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <200809241538.51217.hftom@free.fr>
Message-ID: <20080924140821.40890@gmx.net>
MIME-Version: 1.0
References: <200809211905.34424.hftom@free.fr>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
	<200809241538.51217.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
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



> Le Tuesday 23 September 2008 18:27:57 Hans Werner, vous avez =E9crit :
> =

> > > Sure, here it is (patch against current svn
> > > http://websvn.kde.org/branches/extragear/kde3/multimedia/)
> > >
> > > Atm, s2api is only used for S/S2.
> > >
> > > P.S.
> > > In order to play H264/HD with kaffeine/xine, you need a fairly recent
> > > ffmpeg
> > > and xine compiled with --with-external-ffmpeg configure option. (and
> of
> > > course a quite strong cpu, unlike my old athlon-xp-2600 :)
> > > However, you can still record and/or broadcast without this update.
> >
> > Success! Many thanks Christophe.
> >
> > With the following:
> > HVR4000 card
> > S2API + multifrontend patch (hg clone
> http://linuxtv.org/hg/~stoth/s2-mfe)
> > ffmpeg from SVN
> > xine-lib from mercurial (compiled with --with-external-ffmpeg)
> > Kaffeine from SVN + Christophe's S2API patch
> =

> Good :)
> =

> > Scanning to find channels and tuning are working in Kaffeine for  DVB-T,
> > DVB-S and DVB-S2. S/S2 tuning and scanning is with S2API.
> >
> > My CPU (3ghz core 2 quad) is fast enough to show live HD video so I can
> > watch HD channels live inside Kaffeine,
> =

> Lucky you :)
> =

> > or record to disk and watch =

> > afterwards. ASTRA HD+ and ANIXE HD are good. ARTE HD throws some errors
> and
> > stutters a bit. Simul HD can crash Kaffeine.

Does anyone have any info about Arte HD or Simul HD?
 =

> > I enabled the two lines in dvbstream.cpp which set modulation to QPSK
> > instead of QAM_AUTO for DVB-S.
> =

> So, you see this also. This was my original report, and why i introduced
> this =

> fix.
> =

> > Settings: number of xine threads >=3D 4, de-interlacing(CTRL-I) at mini=
mum
> > (is it useful for HD ?
> =

> Yes for 1080i but not for 720p.
> =

> > I don't know). The load isn't always distributed =

> > well across the 4 cpus -- it can max out one of them sometimes, with the
> > others almost idle. Perhaps this can be improved.
> =

> Perhaps, but this is ffmpeg stuff.

Yes. The multithreaded decoding does spread the load well for some HD chann=
els.

> Btw, while cx24116 single-frontend seems pretty stable, the mfe driver is
> not =

> here. As soon as i switch to dvb-t, the cx24116 firmware crashes (at least
> seems so: ~"Firmware doen't respond .." ) and is reloaded on next S/S2
> zap, =

> and after a while, the dvb-t signal appears more and more noisy. I have to
> unload/reload the modules to cure this.

Oh. I haven't seen any problems like that or heard it reported before.
I am using firmware version 1.23.86.1. Which version are you using?

Regards,
Hans

-- =

Release early, release often.

GMX startet ShortView.de. Hier findest Du Leute mit Deinen Interessen!
Jetzt dabei sein: http://www.shortview.de/wasistshortview.php?mc=3Dsv_ext_m=
f@gmx

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
