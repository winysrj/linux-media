Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <HWerner4@gmx.de>) id 1L0GKU-0003wg-GD
	for linux-dvb@linuxtv.org; Wed, 12 Nov 2008 15:04:23 +0100
Date: Wed, 12 Nov 2008 15:03:47 +0100
From: "Hans Werner" <HWerner4@gmx.de>
In-Reply-To: <200811121404.26185.hftom@free.fr>
Message-ID: <20081112140347.217190@gmx.net>
MIME-Version: 1.0
References: <20081112023112.94740@gmx.net> <200811121353.47705.hftom@free.fr>
	<c74595dc0811120501h36c129a2wf85202263274c453@mail.gmail.com>
	<200811121404.26185.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>, alex.betis@gmail.com
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

> Le mercredi 12 novembre 2008 14:01:11 Alex Betis, vous avez =E9crit :
> > On Wed, Nov 12, 2008 at 2:53 PM, Christophe Thommeret <hftom@free.fr>
> wrote:
> > > > BTW, you give here example of NIT parsing, do you know the format of
> > > > the message and what field specifies that the delivery system is
> > > > DVB-S2? scan utility code doesn't parse it, so I just add both DVB-S
> > > > and DVB-S2 scans for newly added transponder from NITmessage.
> > >
> > > It's specified in Satellite Descriptor:
> > > modulation_system=3D=3D1, =3D>S2
> > > modulation_system=3D=3D0, =3D>S
> >
> > Thanks, but it doesn't help in my case.
> > NIT can specify new transponders, when adding them to the scan list I
> have
> > to know whenever they are DVB-S or DVB-S2.
> > Satellte descriptor is received after locking to the transponder.
> =

> The satellite descriptor is part of NIT.
> See EN-300468

Also look at the Kaffeine code + S2 patch as I did when writing my patches.
Many thanks Christophe.

-- =

Release early, release often.

"Feel free" - 5 GB Mailbox, 50 FreeSMS/Monat ...
Jetzt GMX ProMail testen: http://www.gmx.net/de/go/promail

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
