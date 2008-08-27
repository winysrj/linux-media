Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1KYRrT-0003NN-1j
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 22:43:28 +0200
Date: Wed, 27 Aug 2008 22:42:50 +0200
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <412393.34790.qm@web46101.mail.sp1.yahoo.com>
Message-ID: <20080827204250.271660@gmx.net>
MIME-Version: 1.0
References: <412393.34790.qm@web46101.mail.sp1.yahoo.com>
To: free_beer_for_all@yahoo.com, goga777@bk.ru, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR 4000 recomneded driver and firmware for
	VDR	1.7.0
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

Barry, thanks for your messge. You didn't say whether you tried what
I did with HVR4000+liplianindvb+szap2 (-p option). =


Before we talk about mplayer, does it actually work for you?

> Which version  of `mplayer'?
> =

> You probably know, but it bears repeating:  mplayer is a
> moving target, and significant features are added regularly. =


Yes, I know. People around here could learn a lot from the way mplayer
and ffmpeg each continue to check in significant and rapid improvements to a
single repository.

I regularly update mplayer from SVN and recompile too.  I have tried the fo=
llowing:

MPlayer dev-SVN-r27489-4.1.2  (today!): runs but video very slow and out of=
 sync, audio ok.
MPlayer dev-SVN-r27341-4.1.2  (about 1 month old): crashes in <1s
MPlayer 1.0rc2-4.2.3 (ubuntu hardy): crashes in <1s
xine-lib 1.1.15, xine-ui 0.99.5 (latest): No video, but audio ok.

The log I showed was from Mplayer SVN 27341, but 27489 is similar: lots and=
 lots of =

"number of reference frames exceeds max" errors.
 =

> > Starting playback...
> > [h264 @ 0xbc0b40]number of reference frames exceeds max
> > (probably corrupt input), discarding one
> > [h264 @ 0xbc0b40]number of reference frames exceeds max
> > (probably corrupt input), discarding one
> > [h264 @ 0xbc0b40]number of reference frames exceeds max
> > (probably corrupt input), discarding one
> > [h264 @ 0xbc0b40]number of reference frames exceeds max
> > (probably corrupt input), discarding one

And I have some sample TS files for Astra HD+ made with another card which =
all the
mplayers play perfectly so I know h264 is working.

So at this point I do not think the problem is mplayer.

Hans
-- =

Release early, release often.

Psssst! Schon das coole Video vom GMX MultiMessenger gesehen?
Der Eine f=FCr Alle: http://www.gmx.net/de/go/messenger03

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
