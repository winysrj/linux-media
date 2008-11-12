Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L0F1N-0005XV-1m
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 13:40:34 +0100
Date: Wed, 12 Nov 2008 13:39:59 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
Message-ID: <20081112123959.217200@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net>
	<c74595dc0811120243m4819b86bk84a5d23c8e00e467@mail.gmail.com>
To: "Alex Betis" <alex.betis@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] scan-s2: fixes and diseqc rotor support
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

> On Wed, Nov 12, 2008 at 4:31 AM, Hans Werner <HWerner4@gmx.de> wrote:
> =

> > I have attached two patches for scan-s2 at
> > http://mercurial.intuxication.org/hg/scan-s2.
> >
> > Patch1: Some fixes for problems I found. QAM_AUTO is not supported by
> all
> > drivers,
> > in particular the HVR-4000, so one needs to use QPSK as the default and
> > ensure that
> > settings are parsed properly from the network information -- the new S2
> > FECs and
> > modulations were not handled.
> >
> > Patch2: Add DiSEqC 1.2 rotor support. Use it like this to move the dish
> to
> > the correct
> > position for the scan:
> >  scan-s2 -r 19.2E -n dvb-s/Astra-19.2E
> >  or
> >  scan-s2 -R 2 -n dvb-s/Astra-19.2E
> >
> > A file (rotor.conf) listing the rotor positions is used (NB: rotors vary
> --
> > do check your
> > rotor manual).
> >
> =

> I didn't check the diff files yet, will do it when I get home.
> But I don't think QPSK should be used by default. I have a version already
> where you can specify which scan mode you want to be performed DVB-S or
> DVB-S2 by specifying S1 or S2 in freq file, also if you implicitly specify
> QPSK in frequency file the utility will not scan DVB-S2, same logic also
> for
> 8PSK that will scan only DVB-S2 and will not try to scan DVB-S.
> I'll push that version soon to the repository.
> =

> The default should stay the AUTO mode since there are cards that can
> handle
> that and their owners might have simplified frequency file version.

Perhaps I wasn't clear: I don't force scanning to be QPSK only. With just t=
he
following one line in dvb-s/Astra-19.2E I was able to scan DVB-S and DVB-S2
(both QPSK and 8PSK) channels in one command with the HVR-4000:
S 12551500 V 22000000 5/6

The point is that some drivers and hardware (e.g. HVR-4000) cannot handle Q=
AM_AUTO
or FEC_AUTO and will generate errors, but the necessary transponder informa=
tion *is*
available to be parsed and used, so scan-s2 should do that. =


We need scan-s2 do the best possible scan in one command with the standard =
initial
transponder files for all cards. You can't assume the hardware has AUTO cap=
abilities.
Perhaps the capabilities could be checked before the scan though and used i=
f available.

Hans

-- =

Release early, release often.

GMX Download-Spiele: Preizsturz! Alle Puzzle-Spiele Deluxe =FCber 60% billi=
ger.
http://games.entertainment.gmx.net/de/entertainment/games/download/puzzle/i=
ndex.html

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
